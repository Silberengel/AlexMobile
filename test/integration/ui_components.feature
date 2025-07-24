Feature: UI Components
  As a user
  I want the UI components to work consistently and elegantly
  So that I can interact with the app effectively

  Background:
    Given I am using the Alex Reader app
    And the app follows the Zapchat design system

  Scenario: Search bar functionality
    Given I am on the home screen
    When I tap the search bar
    Then the keyboard should appear
    And I should see "Search publications..." placeholder text
    And the search bar should have a search icon
    When I type text
    Then the text should appear in the search bar
    And a clear button (X) should appear
    When I tap the clear button
    Then the search should be cleared
    And the keyboard should be dismissed
    When I tap the search button on the keyboard
    Then the search should be executed
    And the keyboard should be dismissed

  Scenario: Search bar styling
    Given I am viewing the search bar
    When I look at the search bar design
    Then the search bar should have rounded corners
    And the search bar should have a subtle border
    And the search bar should have a shadow
    And the search bar should follow the Zapchat theme
    And the search bar should be properly sized

  Scenario: Content type filter chips
    Given I am on the home screen
    When I view the content type filter chips
    Then I should see "All", "Books", "Articles", "Notes", "Wikis" chips
    And each chip should have an appropriate icon
    And the selected chip should be highlighted in purple
    And unselected chips should be gray
    When I tap a different chip
    Then the selection should change
    And the publications should be filtered accordingly

  Scenario: Filter chip styling
    Given I am viewing the filter chips
    When I look at the chip design
    Then the chips should have rounded corners
    And the chips should have proper spacing
    And the chips should be horizontally scrollable
    And the chips should follow the Zapchat design system
    And the chips should provide visual feedback on tap

  Scenario: Status indicators
    Given I am viewing the status indicators
    When the app is online and syncing
    Then the status should show green color
    And the status should indicate "Online"
    When the app is online but not syncing
    Then the status should show yellow color
    And the status should indicate "Limited"
    When the app is offline
    Then the status should show red color
    And the status should indicate "Offline"

  Scenario: Sync indicator
    Given I am viewing the sync indicator
    When sync is in progress
    Then the sync icon should rotate
    And the sync icon should be purple
    And the rotation should be smooth
    When sync is not in progress
    Then the sync icon should be static
    And the sync icon should be gray
    When I tap the sync indicator
    Then a manual sync should be triggered

  Scenario: Publication cards
    Given I am viewing publication cards
    When I look at the card design
    Then the cards should have rounded corners
    And the cards should have subtle shadows
    And the cards should have proper spacing
    And the cards should display publication information clearly
    And the cards should be responsive to taps

  Scenario: Publication card content
    Given I am viewing a publication card
    When I look at the card content
    Then I should see the publication title
    And I should see the publication summary
    And I should see the author information
    And I should see the publication date
    And I should see the content type icon
    And I should see the cover image if available

  Scenario: Bottom navigation
    Given I am viewing the bottom navigation
    When I look at the navigation design
    Then the navigation should have multiple tabs
    And the current tab should be highlighted
    And the tabs should be properly spaced
    And the navigation should follow the Zapchat design system
    When I tap a different tab
    Then the selection should change
    And the appropriate screen should be displayed

  Scenario: Floating action button
    Given I am viewing the floating action button
    When I look at the FAB design
    Then the FAB should be circular
    And the FAB should have the add icon
    And the FAB should have a "New" label
    And the FAB should be positioned in the bottom right
    And the FAB should follow the Zapchat design system
    When I tap the FAB
    Then the button should respond to the tap
    And the appropriate action should be triggered

  Scenario: Loading states
    Given I am viewing a loading state
    When I look at the loading indicator
    Then the loading indicator should be circular
    And the loading indicator should be purple
    And the loading indicator should be properly sized
    And the loading indicator should be centered
    And the loading indicator should be smooth

  Scenario: Shimmer loading
    Given I am viewing shimmer loading cards
    When I look at the shimmer effect
    Then the shimmer should be animated
    And the shimmer should have placeholder content
    And the shimmer should follow the card layout
    And the shimmer should be smooth and continuous

  Scenario: Error states
    Given I am viewing an error state
    When I look at the error display
    Then the error should show an error icon
    And the error should show an error message
    And the error should show a retry button
    And the error should be properly centered
    And the error should follow the Zapchat design system

  Scenario: Empty states
    Given I am viewing an empty state
    When I look at the empty state display
    Then the empty state should show an appropriate icon
    And the empty state should show a descriptive message
    And the empty state should be properly centered
    And the empty state should follow the Zapchat design system

  Scenario: App bar design
    Given I am viewing the app bar
    When I look at the app bar design
    Then the app bar should show the app title
    And the app bar should show the app icon
    And the app bar should show status indicators
    And the app bar should show authentication status
    And the app bar should follow the Zapchat design system

  Scenario: Table of contents panel
    Given I am viewing the table of contents panel
    When I look at the panel design
    Then the panel should be 300 pixels wide
    And the panel should have a left border
    And the panel should show section headers
    And the panel should be scrollable if needed
    And the panel should follow the Zapchat design system

  Scenario: Reading progress indicator
    Given I am viewing the reading progress indicator
    When I look at the progress display
    Then the progress should be visually represented
    And the progress should show a percentage
    And the progress should be properly sized
    And the progress should follow the Zapchat design system

  Scenario: Chapter cards
    Given I am viewing chapter cards
    When I look at the chapter card design
    Then the cards should have rounded corners
    And the cards should show chapter numbers
    And the cards should show chapter titles
    And the cards should show content type icons
    And the cards should be responsive to taps

  Scenario: Responsive design
    Given I am viewing the app on different screen sizes
    When I view the app on a small screen
    Then the components should be properly sized
    And the text should be readable
    And the layout should not overflow
    When I view the app on a large screen
    Then the components should utilize the available space
    And the layout should remain well-organized

  Scenario: Theme consistency
    Given I am viewing the app components
    When I look at the overall design
    Then all components should follow the Zapchat theme
    And the colors should be consistent
    And the spacing should be consistent
    And the typography should be consistent
    And the interactions should be consistent

  Scenario: Accessibility
    Given I am using accessibility features
    When I interact with the components
    Then the components should be accessible to screen readers
    And the components should have proper contrast ratios
    And the components should be navigable with keyboard
    And the components should support text scaling 