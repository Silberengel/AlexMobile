import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkState {
  offline,
  online,
  lowBandwidth,
  highBandwidth,
}

enum ConnectionType {
  none,
  wifi,
  mobile,
  ethernet,
}

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<NetworkState> _networkStateController = 
      StreamController<NetworkState>.broadcast();
  final StreamController<ConnectionType> _connectionTypeController = 
      StreamController<ConnectionType>.broadcast();

  NetworkState _currentState = NetworkState.offline;
  ConnectionType _currentConnectionType = ConnectionType.none;
  Timer? _bandwidthTestTimer;
  double _lastBandwidthTest = 0.0;

  Stream<NetworkState> get networkStateStream => _networkStateController.stream;
  Stream<ConnectionType> get connectionTypeStream => _connectionTypeController.stream;
  NetworkState get currentState => _currentState;
  ConnectionType get currentConnectionType => _currentConnectionType;

  /// Initialize network monitoring
  Future<void> initialize() async {
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
    
    // Initial state check
    await _checkInitialState();
    
    // Start bandwidth monitoring
    _startBandwidthMonitoring();
  }

  /// Check initial network state
  Future<void> _checkInitialState() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    await _handleConnectivityChange(connectivityResult);
  }

  /// Handle connectivity changes
  Future<void> _handleConnectivityChange(ConnectivityResult result) async {
    ConnectionType newType;
    
    switch (result) {
      case ConnectivityResult.wifi:
        newType = ConnectionType.wifi;
        break;
      case ConnectivityResult.mobile:
        newType = ConnectionType.mobile;
        break;
      case ConnectivityResult.ethernet:
        newType = ConnectionType.ethernet;
        break;
      default:
        newType = ConnectionType.none;
    }

    _currentConnectionType = newType;
    _connectionTypeController.add(newType);

    // Test bandwidth and update state
    await _testBandwidthAndUpdateState();
  }

  /// Test bandwidth and update network state
  Future<void> _testBandwidthAndUpdateState() async {
    if (_currentConnectionType == ConnectionType.none) {
      _updateNetworkState(NetworkState.offline);
      return;
    }

    try {
      final bandwidth = await _measureBandwidth();
      _lastBandwidthTest = bandwidth;

      NetworkState newState;
      if (bandwidth < 1.0) { // Less than 1 Mbps
        newState = NetworkState.lowBandwidth;
      } else if (bandwidth > 10.0) { // More than 10 Mbps
        newState = NetworkState.highBandwidth;
      } else {
        newState = NetworkState.online;
      }

      _updateNetworkState(newState);
    } catch (e) {
      // If bandwidth test fails, assume offline
      _updateNetworkState(NetworkState.offline);
    }
  }

  /// Measure bandwidth by downloading a small test file
  Future<double> _measureBandwidth() async {
    try {
      final stopwatch = Stopwatch()..start();
      
      // Download a small test file (1KB)
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('https://httpbin.org/bytes/1024'));
      final response = await request.close();
      
      // Read the response
      await response.transform(List<int>.from).toList();
      
      stopwatch.stop();
      client.close();

      // Calculate bandwidth in Mbps
      final durationSeconds = stopwatch.elapsedMilliseconds / 1000.0;
      final bytesPerSecond = 1024 / durationSeconds;
      final mbps = (bytesPerSecond * 8) / 1000000; // Convert to Mbps

      return mbps;
    } catch (e) {
      return 0.0;
    }
  }

  /// Update network state and notify listeners
  void _updateNetworkState(NetworkState newState) {
    if (_currentState != newState) {
      _currentState = newState;
      _networkStateController.add(newState);
    }
  }

  /// Start periodic bandwidth monitoring
  void _startBandwidthMonitoring() {
    _bandwidthTestTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (_currentConnectionType != ConnectionType.none) {
        _testBandwidthAndUpdateState();
      }
    });
  }

  /// Get recommended sync interval based on network state
  Duration getRecommendedSyncInterval() {
    switch (_currentState) {
      case NetworkState.offline:
        return const Duration(hours: 1); // No sync when offline
      case NetworkState.lowBandwidth:
        return const Duration(minutes: 30); // Less frequent sync
      case NetworkState.online:
        return const Duration(minutes: 15); // Normal sync
      case NetworkState.highBandwidth:
        return const Duration(minutes: 5); // Frequent sync
    }
  }

  /// Get recommended batch size for sync
  int getRecommendedBatchSize() {
    switch (_currentState) {
      case NetworkState.offline:
        return 0; // No sync
      case NetworkState.lowBandwidth:
        return 50; // Small batches
      case NetworkState.online:
        return 100; // Normal batches
      case NetworkState.highBandwidth:
        return 500; // Large batches
    }
  }

  /// Check if sync should be performed
  bool shouldPerformSync() {
    return _currentState != NetworkState.offline;
  }

  /// Get current bandwidth estimate
  double get currentBandwidth => _lastBandwidthTest;

  /// Dispose resources
  void dispose() {
    _bandwidthTestTimer?.cancel();
    _networkStateController.close();
    _connectionTypeController.close();
  }
} 