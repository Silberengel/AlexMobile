Feature: Event Deletion
  As a user
  I want to request deletion of my own events
  So that I can remove content I no longer want to be associated with

  Background:
    Given I am authenticated with a nostr key
    And I have published events that I want to delete
    And the app supports event deletion functionality

  Scenario: Deletion request event creation (NIP-09 kind 5)
    Given I want to delete one of my events
    When I create a deletion request
    Then the app should create a kind 5 event
    And the event should include an 'e' tag with the target event ID
    And the event should include a 'k' tag with the target event kind
    And the event should be properly signed with my nostr key
    And the event should be published to relays

  Scenario: Multiple event deletion request
    Given I want to delete multiple events
    When I create a deletion request
    Then the app should create a kind 5 event
    And the event should include multiple 'e' tags for each target event
    And the event should include 'k' tags for each target event kind
    And all target events should have the same pubkey as the deletion request
    And the event should be properly signed and published

  Scenario: Addressable event deletion request
    Given I want to delete an addressable event
    When I create a deletion request
    Then the app should create a kind 5 event
    And the event should include an 'a' tag with the event coordinates
    And the event coordinates should be in format (kind:pubkey:d-tag)
    And the event should include a 'k' tag with the target event kind
    And the event should be properly signed and published

  Scenario: Deletion request with reason
    Given I want to delete an event with a reason
    When I create a deletion request
    Then I should be able to provide a reason in the content field
    And the reason should be optional and descriptive
    And the reason should help other users understand the deletion
    And the reason should be included in the deletion request event

  Scenario: Deletion request validation
    Given I am creating a deletion request
    When I validate the deletion request
    Then the app should verify that all target events have the same pubkey
    And the app should verify that I own the target events
    And the app should verify that the event is properly signed
    And the app should verify that required tags are present
    And the app should reject invalid deletion requests

  Scenario: Deletion request display
    Given I am viewing a deletion request event
    When I display the deletion request
    Then I should see a clear indication that this is a deletion request
    And I should see the reason for deletion if provided
    And I should see which events are being deleted
    And I should see the timestamp of the deletion request
    And the display should be clearly distinguishable from regular events

  Scenario: Deleted event display
    Given I am viewing an event that has been deleted
    When I display the deleted event
    Then I should see a clear indication that the event has been deleted
    And I should see the deletion reason if available
    And I should see who requested the deletion
    And I should see when the deletion was requested
    And the original content should be replaced or hidden

  Scenario: Deleted event hiding
    Given I am viewing a deleted event
    When I choose to hide deleted events
    Then the deleted event should be completely hidden from view
    And the event should not appear in search results
    And the event should not appear in publication lists
    And the event should not appear in user profiles
    And the hiding should be consistent across the app

  Scenario: Deleted event with replacement content
    Given I am viewing a deleted event
    When I choose to show deletion reason as content
    Then the original content should be replaced with the deletion reason
    And the replacement should be clearly marked as a deletion reason
    And the replacement should not be confused with original content
    And the user interface should clearly indicate this is a deletion request

  Scenario: Deletion request broadcasting
    Given I have created a deletion request
    When I publish the deletion request
    Then the event should be sent to all connected relays
    And the event should be broadcast to other relays
    And the event should be stored locally for reference
    And the event should be available to other clients

  Scenario: Deletion request synchronization
    Given I am viewing events from other users
    When a deletion request is published by an event author
    Then the app should process the deletion request
    And the app should hide or mark the deleted events
    And the app should update the display immediately
    And the app should synchronize the changes across the interface

  Scenario: Deletion request for different event kinds
    Given I want to delete different types of events
    When I create deletion requests
    Then the app should handle text notes (kind 1)
    And the app should handle direct messages (kind 4)
    And the app should handle long-form content (kind 30023)
    And the app should handle publication sections (kind 30041)
    And the app should handle wikis (kind 30818)
    And the app should handle indexes (kind 30040)
    And the app should handle profiles (kind 0)

  Scenario: Deletion request error handling
    Given I am trying to create a deletion request
    When the deletion request fails
    Then the app should handle the error gracefully
    And I should see an appropriate error message
    And the app should provide retry options
    And the app should not lose my deletion request data
    And the app should attempt to publish again when possible

  Scenario: Deletion request permissions
    Given I am trying to delete an event
    When I attempt to create a deletion request
    Then the app should verify that I own the target event
    And the app should only allow deletion of my own events
    And the app should prevent deletion of other users' events
    And the app should show appropriate error messages for unauthorized deletions

  Scenario: Deletion request confirmation
    Given I am about to delete an event
    When I initiate the deletion process
    Then the app should ask for confirmation
    And the app should clearly explain the consequences
    And the app should warn that deletion is not guaranteed
    And the app should allow me to cancel the deletion
    And the app should provide a clear confirmation dialog

  Scenario: Deletion request notification
    Given I have created a deletion request
    When the deletion request is processed
    Then I should receive a notification that the request was sent
    And the notification should explain that deletion is not guaranteed
    And the notification should inform me about the decentralized nature
    And the notification should provide helpful information about the process

  Scenario: Deletion request history
    Given I have created multiple deletion requests
    When I view my deletion history
    Then I should see all my past deletion requests
    And I should see the status of each deletion request
    And I should see which events were targeted for deletion
    And I should see the reasons provided for each deletion
    And the history should be organized and searchable

  Scenario: Deletion request for replaceable events
    Given I want to delete a replaceable event
    When I create a deletion request with an 'a' tag
    Then the app should include the event coordinates in the 'a' tag
    And the app should specify the event kind in the 'k' tag
    And the app should include the pubkey in the coordinates
    And the app should include the d-tag identifier
    And the deletion should apply to all versions up to the deletion timestamp

  Scenario: Deletion request timestamp handling
    Given I am creating a deletion request for replaceable events
    When I specify the deletion timestamp
    Then the deletion should apply to all versions up to that timestamp
    And the app should use the deletion request's created_at timestamp
    And the app should handle timezone differences appropriately
    And the app should ensure consistent timestamp handling

  Scenario: Deletion request relay behavior
    Given I am a relay operator
    When I receive a deletion request
    Then I should delete or stop publishing referenced events
    And I should only delete events with matching pubkey
    And I should continue publishing the deletion request event
    And I should not treat relay validation as authoritative
    And I should handle cases where referenced events are unknown

  Scenario: Deletion request client validation
    Given I am a client processing deletion requests
    When I validate a deletion request
    Then I should verify that each 'e' tag pubkey matches the request pubkey
    And I should verify the deletion request signature
    And I should verify that required tags are present
    And I should reject invalid deletion requests
    And I should not rely on relay validation

  Scenario: Deletion request of deletion request
    Given I am trying to delete a deletion request event
    When I create a deletion request for a deletion request
    Then the app should inform me that this has no effect
    And the app should explain that "unrequest deletion" is not supported
    And the app should prevent this type of deletion request
    And the app should provide clear guidance about this limitation

  Scenario: Deletion request privacy
    Given I am creating deletion requests
    When I handle deletion request data
    Then my deletion requests should be properly signed
    And my deletion requests should be associated with my identity
    And the app should respect privacy settings
    And the app should handle private deletion requests appropriately
    And the app should maintain security of my private key

  Scenario: Deletion request analytics
    Given I am viewing deletion request data
    When I analyze deletion patterns
    Then I should see meaningful analytics about deletions
    And the analytics should help understand content moderation
    And the analytics should be privacy-respecting
    And the analytics should provide useful insights for content management

  Scenario: Deletion request moderation
    Given I am viewing deletion requests
    When I see problematic deletion requests
    Then I should be able to report problematic deletion requests
    And the app should provide moderation tools for deletions
    And the app should handle deletion request moderation appropriately
    And the app should maintain a safe environment
    And the app should respect community guidelines

  Scenario: Deletion request network handling
    Given I am creating deletion requests
    When there are network connectivity issues
    Then the app should handle offline scenarios
    And the deletion request should be queued for when connectivity returns
    And the app should provide clear status information
    And the app should retry when connectivity is restored
    And the app should not lose deletion request data

  Scenario: Deletion request user education
    Given I am using the deletion feature
    When I create deletion requests
    Then the app should educate me about the decentralized nature
    And the app should explain that deletion is not guaranteed
    And the app should provide information about relay behavior
    And the app should offer best practices for content management
    And the app should help me understand the implications of deletion 