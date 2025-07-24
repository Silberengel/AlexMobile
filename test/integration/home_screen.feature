Feature: Home Screen
  As a user
  I want to browse and manage publications
  So that I can find and read content easily

  Background:
    Given I am on the home screen
    And there are publications available

  Scenario: Home screen layout
    Then I should see the app bar with "Alex Reader" title
    And the app bar should display the library books icon
    And I should see a search bar below the app bar
    And I should see content type filter chips
    And I should see a list of publication cards
    And I should see a bottom navigation bar
    And I should see a floating action button with "New" label

  Scenario: Publication cards display
    Given there are publications in the list
    When I view the publication cards
    Then each card should display the publication title
    And each card should display the publication summary
    And each card should display the author information
    And each card should display the publication date
    And each card should display the content type icon
    And each card should have a cover image if available

  Scenario: Publication card interaction
    Given I see a publication card
    When I tap on a publication card
    Then I should be navigated to the appropriate reader screen
    And if the publication is a book (kind 30040)
    Then I should be taken to the index reader screen
    And if the publication is an article, note, or wiki
    Then I should be taken to the reader screen

  Scenario: Search functionality
    Given I am on the home screen
    When I tap on the search bar
    Then the keyboard should appear
    And I should see "Search publications..." placeholder text
    When I type a search query
    Then the search should be debounced by 500ms
    And the publications list should filter based on the query
    And I should see a clear button (X) when text is entered
    When I tap the clear button
    Then the search should be cleared
    And all publications should be shown again

  Scenario: Search submission
    Given I have entered a search query
    When I tap the search button on the keyboard
    Then the search should be executed immediately
    And the publications list should update with search results

  Scenario: Content type filtering
    Given I am on the home screen
    When I tap on "All" filter chip
    Then all publication types should be shown
    When I tap on "Books" filter chip
    Then only book publications (kind 30040) should be shown
    When I tap on "Articles" filter chip
    Then only article publications (kind 30023) should be shown
    When I tap on "Notes" filter chip
    Then only note publications (kind 30041) should be shown
    When I tap on "Wikis" filter chip
    Then only wiki publications (kind 30818) should be shown

  Scenario: Pull to refresh
    Given I am on the home screen
    When I pull down on the publications list
    Then the list should show a refresh indicator
    And the publications should be refreshed from the network
    And new publications should be loaded if available

  Scenario: Infinite scrolling
    Given there are more publications available
    When I scroll to the bottom of the list
    Then more publications should be loaded automatically
    And a loading indicator should appear at the bottom
    And the new publications should be added to the list

  Scenario: Empty state
    Given there are no publications available
    When I view the home screen
    Then I should see an empty state message
    And the empty state should display "No publications found"
    And the empty state should show a library books icon
    And the empty state should suggest pulling to refresh

  Scenario: Loading state
    Given the app is loading publications
    When I view the home screen
    Then I should see shimmer loading cards
    And the shimmer cards should have placeholder content
    And the shimmer effect should be visible

  Scenario: Error state
    Given there was an error loading publications
    When I view the home screen
    Then I should see an error message
    And the error should display "Error loading publications"
    And I should see a "Retry" button
    When I tap the "Retry" button
    Then the publications should be loaded again

  Scenario: Sync status indicator
    Given I am on the home screen
    When the app is syncing with relays
    Then I should see a syncing indicator in the app bar
    And the sync indicator should show a rotating icon
    When the app is not syncing
    Then I should see a static sync icon
    When I tap the sync indicator
    Then the publications should be refreshed

  Scenario: Authentication status
    Given I am on the home screen
    When I am not authenticated
    Then I should see a login icon in the app bar
    When I am authenticated
    Then I should see a person icon in the app bar
    When I tap the authentication icon
    Then I should be logged in or out accordingly

  Scenario: Bottom navigation
    Given I am on the home screen
    When I tap on different bottom navigation items
    Then the navigation should respond to taps
    And the current index should be highlighted

  Scenario: Floating action button
    Given I am on the home screen
    When I tap the floating action button
    Then the button should respond to the tap
    And the button should show a "New" label with add icon

  Scenario: Network connectivity handling
    Given I have no internet connectivity
    When I am on the home screen
    Then the app should work with offline data
    And I should see a network status indicator
    And the status should show red for offline
    When I regain internet connectivity
    Then the app should sync with relays
    And the status should show green for online 