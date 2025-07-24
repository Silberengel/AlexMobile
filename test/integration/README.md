# Integration Tests for Alex Reader

This directory contains comprehensive Gherkin feature files that map out the functionality of the Alex Reader app. These feature files serve as living documentation of the app's behavior and can be used as a foundation for automated testing.

## Overview

The Alex Reader is a Nostr-based e-reader application that allows users to browse, search, and read publications from the Nostr network. The app supports various content types including articles, notes, wikis, and books with chapters.

## Feature Files Structure

### Core Functionality

1. **`app_initialization.feature`** - App startup, splash screen, error handling, and initialization processes
2. **`home_screen.feature`** - Main screen functionality including publication browsing, search, filtering, and navigation
3. **`reader_screen.feature`** - Publication reading experience including content rendering, table of contents, and reading progress
4. **`index_reader_screen.feature`** - Book/chapter navigation for structured content (kind 30040)

### Network and Data

5. **`nostr_integration.feature`** - Nostr network integration including relay connections, event synchronization, and network status
6. **`authentication.feature`** - User authentication functionality and state management
7. **`data_management.feature`** - Local data storage, caching, and persistence using Isar database

### Content and UI

8. **`content_rendering.feature`** - Content formatting including NostrMarkup, AsciiDoc, and different content type handling
9. **`ui_components.feature`** - UI component behavior including search bar, filters, status indicators, and navigation elements
10. **`interactions.feature`** - User interactions including reactions, comments, highlights, and metadata cards
11. **`zapping.feature`** - Lightning payments including QR codes, wallet integration, and zap-comment threading

### Publishing and Quality

12. **`publishing.feature`** - Event publishing including local storage, broadcasting, draft management, and relay configuration
13. **`performance.feature`** - Performance aspects including loading times, memory usage, and app responsiveness
14. **`error_handling.feature`** - Error handling including network errors, data errors, and user-facing error messages

## Content Types Supported

The app supports the following Nostr event kinds:

- **Articles (kind 30023)** - Standalone articles in NostrMarkup format
- **Notes (kind 30041)** - User-generated content in NostrMarkup format
- **Wikis (kind 30818)** - Wiki content in AsciiDoc format
- **Books/Indexes (kind 30040)** - Structured content with chapters

## Key Features Documented

### App Initialization
- Splash screen with Zapchat design
- Database initialization (Isar)
- Demo data population
- Service initialization
- Error handling and recovery

### Home Screen
- Publication card display
- Search functionality with debouncing
- Content type filtering
- Pull-to-refresh
- Infinite scrolling
- Network status indicators

### Reader Experience
- Content rendering for different formats
- Table of contents navigation
- Reading progress tracking
- Image handling and caching
- Responsive design
- Metadata cards with interaction counters
- Reactions, comments, and highlights
- Lightning payments and zapping functionality

### Nostr Integration
- Relay connection management
- Event subscription and processing
- Background synchronization
- Offline functionality
- Network status monitoring

### Data Management
- Local storage with Isar database
- Event deduplication
- Content type classification
- Chapter data management
- Performance optimization
- Draft management and local storage
- Publishing queue and broadcast management

## Design System

The app follows the **Zapchat design system** with:

- **Colors**: Purple primary theme with green success, yellow warning, and red error states
- **Typography**: Clean, readable fonts with proper hierarchy
- **Icons**: GitHub-style minimalistic icons
- **Components**: Rounded corners, subtle shadows, consistent spacing
- **Interactions**: Smooth animations and responsive feedback

## User Preferences

The feature files reflect the following user preferences:

- **Network Status**: Red/yellow/green indicators for offline/limited/online states
- **UI Design**: Minimalistic, elegant, and easily recognizable components
- **Icons**: GitHub-style icons that are not colorful or distracting
- **Bullet Points**: Use '*' for bullet markers with a space after the asterisk
- **Strikethrough**: Display with a line through the text
- **Content Formatting**: Support for both NostrMarkup and AsciiDoc

## Testing Strategy

These feature files can be used for:

1. **Manual Testing**: Step-by-step verification of app functionality
2. **Automated Testing**: Foundation for Cucumber/Behave integration tests
3. **Documentation**: Living documentation of app behavior
4. **Requirements**: Clear specification of expected functionality
5. **Regression Testing**: Ensure features continue to work as expected

## Next Steps

To implement automated testing:

1. **Choose a Testing Framework**: Consider Flutter Driver, integration_test, or Cucumber for Flutter
2. **Implement Step Definitions**: Create step definitions for each scenario
3. **Set Up Test Environment**: Configure test data and mock services
4. **Run Tests**: Execute tests as part of CI/CD pipeline
5. **Maintain Tests**: Keep tests updated as features evolve

## File Organization

```
test/integration/
├── README.md                           # This documentation
├── app_initialization.feature          # App startup and initialization
├── home_screen.feature                 # Main screen functionality
├── reader_screen.feature               # Publication reading
├── index_reader_screen.feature         # Book/chapter navigation
├── nostr_integration.feature           # Network integration
├── authentication.feature              # User authentication
├── data_management.feature             # Data storage and management
├── content_rendering.feature           # Content formatting
├── ui_components.feature               # UI component behavior
├── interactions.feature                # User interactions and engagement
├── zapping.feature                     # Lightning payments and zapping
├── publishing.feature                  # Event publishing and broadcasting
├── performance.feature                 # Performance aspects
└── error_handling.feature              # Error handling
```

## Contributing

When adding new features or modifying existing functionality:

1. **Update Feature Files**: Add or modify scenarios to reflect new behavior
2. **Maintain Consistency**: Follow the established patterns and naming conventions
3. **Test Coverage**: Ensure all new functionality is covered by scenarios
4. **Documentation**: Update this README if adding new feature files

## Notes

- These feature files are **not yet automated** - they serve as comprehensive documentation
- Scenarios are written from a **user perspective** focusing on behavior rather than implementation
- The files follow **Gherkin syntax** and can be used with various testing frameworks
- All scenarios are **independent** and can be run in any order
- Background sections provide common setup for related scenarios 