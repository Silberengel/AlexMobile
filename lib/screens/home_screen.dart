import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../models/nostr_event.dart';
import '../providers/app_providers.dart';
import '../widgets/publication_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/zapchat_bottom_nav.dart';
import '../widgets/zapchat_fab.dart';
import '../widgets/zapchat_status_indicator.dart';
import '../widgets/content_type_filter.dart';
import '../theme/zapchat_theme.dart';
import 'reader_screen.dart';
import 'index_reader_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore) {
        _loadMore();
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    
    setState(() {
      _isLoadingMore = true;
    });

    await ref.read(publicationsNotifierProvider.notifier).loadMore();

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final publicationsAsync = ref.watch(publicationsNotifierProvider);
    final searchQuery = ref.watch(searchNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final selectedContentType = ref.watch(contentTypeFilterNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(ZapchatTheme.spacing8),
              decoration: BoxDecoration(
                color: ZapchatTheme.primaryPurple,
                borderRadius: BorderRadius.circular(ZapchatTheme.radius12),
              ),
              child: const Icon(
                Icons.library_books,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: ZapchatTheme.spacing12),
            const Text(
              'Alex Reader',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          // Sync status indicator
          Consumer(
            builder: (context, ref, child) {
              final syncStatus = ref.watch(syncStatusNotifierProvider);
              return Container(
                margin: const EdgeInsets.only(right: ZapchatTheme.spacing16),
                child: ZapchatSyncIndicator(
                  isSyncing: syncStatus,
                  onTap: () {
                    ref.read(publicationsNotifierProvider.notifier).refresh();
                  },
                ),
              );
            },
          ),
          // Auth button
          IconButton(
            icon: authState.when(
              data: (isAuthenticated) => Icon(
                isAuthenticated ? Icons.person : Icons.login,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Icon(Icons.error),
            ),
            onPressed: () {
              authState.when(
                data: (isAuthenticated) {
                  if (isAuthenticated) {
                    ref.read(authNotifierProvider.notifier).logout();
                  } else {
                    ref.read(authNotifierProvider.notifier).login();
                  }
                },
                loading: () {},
                error: (_, __) {},
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(ZapchatTheme.spacing16),
            child: SearchBarWidget(
              onSearchChanged: (query) {
                ref.read(searchNotifierProvider.notifier).updateQuery(query);
                ref.read(publicationsNotifierProvider.notifier).search(query);
              },
              onSearchSubmitted: (query) {
                ref.read(publicationsNotifierProvider.notifier).search(query);
              },
            ),
          ),
          
          // Content type filter
          Padding(
            padding: const EdgeInsets.only(bottom: ZapchatTheme.spacing16),
            child: ContentTypeFilter(
              selectedType: selectedContentType,
              onTypeChanged: (type) {
                ref.read(contentTypeFilterNotifierProvider.notifier).setContentType(type);
                ref.read(publicationsNotifierProvider.notifier).refresh();
              },
            ),
          ),
          // Publications list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(publicationsNotifierProvider.notifier).refresh();
              },
              child: publicationsAsync.when(
                data: (publications) {
                  if (publications.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: ZapchatTheme.spacing16),
                    itemCount: publications.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == publications.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      
                      final publication = publications[index];
                                              return PublicationCard(
                          publication: publication,
                          onTap: () {
                            // Navigate to appropriate reader based on content type
                            if (publication.kind == 30040) {
                              // Index/Book - show chapters
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IndexReaderScreen(
                                    indexEvent: publication,
                                  ),
                                ),
                              );
                            } else {
                              // Regular content - show reader
                              ref.read(selectedPublicationNotifierProvider.notifier)
                                  .selectPublication(publication.eventId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ReaderScreen(),
                                ),
                              );
                            }
                          },
                        );
                    },
                  );
                },
                loading: () => _buildLoadingState(),
                error: (error, stack) => _buildErrorState(error),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ZapchatBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
      floatingActionButton: ZapchatFAB(
        onPressed: () {
          // TODO: Add new publication
        },
        icon: Icons.add,
        label: 'New',
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No publications found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull to refresh or check your connection',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 16,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading publications',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(publicationsNotifierProvider.notifier).refresh();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
} 