import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../widgets/header_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/content_tabs_widget.dart';
import '../widgets/publication_grid_widget.dart';
import '../widgets/profile_menu_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey _profileButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final contentFilter = ref.watch(contentFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final publications = ref.watch(contentProvider);

    return Scaffold(
      body: Column(
        children: [
          // Header with Alexandria Mobile label and profile menu
          HeaderWidget(
            onProfileTap: () => _showProfileMenu(context),
            onHomeTap: () => _goToHome(),
            profileButtonKey: _profileButtonKey,
          ),
          
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
    );
  }

  void _showProfileMenu(BuildContext context) {
    // Get the button's position for dropdown positioning
    final RenderBox button = _profileButtonKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
    
    // Calculate position to appear below the button, aligned to the right edge
    final adjustedPosition = RelativeRect.fromLTRB(
      buttonPosition.dx - 200, // Align to left edge of button, minus menu width
      buttonPosition.dy + button.size.height + 8, // Below the button
      overlay.size.width - buttonPosition.dx - button.size.width, // Right side
      overlay.size.height - buttonPosition.dy - button.size.height - 8, // Top side
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
      ],
    ).then((value) {
      if (value != null) {
        _handleMenuAction(context, value);
      }
    });
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
    }
  }

  void _goToHome() {
    ref.read(contentFilterProvider.notifier).state = ContentType.publications;
    ref.read(searchQueryProvider.notifier).state = '';
  }
} 