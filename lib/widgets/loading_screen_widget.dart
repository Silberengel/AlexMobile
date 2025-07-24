import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingScreenWidget extends StatefulWidget {
  final String? message;
  final bool showLogo;
  final bool showProgress;

  const LoadingScreenWidget({
    super.key,
    this.message,
    this.showLogo = true,
    this.showProgress = true,
  });

  @override
  State<LoadingScreenWidget> createState() => _LoadingScreenWidgetState();
}

class _LoadingScreenWidgetState extends State<LoadingScreenWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.darkBackground,
            AppTheme.darkSurface,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.showLogo) ...[
              // Animated Logo with brand colors
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: AppTheme.brandGradient,
                          boxShadow: [
                            const BoxShadow(
                              color: AppTheme.brandPurple,
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Center(
                                                      child: const Icon(
                            Icons.book,
                            size: 60,
                            color: Colors.white,
                          ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
            
            // Brand Text with proper hierarchy
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    children: [
                      Text(
                        'Alexandria Mobile',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'by GitCitadel',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.brandPurple,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 60),
            
            // Loading Message
            if (widget.message != null) ...[
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Text(
                      widget.message!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.darkTextSecondary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
            
            // Progress Indicator
            if (widget.showProgress) ...[
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      width: 200,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.darkCard,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.brandPurple),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingOverlayWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const LoadingOverlayWidget({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: LoadingScreenWidget(
              message: message,
              showLogo: true,
              showProgress: true,
            ),
          ),
      ],
    );
  }
} 