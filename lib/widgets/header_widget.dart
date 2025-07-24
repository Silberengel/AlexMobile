import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import 'gitcitadel_logo_widget.dart';

class HeaderWidget extends ConsumerWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onHomeTap;
  final GlobalKey? profileButtonKey;

  const HeaderWidget({
    super.key,
    required this.onProfileTap,
    required this.onHomeTap,
    this.profileButtonKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // GitCitadel Logo and Branding (left)
            GitCitadelBrandWidget(
              onTap: onHomeTap,
            ),
            
            const Spacer(),
            
            // Theme toggle button
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.brandPurple.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: IconButton(
                onPressed: () {
                  final themeMode = ref.read(themeProvider);
                  final newMode = themeMode == ThemeMode.dark 
                    ? ThemeMode.light 
                    : ThemeMode.dark;
                  ref.read(themeProvider.notifier).state = newMode;
                },
                icon: Icon(
                  ref.watch(themeProvider) == ThemeMode.dark 
                    ? Icons.light_mode 
                    : Icons.dark_mode,
                  color: AppTheme.brandPurple,
                  size: 22,
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Profile menu button (right)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.brandPurple.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: IconButton(
                key: profileButtonKey,
                onPressed: onProfileTap,
                icon: Icon(
                  Icons.person,
                  color: AppTheme.brandPurple,
                  size: 22,
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 