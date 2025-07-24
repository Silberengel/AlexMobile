import 'package:isar/isar.dart';
import 'dart:convert';

part 'nostr_event.g.dart';

@collection
class NostrEvent {
  Id id = Isar.autoIncrement;
  
  @Index()
  String eventId;
  
  @Index()
  String pubkey;
  
  @Index()
  int kind;
  
  int createdAt;
  
  String content;
  
  @Index()
  List<String> tags;
  
  String? relayUrl;
  
  // For publications (kind 30023, 30040, 30041, 30818)
  String? title;
  String? summary;
  String? image;
  List<String>? authors;
  List<String>? tags_parsed;
  String? publishedAt;
  
  // For 30040 index events
  List<String>? chapterIds; // List of 30041/30818 event IDs in order
  String? indexType; // "book", "course", "collection", etc.
  
  // Content type classification
  String? contentType; // "article", "note", "wiki", "index"
  
  // For profiles (kind 0)
  String? name;
  String? displayName;
  String? picture;
  String? about;
  String? website;
  
  // Metadata
  DateTime? lastSynced;
  bool isLocal = false;
  
  NostrEvent({
    required this.eventId,
    required this.pubkey,
    required this.kind,
    required this.createdAt,
    required this.content,
    required this.tags,
    this.relayUrl,
    this.title,
    this.summary,
    this.image,
    this.authors,
    this.tags_parsed,
    this.publishedAt,
    this.chapterIds,
    this.indexType,
    this.contentType,
    this.name,
    this.displayName,
    this.picture,
    this.about,
    this.website,
    this.lastSynced,
    this.isLocal = false,
  });
  
  factory NostrEvent.fromJson(Map<String, dynamic> json) {
    final event = NostrEvent(
      eventId: json['id'] ?? '',
      pubkey: json['pubkey'] ?? '',
      kind: json['kind'] ?? 0,
      createdAt: json['created_at'] ?? 0,
      content: json['content'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
    
    // Parse content based on kind
    switch (event.kind) {
      case 0: // Profile
        final profile = _parseProfileContent(event.content);
        event.name = profile['name'];
        event.displayName = profile['display_name'];
        event.picture = profile['picture'];
        event.about = profile['about'];
        event.website = profile['website'];
        break;
        
      case 30023: // Standalone articles in NostrMarkup
        final publication = _parsePublicationContent(event.content);
        event.title = publication['title'];
        event.summary = publication['summary'];
        event.image = publication['image'];
        event.authors = publication['authors'];
        event.tags_parsed = publication['tags'];
        event.publishedAt = publication['published_at'];
        event.contentType = 'article';
        break;
        
      case 30040: // Index/Table of Contents
        final publication = _parsePublicationContent(event.content);
        event.title = publication['title'];
        event.summary = publication['summary'];
        event.image = publication['image'];
        event.authors = publication['authors'];
        event.tags_parsed = publication['tags'];
        event.publishedAt = publication['published_at'];
        event.chapterIds = publication['chapter_ids'];
        event.indexType = publication['index_type'];
        event.contentType = 'index';
        break;
        
      case 30041: // Notes (can be standalone or part of index)
        final publication = _parsePublicationContent(event.content);
        event.title = publication['title'];
        event.summary = publication['summary'];
        event.image = publication['image'];
        event.authors = publication['authors'];
        event.tags_parsed = publication['tags'];
        event.publishedAt = publication['published_at'];
        event.contentType = 'note';
        break;
        
      case 30818: // Wikis (can be standalone or part of index)
        final publication = _parsePublicationContent(event.content);
        event.title = publication['title'];
        event.summary = publication['summary'];
        event.image = publication['image'];
        event.authors = publication['authors'];
        event.tags_parsed = publication['tags'];
        event.publishedAt = publication['published_at'];
        event.contentType = 'wiki';
        break;
    }
    
    return event;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': eventId,
      'pubkey': pubkey,
      'kind': kind,
      'created_at': createdAt,
      'content': content,
      'tags': tags,
      'relay_url': relayUrl,
      'title': title,
      'summary': summary,
      'image': image,
      'authors': authors,
      'tags_parsed': tags_parsed,
      'published_at': publishedAt,
      'name': name,
      'display_name': displayName,
      'picture': picture,
      'about': about,
      'website': website,
      'last_synced': lastSynced?.toIso8601String(),
      'is_local': isLocal,
    };
  }
  
  static Map<String, String?> _parseProfileContent(String content) {
    try {
      final Map<String, dynamic> profile = Map<String, dynamic>.from(
        jsonDecode(content),
      );
      return {
        'name': profile['name'],
        'display_name': profile['display_name'],
        'picture': profile['picture'],
        'about': profile['about'],
        'website': profile['website'],
      };
    } catch (e) {
      return {};
    }
  }
  
  static Map<String, dynamic> _parsePublicationContent(String content) {
    try {
      final Map<String, dynamic> publication = Map<String, dynamic>.from(
        jsonDecode(content),
      );
      return {
        'title': publication['title'],
        'summary': publication['summary'],
        'image': publication['image'],
        'authors': publication['authors']?.cast<String>(),
        'tags': publication['tags']?.cast<String>(),
        'published_at': publication['published_at'],
      };
    } catch (e) {
      return {};
    }
  }
} 