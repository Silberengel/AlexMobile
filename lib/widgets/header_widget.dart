import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import 'gitcitadel_logo_widget.dart';
import 'profile_widget.dart';

class HeaderWidget extends ConsumerWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onHomeTap;
  final Function(BuildContext context, RenderBox profileBox)? onMenuTap;

  const HeaderWidget({
    super.key,
    this.onProfileTap,
    this.onHomeTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Alexandria Mobile label (left side)
          Expanded(
            child: GestureDetector(
              onTap: onHomeTap,
              child: GitCitadelBrandWidget(
                logoSize: 32,
                showSubtitle: true,
                onTap: onHomeTap,
              ),
            ),
          ),
          
          // Status indicators (right side)
          Row(
            children: [
              // Theme toggle
              _buildThemeToggle(context, ref),
              
              const SizedBox(width: 8),
              
              // Profile widget
              ProfileWidget(
                onTap: onProfileTap,
                onMenuTap: onMenuTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return IconButton(
      onPressed: () {
        ref.read(themeProvider.notifier).update((state) => 
          state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark
        );
      },
      icon: Icon(
        themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
        size: 20,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      tooltip: themeMode == ThemeMode.dark ? 'Switch to light mode' : 'Switch to dark mode',
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(8),
        minimumSize: const Size(32, 32),
      ),
    );
  }
} 