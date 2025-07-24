Feature: Relay Management
  As a user
  I want to manage relay connections and configurations
  So that I can optimize my Nostr network experience

  Background:
    Given I am authenticated with a nostr key
    And the app supports advanced relay management
    And I have access to relay configuration options

  Scenario: Relay discovery and auto-configuration
    Given the app is starting up
    When the app performs relay discovery
    Then the app should automatically detect local relays at ws://localhost:8080
    And the app should automatically detect local relays at ws://localhost:4869
    And the app should discover relays from kind 10432 events
    And the app should discover inbox relays from kind 10002 events
    And the app should exclude blocked relays from kind 10006 events
    And the app should prioritize local relays when available
    And the app should configure discovered relays appropriately

  Scenario: Relay inbox/outbox configuration
    Given I am configuring relay settings
    When I set up relay inboxes and outboxes
    Then I should be able to configure relays as inboxes only
    And I should be able to configure relays as outboxes only
    And I should be able to configure relays as both inboxes and outboxes
    And the app should use inbox relays for fetching events
    And the app should use outbox relays for publishing events
    And the app should handle relay-specific event filtering
    And I should be able to set relay priorities

  Scenario: Relay list management
    Given I am managing relay lists
    When I access relay configuration
    Then I should see my current relay list
    And I should see which relays are configured as inboxes
    And I should see which relays are configured as outboxes
    And I should be able to add new relays to the list
    And I should be able to remove relays from the list
    And I should be able to reorder relays by priority
    And I should be able to import relay lists from kind 10002 events
    And I should be able to export my relay configuration

  Scenario: Relay health monitoring
    Given I am connected to multiple relays
    When I monitor relay health
    Then I should see connection status for each relay
    And I should see response times for each relay
    And I should see success rates for each relay
    And I should see event throughput for each relay
    And I should see uptime statistics for each relay
    And the app should automatically switch to healthy relays
    And the app should log relay performance metrics
    And the app should mark relays as offline when they fail

  Scenario: Relay failover and recovery
    Given I have multiple relays configured
    When a relay becomes unavailable
    Then the app should automatically failover to other relays
    And the app should continue publishing to available outboxes
    And the app should continue fetching from available inboxes
    And the app should retry failed relays periodically
    And the app should maintain a queue of failed events
    When the relay becomes available again
    Then the app should automatically reconnect to the relay
    And the app should sync any missed events
    And the app should process queued events

  Scenario: Relay event filtering and routing
    Given I have relays configured with different purposes
    When events are fetched from relays
    Then the app should fetch metadata events from profile relays
    And the app should fetch content events from content relays
    And the app should fetch social events from social relays
    And the app should handle relay-specific event kinds appropriately
    And the app should avoid duplicate events from multiple relays
    And the app should route events to appropriate relays based on content type

  Scenario: Local relay optimization
    Given I have local relays available
    When I use the app
    Then the app should prioritize local relays for all operations
    And the app should use local relays for faster response times
    And the app should fall back to remote relays when local relays are unavailable
    And the app should sync with local relays when they become available
    And the app should use local relays for real-time updates
    And the app should cache events locally for offline access

  Scenario: Relay URL normalization and validation
    Given I am adding relays to the configuration
    When I add relay URLs
    Then the relays should be normalized to start with "ws://" or "wss://"
    And the relays should end with no trailing "/"
    And duplicate relays should be automatically removed
    And invalid relay URLs should be rejected
    And the normalized URLs should be saved
    And the app should validate relay connectivity before adding

  Scenario: Relay authentication and security
    Given I am configuring relay security
    When I set up relay authentication
    Then I should be able to configure relay-specific authentication
    And I should be able to use relay-specific keys
    And I should be able to configure relay access permissions
    And the app should handle relay authentication failures gracefully
    And the app should support relay-specific encryption

  Scenario: Relay performance optimization
    Given I am optimizing relay performance
    When I configure relay settings
    Then I should be able to set connection timeouts
    And I should be able to configure retry intervals
    And I should be able to set maximum concurrent connections
    And I should be able to configure event buffering
    And I should be able to optimize for latency or throughput

  Scenario: Relay event synchronization
    Given I am syncing events across relays
    When I perform event synchronization
    Then the app should sync events from all configured inboxes
    And the app should publish events to all configured outboxes
    And the app should handle sync conflicts appropriately
    And the app should maintain event consistency across relays
    And the app should sync missed events when reconnecting

  Scenario: Relay backup and restore
    Given I have a configured relay setup
    When I backup my relay configuration
    Then I should be able to export my relay list
    And I should be able to export relay settings
    And I should be able to import relay configurations
    And I should be able to restore relay settings from backup
    And the app should validate imported relay configurations

  Scenario: Relay analytics and reporting
    Given I am monitoring relay performance
    When I access relay analytics
    Then I should see relay usage statistics
    And I should see event throughput metrics
    And I should see connection reliability data
    And I should see relay response time trends
    And I should be able to export relay performance reports

  Scenario: Relay community features
    Given I am using relay community features
    When I access relay community options
    Then I should be able to discover popular relays
    And I should be able to see relay recommendations
    And I should be able to share relay configurations
    And I should be able to join relay communities
    And I should be able to contribute to relay directories 