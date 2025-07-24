import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:highlight/highlight.dart' as hl;

class MarkupService {
  static final MarkupService _instance = MarkupService._internal();
  factory MarkupService() => _instance;
  MarkupService._internal();

  /// Parse and render content based on content type
  Widget renderContent(String content, int kind, {BuildContext? context}) {
    switch (kind) {
      case 30023: // Articles - use NostrMarkup (enhanced Markdown)
        return _renderNostrMarkup(content, context: context);
      case 30041: // Publication sections - use AsciiDoc
        return _renderAsciiDoc(content, context: context);
      case 30818: // Wikis - use AsciiDoc
        return _renderAsciiDoc(content, context: context);
      default:
        return _renderBasicMarkdown(content, context: context);
    }
  }

  /// Render NostrMarkup (enhanced Markdown with Nostr-specific features)
  Widget _renderNostrMarkup(String content, {BuildContext? context}) {
    // Convert NostrMarkup to enhanced Markdown
    String enhancedMarkdown = _convertNostrMarkupToMarkdown(content);
    
    return Markdown(
      data: enhancedMarkdown,
      styleSheet: _getMarkdownStyleSheet(),
      builders: {
        'code': CodeElementBuilder(),
      },
      onTapLink: (text, url, title) {
        _handleLinkTap(url, context);
      },
    );
  }

  /// Render AsciiDoc content
  Widget _renderAsciiDoc(String content, {BuildContext? context}) {
    // Convert AsciiDoc to Markdown for rendering
    String markdown = _convertAsciiDocToMarkdown(content);
    
    return Markdown(
      data: markdown,
      styleSheet: _getMarkdownStyleSheet(),
      builders: {
        'code': CodeElementBuilder(),
      },
      onTapLink: (text, url, title) {
        _handleLinkTap(url, context);
      },
    );
  }

  /// Render basic Markdown
  Widget _renderBasicMarkdown(String content, {BuildContext? context}) {
    return Markdown(
      data: content,
      styleSheet: _getMarkdownStyleSheet(),
      builders: {
        'code': CodeElementBuilder(),
      },
      onTapLink: (text, url, title) {
        _handleLinkTap(url, context);
      },
    );
  }

  /// Convert NostrMarkup to enhanced Markdown
  String _convertNostrMarkupToMarkdown(String content) {
    String result = content;
    
    // Handle Nostr identifiers
    result = _processNostrIdentifiers(result);
    
    // Handle emoji shortcodes
    result = _processEmojiShortcodes(result);
    
    // Handle wikilinks
    result = _processWikilinks(result);
    
    // Handle footnotes
    result = _processFootnotes(result);
    
    return result;
  }

  /// Convert AsciiDoc to Markdown
  String _convertAsciiDocToMarkdown(String content) {
    String result = content;
    
    // Convert AsciiDoc headers to Markdown
    result = _convertAsciiDocHeaders(result);
    
    // Convert AsciiDoc lists to Markdown
    result = _convertAsciiDocLists(result);
    
    // Convert AsciiDoc emphasis to Markdown
    result = _convertAsciiDocEmphasis(result);
    
    // Convert AsciiDoc links to Markdown
    result = _convertAsciiDocLinks(result);
    
    // Convert AsciiDoc images to Markdown
    result = _convertAsciiDocImages(result);
    
    // Convert AsciiDoc code blocks to Markdown
    result = _convertAsciiDocCodeBlocks(result);
    
    // Convert AsciiDoc tables to Markdown
    result = _convertAsciiDocTables(result);
    
    // Convert AsciiDoc admonitions to Markdown
    result = _convertAsciiDocAdmonitions(result);
    
    // Convert AsciiDoc callouts to Markdown
    result = _convertAsciiDocCallouts(result);
    
    return result;
  }

  /// Process Nostr identifiers (npub, nprofile, nevent, naddr)
  String _processNostrIdentifiers(String content) {
    // Handle Nostr identifiers with or without nostr: prefix
    RegExp nostrRegex = RegExp(r'(nostr:)?(npub|nprofile|nevent|naddr|note)[a-zA-Z0-9]+');
    return content.replaceAllMapped(nostrRegex, (match) {
      String identifier = match.group(0)!;
      // Convert to clickable link
      return '[$identifier](nostr:$identifier)';
    });
  }

