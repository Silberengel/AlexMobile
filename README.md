# Alexandria Reader - Nostr E-Reader App

A cross-platform Flutter e-reader app for the Nostr protocol, built with the Purplebase library and inspired by Zapchat's design language. This app provides a modern reading experience for Nostr publications with offline-first architecture.

## Features

### 📚 **Core Reading Features**
- **Reactive Search**: Real-time search with debouncing across all publications
- **Publication Cards**: Beautiful Zapchat-inspired card-based UI for browsing publications
- **Reader View**: Full-featured reading experience with markdown support
- **Table of Contents**: Automatic parsing and navigation of document sections
- **Reading Progress**: Visual progress indicator and tracking
- **Lazy Loading**: Efficient loading of large publications

### 🔄 **Nostr Integration**
- **Multi-Relay Support**: Connects to `wss://thecitadel.nostr1.com` and `wss://profiles.nostr1.com`
- **Local Relay Detection**: Automatically connects to `localhost:4869` if available
- **Event Types**: 
  - **30040**: Index/Books with ordered chapters (30041s and 30818s)
  - **30023**: Standalone articles in NostrMarkup
  - **30041**: Notes (standalone or part of indexes) with AsciiDoc
  - **30818**: Wikis (standalone or part of indexes) with AsciiDoc
  - **0**: User profiles
- **Advanced Markup Rendering**:
  - **NostrMarkup** for articles (30023): Enhanced Markdown with Nostr identifiers, emoji shortcodes, wikilinks, and footnotes
  - **AsciiDoc** for wikis (30818) and publication sections (30041): Full AsciiDoc support with headers, tables, admonitions, callouts, and more
  - **Basic Markdown** for other content types
- **Content Type Filtering**: Tabbed interface to browse different content types
- **Background Sync**: Automatic synchronization every 15 minutes
- **Offline-First**: All reading is done from local cache

### 🔐 **Authentication**
- **Amber Integration**: Secure Nostr authentication using Amber signer
- **Optional Login**: App works perfectly without authentication (read-only mode)
- **Profile Management**: User profile and publication creation when authenticated

### 📱 **Cross-Platform**
- **Android Support**: Native Android app with Zapchat-inspired Material Design 3
- **iOS Support**: Native iOS app with Zapchat-inspired Cupertino design elements
- **Responsive Design**: Adapts to different screen sizes and orientations

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   UI Layer      │    │   State Layer   │    │   Data Layer    │
│                 │    │                 │    │                 │
│ • Home Screen   │◄──►│ • Riverpod      │◄──►│ • Isar DB       │
│ • Reader Screen │    │ • Providers     │    │ • Nostr Service │
│ • Widgets       │    │ • State Mgmt    │    │ • Event Repo    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Key Components

1. **Models** (`lib/models/`)
   - `NostrEvent`: Core data model for all Nostr events
   - Supports publications, profiles, and metadata

2. **Services** (`lib/services/`)
   - `NostrService`: Handles relay connections and event syncing
   - `AuthService`: Amber integration and user authentication

3. **Repository** (`lib/repositories/`)
   - `EventRepository`: Local storage and caching with Isar

4. **Providers** (`lib/providers/`)
   - State management with Riverpod
   - Reactive UI updates

5. **Screens** (`lib/screens/`)
   - `HomeScreen`: Landing page with search and publication cards
   - `ReaderScreen`: Full-featured reading experience

6. **Widgets** (`lib/widgets/`)
   - Reusable UI components
   - Search bar, publication cards, table of contents

## Setup Instructions

### Prerequisites

1. **Flutter SDK** (3.0.0 or higher)
2. **Dart SDK** (3.0.0 or higher)
3. **Android Studio** / **VS Code** with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd alex_reader
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

#### Relay Configuration
The app automatically connects to:
- `wss://thecitadel.nostr1.com` (publications)
- `wss://profiles.nostr1.com` (profiles)
- `ws://localhost:4869` (if local relay detected)

#### Local Development
To use a local relay:
1. Start your local relay on port 4869
2. The app will automatically detect and connect to it

### Building for Production

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

## Development

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   └── nostr_event.dart
├── services/                 # Business logic
│   ├── nostr_service.dart
│   └── auth_service.dart
├── repositories/             # Data access
│   └── event_repository.dart
├── providers/                # State management
│   └── app_providers.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   └── reader_screen.dart
└── widgets/                  # Reusable components
    ├── publication_card.dart
    ├── search_bar.dart
    ├── table_of_contents.dart
    └── reading_progress.dart
