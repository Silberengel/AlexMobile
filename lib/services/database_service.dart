import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/nostr_event_models.dart';
import '../models/nostr_models.dart';

class DatabaseService {
  static const String _eventsBoxName = 'nostr_events';
  static const String _profilesBoxName = 'user_profiles';
  static const String _settingsBoxName = 'app_settings';
  static const String _cacheBoxName = 'content_cache';
  static const String _readingProgressBoxName = 'reading_progress';
  
  late Box _eventsBox;
  late Box _profilesBox;
  late Box _settingsBox;
  late Box _cacheBox;
  late Box _readingProgressBox;
  
  bool _isInitialized = false;
  
  // Database version for migrations
  static const int _currentVersion = 1;
  
  // Initialize database
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Open all boxes
      _eventsBox = await Hive.openBox(_eventsBoxName);
      _profilesBox = await Hive.openBox(_profilesBoxName);
      _settingsBox = await Hive.openBox(_settingsBoxName);
      _cacheBox = await Hive.openBox(_cacheBoxName);
      _readingProgressBox = await Hive.openBox(_readingProgressBoxName);
      
      // Check and perform migrations if needed
      await _performMigrations();
      
      _isInitialized = true;
    } catch (e) {
      throw DatabaseException('Failed to initialize database: $e');
    }
  }
  
  // Perform database migrations
  Future<void> _performMigrations() async {
    final currentVersion = _settingsBox.get('db_version', defaultValue: 0);
    
    if (currentVersion < _currentVersion) {
      // Perform migrations based on version
      if (currentVersion < 1) {
        await _migrateToVersion1();
      }
      
      // Update version
      await _settingsBox.put('db_version', _currentVersion);
    }
  }
  
  // Migration to version 1
  Future<void> _migrateToVersion1() async {
    // Add any version 1 specific migrations here
    // For now, just ensure proper box structure
  }
  
  // Event storage methods
  Future<void> storeEvent(NostrEvent event) async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      await _eventsBox.put(event.id, jsonEncode(event.toJson()));
    } catch (e) {
      throw DatabaseException('Failed to store event: $e');
    }
  }
  
  Future<void> storeEvents(List<NostrEvent> events) async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      final batch = _eventsBox.toMap();
      for (final event in events) {
        batch[event.id] = jsonEncode(event.toJson());
      }
      await _eventsBox.putAll(batch);
    } catch (e) {
      throw DatabaseException('Failed to store events: $e');
    }
  }
  
  NostrEvent? getEvent(String eventId) {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      final eventData = _eventsBox.get(eventId);
      if (eventData != null) {
        return NostrEvent.fromJson(jsonDecode(eventData));
      }
      return null;
    } catch (e) {
      throw DatabaseException('Failed to retrieve event: $e');
    }
  }
  
  List<NostrEvent> getEventsByKind(int kind) {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      final events = <NostrEvent>[];
      for (final entry in _eventsBox.values) {
        final eventData = jsonDecode(entry);
        if (eventData['kind'] == kind) {
          events.add(NostrEvent.fromJson(eventData));
        }
      }
      return events;
    } catch (e) {
      throw DatabaseException('Failed to retrieve events by kind: $e');
    }
  }
  
  List<NostrEvent> getEventsByAuthor(String pubkey) {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      final events = <NostrEvent>[];
      for (final entry in _eventsBox.values) {
        final eventData = jsonDecode(entry);
        if (eventData['pubkey'] == pubkey) {
          events.add(NostrEvent.fromJson(eventData));
        }
      }
      return events;
    } catch (e) {
      throw DatabaseException('Failed to retrieve events by author: $e');
    }
  }
  
  // Profile storage methods
  Future<void> storeProfile(UserProfile profile) async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      await _profilesBox.put(profile.npub, jsonEncode(profile.toJson()));
    } catch (e) {
      throw DatabaseException('Failed to store profile: $e');
    }
  }
  
  UserProfile? getProfile(String npub) {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      final profileData = _profilesBox.get(npub);
      if (profileData != null) {
        return UserProfile.fromJson(jsonDecode(profileData));
      }
      return null;
    } catch (e) {
      throw DatabaseException('Failed to retrieve profile: $e');
    }
  }
  
  // Settings storage methods
  Future<void> storeSetting(String key, dynamic value) async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      await _settingsBox.put(key, value);
    } catch (e) {
      throw DatabaseException('Failed to store setting: $e');
    }
  }
  
  T? getSetting<T>(String key, {T? defaultValue}) {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      return _settingsBox.get(key, defaultValue: defaultValue);
    } catch (e) {
      throw DatabaseException('Failed to retrieve setting: $e');
    }
  }
  
  // Cache storage methods
  Future<void> cacheContent(String key, Map<String, dynamic> content) async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      await _cacheBox.put(key, jsonEncode(content));
    } catch (e) {
      throw DatabaseException('Failed to cache content: $e');
    }
  }
  
  Map<String, dynamic>? getCachedContent(String key) {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      final contentData = _cacheBox.get(key);
      if (contentData != null) {
        return Map<String, dynamic>.from(jsonDecode(contentData));
      }
      return null;
    } catch (e) {
      throw DatabaseException('Failed to retrieve cached content: $e');
    }
  }
  
  // Reading progress storage methods
  Future<void> storeReadingProgress(String eventId, double progress) async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      await _readingProgressBox.put(eventId, progress);
    } catch (e) {
      throw DatabaseException('Failed to store reading progress: $e');
    }
  }
  
  double getReadingProgress(String eventId) {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      return _readingProgressBox.get(eventId, defaultValue: 0.0);
    } catch (e) {
      throw DatabaseException('Failed to retrieve reading progress: $e');
    }
  }
  
  // Clear reading progress
  Future<void> clearReadingProgress(String eventId) async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      await _readingProgressBox.delete(eventId);
    } catch (e) {
      throw DatabaseException('Failed to clear reading progress: $e');
    }
  }
  
  // Clear all reading progress
  Future<void> clearAllReadingProgress() async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      await _readingProgressBox.clear();
    } catch (e) {
      throw DatabaseException('Failed to clear all reading progress: $e');
    }
  }
  
  // Database maintenance methods
  Future<void> clearCache() async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      await _cacheBox.clear();
    } catch (e) {
      throw DatabaseException('Failed to clear cache: $e');
    }
  }
  
  Future<void> clearEvents() async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      await _eventsBox.clear();
    } catch (e) {
      throw DatabaseException('Failed to clear events: $e');
    }
  }
  
  Future<void> clearProfiles() async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      await _profilesBox.clear();
    } catch (e) {
      throw DatabaseException('Failed to clear profiles: $e');
    }
  }
  
  // Get database statistics
  Map<String, int> getDatabaseStats() {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      return {
        'events': _eventsBox.length,
        'profiles': _profilesBox.length,
        'settings': _settingsBox.length,
        'cached_content': _cacheBox.length,
        'reading_progress': _readingProgressBox.length,
      };
    } catch (e) {
      throw DatabaseException('Failed to get database stats: $e');
    }
  }
  
  // Export data
  Future<Map<String, dynamic>> exportData() async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      final events = <Map<String, dynamic>>[];
      for (final entry in _eventsBox.values) {
        events.add(jsonDecode(entry));
      }
      
      final profiles = <Map<String, dynamic>>[];
      for (final entry in _profilesBox.values) {
        profiles.add(jsonDecode(entry));
      }
      
      return {
        'version': _currentVersion,
        'exported_at': DateTime.now().toIso8601String(),
        'events': events,
        'profiles': profiles,
        'settings': _settingsBox.toMap(),
        'reading_progress': _readingProgressBox.toMap(),
      };
    } catch (e) {
      throw DatabaseException('Failed to export data: $e');
    }
  }
  
  // Import data
  Future<void> importData(Map<String, dynamic> data) async {
    if (!_isInitialized) throw DatabaseException('Database not initialized');
    
    try {
      // Clear existing data
      await _eventsBox.clear();
      await _profilesBox.clear();
      await _settingsBox.clear();
      await _readingProgressBox.clear();
      
      // Import events
      if (data['events'] != null) {
        for (final eventData in data['events']) {
          await _eventsBox.put(eventData['id'], jsonEncode(eventData));
        }
      }
      
      // Import profiles
      if (data['profiles'] != null) {
        for (final profileData in data['profiles']) {
          await _profilesBox.put(profileData['npub'], jsonEncode(profileData));
        }
      }
      
      // Import settings
      if (data['settings'] != null) {
        await _settingsBox.putAll(Map<String, dynamic>.from(data['settings']));
      }
      
      // Import reading progress
      if (data['reading_progress'] != null) {
        await _readingProgressBox.putAll(Map<String, dynamic>.from(data['reading_progress']));
      }
    } catch (e) {
      throw DatabaseException('Failed to import data: $e');
    }
  }
  
  // Close database
  Future<void> close() async {
    if (!_isInitialized) return;
    
    try {
      await _eventsBox.close();
      await _profilesBox.close();
      await _settingsBox.close();
      await _cacheBox.close();
      await _readingProgressBox.close();
      _isInitialized = false;
    } catch (e) {
      throw DatabaseException('Failed to close database: $e');
    }
  }
}

// Database exception
class DatabaseException implements Exception {
  final String message;
  
  DatabaseException(this.message);
  
  @override
  String toString() => 'DatabaseException: $message';
} 