import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../models/nostr_models.dart';

class NetworkStatusIndicator extends ConsumerWidget {
  final double size;
  final bool showText;
  final bool showTooltip;

  const NetworkStatusIndicator({
    super.key,
    this.size = 16.0,
    this.showText = false,
    this.showTooltip = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = ref.watch(networkStatusProvider);
    final relayConnections = ref.watch(relayConnectionsProvider);
    
    final connectedRelays = relayConnections.where((relay) => relay.isConnected).length;
    final totalRelays = relayConnections.length;

    return Tooltip(
      message: showTooltip ? _getStatusTooltip(networkStatus, connectedRelays, totalRelays) : '',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status indicator circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getStatusColor(networkStatus),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: networkStatus == NetworkStatus.loading
                ? Center(
                    child: SizedBox(
                      width: size * 0.5,
                      height: size * 0.5,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : null,
          ),
          
          // Status text (optional)
          if (showText) ...[
            const SizedBox(width: 4),
            Text(
              _getStatusText(networkStatus),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getStatusColor(networkStatus),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          
          // Relay count (optional)
          if (showText && totalRelays > 0) ...[
            const SizedBox(width: 8),
            Text(
              '($connectedRelays/$totalRelays relays)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(NetworkStatus status) {
    switch (status) {
      case NetworkStatus.online:
        return const Color(0xFF4CAF50); // Green
      case NetworkStatus.limited:
        return const Color(0xFFFF9800); // Yellow/Orange
      case NetworkStatus.offline:
        return const Color(0xFFF44336); // Red
      case NetworkStatus.unknown:
        return const Color(0xFF9E9E9E); // Grey
      case NetworkStatus.loading:
        return const Color(0xFF2196F3); // Blue
    }
  }

  String _getStatusText(NetworkStatus status) {
    switch (status) {
      case NetworkStatus.online:
        return 'Online';
      case NetworkStatus.limited:
        return 'Limited';
      case NetworkStatus.offline:
        return 'Offline';
      case NetworkStatus.unknown:
        return 'Unknown';
      case NetworkStatus.loading:
        return 'Checking...';
    }
  }

  String _getStatusTooltip(NetworkStatus status, int connectedRelays, int totalRelays) {
    final statusText = _getStatusText(status);
    final relayInfo = totalRelays > 0 ? ' ($connectedRelays/$totalRelays relays connected)' : '';
    
    switch (status) {
      case NetworkStatus.online:
        return 'Network: $statusText$relayInfo';
      case NetworkStatus.limited:
        return 'Network: $statusText - Some connectivity issues detected$relayInfo';
      case NetworkStatus.offline:
        return 'Network: $statusText - No internet connection$relayInfo';
      case NetworkStatus.unknown:
        return 'Network: $statusText - Checking connection...$relayInfo';
      case NetworkStatus.loading:
        return 'Network: $statusText - Testing connectivity...$relayInfo';
    }
  }
}

// Compact version for use in headers
class CompactNetworkIndicator extends ConsumerWidget {
  final double size;

  const CompactNetworkIndicator({
    super.key,
    this.size = 12.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = ref.watch(networkStatusProvider);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getStatusColor(networkStatus),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: networkStatus == NetworkStatus.loading
          ? Center(
              child: SizedBox(
                width: size * 0.6,
                height: size * 0.6,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          : null,
    );
  }

  Color _getStatusColor(NetworkStatus status) {
    switch (status) {
      case NetworkStatus.online:
        return const Color(0xFF4CAF50); // Green
      case NetworkStatus.limited:
        return const Color(0xFFFF9800); // Yellow/Orange
      case NetworkStatus.offline:
        return const Color(0xFFF44336); // Red
      case NetworkStatus.unknown:
        return const Color(0xFF9E9E9E); // Grey
      case NetworkStatus.loading:
        return const Color(0xFF2196F3); // Blue
    }
  }
}

// Animated version with pulse effect for offline status
class AnimatedNetworkIndicator extends ConsumerStatefulWidget {
  final double size;
  final bool showText;

  const AnimatedNetworkIndicator({
    super.key,
    this.size = 16.0,
    this.showText = false,
  });

  @override
  ConsumerState<AnimatedNetworkIndicator> createState() => _AnimatedNetworkIndicatorState();
}

class _AnimatedNetworkIndicatorState extends ConsumerState<AnimatedNetworkIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final networkStatus = ref.watch(networkStatusProvider);
    
    // Start/stop animation based on status
    if (networkStatus == NetworkStatus.offline) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: networkStatus == NetworkStatus.offline ? _pulseAnimation.value : 1.0,
          child: NetworkStatusIndicator(
            size: widget.size,
            showText: widget.showText,
          ),
        );
      },
    );
  }
} 