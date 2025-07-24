import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/nostr_event.dart';
import '../theme/zapchat_theme.dart';

class PublicationCard extends StatelessWidget {
  final NostrEvent publication;
  final VoidCallback onTap;

  const PublicationCard({
    super.key,
    required this.publication,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: ZapchatTheme.spacing16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ZapchatTheme.radius16),
        boxShadow: ZapchatTheme.shadowMedium,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            if (publication.image?.isNotEmpty == true)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
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
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    publication.title ?? 'Untitled',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Summary
                  if (publication.summary?.isNotEmpty == true) ...[
                    Text(
                      publication.summary!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // Meta information
                  Row(
                    children: [
                      // Content type indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ZapchatTheme.spacing6,
                          vertical: ZapchatTheme.spacing2,
                        ),
                        decoration: BoxDecoration(
                          color: _getContentTypeColor(publication.kind).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(ZapchatTheme.radius8),
                          border: Border.all(
                            color: _getContentTypeColor(publication.kind).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getContentTypeIcon(publication.kind),
                              size: 12,
                              color: _getContentTypeColor(publication.kind),
                            ),
                            const SizedBox(width: ZapchatTheme.spacing4),
                            Text(
                              _getContentTypeLabel(publication.kind),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: _getContentTypeColor(publication.kind),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Author
                      if (publication.authors?.isNotEmpty == true) ...[
                        Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            publication.authors!.join(', '),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                        _formatDate(publication.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Tags
                  if (publication.tags_parsed?.isNotEmpty == true) ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: publication.tags_parsed!.take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(ZapchatTheme.radius20),
                          ),
                          child: Text(
                            tag,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontSize: 10,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    if (publication.tags_parsed!.length > 3) ...[
                      const SizedBox(width: 8),
                      Text(
                        '+${publication.tags_parsed!.length - 3} more',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
  
  Color _getContentTypeColor(int kind) {
    switch (kind) {
      case 30040:
        return ZapchatTheme.primaryPurple;
      case 30023:
        return ZapchatTheme.secondaryPurple;
      case 30041:
        return ZapchatTheme.accentPurple;
      case 30818:
        return ZapchatTheme.successGreen;
      default:
        return ZapchatTheme.textSecondary;
    }
  }
  
  IconData _getContentTypeIcon(int kind) {
    switch (kind) {
      case 30040:
        return Icons.book;
      case 30023:
        return Icons.article;
      case 30041:
        return Icons.note;
      case 30818:
        return Icons.wiki;
      default:
        return Icons.library_books;
    }
  }
  
  String _getContentTypeLabel(int kind) {
    switch (kind) {
      case 30040:
        return 'Book';
      case 30023:
        return 'Article';
      case 30041:
        return 'Note';
      case 30818:
        return 'Wiki';
      default:
        return 'Content';
    }
  }
} 