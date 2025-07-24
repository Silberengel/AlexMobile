import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/nostr_models.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<NetworkStatus> _statusController = StreamController<NetworkStatus>.broadcast();
  final StreamController<List<RelayConnection>> _relayStatusController = StreamController<List<RelayConnection>>.broadcast();
  
  NetworkStatus _currentStatus = NetworkStatus.unknown;
  List<RelayConnection> _relayConnections = [];
  Timer? _statusCheckTimer;
  Timer? _relayHealthTimer;
  
  // Default relay URLs
  static const List<String> _defaultRelays = [
    'ws://localhost:8080',
    'ws://localhost:4869',
    'wss://relay.damus.io',
    'wss://nos.lol',
    'wss://relay.snort.social',
  ];
  
  // Streams
  Stream<NetworkStatus> get statusStream => _statusController.stream;
  Stream<List<RelayConnection>> get relayStatusStream => _relayStatusController.stream;
  
  // Current status
  NetworkStatus get currentStatus => _currentStatus;
  List<RelayConnection> get relayConnections => List.unmodifiable(_relayConnections);
  
  // Initialize network monitoring
  Future<void> initialize() async {
    // Set up connectivity listener
    _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
    
    // Initialize relay connections
    await _initializeRelayConnections();
    
    // Start periodic status checks
    _startStatusMonitoring();
    _startRelayHealthMonitoring();
    
    // Perform initial status check
    await _checkNetworkStatus();
  }
  
  // Initialize relay connections
  Future<void> _initializeRelayConnections() async {
    _relayConnections = _defaultRelays.map((url) => RelayConnection(
      url: url,
      isConnected: false,
      isInbox: true,
      isOutbox: true,
      responseTime: 0,
      successRate: 0.0,
      lastConnected: DateTime.now(),
    )).toList();
    
    _relayStatusController.add(_relayConnections);
  }
  
  // Handle connectivity changes
  void _handleConnectivityChange(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        _updateStatus(NetworkStatus.online);
        break;
      case ConnectivityResult.ethernet:
        _updateStatus(NetworkStatus.online);
        break;
      case ConnectivityResult.none:
        _updateStatus(NetworkStatus.offline);
        break;
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
        _updateStatus(NetworkStatus.limited);
        break;
      default:
        _updateStatus(NetworkStatus.unknown);
    }
  }
  
  // Update network status
  void _updateStatus(NetworkStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _statusController.add(status);
    }
  }
  
  // Check network status
  Future<void> _checkNetworkStatus() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _handleConnectivityChange(result);
      
      // Test internet connectivity
      if (result != ConnectivityResult.none) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
            _updateStatus(NetworkStatus.online);
          } else {
            _updateStatus(NetworkStatus.limited);
          }
        } catch (e) {
          _updateStatus(NetworkStatus.limited);
        }
      } else {
        _updateStatus(NetworkStatus.offline);
      }
    } catch (e) {
      _updateStatus(NetworkStatus.unknown);
    }
  }
  
  // Start status monitoring
  void _startStatusMonitoring() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkNetworkStatus();
    });
  }
  
  // Start relay health monitoring
  void _startRelayHealthMonitoring() {
    _relayHealthTimer?.cancel();
    _relayHealthTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _checkRelayHealth();
    });
  }
  
  // Check relay health
  Future<void> _checkRelayHealth() async {
    if (_currentStatus == NetworkStatus.offline) {
      // Mark all relays as offline
      for (var relay in _relayConnections) {
        relay = RelayConnection(
          url: relay.url,
          isConnected: false,
          isInbox: relay.isInbox,
          isOutbox: relay.isOutbox,
          responseTime: relay.responseTime,
          successRate: relay.successRate,
          lastConnected: relay.lastConnected,
        );
      }
      _relayStatusController.add(_relayConnections);
      return;
    }
    
    // Test each relay
    for (int i = 0; i < _relayConnections.length; i++) {
      final relay = _relayConnections[i];
      final isConnected = await _testRelayConnection(relay.url);
      
      _relayConnections[i] = RelayConnection(
        url: relay.url,
        isConnected: isConnected,
        isInbox: relay.isInbox,
        isOutbox: relay.isOutbox,
        responseTime: isConnected ? _measureResponseTime(relay.url) : 0,
        successRate: isConnected ? 1.0 : 0.0,
        lastConnected: isConnected ? DateTime.now() : relay.lastConnected,
      );
    }
    
    _relayStatusController.add(_relayConnections);
  }
  
  // Test relay connection
  Future<bool> _testRelayConnection(String url) async {
    try {
      // Simplified relay test - in real implementation, this would test WebSocket connection
      final uri = Uri.parse(url);
      final socket = await Socket.connect(uri.host, uri.port, timeout: const Duration(seconds: 5));
      await socket.close();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Measure response time
  int _measureResponseTime(String url) {
    // Simplified response time measurement
    // In real implementation, this would measure actual WebSocket ping/pong
    return DateTime.now().millisecondsSinceEpoch % 1000; // Mock response time
  }
  
  // Add relay
  Future<void> addRelay(String url) async {
    // Normalize URL
    final normalizedUrl = _normalizeRelayUrl(url);
    
    // Check if relay already exists
    if (_relayConnections.any((relay) => relay.url == normalizedUrl)) {
      return;
    }
    
    // Test connection before adding
    final isConnected = await _testRelayConnection(normalizedUrl);
    
    final newRelay = RelayConnection(
      url: normalizedUrl,
      isConnected: isConnected,
      isInbox: true,
      isOutbox: true,
      responseTime: isConnected ? _measureResponseTime(normalizedUrl) : 0,
      successRate: isConnected ? 1.0 : 0.0,
      lastConnected: DateTime.now(),
    );
    
    _relayConnections.add(newRelay);
    _relayStatusController.add(_relayConnections);
  }
  
  // Remove relay
  void removeRelay(String url) {
    final normalizedUrl = _normalizeRelayUrl(url);
    _relayConnections.removeWhere((relay) => relay.url == normalizedUrl);
    _relayStatusController.add(_relayConnections);
  }
  
  // Update relay configuration
  void updateRelayConfiguration(String url, {bool? isInbox, bool? isOutbox}) {
    final normalizedUrl = _normalizeRelayUrl(url);
    final index = _relayConnections.indexWhere((relay) => relay.url == normalizedUrl);
    
    if (index != -1) {
      final relay = _relayConnections[index];
      _relayConnections[index] = RelayConnection(
        url: relay.url,
        isConnected: relay.isConnected,
        isInbox: isInbox ?? relay.isInbox,
        isOutbox: isOutbox ?? relay.isOutbox,
        responseTime: relay.responseTime,
        successRate: relay.successRate,
        lastConnected: relay.lastConnected,
      );
      _relayStatusController.add(_relayConnections);
    }
  }
  
  // Normalize relay URL
  String _normalizeRelayUrl(String url) {
    String normalized = url.trim();
    
    // Ensure protocol
    if (!normalized.startsWith('ws://') && !normalized.startsWith('wss://')) {
      normalized = 'wss://$normalized';
    }
    
    // Remove trailing slash
    if (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    
    return normalized;
  }
  
  // Get connected relays
  List<RelayConnection> getConnectedRelays() {
    return _relayConnections.where((relay) => relay.isConnected).toList();
  }
  
  // Get inbox relays
  List<RelayConnection> getInboxRelays() {
    return _relayConnections.where((relay) => relay.isInbox).toList();
  }
  
  // Get outbox relays
  List<RelayConnection> getOutboxRelays() {
    return _relayConnections.where((relay) => relay.isOutbox).toList();
  }
  
  // Get network status color (for UI)
  static String getStatusColor(NetworkStatus status) {
    switch (status) {
      case NetworkStatus.online:
        return '#4CAF50'; // Green
      case NetworkStatus.limited:
        return '#FF9800'; // Yellow/Orange
      case NetworkStatus.offline:
        return '#F44336'; // Red
      case NetworkStatus.unknown:
        return '#9E9E9E'; // Grey
      case NetworkStatus.loading:
        return '#2196F3'; // Blue
    }
  }
  
  // Get network status text
  static String getStatusText(NetworkStatus status) {
    switch (status) {
      case NetworkStatus.online:
        return 'Online';
      case NetworkStatus.limited:
        return 'Limited Connectivity';
      case NetworkStatus.offline:
        return 'Offline';
      case NetworkStatus.unknown:
        return 'Unknown';
      case NetworkStatus.loading:
        return 'Checking...';
    }
  }
  
  // Dispose resources
  void dispose() {
    _statusCheckTimer?.cancel();
    _relayHealthTimer?.cancel();
    _statusController.close();
    _relayStatusController.close();
  }
} 