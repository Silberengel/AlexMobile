import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class GitCitadelLogoWidget extends StatelessWidget {
  final double size;
  final bool showGradient;
  final VoidCallback? onTap;

  const GitCitadelLogoWidget({
    super.key,
    this.size = 32,
    this.showGradient = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Use black logo in both modes for better contrast
    final logoAsset = 'assets/GitCitadelLogos/GitCitadel_Icon_Black.svg';

    Widget logo = SvgPicture.asset(
      logoAsset,
      width: size * 0.625, // 20/32 ratio
      height: size * 0.625,
      fit: BoxFit.contain,
    );

    if (showGradient) {
      logo = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.25), // 8/32 ratio
          gradient: AppTheme.brandGradient,
          boxShadow: [
            BoxShadow(
              color: AppTheme.brandPurple.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.25),
          child: Center(child: logo),
        ),
      );
    }

    if (onTap != null) {
      logo = GestureDetector(
        onTap: onTap,
        child: logo,
      );
    }

    return logo;
  }
}

class GitCitadelBrandWidget extends StatelessWidget {
  final double logoSize;
  final bool showSubtitle;
  final VoidCallback? onTap;

  const GitCitadelBrandWidget({
    super.key,
    this.logoSize = 32,
    this.showSubtitle = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          GitCitadelLogoWidget(
            size: logoSize,
            showGradient: true,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => AppTheme.gitcitadelGradient.createShader(bounds),
                child: Text(
                  'GitCitadel',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // This will be masked by the gradient
                    fontSize: 20,
                  ),
                ),
              ),
              if (showSubtitle)
                Text(
                  'Alexandria Mobile',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
} 