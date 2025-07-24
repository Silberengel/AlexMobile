import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/markup_service.dart';

/// Provider for the markup service
final markupServiceProvider = Provider<MarkupService>((ref) {
  return MarkupService();
}); 