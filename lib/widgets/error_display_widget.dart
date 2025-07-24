import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../services/error_service.dart';

class ErrorDisplayWidget extends ConsumerWidget {
  final AppError error;
  final VoidCallback? onDismiss;
  final VoidCallback? onRetry;

  const ErrorDisplayWidget({
    super.key,
    required this.error,
    this.onDismiss,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorService = ref.read(errorServiceProvider);
    final userMessage = errorService.getUserFriendlyMessage(error);
    final suggestions = errorService.getRecoverySuggestions(error);
    final severityColor = errorService.getErrorSeverityColor(error.severity);
    final categoryIcon = errorService.getErrorCategoryIcon(error.category);

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: severityColor.withOpacity(0.1),
        border: Border.all(
          color: severityColor.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error header
          Row(
            children: [
              Icon(
                categoryIcon,
                color: severityColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getErrorTitle(error.category),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: severityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Error message
          Text(
            userMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          
          // Recovery suggestions
          if (suggestions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Suggestions:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            ...suggestions.map((suggestion) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: severityColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      suggestion,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
          
          // Action buttons
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onRetry,
                  child: Text(
                    'Retry',
                    style: TextStyle(color: severityColor),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getErrorTitle(ErrorCategory category) {
    switch (category) {
      case ErrorCategory.network:
        return 'Network Error';
      case ErrorCategory.authentication:
        return 'Authentication Error';
      case ErrorCategory.database:
        return 'Storage Error';
      case ErrorCategory.relay:
        return 'Relay Error';
      case ErrorCategory.content:
        return 'Content Error';
      case ErrorCategory.ui:
        return 'Interface Error';
      case ErrorCategory.unknown:
        return 'Error';
    }
  }
}

// Global error banner that appears at the top of the screen
class GlobalErrorBanner extends ConsumerWidget {
  const GlobalErrorBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentError = ref.watch(errorProvider);
    
    if (currentError == null) return const SizedBox.shrink();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: _getErrorColor(currentError.severity).withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: _getErrorColor(currentError.severity).withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getErrorIcon(currentError.category),
            color: _getErrorColor(currentError.severity),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _getShortErrorMessage(currentError),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getErrorColor(currentError.severity),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            onPressed: () => ref.read(errorProvider.notifier).clearError(),
            icon: const Icon(Icons.close, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
          ),
        ],
      ),
    );
  }

  Color _getErrorColor(ErrorSeverity severity) {
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

  IconData _getErrorIcon(ErrorCategory category) {
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

  String _getShortErrorMessage(AppError error) {
    switch (error.category) {
      case ErrorCategory.network:
        return 'Network issue detected';
      case ErrorCategory.authentication:
        return 'Authentication failed';
      case ErrorCategory.database:
        return 'Storage error';
      case ErrorCategory.relay:
        return 'Relay connection issue';
      case ErrorCategory.content:
        return 'Content loading error';
      case ErrorCategory.ui:
        return 'Interface error';
      case ErrorCategory.unknown:
        return 'An error occurred';
    }
  }
}

// Error snackbar for quick notifications
class ErrorSnackBar extends ConsumerWidget {
  final AppError error;
  final VoidCallback? onRetry;

  const ErrorSnackBar({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorService = ref.read(errorServiceProvider);
    final userMessage = errorService.getUserFriendlyMessage(error);
    final severityColor = errorService.getErrorSeverityColor(error.severity);

    return SnackBar(
      content: Row(
        children: [
          Icon(
            errorService.getErrorCategoryIcon(error.category),
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(userMessage),
          ),
        ],
      ),
      backgroundColor: severityColor,
      duration: const Duration(seconds: 4),
      action: onRetry != null ? SnackBarAction(
        label: 'Retry',
        textColor: Colors.white,
        onPressed: onRetry!,
      ) : null,
    );
  }
} 