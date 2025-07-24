Feature: Nostr Network Integration
  As a user
  I want the app to connect to the Nostr network
  So that I can access and sync publications

  Background:
    Given the app is running
    And I have internet connectivity

  Scenario: Relay connection establishment
    When the app initializes
    Then the app should connect to configured relays
    And the app should connect to "wss://thecitadel.nostr1.com"
    And the app should connect to "wss://profiles.nostr1.com"
    And the connections should be established successfully
    And the app should subscribe to publication events

  Scenario: Event subscription
    Given the app is connected to relays
    When the app subscribes to events
    Then the app should subscribe to publication kinds [30040, 30041, 30023, 30818]
    And the app should subscribe to profile kinds [0]
    And the subscription should have a unique ID
    And the subscription should request up to 1000 events

  Scenario: Event reception and processing
    Given the app is subscribed to events
    When a new publication event is received
    Then the event should be parsed as a NostrEvent
    And the event should be stored in the local database
    And the event should be associated with the relay URL
    And the event should have a last sync timestamp
    And the publication should appear in the home screen

  Scenario: Profile event processing
    Given the app is subscribed to events
    When a profile event (kind 0) is received
    Then the event should be parsed as a NostrEvent
    And the profile data should be extracted (name, display_name, picture, about, website)
    And the profile should be stored in the local database
    And the profile should be associated with the author

  Scenario: Publication content parsing
    Given a publication event is received
    When the event is processed
    Then articles (kind 30023) should be parsed as NostrMarkup
    And notes (kind 30041) should be parsed as NostrMarkup
    And wikis (kind 30818) should be parsed as AsciiDoc
    And books (kind 30040) should be parsed with chapter IDs
    And the content should be properly formatted

  Scenario: Background synchronization
    Given the app is running
    When background sync is active
    Then the app should sync every 15 minutes
    And the app should request events since the last sync
    And new events should be downloaded and stored
    And the sync status should be updated

  Scenario: Local relay connection
    Given a local relay is available on localhost:4869
    When the app detects the local relay
    Then the app should connect to the local relay
    And the app should subscribe to events from the local relay
    And local events should be processed alongside remote events

  Scenario: Connection error handling
    Given the app is connected to relays
    When a connection error occurs
    Then the app should attempt to reconnect after 5 seconds
    And the app should log the connection error
    And the app should continue functioning with offline data
    When the connection is restored
    Then the app should resume normal operation

  Scenario: Connection closure handling
    Given the app is connected to relays
    When a connection is closed unexpectedly
    Then the app should detect the closure
    And the app should attempt to reconnect
    And the app should maintain offline functionality
    When the connection is re-established
    Then the app should resume syncing

  Scenario: Network status indicators
    Given the app is monitoring network status
    When the app is online and syncing
    Then the status indicator should show green
    And the status should indicate "Online"
    When the app is online but not syncing
    Then the status indicator should show yellow
    And the status should indicate "Limited"
    When the app is offline
    Then the status indicator should show red
    And the status should indicate "Offline"

  Scenario: Sync status display
    Given the app is syncing with relays
    When sync is in progress
    Then the sync indicator should show a rotating icon
    And the sync indicator should be purple
    When sync is not in progress
    Then the sync indicator should show a static icon
    And the sync indicator should be gray
    When I tap the sync indicator
    Then the app should trigger a manual sync

  Scenario: Event filtering by content type
    Given the app is receiving events from relays
    When I filter by content type
    Then only events of the selected type should be displayed
    And the filter should apply to both local and remote events
    And the filter should persist across app sessions

  Scenario: Search across network events
    Given the app has synced events from relays
    When I search for publications
    Then the search should include events from all connected relays
    And the search should work with offline data
    And the search results should be relevant to the query

  Scenario: Relay-specific event handling
    Given the app is connected to multiple relays
    When events are received from different relays
    Then each event should be tagged with its source relay
    And events from different relays should be deduplicated
    And the most recent version of an event should be kept

  Scenario: Event validation
    Given the app receives events from relays
    When an event is received
    Then the event should be validated for required fields
    And the event should have a valid signature
    And malformed events should be rejected
    And valid events should be processed normally

  Scenario: Subscription management
    Given the app has active subscriptions
    When the app goes to background
    Then the subscriptions should be maintained
    And events should continue to be received
    When the app returns to foreground
    Then the subscriptions should still be active
    And any missed events should be synced

  Scenario: Event storage and retrieval
    Given events are received from relays
    When events are stored locally
    Then the events should be stored in the Isar database
    And the events should be indexed by event ID
    And the events should be indexed by pubkey
    And the events should be indexed by kind
    And the events should be queryable by multiple criteria

  Scenario: Offline functionality
    Given the app has synced events locally
    When I lose internet connectivity
    Then the app should continue to function
    And I should be able to view previously synced publications
    And I should be able to search through local data
    And the app should indicate offline status
    When I regain internet connectivity
    Then the app should resume syncing
    And new events should be downloaded

  Scenario: Event deduplication
    Given the same event is received from multiple relays
    When the events are processed
    Then only one copy of the event should be stored
    And the event should be associated with all source relays
    And the event should not appear multiple times in the UI

  Scenario: Subscription ID management
    Given the app creates subscriptions to relays
    When subscriptions are created
    Then each subscription should have a unique ID
    And the subscription IDs should be generated with timestamps
    And the subscription IDs should be properly formatted
    And the subscription IDs should be used for message routing 