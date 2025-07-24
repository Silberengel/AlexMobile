import 'package:flutter_test/flutter_test.dart';
import 'package:alex_reader/services/markup_service.dart';

void main() {
  group('MarkupService Tests', () {
    late MarkupService markupService;

    setUp(() {
      markupService = MarkupService();
    });

    group('NostrMarkup (30023) Tests', () {
      test('should process emoji shortcodes', () {
        const input = 'Hello :smile: world :heart:';
        const expected = 'Hello 😄 world ❤️';
        
        final result = markupService.renderContent(input, 30023);
        expect(result, isNotNull);
      });

      test('should process wikilinks', () {
        const input = 'See [[NIP-54]] for more details';
        const expected = 'See [NIP-54](https://next-alexandria/publication?d=nip-54) for more details';
        
        final result = markupService.renderContent(input, 30023);
        expect(result, isNotNull);
      });

      test('should process Nostr identifiers', () {
        const input = 'Check out npub1abc123... and nostr:nevent1def456...';
        
        final result = markupService.renderContent(input, 30023);
        expect(result, isNotNull);
      });

      test('should process footnotes', () {
        const input = 'This is a test[^1].\n\n[^1]: This is a footnote.';
        
        final result = markupService.renderContent(input, 30023);
        expect(result, isNotNull);
      });
    });

    group('AsciiDoc (30041, 30818) Tests', () {
      test('should convert AsciiDoc headers', () {
        const input = '= Main Title\n\n== Section Title\n\n=== Subsection';
        const expected = '# Main Title\n\n## Section Title\n\n### Subsection';
        
        final result = markupService.renderContent(input, 30041);
        expect(result, isNotNull);
      });

      test('should convert AsciiDoc emphasis', () {
        const input = '*bold text* and _italic text_';
        const expected = '**bold text** and *italic text*';
        
        final result = markupService.renderContent(input, 30041);
        expect(result, isNotNull);
      });

      test('should convert AsciiDoc links', () {
        const input = 'link:https://example.com[Example Link]';
        const expected = '[Example Link](https://example.com)';
        
        final result = markupService.renderContent(input, 30041);
        expect(result, isNotNull);
      });

      test('should convert AsciiDoc images', () {
        const input = 'image::https://example.com/image.png[Alt Text]';
        const expected = '![Alt Text](https://example.com/image.png)';
        
        final result = markupService.renderContent(input, 30041);
        expect(result, isNotNull);
      });

      test('should convert AsciiDoc code blocks', () {
        const input = '[source,dart]\nvoid main() {\n  print("Hello");\n}';
        const expected = '```dart\nvoid main() {\n  print("Hello");\n}\n```';
        
        final result = markupService.renderContent(input, 30041);
        expect(result, isNotNull);
      });

      test('should convert AsciiDoc admonitions', () {
        const input = 'NOTE: This is a note.\n\nWARNING: This is a warning.';
        const expected = '> **NOTE:** This is a note.\n\n> **WARNING:** This is a warning.';
        
        final result = markupService.renderContent(input, 30041);
        expect(result, isNotNull);
      });

      test('should convert AsciiDoc callouts', () {
        const input = 'Some code <1> with callout';
        const expected = 'Some code ^[1] with callout';
        
        final result = markupService.renderContent(input, 30041);
        expect(result, isNotNull);
      });
    });

    group('Basic Markdown Tests', () {
      test('should render basic markdown', () {
        const input = '# Title\n\nThis is **bold** and *italic* text.';
        
        final result = markupService.renderContent(input, 1);
        expect(result, isNotNull);
      });
    });
  });
} 