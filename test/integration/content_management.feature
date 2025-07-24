Feature: Content Management
  As a user
  I want to browse and manage content
  So that I can find and interact with publications

  Background:
    Given I am authenticated with a nostr key
    And the app is displaying content from relays
    And I have access to various content types

  Scenario: Home screen display
    Given I am on the home screen
    When I view the content
    Then I should see publication cards in a grid layout
    And I should see publication thumbnails
    And I should see publication titles
    And I should see author information
    And I should see version information when available
    And I should see a three-dot menu on each card

  Scenario: Content tabs functionality
    Given I am viewing the content tabs
    When I click the "Publications" tab
    Then I should see all publication types (default landing page)
    And the tab should be highlighted as active
    When I click the "Articles" tab
    Then I should see only kind 30023 articles
    And the tab should be highlighted as active
    When I click the "Wikis" tab
    Then I should see only kind 30818 wikis
    And the tab should be highlighted as active
    When I click the "Notes" tab
    Then I should see only kind 30041 notes
    And the tab should be highlighted as active

  Scenario: Content tab visibility
    Given I am viewing the app on a monitor
    When I look at the content tabs
    Then all four tabs should be visible without scrolling
    And the tabs should be arranged horizontally
    And the tabs should have equal spacing
    And the tabs should be responsive to screen size

  Scenario: Publication card display
    Given I am viewing publication cards
    When I look at a publication card
    Then I should see a thumbnail image on the left
    And I should see the publication title in white text
    And I should see the author line (e.g., "by unknown" or npub)
    And I should see version information when available
    And I should see a three-dot menu icon in the bottom-right corner
    And the card should have a dark grey background

  Scenario: Content type filtering
    Given I am viewing content
    When I select different content tabs
    Then the "Publications" tab should show all content types
    And the "Articles" tab should show only kind 30023 content
    And the "Wikis" tab should show only kind 30818 content
    And the "Notes" tab should show only kind 30041 content
    And the content should be properly filtered by kind

  Scenario: Search functionality
    Given I am viewing the search bar
    When I enter search terms
    Then I should be able to search by publication title
    And I should be able to search by author
    And the search should work across all content types
    And the search results should update in real-time
    And the search should be case-insensitive

  Scenario: Content filtering
    Given I am viewing content
    When I apply filters
    Then I should be able to filter by content type
    And I should be able to filter by author
    And I should be able to filter by date range
    And I should be able to filter by tags
    And the filters should work in combination

  Scenario: Content rendering
    Given I am viewing content
    When content is loaded
    Then publications should render properly
    And images should display correctly
    And text should be readable
    And links should be clickable
    And the layout should be responsive

  Scenario: Content navigation
    Given I am viewing content
    When I interact with content
    Then I should be able to click on publication cards
    And I should be able to access publication details
    And I should be able to return to the content list
    And navigation should be smooth

  Scenario: Content refresh
    Given I am viewing content
    When I refresh the content
    Then the app should fetch new content from relays
    And the app should show loading indicators
    And the app should handle refresh errors gracefully
    And the app should update the content list

  Scenario: Data management
    Given I am using the app
    When I manage data
    Then the app should cache content locally
    And the app should sync with relays when online
    And the app should handle offline content access
    And the app should manage storage efficiently

  Scenario: Offline access
    Given I am offline
    When I access content
    Then I should be able to view cached content
    And I should see offline indicators
    And I should be able to queue content requests
    And the app should sync when back online

  Scenario: Content pagination
    Given I am viewing content
    When I scroll through content
    Then the app should load more content as I scroll
    And the app should show loading indicators during pagination
    And the app should handle pagination errors gracefully
    And the app should maintain scroll position

  Scenario: Content sorting
    Given I am viewing content
    When I sort content
    Then I should be able to sort by date (newest first)
    And I should be able to sort by date (oldest first)
    And I should be able to sort by title (A-Z)
    And I should be able to sort by title (Z-A)
    And I should be able to sort by author
    And the sorting should work across all content types

  Scenario: Content recommendations
    Given I am viewing content
    When I browse content
    Then I should see content based on my reading history
    And I should see content from authors I follow
    And I should see trending content
    And I should see recently published content

  Scenario: Content sharing
    Given I am viewing content
    When I share content
    Then I should be able to share publication links
    And I should be able to share publication metadata
    And I should be able to share to external apps
    And the sharing should include proper attribution

  Scenario: Content analytics
    Given I am viewing content
    When I interact with content
    Then the app should track reading time
    And the app should track content interactions
    And the app should track content sharing
    And the app should provide reading statistics

  Scenario: Content moderation
    Given I am viewing content
    When I encounter inappropriate content
    Then I should be able to report content
    And I should be able to mute authors
    And I should be able to block content types
    And the app should handle moderation actions appropriately 