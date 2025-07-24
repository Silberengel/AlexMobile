import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart'; // Added for sha256

class AuthService {
  static const String _pubkeyKey = 'user_pubkey';
  static const String _privateKeyKey = 'user_private_key';
  
  String? _currentPubkey;
  String? _currentPrivateKey;
  
  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    if (_currentPubkey != null) return true;
    
    final prefs = await SharedPreferences.getInstance();
    _currentPubkey = prefs.getString(_pubkeyKey);
    _currentPrivateKey = prefs.getString(_privateKeyKey);
    
    return _currentPubkey != null;
  }
  
  /// Get current user's pubkey
  String? get currentPubkey => _currentPubkey;
  
  /// Get current user's private key (if available)
  String? get currentPrivateKey => _currentPrivateKey;
  
  /// Login with manual key entry (for development/testing)
  Future<bool> loginWithKey(String privateKey) async {
    try {
      // Validate private key format (nsec1...)
      if (!privateKey.startsWith('nsec1')) {
        throw Exception('Invalid private key format. Must start with nsec1');
      }
      
      // For now, we'll use a simple pubkey derivation
      // In a real app, you'd use proper cryptographic functions
      final pubkey = _derivePubkeyFromPrivateKey(privateKey);
      
      _currentPubkey = pubkey;
      _currentPrivateKey = privateKey;
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pubkeyKey, _currentPubkey!);
      await prefs.setString(_privateKeyKey, _currentPrivateKey!);
      
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
  
  /// Login using Amber app (deep link)
  Future<bool> loginWithAmber() async {
    try {
      // This would open the Amber app via deep link
      // For now, we'll simulate the process
      print('Opening Amber app for authentication...');
      
      // In a real implementation, you'd use:
      // final url = 'amber://auth?callback=alexreader://auth';
      // await launchUrl(Uri.parse(url));
      
      // For now, return false to indicate manual key entry needed
      return false;
    } catch (e) {
      print('Amber login error: $e');
      return false;
    }
  }
  
  /// Login method (defaults to Amber)
  Future<bool> login() async {
    return await loginWithAmber();
  }
  
  /// Logout user
  Future<void> logout() async {
    _currentPubkey = null;
    _currentPrivateKey = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pubkeyKey);
    await prefs.remove(_privateKeyKey);
  }
  
  /// Sign an event (if authenticated)
  Future<String?> signEvent(Map<String, dynamic> event) async {
    if (!await isAuthenticated() || _currentPrivateKey == null) {
      return null;
    }
    
    try {
      // This is a simplified signing implementation
      // In a real app, you'd use proper cryptographic signing
      final eventJson = jsonEncode(event);
      final hash = sha256.convert(utf8.encode(eventJson));
      return hash.toString();
    } catch (e) {
      print('Sign event error: $e');
      return null;
    }
  }
  
  /// Create and sign a publication event
  Future<Map<String, dynamic>?> createPublication({
    required String title,
    required String content,
    String? summary,
    String? image,
    List<String>? tags,
    List<String>? authors,
  }) async {
    if (!await isAuthenticated()) {
      return null;
    }
    
    try {
      final event = {
        'kind': 30023, // Long-form content
        'pubkey': _currentPubkey,
        'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'content': _createPublicationContent(
          title: title,
          content: content,
          summary: summary,
          image: image,
          tags: tags,
          authors: authors,
        ),
        'tags': [
          ['d', _generateEventId()], // Event identifier
          if (tags != null) ...tags.map((tag) => ['t', tag]),
          if (authors != null) ...authors.map((author) => ['p', author]),
        ],
      };
      
      final signature = await signEvent(event);
      if (signature != null) {
        event['id'] = _generateEventId();
        event['sig'] = signature;
        return event;
      }
      
      return null;
    } catch (e) {
      print('Create publication error: $e');
      return null;
    }
  }
  
  /// Create publication content JSON
  String _createPublicationContent({
    required String title,
    required String content,
    String? summary,
    String? image,
    List<String>? tags,
    List<String>? authors,
  }) {
    final Map<String, dynamic> publication = {
      'title': title,
      'content': content,
      'published_at': DateTime.now().toIso8601String(),
    };
    
    if (summary != null) publication['summary'] = summary;
    if (image != null) publication['image'] = image;
    if (tags != null) publication['tags'] = tags;
    if (authors != null) publication['authors'] = authors;
    
    return jsonEncode(publication);
  }
  
  /// Generate a unique event ID
  String _generateEventId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (1000 + (DateTime.now().microsecond % 9000));
    return 'pub_${timestamp}_$random';
  }
  
  /// Derive pubkey from private key (simplified)
  String _derivePubkeyFromPrivateKey(String privateKey) {
    // This is a simplified implementation
    // In a real app, you'd use proper cryptographic functions
    final hash = sha256.convert(utf8.encode(privateKey));
    return 'npub1${hash.toString().substring(0, 50)}';
  }
} 