// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventRepositoryHash() => r'a63944284660a112347d516cdc74a0766499e600';

/// See also [eventRepository].
@ProviderFor(eventRepository)
final eventRepositoryProvider = AutoDisposeProvider<EventRepository>.internal(
  eventRepository,
  name: r'eventRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EventRepositoryRef = AutoDisposeProviderRef<EventRepository>;
String _$nostrServiceHash() => r'991609369b86e1b3253a36d0794796f5ece12846';

/// See also [nostrService].
@ProviderFor(nostrService)
final nostrServiceProvider = AutoDisposeProvider<NostrService>.internal(
  nostrService,
  name: r'nostrServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$nostrServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NostrServiceRef = AutoDisposeProviderRef<NostrService>;
String _$authServiceHash() => r'e771c719cfb4bd87b7f15fc6722ef9f56a9844e4';

/// See also [authService].
@ProviderFor(authService)
final authServiceProvider = AutoDisposeProvider<AuthService>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthServiceRef = AutoDisposeProviderRef<AuthService>;
String _$contentTypeFilterNotifierHash() =>
    r'b390c0fd5eeb6198132d116d6d1cdd5a98f597b8';

/// See also [ContentTypeFilterNotifier].
@ProviderFor(ContentTypeFilterNotifier)
final contentTypeFilterNotifierProvider = AutoDisposeNotifierProvider<
    ContentTypeFilterNotifier, ContentType>.internal(
  ContentTypeFilterNotifier.new,
  name: r'contentTypeFilterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contentTypeFilterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ContentTypeFilterNotifier = AutoDisposeNotifier<ContentType>;
String _$publicationsNotifierHash() =>
    r'ce555cf29c432836aff379655428d5980725ca65';

/// See also [PublicationsNotifier].
@ProviderFor(PublicationsNotifier)
final publicationsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    PublicationsNotifier, List<NostrEvent>>.internal(
  PublicationsNotifier.new,
  name: r'publicationsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$publicationsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PublicationsNotifier = AutoDisposeAsyncNotifier<List<NostrEvent>>;
String _$searchNotifierHash() => r'05cd202d4110bbb34c035c1ed2c9f3a6b25f1cd3';

/// See also [SearchNotifier].
@ProviderFor(SearchNotifier)
final searchNotifierProvider =
    AutoDisposeNotifierProvider<SearchNotifier, String>.internal(
  SearchNotifier.new,
  name: r'searchNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchNotifier = AutoDisposeNotifier<String>;
String _$selectedPublicationNotifierHash() =>
    r'49219834bc95dbbcf119b2a567cf54d9fdf59afd';

/// See also [SelectedPublicationNotifier].
@ProviderFor(SelectedPublicationNotifier)
final selectedPublicationNotifierProvider = AutoDisposeNotifierProvider<
    SelectedPublicationNotifier, NostrEvent?>.internal(
  SelectedPublicationNotifier.new,
  name: r'selectedPublicationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedPublicationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedPublicationNotifier = AutoDisposeNotifier<NostrEvent?>;
String _$syncStatusNotifierHash() =>
    r'759e7811e7231521256e8d86d9822a384b3a24d6';

/// See also [SyncStatusNotifier].
@ProviderFor(SyncStatusNotifier)
final syncStatusNotifierProvider =
    AutoDisposeNotifierProvider<SyncStatusNotifier, bool>.internal(
  SyncStatusNotifier.new,
  name: r'syncStatusNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncStatusNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SyncStatusNotifier = AutoDisposeNotifier<bool>;
String _$authNotifierHash() => r'da031905fade807fa68378b88f1b88113b96907a';

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AuthNotifier, bool>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeAsyncNotifier<bool>;
String _$appInitializerHash() => r'4767419a2008543f045fd89601e3c33f2c2a1223';

/// See also [AppInitializer].
@ProviderFor(AppInitializer)
final appInitializerProvider =
    AutoDisposeAsyncNotifierProvider<AppInitializer, void>.internal(
  AppInitializer.new,
  name: r'appInitializerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appInitializerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppInitializer = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