```

### Key Dependencies

- **purplebase**: Nostr protocol implementation
- **ndk**: Nostr Development Kit
- **flutter_riverpod**: State management
- **isar**: Local database
- **flutter_markdown**: Markdown rendering
- **markdown**: Advanced Markdown parsing
- **asciidoc**: AsciiDoc parsing support
- **flutter_highlight**: Syntax highlighting
- **amber_signer**: Nostr authentication

### Code Generation

The project uses code generation for:
- Isar database schemas
- Riverpod providers

Run after any model changes:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Features in Detail

### Offline-First Architecture
- All publications are cached locally using Isar database
- App works completely offline after initial sync
- Background sync every 15 minutes when online
- Efficient storage with automatic cleanup

### Search Functionality
- Real-time search with 500ms debouncing
- Searches across titles, summaries, and content
- Tag-based filtering
- Search history and suggestions

### Reading Experience
- Clean, distraction-free reading interface
- Adjustable font sizes and themes
- Table of contents with section navigation
- Reading progress tracking
- Syntax highlighting for code blocks
- Support for complex markup formats (NostrMarkup, AsciiDoc)
- Bookmarking and highlighting (planned)

### Nostr Integration
- Full Nostr protocol compliance
- Support for all publication kinds (30040, 30041, 30023, 30818)
- Profile metadata and avatars
- Event signing and publishing (when authenticated)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Specifications Used

- **[NIP-09: Event Deletion Request](https://github.com/nostr-protocol/nips/blob/master/09.md)** - Event deletion and content moderation
- **[NIP-22: Comments](https://github.com/nostr-protocol/nips/blob/master/22.md)** - Threading comments on events and external content
- **[NIP-23: Long-form Content](https://github.com/nostr-protocol/nips/blob/master/23.md)** - Long-form articles and blog posts
- **[NIP-25: Reactions](https://github.com/nostr-protocol/nips/blob/master/25.md)** - User reactions to events (likes, dislikes, emojis)
- **[NIP-42: Authentication of clients to relays](https://github.com/nostr-protocol/nips/blob/master/42.md)** - Client authentication to relays
- **[NIP-46: Nostr Remote Signing](https://github.com/nostr-protocol/nips/blob/master/46.md)** - Remote signing for enhanced security
- **[NIP-51: Lists](https://github.com/nostr-protocol/nips/blob/master/51.md)** - User lists including bookmarks and mute lists
- **[NIP-7D: Threads](https://github.com/nostr-protocol/nips/blob/master/7D.md)** - Thread-based discussions using kind 11 events
- **[NIP-54: Wiki](https://github.com/nostr-protocol/nips/blob/master/54.md)** - Wiki articles and collaborative editing
- **[NIP-57: Lightning Zaps](https://github.com/nostr-protocol/nips/blob/master/57.md)** - Lightning payment integration for supporting content creators
- **[NIP-58: Badges](https://github.com/nostr-protocol/nips/blob/master/58.md)** - Badge definitions, awards, and profile badges
- **[NIP-84: Highlights](https://github.com/nostr-protocol/nips/blob/master/84.md)** - Content highlighting and quote highlights
- **[NKBIP-01: Curated Publications](https://next-alexandria.gitcitadel.eu/publication?id=naddr1qvzqqqrcvgpzplfq3m5v3u5r0q9f255fdeyz8nyac6lagssx8zy4wugxjs8ajf7pqyd8wumn8ghj7argv4nx7un9wd6zumn0wd68yvfwvdhk6qgmwaehxw309a6xsetrd96xzer9dshxummnw3erztnrdakszyrhwden5te0dehhxarj9ekxzmnyqyg8wumn8ghj7mn0wd68ytnhd9hx2qghwaehxw309ahx7um5wgh8xmmkvf5hgtngdaehgqg3waehxw309ahx7um5wgerztnrdakszxthwden5te0wpex7enfd3jhxtnwdaehgu339e3k7mgpz4mhxue69uhkzem8wghxummnw3ezumrpdejqzxrhwden5te0wfjkccte9ehx7umhdpjhyefwvdhk6qqgde4ky6ts95crzzparsa)** - Curated publications including books, journals, and knowledge bases

## Acknowledgments

- Built with the [Purplebase](https://github.com/purplebase) Nostr library
- Inspired by Alexandria's reading experience and Zapchat's design language
- Uses Material Design 3 with Zapchat-inspired theming for modern UI
