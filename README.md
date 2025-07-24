# Alexandria Mobile

A Flutter-based mobile client for [Alexandria](https://alexandria.gitcitadel.eu), a decentralized knowledge platform built on Nostr. Alexandria Mobile provides access to publications, articles, wikis, and notes in a user-friendly mobile interface. It also features a discussion board, for avid readers.

## Features

* **Decentralized Content**: Access publications, articles, wikis, and notes from the Nostr network
* **Cross-Platform**: Built with Flutter for iOS, Chrome, and Android
* **Modern UI**: Clean, accessible interface following Zap Chat design principles
* **Offline Support**: Content caching and offline reading capabilities
* **Relay Management**: Connect to and manage Nostr relays
* **Search**: Find content across the decentralized network

## Getting Started

### Prerequisites

* Flutter SDK (latest stable version)
* Dart SDK
* Android Studio / Xcode (for mobile development)
* Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Silberengel/AlexMobile
cd alexandria-mobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Nostr Specifications Used

This application implements the following Nostr Network Improvement Proposals (NIPs) and Alexandria specifications:

* **[NK-BIP-01: Alexandria Core Specification](https://alexandria.gitcitadel.eu/publication?d=nkbip-01)** - Core Alexandria protocol and data structures
* **[NIP-01: Basic protocol flow](https://github.com/nostr-protocol/nips/blob/master/01.md)** - Basic protocol flow and event structure
* **[NIP-22: Comments](https://github.com/nostr-protocol/nips/blob/master/22.md)** - Generic comment events
* **[NIP-23: Long-form Content](https://github.com/nostr-protocol/nips/blob/master/23.md)** - Long-form content
* **[NIP-25: Reactions](https://github.com/nostr-protocol/nips/blob/master/25.md)** - Reactions
* **[NIP-42: Authentication of clients to relays](https://github.com/nostr-protocol/nips/blob/master/42.md)** - Authentication of clients to relays
* **[NIP-51: Lists](https://github.com/nostr-protocol/nips/blob/master/51.md)** - Lists
* **[NIP-54: Wiki](https://github.com/nostr-protocol/nips/blob/master/54.md)** - Wiki
* **[NIP-56: Reporting](https://github.com/nostr-protocol/nips/blob/master/56.md)** - Reporting
* **[NIP-57: Lightning Zaps](https://github.com/nostr-protocol/nips/blob/master/57.md)** - Lightning Zaps
* **[NIP-84: Highlights](https://github.com/nostr-protocol/nips/blob/master/84.md)** - Highlights
* **[NIP-7D: Threads](https://github.com/nostr-protocol/nips/blob/master/7D.md)** - Threads
* **[NIP-46: Nostr Connect](https://github.com/nostr-protocol/nips/blob/master/46.md)** - Nostr Connect

## Data Models

The application focuses on the following Nostr event types:

* **Kind 11**: Comment threads
* **Kind 30023**: Long-form articles (NIP-23)
* **Kind 30040**: Publication indexes (NKBIP-01)
* **Kind 30041**: Notes/Zettels (NKBIP-01)
* **Kind 30818**: Wiki pages (NIP-54)

## Architecture

### State Management
* **Riverpod**: For reactive state management
* **Hive**: For local data persistence

### Key Components
* **Providers**: Centralized state management
* **Screens**: Main application views
* **Widgets**: Reusable UI components
* **Services**: Network and data services
* **Models**: Data structures and types

## Development

### Project Structure
```
lib/
├── main.dart              # Application entry point
├── models/                # Data models
├── providers/             # State management
├── screens/               # Application screens
├── services/              # Network and data services
├── theme/                 # UI theming
├── utils/                 # Utility functions
└── widgets/               # Reusable UI components
```

### Key Features
* **Content Filtering**: Filter by publication type (articles, wikis, notes, publications)
* **Search**: Full-text search across content
* **Network Status**: Real-time connection status monitoring
* **Relay Management**: Connect to and manage Nostr relays
* **User Profiles**: Nostr user profile management

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

* Built on the [Nostr protocol](https://github.com/nostr-protocol/nips)
* Inspired by [Zap Chat](https://www.figma.com/community/file/1430887635327548022/zapchat-a-nostr-app-design) design principles
* Part of the [GitCitadel](https://gitcitadel.com) ecosystem

## Support

Contact us on Nostr, on our [GitCitadel npub](https://njump.me/nprofile1qqsggm4l0xs23qfjwnkfwf6fqcs66s3lz637gaxhl4nwd2vtle8rnfqprfmhxue69uhhg6r9vehhyetnwshxummnw3erztnrdaks5zhueg).
