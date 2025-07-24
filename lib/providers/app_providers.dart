import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../models/nostr_event_models.dart';

// Authentication provider
final authProvider = StateProvider<AuthState>((ref) => AuthState.anonymous);

// Content filter provider
final contentFilterProvider = StateProvider<ContentType>((ref) => ContentType.publications);

// Search provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Network status provider
final networkStatusProvider = StateProvider<NetworkStatus>((ref) => NetworkStatus.unknown);

// Relay connections provider
final relayConnectionsProvider = StateProvider<List<RelayConnection>>((ref) => []);

// Content provider with sample data using new Nostr event models
final contentProvider = StateProvider<List<NostrEvent>>((ref) => [
  // Sample PublicationIndex (Kind 30040)
  PublicationIndex(
    id: '1',
    pubkey: 'sample_pubkey_1',
    created_at: DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch ~/ 1000,
    kind: NostrEventKinds.publicationIndex,
    tags: [
      ['e', 'event_id_1'],
      ['e', 'event_id_2'],
      ['a', '30023:sample_pubkey_1:article_1'],
    ],
    content: jsonEncode({
      'title': 'A Meta-Analysis on the Association between Peptides and Cognitive Function',
      'description': 'Comprehensive meta-analysis examining peptide administration and cognitive performance',
      'image': 'https://via.placeholder.com/150/4A90E2/FFFFFF?text=A',
      'tags': ['neuroscience', 'peptides', 'cognitive', 'research'],
      'authors': ['Dr. Sarah Chen'],
      'metadata': {'version': '1.4'},
    }),
    title: 'A Meta-Analysis on the Association between Peptides and Cognitive Function',
  ),
  
  // Sample LongFormArticle (Kind 30023)
  LongFormArticle(
    id: '2',
    pubkey: 'sample_pubkey_2',
    created_at: DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch ~/ 1000,
    kind: NostrEventKinds.longFormContent,
    tags: [
      ['t', 'health'],
      ['t', 'chronicdisease'],
      ['t', 'epidemiology'],
    ],
    content: jsonEncode({
      'title': 'Why Chronic Disease Is Exploding!',
      'content': 'An investigation into the rising rates of chronic diseases and their underlying causes. This #health #chronicdisease #epidemiology study reveals alarming trends in modern healthcare.',
      'summary': 'Analysis of chronic disease trends',
      'tags': ['health', 'chronicdisease', 'epidemiology'],
      'metadata': {'version': '2.0'},
      'image': 'https://via.placeholder.com/150/4A90E2/FFFFFF?text=C',
    }),
    title: 'Why Chronic Disease Is Exploding!',
    articleContent: 'An investigation into the rising rates of chronic diseases and their underlying causes. This #health #chronicdisease #epidemiology study reveals alarming trends in modern healthcare.',
  ),
  
  // Sample Zettel (Kind 30041)
  Zettel(
    id: '3',
    pubkey: 'sample_pubkey_3',
    created_at: DateTime.now().subtract(const Duration(hours: 6)).millisecondsSinceEpoch ~/ 1000,
    kind: NostrEventKinds.zettel,
    tags: [
      ['t', 'philosophy'],
      ['t', 'psychology'],
      ['t', 'mimesis'],
      ['t', 'desire'],
    ],
    content: jsonEncode({
      'title': 'Desire Part 1: Mimesis',
      'content': 'An exploration of mimetic desire and its role in human behavior and society. This #philosophy #psychology #mimesis #desire analysis examines how we imitate others unconsciously.',
      'summary': 'Exploration of mimetic desire',
      'tags': ['philosophy', 'psychology', 'mimesis', 'desire'],
      'metadata': {},
    }),
    title: 'Desire Part 1: Mimesis',
    noteContent: 'An exploration of mimetic desire and its role in human behavior and society. This #philosophy #psychology #mimesis #desire analysis examines how we imitate others unconsciously.',
  ),
  
  // Sample WikiPage (Kind 30818)
  WikiPage(
    id: '4',
    pubkey: 'sample_pubkey_4',
    created_at: DateTime.now().subtract(const Duration(days: 5)).millisecondsSinceEpoch ~/ 1000,
    kind: NostrEventKinds.wiki,
    tags: [
      ['t', 'neuroscience'],
      ['t', 'brain'],
      ['t', 'biology'],
      ['t', 'science'],
    ],
    content: jsonEncode({
      'title': 'The Human Brain: A Comprehensive Guide',
      'content': 'An in-depth exploration of brain structure, function, and the latest neuroscience research. This #neuroscience #brain #biology #science wiki covers everything from neural pathways to cognitive functions.',
      'summary': 'Comprehensive guide to brain structure and function',
      'tags': ['neuroscience', 'brain', 'biology', 'science'],
      'metadata': {'version': '3.1'},
    }),
    title: 'The Human Brain: A Comprehensive Guide',
    wikiContent: 'An in-depth exploration of brain structure, function, and the latest neuroscience research. This #neuroscience #brain #biology #science wiki covers everything from neural pathways to cognitive functions.',
  ),
  
  // Sample DiscussionThread (Kind 11)
  DiscussionThread(
    id: '5',
    pubkey: 'sample_pubkey_5',
    created_at: DateTime.now().subtract(const Duration(hours: 12)).millisecondsSinceEpoch ~/ 1000,
    kind: NostrEventKinds.bulletinBoard,
    tags: [
      ['t', 'discussion'],
      ['t', 'community'],
    ],
    content: jsonEncode({
      'title': 'Relay Test: TheCitadel',
      'content': 'Testing relay functionality and connectivity...',
      'tags': ['discussion', 'community'],
    }),
    title: 'Relay Test: TheCitadel',
    threadContent: 'Testing relay functionality and connectivity...',
  ),
]);

// Profile provider
final profileProvider = StateProvider<UserProfile?>((ref) => null);

// Enums
enum AuthState { anonymous, authenticated, loading, error }
enum ContentType { publications, articles, wikis, notes }
enum NetworkStatus { online, offline, limited, unknown }

// Models
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
} 