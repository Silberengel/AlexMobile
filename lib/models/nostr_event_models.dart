import 'dart:convert';

/// Core Nostr Event - Base structure for all Nostr events
class NostrEvent {
  final String id;           // 32-byte hex string
  final String pubkey;       // 32-byte hex string
  final int created_at;      // Unix timestamp in seconds
  final int kind;            // Event kind
  final List<List<String>> tags; // Array of tag arrays
  final String content;      // Event content
  final String? sig;         // 64-byte hex string

  NostrEvent({
    required this.id,
    required this.pubkey,
    required this.created_at,
    required this.kind,
    required this.tags,
    required this.content,
    this.sig,
  });

  factory NostrEvent.fromJson(Map<String, dynamic> json) {
    return NostrEvent(
      id: json['id'] as String,
      pubkey: json['pubkey'] as String,
      created_at: json['created_at'] as int,
      kind: json['kind'] as int,
      tags: List<List<String>>.from(
        (json['tags'] as List).map((tag) => List<String>.from(tag)),
      ),
      content: json['content'] as String,
      sig: json['sig'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pubkey': pubkey,
      'created_at': created_at,
      'kind': kind,
      'tags': tags,
      'content': content,
      if (sig != null) 'sig': sig,
    };
  }
}

/// Nostr Event Kinds used in Alexandria
class NostrEventKinds {
  // Core Nostr events
  static const int metadata = 0;              // User profile metadata
  static const int reaction = 7;              // Reactions (NIP-25)
  
  // Alexandria-specific events
  static const int publicationIndex = 30040;   // Publication indexes (NK-BIP-01)
  static const int zettel = 30041;            // Notes/Zettels (NK-BIP-01)
  static const int longFormContent = 30023;   // Long-form articles (NIP-23)
  static const int wiki = 30818;              // Wiki pages (NIP-54)
  
  // Social and interaction events
  static const int bulletinBoard = 11;        // Discussion threads
  static const int zap = 9735;                // Lightning zaps (NIP-57)
  static const int highlight = 9802;          // Content highlights (NIP-84)
  
  // List and organization events
  static const int muteList = 10000;          // Mute lists
  static const int pinnedNotes = 10001;       // Pinned notes
  static const int relayList = 10002;         // Relay lists
  static const int bookmark = 10003;          // Bookmarks
  static const int localRelays = 10432;       // Local relays
  static const int blockedRelays = 10006;     // Blocked relays
  
  // Content organization
  static const int label = 1985;              // Custom labels
  static const int report = 1984;             // Content reports (NIP-56)
}

/// User Profile (Kind 0)
class UserProfile extends NostrEvent {
  final String? displayName;
  final String? bio;
  final String? website;
  final String? picture;
  final String? nip05;
  final String? lud16;
  final String? name;

  UserProfile({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    this.displayName,
    this.bio,
    this.website,
    this.picture,
    this.nip05,
    this.lud16,
    this.name,
  });

  // Getter for npub (public key in bech32 format)
  String get npub => pubkey; // For now, using pubkey directly. In a real implementation, this would convert to bech32

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      pubkey: json['pubkey'] as String,
      created_at: json['created_at'] as int,
      kind: json['kind'] as int,
      tags: List<List<String>>.from(
        (json['tags'] as List).map((tag) => List<String>.from(tag)),
      ),
      content: json['content'] as String,
      sig: json['sig'] as String?,
      displayName: json['displayName'] as String?,
      bio: json['bio'] as String?,
      website: json['website'] as String?,
      picture: json['picture'] as String?,
      nip05: json['nip05'] as String?,
      lud16: json['lud16'] as String?,
      name: json['name'] as String?,
    );
  }

  factory UserProfile.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.metadata) {
      throw ArgumentError('UserProfile can only be created from kind 0 events');
    }

    Map<String, dynamic> profileData = {};
    try {
      profileData = Map<String, dynamic>.from(jsonDecode(event.content));
    } catch (e) {
      // Handle parsing errors
    }

    return UserProfile(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      displayName: profileData['display_name'],
      bio: profileData['bio'],
      website: profileData['website'],
      picture: profileData['picture'],
      nip05: profileData['nip05'],
      lud16: profileData['lud16'],
      name: profileData['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'displayName': displayName,
      'bio': bio,
      'website': website,
      'picture': picture,
      'nip05': nip05,
      'lud16': lud16,
      'name': name,
    });
    return baseJson;
  }
}

