import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../models/nostr_event_models.dart';
import '../models/nostr_models.dart';
import '../services/auth_service.dart';
import '../services/network_service.dart';
import '../services/database_service.dart';
import '../services/error_service.dart';

// Service providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final networkServiceProvider = Provider<NetworkService>((ref) => NetworkService());
final databaseServiceProvider = Provider<DatabaseService>((ref) => DatabaseService());
final errorServiceProvider = Provider<ErrorService>((ref) => ErrorService());

// Authentication state provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService, ref);
});

// Network status provider
final networkStatusProvider = StateNotifierProvider<NetworkStatusNotifier, NetworkStatus>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return NetworkStatusNotifier(networkService, ref);
});

// Relay connections provider
final relayConnectionsProvider = StateNotifierProvider<RelayConnectionsNotifier, List<RelayConnection>>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return RelayConnectionsNotifier(networkService, ref);
});

// User profile provider
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return UserProfileNotifier(authService, ref);
});

// Error provider
final errorProvider = StateNotifierProvider<ErrorNotifier, AppError?>((ref) {
  final errorService = ref.watch(errorServiceProvider);
  return ErrorNotifier(errorService, ref);
});

// Content filter provider
final contentFilterProvider = StateProvider<ContentType>((ref) => ContentType.publications);

// Search provider
final searchQueryProvider = StateProvider<String>((ref) => '');

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

// Content type enum
enum ContentType { publications, articles, wikis, notes }

// State notifiers
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final Ref _ref;

  AuthStateNotifier(this._authService, this._ref) : super(AuthState.anonymous) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _authService.initialize();
      if (_authService.isAuthenticated) {
        state = AuthState.authenticated;
      } else {
        state = AuthState.anonymous;
      }
    } catch (e) {
      state = AuthState.error;
      _ref.read(errorServiceProvider).reportAuthError('Failed to initialize authentication', details: e.toString());
    }
  }

  Future<void> loginWithAmber() async {
    state = AuthState.loading;
    try {
      final result = await _authService.loginWithAmber();
      if (result.success) {
        state = AuthState.authenticated;
        _ref.read(userProfileProvider.notifier).setProfile(result.profile!);
      } else {
        state = AuthState.error;
        _ref.read(errorServiceProvider).reportAuthError(result.error ?? 'Amber login failed');
      }
    } catch (e) {
      state = AuthState.error;
      _ref.read(errorServiceProvider).reportAuthError('Amber login failed', details: e.toString());
    }
  }

  Future<void> loginWithNpub(String npub) async {
    state = AuthState.loading;
    try {
      final result = await _authService.loginWithNpub(npub);
      if (result.success) {
        state = AuthState.authenticated;
        _ref.read(userProfileProvider.notifier).setProfile(result.profile!);
      } else {
        state = AuthState.error;
        _ref.read(errorServiceProvider).reportAuthError(result.error ?? 'Npub login failed');
      }
    } catch (e) {
      state = AuthState.error;
      _ref.read(errorServiceProvider).reportAuthError('Npub login failed', details: e.toString());
    }
  }

  Future<void> loginWithNsec(String nsec) async {
    state = AuthState.loading;
    try {
      final result = await _authService.loginWithNsec(nsec);
      if (result.success) {
        state = AuthState.authenticated;
        _ref.read(userProfileProvider.notifier).setProfile(result.profile!);
      } else {
        state = AuthState.error;
        _ref.read(errorServiceProvider).reportAuthError(result.error ?? 'Nsec login failed');
      }
    } catch (e) {
      state = AuthState.error;
      _ref.read(errorServiceProvider).reportAuthError('Nsec login failed', details: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      state = AuthState.anonymous;
      _ref.read(userProfileProvider.notifier).clearProfile();
    } catch (e) {
      _ref.read(errorServiceProvider).reportAuthError('Logout failed', details: e.toString());
    }
  }
}

class NetworkStatusNotifier extends StateNotifier<NetworkStatus> {
  final NetworkService _networkService;
  final Ref _ref;

  NetworkStatusNotifier(this._networkService, this._ref) : super(NetworkStatus.unknown) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _networkService.initialize();
      _networkService.statusStream.listen((status) {
        state = status;
      });
    } catch (e) {
      _ref.read(errorServiceProvider).reportNetworkError('Failed to initialize network monitoring', details: e.toString());
    }
  }
}

class RelayConnectionsNotifier extends StateNotifier<List<RelayConnection>> {
  final NetworkService _networkService;
  final Ref _ref;

  RelayConnectionsNotifier(this._networkService, this._ref) : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _networkService.relayStatusStream.listen((connections) {
        state = connections;
      });
    } catch (e) {
      _ref.read(errorServiceProvider).reportRelayError('Failed to initialize relay monitoring', details: e.toString());
    }
  }

  Future<void> addRelay(String url) async {
    try {
      await _networkService.addRelay(url);
    } catch (e) {
      _ref.read(errorServiceProvider).reportRelayError('Failed to add relay', details: e.toString());
    }
  }

  void removeRelay(String url) {
    try {
      _networkService.removeRelay(url);
    } catch (e) {
      _ref.read(errorServiceProvider).reportRelayError('Failed to remove relay', details: e.toString());
    }
  }
}

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final AuthService _authService;
  final Ref _ref;

  UserProfileNotifier(this._authService, this._ref) : super(null) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final profile = _authService.getCurrentProfile();
      if (profile != null) {
        state = profile;
      }
    } catch (e) {
      _ref.read(errorServiceProvider).reportAuthError('Failed to load user profile', details: e.toString());
    }
  }

  void setProfile(UserProfile profile) {
    state = profile;
  }

  void clearProfile() {
    state = null;
  }

  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? website,
    String? picture,
    String? nip05,
    String? lud16,
  }) async {
    try {
      await _authService.updateProfile(
        displayName: displayName,
        bio: bio,
        website: website,
        picture: picture,
        nip05: nip05,
        lud16: lud16,
      );
      
      // Refresh profile
      final updatedProfile = _authService.getCurrentProfile();
      if (updatedProfile != null) {
        state = updatedProfile;
      }
    } catch (e) {
      _ref.read(errorServiceProvider).reportAuthError('Failed to update profile', details: e.toString());
    }
  }
}

class ErrorNotifier extends StateNotifier<AppError?> {
  final ErrorService _errorService;
  final Ref _ref;

  ErrorNotifier(this._errorService, this._ref) : super(null) {
    _errorService.errorStream.listen((error) {
      state = error;
    });
  }

  void clearError() {
    state = null;
  }
} 