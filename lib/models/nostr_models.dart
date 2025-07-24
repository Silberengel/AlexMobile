import 'package:flutter/foundation.dart';

/// Network Status Enum
enum NetworkStatus {
  online,
  offline,
  limited,
  unknown,
  loading,
}

/// Authentication State Enum
enum AuthState {
  anonymous,
  authenticated,
  loading,
  error,
}

/// Relay Connection Model
class RelayConnection {
  final String url;
  final bool isConnected;
  final bool isInbox;
  final bool isOutbox;
  final int responseTime;
  final double successRate;
  final DateTime lastConnected;

  RelayConnection({
    required this.url,
    this.isConnected = false,
    this.isInbox = true,
    this.isOutbox = true,
    this.responseTime = 0,
    this.successRate = 0.0,
    required this.lastConnected,
  });

  factory RelayConnection.fromJson(Map<String, dynamic> json) {
    return RelayConnection(
      url: json['url'] as String,
      isConnected: json['isConnected'] as bool? ?? false,
      isInbox: json['isInbox'] as bool? ?? true,
      isOutbox: json['isOutbox'] as bool? ?? true,
      responseTime: json['responseTime'] as int? ?? 0,
      successRate: (json['successRate'] as num?)?.toDouble() ?? 0.0,
      lastConnected: DateTime.parse(json['lastConnected'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'isConnected': isConnected,
      'isInbox': isInbox,
      'isOutbox': isOutbox,
      'responseTime': responseTime,
      'successRate': successRate,
      'lastConnected': lastConnected.toIso8601String(),
    };
  }
} 