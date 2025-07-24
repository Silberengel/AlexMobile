import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GitCitadelButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double height;

  const GitCitadelButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;
    
    if (isOutlined) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppTheme.brandPurple,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(width ?? double.infinity, height),
        ),
        child: _buildButtonContent(),
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.brandPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppTheme.brandPurple.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(width ?? double.infinity, height),
        ),
        child: _buildButtonContent(),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: button,
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}

class GitCitadelIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const GitCitadelIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
    this.size = 48,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppTheme.lightCard;
    final icColor = iconColor ?? AppTheme.brandPurple;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(size * 0.25),
        border: Border.all(
          color: AppTheme.brandPurple.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.brandPurple.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(size * 0.25),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: size * 0.4,
                    height: size * 0.4,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(icColor),
                    ),
                  )
                : Icon(
                    icon,
                    color: icColor,
                    size: size * 0.4,
                  ),
          ),
        ),
      ),
    );
  }
}

class GitCitadelFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? iconColor;

  const GitCitadelFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppTheme.brandPurple;
    final icColor = iconColor ?? Colors.white;

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: bgColor,
      foregroundColor: icColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon),
    );
  }
} 