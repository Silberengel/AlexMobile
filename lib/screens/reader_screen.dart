import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/nostr_event.dart';
import '../providers/app_providers.dart';
import '../widgets/table_of_contents.dart';
import '../widgets/reading_progress.dart';
import '../theme/zapchat_theme.dart';
import '../services/markup_service.dart';
import '../providers/markup_provider.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showTableOfContents = false;
  double _readingProgress = 0.0;

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
    if (_scrollController.hasClients) {
      final progress = _scrollController.offset / 
          (_scrollController.position.maxScrollExtent - _scrollController.position.minScrollExtent);
      setState(() {
        _readingProgress = progress.clamp(0.0, 1.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final publication = ref.watch(selectedPublicationNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          publication?.title ?? 'Reading',
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          // Table of contents toggle
          Container(
            margin: const EdgeInsets.only(right: ZapchatTheme.spacing8),
            child: IconButton(
              icon: Icon(
                _showTableOfContents ? Icons.close : Icons.list,
                color: ZapchatTheme.primaryPurple,
              ),
              onPressed: () {
                setState(() {
                  _showTableOfContents = !_showTableOfContents;
                });
              },
            ),
          ),
          // Reading progress
          Container(
            margin: const EdgeInsets.only(right: ZapchatTheme.spacing16),
            child: ReadingProgressWidget(progress: _readingProgress),
          ),
        ],
      ),
      body: publication == null 
        ? _buildErrorState('No publication selected')
        : _buildReaderContent(publication),
    );
  }

  Widget _buildReaderContent(NostrEvent publication) {
    return Row(
      children: [
        // Main content
        Expanded(
          child: _buildPublicationContent(publication),
        ),
        // Table of contents (if shown)
        if (_showTableOfContents)
          Container(
            width: 300,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: TableOfContentsWidget(
              content: publication.content,
              onSectionSelected: (index) {
                // Scroll to section
                _scrollToSection(index);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPublicationContent(NostrEvent publication) {
          return SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(ZapchatTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Publication header
          _buildPublicationHeader(publication),
          
          const SizedBox(height: 32),
          
          // Publication content
          _buildPublicationBody(publication),
          
          const SizedBox(height: 32),
          
          // Publication footer
          _buildPublicationFooter(publication),
        ],
      ),
    );
  }

  Widget _buildPublicationHeader(NostrEvent publication) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          publication.title ?? 'Untitled',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Meta information
        Row(
          children: [
            // Author
            if (publication.authors?.isNotEmpty == true)
              Expanded(
                child: Text(
                  'By ${publication.authors!.join(', ')}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            
            // Date
            Text(
              _formatDate(publication.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Summary
        if (publication.summary?.isNotEmpty == true) ...[
          Text(
            publication.summary!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Cover image
        if (publication.image?.isNotEmpty == true)
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.only(bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: publication.image!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
          ),
        
        // Tags
        if (publication.tags_parsed?.isNotEmpty == true) ...[
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: publication.tags_parsed!.map((tag) {
              return Chip(
                label: Text(tag),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        
        const Divider(),
      ],
    );
  }

  Widget _buildPublicationBody(NostrEvent publication) {
    // Parse content for lazy loading
    final content = publication.content;
    final sections = _parseContentSections(content);
    
    return Column(
      children: sections.map((section) {
        return _buildContentSection(section, publication);
      }).toList(),
    );
  }

  Widget _buildContentSection(Map<String, dynamic> section, NostrEvent publication) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          if (section['title'] != null) ...[
            Text(
              section['title'],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Section content
          ref.read(markupServiceProvider).renderContent(
            section['content'],
            publication.kind,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildPublicationFooter(NostrEvent publication) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16),
        
        // Publication metadata
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 8),
            Text(
              'Published ${_formatDate(publication.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            Icon(
              Icons.person,
              size: 16,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 8),
            Text(
              'Author: ${_shortenPubkey(publication.pubkey)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(String error) {
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
            'Error loading publication',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
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

  // Helper methods
  List<Map<String, dynamic>> _parseContentSections(String content) {
    // Simple section parsing - in a real app, you'd want more sophisticated parsing
    final sections = <Map<String, dynamic>>[];
    
    // Split by headers
    final lines = content.split('\n');
    String currentSection = '';
    String currentTitle = '';
    
    for (final line in lines) {
      if (line.startsWith('#')) {
        // Save previous section
        if (currentSection.isNotEmpty) {
          sections.add({
            'title': currentTitle.isEmpty ? null : currentTitle,
            'content': currentSection.trim(),
          });
        }
        
        // Start new section
        currentTitle = line.replaceAll(RegExp(r'^#+\s*'), '');
        currentSection = line + '\n';
      } else {
        currentSection += line + '\n';
      }
    }
    
    // Add final section
    if (currentSection.isNotEmpty) {
      sections.add({
        'title': currentTitle.isEmpty ? null : currentTitle,
        'content': currentSection.trim(),
      });
    }
    
    return sections;
  }

  void _scrollToSection(int index) {
    // Implementation for scrolling to specific section
    // This would require more sophisticated content parsing
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year}';
  }

  String _shortenPubkey(String pubkey) {
    if (pubkey.length <= 12) return pubkey;
    return '${pubkey.substring(0, 6)}...${pubkey.substring(pubkey.length - 6)}';
  }
} 