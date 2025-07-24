import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../models/nostr_models.dart';

class ProfileMenuWidget extends ConsumerWidget {
  const ProfileMenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final authState = ref.watch(authStateProvider);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile header
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                userProfile?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(userProfile?.displayName ?? 'User'),
            subtitle: Text(userProfile?.bio ?? 'No bio available'),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          
          const Divider(),
          
          // Menu items
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('View Profile'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Navigate to profile screen
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Navigate to settings screen
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.forum),
            title: const Text('Discussions'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Navigate to discussions screen
            },
          ),
          
          const Divider(),
          
          // Logout option
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              ref.read(authStateProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
} 