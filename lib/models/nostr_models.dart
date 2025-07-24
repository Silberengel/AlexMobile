import 'package:flutter/foundation.dart';

/// Nostr Event - Core data structure for all Nostr events
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
  static const int textNote = 1;
  static const int longFormContent = 30023;  // NIP-23
  static const int publication = 30040;       // Alexandria publications
  static const int publicationWithMetadata = 30041; // Alexandria publications with metadata
  static const int wiki = 30818;              // NIP-54
  static const int reaction = 7;              // NIP-25
  static const int list = 30000;              // NIP-51
  static const int report = 1984;             // NIP-56
  static const int highlight = 9802;          // NIP-84
}

/// Alexandria Publication - Extends NostrEvent for publication-specific data
class AlexandriaPublication extends NostrEvent {
  final String title;
  final String author;
  final String? version;
  final String? thumbnail;
  final List<String> summaryTags;
  final Map<String, dynamic> metadata;
  final PublicationType type;

  AlexandriaPublication({
    required super.id,
    required super.pubkey,
    required super.created_at,
    required super.kind,
    required super.tags,
    required super.content,
    super.sig,
    required this.title,
    required this.author,
    this.version,
    this.thumbnail,
    this.summaryTags = const [],
    this.metadata = const {},
    required this.type,
  });

  factory AlexandriaPublication.fromNostrEvent(NostrEvent event) {
    // Parse content based on kind
    Map<String, dynamic> parsedContent = {};
    try {
      parsedContent = Map<String, dynamic>.from(
        jsonDecode(event.content),
      );
    } catch (e) {
      // Handle non-JSON content
    }

    // Determine publication type based on kind
    PublicationType type;
    switch (event.kind) {
      case NostrEventKinds.longFormContent:
        type = PublicationType.articles;
        break;
      case NostrEventKinds.wiki:
        type = PublicationType.wikis;
        break;
      case NostrEventKinds.publication:
      case NostrEventKinds.publicationWithMetadata:
        type = PublicationType.publications;
        break;
      default:
        type = PublicationType.notes;
    }

    return AlexandriaPublication(
      id: event.id,
      pubkey: event.pubkey,
      created_at: event.created_at,
      kind: event.kind,
      tags: event.tags,
      content: event.content,
      sig: event.sig,
      title: parsedContent['title'] ?? '',
      author: parsedContent['author'] ?? '',
      version: parsedContent['version'],
      thumbnail: parsedContent['thumbnail'],
      summaryTags: List<String>.from(parsedContent['summaryTags'] ?? []),
      metadata: Map<String, dynamic>.from(parsedContent['metadata'] ?? {}),
      type: type,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'title': title,
      'author': author,
      'version': version,
      'thumbnail': thumbnail,
      'summaryTags': summaryTags,
      'metadata': metadata,
      'type': type.toString(),
    });
    return baseJson;
  }
}

/// Publication Types
enum PublicationType {
  publications,  // Kind 30040/30041
  articles,      // Kind 30023
  wikis,         // Kind 30818
  notes,         // Kind 1
}

/// Relay Connection Model
class RelayConnection {
  final String url;
  final bool isConnected;
  final bool isInbox;
  final bool isOutbox;
  final int responseTime;
  final double successRate;
  final DateTime lastConnected;

  RelayConnection({
    required this.url,
    this.isConnected = false,
    this.isInbox = true,
    this.isOutbox = true,
    this.responseTime = 0,
    this.successRate = 0.0,
    required this.lastConnected,
  });

  factory RelayConnection.fromJson(Map<String, dynamic> json) {
    return RelayConnection(
      url: json['url'] as String,
      isConnected: json['isConnected'] as bool? ?? false,
      isInbox: json['isInbox'] as bool? ?? true,
      isOutbox: json['isOutbox'] as bool? ?? true,
      responseTime: json['responseTime'] as int? ?? 0,
      successRate: (json['successRate'] as num?)?.toDouble() ?? 0.0,
      lastConnected: DateTime.parse(json['lastConnected'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'isConnected': isConnected,
      'isInbox': isInbox,
      'isOutbox': isOutbox,
      'responseTime': responseTime,
      'successRate': successRate,
      'lastConnected': lastConnected.toIso8601String(),
    };
  }
}

/// User Profile Model (NIP-05 compatible)
class UserProfile {
  final String npub;
  final String? displayName;
  final String? bio;
  final String? website;
  final String? picture;
  final String? nip05;
  final String? lud16;

  UserProfile({
    required this.npub,
    this.displayName,
    this.bio,
    this.website,
    this.picture,
    this.nip05,
    this.lud16,
  });

  factory UserProfile.fromNostrEvent(NostrEvent event) {
    if (event.kind != 0) {
      throw ArgumentError('UserProfile can only be created from kind 0 events');
    }

    Map<String, dynamic> profileData = {};
    try {
      profileData = Map<String, dynamic>.from(jsonDecode(event.content));
    } catch (e) {
      // Handle parsing errors
    }

    return UserProfile(
      npub: event.pubkey,
      displayName: profileData['display_name'],
      bio: profileData['bio'],
      website: profileData['website'],
      picture: profileData['picture'],
      nip05: profileData['nip05'],
      lud16: profileData['lud16'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'npub': npub,
      'displayName': displayName,
      'bio': bio,
      'website': website,
      'picture': picture,
      'nip05': nip05,
      'lud16': lud16,
    };
  }
}

/// Network Status Enum
enum NetworkStatus {
  online,
  offline,
  limited,
  unknown,
}

/// Authentication State Enum
enum AuthState {
  anonymous,
  authenticated,
  loading,
  error,
}

// Helper function for JSON decoding
Map<String, dynamic> jsonDecode(String jsonString) {
  // This would need proper JSON decoding implementation
  // For now, returning empty map
  return {};
} 