import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/nostr_event.dart';
import '../repositories/event_repository.dart';
import '../services/nostr_service.dart';
import '../services/auth_service.dart';
import '../services/demo_data_service.dart';
import '../widgets/content_type_filter.dart';

part 'app_providers.g.dart';

// Repository provider
@riverpod
EventRepository eventRepository(EventRepositoryRef ref) {
  return EventRepository();
}

// Nostr service provider
@riverpod
NostrService nostrService(NostrServiceRef ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return NostrService(repository);
}

// Auth service provider
@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

// Content type filter provider
@riverpod
class ContentTypeFilterNotifier extends _$ContentTypeFilterNotifier {
  @override
  ContentType build() {
    return ContentType.all;
  }
  
  void setContentType(ContentType type) {
    state = type;
  }
}

// Publications provider
@riverpod
class PublicationsNotifier extends _$PublicationsNotifier {
  @override
  Future<List<NostrEvent>> build() async {
    final repository = ref.read(eventRepositoryProvider);
    final contentType = ref.watch(contentTypeFilterNotifierProvider);
    final kinds = getKindsFromContentType(contentType);
    return await repository.getPublications(kinds: kinds);
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(eventRepositoryProvider);
      final contentType = ref.read(contentTypeFilterNotifierProvider);
      final kinds = getKindsFromContentType(contentType);
      return await repository.getPublications(kinds: kinds);
    });
  }
  
  Future<void> search(String query) async {
    if (query.isEmpty) {
      await refresh();
      return;
    }
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(eventRepositoryProvider);
      final contentType = ref.read(contentTypeFilterNotifierProvider);
      final kinds = getKindsFromContentType(contentType);
      return await repository.searchPublications(query, kinds: kinds);
    });
  }
  
  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is AsyncData && currentState.value != null) {
      final repository = ref.read(eventRepositoryProvider);
      final contentType = ref.read(contentTypeFilterNotifierProvider);
      final kinds = getKindsFromContentType(contentType);
      final morePublications = await repository.getPublications(
        kinds: kinds,
        offset: currentState.value!.length,
      );
      
      if (morePublications.isNotEmpty) {
        state = AsyncValue.data([...currentState.value!, ...morePublications]);
      }
    }
  }
}

// Search provider
@riverpod
class SearchNotifier extends _$SearchNotifier {
  @override
  String build() {
    return '';
  }
  
  void updateQuery(String query) {
    state = query;
  }
}

// Selected publication provider
@riverpod
class SelectedPublicationNotifier extends _$SelectedPublicationNotifier {
  @override
  NostrEvent? build() {
    return null;
  }
  
  Future<void> selectPublication(String eventId) async {
    state = null; // Clear current selection
    state = await AsyncValue.guard(() async {
      final repository = ref.read(eventRepositoryProvider);
      return await repository.getPublication(eventId);
    }).then((value) => value.value);
  }
  
  void clearSelection() {
    state = null;
  }
}

// Sync status provider
@riverpod
class SyncStatusNotifier extends _$SyncStatusNotifier {
  @override
  bool build() {
    return false;
  }
  
  void setSyncing(bool syncing) {
    state = syncing;
  }
}

// User authentication provider
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<bool> build() async {
    final authService = ref.read(authServiceProvider);
    return await authService.isAuthenticated();
  }
  
  Future<void> login() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      return await authService.login();
    });
  }
  
  Future<void> logout() async {
    state = const AsyncValue.loading();
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    state = await AsyncValue.guard(() async {
      return await authService.isAuthenticated();
    });
  }
}

// App initialization provider
@riverpod
class AppInitializer extends _$AppInitializer {
  @override
  Future<void> build() async {
    // Initialize repositories and services
    final repository = ref.read(eventRepositoryProvider);
    await repository.initialize();
    
    // Populate with demo data if empty
    final count = await repository.getPublicationCount();
    if (count == 0) {
      final demoService = DemoDataService(repository);
      await demoService.populateDemoData();
    }
    
    final nostrService = ref.read(nostrServiceProvider);
    await nostrService.initialize();
    
    // Check for local relay
    if (await nostrService.isLocalRelayAvailable()) {
      await nostrService.connectToLocalRelay();
    }
  }
} 