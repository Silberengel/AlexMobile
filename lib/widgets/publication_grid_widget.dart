import 'package:flutter/material.dart';
import '../providers/app_providers.dart';
import '../models/nostr_event_models.dart';
import 'publication_card_widget.dart';

class PublicationGridWidget extends StatelessWidget {
  final List<NostrEvent> events;
  final ContentType filter;
  final String searchQuery;

  const PublicationGridWidget({
    super.key,
    required this.events,
    required this.filter,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    // Filter events based on content type and search query
    final filteredEvents = events.where((event) {
      // Filter by content type
      if (filter != ContentType.publications) {
        final eventType = _getEventContentType(event);
        if (eventType != filter) {
          return false;
        }
      }
      
      // Filter by search query
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final eventData = _parseEventData(event);
        
        return eventData['title'].toLowerCase().contains(query) ||
               eventData['author'].toLowerCase().contains(query) ||
               eventData['content'].toLowerCase().contains(query) ||
               (eventData['summaryTags'] as List<dynamic>).any((tag) => tag.toLowerCase().contains(query));
      }
      
      return true;
    }).toList();

    if (filteredEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              searchQuery.isNotEmpty 
                ? 'No publications found for "$searchQuery"'
                : 'No publications available',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isWideScreen = screenWidth > 768;
        
        // Responsive card dimensions
        double cardWidth;
        double cardHeight;
        double spacing;
        double padding;
        
        if (isWideScreen) {
          // Web/tablet layout - larger cards with more content
          cardWidth = 280.0;
          cardHeight = 420.0; // Taller for enhanced content
          spacing = 20.0;
          padding = 24.0;
        } else {
          // Mobile layout - compact cards
          cardWidth = 160.0;
          cardHeight = 256.0;
          spacing = 16.0;
          padding = 16.0;
        }
        
        // Calculate how many cards can fit in a row
        final availableWidth = screenWidth - (padding * 2);
        final cardsPerRow = (availableWidth / (cardWidth + spacing)).floor();
        
        // Determine responsive layout:
        // - Mobile (narrow): 2 cards max
        // - Medium: 3 cards max  
        // - Wide: 4-5 cards max
        int actualCardsPerRow;
        if (screenWidth < 600) {
          // Mobile: max 2 cards
          actualCardsPerRow = cardsPerRow.clamp(1, 2);
        } else if (screenWidth < 900) {
          // Medium: max 3 cards
          actualCardsPerRow = cardsPerRow.clamp(2, 3);
        } else if (screenWidth < 1200) {
          // Wide: max 4 cards
          actualCardsPerRow = cardsPerRow.clamp(3, 4);
        } else {
          // Extra wide: max 5 cards
          actualCardsPerRow = cardsPerRow.clamp(4, 5);
        }
        
        return GridView.builder(
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: actualCardsPerRow,
            childAspectRatio: cardWidth / cardHeight,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: filteredEvents.length,
          itemBuilder: (context, index) {
            return PublicationCardWidget(
              event: filteredEvents[index],
            );
          },
        );
      },
    );
  }

  ContentType _getEventContentType(NostrEvent event) {
    switch (event.kind) {
      case NostrEventKinds.publicationIndex:
        return ContentType.publications;
      case NostrEventKinds.longFormContent:
        return ContentType.articles;
      case NostrEventKinds.wiki:
        return ContentType.wikis;
      case NostrEventKinds.zettel:
      case NostrEventKinds.bulletinBoard:
        return ContentType.notes;
      default:
        return ContentType.publications;
    }
  }

  Map<String, dynamic> _parseEventData(NostrEvent event) {
    try {
      final content = jsonDecode(event.content);
      
      return {
        'title': content['title'] ?? 'Untitled',
        'author': content['authors']?.first ?? 'Unknown',
        'content': content['content'] ?? content['description'] ?? '',
        'summaryTags': content['tags'] ?? [],
      };
    } catch (e) {
      return {
        'title': 'Untitled',
        'author': 'Unknown',
        'content': '',
        'summaryTags': [],
      };
    }
  }
} 