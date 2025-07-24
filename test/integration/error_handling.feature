Feature: Error Handling
  As a user
  I want the app to handle errors gracefully
  So that I can continue using the app even when problems occur

  Background:
    Given I am using the Alex Reader app
    And the app has error handling capabilities

  Scenario: Network connection errors
    Given I have no internet connectivity
    When I try to sync with relays
    Then the app should handle the network error gracefully
    And the app should continue functioning with offline data
    And the app should show an appropriate error message
    And the app should provide a retry option
    When I regain internet connectivity
    Then the app should automatically retry the sync
    And the sync should complete successfully

  Scenario: Relay connection errors
    Given I am connected to relays
    When a relay connection fails
    Then the app should detect the connection failure
    And the app should attempt to reconnect after 5 seconds
    And the app should log the connection error
    And the app should continue functioning with other relays
    When the relay connection is restored
    Then the app should resume normal operation

  Scenario: Data parsing errors
    Given I receive malformed data from relays
    When the app processes the data
    Then the app should validate the data structure
    And malformed events should be rejected
    And the app should log parsing errors
    And the app should continue processing valid events
    And the app should not crash due to parsing errors

  Scenario: Database errors
    Given I encounter database errors
    When I try to access stored publications
    Then the app should handle the database error gracefully
    And the app should show an appropriate error message
    And the app should provide recovery options
    And the app should not crash due to database errors
    When the database error is resolved
    Then the app should resume normal operation

  Scenario: Publication loading errors
    Given I try to load a publication
    When the publication fails to load
    Then the app should show an error message
    And the error should display "Error loading publication"
    And the error should show specific error details
    And the app should provide a retry option
    When I tap the retry button
    Then the app should attempt to load the publication again

  Scenario: Chapter loading errors
    Given I am viewing a book with chapters
    When some chapters fail to load
    Then the app should handle the error gracefully
    And the book header should still be displayed
    And the available chapters should be shown
    And the app should indicate which chapters failed to load
    And the app should provide retry options

  Scenario: Content rendering errors
    Given I am viewing a publication with formatting errors
    When I view the content
    Then the content should be rendered gracefully
    And formatting errors should not break the display
    And the content should still be readable
    And the app should log rendering errors
    And the app should continue functioning normally

  Scenario: Authentication errors
    Given I attempt to authenticate
    When the authentication fails
    Then the app should handle the authentication error gracefully
    And I should remain unauthenticated
    And the app should show an appropriate error message
    And the app should provide retry options
    And the app should continue functioning normally

  Scenario: Search errors
    Given I perform a search
    When the search encounters an error
    Then the app should handle the search error gracefully
    And the app should show an appropriate error message
    And the app should provide retry options
    And the app should not crash due to search errors
    When I retry the search
    Then the app should attempt the search again

  Scenario: Sync errors
    Given I am syncing with relays
    When the sync encounters an error
    Then the app should handle the sync error gracefully
    And the app should show an appropriate error message
    And the app should provide retry options
    And the app should continue functioning with local data
    When I retry the sync
    Then the app should attempt to sync again

  Scenario: Memory errors
    Given I am using the app extensively
    When the app encounters memory issues
    Then the app should handle memory errors gracefully
    And the app should clean up unused resources
    And the app should show an appropriate error message
    And the app should not crash due to memory issues
    And the app should continue functioning normally

  Scenario: Storage errors
    Given I am storing publications locally
    When the app encounters storage errors
    Then the app should handle storage errors gracefully
    And the app should show an appropriate error message
    And the app should provide recovery options
    And the app should not crash due to storage errors
    And the app should continue functioning normally

  Scenario: UI error handling
    Given I encounter UI-related errors
    When the UI encounters an error
    Then the app should handle UI errors gracefully
    And the app should show an appropriate error message
    And the app should provide recovery options
    And the app should not crash due to UI errors
    And the app should continue functioning normally

  Scenario: Error message display
    Given I encounter an error
    When the error is displayed
    Then the error message should be clear and understandable
    And the error message should provide helpful information
    And the error message should follow the Zapchat design system
    And the error message should be properly centered
    And the error message should include a retry option when appropriate

  Scenario: Error recovery
    Given I encounter an error
    When I attempt to recover from the error
    Then the app should provide recovery options
    And the recovery should be automatic when possible
    And the recovery should be manual when necessary
    And the recovery should be successful
    And the app should resume normal operation

  Scenario: Error logging
    Given I encounter various errors
    When errors occur
    Then the app should log errors appropriately
    And the error logs should include relevant details
    And the error logs should be helpful for debugging
    And the error logs should not expose sensitive information
    And the error logs should be accessible to developers

  Scenario: Graceful degradation
    Given I encounter errors in non-critical features
    When the errors occur
    Then the app should continue functioning with reduced features
    And the app should indicate which features are unavailable
    And the app should provide alternative options when possible
    And the app should not crash due to non-critical errors

  Scenario: Error prevention
    Given I am using the app normally
    When I perform various operations
    Then the app should prevent common errors
    And the app should validate input data
    And the app should handle edge cases gracefully
    And the app should provide helpful feedback
    And the app should guide users away from error-prone actions

  Scenario: Error state persistence
    Given I encounter an error
    When I navigate away from the error screen
    And I return to the same context
    Then the error state should be handled appropriately
    And the app should not get stuck in an error state
    And the app should provide recovery options
    And the app should resume normal operation when possible

  Scenario: Error communication
    Given I encounter an error
    When the error is communicated to me
    Then the error message should be user-friendly
    And the error message should explain what went wrong
    And the error message should suggest what I can do
    And the error message should not be technical jargon
    And the error message should follow the app's design language 