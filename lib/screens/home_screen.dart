import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../models/nostr_models.dart';
import '../widgets/header_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/content_tabs_widget.dart';
import '../widgets/publication_grid_widget.dart';
import '../widgets/profile_menu_widget.dart';
import '../widgets/network_status_indicator.dart';
import '../widgets/auth_status_indicator.dart';
import '../widgets/error_display_widget.dart';
import '../services/error_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize services
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      // Initialize database service
      final databaseService = ref.read(databaseServiceProvider);
      await databaseService.initialize();
      
      // Initialize network service
      final networkService = ref.read(networkServiceProvider);
      await networkService.initialize();
      
      // Initialize auth service
      final authService = ref.read(authServiceProvider);
      await authService.initialize();
    } catch (e) {
      ref.read(errorServiceProvider).reportError(
        'Failed to initialize services',
        details: e.toString(),
        severity: ErrorSeverity.critical,
        category: ErrorCategory.unknown,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentFilter = ref.watch(contentFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final publications = ref.watch(contentProvider);
    final authState = ref.watch(authStateProvider);
    final networkStatus = ref.watch(networkStatusProvider);
    final currentError = ref.watch(errorProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with Alexandria Mobile label and status indicators
            HeaderWidget(
              onHomeTap: () => _goToHome(),
              onMenuTap: (context, profileBox) => _showAuthenticatedProfileMenu(context, profileBox),
            ),
            
            // Global error banner (moved below header)
            if (currentError != null) const GlobalErrorBanner(),
            
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SearchBarWidget(
                onSearchChanged: (query) {
                  ref.read(searchQueryProvider.notifier).state = query;
                },
              ),
            ),
            
            // Content tabs
            ContentTabsWidget(
              selectedTab: contentFilter,
              onTabChanged: (tab) {
                ref.read(contentFilterProvider.notifier).state = tab;
              },
            ),
            
            // Content grid
            Expanded(
              child: PublicationGridWidget(
                events: publications,
                filter: contentFilter,
                searchQuery: searchQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToHome() {
    // Navigate to home or refresh content
    setState(() {
      // Refresh the content
    });
  }

  void _showAuthenticatedProfileMenu(BuildContext context, RenderBox profileBox) {
    // Get the position of the profile widget
    final profilePosition = profileBox.localToGlobal(Offset.zero);
    
    // Calculate position to appear below the profile widget, aligned to the right edge
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = 200.0;
    
    // Position the menu to the right of the profile widget, but ensure it doesn't go off-screen
    final rightEdge = profilePosition.dx + profileBox.size.width;
    final leftPosition = (rightEdge - menuWidth).clamp(0.0, screenWidth - menuWidth);
    
    final adjustedPosition = RelativeRect.fromLTRB(
      leftPosition, // Left position
      profilePosition.dy + profileBox.size.height + 8, // Below the profile widget
      screenWidth - leftPosition - menuWidth, // Right side
      0, // Top side (will be calculated automatically)
    );
    
    // Show dropdown menu using showMenu with custom items
    showMenu(
      context: context,
      position: adjustedPosition,
      items: [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 20),
              SizedBox(width: 8),
              Text('View Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, size: 20),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'discussions',
          child: Row(
            children: [
              Icon(Icons.forum, size: 20),
              SizedBox(width: 8),
              Text('Discussions'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _handleMenuAction(context, value);
      }
    });
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AuthLoginDialog(),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'profile':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile screen coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings screen coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'discussions':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Discussions screen coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'logout':
        ref.read(authStateProvider.notifier).logout();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
    }
  }
} 