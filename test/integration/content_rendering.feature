Feature: Content Rendering
  As a user
  I want content to be properly formatted and displayed
  So that I can read publications comfortably

  Background:
    Given I am viewing a publication
    And the publication has content to render

  Scenario: NostrMarkup rendering for articles
    Given I am viewing an article (kind 30023)
    When I view the content
    Then the content should be rendered as NostrMarkup
    And the content should support basic formatting
    And the content should support advanced formatting
    And the content should follow NostrMarkup guidelines

  Scenario: NostrMarkup rendering for notes
    Given I am viewing a note (kind 30041)
    When I view the content
    Then the content should be rendered as NostrMarkup
    And the content should support user-generated content formatting
    And the content should handle comments and issues
    And the content should support long-form articles

  Scenario: AsciiDoc rendering for wikis
    Given I am viewing a wiki (kind 30818)
    When I view the content
    Then the content should be rendered as AsciiDoc
    And the content should support wiki-specific formatting
    And the content should handle complex document structures
    And the content should support AsciiDoc syntax

  Scenario: AsciiDoc rendering for publications
    Given I am viewing a publication (kind 30041)
    When I view the content
    Then the content should be rendered as AsciiDoc
    And the content should support publication-specific formatting
    And the content should handle structured documents

  Scenario: Basic formatting support
    Given I am viewing content with basic formatting
    When I view the content
    Then bold text should be displayed as bold
    And italic text should be displayed as italic
    And strikethrough text should display with a line through the text
    And bullet points should use '*' for markers
    And bullet points should have a space after the asterisk
    And numbered lists should be properly formatted

  Scenario: Advanced formatting support
    Given I am viewing content with advanced formatting
    When I view the content
    Then headers should be properly sized and styled
    And links should be clickable and properly styled
    And code blocks should be properly formatted
    And inline code should be highlighted
    And blockquotes should be properly indented
    And tables should be properly aligned

  Scenario: Image rendering
    Given I am viewing content with images
    When I view the images
    Then the images should be properly sized
    And the images should be cached for offline viewing
    And the images should show loading placeholders
    And the images should show error icons if loading fails
    And the images should be responsive to screen size

  Scenario: Link handling
    Given I am viewing content with links
    When I view the links
    Then the links should be properly styled
    And the links should be clickable
    And the links should open in appropriate viewers
    And external links should be handled properly
    And internal links should navigate correctly

  Scenario: Code block rendering
    Given I am viewing content with code blocks
    When I view the code blocks
    Then the code should be properly formatted
    And the code should have syntax highlighting
    And the code should be properly indented
    And the code should be scrollable if long
    And the code should have appropriate background colors

  Scenario: Table rendering
    Given I am viewing content with tables
    When I view the tables
    Then the tables should be properly aligned
    And the table headers should be distinguished
    And the table cells should be properly spaced
    And the tables should be responsive to screen size
    And the tables should be scrollable if wide

  Scenario: GitHub style icons
    Given I am viewing content with icons
    When I view the icons
    Then the icons should follow GitHub style
    And the icons should be minimalistic and elegant
    And the icons should be easily recognizable
    And the icons should not be colorful or distracting

  Scenario: Content section parsing
    Given I am viewing content with multiple sections
    When I view the content
    Then each section should be properly separated
    And section headers should be clearly displayed
    And section content should be properly formatted
    And the content should be lazy loaded for performance

  Scenario: Content type specific rendering
    Given I am viewing different content types
    When I view articles (kind 30023)
    Then the content should use NostrMarkup with basic and advanced parsers
    When I view notes (kind 30041)
    Then the content should use NostrMarkup for user-generated content
    When I view wikis (kind 30818)
    Then the content should use AsciiDoc for wiki formatting
    When I view publications (kind 30041)
    Then the content should use AsciiDoc for publication formatting

  Scenario: Content error handling
    Given I am viewing content with formatting errors
    When I view the content
    Then the content should be rendered gracefully
    And formatting errors should not break the display
    And the content should still be readable
    And error messages should be displayed appropriately

  Scenario: Content performance
    Given I am viewing a long publication
    When I scroll through the content
    Then the content should render smoothly
    And the scrolling should not be choppy
    And the content should load progressively
    And the performance should remain good

  Scenario: Content accessibility
    Given I am viewing content
    When I use accessibility features
    Then the content should be accessible to screen readers
    And the content should have proper contrast ratios
    And the content should be navigable with keyboard
    And the content should support text scaling

  Scenario: Content responsive design
    Given I am viewing content on different screen sizes
    When I view the content on a small screen
    Then the content should be properly sized
    And the content should be readable
    And the content should not overflow
    When I view the content on a large screen
    Then the content should utilize the available space
    And the content should remain well-formatted

  Scenario: Content caching
    Given I am viewing content
    When I view the content
    Then the content should be cached locally
    And the content should be available offline
    And the content should load quickly from cache
    And the cache should be managed efficiently

  Scenario: Content search within rendered content
    Given I am viewing rendered content
    When I search within the content
    Then the search should work on the rendered text
    And the search should highlight matches
    And the search should be case-insensitive
    And the search should support partial matches

  Scenario: Content export and sharing
    Given I am viewing rendered content
    When I want to share the content
    Then the content should be shareable
    And the shared content should maintain formatting
    And the shared content should be readable
    And the sharing should work across different platforms 