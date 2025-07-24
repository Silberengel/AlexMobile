import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';

class ProfileMenuWidget extends ConsumerWidget {
  const ProfileMenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(profileProvider);

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile info
          if (userProfile != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: userProfile.picture != null
                      ? NetworkImage(userProfile.picture!)
                      : null,
                    child: userProfile.picture == null
                      ? Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 20,
                        )
                      : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProfile.displayName ?? 'Anonymous',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${userProfile.pubkey.substring(0, 16)}...',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Not authenticated',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Tap to sign in',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
          
          // Menu options
          _buildMenuItem(
            context,
            icon: Icons.person,
            title: 'View Profile',
            onTap: () => Navigator.pop(context, 'profile'),
          ),
          
          _buildMenuItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => Navigator.pop(context, 'settings'),
          ),
          
          _buildMenuItem(
            context,
            icon: Icons.forum,
            title: 'Discussions',
            onTap: () => Navigator.pop(context, 'discussions'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface,
        size: 20,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }
} 