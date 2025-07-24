import 'dart:convert';
import '../models/nostr_event.dart';
import '../repositories/event_repository.dart';

class DemoDataService {
  final EventRepository _repository;
  
  DemoDataService(this._repository);
  
  /// Populate the database with demo data
  Future<void> populateDemoData() async {
    await _repository.initialize();
    
    // Create demo publications
    final demoPublications = [
      _createDemoArticle(),
      _createDemoWiki(),
      _createDemoIndex(),
      _createDemoNote(),
    ];
    
    for (final publication in demoPublications) {
      await _repository.saveEvent(publication);
    }
    
    print('Demo data populated successfully');
  }
  
  /// Create a demo article (30023)
  NostrEvent _createDemoArticle() {
    return NostrEvent(
      eventId: 'demo_article_1',
      pubkey: 'npub1demo123456789',
      kind: 30023,
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      content: jsonEncode({
        'title': 'Getting Started with Nostr',
        'content': '''# Getting Started with Nostr :smile:

Welcome to the world of Nostr! This is a **decentralized** social media protocol.

## What is Nostr?

Nostr is a *simple, open protocol* that enables global, decentralized, and censorship-resistant social media.

## Key Features

- **Decentralized**: No central servers
- **Censorship-resistant**: Content can't be easily blocked
- **Simple**: Easy to implement and use

## Nostr Identifiers

Check out these Nostr identifiers:
- npub1abc123def456ghi789jkl012mno345pqr678stu901vwx234yz
- nostr:nevent1def456ghi789jkl012mno345pqr678stu901vwx234yz

## References

See [[NIP-01]] for the basic protocol specification.
See [[NIP-23]] for long-form content.

## Footnotes

This is a test article[^1] with footnotes.

[^1]: This is a footnote explaining something important.

## Code Example

```javascript
// Simple Nostr client
const nostr = {
  connect: (relay) => {
    console.log(`Connecting to ${relay}`);
  },
  publish: (event) => {
    console.log('Publishing event:', event);
  }
};
```''',
        'summary': 'A comprehensive introduction to the Nostr protocol',
        'image': 'https://example.com/nostr-intro.jpg',
        'authors': ['Alice', 'Bob'],
        'tags': ['nostr', 'tutorial', 'decentralized'],
        'published_at': DateTime.now().toIso8601String(),
      }),
      tags: ['d', 'demo_article_1', 't', 'nostr', 't', 'tutorial'],
      title: 'Getting Started with Nostr',
      summary: 'A comprehensive introduction to the Nostr protocol',
      image: 'https://example.com/nostr-intro.jpg',
      authors: ['Alice', 'Bob'],
      tags_parsed: ['nostr', 'tutorial', 'decentralized'],
      publishedAt: DateTime.now().toIso8601String(),
      contentType: 'article',
    );
  }
  
  /// Create a demo wiki (30818)
  NostrEvent _createDemoWiki() {
    return NostrEvent(
      eventId: 'demo_wiki_1',
      pubkey: 'npub1demo123456789',
      kind: 30818,
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      content: jsonEncode({
        'title': 'Nostr Protocol Wiki',
        'content': '''= Nostr Protocol Wiki

== Overview

The Nostr protocol is a simple, open protocol that enables global, decentralized, and censorship-resistant social media.

== Protocol Details

=== Event Structure

Events have the following structure:

[source,json]
----
{
  "id": "event_id",
  "pubkey": "public_key",
  "created_at": 1234567890,
  "kind": 1,
  "tags": [],
  "content": "event content",
  "sig": "signature"
}
----

=== Event Kinds

* **0**: Metadata
* **1**: Text Note
* **30023**: Long-form Content
* **30040**: Index
* **30041**: Publication Section
* **30818**: Wiki

== Implementation

=== Client Libraries

link:https://github.com/nostr-protocol/nostr[Official Nostr Libraries]

=== Relay Software

link:https://github.com/fiatjaf/relayer[Relayer] - A simple relay implementation

== Best Practices

IMPORTANT: Always validate signatures before processing events.

CAUTION: Be careful with private key management.

TIP: Use multiple relays for redundancy and censorship resistance.''',
        'summary': 'Comprehensive documentation of the Nostr protocol',
        'image': 'https://example.com/nostr-wiki.jpg',
        'authors': ['Nostr Community'],
        'tags': ['nostr', 'wiki', 'documentation'],
        'published_at': DateTime.now().toIso8601String(),
      }),
      tags: ['d', 'demo_wiki_1', 't', 'nostr', 't', 'wiki'],
      title: 'Nostr Protocol Wiki',
      summary: 'Comprehensive documentation of the Nostr protocol',
      image: 'https://example.com/nostr-wiki.jpg',
      authors: ['Nostr Community'],
      tags_parsed: ['nostr', 'wiki', 'documentation'],
      publishedAt: DateTime.now().toIso8601String(),
      contentType: 'wiki',
    );
  }
  
  /// Create a demo index (30040)
  NostrEvent _createDemoIndex() {
    return NostrEvent(
      eventId: 'demo_index_1',
      pubkey: 'npub1demo123456789',
      kind: 30040,
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      content: jsonEncode({
        'title': 'Nostr Learning Path',
        'content': 'A comprehensive learning path for Nostr developers',
        'summary': 'Complete guide to learning Nostr development',
        'image': 'https://example.com/nostr-learning.jpg',
        'authors': ['Nostr Academy'],
        'tags': ['nostr', 'learning', 'course'],
        'published_at': DateTime.now().toIso8601String(),
        'chapter_ids': ['demo_article_1', 'demo_wiki_1', 'demo_note_1'],
        'index_type': 'course',
      }),
      tags: ['d', 'demo_index_1', 't', 'nostr', 't', 'course'],
      title: 'Nostr Learning Path',
      summary: 'Complete guide to learning Nostr development',
      image: 'https://example.com/nostr-learning.jpg',
      authors: ['Nostr Academy'],
      tags_parsed: ['nostr', 'learning', 'course'],
      publishedAt: DateTime.now().toIso8601String(),
      chapterIds: ['demo_article_1', 'demo_wiki_1', 'demo_note_1'],
      indexType: 'course',
      contentType: 'index',
    );
  }
  
  /// Create a demo note (30041)
  NostrEvent _createDemoNote() {
    return NostrEvent(
      eventId: 'demo_note_1',
      pubkey: 'npub1demo123456789',
      kind: 30041,
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      content: jsonEncode({
        'title': 'Quick Nostr Tips',
        'content': '''= Quick Nostr Tips

== Security Best Practices

NOTE: Always use strong private keys.

WARNING: Never share your private key.

TIP: Use multiple relays for redundancy.

== Development Tips

[source,javascript]
----
// Always validate events
function validateEvent(event) {
  // Check signature
  // Verify timestamp
  // Validate content
}
----

== Common Mistakes

CAUTION: Don't trust single relays.

IMPORTANT: Always verify signatures.''',
        'summary': 'Quick tips for Nostr developers',
        'image': 'https://example.com/nostr-tips.jpg',
        'authors': ['Nostr Tips'],
        'tags': ['nostr', 'tips', 'development'],
        'published_at': DateTime.now().toIso8601String(),
      }),
      tags: ['d', 'demo_note_1', 't', 'nostr', 't', 'tips'],
      title: 'Quick Nostr Tips',
      summary: 'Quick tips for Nostr developers',
      image: 'https://example.com/nostr-tips.jpg',
      authors: ['Nostr Tips'],
      tags_parsed: ['nostr', 'tips', 'development'],
      publishedAt: DateTime.now().toIso8601String(),
      contentType: 'note',
    );
  }
}

 