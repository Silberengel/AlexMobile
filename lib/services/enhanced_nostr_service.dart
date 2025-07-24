import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/nostr_event.dart';
import '../repositories/event_repository.dart';
import 'network_service.dart';

class EnhancedNostrService {
  static const List<String> _relays = [
    'wss://thecitadel.nostr1.com',
    'wss://profiles.nostr1.com',
  ];
  
  static const List<int> _publicationKinds = [30040, 30041, 30023, 30818];
  static const int _profileKind = 0;
  
  final EventRepository _eventRepository;
  final NetworkService _networkService;
  final Map<String, WebSocketChannel?> _connections = {};
  
  Timer? _adaptiveSyncTimer;
  Timer? _profileSyncTimer;
  bool _initialized = false;
  StreamSubscription<NetworkState>? _networkStateSubscription;
  
  EnhancedNostrService(this._eventRepository, this._networkService);
  
  /// Initialize with adaptive sync
  Future<void> initialize() async {
    if (_initialized) return;
    
    // Initialize network monitoring
    await _networkService.initialize();
    
    // Listen to network state changes
    _networkStateSubscription = _networkService.networkStateStream.listen(_onNetworkStateChanged);
    
    // Connect to relays if online
    if (_networkService.shouldPerformSync()) {
      await _connectToRelays();
    }
    
    // Start adaptive sync
    await _startAdaptiveSync();
    
    // Start profile sync (more frequent)
    _startProfileSync();
    
    _initialized = true;
  }
  
  /// Handle network state changes
  void _onNetworkStateChanged(NetworkState state) {
    print('Network state changed to: $state');
    
    switch (state) {
      case NetworkState.offline:
        _pauseSync();
        break;
      case NetworkState.online:
      case NetworkState.lowBandwidth:
      case NetworkState.highBandwidth:
        _resumeSync();
        _updateSyncInterval();
        break;
    }
  }
  
  /// Connect to all configured relays
  Future<void> _connectToRelays() async {
    for (final relay in _relays) {
      try {
        final channel = WebSocketChannel.connect(Uri.parse(relay));
        _connections[relay] = channel;
        
        // Subscribe to events with adaptive batch size
        await _subscribeToEvents(channel, relay);
        
        // Listen for incoming events
        channel.stream.listen(
          (data) => _handleIncomingEvent(data, relay),
          onError: (error) => _handleConnectionError(relay, error),
          onDone: () => _handleConnectionClosed(relay),
        );
        
        print('Connected to relay: $relay');
      } catch (e) {
        print('Failed to connect to relay $relay: $e');
      }
    }
  }
  
  /// Subscribe to events with adaptive batch size
  Future<void> _subscribeToEvents(WebSocketChannel channel, String relay) async {
    final subscriptionId = _generateSubscriptionId();
    final batchSize = _networkService.getRecommendedBatchSize();
    
    // Subscribe to publications
    final publicationFilter = {
      'kinds': _publicationKinds,
      'limit': batchSize,
    };
    
    // Subscribe to profiles with higher priority
    final profileFilter = {
      'kinds': [_profileKind],
      'limit': batchSize * 2, // More profiles to keep cache fresh
    };
    
    final subscription = {
      'id': subscriptionId,
      'method': 'REQ',
      'params': [subscriptionId, publicationFilter, profileFilter],
    };
    
    channel.sink.add(jsonEncode(subscription));
  }
  
  /// Handle incoming events from relays
  Future<void> _handleIncomingEvent(dynamic data, String relay) async {
    try {
      final List<dynamic> message = jsonDecode(data);
      
      if (message.length >= 3 && message[0] == 'EVENT') {
        final eventData = message[2];
        final event = NostrEvent.fromJson(eventData);
        event.relayUrl = relay;
        event.lastSynced = DateTime.now();
        
        // Use special handling for profiles
        if (event.kind == 0) {
          await _eventRepository.saveProfile(event);
        } else {
          await _eventRepository.saveEvent(event);
        }
      }
    } catch (e) {
      print('Error handling incoming event: $e');
    }
  }
  
  /// Start adaptive synchronization
  Future<void> _startAdaptiveSync() async {
    // Initial sync if online
    if (_networkService.shouldPerformSync()) {
      await _performSync();
    }
    
    // Set up adaptive sync timer
    _updateSyncInterval();
  }
  
