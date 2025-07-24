import 'package:flutter/material.dart';
import '../theme/zapchat_theme.dart';

class ZapchatFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? label;

  const ZapchatFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ZapchatTheme.radius24),
        boxShadow: ZapchatTheme.shadowLarge,
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: ZapchatTheme.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ZapchatTheme.radius24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            if (label != null) ...[
              const SizedBox(width: ZapchatTheme.spacing8),
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ZapchatMiniFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ZapchatMiniFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ZapchatTheme.radius20),
        boxShadow: ZapchatTheme.shadowMedium,
      ),
      child: FloatingActionButton.small(
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? ZapchatTheme.primaryPurple,
        foregroundColor: foregroundColor ?? Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ZapchatTheme.radius20),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
} 