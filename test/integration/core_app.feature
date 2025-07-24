Feature: Core App Functionality
  As a user
  I want to use the basic app features
  So that I can authenticate, navigate, and access content

  Background:
    Given I am using the Alex Reader app
    And the app is properly initialized

  Scenario: App initialization
    Given the app is starting up
    When the app initializes
    Then the app should load successfully
    And I should see the home screen
    And the app should check authentication status
    And the app should connect to configured relays
    And the app should display appropriate status indicators

  Scenario: Header navigation layout
    Given I am viewing the app
    When I look at the top header
    Then I should see "Alexandria Mobile" label in the top-left
    And I should see a profile icon in the top-right
    And I should see a theme toggle icon (sun/moon) next to the profile icon
    And clicking the "Alexandria Mobile" label should return me to the home/publications page
    And clicking the profile icon should open the profile menu

  Scenario: Profile menu functionality
    Given I am viewing the app
    When I click the profile icon in the top-right
    Then a profile menu should open
    And I should see a "View Profile" option
    And I should see a "Settings" option
    And I should see a "Discussions" option
    When I click "View Profile"
    Then I should be taken to my profile page
    When I click "Settings"
    Then I should be taken to the settings page
    When I click "Discussions"
    Then I should be taken to the kind 11 bulletin-board style feed

  Scenario: Search bar placement
    Given I am viewing the app
    When I look below the navigation bar
    Then I should see a search bar
    And the search bar should be centered
    And the search bar should have placeholder text "Search events by title or author..."
    And the search bar should be visible without scrolling

  Scenario: Content tabs layout
    Given I am viewing the app
    When I look below the search bar
    Then I should see content tabs
    And I should see a "Publications" tab (default/landing page)
    And I should see an "Articles" tab (kind 30023)
    And I should see a "Wikis" tab (kind 30818)
    And I should see a "Notes" tab (kind 30041)
    And all tabs should be visible on the monitor without scrolling
    And the "Publications" tab should be selected by default
    And clicking each tab should show the appropriate content type

  Scenario: Dark/light theme toggle
    Given I am viewing the app
    When I look at the theme toggle icon
    Then I should see a sun/moon icon
    And the app should be in dark mode by default
    When I click the theme toggle
    Then the app should switch between dark and light themes
    And the theme should match the design shown in the reference image
    And the theme should persist across app sessions

  Scenario: Authentication status display
    Given I am not authenticated
    When I look at the app bar
    Then I should see a login icon indicating unauthenticated state
    When I become authenticated
    Then I should see a person icon indicating authenticated state

  Scenario: Basic authentication
    Given I am not authenticated
    When I tap the authentication icon
    Then the app should attempt to log me in
    And the app should show a loading state during login
    When the login is successful
    Then I should see the person icon
    And my authentication status should be updated
    And the app should remember my authentication state

  Scenario: Logout functionality
    Given I am authenticated
    When I tap the authentication icon
    Then the app should log me out
    And I should see the login icon
    And my authentication status should be updated

  Scenario: Network status display
    Given I have network connectivity
    When I look at the status indicator
    Then I should see a green indicator for online status
    When I lose network connectivity
    Then I should see a red indicator for offline status
    When I have limited connectivity
    Then I should see a yellow indicator for limited status

  Scenario: Basic relay connection
    Given the app is connecting to relays
    When relay connections are established
    Then the app should show connection status for each relay
    And the app should handle relay connection failures gracefully
    And the app should retry failed connections automatically

  Scenario: Offline behavior
    Given I am offline
    When I use the app
    Then I should be able to view cached content
    And I should see offline indicators
    And I should be able to queue actions for when online
    And the app should not crash or show errors
    When I come back online
    Then the app should automatically sync with relays
    And queued actions should be processed

  Scenario: Error handling
    Given an error occurs in the app
    When the app encounters an error
    Then the app should handle the error gracefully
    And I should see appropriate error feedback
    And the app should continue to function normally
    And the app should provide recovery options when possible

  Scenario: Basic navigation
    Given I am on the home screen
    When I navigate through the app
    Then I should be able to access the reader screen
    And I should be able to access the index reader screen
    And I should be able to return to the home screen
    And navigation should be smooth and responsive

  Scenario: Content loading
    Given I am authenticated
    When I access content
    Then the app should load publications from relays
    And the app should display loading indicators
    And the app should handle content loading errors gracefully
    And the app should cache content for offline access

  Scenario: Event publishing
    Given I am authenticated
    When I publish an event
    Then the app should create and sign the event
    And the app should first save the event in the database
    And then the app should try to broadcast the event to all available relays
    And it should respond gracefully, if a relay is not available
    And if it is offline, then it should rebroadcast again, to the remote relays, when it comes back online

  Scenario: App state persistence
    Given I am using the app
    When I close the app
    And I reopen the app
    Then my authentication state should be preserved
    And my last viewed content should be restored
    And my app preferences should be maintained
    And my cached content should still be available

  Scenario: Database initialization
    Given the app is starting up
    When the database is initialized
    Then the app should create necessary database tables
    And the app should handle database migration gracefully
    And the app should cache events locally for offline access
    And the app should sync with relays when online

  Scenario: App performance
    Given I am using the app
    When I perform various actions
    Then the app should respond quickly to user interactions
    And the app should not freeze or become unresponsive
    And the app should handle large amounts of content efficiently
    And the app should use memory efficiently

  Scenario: App lifecycle management
    Given the app is running
    When the app goes to background
    Then the app should pause non-essential operations
    And the app should save current state
    When the app returns to foreground
    Then the app should resume normal operations
    And the app should refresh content if needed