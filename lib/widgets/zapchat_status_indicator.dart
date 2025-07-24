import 'package:flutter/material.dart';
import '../theme/zapchat_theme.dart';

class ZapchatStatusIndicator extends StatelessWidget {
  final bool isConnected;
  final bool isSyncing;
  final String? statusText;

  const ZapchatStatusIndicator({
    super.key,
    required this.isConnected,
    required this.isSyncing,
    this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ZapchatTheme.spacing12,
        vertical: ZapchatTheme.spacing6,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(ZapchatTheme.radius20),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getStatusColor(),
              shape: BoxShape.circle,
            ),
          ),
          if (statusText != null) ...[
            const SizedBox(width: ZapchatTheme.spacing8),
            Text(
              statusText!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getStatusColor(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (isSyncing) {
      return ZapchatTheme.warningYellow;
    } else if (isConnected) {
      return ZapchatTheme.successGreen;
    } else {
      return ZapchatTheme.errorRed;
    }
  }
}

class ZapchatSyncIndicator extends StatelessWidget {
  final bool isSyncing;
  final VoidCallback? onTap;

  const ZapchatSyncIndicator({
    super.key,
    required this.isSyncing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(ZapchatTheme.spacing8),
        decoration: BoxDecoration(
          color: isSyncing 
              ? ZapchatTheme.primaryPurple.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ZapchatTheme.radius12),
        ),
        child: AnimatedRotation(
          turns: isSyncing ? 1 : 0,
          duration: const Duration(seconds: 2),
          child: Icon(
            Icons.sync,
            size: 20,
            color: isSyncing 
                ? ZapchatTheme.primaryPurple
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
} 