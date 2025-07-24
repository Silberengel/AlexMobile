import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:crypto/crypto.dart';
import '../models/nostr_event.dart';
import '../repositories/event_repository.dart';

class NostrService {
  static const List<String> _relays = [
    'wss://thecitadel.nostr1.com',
    'wss://profiles.nostr1.com',
  ];
  
  static const List<int> _publicationKinds = [30040, 30041, 30023, 30818];
  static const int _profileKind = 0;
  
  final EventRepository _eventRepository;
  final Map<String, WebSocketChannel?> _connections = {};
  Timer? _syncTimer;
  bool _initialized = false;
  
  NostrService(this._eventRepository);
  
  /// Initialize connections and start background sync
  Future<void> initialize() async {
    if (_initialized) return;
    
    await _connectToRelays();
    await _startBackgroundSync();
    _initialized = true;
  }
  
  /// Connect to all configured relays
  Future<void> _connectToRelays() async {
    for (final relay in _relays) {
      try {
        final channel = WebSocketChannel.connect(Uri.parse(relay));
        _connections[relay] = channel;
        
        // Subscribe to events
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
  
  /// Subscribe to relevant events
  Future<void> _subscribeToEvents(WebSocketChannel channel, String relay) async {
    final subscriptionId = _generateSubscriptionId();
    
    // Subscribe to publications
    final publicationFilter = {
      'kinds': _publicationKinds,
      'limit': 1000,
    };
    
    // Subscribe to profiles
    final profileFilter = {
      'kinds': [_profileKind],
      'limit': 1000,
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
        
        await _eventRepository.saveEvent(event);
      }
    } catch (e) {
      print('Error handling incoming event: $e');
    }
  }
  
  /// Start background synchronization
  Future<void> _startBackgroundSync() async {
    // Initial sync
    await _performSync();
    
    // Set up periodic sync every 15 minutes
    _syncTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      _performSync();
    });
  }
  
  /// Perform synchronization with relays
  Future<void> _performSync() async {
    print('Starting background sync...');
    
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
  
  /// Request events from a specific relay
  Future<void> _requestEvents(WebSocketChannel channel, String relay) async {
    final subscriptionId = _generateSubscriptionId();
    
    // Get events since last sync
    final lastSync = await _eventRepository.getLastSyncTime(relay);
    final since = lastSync != null ? lastSync.millisecondsSinceEpoch ~/ 1000 : 0;
    
    final filter = {
      'kinds': [..._publicationKinds, _profileKind],
      'since': since,
      'limit': 1000,
    };
    
    final subscription = {
      'id': subscriptionId,
      'method': 'REQ',
      'params': [subscriptionId, filter],
    };
    
    channel.sink.add(jsonEncode(subscription));
  }
  
  /// Handle connection errors
  void _handleConnectionError(String relay, dynamic error) {
    print('Connection error for relay $relay: $error');
    _reconnectToRelay(relay);
  }
  
  /// Handle connection closure
  void _handleConnectionClosed(String relay) {
    print('Connection closed for relay $relay');
    _reconnectToRelay(relay);
  }
  
  /// Reconnect to a specific relay
  Future<void> _reconnectToRelay(String relay) async {
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
  
  /// Close all connections
  Future<void> dispose() async {
    _syncTimer?.cancel();
    
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
  
  /// Get sync status
  bool get isSyncing => _initialized;
  
  /// Get connected relays
  List<String> get connectedRelays => _connections.keys.toList();
} 