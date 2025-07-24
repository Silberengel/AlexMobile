import 'package:flutter/material.dart';
import '../providers/app_providers.dart';
import '../models/nostr_event_models.dart';
import '../theme/app_theme.dart';

class PublicationCardWidget extends StatelessWidget {
  final NostrEvent event;

  const PublicationCardWidget({
    super.key,
    required this.event,
  });

  Map<String, dynamic> get eventData => _parseEventData();

  @override
  Widget build(BuildContext context) {
    final GlobalKey buttonKey = GlobalKey();
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 768; // Web/tablet layout
    
    return Card(
      elevation: 4,
      shadowColor: AppTheme.brandPurple.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      child: InkWell(
        onTap: () => _openPublication(context),
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail - Responsive height
                  Container(
                    height: isWideScreen ? 160 : 120, // Taller on web
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _getThumbnailColor(),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.brandPurple.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: eventData['thumbnail'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            eventData['thumbnail']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildThumbnailPlaceholder();
                            },
                          ),
                        )
                      : _buildThumbnailPlaceholder(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Title - More space for longer titles
                  Text(
                    eventData['title'] ?? 'Untitled',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: isWideScreen ? 18 : 16,
                    ),
                    maxLines: isWideScreen ? 4 : 3, // More lines on web
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Author
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: AppTheme.brandPurple,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          eventData['author'] ?? 'Unknown',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.brandPurple,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  // Enhanced content for web/wide screens
                  if (isWideScreen) ...[
                    const SizedBox(height: 12),
                    
                    // Summary/Content preview
                    if (eventData['type'] == ContentType.publications && eventData['summaryTags']?.isNotEmpty == true)
                      // For publications, show summary tags
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: (eventData['summaryTags'] as List<dynamic>?)
                            ?.take(5) // Limit to 5 summary tags
                            .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.brandPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.brandPurple.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: AppTheme.brandPurple,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ))
                            .toList() ?? [],
                      )
                    else if (eventData['content']?.isNotEmpty == true)
                      // For other content types, show content preview
                      Text(
                        _getContentPreview(eventData['content'] as String?),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    
                    const SizedBox(height: 12),
                    
                    // Metadata row
                    Row(
                      children: [
                        // Document type badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getTypeColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getTypeColor().withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getTypeIcon(),
                                size: 12,
                                color: _getTypeColor(),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getTypeLabel(),
                                style: TextStyle(
                                  color: _getTypeColor(),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // Version tag
                        if (eventData['version'] != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.brandPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.brandPurple.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tag,
                                  size: 12,
                                  color: AppTheme.brandPurple,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'v${eventData['version']}',
                                  style: TextStyle(
                                    color: AppTheme.brandPurple,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        const Spacer(),
                        
                        // Timestamp
                        Text(
                          _formatTimestamp(eventData['timestamp'] as DateTime?),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Hashtags (extracted from content or metadata)
                    if ((eventData['summaryTags'] as List<dynamic>?)?.isNotEmpty == true)
                      // Use summary tags if available
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: (eventData['summaryTags'] as List<dynamic>?)
                            ?.take(3) // Limit to 3 hashtags
                            .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.accentTurquoise.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppTheme.accentTurquoise.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: AppTheme.accentTurquoise,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                            .toList() ?? [],
                      )
                    else if (_extractHashtags(eventData['content'] as String?).isNotEmpty)
                      // Fallback to extracting from content
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _extractHashtags(eventData['content'] as String?)
                            .take(3) // Limit to 3 hashtags
                            .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.accentTurquoise.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppTheme.accentTurquoise.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: AppTheme.accentTurquoise,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                            .toList(),
                      ),
                  ] else ...[
                    // Mobile layout - just add version if available
                    if (eventData['version'] != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.tag,
                            size: 14,
                            color: AppTheme.brandPurple,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'v${eventData['version']}',
                            style: TextStyle(
                              color: AppTheme.brandPurple,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                  
                  // Spacer to push content to top and ensure proper spacing
                  const Spacer(),
                ],
              ),
            ),
            
            // Three-dot menu positioned in top-right
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                key: buttonKey,
                onTap: () => _showMenu(context, buttonKey),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.more_vert,
                    color: AppTheme.brandPurpleDark,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getContentPreview(String? content) {
    if (content == null) return '';
    // Remove markdown formatting and get first 150 characters
    String preview = content
        .replaceAll(RegExp(r'#+\s*'), '') // Remove headers
        .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1') // Remove bold
        .replaceAll(RegExp(r'\*(.*?)\*'), r'$1') // Remove italic
        .replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1') // Remove links
        .replaceAll(RegExp(r'`([^`]+)`'), r'$1') // Remove code
        .trim();
    
    if (preview.length > 150) {
      preview = '${preview.substring(0, 150)}...';
    }
    return preview;
  }

  List<String> _extractHashtags(String? content) {
    if (content == null) return [];
    final hashtagRegex = RegExp(r'#(\w+)');
    final matches = hashtagRegex.allMatches(content);
    return matches.map((match) => match.group(0)!).toList();
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return 'N/A';
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _getTypeLabel() {
    final type = eventData['type'] as ContentType?;
    if (type == null) return 'Publication';
    switch (type) {
      case ContentType.articles:
        return 'Article';
      case ContentType.wikis:
        return 'Wiki';
      case ContentType.notes:
        return 'Note';
      default:
        return 'Publication';
    }
  }

  Color _getTypeColor() {
    final type = eventData['type'] as ContentType?;
    if (type == null) return AppTheme.accentBlue;
    switch (type) {
      case ContentType.articles:
        return AppTheme.accentTurquoise;
      case ContentType.wikis:
        return AppTheme.accentHotPink;
      case ContentType.notes:
        return AppTheme.accentOrange;
      default:
        return AppTheme.accentBlue;
    }
  }

  IconData _getTypeIcon() {
    final type = eventData['type'] as ContentType?;
    if (type == null) return Icons.book;
    switch (type) {
      case ContentType.articles:
        return Icons.article;
      case ContentType.wikis:
        return Icons.menu_book;
      case ContentType.notes:
        return Icons.note;
      default:
        return Icons.book;
    }
  }

  Widget _buildThumbnailPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: _getThumbnailColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getThumbnailIcon(),
        size: 32,
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }

  Color _getThumbnailColor() {
    final type = eventData['type'] as ContentType?;
    if (type == null) return AppTheme.accentBlue;
    switch (type) {
      case ContentType.articles:
        return AppTheme.accentTurquoise;
      case ContentType.wikis:
        return AppTheme.accentHotPink;
      case ContentType.notes:
        return AppTheme.accentOrange;
      default:
        return AppTheme.accentBlue;
    }
  }

  IconData _getThumbnailIcon() {
    final type = eventData['type'] as ContentType?;
    if (type == null) return Icons.book;
    switch (type) {
      case ContentType.articles:
        return Icons.article;
      case ContentType.wikis:
        return Icons.menu_book;
      case ContentType.notes:
        return Icons.note;
      default:
        return Icons.book;
    }
  }

  Map<String, dynamic> _parseEventData() {
    try {
      final content = jsonDecode(event.content);
      final timestamp = DateTime.fromMillisecondsSinceEpoch(event.created_at * 1000);
      
      // Determine content type based on event kind
      ContentType contentType;
      switch (event.kind) {
        case NostrEventKinds.publicationIndex:
          contentType = ContentType.publications;
          break;
        case NostrEventKinds.longFormContent:
          contentType = ContentType.articles;
          break;
        case NostrEventKinds.wiki:
          contentType = ContentType.wikis;
          break;
        case NostrEventKinds.zettel:
          contentType = ContentType.notes;
          break;
        case NostrEventKinds.bulletinBoard:
          contentType = ContentType.notes; // Discussion threads as notes
          break;
        default:
          contentType = ContentType.publications;
      }
      
      return {
        'title': content['title'] ?? 'Untitled',
        'author': content['authors']?.first ?? 'Unknown',
        'content': content['content'] ?? content['description'] ?? '',
        'thumbnail': content['image'],
        'version': content['metadata']?['version'],
        'summaryTags': content['tags'] ?? [],
        'type': contentType,
        'timestamp': timestamp,
      };
    } catch (e) {
      // Fallback for malformed content
      return {
        'title': 'Untitled',
        'author': 'Unknown',
        'content': '',
        'thumbnail': null,
        'version': null,
        'summaryTags': [],
        'type': ContentType.publications,
        'timestamp': DateTime.fromMillisecondsSinceEpoch(event.created_at * 1000),
      };
    }
  }

  void _openPublication(BuildContext context) {
    // TODO: Navigate to publication reader
    _showToast(context, 'Opening: ${eventData['title'] ?? 'Untitled'}');
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'open':
        _openPublication(context);
        break;
      case 'share':
        // TODO: Implement share functionality
        _showToast(context, 'Share functionality coming soon');
        break;
      case 'bookmark':
        // TODO: Implement bookmark functionality
        _showToast(context, 'Bookmark functionality coming soon');
        break;
    }
  }

  void _showToast(BuildContext context, String message) {
    // Show a simple overlay message that doesn't interfere with keyboard
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.brandPurple,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the overlay after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void _showMenu(BuildContext context, GlobalKey buttonKey) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Get the button's position
    final RenderBox? buttonBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (buttonBox == null) return;
    
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final buttonPosition = buttonBox.localToGlobal(Offset.zero, ancestor: overlay);
    
    // Calculate position relative to the button
    final RelativeRect position = RelativeRect.fromLTRB(
      buttonPosition.dx,
      buttonPosition.dy + buttonBox.size.height + 4, // Below button with 4px spacing
      overlay.size.width - buttonPosition.dx - buttonBox.size.width,
      0,
    );
    
    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'open',
          child: Row(
            children: [
              Icon(Icons.open_in_new, color: AppTheme.brandPurpleDark, size: 18),
              const SizedBox(width: 8),
              Text(
                'Open',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share, color: AppTheme.brandPurpleDark, size: 18),
              const SizedBox(width: 8),
              Text(
                'Share',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'bookmark',
          child: Row(
            children: [
              Icon(Icons.bookmark_border, color: AppTheme.brandPurpleDark, size: 18),
              const SizedBox(width: 8),
              Text(
                'Bookmark',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
} 