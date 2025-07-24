Feature: Data Management
  As a user
  I want my data to be properly managed and persisted
  So that I can access content reliably

  Background:
    Given I am using the Alex Reader app
    And the app has data management capabilities

  Scenario: Local database initialization
    When the app starts
    Then the Isar database should be initialized
    And the NostrEvent schema should be registered
    And the database should be ready for storing publications
    And the database should be located in the app documents directory

  Scenario: Publication storage
    Given I receive publications from relays
    When publications are processed
    Then the publications should be stored in the local database
    And each publication should have a unique event ID
    And each publication should be indexed by pubkey
    And each publication should be indexed by kind
    And each publication should have a last sync timestamp

  Scenario: Publication retrieval
    Given I have stored publications locally
    When I request publications
    Then the publications should be retrieved from the local database
    And the publications should be filtered by content type
    And the publications should be sorted by creation date
    And the publications should be returned efficiently

  Scenario: Publication search
    Given I have stored publications locally
    When I search for publications
    Then the search should query the local database
    And the search should be case-insensitive
    And the search should support partial matches
    And the search results should be relevant
    And the search should be fast

  Scenario: Publication count
    Given I have stored publications locally
    When I request the publication count
    Then the count should be accurate
    And the count should be returned quickly
    And the count should reflect the current state

  Scenario: Demo data population
    Given the app has no existing publications
    When the app initializes
    Then demo data should be populated
    And the demo data should include various content types
    And the demo data should be properly formatted
    And the demo data should be accessible

  Scenario: Data persistence
    Given I have publications stored locally
    When I close the app
    And I reopen the app
    Then the publications should still be available
    And the publications should be loaded quickly
    And the publications should be in the same state

  Scenario: Data synchronization
    Given I have local publications
    When I sync with relays
    Then new publications should be downloaded
    And existing publications should be updated
    And the sync status should be tracked
    And the last sync time should be recorded

  Scenario: Event deduplication
    Given I receive the same event from multiple relays
    When the events are processed
    Then only one copy should be stored
    And the event should be associated with all source relays
    And the event should not appear multiple times in the UI

  Scenario: Event validation
    Given I receive events from relays
    When the events are processed
    Then the events should be validated for required fields
    And malformed events should be rejected
    And valid events should be stored
    And validation errors should be logged

  Scenario: Profile data management
    Given I receive profile events (kind 0)
    When the profiles are processed
    Then the profiles should be stored locally
    And the profiles should be associated with authors
    And the profiles should include name, display_name, picture, about, website
    And the profiles should be retrievable by pubkey

  Scenario: Content type classification
    Given I have stored publications
    When I filter by content type
    Then articles (kind 30023) should be classified as "article"
    And notes (kind 30041) should be classified as "note"
    And wikis (kind 30818) should be classified as "wiki"
    And books (kind 30040) should be classified as "index"
    And the classification should be consistent

  Scenario: Chapter data management
    Given I have stored book publications
    When I view a book with chapters
    Then the chapter IDs should be extracted
    And the chapters should be loaded from the database
    And the chapters should be ordered correctly
    And missing chapters should be handled gracefully

  Scenario: Data cleanup
    Given I have old or invalid data
    When data cleanup is performed
    Then invalid events should be removed
    And orphaned data should be cleaned up
    And the database should remain efficient
    And cleanup should not affect valid data

  Scenario: Database performance
    Given I have many publications stored
    When I perform database operations
    Then the operations should be fast
    And the database should remain responsive
    And memory usage should be reasonable
    And the database should scale well

  Scenario: Offline data access
    Given I have publications stored locally
    When I have no internet connectivity
    Then I should be able to access all stored publications
    And I should be able to search through local data
    And I should be able to read publications offline
    And the app should indicate offline status

  Scenario: Data migration
    Given I have existing data in an old format
    When the app updates
    Then the data should be migrated to the new format
    And no data should be lost
    And the migration should be transparent
    And the app should continue to function normally

  Scenario: Data backup and restore
    Given I have important publications stored
    When I backup my data
    Then the data should be backed up safely
    And the backup should include all publications
    And the backup should be restorable
    And the backup should be secure

  Scenario: Data export
    Given I have publications stored locally
    When I export my data
    Then the data should be exported in a standard format
    And the export should include all publications
    And the export should be readable
    And the export should be shareable

  Scenario: Data import
    Given I have exported data
    When I import the data
    Then the data should be imported correctly
    And all publications should be available
    And the data should be properly formatted
    And conflicts should be resolved appropriately

  Scenario: Database indexing
    Given I have publications stored in the database
    When I query the database
    Then the queries should use proper indexes
    And the queries should be efficient
    And the indexes should be maintained
    And the database should perform well

  Scenario: Data consistency
    Given I have data stored locally
    When I perform operations on the data
    Then the data should remain consistent
    And transactions should be atomic
    And the database should maintain integrity
    And errors should be handled gracefully

  Scenario: Memory management
    Given I have many publications loaded
    When I navigate through the app
    Then memory usage should be reasonable
    And the app should not crash due to memory issues
    And unused data should be cleaned up
    And the app should remain responsive 