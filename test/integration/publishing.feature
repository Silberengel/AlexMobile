Feature: Publishing
  As a user
  I want to publish events to the Nostr network with proper local storage and broadcasting
  So that my content is reliably distributed and managed

  Background:
    Given I am using the Alex Reader app
    And I have authentication capabilities
    And the app has publishing functionality

  Scenario: Local database storage for published events
    Given I am creating a new event to publish
    When I submit the event for publishing
    Then the event should be signed with my private key
    And the signed event should be stored in the local database first
    And the event should be marked as "published" in the database
    And the event should have a timestamp of when it was published
    And the event should be associated with my identity

  Scenario: Draft creation and storage
    Given I am creating a new event
    When I save the event as a draft
    Then the draft should be stored in the local database
    And the draft should be marked as "draft" status
    And the draft should be editable and deletable
    And the draft should not be broadcasted to relays
    And the draft should be accessible from a drafts section

  Scenario: Draft management
    Given I have drafts stored in the database
    When I view my drafts
    Then I should see all my saved drafts
    And I should be able to edit any draft
    And I should be able to delete any draft
    And I should be able to publish any draft
    And the drafts should be organized by creation date

  Scenario: Draft editing
    Given I am viewing a draft
    When I edit the draft
    Then I should be able to modify all fields of the draft
    And the changes should be saved automatically
    And I should be able to preview the draft
    And I should be able to publish the edited draft
    And the original draft should be updated with changes

  Scenario: Draft publishing
    Given I am viewing a draft
    When I choose to publish the draft
    Then the draft should be signed with my private key
    And the signed event should be stored in the database
    And the event should be marked as "published"
    And the draft should be removed from the drafts section
    And the event should be queued for broadcasting

  Scenario: Immediate broadcasting attempt
    Given I have a signed event ready for broadcasting
    When the event is published
    Then the app should attempt to broadcast immediately
    And the broadcast should be sent to all available relays
    And the broadcast should include the local relay if available
    And the broadcast should happen in the background
    And the UI should not be blocked during broadcasting

  Scenario: Network failure handling
    Given I am publishing an event
    When there is no network connectivity
    Then the event should still be stored in the local database
    And the event should be marked as "pending broadcast"
    And the app should not throw errors
    And the app should log the broadcast failure
    And the event should be queued for retry

  Scenario: Broadcast retry mechanism
    Given I have events pending broadcast
    When the network becomes available
    Then the app should detect the network restoration
    And the app should automatically retry broadcasting
    And all pending events should be broadcasted
    And the events should be marked as "broadcasted"
    And the retry should happen in the background

  Scenario: Broadcast logging
    Given I am publishing events
    When broadcasting occurs
    Then all broadcast attempts should be logged
    And the logs should include success/failure status
    And the logs should include relay information
    And the logs should include timestamps
    And the logs should be accessible to the user

  Scenario: Database viewer/editor access
    Given I want to manage published events
    When I access the database viewer/editor
    Then I should see all events in the database
    And I should be able to perform CRUD operations
    And I should see the broadcast status of each event
    And I should be able to force retry of failed broadcasts
    And I should be able to modify relay configurations

  Scenario: Relay management
    Given I am in the database viewer/editor
    When I view relay configurations
    Then I should see all available relays
    And I should see the connection status of each relay
    And I should be able to add new relays
    And I should be able to remove existing relays
    And I should be able to configure relays as inbox/outbox

  Scenario: Standard relay set configuration
    Given I am configuring relays
    When I set up the standard relay set
    Then all relays should be configured as both inbox and outbox by default
    And I should be able to change individual relay configurations
    And I should be able to set relays as inbox-only
    And I should be able to set relays as outbox-only
    And the configuration should be persistent

  Scenario: Timed broadcasting
    Given I am publishing an event
    When I choose timed publishing
    Then I should be able to schedule the broadcast time
    And the event should be stored as "scheduled"
    And the event should be broadcasted at the scheduled time
    And I should be able to modify or cancel scheduled broadcasts
    And the scheduling should work even when the app is closed

  Scenario: Broadcast queue management
    Given I have events in the broadcast queue
    When I view the queue
    Then I should see all pending broadcasts
    And I should see the status of each broadcast attempt
    And I should be able to retry failed broadcasts manually
    And I should be able to cancel pending broadcasts
    And I should see detailed logs for each broadcast attempt

  Scenario: Event deletion with relay notification
    Given I am deleting a published event from the database
    When I confirm the deletion
    Then the app should ask if I want to publish a kind 05 deletion request
    And if I choose to publish the deletion request
    Then the deletion request should be signed and broadcasted
    And the relays should be informed to remove the event
    And the deletion request should be stored in the database

  Scenario: Broadcast status tracking
    Given I have published events
    When I view the broadcast status
    Then I should see which relays received each event
    And I should see which relays failed to receive events
    And I should see timestamps for each broadcast attempt
    And I should see success/failure rates for each relay
    And I should be able to troubleshoot relay issues

  Scenario: Relay health monitoring
    Given I am monitoring relay connections
    When I view relay health
    Then I should see connection status for each relay
    And I should see response times for each relay
    And I should see success rates for each relay
    And I should be able to test relay connectivity
    And I should be able to prioritize reliable relays

  Scenario: Broadcast optimization
    Given I am broadcasting to multiple relays
    When the broadcast occurs
    Then the app should optimize the broadcast process
    And the app should handle slow relays gracefully
    And the app should not wait for all relays to respond
    And the app should continue functioning during broadcast
    And the app should prioritize successful relays

  Scenario: Event signing verification
    Given I am publishing an event
    When the event is signed
    Then the signature should be verified before storage
    And the signature should be verified before broadcasting
    And the app should handle signature errors gracefully
    And the app should provide clear error messages for signature issues
    And the app should not broadcast invalid signatures

  Scenario: Content validation
    Given I am creating an event to publish
    When I submit the event
    Then the content should be validated before signing
    And the event structure should be validated
    And the app should prevent invalid events from being published
    And the app should provide clear validation error messages
    And the app should help fix validation issues

  Scenario: Publishing permissions
    Given I am attempting to publish an event
    When I am not authenticated
    Then the app should prompt me to authenticate
    And the app should not allow publishing without authentication
    And the app should explain why authentication is required
    When I am authenticated
    Then I should be able to publish events freely
    And my events should be properly signed with my key

  Scenario: Publishing history
    Given I have published multiple events
    When I view my publishing history
    Then I should see all my published events
    And I should see the broadcast status of each event
    And I should see the timestamps of each publication
    And I should be able to view detailed logs for each event
    And I should be able to republish failed events

  Scenario: Publishing analytics
    Given I have been publishing events
    When I view publishing analytics
    Then I should see statistics about my publications
    And I should see broadcast success rates
    And I should see which relays are most reliable
    And I should see publishing patterns and trends
    And the analytics should help improve publishing success

  Scenario: Offline publishing queue
    Given I am offline
    When I create events to publish
    Then the events should be stored in the local database
    And the events should be marked as "pending broadcast"
    And the events should be queued for when connectivity returns
    And I should be able to view the pending queue
    And I should be able to modify or cancel pending events

  Scenario: Publishing error recovery
    Given I encounter publishing errors
    When the errors occur
    Then the app should handle errors gracefully
    And the app should not lose my event data
    And the app should provide clear error messages
    And the app should suggest solutions for common errors
    And the app should allow me to retry failed operations 