/// Publication Index (Kind 30040) - NK-BIP-01
class PublicationIndex extends NostrEvent {
  final String title;
  final String? description;
  final String? image;
  final List<String> contentTags;
  final List<String> authors;
  final Map<String, dynamic> metadata;
  final List<String> indexedEvents; // Event IDs from 'e' tags
  final List<String> indexedArticles; // Article addresses from 'a' tags

  PublicationIndex({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    required this.title,
    this.description,
    this.image,
    this.contentTags = const [],
    this.authors = const [],
    this.metadata = const {},
    this.indexedEvents = const [],
    this.indexedArticles = const [],
  });

  factory PublicationIndex.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.publicationIndex) {
      throw ArgumentError('PublicationIndex can only be created from kind 30040 events');
    }

    Map<String, dynamic> parsedContent = {};
    try {
      parsedContent = Map<String, dynamic>.from(jsonDecode(event.content));
    } catch (e) {
      // Handle parsing errors
    }

    // Extract indexed events from 'e' tags and articles from 'a' tags
    List<String> indexedEvents = [];
    List<String> indexedArticles = [];
    
    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'e':
            if (tag.length > 1) indexedEvents.add(tag[1]);
            break;
          case 'a':
            if (tag.length > 1) indexedArticles.add(tag[1]);
            break;
        }
      }
    }

    return PublicationIndex(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      title: parsedContent['title'] ?? '',
      description: parsedContent['description'],
      image: parsedContent['image'],
      contentTags: List<String>.from(parsedContent['tags'] ?? []),
      authors: List<String>.from(parsedContent['authors'] ?? []),
      metadata: Map<String, dynamic>.from(parsedContent['metadata'] ?? {}),
      indexedEvents: indexedEvents,
      indexedArticles: indexedArticles,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'title': title,
      'description': description,
      'image': image,
      'contentTags': contentTags,
      'authors': authors,
      'metadata': metadata,
      'indexedEvents': indexedEvents,
      'indexedArticles': indexedArticles,
    });
    return baseJson;
  }
}

/// Zettel/Note (Kind 30041) - NK-BIP-01
class Zettel extends NostrEvent {
  final String title;
  final String noteContent;
  final String? summary;
  final List<String> contentTags;
  final Map<String, dynamic> metadata;
  final String? parentId; // Reference to parent zettel
  final List<String> references; // Referenced zettels

  Zettel({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    required this.title,
    required this.noteContent,
    this.summary,
    this.contentTags = const [],
    this.metadata = const {},
    this.parentId,
    this.references = const [],
  });

  factory Zettel.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.zettel) {
      throw ArgumentError('Zettel can only be created from kind 30041 events');
    }

    Map<String, dynamic> parsedContent = {};
    try {
      parsedContent = Map<String, dynamic>.from(jsonDecode(event.content));
    } catch (e) {
      // Handle parsing errors
    }

    // Extract parent and references from tags
    String? parentId;
    List<String> references = [];
    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'e':
            if (tag.length > 1) {
              if (tag.length > 2 && tag[2] == 'reply') {
                parentId = tag[1];
              } else {
                references.add(tag[1]);
              }
            }
            break;
        }
      }
    }

    return Zettel(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      title: parsedContent['title'] ?? '',
      noteContent: parsedContent['content'] ?? '',
      summary: parsedContent['summary'],
      contentTags: List<String>.from(parsedContent['tags'] ?? []),
      metadata: Map<String, dynamic>.from(parsedContent['metadata'] ?? {}),
      parentId: parentId,
      references: references,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'title': title,
      'noteContent': noteContent,
      'summary': summary,
      'contentTags': contentTags,
      'metadata': metadata,
      'parentId': parentId,
      'references': references,
    });
    return baseJson;
  }
}

