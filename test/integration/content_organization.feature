Feature: Content Organization
  As a user
  I want to organize and manage content effectively
  So that I can find, publicationmark, and filter content according to my preferences

  Background:
    Given I am authenticated with a nostr key
    And the app supports content organization functionality
    And I have access to various content types

  Scenario: publicationmark creation
    Given I am viewing a publication header card
    When I tap the publicationmark button
    Then the app should create a kind 10003 publicationmark event
    And the event should include the publication in the tags
    And the event should be properly signed with my nostr key
    And the event should be published to relays
    And the publicationmark should be saved locally

  Scenario: publicationmark different content types
    Given I am viewing different types of content
    When I publicationmark various items
    Then the app should support publicationmarking kind 11, 30040, 30041, 30023, and 30818 events
    And the app should include appropriate tags for each type

  Scenario: publicationmark display
    Given I have publicationmarked several items
    When I view my publicationmarks
    Then I should see all my publicationmarked items
    And the items should be organized by type
    And the items should show their source information
    And I should be able to access the original content
    And I should be able to remove publicationmarks

  Scenario: Mute list creation
    Given I want to mute unwanted content
    When I create a mute list
    Then the app should create a kind 10000 mute event
    And the event should include muted pubkeys in 'p' tags
    And the event should include muted hashtags in 't' tags
    And the event should include muted words in 'word' tags
    And the event should be properly signed and published

  Scenario: Mute list filtering
    Given I have a mute list configured
    When I fetch content from relays
    Then the app should filter out content from muted pubkeys (from "pubkey" and "p" tags/fields)
    And the app should filter out content with muted hashtags
    And the app should filter out content with muted words
    And the filtering should be applied consistently

  Scenario: Mute list management
    Given I have a mute list
    When I manage my mute list
    Then I should be able to add new items to mute
    And I should be able to remove items from mute
    And I should be able to view all muted items
    And changes should be published to relays

  Scenario: Pinned notes list
    Given I want to pin important notes
    When I create a pinned notes list
    Then the app should create a kind 10001 pinned notes event
    And the event should include note IDs in 'e' tags
    And the event should be properly signed and published
    And pinned notes should be displayed prominently on profiles

  Scenario: List chronological ordering
    Given I am adding items to an existing list
    When I add new items
    Then the new items should be appended to the end of the list
    And the items should be stored in chronological order
    And the order should be maintained when displaying

  Scenario: Content categorization
    Given I am organizing content
    When I categorize content
    Then I should be able to create custom kind 1985 labels
    And I should be able to assign content to categories
    And I should be able to filter content by category
    And I should be able to manage category hierarchies

  Scenario: Content tagging
    Given I am viewing content
    When I add hashtags to content
    Then I should be able to add custom hashtags
    And I should be able to use existing hashtags
    And I should be able to search by hashtags
    And I should be able to see hashtag usage statistics

  Scenario: Content discovery
    Given I am looking for new content
    When I use content discovery features
    Then I should be able to browse trending content
    And I should be able to discover content by topic
    And I should be able to find content by author
    And I should be able to explore related content

  Scenario: Content synchronization
    Given I have organized content
    When I sync my content organization
    Then my publicationmarks should sync across devices
    And my mute lists should sync across devices
    And my pinned notes should sync across devices
    And my custom categories should sync across devices

  Scenario: Content export and import
    Given I have organized content
    When I export my content organization to jsonl
    Then I should be able to export publicationmarks
    And I should be able to export mute lists
    And I should be able to export pinned notes
    And I should be able to import organization data from other sources

  Scenario: Content analytics
    Given I am viewing content organization data
    When I access content analytics
    Then I should see content consumption statistics
    And I should see publicationmark patterns
    And I should see reading time analytics
    And I should be able to export analytics data 