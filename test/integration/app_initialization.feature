Feature: App Initialization
  As a user
  I want the app to initialize properly
  So that I can start using the Alex Reader

  Background:
    Given the app is not running
    And the device has internet connectivity

  Scenario: Successful app initialization
    When I launch the Alex Reader app
    Then I should see the splash screen with the app icon
    And the splash screen should display "Alex Reader" title
    And the splash screen should display "Nostr E-Reader" subtitle
    And I should see a loading indicator with purple color
    And the loading indicator should display "Initializing..." text
    Then after initialization completes
    And I should be taken to the home screen
    And the app should be ready to use

  Scenario: App initialization with demo data
    Given the app has no existing publications
    When I launch the Alex Reader app
    Then the app should populate with demo data
    And I should see sample publications on the home screen

  Scenario: App initialization with existing data
    Given the app has existing publications stored locally
    When I launch the Alex Reader app
    Then the app should load existing publications
    And I should see the stored publications on the home screen

  Scenario: App initialization with network error
    Given the device has no internet connectivity
    When I launch the Alex Reader app
    Then I should see the splash screen
    And after initialization completes
    And I should be taken to the home screen
    And the app should work with offline data

  Scenario: App initialization failure
    Given the app encounters a critical error during initialization
    When I launch the Alex Reader app
    Then I should see an error screen
    And the error screen should display "Failed to initialize app"
    And the error screen should show the specific error message
    And I should see a "Retry" button
    When I tap the "Retry" button
    Then the app should attempt to initialize again

  Scenario: App restart after error
    Given the app failed to initialize
    And I am on the error screen
    When I tap the "Retry" button
    Then the app should restart the initialization process
    And I should see the splash screen again
    And if initialization succeeds
    Then I should be taken to the home screen

  Scenario: Database initialization
    When I launch the Alex Reader app
    Then the Isar database should be initialized
    And the NostrEvent schema should be registered
    And the database should be ready for storing publications

  Scenario: Service initialization
    When I launch the Alex Reader app
    Then the EventRepository should be initialized
    And the NostrService should be initialized
    And the AuthService should be initialized
    And all providers should be properly configured

  Scenario: Theme initialization
    When I launch the Alex Reader app
    Then the ZapchatTheme should be applied
    And the app should use the light theme by default
    And the app should support dark theme switching
    And all UI elements should follow the Zapchat design system 