/// Long-form Article (Kind 30023) - NIP-23
class LongFormArticle extends NostrEvent {
  final String title;
  final String articleContent;
  final String? summary;
  final List<String> contentTags;
  final Map<String, dynamic> metadata;
  final String? image;
  final String? publishedAt;

  LongFormArticle({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    required this.title,
    required this.articleContent,
    this.summary,
    this.contentTags = const [],
    this.metadata = const {},
    this.image,
    this.publishedAt,
  });

  factory LongFormArticle.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.longFormContent) {
      throw ArgumentError('LongFormArticle can only be created from kind 30023 events');
    }

    Map<String, dynamic> parsedContent = {};
    try {
      parsedContent = Map<String, dynamic>.from(jsonDecode(event.content));
    } catch (e) {
      // Handle parsing errors
    }

    return LongFormArticle(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      title: parsedContent['title'] ?? '',
      articleContent: parsedContent['content'] ?? '',
      summary: parsedContent['summary'],
      contentTags: List<String>.from(parsedContent['tags'] ?? []),
      metadata: Map<String, dynamic>.from(parsedContent['metadata'] ?? {}),
      image: parsedContent['image'],
      publishedAt: parsedContent['published_at'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'title': title,
      'articleContent': articleContent,
      'summary': summary,
      'contentTags': contentTags,
      'metadata': metadata,
      'image': image,
      'publishedAt': publishedAt,
    });
    return baseJson;
  }
}

/// Wiki Page (Kind 30818) - NIP-54
class WikiPage extends NostrEvent {
  final String title;
  final String wikiContent;
  final String? summary;
  final List<String> contentTags;
  final Map<String, dynamic> metadata;
  final String? parentId;
  final List<String> references;

  WikiPage({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    required this.title,
    required this.wikiContent,
    this.summary,
    this.contentTags = const [],
    this.metadata = const {},
    this.parentId,
    this.references = const [],
  });

  factory WikiPage.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.wiki) {
      throw ArgumentError('WikiPage can only be created from kind 30818 events');
    }

    Map<String, dynamic> parsedContent = {};
    try {
      parsedContent = Map<String, dynamic>.from(jsonDecode(event.content));
    } catch (e) {
      // Handle parsing errors
    }

    // Extract parent and references from tags
    String? parentId;
    List<String> references = [];
    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'e':
            if (tag.length > 1) {
              if (tag.length > 2 && tag[2] == 'reply') {
                parentId = tag[1];
              } else {
                references.add(tag[1]);
              }
            }
            break;
        }
      }
    }

    return WikiPage(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      title: parsedContent['title'] ?? '',
      wikiContent: parsedContent['content'] ?? '',
      summary: parsedContent['summary'],
      contentTags: List<String>.from(parsedContent['tags'] ?? []),
      metadata: Map<String, dynamic>.from(parsedContent['metadata'] ?? {}),
      parentId: parentId,
      references: references,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'title': title,
      'wikiContent': wikiContent,
      'summary': summary,
      'contentTags': contentTags,
      'metadata': metadata,
      'parentId': parentId,
      'references': references,
    });
    return baseJson;
  }
}

/// Discussion Thread (Kind 11)
class DiscussionThread extends NostrEvent {
  final String title;
  final String threadContent;
  final List<String> contentTags;
  final String? parentId;
  final List<String> replies;

  DiscussionThread({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    required this.title,
    required this.threadContent,
    this.contentTags = const [],
    this.parentId,
    this.replies = const [],
  });

