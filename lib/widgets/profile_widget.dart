import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../models/nostr_models.dart';
import 'auth_status_indicator.dart';

class ProfileWidget extends ConsumerWidget {
  final VoidCallback? onTap;
  final Function(BuildContext context, RenderBox profileBox)? onMenuTap;

  const ProfileWidget({
    super.key,
    this.onTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userProfile = ref.watch(userProfileProvider);

    return GestureDetector(
      onTap: onTap ?? () => _handleTap(context, ref, authState),
      child: Builder(
        builder: (context) {
          return Container(
            key: const ValueKey('profile_widget'),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile picture or default icon
                _buildProfilePicture(context, authState, userProfile),
                
                const SizedBox(width: 8),
                
                // Handle or status text
                _buildHandleText(context, authState, userProfile),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context, AuthState authState, userProfile) {
    if (authState == AuthState.authenticated && userProfile != null) {
      // Show user's profile picture
      return CircleAvatar(
        radius: 16,
        backgroundImage: userProfile.picture != null 
          ? NetworkImage(userProfile.picture!) 
          : null,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: userProfile.picture == null
          ? Text(
              _getInitials(userProfile.displayName ?? userProfile.name ?? ''),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      );
    } else {
      // Show default user icon
      return CircleAvatar(
        radius: 16,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        child: Icon(
          Icons.person,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
  }

  Widget _buildHandleText(BuildContext context, AuthState authState, userProfile) {
    if (authState == AuthState.authenticated && userProfile != null) {
      // Show user's handle/name
      final displayName = userProfile.displayName ?? userProfile.name ?? userProfile.npub.substring(0, 8);
      return Text(
        displayName,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      );
    } else {
      // Show login status
      return Text(
        _getStatusText(authState),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      );
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _getStatusText(AuthState state) {
    switch (state) {
      case AuthState.authenticated:
        return 'Logged in';
      case AuthState.loading:
        return 'Loading...';
      case AuthState.error:
        return 'Error';
      case AuthState.anonymous:
        return 'Login';
    }
  }

  void _handleTap(BuildContext context, WidgetRef ref, AuthState state) {
    switch (state) {
      case AuthState.authenticated:
        // Show profile menu with position
        if (onMenuTap != null) {
          // Find the profile widget's RenderBox
          final RenderBox? profileBox = context.findRenderObject() as RenderBox?;
          if (profileBox != null) {
            onMenuTap!(context, profileBox);
          }
        } else if (onTap != null) {
          onTap!();
        }
        break;
      case AuthState.anonymous:
      case AuthState.error:
      case AuthState.loading:
        // Show login dialog
        _showLoginDialog(context, ref);
        break;
    }
  }

  void _showLoginDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const AuthLoginDialog(),
    );
  }
} 