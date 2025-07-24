import 'dart:async';
import 'package:flutter/material.dart';

enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

enum ErrorCategory {
  network,
  authentication,
  database,
  relay,
  content,
  ui,
  unknown,
}

class AppError {
  final String message;
  final String? details;
  final ErrorSeverity severity;
  final ErrorCategory category;
  final DateTime timestamp;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? context;

  AppError({
    required this.message,
    this.details,
    required this.severity,
    required this.category,
    DateTime? timestamp,
    this.stackTrace,
    this.context,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'AppError($category, $severity): $message${details != null ? ' - $details' : ''}';
  }
}

class ErrorService {
  static final ErrorService _instance = ErrorService._internal();
  factory ErrorService() => _instance;
  ErrorService._internal();

  final StreamController<AppError> _errorController = StreamController<AppError>.broadcast();
  final List<AppError> _errorHistory = [];
  final int _maxHistorySize = 100;

  // Stream for listening to errors
  Stream<AppError> get errorStream => _errorController.stream;

  // Get error history
  List<AppError> get errorHistory => List.unmodifiable(_errorHistory);

  // Report an error
  void reportError(
    String message, {
    String? details,
    ErrorSeverity severity = ErrorSeverity.medium,
    ErrorCategory category = ErrorCategory.unknown,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    final error = AppError(
      message: message,
      details: details,
      severity: severity,
      category: category,
      stackTrace: stackTrace,
      context: context,
    );

    // Add to history
    _errorHistory.add(error);
    if (_errorHistory.length > _maxHistorySize) {
      _errorHistory.removeAt(0);
    }

    // Broadcast error
    _errorController.add(error);

    // Log error (in real implementation, this would use proper logging)
    _logError(error);
  }

  // Report network error
  void reportNetworkError(String message, {String? details, Map<String, dynamic>? context}) {
    reportError(
      message,
      details: details,
      severity: ErrorSeverity.high,
      category: ErrorCategory.network,
      context: context,
    );
  }

  // Report authentication error
  void reportAuthError(String message, {String? details, Map<String, dynamic>? context}) {
    reportError(
      message,
      details: details,
      severity: ErrorSeverity.high,
      category: ErrorCategory.authentication,
      context: context,
    );
  }

  // Report database error
  void reportDatabaseError(String message, {String? details, Map<String, dynamic>? context}) {
    reportError(
      message,
      details: details,
      severity: ErrorSeverity.critical,
      category: ErrorCategory.database,
      context: context,
    );
  }

  // Report relay error
  void reportRelayError(String message, {String? details, Map<String, dynamic>? context}) {
    reportError(
      message,
      details: details,
      severity: ErrorSeverity.medium,
      category: ErrorCategory.relay,
      context: context,
    );
  }

  // Report content error
  void reportContentError(String message, {String? details, Map<String, dynamic>? context}) {
    reportError(
      message,
      details: details,
      severity: ErrorSeverity.low,
      category: ErrorCategory.content,
      context: context,
    );
  }

  // Report UI error
  void reportUIError(String message, {String? details, Map<String, dynamic>? context}) {
    reportError(
      message,
      details: details,
      severity: ErrorSeverity.medium,
      category: ErrorCategory.ui,
      context: context,
    );
  }

  // Log error (simplified implementation)
  void _logError(AppError error) {
    // In a real implementation, this would use proper logging
    print('ERROR: ${error.toString()}');
    if (error.stackTrace != null) {
      print('StackTrace: ${error.stackTrace}');
    }
  }

  // Get user-friendly error message
  String getUserFriendlyMessage(AppError error) {
    switch (error.category) {
      case ErrorCategory.network:
        return _getNetworkErrorMessage(error);
      case ErrorCategory.authentication:
        return _getAuthErrorMessage(error);
      case ErrorCategory.database:
        return _getDatabaseErrorMessage(error);
      case ErrorCategory.relay:
        return _getRelayErrorMessage(error);
      case ErrorCategory.content:
        return _getContentErrorMessage(error);
      case ErrorCategory.ui:
        return _getUIErrorMessage(error);
      case ErrorCategory.unknown:
        return _getUnknownErrorMessage(error);
    }
  }

  String _getNetworkErrorMessage(AppError error) {
    if (error.message.contains('timeout')) {
      return 'Connection timed out. Please check your internet connection and try again.';
    } else if (error.message.contains('unreachable')) {
      return 'Unable to reach the server. Please check your internet connection.';
    } else if (error.message.contains('no internet')) {
      return 'No internet connection detected. Please connect to the internet and try again.';
    }
    return 'Network error occurred. Please try again.';
  }

  String _getAuthErrorMessage(AppError error) {
    if (error.message.contains('invalid')) {
      return 'Invalid authentication credentials. Please check your login information.';
    } else if (error.message.contains('expired')) {
      return 'Your session has expired. Please log in again.';
    } else if (error.message.contains('denied')) {
      return 'Access denied. Please check your permissions.';
    }
    return 'Authentication error occurred. Please try logging in again.';
  }

  String _getDatabaseErrorMessage(AppError error) {
    if (error.message.contains('corrupted')) {
      return 'Database corruption detected. Please restart the app.';
    } else if (error.message.contains('full')) {
      return 'Storage is full. Please clear some space and try again.';
    } else if (error.message.contains('locked')) {
      return 'Database is locked. Please try again in a moment.';
    }
    return 'Storage error occurred. Please try again.';
  }

  String _getRelayErrorMessage(AppError error) {
    if (error.message.contains('unreachable')) {
      return 'Unable to connect to relay. Trying alternative relays...';
    } else if (error.message.contains('timeout')) {
      return 'Relay connection timed out. Trying again...';
    } else if (error.message.contains('rate limit')) {
      return 'Relay rate limit exceeded. Please wait a moment.';
    }
    return 'Relay connection error. Trying alternative relays...';
  }

  String _getContentErrorMessage(AppError error) {
    if (error.message.contains('not found')) {
      return 'Content not found. It may have been removed or is unavailable.';
    } else if (error.message.contains('format')) {
      return 'Content format error. This content may be corrupted.';
    } else if (error.message.contains('size')) {
      return 'Content is too large to display.';
    }
    return 'Content error occurred. Please try again.';
  }

  String _getUIErrorMessage(AppError error) {
    if (error.message.contains('render')) {
      return 'Display error occurred. Please restart the app.';
    } else if (error.message.contains('navigation')) {
      return 'Navigation error. Please try again.';
    }
    return 'Interface error occurred. Please try again.';
  }

  String _getUnknownErrorMessage(AppError error) {
    return 'An unexpected error occurred. Please try again.';
  }

  // Get recovery suggestions
  List<String> getRecoverySuggestions(AppError error) {
    final suggestions = <String>[];

    switch (error.category) {
      case ErrorCategory.network:
        suggestions.addAll([
          'Check your internet connection',
          'Try switching between WiFi and mobile data',
          'Restart the app',
        ]);
        break;
      case ErrorCategory.authentication:
        suggestions.addAll([
          'Try logging in again',
          'Check your credentials',
          'Clear app data and restart',
        ]);
        break;
      case ErrorCategory.database:
        suggestions.addAll([
          'Restart the app',
          'Clear app cache',
          'Reinstall the app if the problem persists',
        ]);
        break;
      case ErrorCategory.relay:
        suggestions.addAll([
          'The app will automatically try alternative relays',
          'Check your relay configuration',
          'Try again in a moment',
        ]);
        break;
      case ErrorCategory.content:
        suggestions.addAll([
          'Try refreshing the content',
          'Check if the content is still available',
          'Try accessing the content later',
        ]);
        break;
      case ErrorCategory.ui:
        suggestions.addAll([
          'Restart the app',
          'Try the action again',
          'Clear app cache',
        ]);
        break;
      case ErrorCategory.unknown:
        suggestions.addAll([
          'Try again',
          'Restart the app',
          'Check for app updates',
        ]);
        break;
    }

    return suggestions;
  }

  // Get error severity color
  Color getErrorSeverityColor(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return Colors.blue;
      case ErrorSeverity.medium:
        return Colors.orange;
      case ErrorSeverity.high:
        return Colors.red;
      case ErrorSeverity.critical:
        return Colors.purple;
    }
  }

  // Get error category icon
  IconData getErrorCategoryIcon(ErrorCategory category) {
    switch (category) {
      case ErrorCategory.network:
        return Icons.wifi_off;
      case ErrorCategory.authentication:
        return Icons.lock;
      case ErrorCategory.database:
        return Icons.storage;
      case ErrorCategory.relay:
        return Icons.cloud_off;
      case ErrorCategory.content:
        return Icons.article;
      case ErrorCategory.ui:
        return Icons.bug_report;
      case ErrorCategory.unknown:
        return Icons.error;
    }
  }

  // Clear error history
  void clearErrorHistory() {
    _errorHistory.clear();
  }

  // Get recent errors
  List<AppError> getRecentErrors({int count = 10}) {
    final recentCount = count.clamp(1, _errorHistory.length);
    return _errorHistory.take(recentCount).toList();
  }

  // Get errors by category
  List<AppError> getErrorsByCategory(ErrorCategory category) {
    return _errorHistory.where((error) => error.category == category).toList();
  }

  // Get errors by severity
  List<AppError> getErrorsBySeverity(ErrorSeverity severity) {
    return _errorHistory.where((error) => error.severity == severity).toList();
  }

  // Dispose resources
  void dispose() {
    _errorController.close();
  }
} 