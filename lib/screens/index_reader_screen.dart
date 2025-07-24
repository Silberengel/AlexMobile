import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/nostr_event.dart';
import '../providers/app_providers.dart';
import '../theme/zapchat_theme.dart';
import 'reader_screen.dart';

class IndexReaderScreen extends ConsumerStatefulWidget {
  final NostrEvent indexEvent;

  const IndexReaderScreen({
    super.key,
    required this.indexEvent,
  });

  @override
  ConsumerState<IndexReaderScreen> createState() => _IndexReaderScreenState();
}

class _IndexReaderScreenState extends ConsumerState<IndexReaderScreen> {
  List<NostrEvent>? _chapters;
  bool _isLoadingChapters = true;

  @override
  void initState() {
    super.initState();
    _loadChapters();
  }

  Future<void> _loadChapters() async {
    if (widget.indexEvent.chapterIds == null) {
      setState(() {
        _isLoadingChapters = false;
      });
      return;
    }

    try {
      final repository = ref.read(eventRepositoryProvider);
      final chapters = <NostrEvent>[];
      
      for (final chapterId in widget.indexEvent.chapterIds!) {
        final chapter = await repository.getPublication(chapterId);
        if (chapter != null) {
          chapters.add(chapter);
        }
      }
      
      setState(() {
        _chapters = chapters;
        _isLoadingChapters = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingChapters = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.indexEvent.title ?? 'Book',
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ZapchatTheme.spacing12,
              vertical: ZapchatTheme.spacing8,
            ),
            margin: const EdgeInsets.only(right: ZapchatTheme.spacing16),
            decoration: BoxDecoration(
              color: ZapchatTheme.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ZapchatTheme.radius12),
              border: Border.all(
                color: ZapchatTheme.primaryPurple.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.book,
                  size: 16,
                  color: ZapchatTheme.primaryPurple,
                ),
                const SizedBox(width: ZapchatTheme.spacing8),
                Text(
                  'Book',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ZapchatTheme.primaryPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoadingChapters) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(ZapchatTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book header
          _buildBookHeader(),
          
          const SizedBox(height: ZapchatTheme.spacing32),
          
          // Chapters list
          _buildChaptersList(),
        ],
      ),
    );
  }

  Widget _buildBookHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          widget.indexEvent.title ?? 'Untitled Book',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        
        const SizedBox(height: ZapchatTheme.spacing16),
        
        // Meta information
        Row(
          children: [
            // Author
            if (widget.indexEvent.authors?.isNotEmpty == true) ...[
              Icon(
                Icons.person,
                size: 16,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'By ${widget.indexEvent.authors!.join(', ')}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
            
            // Date
            Icon(
              Icons.access_time,
              size: 16,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 4),
            Text(
              _formatDate(widget.indexEvent.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: ZapchatTheme.spacing16),
        
        // Summary
        if (widget.indexEvent.summary?.isNotEmpty == true) ...[
          Text(
            widget.indexEvent.summary!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: ZapchatTheme.spacing16),
        ],
        
        // Cover image
        if (widget.indexEvent.image?.isNotEmpty == true)
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.only(bottom: ZapchatTheme.spacing16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ZapchatTheme.radius12),
              child: Image.network(
                widget.indexEvent.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
          ),
        
        // Tags
        if (widget.indexEvent.tags_parsed?.isNotEmpty == true) ...[
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: widget.indexEvent.tags_parsed!.map((tag) {
              return Chip(
                label: Text(tag),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: ZapchatTheme.spacing16),
        ],
        
        const Divider(),
      ],
    );
  }

  Widget _buildChaptersList() {
    if (_chapters == null || _chapters!.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.library_books,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: ZapchatTheme.spacing16),
            Text(
              'No chapters found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This book doesn\'t have any chapters yet',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chapters',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        
        const SizedBox(height: ZapchatTheme.spacing16),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _chapters!.length,
          itemBuilder: (context, index) {
            final chapter = _chapters![index];
            return _buildChapterCard(chapter, index + 1);
          },
        ),
      ],
    );
  }

  Widget _buildChapterCard(NostrEvent chapter, int chapterNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: ZapchatTheme.spacing12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ZapchatTheme.radius12),
        boxShadow: ZapchatTheme.shadowSmall,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          ref.read(selectedPublicationNotifierProvider.notifier)
              .selectPublication(chapter.eventId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReaderScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(ZapchatTheme.radius12),
        child: Padding(
          padding: const EdgeInsets.all(ZapchatTheme.spacing16),
          child: Row(
            children: [
              // Chapter number
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: ZapchatTheme.primaryPurple,
                  borderRadius: BorderRadius.circular(ZapchatTheme.radius8),
                ),
                child: Center(
                  child: Text(
                    '$chapterNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: ZapchatTheme.spacing12),
              
              // Chapter content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.title ?? 'Untitled Chapter',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    if (chapter.summary?.isNotEmpty == true) ...[
                      const SizedBox(height: ZapchatTheme.spacing4),
                      Text(
                        chapter.summary!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(width: ZapchatTheme.spacing8),
              
              // Standalone view button
              Container(
                margin: const EdgeInsets.only(right: ZapchatTheme.spacing8),
                child: IconButton(
                  onPressed: () {
                    // Open chapter in standalone view
                    ref.read(selectedPublicationNotifierProvider.notifier)
                        .selectPublication(chapter.eventId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReaderScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    chapter.kind == 30041 ? Icons.note : Icons.article,
                    size: 20,
                    color: chapter.kind == 30041 
                        ? ZapchatTheme.accentPurple 
                        : ZapchatTheme.successGreen,
                  ),
                  tooltip: chapter.kind == 30041 ? 'Open Note' : 'Open Wiki',
                  style: IconButton.styleFrom(
                    backgroundColor: (chapter.kind == 30041 
                        ? ZapchatTheme.accentPurple 
                        : ZapchatTheme.successGreen).withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ZapchatTheme.radius8),
                    ),
                  ),
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year}';
  }
} 