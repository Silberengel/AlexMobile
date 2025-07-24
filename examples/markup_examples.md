# Markup Rendering Examples

This document demonstrates the markup rendering capabilities for different Nostr content types.

## NostrMarkup (30023) - Articles

### Example 1: Basic Article with Nostr Features

```markdown
# Getting Started with Nostr

Welcome to the world of Nostr! :smile:

## What is Nostr?

Nostr is a **simple**, *open protocol* that enables global, decentralized, and censorship-resistant social media.

## Key Features

- **Decentralized**: No central servers
- **Censorship-resistant**: Content can't be easily blocked
- **Simple**: Easy to implement and use

## Nostr Identifiers

Check out these Nostr identifiers:
- npub1abc123def456ghi789jkl012mno345pqr678stu901vwx234yz
- nostr:nevent1def456ghi789jkl012mno345pqr678stu901vwx234yz

## References

See [[NIP-01]] for the basic protocol specification.
See [[NIP-23]] for long-form content.

## Footnotes

This is a test article[^1] with footnotes.

[^1]: This is a footnote explaining something important.
```

### Example 2: Article with Code and Tables

```markdown
# Nostr Client Implementation

## Code Example

```javascript
// Simple Nostr client
const nostr = {
  connect: (relay) => {
    console.log(`Connecting to ${relay}`);
  },
  publish: (event) => {
    console.log('Publishing event:', event);
  }
};
```

## Feature Comparison

| Feature | Nostr | Twitter | Mastodon |
|---------|-------|---------|----------|
| Decentralized | ✅ | ❌ | ✅ |
| Censorship-resistant | ✅ | ❌ | ❌ |
| Simple Protocol | ✅ | ❌ | ❌ |

## Emoji Support

Express yourself with emojis: :heart: :fire: :rocket: :thumbsup:
```

## AsciiDoc (30041, 30818) - Publication Sections and Wikis

### Example 1: Publication Section

```asciidoc
= Advanced Nostr Concepts

== Introduction

This section covers advanced concepts in the Nostr protocol.

== Key Components

=== Relays
Relays are the backbone of Nostr's infrastructure.

=== Events
Events are the fundamental data structure.

== Code Examples

[source,javascript]
----
// Connect to multiple relays
const relays = [
  'wss://relay1.nostr.com',
  'wss://relay2.nostr.com'
];

relays.forEach(relay => {
  connect(relay);
});
----

== Important Notes

NOTE: Always validate events before processing.

WARNING: Be careful with private keys.

TIP: Use multiple relays for redundancy.

== Tables

|===
|Component |Purpose |Example
|Relay |Message routing |wss://relay.nostr.com
|Event |Data structure |{id, pubkey, sig, kind, content}
|Client |User interface |Web app, mobile app
|===

== Callouts

Some code with callouts <1>:

[source,javascript]
----
function processEvent(event) {
  validate(event); <1>
  store(event);
}
----

<1> Always validate events before processing
```

### Example 2: Wiki Entry

```asciidoc
= Nostr Protocol Wiki

== Overview

The Nostr protocol is a simple, open protocol that enables global, decentralized, and censorship-resistant social media.

== Protocol Details

=== Event Structure

Events have the following structure:

[source,json]
----
{
  "id": "event_id",
  "pubkey": "public_key",
  "created_at": 1234567890,
  "kind": 1,
  "tags": [],
  "content": "event content",
  "sig": "signature"
}
----

=== Event Kinds

* **0**: Metadata
* **1**: Text Note
* **30023**: Long-form Content
* **30040**: Index
* **30041**: Publication Section
* **30818**: Wiki

== Implementation

=== Client Libraries

link:https://github.com/nostr-protocol/nostr[Official Nostr Libraries]

=== Relay Software

link:https://github.com/fiatjaf/relayer[Relayer] - A simple relay implementation

== Best Practices

IMPORTANT: Always validate signatures before processing events.

CAUTION: Be careful with private key management.

TIP: Use multiple relays for redundancy and censorship resistance.

== Examples

=== Basic Text Note

[source,javascript]
----
const event = {
  kind: 1,
  content: "Hello, Nostr!",
  created_at: Math.floor(Date.now() / 1000)
};
----

=== Metadata Event

[source,javascript]
----
const metadata = {
  kind: 0,
  content: JSON.stringify({
    name: "Alice",
    about: "Nostr enthusiast",
    picture: "https://example.com/avatar.jpg"
  })
};
----
```

## Basic Markdown (Other Content Types)

### Example: Simple Note

```markdown
# Simple Note

This is a basic note with **bold** and *italic* text.

## Lists

- Item 1
- Item 2
- Item 3

## Code

```python
def hello_world():
    print("Hello, World!")
```

## Links

Check out [Nostr](https://nostr.com) for more information.
```

## Testing the Markup Service

To test the markup rendering, you can use the following Flutter test:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:alex_reader/services/markup_service.dart';

void main() {
  test('NostrMarkup rendering', () {
    final markupService = MarkupService();
    final widget = markupService.renderContent(
      'Hello :smile: world! See [[NIP-01]] for details.',
      30023
    );
    expect(widget, isNotNull);
  });
}
```

## Features Implemented

### NostrMarkup (30023)
- ✅ Emoji shortcodes (`:smile:`, `:heart:`, etc.)
- ✅ Wikilinks (`[[NIP-01]]`)
- ✅ Nostr identifiers (`npub1...`, `nevent1...`)
- ✅ Footnotes (`[^1]` and `[^1]: text`)
- ✅ Enhanced Markdown with syntax highlighting

### AsciiDoc (30041, 30818)
- ✅ Headers (`=`, `==`, `===`)
- ✅ Emphasis (`*bold*`, `_italic_`)
- ✅ Links (`link:url[text]`)
- ✅ Images (`image::url[alt]`)
- ✅ Code blocks (`[source,language]`)
- ✅ Tables (`|===`)
- ✅ Admonitions (`NOTE:`, `WARNING:`, etc.)
- ✅ Callouts (`<1>`)

### Basic Markdown
- ✅ Standard Markdown rendering
- ✅ Syntax highlighting for code blocks
- ✅ Custom styling with Zapchat theme 