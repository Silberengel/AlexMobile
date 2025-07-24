import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import '../models/nostr_event_models.dart';

class AuthService {
  static const String _authBoxName = 'auth';
  static const String _keyName = 'nostr_key';
  static const String _profileName = 'user_profile';
  
  late Box _authBox;
  UserProfile? _currentProfile;
  String? _currentNsec;
  
  // Authentication methods
  static const String amberLogin = 'amber';
  static const String npubLogin = 'npub';
  static const String nsecLogin = 'nsec';
  
  Future<void> initialize() async {
    _authBox = await Hive.openBox(_authBoxName);
    await _loadStoredProfile();
  }
  
  // Load stored profile from local storage
  Future<void> _loadStoredProfile() async {
    final profileData = _authBox.get(_profileName);
    if (profileData != null) {
      try {
        final profileMap = Map<String, dynamic>.from(jsonDecode(profileData));
        _currentProfile = UserProfile(
          id: _generateRandomId(),
          pubkey: profileMap['npub'] ?? '',
          created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          kind: 0,
          tags: [],
          content: jsonEncode(profileMap),
        );
      } catch (e) {
        // Handle parsing errors
        _currentProfile = null;
      }
    }
    
    // Load stored nsec if available
    _currentNsec = _authBox.get(_keyName);
  }
  
  // Save profile to local storage
  Future<void> _saveProfile(UserProfile profile) async {
    await _authBox.put(_profileName, jsonEncode(profile.toJson()));
    _currentProfile = profile;
  }
  
  // Save nsec to encrypted local storage
  Future<void> _saveNsec(String nsec) async {
    // In a real implementation, this would be encrypted
    await _authBox.put(_keyName, nsec);
    _currentNsec = nsec;
  }
  
  // Amber login (platform-specific)
  Future<AuthResult> loginWithAmber() async {
    try {
      if (kIsWeb) {
        // Web: Show QR code and nostrconnect:// link
        return AuthResult.error('Web Amber login not yet implemented');
      } else if (Platform.isAndroid) {
        // Android: Open Amber app
        return _loginWithAmberAndroid();
      } else {
        // Other platforms: Not supported
        return AuthResult.error('Amber login not supported on this platform');
      }
    } catch (e) {
      return AuthResult.error('Amber login failed: $e');
    }
  }
  
  // Android-specific Amber login
  Future<AuthResult> _loginWithAmberAndroid() async {
    try {
      // TODO: Implement actual Amber app integration
      // For now, simulate the process
      await Future.delayed(const Duration(seconds: 2));
      
      // Generate a mock profile for demo
      final mockProfile = UserProfile(
        id: _generateRandomId(),
        pubkey: _generateRandomNpub(),
        created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        kind: 0,
        tags: [],
        content: jsonEncode({
          'displayName': 'Amber User',
          'bio': 'Connected via Amber',
          'picture': 'https://example.com/amber-avatar.png',
        }),
        displayName: 'Amber User',
        bio: 'Connected via Amber',
        picture: 'https://example.com/amber-avatar.png',
      );
      
      await _saveProfile(mockProfile);
      
      return AuthResult.success(mockProfile);
    } catch (e) {
      return AuthResult.error('Android Amber login failed: $e');
    }
  }
  
  // Web-specific Amber login
  Future<AuthResult> _loginWithAmberWeb() async {
    try {
      // TODO: Implement QR code and nostrconnect:// link generation
      // For now, return error
      return AuthResult.error('Web Amber login not yet implemented');
    } catch (e) {
      return AuthResult.error('Web Amber login failed: $e');
    }
  }
  
  // Npub-only login (public key only)
  Future<AuthResult> loginWithNpub(String npub) async {
    try {
      if (!_isValidNpub(npub)) {
        return AuthResult.error('Invalid npub format');
      }
      
      // Create a minimal profile with just the npub
      final profile = UserProfile(
        id: _generateRandomId(),
        pubkey: npub,
        created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        kind: 0,
        tags: [],
        content: jsonEncode({'npub': npub}),
      );
      await _saveProfile(profile);
      
      return AuthResult.success(profile);
    } catch (e) {
      return AuthResult.error('Npub login failed: $e');
    }
  }
  
