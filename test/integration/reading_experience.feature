Feature: Reading Experience
  As a user
  I want to read publications in a focused environment
  So that I can have an optimal reading experience

  Background:
    Given I am viewing a publication in the reader screen
    And the publication is properly loaded and displayed
    And I have access to reader functionality

  Scenario: Reader screen layout
    Given I am in the reader screen
    When I view the reader interface
    Then I should see a clean, distraction-free reading environment
    And I should see the publication content prominently displayed
    And I should see navigation controls for reading progress
    And I should see options to adjust reading settings
    And I should see interaction buttons for the publication

  Scenario: Publication content display
    Given I am reading a publication
    When I view the publication content
    Then I should see the publication title prominently displayed
    And I should see the publication content properly formatted
    And I should see the publication metadata (author, date, etc.)
    And I should see the publication images if available
    And I should see proper typography and spacing

  Scenario: Reading progress tracking
    Given I am reading a publication
    When I scroll through the content
    Then I should see a reading progress indicator
    And the progress should update as I scroll
    And I should be able to see my reading position
    And I should be able to jump to specific sections
    And the progress should be saved for later sessions

  Scenario: Reading settings adjustment
    Given I am in the reader screen
    When I access reading settings
    Then I should be able to adjust font size
    And I should be able to change font family
    And I should be able to adjust line spacing
    And I should be able to change text color
    And I should be able to adjust background color
    And I should be able to toggle dark/light mode

  Scenario: Table of contents navigation
    Given I am reading a publication with sections
    When I access the table of contents
    Then I should see a list of all sections
    And I should be able to click on any section to jump to it
    And I should see my current reading position highlighted
    And I should be able to expand/collapse sections

  Scenario: Publication index display (kind 30040)
    Given I am reading a publication that has a kind 30040 index
    When I view the publication index
    Then I should see the table of contents for the publication
    And I should see all indexed content items listed
    And I should see the relationship between the index and content
    And I should be able to navigate to specific indexed content
    And I should see my reading progress for indexed items

  Scenario: Indexed content navigation
    Given I am viewing a publication with indexed content
    When I navigate through indexed content
    Then I should be able to jump to specific indexed items
    And I should see my progress through the indexed content
    And I should be able to return to the main publication
    And I should see the relationship between index and content items

  Scenario: Publication search within reader
    Given I am reading a publication
    When I want to search within the publication
    Then I should be able to search for specific text
    And I should see search results highlighted
    And I should be able to navigate between search results
    And I should be able to see the number of search results
    And I should be able to clear the search

  Scenario: Publication sharing
    Given I am reading a publication
    When I want to share the publication
    Then I should be able to share the publication naddr
    And I should be able to share it as a "nostr:naddr..." address
    And I should be able to share it as a "nostr:nevent..." address
    And I should be able to share it as an Alexandria web page link like "https://alexandria.gitcitadel.eu/publication?id=naddr1qvzqqqr4tqpzphzv6zrv6l89kxpj4h60m5fpz2ycsrfv0c54hjcwdpxqrt8wwlqxqydhwumn8ghj7argv43kjarpv3jkctnwdaehgu339e3k7mgprfmhxue69uhhg6r9vehhyetnwshxummnw3erztnrdaksq4tp94kk2arp94skuctv09ekjueddahz6argv5kkzumnda3kjct5d9hkuttzv468wet9dckhqetsw35kxtt4d33k2u3dv35hxetpwdjj6ctwvskkxmmkd9jz6vfe94ek2an9wf5hg7gd7dx5s"

  Scenario: Content formatting support
    Given I am reading a publication
    When I view the content
    Then I should see proper AsciiDoc rendering for publications and wikis
    And I should see proper NostrMarkup rendering for other content
    And I should see nostr addresses properly rendered with display names
    And I should see emoji shortcodes properly displayed
    And I should see wikilinks properly formatted
    And I should see footnotes properly displayed

  Scenario: Reading mode preferences
    Given I am in the reader screen
    When I access reading mode settings
    Then I should be able to enable distraction-free mode
    And I should be able to adjust reading speed
    And I should be able to enable auto-scroll
    And I should be able to configure reading breaks
    And I should be able to set reading reminders

  Scenario: Bookmark functionality
    Given I am reading a publication
    When I want to bookmark my position
    Then I should be able to create bookmarks
    And I should be able to view my bookmarks
    And I should be able to jump to bookmarked positions
    And I should be able to organize bookmarks
    And I should be able to sync bookmarks across devices

  Scenario: Reading statistics
    Given I am reading publications
    When I view reading statistics
    Then I should see my reading time statistics
    And I should see my reading progress across publications
    And I should see my reading speed metrics
    And I should be able to export reading statistics

  Scenario: Offline reading
    Given I am reading a cached publication
    When I am offline
    Then I should be able to continue reading
    And I should see offline indicators
    And I should be able to access cached content
    And I should be able to queue actions for when online

  Scenario: Reading accessibility
    Given I am using accessibility features
    When I read publications
    Then I should be able to use screen readers
    And I should be able to adjust text contrast
    And I should be able to use voice commands
    And I should be able to navigate with keyboard shortcuts