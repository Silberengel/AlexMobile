Feature: Index Reader Screen
  As a user
  I want to browse books and their chapters
  So that I can navigate through structured content

  Background:
    Given I have selected a book publication (kind 30040)
    And I am on the index reader screen

  Scenario: Index reader screen layout
    Then I should see the app bar with the book title
    And the app bar should display a "Book" badge
    And the app bar should show the book icon
    And I should see the book header section
    And I should see the chapters list section
    And the content should be scrollable

  Scenario: Book header display
    Given I am viewing a book
    When I look at the book header
    Then I should see the book title prominently displayed
    And I should see the author information
    And I should see the publication date
    And I should see the book summary if available
    And I should see the cover image if available
    And I should see book tags if available

  Scenario: Book metadata display
    Given I am viewing a book
    When I look at the book metadata
    Then I should see the book type (index, course, collection)
    And I should see the number of chapters
    And I should see the book creation timestamp
    And I should see the author's public key

  Scenario: Chapters list display
    Given I am viewing a book with chapters
    When I look at the chapters list
    Then I should see a "Chapters" section header
    And I should see chapter cards for each chapter
    And each chapter card should show the chapter number
    And each chapter card should show the chapter title
    And each chapter card should show the chapter summary if available
    And each chapter card should show the content type icon

  Scenario: Chapter card interaction
    Given I see a chapter card
    When I tap on a chapter card
    Then I should be navigated to the reader screen
    And the selected chapter should be loaded
    And the chapter content should be displayed

  Scenario: Chapter content type indicators
    Given I am viewing a book with different chapter types
    When I look at the chapter cards
    Then note chapters (kind 30041) should show a note icon
    And wiki chapters (kind 30818) should show an article icon
    And the note icon should be purple
    And the wiki icon should be green
    And the icons should have appropriate background colors

  Scenario: Standalone chapter viewing
    Given I am viewing a chapter card
    When I tap the standalone view button on a chapter card
    Then I should be navigated to the reader screen
    And the chapter should be opened in standalone mode
    And the chapter content should be displayed

  Scenario: Chapter navigation
    Given I am viewing a book with multiple chapters
    When I tap on different chapter cards
    Then I should be able to navigate between chapters
    And each chapter should load correctly
    And the chapter content should be properly formatted

  Scenario: Empty chapters state
    Given I am viewing a book with no chapters
    When I look at the chapters section
    Then I should see an empty state message
    And the empty state should display "No chapters found"
    And the empty state should show a library books icon
    And the empty state should explain that the book has no chapters

  Scenario: Chapter loading states
    Given I am viewing a book with chapters
    When the chapters are loading
    Then I should see a loading indicator
    And the loading indicator should be centered
    When the chapters have loaded
    Then the chapters list should be displayed
    And the loading indicator should disappear

  Scenario: Chapter error handling
    Given there was an error loading chapters
    When I view the index reader screen
    Then the book header should still be displayed
    And the chapters section should show an error state
    And the error should be handled gracefully

  Scenario: Book without chapter IDs
    Given I am viewing a book without chapter IDs
    When I view the index reader screen
    Then the book header should be displayed
    And the chapters section should show the empty state
    And the empty state should indicate no chapters are available

  Scenario: Chapter content type rendering
    Given I am viewing a book with note chapters
    When I open a note chapter
    Then the content should be rendered as NostrMarkup
    And the content should support user-generated content formatting

  Scenario: Wiki chapter rendering
    Given I am viewing a book with wiki chapters
    When I open a wiki chapter
    Then the content should be rendered as AsciiDoc
    And the content should support wiki-specific formatting

  Scenario: Chapter numbering
    Given I am viewing a book with multiple chapters
    When I look at the chapter cards
    Then each chapter should have a sequential number
    And the chapter numbers should start from 1
    And the chapter numbers should be displayed in purple circles
    And the chapter numbers should be white text

  Scenario: Chapter card styling
    Given I am viewing chapter cards
    When I look at the chapter card design
    Then the cards should have rounded corners
    And the cards should have subtle shadows
    And the cards should have proper spacing
    And the cards should be responsive to taps
    And the cards should follow the Zapchat design system

  Scenario: Back navigation
    Given I am on the index reader screen
    When I tap the back button
    Then I should return to the home screen
    And the book selection should be cleared

  Scenario: Book cover image handling
    Given I am viewing a book with a cover image
    When I look at the cover image
    Then the image should be properly sized
    And the image should have rounded corners
    And the image should show an error icon if loading fails
    And the image should be responsive to different screen sizes

  Scenario: Book tags display
    Given I am viewing a book with tags
    When I look at the book tags
    Then the tags should be displayed as chips
    And the chips should have appropriate colors
    And the chips should be properly spaced
    And the chips should follow the theme design

  Scenario: Responsive layout
    Given I am on the index reader screen
    When I rotate the device
    Then the layout should adapt to the new orientation
    And the book header should remain readable
    And the chapters list should adjust properly
    And the content should remain accessible 