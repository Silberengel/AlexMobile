import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/nostr_event.dart';

class EventRepository {
  late Isar _isar;
  bool _initialized = false;
  
  /// Initialize the Isar database
  Future<void> initialize() async {
    if (_initialized) return;
    
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [NostrEventSchema],
      directory: dir.path,
    );
    _initialized = true;
  }
  
  /// Save an event to local storage
  Future<void> saveEvent(NostrEvent event) async {
    await initialize();
    
    await _isar.writeTxn(() async {
      // Check if event already exists
      final existing = await _isar.nostrEvents
          .filter()
          .eventIdEqualTo(event.eventId)
          .findFirst();
      
      if (existing != null) {
        // Update existing event
        existing.content = event.content;
        existing.tags = event.tags;
        existing.lastSynced = DateTime.now();
        existing.relayUrl = event.relayUrl;
        
        // Update parsed fields
        if (event.kind == 0) {
          existing.name = event.name;
          existing.displayName = event.displayName;
          existing.picture = event.picture;
          existing.about = event.about;
          existing.website = event.website;
        } else if ([30023, 30040, 30041, 30818].contains(event.kind)) {
          existing.title = event.title;
          existing.summary = event.summary;
          existing.image = event.image;
          existing.authors = event.authors;
          existing.tags_parsed = event.tags_parsed;
          existing.publishedAt = event.publishedAt;
        }
        
        await _isar.nostrEvents.put(existing);
      } else {
        // Insert new event
        await _isar.nostrEvents.put(event);
      }
    });
  }
  
  /// Save a profile with special handling to prevent staleness
  Future<void> saveProfile(NostrEvent profile) async {
    await initialize();
    
    await _isar.writeTxn(() async {
      // Check if profile already exists
      final existing = await _isar.nostrEvents
          .filter()
          .pubkeyEqualTo(profile.pubkey)
          .and()
          .kindEqualTo(0)
          .findFirst();
      
      if (existing != null) {
        // Always update profile data to prevent staleness
        existing.content = profile.content;
        existing.tags = profile.tags;
        existing.lastSynced = DateTime.now();
        existing.relayUrl = profile.relayUrl;
        
        // Update profile fields
        existing.name = profile.name;
        existing.displayName = profile.displayName;
        existing.picture = profile.picture;
        existing.about = profile.about;
        existing.website = profile.website;
        
        await _isar.nostrEvents.put(existing);
      } else {
        // Insert new profile
        await _isar.nostrEvents.put(profile);
      }
    });
  }
  
  /// Get all publication events
  Future<List<NostrEvent>> getPublications({
    String? searchQuery,
    List<String>? tags,
    List<int>? kinds,
    int limit = 50,
    int offset = 0,
  }) async {
    await initialize();
    
    var query = _isar.nostrEvents
        .filter()
        .kindBetween(30023, 30818, includeLower: true, includeUpper: true);
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.titleContains(searchQuery, caseSensitive: false);
    }
    
    if (tags != null && tags.isNotEmpty) {
      // Filter by tags - this is a simplified implementation
      // In a real app, you'd want more sophisticated tag filtering
      query = query.tags_parsedElementContains(tags.first);
    }
    
    return await query
        .sortByCreatedAtDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
  }
  
  /// Get a specific publication by event ID
  Future<NostrEvent?> getPublication(String eventId) async {
    await initialize();
    
    return await _isar.nostrEvents
        .filter()
        .eventIdEqualTo(eventId)
        .kindBetween(30023, 30818, includeLower: true, includeUpper: true)
        .findFirst();
  }
  
  /// Get profile by pubkey with staleness check
  Future<NostrEvent?> getProfile(String pubkey) async {
    await initialize();
    
    final profile = await _isar.nostrEvents
        .filter()
        .pubkeyEqualTo(pubkey)
        .kindEqualTo(0)
        .findFirst();
    
    // Check if profile is stale (older than 1 hour)
    if (profile != null) {
      final lastSync = profile.lastSynced;
      if (lastSync != null) {
        final age = DateTime.now().difference(lastSync);
        if (age.inHours > 1) {
          // Mark profile as potentially stale
          print('Profile for $pubkey is stale (${age.inHours} hours old)');
        }
      }
    }
    
    return profile;
  }
  
  /// Get all profiles with staleness filtering
  Future<List<NostrEvent>> getProfiles({
    int limit = 100,
    int offset = 0,
    bool includeStale = false,
  }) async {
    await initialize();
    
    var query = _isar.nostrEvents
        .filter()
        .kindEqualTo(0);
    
    if (!includeStale) {
      // Only get profiles synced in the last 24 hours
      final cutoff = DateTime.now().subtract(const Duration(hours: 24));
      query = query.createdAtGreaterThan(cutoff.millisecondsSinceEpoch ~/ 1000);
    }
    
    return await query
        .sortByCreatedAtDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
  }
  
  /// Get stale profiles that need refreshing
  Future<List<NostrEvent>> getStaleProfiles({int limit = 50}) async {
    await initialize();
    
    final cutoff = DateTime.now().subtract(const Duration(hours: 1));
    
    return await _isar.nostrEvents
        .filter()
        .kindEqualTo(0)
        .createdAtLessThan(cutoff.millisecondsSinceEpoch ~/ 1000)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
  }
  
  /// Get profiles that haven't been synced recently
  Future<List<NostrEvent>> getProfilesNeedingSync({int limit = 50}) async {
    await initialize();
    
    final cutoff = DateTime.now().subtract(const Duration(hours: 6));
    
    return await _isar.nostrEvents
        .filter()
        .kindEqualTo(0)
        .createdAtLessThan(cutoff.millisecondsSinceEpoch ~/ 1000)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
  }
  
  /// Update profile last synced time
  Future<void> updateProfileLastSynced(String pubkey) async {
    await initialize();
    
    await _isar.writeTxn(() async {
      final profile = await _isar.nostrEvents
          .filter()
          .pubkeyEqualTo(pubkey)
          .and()
          .kindEqualTo(0)
          .findFirst();
      
      if (profile != null) {
        profile.lastSynced = DateTime.now();
        await _isar.nostrEvents.put(profile);
      }
    });
  }
  
  /// Search publications by content
  Future<List<NostrEvent>> searchPublications(String query, {List<int>? kinds}) async {
    await initialize();
    
    return await _isar.nostrEvents
        .filter()
        .kindBetween(30023, 30818, includeLower: true, includeUpper: true)
        .and()
        .group((q) => q
            .titleContains(query, caseSensitive: false)
            .or()
            .summaryContains(query, caseSensitive: false)
            .or()
            .contentContains(query, caseSensitive: false))
        .sortByCreatedAtDesc()
        .limit(50)
        .findAll();
  }
  
  /// Get last sync time for a relay
  Future<DateTime?> getLastSyncTime(String relay) async {
    await initialize();
    
    final event = await _isar.nostrEvents
        .filter()
        .relayUrlEqualTo(relay)
        .sortByCreatedAtDesc()
        .findFirst();
    
    return event?.lastSynced;
  }
  
  /// Get publication count
  Future<int> getPublicationCount() async {
    await initialize();
    
    return await _isar.nostrEvents
        .filter()
        .kindBetween(30023, 30818, includeLower: true, includeUpper: true)
        .count();
  }
  
  /// Get profile count
  Future<int> getProfileCount() async {
    await initialize();
    
    return await _isar.nostrEvents
        .filter()
        .kindEqualTo(0)
        .count();
  }
  
  /// Get stale profile count
  Future<int> getStaleProfileCount() async {
    await initialize();
    
    final cutoff = DateTime.now().subtract(const Duration(hours: 1));
    
    return await _isar.nostrEvents
        .filter()
        .kindEqualTo(0)
        .and()
        .lastSyncedLessThan(cutoff)
        .count();
  }
  
  /// Clear all data
  Future<void> clearAll() async {
    await initialize();
    
    await _isar.writeTxn(() async {
      await _isar.nostrEvents.clear();
    });
  }
  
  /// Clear stale profiles
  Future<void> clearStaleProfiles() async {
    await initialize();
    
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    
    await _isar.writeTxn(() async {
      final staleProfiles = await _isar.nostrEvents
          .filter()
          .kindEqualTo(0)
          .and()
          .lastSyncedLessThan(cutoff)
          .findAll();
      
      for (final profile in staleProfiles) {
        await _isar.nostrEvents.delete(profile.id);
      }
    });
  }
  
  /// Close the database
  Future<void> close() async {
    if (_initialized) {
      await _isar.close();
      _initialized = false;
    }
  }
} 