  factory DiscussionThread.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.bulletinBoard) {
      throw ArgumentError('DiscussionThread can only be created from kind 11 events');
    }

    Map<String, dynamic> parsedContent = {};
    try {
      parsedContent = Map<String, dynamic>.from(jsonDecode(event.content));
    } catch (e) {
      // Handle parsing errors
    }

    // Extract parent and replies from tags
    String? parentId;
    List<String> replies = [];
    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'e':
            if (tag.length > 1) {
              if (tag.length > 2 && tag[2] == 'reply') {
                parentId = tag[1];
              } else {
                replies.add(tag[1]);
              }
            }
            break;
        }
      }
    }

    return DiscussionThread(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      title: parsedContent['title'] ?? '',
      threadContent: parsedContent['content'] ?? '',
      contentTags: List<String>.from(parsedContent['tags'] ?? []),
      parentId: parentId,
      replies: replies,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'title': title,
      'threadContent': threadContent,
      'contentTags': contentTags,
      'parentId': parentId,
      'replies': replies,
    });
    return baseJson;
  }
}

/// Reaction (Kind 7) - NIP-25
class Reaction extends NostrEvent {
  final String reactedEventId;
  final String reaction; // Usually emoji
  final String? reactionContent;

  Reaction({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    required this.reactedEventId,
    required this.reaction,
    this.reactionContent,
  });

  factory Reaction.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.reaction) {
      throw ArgumentError('Reaction can only be created from kind 7 events');
    }

    String reactedEventId = '';
    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty && tag[0] == 'e' && tag.length > 1) {
        reactedEventId = tag[1];
        break;
      }
    }

    return Reaction(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      reactedEventId: reactedEventId,
      reaction: event.content,
      reactionContent: event.content,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'reactedEventId': reactedEventId,
      'reaction': reaction,
      'reactionContent': reactionContent,
    });
    return baseJson;
  }
}

/// Zap (Kind 9735) - NIP-57
class Zap extends NostrEvent {
  final String zappedEventId;
  final String? zappedAuthor;
  final int? amount;
  final String? comment;
  final String? bolt11;
  final String? preimage;

  Zap({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    required this.zappedEventId,
    this.zappedAuthor,
    this.amount,
    this.comment,
    this.bolt11,
    this.preimage,
  });

  factory Zap.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.zap) {
      throw ArgumentError('Zap can only be created from kind 9735 events');
    }

    String zappedEventId = '';
    String? zappedAuthor;
    int? amount;
    String? bolt11;
    String? preimage;

    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'e':
            if (tag.length > 1) zappedEventId = tag[1];
            break;
          case 'p':
            if (tag.length > 1) zappedAuthor = tag[1];
            break;
          case 'amount':
            if (tag.length > 1) amount = int.tryParse(tag[1]);
            break;
          case 'bolt11':
            if (tag.length > 1) bolt11 = tag[1];
            break;
          case 'preimage':
            if (tag.length > 1) preimage = tag[1];
            break;
        }
      }
    }

    return Zap(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      zappedEventId: zappedEventId,
      zappedAuthor: zappedAuthor,
      amount: amount,
      comment: event.content,
      bolt11: bolt11,
      preimage: preimage,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'zappedEventId': zappedEventId,
      'zappedAuthor': zappedAuthor,
      'amount': amount,
      'comment': comment,
      'bolt11': bolt11,
      'preimage': preimage,
    });
    return baseJson;
  }
}

/// Highlight (Kind 9802) - NIP-84
class Highlight extends NostrEvent {
  final String highlightedEventId;
  final String? highlightedAuthor;
  final String? highlightContent;
  final String? note;

  Highlight({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    required this.highlightedEventId,
    this.highlightedAuthor,
    this.highlightContent,
    this.note,
  });

