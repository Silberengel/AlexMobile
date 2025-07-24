Feature: Reader Screen
  As a user
  I want to read publications in a dedicated reader interface
  So that I can have a focused, distraction-free reading experience

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
    And I should see a way to return to the main screen

  Scenario: Publication content display
    Given I am reading a publication
    When I view the publication content
    Then I should see the publication title prominently displayed
    And I should see the publication content properly formatted
    And I should see the publication metadata (author, date, etc.)
    And I should see the publication images if available
    And I should see proper typography and spacing
    And I should see the content rendered according to its type

  Scenario: Reading progress tracking
    Given I am reading a publication
    When I scroll through the content
    Then I should see a reading progress indicator
    And the progress should update as I scroll
    And I should be able to see my reading position
    And I should be able to jump to specific sections
    And I should be able to bookmark my reading position
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
    And I should be able to adjust margins

  Scenario: Table of contents navigation
    Given I am reading a publication with sections
    When I access the table of contents
    Then I should see a list of all sections
    And I should be able to click on any section to jump to it
    And I should see my current reading position highlighted
    And I should be able to expand/collapse sections
    And I should be able to search within the table of contents
    And the table of contents should be easily accessible

  Scenario: Publication interaction
    Given I am reading a publication
    When I want to interact with the publication
    Then I should be able to bookmark the publication
    And I should be able to share the publication
    And I should be able to react to the publication (NIP-25)
    And I should be able to comment on the publication (NIP-22)
    And I should be able to highlight parts of the publication (NIP-84)
    And I should be able to zap the publication (NIP-57)

  Scenario: Publication navigation
    Given I am reading a publication
    When I want to navigate
    Then I should be able to go to the next publication
    And I should be able to go to the previous publication
    And I should be able to return to the publication list
    And I should be able to see related publications
    And I should be able to jump to specific pages or sections
    And I should be able to use keyboard shortcuts for navigation

  Scenario: Publication search
    Given I am reading a publication
    When I want to search within the publication
    Then I should be able to search for specific text
    And I should see search results highlighted
    And I should be able to navigate between search results
    And I should be able to see the number of search results
    And I should be able to clear the search
    And the search should be case-sensitive or case-insensitive

  Scenario: Publication sharing
    Given I am reading a publication
    When I want to share the publication
    Then I should be able to share the publication URL
    And I should be able to share the publication content
    And I should be able to share specific sections
    And I should be able to share with notes or comments
    And I should be able to share to different platforms
    And I should be able to copy the publication link

  Scenario: Publication bookmarking
    Given I am reading a publication
    When I want to bookmark the publication
    Then I should be able to add the publication to my bookmarks (NIP-51 kind 10003)
    And I should be able to organize bookmarks into sets (NIP-51 kind 30003)
    And I should be able to add notes to bookmarks
    And I should be able to categorize bookmarks
    And I should be able to access my bookmarks later
    And the bookmark should be properly synced

  Scenario: Publication reactions (NIP-25)
    Given I am reading a publication
    When I want to react to the publication
    Then I should be able to like the publication (+)
    And I should be able to dislike the publication (-)
    And I should be able to add emoji reactions
    And I should be able to see other users' reactions
    And I should be able to see reaction counts
    And I should be able to remove my reactions
    And the reactions should be properly signed and published

  Scenario: Publication comments (NIP-22)
    Given I am reading a publication
    When I want to comment on the publication
    Then I should be able to add comments (kind 1111)
    And I should be able to reply to existing comments
    And I should be able to see the comment thread
    And I should be able to navigate through comments
    And I should be able to moderate comments if I'm the author
    And the comments should be properly threaded

  Scenario: Publication highlights (NIP-84)
    Given I am reading a publication
    When I want to highlight parts of the publication
    Then I should be able to select text to highlight
    And I should be able to add notes to highlights
    And I should be able to see my highlights
    And I should be able to share highlights
    And I should be able to organize highlights
    And the highlights should be properly saved and synced

  Scenario: Publication zaps (NIP-57)
    Given I am reading a publication
    When I want to zap the publication
    Then I should be able to send lightning payments
    And I should be able to choose the zap amount
    And I should be able to add a message to the zap
    And I should be able to see zap receipts
    And I should be able to see total zaps received
    And the zaps should be properly processed and displayed

  Scenario: Publication metadata display
    Given I am reading a publication
    When I view the publication metadata
    Then I should see the publication title
    And I should see the publication author
    And I should see the publication date
    And I should see the publication tags
    And I should see the publication summary
    And I should see the publication image if available
    And I should see interaction statistics

  Scenario: Publication accessibility
    Given I am reading a publication
    When I use accessibility features
    Then I should be able to use screen readers
    And I should be able to navigate with keyboard
    And I should be able to adjust text size
    And I should be able to use high contrast mode
    And I should be able to use voice commands
    And the content should be properly structured for accessibility

  Scenario: Publication offline reading
    Given I am reading a publication
    When I go offline
    Then I should still be able to read the publication
    And I should still be able to access my bookmarks
    And I should still be able to see my highlights
    And I should still be able to adjust reading settings
    And I should still be able to navigate the publication
    And the offline experience should be seamless

  Scenario: Publication synchronization
    Given I am reading a publication
    When the publication updates
    Then I should see the updates in real-time
    And I should see new comments and reactions
    And I should see updated interaction counts
    And I should see new highlights and bookmarks
    And the synchronization should be smooth and reliable
    And I should be notified of significant updates

  # NIP-54 Wiki Reading Scenarios

  Scenario: Wiki article reading (NIP-54 kind 30818)
    Given I am reading a wiki article
    When I view the wiki content
    Then I should see the wiki article title prominently displayed
    And I should see the wiki article content in AsciiDoc format
    And I should see the wiki article metadata (author, date, etc.)
    And I should see the wiki article summary if available
    And I should see the wiki article d-tag identifier
    And I should see the wiki article version information
    And I should see the wiki article collaboration status

  Scenario: Wiki article wikilinks navigation (NIP-54)
    Given I am reading a wiki article with wikilinks
    When I encounter wikilinks in the content
    Then I should see wikilinks properly rendered and clickable
    And I should see [[Target Page]] links display as 'Target Page'
    And I should see [[target page|see this]] links display as 'see this'
    And clicking wikilinks should query relays for matching d-tag events
    And I should be able to navigate to linked wiki articles
    And I should see loading indicators while fetching linked articles
    And I should be able to return to the original article

  Scenario: Wiki article nostr links (NIP-21)
    Given I am reading a wiki article with nostr links
    When I encounter nostr:... links in the content
    Then I should see nostr links properly rendered and clickable
    And I should be able to navigate to linked profiles
    And I should be able to navigate to linked events
    And the links should follow NIP-21 specifications
    And I should see proper link descriptions and context
    And I should be able to return to the wiki article

  Scenario: Wiki article AsciiDoc rendering
    Given I am reading a wiki article
    When I view the AsciiDoc content
    Then I should see tables properly formatted and aligned
    And I should see footnotes properly displayed and linked
    And I should see sidebars properly positioned
    And I should see headers properly styled and hierarchical
    And I should see lists properly formatted and indented
    And I should see code blocks properly highlighted
    And I should see images properly displayed and sized

  Scenario: Wiki article version comparison
    Given I am reading a wiki article with multiple versions
    When I want to compare versions
    Then I should be able to see different versions of the article
    And I should be able to switch between versions
    And I should be able to see version differences highlighted
    And I should be able to see who created each version
    And I should be able to see when each version was created
    And I should be able to choose which version to display
    And I should see version metadata and attribution

  Scenario: Wiki article collaboration features
    Given I am reading a wiki article
    When I want to collaborate on the article
    Then I should be able to fork the article to create my version
    And I should be able to request merges into other articles
    And I should be able to defer to other users' versions
    And I should be able to create redirects to other articles
    And I should be able to react to articles to show trust
    And I should see collaboration history and attribution
    And I should be able to participate in merge requests

  Scenario: Wiki article prioritization display
    Given I am reading a wiki article
    When I view article prioritization information
    Then I should see article trust indicators from NIP-25 reactions
    And I should see article source relays from NIP-51 lists
    And I should see author trust from NIP-02 contact lists
    And I should see curator recommendations from NIP-51 lists
    And I should see why this version was chosen for display
    And I should be able to see alternative versions
    And I should be able to switch to different versions

  Scenario: Wiki article search and discovery
    Given I am reading a wiki article
    When I want to discover related content
    Then I should be able to search for related wiki articles
    And I should be able to browse articles by topic
    And I should be able to discover articles through wikilinks
    And I should be able to find articles through nostr links
    And I should be able to see popular related articles
    And I should be able to see trusted author recommendations
    And I should be able to explore wiki article networks

  Scenario: Wiki article quality indicators
    Given I am reading a wiki article
    When I view article quality information
    Then I should see article reaction counts and types
    And I should see author reputation and trust indicators
    And I should see article version history and stability
    And I should see collaboration patterns and attribution
    And I should see article completeness and accuracy indicators
    And I should see community feedback and recommendations
    And I should see article moderation status

  Scenario: Wiki article export and sharing
    Given I am reading a wiki article
    When I want to share the article
    Then I should be able to export the article content
    And I should be able to share the article link
    And I should be able to share specific sections
    And I should be able to share with notes or comments
    And I should be able to recommend the article to others
    And I should be able to discuss the article with other users
    And I should be able to create article-related content

  Scenario: Wiki article synchronization
    Given I am reading a wiki article
    When wiki data updates
    Then I should see article updates in real-time
    And I should see new article versions appear
    And I should see updated reactions and comments
    And I should see new wikilinks and nostr links
    And I should see collaboration updates and merge requests
    And the synchronization should be efficient and reliable
    And I should be notified of significant article changes

  Scenario: Wiki article error handling
    Given I am reading a wiki article
    When I encounter errors or missing data
    Then I should see appropriate error messages
    And I should see fallback content when available
    And I should see retry options for failed operations
    And I should see alternative article versions
    And I should be able to report problematic articles
    And the error handling should not break the reading experience
    And I should be able to continue reading despite errors

  Scenario: Wiki article performance optimization
    Given I am reading a wiki article
    When I interact with the article
    Then article content should load efficiently
    And wikilinks should be resolved quickly
    And nostr links should be processed efficiently
    And article rendering should be smooth
    And article navigation should be responsive
    And article synchronization should be optimized
    And the performance should not impact reading experience

  Scenario: Wiki article accessibility features
    Given I am reading a wiki article
    When I use accessibility features
    Then wikilinks should be properly announced by screen readers
    And nostr links should be accessible with keyboard navigation
    And AsciiDoc content should be properly structured for accessibility
    And article navigation should be keyboard accessible
    And article content should have proper contrast ratios
    And article images should have proper alt text
    And the accessibility should meet standard guidelines

  # NIP-23 Long-form Content Reading Scenarios

  Scenario: Long-form article reading (NIP-23 kind 30023)
    Given I am reading a long-form article
    When I view the article content
    Then I should see the article title prominently displayed
    And I should see the article content in Markdown format
    And I should see the article metadata (author, date, etc.)
    And I should see the article summary if available
    And I should see the article image if available
    And I should see the article d-tag identifier
    And I should see the article published_at timestamp
    And I should see the article tags and topics

  Scenario: Long-form article Markdown rendering (NIP-23)
    Given I am reading a long-form article
    When I view the Markdown content
    Then I should see paragraphs properly formatted without hard line breaks
    And I should see headers properly styled and hierarchical
    And I should see lists properly formatted and indented
    And I should see code blocks properly highlighted
    And I should see images properly displayed and sized
    And I should see links properly rendered and clickable
    And I should see emphasis and strong text properly styled
    And I should see blockquotes properly formatted

  Scenario: Long-form article nostr links (NIP-21)
    Given I am reading a long-form article with nostr links
    When I encounter nostr:... links in the content
    Then I should see nostr links properly rendered and clickable
    And I should be able to navigate to linked profiles
    And I should be able to navigate to linked events
    And I should be able to navigate to linked articles
    And the links should follow NIP-21 specifications
    And I should see proper link descriptions and context
    And I should be able to return to the original article

  Scenario: Long-form article references (NIP-27)
    Given I am reading a long-form article with references
    When I encounter references to other Nostr content
    Then I should see references properly tagged in the event
    And I should see references properly linked in the content
    And I should be able to navigate to referenced content
    And I should see reference context and descriptions
    And the references should follow NIP-27 specifications
    And I should be able to return to the original article

  Scenario: Long-form article metadata display
    Given I am reading a long-form article
    When I view the article metadata
    Then I should see the article title from the 'title' tag
    And I should see the article image from the 'image' tag
    And I should see the article summary from the 'summary' tag
    And I should see the published_at timestamp
    And I should see the article tags from 't' tags
    And I should see the article d-tag identifier
    And I should see the article creation timestamp
    And I should see the article author information

  Scenario: Long-form article version management
    Given I am reading a long-form article
    When I want to manage article versions
    Then I should see the current version of the article
    And I should be able to see article edit history
    And I should be able to see when the article was last updated
    And I should be able to see the original published date
    And I should be able to see article changes over time
    And I should be able to compare different versions
    And I should see version metadata and attribution

  Scenario: Long-form article comments (NIP-22)
    Given I am reading a long-form article
    When I want to comment on the article
    Then I should be able to add comments using kind 1111 (NIP-22)
    And I should be able to reply to existing comments
    And I should be able to see the comment thread
    And I should be able to navigate through comments
    And I should be able to moderate comments if I'm the author
    And the comments should be properly threaded
    And the comments should follow NIP-22 specifications

  Scenario: Long-form article reactions (NIP-25)
    Given I am reading a long-form article
    When I want to react to the article
    Then I should be able to like the article (+)
    And I should be able to dislike the article (-)
    And I should be able to add emoji reactions
    And I should be able to see other users' reactions
    And I should be able to see reaction counts
    And I should be able to remove my reactions
    And the reactions should be properly signed and published

  Scenario: Long-form article bookmarking (NIP-51)
    Given I am reading a long-form article
    When I want to bookmark the article
    Then I should be able to add the article to my bookmarks (kind 10003)
    And I should be able to organize bookmarks into sets (kind 30003)
    And I should be able to add notes to bookmarks
    And I should be able to categorize bookmarks
    And I should be able to access my bookmarks later
    And the bookmark should be properly synced
    And the bookmark should include article metadata

  Scenario: Long-form article highlighting (NIP-84)
    Given I am reading a long-form article
    When I want to highlight parts of the article
    Then I should be able to select text to highlight
    And I should be able to add notes to highlights
    And I should be able to see my highlights
    And I should be able to share highlights
    And I should be able to organize highlights
    And the highlights should be properly saved and synced
    And the highlights should include article context

  Scenario: Long-form article zaps (NIP-57)
    Given I am reading a long-form article
    When I want to zap the article
    Then I should be able to send lightning payments
    And I should be able to choose the zap amount
    And I should be able to add a message to the zap
    And I should be able to see zap receipts
    And I should be able to see total zaps received
    And the zaps should be properly processed and displayed
    And the zaps should support the article author

  Scenario: Long-form article sharing
    Given I am reading a long-form article
    When I want to share the article
    Then I should be able to share the article using naddr (NIP-19)
    And I should be able to share the article URL
    And I should be able to share the article content
    And I should be able to share specific sections
    And I should be able to share with notes or comments
    And I should be able to share to different platforms
    And I should be able to copy the article link

  Scenario: Long-form article search and discovery
    Given I am reading a long-form article
    When I want to discover related content
    Then I should be able to search for related articles
    And I should be able to browse articles by topic
    And I should be able to discover articles through tags
    And I should be able to find articles through nostr links
    And I should be able to see popular related articles
    And I should be able to see trusted author recommendations
    And I should be able to explore article networks

  Scenario: Long-form article quality indicators
    Given I am reading a long-form article
    When I view article quality information
    Then I should see article reaction counts and types
    And I should see author reputation and trust indicators
    And I should see article version history and stability
    And I should see article completeness and accuracy indicators
    And I should see community feedback and recommendations
    And I should see article moderation status
    And I should see article engagement metrics

  Scenario: Long-form article export and sharing
    Given I am reading a long-form article
    When I want to share the article
    Then I should be able to export the article content
    And I should be able to share the article link
    And I should be able to share specific sections
    And I should be able to share with notes or comments
    And I should be able to recommend the article to others
    And I should be able to discuss the article with other users
    And I should be able to create article-related content

  Scenario: Long-form article synchronization
    Given I am reading a long-form article
    When article data updates
    Then I should see article updates in real-time
    And I should see new article versions appear
    And I should see updated reactions and comments
    And I should see new nostr links and references
    And I should see collaboration updates
    And the synchronization should be efficient and reliable
    And I should be notified of significant article changes

  Scenario: Long-form article error handling
    Given I am reading a long-form article
    When I encounter errors or missing data
    Then I should see appropriate error messages
    And I should see fallback content when available
    And I should see retry options for failed operations
    And I should see alternative article versions
    And I should be able to report problematic articles
    And the error handling should not break the reading experience
    And I should be able to continue reading despite errors

  Scenario: Long-form article performance optimization
    Given I am reading a long-form article
    When I interact with the article
    Then article content should load efficiently
    And nostr links should be resolved quickly
    And references should be processed efficiently
    And article rendering should be smooth
    And article navigation should be responsive
    And article synchronization should be optimized
    And the performance should not impact reading experience

  Scenario: Long-form article accessibility features
    Given I am reading a long-form article
    When I use accessibility features
    Then nostr links should be properly announced by screen readers
    And references should be accessible with keyboard navigation
    And Markdown content should be properly structured for accessibility
    And article navigation should be keyboard accessible
    And article content should have proper contrast ratios
    And article images should have proper alt text
    And the accessibility should meet standard guidelines

  # NKBIP-01 Curated Publications Reading Scenarios

  Scenario: Publication index reading (NKBIP-01 kind 30040)
    Given I am reading a curated publication
    When I view the publication index
    Then I should see the publication title prominently displayed
    And I should see the publication metadata (author, version, etc.)
    And I should see the publication summary if available
    And I should see the publication image if available
    And I should see the publication type (book, magazine, etc.)
    And I should see the publication source URL if available
    And I should see the publication auto-update setting
    And I should see the publication sections in display order

  Scenario: Publication content reading (NKBIP-01 kind 30041)
    Given I am reading a publication section
    When I view the section content
    Then I should see the section title prominently displayed
    And I should see the section content in AsciiDoc format
    And I should see wikilinks properly rendered and clickable
    And I should see the section d-tag identifier
    And I should see the section metadata
    And I should be able to navigate between sections
    And I should be able to return to the publication index

  Scenario: Publication navigation and structure
    Given I am reading a curated publication
    When I navigate through the publication
    Then I should be able to see the table of contents
    And I should be able to jump to any section
    And I should be able to navigate sequentially through sections
    And I should be able to see my reading progress
    And I should be able to bookmark my current position
    And I should be able to see section hierarchy if nested
    And I should be able to return to the publication index

  Scenario: Publication wikilinks navigation (NKBIP-01)
    Given I am reading a publication section with wikilinks
    When I encounter wikilinks in the content
    Then I should see wikilinks properly rendered and clickable
    And I should be able to navigate to linked sections
    And I should be able to navigate to linked publications
    And I should be able to navigate to linked wiki articles
    And I should be able to navigate to linked long-form articles
    And I should see proper link descriptions and context
    And I should be able to return to the original section

  Scenario: Publication metadata display
    Given I am reading a curated publication
    When I view the publication metadata
    Then I should see the publication title from the 'title' tag
    And I should see the publication author from the 'author' tag
    And I should see the publication version from the 'version' tag
    And I should see the publication type from the 'type' tag
    And I should see the publication source URL from the 'source' tag
    And I should see the publication image from the 'image' tag
    And I should see the publication summary from the 'summary' tag
    And I should see the publication tags from 't' tags

  Scenario: Publication auto-update behavior
    Given I am reading a curated publication
    When the publication has auto-update settings
    Then I should see the auto-update setting (yes/ask/no)
    And I should be notified of publication updates if set to 'ask'
    And I should automatically update if set to 'yes'
    And I should not update if set to 'no'
    And I should see version history and changes
    And I should be able to choose which version to read
    And I should see update notifications and summaries

  Scenario: Publication derivative works
    Given I am reading a derivative publication
    When I view the publication information
    Then I should see the original author from the 'p' tag
    And I should see the original event reference from the 'E' tag
    And I should see proper attribution to the original work
    And I should be able to access the original publication
    And I should see the relationship between original and derivative
    And I should see modification history and changes
    And I should see proper licensing and permissions

  Scenario: Publication section rendering (NKBIP-01)
    Given I am reading a publication section
    When I view the AsciiDoc content
    Then I should see headers properly styled and hierarchical
    And I should see lists properly formatted and indented
    And I should see code blocks properly highlighted
    And I should see images properly displayed and sized
    And I should see wikilinks properly rendered and clickable
    And I should see emphasis and strong text properly styled
    And I should see blockquotes properly formatted

  Scenario: Publication comments (NIP-22)
    Given I am reading a publication section
    When I want to comment on the section
    Then I should be able to add comments using kind 1111 (NIP-22)
    And I should be able to reply to existing comments
    And I should be able to see the comment thread
    And I should be able to navigate through comments
    And I should be able to moderate comments if I'm the author
    And the comments should be properly threaded
    And the comments should follow NIP-22 specifications

  Scenario: Publication reactions (NIP-25)
    Given I am reading a publication section
    When I want to react to the section
    Then I should be able to like the section (+)
    And I should be able to dislike the section (-)
    And I should be able to add emoji reactions
    And I should be able to see other users' reactions
    And I should be able to see reaction counts
    And I should be able to remove my reactions
    And the reactions should be properly signed and published

  Scenario: Publication bookmarking (NIP-51)
    Given I am reading a publication section
    When I want to bookmark the section
    Then I should be able to add the section to my bookmarks (kind 10003)
    And I should be able to organize bookmarks into sets (kind 30003)
    And I should be able to add notes to bookmarks
    And I should be able to categorize bookmarks
    And I should be able to access my bookmarks later
    And the bookmark should be properly synced
    And the bookmark should include section metadata

  Scenario: Publication highlighting (NIP-84)
    Given I am reading a publication section
    When I want to highlight parts of the section
    Then I should be able to select text to highlight
    And I should be able to add notes to highlights
    And I should be able to see my highlights
    And I should be able to share highlights
    And I should be able to organize highlights
    And the highlights should be properly saved and synced
    And the highlights should include section context

  Scenario: Publication zaps (NIP-57)
    Given I am reading a publication section
    When I want to zap the section
    Then I should be able to send lightning payments
    And I should be able to choose the zap amount
    And I should be able to add a message to the zap
    And I should be able to see zap receipts
    And I should be able to see total zaps received
    And the zaps should be properly processed and displayed
    And the zaps should support the section author

  Scenario: Publication sharing
    Given I am reading a publication section
    When I want to share the section
    Then I should be able to share the section using naddr (NIP-19)
    And I should be able to share the publication URL
    And I should be able to share the section content
    And I should be able to share specific sections
    And I should be able to share with notes or comments
    And I should be able to share to different platforms
    And I should be able to copy the section link

  Scenario: Publication search and discovery
    Given I am reading a publication section
    When I want to discover related content
    Then I should be able to search for related publications
    And I should be able to browse publications by topic
    And I should be able to discover publications through tags
    And I should be able to find publications through wikilinks
    And I should be able to see popular related publications
    And I should be able to see trusted author recommendations
    And I should be able to explore publication networks

  Scenario: Publication quality indicators
    Given I am reading a publication section
    When I view publication quality information
    Then I should see section reaction counts and types
    And I should see author reputation and trust indicators
    And I should see publication version history and stability
    And I should see publication completeness and accuracy indicators
    And I should see community feedback and recommendations
    And I should see publication moderation status
    And I should see publication engagement metrics

  Scenario: Publication export and sharing
    Given I am reading a publication section
    When I want to share the publication
    Then I should be able to export the publication content
    And I should be able to share the publication link
    And I should be able to share specific sections
    And I should be able to share with notes or comments
    And I should be able to recommend the publication to others
    And I should be able to discuss the publication with other users
    And I should be able to create publication-related content

  Scenario: Publication synchronization
    Given I am reading a publication section
    When publication data updates
    Then I should see publication updates in real-time
    And I should see new publication versions appear
    And I should see updated reactions and comments
    And I should see new wikilinks and references
    And I should see collaboration updates
    And the synchronization should be efficient and reliable
    And I should be notified of significant publication changes

  Scenario: Publication error handling
    Given I am reading a publication section
    When I encounter errors or missing data
    Then I should see appropriate error messages
    And I should see fallback content when available
    And I should see retry options for failed operations
    And I should see alternative publication versions
    And I should be able to report problematic publications
    And the error handling should not break the reading experience
    And I should be able to continue reading despite errors

  Scenario: Publication performance optimization
    Given I am reading a publication section
    When I interact with the publication
    Then publication content should load efficiently
    And wikilinks should be resolved quickly
    And references should be processed efficiently
    And publication rendering should be smooth
    And publication navigation should be responsive
    And publication synchronization should be optimized
    And the performance should not impact reading experience

  Scenario: Publication accessibility features
    Given I am reading a publication section
    When I use accessibility features
    Then wikilinks should be properly announced by screen readers
    And references should be accessible with keyboard navigation
    And AsciiDoc content should be properly structured for accessibility
    And publication navigation should be keyboard accessible
    And publication content should have proper contrast ratios
    And publication images should have proper alt text
    And the accessibility should meet standard guidelines 