  // Nsec login with encrypted local storage
  Future<AuthResult> loginWithNsec(String nsec) async {
    try {
      if (!_isValidNsec(nsec)) {
        return AuthResult.error('Invalid nsec format');
      }
      
      // For demo purposes, use the nsec as the pubkey
      // In a real implementation, you would derive the public key from the private key
      final npub = nsec;
      
      // Create profile
      final profile = UserProfile(
        id: _generateRandomId(),
        pubkey: npub,
        created_at: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        kind: 0,
        tags: [],
        content: jsonEncode({
          'npub': npub,
          'nsec': nsec,
        }),
      );
      
      await _saveProfile(profile);
      await _saveNsec(nsec);
      
      return AuthResult.success(profile);
    } catch (e) {
      return AuthResult.error('Nsec login failed: $e');
    }
  }
  
  // Logout
  Future<void> logout() async {
    await _authBox.clear();
    _currentProfile = null;
    _currentNsec = null;
  }
  
  // Get current profile
  UserProfile? getCurrentProfile() => _currentProfile;
  
  // Get current nsec (if available)
  String? getCurrentNsec() => _currentNsec;
  
  // Check if user is authenticated
  bool get isAuthenticated => _currentProfile != null;
  
  // Check if user has private key access
  bool get hasPrivateKey => _currentNsec != null;
  
  // Validate npub format
  bool _isValidNpub(String npub) {
    // Remove any whitespace
    final cleanNpub = npub.trim();
    
    // Check if it's a bech32 npub (starts with npub1)
    if (cleanNpub.startsWith('npub1')) {
      // Basic bech32 validation - should be 63 characters total (5 prefix + 58 data)
      return cleanNpub.length == 63 && RegExp(r'^npub1[a-zA-Z0-9]+$').hasMatch(cleanNpub);
    }
    
    // Check if it's a hex format (64 characters)
    if (cleanNpub.length == 64) {
      return RegExp(r'^[0-9a-fA-F]+$').hasMatch(cleanNpub);
    }
    
    return false;
  }
  
  // Validate nsec format
  bool _isValidNsec(String nsec) {
    // Remove any whitespace
    final cleanNsec = nsec.trim();
    
    // Check if it's a bech32 nsec (starts with nsec1)
    if (cleanNsec.startsWith('nsec1')) {
      // Basic bech32 validation - should be 63 characters total (5 prefix + 58 data)
      return cleanNsec.length == 63 && RegExp(r'^nsec1[a-zA-Z0-9]+$').hasMatch(cleanNsec);
    }
    
    // Check if it's a hex format (64 characters)
    if (cleanNsec.length == 64) {
      return RegExp(r'^[0-9a-fA-F]+$').hasMatch(cleanNsec);
    }
    
    return false;
  }
  
  // Generate random npub for demo purposes
  String _generateRandomNpub() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
  
  // Generate random event ID for demo purposes
  String _generateRandomId() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
  
  // Update profile metadata
  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? website,
    String? picture,
    String? nip05,
    String? lud16,
  }) async {
    if (_currentProfile == null) return;
    
    final updatedProfile = UserProfile(
      id: _currentProfile!.id,
      pubkey: _currentProfile!.npub,
      created_at: _currentProfile!.created_at,
      kind: _currentProfile!.kind,
      tags: _currentProfile!.tags,
      content: _currentProfile!.content,
      sig: _currentProfile!.sig,
      displayName: displayName ?? _currentProfile!.displayName,
      bio: bio ?? _currentProfile!.bio,
      website: website ?? _currentProfile!.website,
      picture: picture ?? _currentProfile!.picture,
      nip05: nip05 ?? _currentProfile!.nip05,
      lud16: lud16 ?? _currentProfile!.lud16,
      name: _currentProfile!.name,
    );
    
    await _saveProfile(updatedProfile);
  }
}

// Authentication result
class AuthResult {
  final bool success;
  final UserProfile? profile;
  final String? error;
  
  AuthResult._({
    required this.success,
    this.profile,
    this.error,
  });
  
  factory AuthResult.success(UserProfile profile) {
    return AuthResult._(success: true, profile: profile);
  }
  
  factory AuthResult.error(String error) {
    return AuthResult._(success: false, error: error);
  }
} 