  /// Start profile-specific sync (more frequent)
  void _startProfileSync() {
    // Profile sync every 5 minutes regardless of network state
    _profileSyncTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (_networkService.shouldPerformSync()) {
        _performProfileSync();
      }
    });
  }
  
  /// Perform profile-specific sync
  Future<void> _performProfileSync() async {
    print('Starting profile sync...');
    
    // Get stale profiles that need refreshing
    final staleProfiles = await _eventRepository.getStaleProfiles(limit: 20);
    
    if (staleProfiles.isNotEmpty) {
      print('Found ${staleProfiles.length} stale profiles to refresh');
      
      for (final relay in _relays) {
        try {
          final channel = _connections[relay];
          if (channel != null) {
            await _requestProfiles(channel, relay, staleProfiles);
          }
        } catch (e) {
          print('Error syncing profiles with relay $relay: $e');
        }
      }
    }
  }
  
  /// Request specific profiles from relay
  Future<void> _requestProfiles(WebSocketChannel channel, String relay, List<NostrEvent> profiles) async {
    final subscriptionId = _generateSubscriptionId();
    
    // Request specific profiles by pubkey
    final pubkeys = profiles.map((p) => p.pubkey).toList();
    
    final filter = {
      'kinds': [_profileKind],
      'authors': pubkeys,
      'limit': pubkeys.length,
    };
    
    final subscription = {
      'id': subscriptionId,
      'method': 'REQ',
      'params': [subscriptionId, filter],
    };
    
    channel.sink.add(jsonEncode(subscription));
  }
  
  /// Update sync interval based on network state
  void _updateSyncInterval() {
    _adaptiveSyncTimer?.cancel();
    
    final interval = _networkService.getRecommendedSyncInterval();
    print('Setting sync interval to: ${interval.inMinutes} minutes');
    
    _adaptiveSyncTimer = Timer.periodic(interval, (timer) {
      if (_networkService.shouldPerformSync()) {
        _performSync();
      }
    });
  }
  
  /// Perform synchronization with adaptive behavior
  Future<void> _performSync() async {
    if (!_networkService.shouldPerformSync()) {
      print('Skipping sync - offline');
      return;
    }
    
    print('Starting adaptive sync...');
    print('Network state: ${_networkService.currentState}');
    print('Bandwidth: ${_networkService.currentBandwidth.toStringAsFixed(2)} Mbps');
    
    for (final relay in _relays) {
      try {
        final channel = _connections[relay];
        if (channel != null) {
          await _requestEvents(channel, relay);
        }
      } catch (e) {
        print('Error syncing with relay $relay: $e');
      }
    }
  }
  
  /// Request events with adaptive parameters
  Future<void> _requestEvents(WebSocketChannel channel, String relay) async {
    final subscriptionId = _generateSubscriptionId();
    final batchSize = _networkService.getRecommendedBatchSize();
    
    // Get events since last sync
    final lastSync = await _eventRepository.getLastSyncTime(relay);
    final since = lastSync?.millisecondsSinceEpoch ~/ 1000 ?? 0;
    
    final filter = {
      'kinds': [..._publicationKinds, _profileKind],
      'since': since,
      'limit': batchSize,
    };
    
    final subscription = {
      'id': subscriptionId,
      'method': 'REQ',
      'params': [subscriptionId, filter],
    };
    
    channel.sink.add(jsonEncode(subscription));
  }
  
  /// Pause sync when offline
  void _pauseSync() {
    print('Pausing sync - offline');
    _adaptiveSyncTimer?.cancel();
  }
  
  /// Resume sync when back online
  void _resumeSync() {
    print('Resuming sync - back online');
    _updateSyncInterval();
  }
  
  /// Handle connection errors with adaptive retry
  void _handleConnectionError(String relay, dynamic error) {
    print('Connection error for relay $relay: $error');
    
    // Adaptive retry based on network state
    final retryDelay = _networkService.currentState == NetworkState.lowBandwidth
        ? const Duration(seconds: 30)
        : const Duration(seconds: 5);
    
    Timer(retryDelay, () => _reconnectToRelay(relay));
  }
  
  /// Handle connection closure
  void _handleConnectionClosed(String relay) {
    print('Connection closed for relay $relay');
    _reconnectToRelay(relay);
  }
  
  /// Reconnect to a specific relay
  Future<void> _reconnectToRelay(String relay) async {
    if (!_networkService.shouldPerformSync()) {
      print('Skipping reconnection - offline');
      return;
    }
    
    try {
      await Future.delayed(const Duration(seconds: 5));
      final channel = WebSocketChannel.connect(Uri.parse(relay));
      _connections[relay] = channel;
      
      await _subscribeToEvents(channel, relay);
      
      channel.stream.listen(
        (data) => _handleIncomingEvent(data, relay),
        onError: (error) => _handleConnectionError(relay, error),
        onDone: () => _handleConnectionClosed(relay),
      );
      
      print('Reconnected to relay: $relay');
    } catch (e) {
      print('Failed to reconnect to relay $relay: $e');
    }
  }
  
  /// Generate a unique subscription ID
  String _generateSubscriptionId() {
    return 'sub_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().microsecond % 9000))}';
  }
  
  /// Get sync status with network info
  Map<String, dynamic> getSyncStatus() async {
    final staleProfileCount = await _eventRepository.getStaleProfileCount();
    
    return {
      'isSyncing': _initialized,
      'networkState': _networkService.currentState.toString(),
      'connectionType': _networkService.currentConnectionType.toString(),
      'bandwidth': _networkService.currentBandwidth,
      'syncInterval': _networkService.getRecommendedSyncInterval().inMinutes,
      'batchSize': _networkService.getRecommendedBatchSize(),
      'connectedRelays': _connections.keys.toList(),
      'staleProfiles': staleProfileCount,
    };
  }
  
  /// Close all connections
  Future<void> dispose() async {
    _adaptiveSyncTimer?.cancel();
    _profileSyncTimer?.cancel();
    _networkStateSubscription?.cancel();
    
    for (final channel in _connections.values) {
      channel?.sink.close();
    }
    _connections.clear();
    _initialized = false;
  }
  
  /// Check if local relay is available
  Future<bool> isLocalRelayAvailable() async {
    try {
      final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:4869'));
      await channel.ready;
      channel.sink.close();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Connect to local relay if available
  Future<void> connectToLocalRelay() async {
    if (await isLocalRelayAvailable()) {
      try {
        final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:4869'));
        _connections['ws://localhost:4869'] = channel;
        
        await _subscribeToEvents(channel, 'ws://localhost:4869');
        
        channel.stream.listen(
          (data) => _handleIncomingEvent(data, 'ws://localhost:4869'),
          onError: (error) => _handleConnectionError('ws://localhost:4869', error),
          onDone: () => _handleConnectionClosed('ws://localhost:4869'),
        );
        
        print('Connected to local relay');
      } catch (e) {
        print('Failed to connect to local relay: $e');
      }
    }
  }
} 