  /// Process emoji shortcodes
  String _processEmojiShortcodes(String content) {
    // Convert :emoji: to actual emoji
    // This is a simplified implementation
    Map<String, String> emojiMap = {
      ':smile:': '😄',
      ':heart:': '❤️',
      ':thumbsup:': '👍',
      ':fire:': '🔥',
      ':rocket:': '🚀',
    };
    
    String result = content;
    emojiMap.forEach((shortcode, emoji) {
      result = result.replaceAll(shortcode, emoji);
    });
    
    return result;
  }

  /// Process wikilinks [[NIP-54]]
  String _processWikilinks(String content) {
    // Convert [[NIP-54]] to [NIP-54](https://next-alexandria/publication?d=nip-54)
    RegExp wikilinkRegex = RegExp(r'\[\[([^\]]+)\]\]');
    return content.replaceAllMapped(wikilinkRegex, (match) {
      String linkText = match.group(1)!;
      String url = 'https://next-alexandria/publication?d=${linkText.toLowerCase().replaceAll(' ', '-')}';
      return '[$linkText]($url)';
    });
  }

  /// Process footnotes
  String _processFootnotes(String content) {
    // Collect footnotes and their references
    Map<String, String> footnotes = {};
    List<String> footnoteRefs = [];
    
    // Find footnote references [^1] or [^Smith]
    RegExp footnoteRefRegex = RegExp(r'\[\^([^\]]+)\]');
    content = content.replaceAllMapped(footnoteRefRegex, (match) {
      String ref = match.group(1)!;
      if (!footnoteRefs.contains(ref)) {
        footnoteRefs.add(ref);
      }
      return '[^$ref]';
    });
    
    // Find footnote definitions [^1]: text or [^Smith]: text
    RegExp footnoteDefRegex = RegExp(r'\[\^([^\]]+)\]:\s*(.+)', multiLine: true);
    content = content.replaceAllMapped(footnoteDefRegex, (match) {
      String ref = match.group(1)!;
      String text = match.group(2)!;
      footnotes[ref] = text;
      return ''; // Remove from content, will be added at bottom
    });
    
    // Add footnotes at the bottom
    if (footnotes.isNotEmpty) {
      content += '\n\n---\n\n**Footnotes:**\n\n';
      for (int i = 0; i < footnoteRefs.length; i++) {
        String ref = footnoteRefs[i];
        String text = footnotes[ref] ?? '';
        content += '${i + 1}. $text\n\n';
      }
    }
    
    return content;
  }

  /// Convert AsciiDoc headers
  String _convertAsciiDocHeaders(String content) {
    // Convert = Header to # Header
    content = content.replaceAll(RegExp(r'^= (.+)$', multiLine: true), '# \$1');
    // Convert == Header to ## Header
    content = content.replaceAll(RegExp(r'^== (.+)$', multiLine: true), '## \$1');
    // Convert === Header to ### Header
    content = content.replaceAll(RegExp(r'^=== (.+)$', multiLine: true), '### \$1');
    return content;
  }

  /// Convert AsciiDoc lists
  String _convertAsciiDocLists(String content) {
    // Convert * item to * item (already Markdown compatible)
    // Convert . item to 1. item
    content = content.replaceAll(RegExp(r'^\. (.+)$', multiLine: true), '1. \$1');
    return content;
  }

  /// Convert AsciiDoc emphasis
  String _convertAsciiDocEmphasis(String content) {
    // Convert *bold* to **bold**
    content = content.replaceAll(RegExp(r'\*([^*]+)\*'), '**\$1**');
    // Convert _italic_ to *italic*
    content = content.replaceAll(RegExp(r'_([^_]+)_'), '*\$1*');
    return content;
  }

  /// Convert AsciiDoc links
  String _convertAsciiDocLinks(String content) {
    // Convert link:url[text] to [text](url)
    RegExp linkRegex = RegExp(r'link:([^\[]+)\[([^\]]+)\]');
    return content.replaceAllMapped(linkRegex, (match) {
      String url = match.group(1)!;
      String text = match.group(2)!;
      return '[$text]($url)';
    });
  }