  factory Highlight.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.highlight) {
      throw ArgumentError('Highlight can only be created from kind 9802 events');
    }

    String highlightedEventId = '';
    String? highlightedAuthor;

    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'e':
            if (tag.length > 1) highlightedEventId = tag[1];
            break;
          case 'p':
            if (tag.length > 1) highlightedAuthor = tag[1];
            break;
        }
      }
    }

    return Highlight(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      highlightedEventId: highlightedEventId,
      highlightedAuthor: highlightedAuthor,
      highlightContent: event.content,
      note: event.content,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'highlightedEventId': highlightedEventId,
      'highlightedAuthor': highlightedAuthor,
      'highlightContent': highlightContent,
      'note': note,
    });
    return baseJson;
  }
}

/// Mute List (Kind 10000)
class MuteList extends NostrEvent {
  final List<String> mutedPubkeys;
  final List<String> mutedHashtags;
  final List<String> mutedWords;

  MuteList({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    this.mutedPubkeys = const [],
    this.mutedHashtags = const [],
    this.mutedWords = const [],
  });

  factory MuteList.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.muteList) {
      throw ArgumentError('MuteList can only be created from kind 10000 events');
    }

    List<String> mutedPubkeys = [];
    List<String> mutedHashtags = [];
    List<String> mutedWords = [];

    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'p':
            if (tag.length > 1) mutedPubkeys.add(tag[1]);
            break;
          case 't':
            if (tag.length > 1) mutedHashtags.add(tag[1]);
            break;
          case 'word':
            if (tag.length > 1) mutedWords.add(tag[1]);
            break;
        }
      }
    }

    return MuteList(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      mutedPubkeys: mutedPubkeys,
      mutedHashtags: mutedHashtags,
      mutedWords: mutedWords,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'mutedPubkeys': mutedPubkeys,
      'mutedHashtags': mutedHashtags,
      'mutedWords': mutedWords,
    });
    return baseJson;
  }
}

/// Pinned Notes List (Kind 10001)
class PinnedNotesList extends NostrEvent {
  final List<String> pinnedEventIds;

  PinnedNotesList({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    this.pinnedEventIds = const [],
  });

  factory PinnedNotesList.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.pinnedNotes) {
      throw ArgumentError('PinnedNotesList can only be created from kind 10001 events');
    }

    List<String> pinnedEventIds = [];
    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty && tag[0] == 'e' && tag.length > 1) {
        pinnedEventIds.add(tag[1]);
      }
    }

    return PinnedNotesList(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      pinnedEventIds: pinnedEventIds,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'pinnedEventIds': pinnedEventIds,
    });
    return baseJson;
  }
}

/// Relay List (Kind 10002)
class RelayList extends NostrEvent {
  final Map<String, RelayInfo> relays;

  RelayList({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    this.relays = const {},
  });

  factory RelayList.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.relayList) {
      throw ArgumentError('RelayList can only be created from kind 10002 events');
    }

    Map<String, RelayInfo> relays = {};
    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty && tag[0] == 'r' && tag.length > 1) {
        String url = tag[1];
        String permission = tag.length > 2 ? tag[2] : 'read';
        relays[url] = RelayInfo(url: url, permission: permission);
      }
    }

    return RelayList(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      relays: relays,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'relays': relays.map((key, value) => MapEntry(key, value.toJson())),
    });
    return baseJson;
  }
}

/// Blocked Relays List (Kind 10006)
class BlockedRelaysList extends NostrEvent {
  final List<String> blockedRelays;

  BlockedRelaysList({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    this.blockedRelays = const [],
  });

  factory BlockedRelaysList.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.blockedRelays) {
      throw ArgumentError('BlockedRelaysList can only be created from kind 10006 events');
    }

    List<String> blockedRelays = [];
    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty && tag[0] == 'r' && tag.length > 1) {
        blockedRelays.add(tag[1]);
      }
    }

    return BlockedRelaysList(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      blockedRelays: blockedRelays,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'blockedRelays': blockedRelays,
    });
    return baseJson;
  }
}

/// Local Relays List (Kind 10432)
class LocalRelaysList extends NostrEvent {
  final List<String> localRelays;

  LocalRelaysList({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    this.localRelays = const [],
  });

