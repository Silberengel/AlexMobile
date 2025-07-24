import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../models/nostr_event_models.dart';
import '../models/nostr_models.dart';

class AuthStatusIndicator extends ConsumerWidget {
  final double size;
  final bool showText;
  final bool showTooltip;
  final VoidCallback? onTap;

  const AuthStatusIndicator({
    super.key,
    this.size = 24.0,
    this.showText = false,
    this.showTooltip = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userProfile = ref.watch(userProfileProvider);

    return Tooltip(
      message: showTooltip ? _getAuthTooltip(authState, userProfile) : '',
      child: GestureDetector(
        onTap: onTap ?? () => _handleAuthTap(context, ref, authState),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Auth status icon
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getAuthColor(authState),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: _getAuthIcon(authState, size * 0.6),
            ),
            
            // Status text (optional)
            if (showText) ...[
              const SizedBox(width: 8),
              Text(
                _getAuthText(authState, userProfile),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getAuthColor(authState),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getAuthColor(AuthState state) {
    switch (state) {
      case AuthState.authenticated:
        return const Color(0xFF4CAF50); // Green
      case AuthState.loading:
        return const Color(0xFFFF9800); // Orange
      case AuthState.error:
        return const Color(0xFFF44336); // Red
      case AuthState.anonymous:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  Widget _getAuthIcon(AuthState state, double iconSize) {
    switch (state) {
      case AuthState.authenticated:
        return Icon(
          Icons.person,
          size: iconSize,
          color: Colors.white,
        );
      case AuthState.loading:
        return SizedBox(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      case AuthState.error:
        return Icon(
          Icons.error,
          size: iconSize,
          color: Colors.white,
        );
      case AuthState.anonymous:
        return Icon(
          Icons.login,
          size: iconSize,
          color: Colors.white,
        );
    }
  }

  String _getAuthText(AuthState state, UserProfile? profile) {
    switch (state) {
      case AuthState.authenticated:
        return profile?.displayName ?? 'Authenticated';
      case AuthState.loading:
        return 'Loading...';
      case AuthState.error:
        return 'Error';
      case AuthState.anonymous:
        return 'Login';
    }
  }

  String _getAuthTooltip(AuthState state, UserProfile? profile) {
    switch (state) {
      case AuthState.authenticated:
        final name = profile?.displayName ?? 'User';
        return 'Authenticated as $name\nTap to logout';
      case AuthState.loading:
        return 'Authenticating...';
      case AuthState.error:
        return 'Authentication error\nTap to retry';
      case AuthState.anonymous:
        return 'Not authenticated\nTap to login';
    }
  }

  void _handleAuthTap(BuildContext context, WidgetRef ref, AuthState state) {
    switch (state) {
      case AuthState.authenticated:
        _showLogoutDialog(context, ref);
        break;
      case AuthState.anonymous:
        _showLoginDialog(context, ref);
        break;
      case AuthState.error:
        _showLoginDialog(context, ref);
        break;
      case AuthState.loading:
        // Do nothing while loading
        break;
    }
  }

  void _showLoginDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const AuthLoginDialog(),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
              Navigator.of(context).pop();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

// Login dialog with authentication options
class AuthLoginDialog extends ConsumerStatefulWidget {
  const AuthLoginDialog({super.key});

  @override
  ConsumerState<AuthLoginDialog> createState() => _AuthLoginDialogState();
}

class _AuthLoginDialogState extends ConsumerState<AuthLoginDialog> {
  final _npubController = TextEditingController();
  final _nsecController = TextEditingController();
  String _selectedMethod = 'amber';

  @override
  void initState() {
    super.initState();
    // Set default method based on platform
    if (kIsWeb) {
      _selectedMethod = 'amber';
    } else if (Platform.isAndroid) {
      _selectedMethod = 'amber';
    } else {
      _selectedMethod = 'npub'; // Default to npub for other platforms
    }
  }

  @override
  void dispose() {
    _npubController.dispose();
    _nsecController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login to Alexandria'),
      content: SizedBox(
        width: 400, // Set a fixed width for better layout
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            
            // Authentication method selection
            SegmentedButton<String>(
              segments: _getAvailableSegments(),
              selected: {_selectedMethod},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedMethod = newSelection.first;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Method-specific input fields
            if (_selectedMethod == 'npub') ...[
              TextField(
                controller: _npubController,
                decoration: const InputDecoration(
                  labelText: 'Npub',
                  hintText: 'Enter your public key',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
            ] else if (_selectedMethod == 'nsec') ...[
              TextField(
                controller: _nsecController,
                decoration: const InputDecoration(
                  labelText: 'Nsec',
                  hintText: 'Enter your private key',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
            ] else if (_selectedMethod == 'amber') ...[
              _buildAmberLoginContent(),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _performLogin(),
          child: const Text('Login'),
        ),
      ],
    );
  }

  List<ButtonSegment<String>> _getAvailableSegments() {
    final segments = <ButtonSegment<String>>[];
    
    if (kIsWeb || Platform.isAndroid) {
      segments.add(const ButtonSegment(
        value: 'amber',
        label: Text('Amber'),
        icon: Icon(Icons.web),
      ));
    }
    
    segments.addAll([
      const ButtonSegment(
        value: 'npub',
        label: Text('Npub'),
        icon: Icon(Icons.person),
      ),
      const ButtonSegment(
        value: 'nsec',
        label: Text('Nsec'),
        icon: Icon(Icons.key),
      ),
    ]);
    
    return segments;
  }

  Widget _buildAmberLoginContent() {
    if (kIsWeb) {
      return Column(
        children: [
          const SizedBox(height: 16),
          const Icon(
            Icons.qr_code,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),
          const Text(
            'Scan QR code or copy the nostrconnect:// link',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          Container(
            width: 400, // Make it twice as wide (was 200)
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 380, // Constrain width (was 180)
                  child: Text(
                    'nostrconnect://example.com/connect?relay=wss://relay.example.com&metadata={"name":"Alexandria Mobile","description":"Nostr client","url":"https://alexandria.example.com"}',
                    style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(
                          text: 'nostrconnect://example.com/connect?relay=wss://relay.example.com&metadata={"name":"Alexandria Mobile","description":"Nostr client","url":"https://alexandria.example.com"}',
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Link copied to clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      tooltip: 'Copy to clipboard',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    } else if (Platform.isAndroid) {
      return Column(
        children: [
          const SizedBox(height: 16),
          const Icon(
            Icons.android,
            size: 64,
            color: Colors.green,
          ),
          const SizedBox(height: 24),
          const Text(
            'This will open the Amber app for authentication',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
        ],
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Amber login not available on this platform',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
        ],
      );
    }
  }

  void _performLogin() async {
    final authNotifier = ref.read(authStateProvider.notifier);
    
    switch (_selectedMethod) {
      case 'amber':
        await authNotifier.loginWithAmber();
        break;
      case 'npub':
        if (_npubController.text.isNotEmpty) {
          await authNotifier.loginWithNpub(_npubController.text.trim());
        }
        break;
      case 'nsec':
        if (_nsecController.text.isNotEmpty) {
          await authNotifier.loginWithNsec(_nsecController.text.trim());
        }
        break;
    }
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

// Compact version for use in headers
class CompactAuthIndicator extends ConsumerWidget {
  final double size;
  final VoidCallback? onTap;

  const CompactAuthIndicator({
    super.key,
    this.size = 20.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return GestureDetector(
      onTap: onTap ?? () => _handleTap(context, ref, authState),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getAuthColor(authState),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: _getAuthIcon(authState, size * 0.6),
      ),
    );
  }

  Color _getAuthColor(AuthState state) {
    switch (state) {
      case AuthState.authenticated:
        return const Color(0xFF4CAF50); // Green
      case AuthState.loading:
        return const Color(0xFFFF9800); // Orange
      case AuthState.error:
        return const Color(0xFFF44336); // Red
      case AuthState.anonymous:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  Widget _getAuthIcon(AuthState state, double iconSize) {
    switch (state) {
      case AuthState.authenticated:
        return Icon(
          Icons.person,
          size: iconSize,
          color: Colors.white,
        );
      case AuthState.loading:
        return SizedBox(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      case AuthState.error:
        return Icon(
          Icons.error,
          size: iconSize,
          color: Colors.white,
        );
      case AuthState.anonymous:
        return Icon(
          Icons.login,
          size: iconSize,
          color: Colors.white,
        );
    }
  }

  void _handleTap(BuildContext context, WidgetRef ref, AuthState state) {
    if (state == AuthState.authenticated) {
      ref.read(authStateProvider.notifier).logout();
    } else {
      showDialog(
        context: context,
        builder: (context) => const AuthLoginDialog(),
      );
    }
  }
} 