  /// Convert AsciiDoc images
  String _convertAsciiDocImages(String content) {
    // Convert image::url[alt] to ![alt](url)
    RegExp imageRegex = RegExp(r'image::([^\[]+)\[([^\]]*)\]');
    return content.replaceAllMapped(imageRegex, (match) {
      String url = match.group(1)!;
      String alt = match.group(2) ?? '';
      return '![$alt]($url)';
    });
  }

  /// Convert AsciiDoc code blocks
  String _convertAsciiDocCodeBlocks(String content) {
    // Convert [source,language] to ```language
    RegExp sourceRegex = RegExp(r'\[source,([^\]]+)\]');
    content = content.replaceAllMapped(sourceRegex, (match) {
      String language = match.group(1)!;
      return '```$language';
    });
    return content;
  }

  /// Convert AsciiDoc tables
  String _convertAsciiDocTables(String content) {
    // Convert AsciiDoc table format to Markdown table
    // This handles basic table conversion
    RegExp tableRegex = RegExp(r'\|===\s*\n(.*?)\n\|===', dotAll: true);
    return content.replaceAllMapped(tableRegex, (match) {
      String tableContent = match.group(1)!;
      List<String> lines = tableContent.split('\n');
      List<String> markdownLines = [];
      
      for (int i = 0; i < lines.length; i++) {
        String line = lines[i].trim();
        if (line.isNotEmpty) {
          // Convert |cell| to | cell |
          String markdownLine = '| ' + line.replaceAll(RegExp(r'\|'), ' | ') + ' |';
          markdownLines.add(markdownLine);
          
          // Add header separator after first row
          if (i == 0) {
            String separator = '| ' + line.split('|').map((_) => '---').join(' | ') + ' |';
            markdownLines.add(separator);
          }
        }
      }
      
      return markdownLines.join('\n');
    });
  }

  /// Convert AsciiDoc admonitions
  String _convertAsciiDocAdmonitions(String content) {
    // Convert NOTE:, TIP:, WARNING:, CAUTION:, IMPORTANT: to Markdown blockquotes
    RegExp admonitionRegex = RegExp(r'^(NOTE|TIP|WARNING|CAUTION|IMPORTANT):\s*(.+)$', multiLine: true);
    return content.replaceAllMapped(admonitionRegex, (match) {
      String type = match.group(1)!;
      String text = match.group(2)!;
      return '> **$type:** $text';
    });
  }

  /// Convert AsciiDoc callouts
  String _convertAsciiDocCallouts(String content) {
    // Convert <1> callouts to numbered references
    RegExp calloutRegex = RegExp(r'<(\d+)>');
    return content.replaceAllMapped(calloutRegex, (match) {
      String number = match.group(1)!;
      return '^[$number]';
    });
  }

  /// Get Markdown style sheet
  MarkdownStyleSheet _getMarkdownStyleSheet() {
    return MarkdownStyleSheet(
      h1: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      h2: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      h3: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      p: const TextStyle(
        fontSize: 16,
        height: 1.5,
        color: Colors.black87,
      ),
      blockquote: const TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: Colors.black54,
      ),
      code: const TextStyle(
        fontSize: 14,
        fontFamily: 'monospace',
        backgroundColor: Color(0xFFF5F5F5),
      ),
      codeblockDecoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// Handle link taps
  void _handleLinkTap(String? url, BuildContext? context) {
    if (url == null || context == null) return;
    
    // Handle Nostr URLs
    if (url.startsWith('nostr:')) {
      // Handle Nostr protocol URLs
      return;
    }
    
    // Handle regular URLs
    // You might want to use url_launcher or similar package
    print('Opening URL: $url');
  }
}

/// Custom code element builder with syntax highlighting
class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    String language = '';
    if (element.attributes.containsKey('class')) {
      language = element.attributes['class']!;
    }
    
    String code = element.textContent;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: HighlightView(
        code,
        language: language.isNotEmpty ? language : 'dart',
        theme: githubTheme,
        padding: EdgeInsets.zero,
        textStyle: const TextStyle(
          fontSize: 14,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
} 