  factory LocalRelaysList.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.localRelays) {
      throw ArgumentError('LocalRelaysList can only be created from kind 10432 events');
    }

    List<String> localRelays = [];
    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty && tag[0] == 'r' && tag.length > 1) {
        localRelays.add(tag[1]);
      }
    }

    return LocalRelaysList(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      localRelays: localRelays,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'localRelays': localRelays,
    });
    return baseJson;
  }
}

/// Bookmark (Kind 10003)
class Bookmark extends NostrEvent {
  final List<String> bookmarkedEventIds;
  final List<String> contentTags;

  Bookmark({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    this.bookmarkedEventIds = const [],
    this.contentTags = const [],
  });

  factory Bookmark.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.bookmark) {
      throw ArgumentError('Bookmark can only be created from kind 10003 events');
    }

    List<String> bookmarkedEventIds = [];
    List<String> contentTags = [];

    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'e':
            if (tag.length > 1) bookmarkedEventIds.add(tag[1]);
            break;
          case 't':
            if (tag.length > 1) contentTags.add(tag[1]);
            break;
        }
      }
    }

    return Bookmark(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      bookmarkedEventIds: bookmarkedEventIds,
      contentTags: contentTags,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'bookmarkedEventIds': bookmarkedEventIds,
      'contentTags': contentTags,
    });
    return baseJson;
  }
}

/// Label (Kind 1985)
class Label extends NostrEvent {
  final String label;
  final List<String> labeledEventIds;
  final String? namespace;

  Label({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    required this.label,
    this.labeledEventIds = const [],
    this.namespace,
  });

  factory Label.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.label) {
      throw ArgumentError('Label can only be created from kind 1985 events');
    }

    String label = event.content;
    List<String> labeledEventIds = [];
    String? namespace;

    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'e':
            if (tag.length > 1) labeledEventIds.add(tag[1]);
            break;
          case 'l':
            if (tag.length > 1) label = tag[1];
            if (tag.length > 2) namespace = tag[2];
            break;
        }
      }
    }

    return Label(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      label: label,
      labeledEventIds: labeledEventIds,
      namespace: namespace,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'label': label,
      'labeledEventIds': labeledEventIds,
      'namespace': namespace,
    });
    return baseJson;
  }
}

/// Report (Kind 1984) - NIP-56
class Report extends NostrEvent {
  final String reportedEventId;
  final String? reportedAuthor;
  final String reason;
  final String? reportContent;

  Report({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    required this.reportedEventId,
    this.reportedAuthor,
    required this.reason,
    this.reportContent,
  });

  factory Report.fromNostrEvent(NostrEvent event) {
    if (event.kind != NostrEventKinds.report) {
      throw ArgumentError('Report can only be created from kind 1984 events');
    }

    String reportedEventId = '';
    String? reportedAuthor;
    String reason = '';

    for (List<String> tag in event.tags) {
      if (tag.isNotEmpty) {
        switch (tag[0]) {
          case 'e':
            if (tag.length > 1) reportedEventId = tag[1];
            break;
          case 'p':
            if (tag.length > 1) reportedAuthor = tag[1];
            break;
          case 'report':
            if (tag.length > 1) reason = tag[1];
            break;
        }
      }
    }

    return Report(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      reportedEventId: reportedEventId,
      reportedAuthor: reportedAuthor,
      reason: reason,
      reportContent: event.content,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'reportedEventId': reportedEventId,
      'reportedAuthor': reportedAuthor,
      'reason': reason,
      'reportContent': reportContent,
    });
    return baseJson;
  }
}

/// Relay Info helper class
class RelayInfo {
  final String url;
  final String permission; // 'read', 'write', or 'read'

  RelayInfo({
    required this.url,
    required this.permission,
  });

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'permission': permission,
    };
  }
}

// Helper function for JSON decoding
Map<String, dynamic> jsonDecode(String jsonString) {
  try {
    return Map<String, dynamic>.from(json.decode(jsonString));
  } catch (e) {
    return {};
  }
} 