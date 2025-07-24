Feature: Lists
  As a user
  I want to create and manage various types of lists
  So that I can organize content, mute unwanted sources, and bookmark important items

  Background:
    Given I am authenticated with a nostr key
    And the app supports list functionality
    And I have access to various content types

  Scenario: Bookmark creation (NIP-51 kind 10003)
    Given I am viewing a publication header card
    When I tap the bookmark button
    Then the app should create a kind 10003 bookmark event
    And the event should include the publication in the tags
    And the event should be properly signed with my nostr key
    And the event should be published to relays
    And the bookmark should be saved locally

  Scenario: Bookmark different content types
    Given I am viewing different types of content
    When I bookmark various items
    Then the app should support bookmarking kind 1 notes
    And the app should support bookmarking kind 30023 articles
    And the app should support bookmarking hashtags
    And the app should support bookmarking URLs
    And the app should include appropriate tags for each type

  Scenario: Bookmark display
    Given I have bookmarked several items
    When I view my bookmarks
    Then I should see all my bookmarked items
    And the items should be organized by type
    And the items should show their source information
    And I should be able to access the original content
    And I should be able to remove bookmarks

  Scenario: Mute list creation (NIP-51 kind 10000)
    Given I want to mute unwanted content
    When I create a mute list
    Then the app should create a kind 10000 mute event
    And the event should include muted pubkeys in 'p' tags
    And the event should include muted hashtags in 't' tags
    And the event should include muted words in 'word' tags
    And the event should include muted threads in 'e' tags
    And the event should be properly signed and published

  Scenario: Mute list filtering
    Given I have a mute list configured
    When I fetch content from relays
    Then the app should filter out content from muted pubkeys
    And the app should filter out content with muted hashtags
    And the app should filter out content with muted words
    And the app should filter out muted threads
    And the filtering should be applied consistently

  Scenario: Mute list management
    Given I have a mute list
    When I manage my mute list
    Then I should be able to add new items to mute
    And I should be able to remove items from mute
    And I should be able to view all muted items
    And I should be able to edit mute list settings
    And changes should be published to relays

  Scenario: Private list items (NIP-51 encryption)
    Given I want to keep some list items private
    When I add private items to a list
    Then the app should encrypt the private items using NIP-04
    And the encrypted items should be stored in the content field
    And the encryption should use the author's public and private keys
    And the private items should not be visible to others
    And the private items should be properly decrypted when viewing

  Scenario: Public list items
    Given I want to share some list items publicly
    When I add public items to a list
    Then the items should be stored in the tags array
    And the items should be visible to others
    And the items should be properly formatted
    And the items should include appropriate metadata

  Scenario: List chronological ordering
    Given I am adding items to an existing list
    When I add new items
    Then the new items should be appended to the end of the list
    And the items should be stored in chronological order
    And the order should be maintained when displaying
    And the order should be preserved when syncing

  Scenario: Follow list (NIP-51 kind 3)
    Given I want to follow other users
    When I create a follow list
    Then the app should create a kind 3 follow event
    And the event should include pubkeys in 'p' tags
    And the event should include optional relay hints
    And the event should include optional petnames
    And the event should be properly signed and published

  Scenario: Pinned notes list (NIP-51 kind 10001)
    Given I want to showcase important notes
    When I create a pinned notes list
    Then the app should create a kind 10001 pinned notes event
    And the event should include kind 1 notes in 'e' tags
    And the pinned notes should be displayed prominently
    And the pinned notes should be accessible from my profile
    And the event should be properly signed and published

  Scenario: Read/write relays list (NIP-51 kind 10002)
    Given I want to configure my relay preferences
    When I create a read/write relays list
    Then the app should create a kind 10002 relays event
    And the event should follow NIP-65 specifications
    And the relays should be used for publishing and mentions
    And the relay configuration should be properly applied
    And the event should be properly signed and published

  Scenario: Communities list (NIP-51 kind 10004)
    Given I want to track communities I belong to
    When I create a communities list
    Then the app should create a kind 10004 communities event
    And the event should include kind 34550 community definitions in 'a' tags
    And the communities should be properly associated
    And the communities should be accessible from my profile
    And the event should be properly signed and published

  Scenario: Public chats list (NIP-51 kind 10005)
    Given I want to track chat channels I'm in
    When I create a public chats list
    Then the app should create a kind 10005 public chats event
    And the event should include kind 40 channel definitions in 'e' tags
    And the chat channels should be properly listed
    And the chat channels should be accessible
    And the event should be properly signed and published

  Scenario: Blocked relays list (NIP-51 kind 10006)
    Given I want to block certain relays
    When I create a blocked relays list
    Then the app should create a kind 10006 blocked relays event
    And the event should include relay URLs in 'relay' tags
    And the app should never connect to blocked relays
    And the blocked relays should be properly filtered
    And the event should be properly signed and published

  Scenario: Search relays list (NIP-51 kind 10007)
    Given I want to configure search relay preferences
    When I create a search relays list
    Then the app should create a kind 10007 search relays event
    And the event should include relay URLs in 'relay' tags
    And the search relays should be used for search queries
    And the search relay configuration should be properly applied
    And the event should be properly signed and published

  Scenario: Bookmark sets (NIP-51 kind 30003)
    Given I want to organize bookmarks into categories
    When I create a bookmark set
    Then the app should create a kind 30003 bookmark set event
    And the event should include a 'd' tag for the set identifier
    And the event should include optional 'title', 'image', and 'description' tags
    And the event should include bookmarked items in appropriate tags
    And the bookmark set should be properly categorized
    And the event should be properly signed and published

  Scenario: Curation sets (NIP-51 kind 30004)
    Given I want to curate articles and notes
    When I create a curation set
    Then the app should create a kind 30004 curation set event
    And the event should include a 'd' tag for the set identifier
    And the event should include optional 'title', 'image', and 'description' tags
    And the event should include kind 30023 articles in 'a' tags
    And the event should include kind 1 notes in 'e' tags
    And the curation should be properly organized
    And the event should be properly signed and published

  Scenario: Video curation sets (NIP-51 kind 30005)
    Given I want to curate videos
    When I create a video curation set
    Then the app should create a kind 30005 video curation set event
    And the event should include a 'd' tag for the set identifier
    And the event should include optional 'title', 'image', and 'description' tags
    And the event should include kind 21 videos in 'a' tags
    And the video curation should be properly organized
    And the event should be properly signed and published

  Scenario: Kind mute sets (NIP-51 kind 30007)
    Given I want to mute pubkeys by specific event kinds
    When I create a kind mute set
    Then the app should create a kind 30007 kind mute set event
    And the 'd' tag should be the kind string
    And the event should include pubkeys in 'p' tags
    And the mute should apply only to the specified kind
    And the kind-specific muting should be properly applied
    And the event should be properly signed and published

  Scenario: Interest sets (NIP-51 kind 30015)
    Given I want to organize my interests
    When I create an interest set
    Then the app should create a kind 30015 interest set event
    And the event should include a 'd' tag for the set identifier
    And the event should include optional 'title', 'image', and 'description' tags
    And the event should include hashtags in 't' tags
    And the interests should be properly categorized
    And the event should be properly signed and published

  Scenario: Emoji sets (NIP-51 kind 30030)
    Given I want to organize my preferred emojis
    When I create an emoji set
    Then the app should create a kind 30030 emoji set event
    And the event should include a 'd' tag for the set identifier
    And the event should include optional 'title', 'image', and 'description' tags
    And the event should include emojis following NIP-30 specifications
    And the emoji set should be properly organized
    And the event should be properly signed and published

  Scenario: List synchronization
    Given I have created various lists
    When I sync my lists across devices
    Then the lists should be synchronized in real-time
    And the list items should be properly ordered
    And the private items should be properly encrypted
    And the public items should be properly shared
    And the synchronization should be secure and reliable

  Scenario: List error handling
    Given I am trying to create or modify a list
    When the list operation fails
    Then the app should handle the error gracefully
    And I should see an appropriate error message
    And the app should provide retry options
    And the app should not lose my list data
    And the app should attempt to publish again when possible

  Scenario: List privacy and security
    Given I am creating lists with private items
    When I manage my lists
    Then my private items should be properly encrypted
    And my encryption keys should be secure
    And the app should respect privacy settings
    And the app should handle private lists appropriately
    And the app should maintain security of my private key

  Scenario: List moderation
    Given I am viewing lists from other users
    When I see inappropriate list content
    Then I should be able to report problematic lists
    And the app should provide moderation tools for lists
    And the app should handle list moderation appropriately
    And the app should maintain a safe environment
    And the app should respect community guidelines

  Scenario: List search and filtering
    Given I am viewing many lists
    When I want to find specific lists
    Then I should be able to search through lists
    And I should be able to filter by list type
    And I should be able to filter by author
    And I should be able to filter by content type
    And the search and filtering should be fast and responsive

  Scenario: List analytics
    Given I am viewing lists
    When I look at list data
    Then I should see meaningful analytics about lists
    And the analytics should help understand usage patterns
    And the analytics should be privacy-respecting
    And the analytics should provide useful insights
    And the analytics should help identify popular content

  Scenario: List export and sharing
    Given I have created lists
    When I want to export or share lists
    Then I should be able to export list data
    And I should be able to share lists with others
    And the export should include proper metadata
    And the sharing should respect privacy settings
    And the export should be in a standard format

  Scenario: List backup and sync
    Given I have created lists
    When I want to backup or sync lists
    Then I should be able to backup list data
    And I should be able to sync lists across devices
    And the backup should include all list metadata
    And the sync should be secure and reliable
    And the sync should respect user preferences

  Scenario: List UI enhancement
    Given I am viewing lists with metadata
    When I display the lists
    Then lists with 'title' tags should show the title
    And lists with 'image' tags should show the image
    And lists with 'description' tags should show the description
    And the UI should be enhanced with the metadata
    And the display should be visually appealing

  Scenario: List set management
    Given I have multiple sets of the same type
    When I manage my sets
    Then I should be able to create multiple sets
    And I should be able to organize sets by 'd' identifiers
    And I should be able to switch between sets
    And I should be able to edit set metadata
    And the set management should be intuitive

  Scenario: List deprecated format handling
    Given I encounter deprecated list formats
    When I process the deprecated lists
    Then the app should handle kind 30000 with 'mute' d-tag
    And the app should handle kind 30001 with 'pin' d-tag
    And the app should handle kind 30001 with 'bookmark' d-tag
    And the app should handle kind 30001 with 'communities' d-tag
    And the app should suggest migration to standard formats 