Feature: Interactions
  As a user
  I want to interact with publications through reactions, comments, and highlights
  So that I can engage with content and other users

  Background:
    Given I am viewing a publication in the reader screen
    And the publication has interaction capabilities

  Scenario: Metadata card display
    Given I am viewing a publication
    When I look at the metadata card at the top
    Then I should see the publication title prominently displayed
    And I should see the author information
    And I should see the publication summary if available
    And I should see the publication tags if available
    And I should see the rendered cover image if available
    And if the publication is part of a book (kind 30040)
    Then I should see the book title displayed
    And I should see the relationship to the parent book

  Scenario: Interaction counters display
    Given I am viewing a publication with interactions
    When I look at the bottom of the metadata card
    Then I should see two icons with counters
    And the first icon should show the combined count of comments (kind 1111) and highlights (kind 9802)
    And the second icon should be a heart icon showing the total reaction count
    And both icons should use outline-style or similarly unobtrusive design
    And the counters should be clearly visible and readable

  Scenario: View interactions button
    Given I am viewing a publication with interactions
    When I look at the bottom of the metadata card
    Then I should see a "View Interactions" button
    And the button should be clearly labeled and accessible
    When I tap the "View Interactions" button
    Then I should see a detailed interactions display
    And the display should show all reactions with counts
    And the display should show all comments in a thread
    And the display should show all highlights with their replies

  Scenario: Reactions display
    Given I am viewing the interactions display
    When I look at the reactions section
    Then I should see all different reaction types
    And each reaction should show its count
    And duplicate reactions should be grouped together
    And the reactions should be displayed clearly
    And I should see an "Add Reaction" button

  Scenario: Adding reactions
    Given I am viewing the reactions section
    When I tap the "Add Reaction" button
    Then I should see a reaction picker interface
    And the picker should show available reaction options
    And I should be able to select a reaction
    When I select a reaction
    Then the reaction should be added to the publication
    And the reaction count should update immediately
    And the reaction should be signed and published
    And the reaction should appear in the reactions list

  Scenario: Comments thread display
    Given I am viewing the interactions display
    When I look at the comments section
    Then I should see all kind 1111 comments listed
    And the comments should be displayed in a thread format
    And each comment should show the author and timestamp
    And the comments should be properly threaded
    And I should see an "Add Comment" button

  Scenario: Adding comments
    Given I am viewing the comments section
    When I tap the "Add Comment" button
    Then I should see a comment input interface
    And the interface should allow me to write my comment
    And the interface should show character limits if applicable
    When I submit my comment
    Then the comment should be added to the thread
    And the comment should be signed and published
    And the comment count should update immediately
    And my comment should appear in the comments list

  Scenario: Highlight display
    Given I am viewing the interactions display
    When I look at the highlights section
    Then I should see all kind 9802 highlight events
    And each highlight should show the highlighted text
    And each highlight should show the author and timestamp
    And any kind 1111 replies to highlights should be threaded below
    And I should see an "Add Highlight" button

  Scenario: Text selection for highlighting
    Given I am reading a publication
    When I select text in the publication
    Then a pen or pencil icon should appear next to the selection
    And the icon should be clearly visible and accessible
    When I tap the pen/pencil icon
    Then I should see a highlight creation interface
    And the interface should show the selected text
    And I should be able to add my own content/notes to the highlight

  Scenario: Creating highlights
    Given I have selected text and tapped the highlight icon
    When I add content to my highlight
    Then I should be able to write additional notes
    And the interface should show the selected text clearly
    And I should be able to modify the highlight before publishing
    When I submit the highlight
    Then the highlight should be created as a kind 9802 event
    And the highlight should be signed and published
    And the highlight should appear in the highlights list
    And the highlight count should update immediately

  Scenario: Interaction counts update
    Given I am viewing a publication with interactions
    When new interactions are added
    Then the counters should update in real-time
    And the metadata card should reflect the new counts
    And the interactions display should show the new items
    And the updates should be immediate and smooth

  Scenario: Interaction threading
    Given I am viewing comments or highlights
    When there are replies to comments or highlights
    Then the replies should be properly threaded
    And the threading should be visually clear
    And the hierarchy should be easy to follow
    And I should be able to expand/collapse threads

  Scenario: Interaction permissions
    Given I am viewing interactions
    When I try to add reactions, comments, or highlights
    Then the app should check my authentication status
    And if I am not authenticated, I should be prompted to log in
    And if I am authenticated, I should be able to interact freely
    And my interactions should be properly signed with my key

  Scenario: Interaction error handling
    Given I am trying to add an interaction
    When the interaction fails to publish
    Then the app should handle the error gracefully
    And I should see an appropriate error message
    And the app should provide retry options
    And the app should not lose my interaction data
    And the app should attempt to publish again when possible

  Scenario: Interaction synchronization
    Given I am viewing interactions
    When new interactions are published by others
    Then the interactions should be synchronized in real-time
    And the counts should update automatically
    And new interactions should appear in the lists
    And the synchronization should be smooth and reliable

  Scenario: Interaction search and filtering
    Given I am viewing many interactions
    When I want to find specific interactions
    Then I should be able to search through interactions
    And I should be able to filter by interaction type
    And I should be able to filter by author
    And the search and filtering should be fast and responsive

  Scenario: Interaction moderation
    Given I am viewing interactions
    When I see inappropriate interactions
    Then I should be able to report problematic interactions
    And the app should provide moderation tools
    And the app should handle moderation appropriately
    And the app should maintain a safe environment

  Scenario: Interaction privacy
    Given I am adding interactions
    When I create reactions, comments, or highlights
    Then my interactions should be properly signed
    And my interactions should be associated with my identity
    And the app should respect privacy settings
    And the app should handle private interactions appropriately

  Scenario: Interaction history
    Given I have added interactions to publications
    When I view my interaction history
    Then I should see all my past interactions
    And I should be able to view and edit my interactions
    And I should be able to delete my interactions if appropriate
    And the history should be organized and searchable

  Scenario: Interaction notifications
    Given I have interacted with publications
    When others respond to my interactions
    Then I should receive appropriate notifications
    And the notifications should be timely and relevant
    And I should be able to manage notification preferences
    And the notifications should help me stay engaged

  Scenario: Interaction analytics
    Given I am viewing interactions
    When I look at interaction data
    Then I should see meaningful analytics about interactions
    And the analytics should help understand engagement
    And the analytics should be privacy-respecting
    And the analytics should provide useful insights

  # NIP-22 Specific Scenarios

  Scenario: Comment event structure (NIP-22 kind 1111)
    Given I am creating a comment on a publication
    When I create a comment event
    Then the event should be of kind 1111
    And the content should be plaintext without HTML or Markdown
    And the event should be properly signed with my nostr key
    And the event should be published to relays

  Scenario: Comment root scope tags (NIP-22)
    Given I am creating a comment on a publication
    When I create a comment event
    Then the event should have uppercase tags for root scope
    And the event should have 'A' tag for addressable events
    And the event should have 'E' tag for regular events
    And the event should have 'I' tag for external identifiers
    And the event should have 'K' tag for root event kind
    And the event should have 'P' tag for root event author

  Scenario: Comment parent scope tags (NIP-22)
    Given I am creating a comment on a publication
    When I create a comment event
    Then the event should have lowercase tags for parent scope
    And the event should have 'a' tag for addressable parent events
    And the event should have 'e' tag for regular parent events
    And the event should have 'i' tag for external parent identifiers
    And the event should have 'k' tag for parent event kind
    And the event should have 'p' tag for parent event author

  Scenario: Comment on addressable event
    Given I am commenting on an addressable event
    When I create a comment
    Then the comment should include 'A' tag with event coordinates
    And the coordinates should be in format (kind:pubkey:d-tag)
    And the comment should include 'K' tag with the root kind
    And the comment should include 'P' tag with the root author
    And the comment should include 'a' tag with parent coordinates
    And the comment should include 'k' tag with parent kind
    And the comment should include 'p' tag with parent author

  Scenario: Comment on regular event
    Given I am commenting on a regular event
    When I create a comment
    Then the comment should include 'E' tag with event ID
    And the comment should include 'K' tag with the root kind
    And the comment should include 'P' tag with the root author
    And the comment should include 'e' tag with parent event ID
    And the comment should include 'k' tag with parent kind
    And the comment should include 'p' tag with parent author

  Scenario: Comment on external identifier
    Given I am commenting on an external identifier
    When I create a comment
    Then the comment should include 'I' tag with the identifier
    And the comment should include 'K' tag with the identifier type
    And the comment should include 'i' tag with parent identifier
    And the comment should include 'k' tag with parent identifier type

  Scenario: Comment reply to another comment
    Given I am replying to an existing comment
    When I create a reply comment
    Then the comment should include 'E' tag with the root event ID
    And the comment should include 'K' tag with the root event kind
    And the comment should include 'P' tag with the root event author
    And the comment should include 'e' tag with the parent comment ID
    And the comment should include 'k' tag with parent comment kind (1111)
    And the comment should include 'p' tag with parent comment author

  Scenario: Comment relay hints
    Given I am creating a comment
    When I include relay hints in tags
    Then the 'E' tag should include relay hint as the second element
    And the 'e' tag should include relay hint as the second element
    And the 'P' tag should include relay hint as the second element
    And the 'p' tag should include relay hint as the second element
    And the hints should help other clients find the referenced events

  Scenario: Comment pubkey hints
    Given I am creating a comment
    When I include pubkey hints in tags
    Then the 'E' tag should include pubkey as the third element
    And the 'e' tag should include pubkey as the third element
    And the pubkey hints should help validate the referenced events
    And the pubkey hints should be properly formatted

  Scenario: Comment content validation
    Given I am creating a comment
    When I validate the comment content
    Then the content should be plaintext only
    And the content should not contain HTML markup
    And the content should not contain Markdown formatting
    And the content should be properly encoded
    And the content should be user-generated

  Scenario: Comment event signing
    Given I am creating a comment
    When I sign the comment event
    Then the event should be properly signed with my private key
    And the signature should be valid and verifiable
    And the event should include all required fields
    And the event should be ready for publishing to relays

  Scenario: Comment event publishing
    Given I have created a signed comment event
    When I publish the comment
    Then the event should be sent to appropriate relays
    And the event should be properly formatted
    And the event should include all required tags
    And the event should be associated with the target event

  Scenario: Comment threading display
    Given I am viewing comments on a publication
    When I display the comment thread
    Then the comments should be properly threaded
    And the threading should show parent-child relationships
    And the threading should be visually clear
    And I should be able to expand/collapse comment threads
    And the threading should follow the tag structure

  Scenario: Comment on website URL
    Given I am commenting on a website URL
    When I create a comment
    Then the comment should include 'I' tag with the URL
    And the comment should include 'K' tag with the domain as kind
    And the comment should include 'i' tag with the same URL
    And the comment should include 'k' tag with the same domain
    And the URL should be properly normalized

  Scenario: Comment on podcast episode
    Given I am commenting on a podcast episode
    When I create a comment
    Then the comment should include 'I' tag with the episode identifier
    And the comment should include 'K' tag with the podcast type
    And the comment should include 'i' tag with the same identifier
    And the comment should include 'k' tag with the same type
    And the identifier should follow the podcast format

  Scenario: Comment on file (NIP-94)
    Given I am commenting on a file
    When I create a comment
    Then the comment should include 'E' tag with the file event ID
    And the comment should include 'K' tag with the file kind (1063)
    And the comment should include 'P' tag with the file author
    And the comment should include 'e' tag with the same file ID
    And the comment should include 'k' tag with the same file kind
    And the comment should include 'p' tag with the same file author

  Scenario: Comment citation support (NIP-21)
    Given I am creating a comment with citations
    When I cite events in the comment content
    Then the comment should include 'q' tags for cited events
    And the 'q' tags should include event IDs or addresses
    And the 'q' tags should include relay hints
    And the 'q' tags should include pubkeys for regular events
    And the citations should be properly formatted

  Scenario: Comment mention support (NIP-21)
    Given I am creating a comment with mentions
    When I mention pubkeys in the comment content
    Then the comment should include 'p' tags for mentioned pubkeys
    And the 'p' tags should include relay hints
    And the mentions should be properly formatted
    And the mentions should be clickable in the UI

  Scenario: Comment not used for kind 1 replies
    Given I am trying to reply to a kind 1 note
    When I attempt to create a comment
    Then the app should prevent comment creation
    And the app should suggest using NIP-10 instead
    And the app should provide clear guidance about proper reply methods
    And the app should maintain protocol compliance

  Scenario: Comment validation
    Given I am creating a comment
    When I validate the comment structure
    Then the app should verify that required tags are present
    And the app should verify that tag formats are correct
    And the app should verify that content is plaintext
    And the app should verify that the event is properly signed
    And the app should reject invalid comments

  Scenario: Comment error handling
    Given I am trying to create a comment
    When the comment fails to publish
    Then the app should handle the error gracefully
    And I should see an appropriate error message
    And the app should provide retry options
    And the app should not lose my comment data
    And the app should attempt to publish again when possible

  Scenario: Comment privacy and security
    Given I am creating comments
    When I publish comments
    Then my comments should be properly signed
    And my comments should be associated with my identity
    And the app should respect privacy settings
    And the app should handle private comments appropriately
    And the app should maintain security of my private key

  Scenario: Comment synchronization
    Given I am viewing comments on a publication
    When new comments are published by others
    Then the comments should be synchronized in real-time
    And the comment counts should update automatically
    And new comments should appear in the thread
    And the synchronization should be smooth and reliable

  Scenario: Comment moderation
    Given I am viewing comments
    When I see inappropriate comments
    Then I should be able to report problematic comments
    And the app should provide moderation tools for comments
    And the app should handle comment moderation appropriately
    And the app should maintain a safe environment
    And the app should respect community guidelines

  # NIP-25 Specific Scenarios

  Scenario: Reaction event structure (NIP-25 kind 7)
    Given I am creating a reaction to a publication
    When I create a reaction event
    Then the event should be of kind 7
    And the content field should include the reaction value
    And the content should be "+" for like/upvote
    And the content should be "-" for dislike/downvote
    And the content should be an emoji for emoji reactions
    And the event should be properly signed with my nostr key

  Scenario: Reaction event tags (NIP-25)
    Given I am creating a reaction to a publication
    When I create a reaction event
    Then the event should have an 'e' tag with the target event ID
    And the 'e' tag should include a relay hint
    And the event should have a 'p' tag with the target event pubkey
    And the 'p' tag should include a relay hint
    And the event should have a 'k' tag with the target event kind
    And if the target is an addressable event, it should have an 'a' tag

  Scenario: Like/upvote reaction interpretation
    Given I am viewing a reaction with content "+"
    When I display the reaction
    Then it should be interpreted as a "like" or "upvote"
    And it should be displayed with appropriate like/upvote styling
    And it should be grouped with other like reactions
    And the count should reflect all like reactions

  Scenario: Dislike/downvote reaction interpretation
    Given I am viewing a reaction with content "-"
    When I display the reaction
    Then it should be interpreted as a "dislike" or "downvote"
    And it should be displayed with appropriate dislike/downvote styling
    And it should be grouped with other dislike reactions
    And the count should reflect all dislike reactions

  Scenario: Emoji reaction interpretation
    Given I am viewing a reaction with emoji content
    When I display the reaction
    Then it should NOT be interpreted as a "like" or "dislike"
    And it should be displayed as the emoji
    And it should be grouped with other identical emoji reactions
    And the count should reflect all identical emoji reactions

  Scenario: Custom emoji reaction support (NIP-30)
    Given I am viewing a reaction with custom emoji shortcode
    When I display the reaction
    Then the content should contain ":shortcode:" format
    And the event should have an emoji tag with the shortcode and URL
    And the emoji should be rendered from the specified URL
    And the shortcode should be properly parsed and displayed

  Scenario: Addressable event reaction support
    Given I am reacting to an addressable event
    When I create a reaction
    Then the reaction should include an 'a' tag
    And the 'a' tag should contain the event coordinates (kind:pubkey:d-tag)
    And the reaction should be properly associated with the addressable event
    And the reaction should be displayed in the correct context

  Scenario: Reaction relay hints
    Given I am creating a reaction
    When I include relay hints in tags
    Then the 'e' tag should include a relay hint as the third element
    And the 'p' tag should include a relay hint as the second element
    And the 'a' tag should include relay and pubkey hints
    And the hints should help other clients find the target events

  Scenario: Multiple 'e' and 'p' tags handling
    Given I am creating a reaction with multiple 'e' or 'p' tags
    When I process the reaction
    Then the target event ID should be the last 'e' tag
    And the target event pubkey should be the last 'p' tag
    And other tags should be processed appropriately
    And the reaction should be associated with the correct target

  Scenario: Website reaction support (kind 17)
    Given I am reacting to a website URL
    When I create a website reaction
    Then the event should be of kind 17
    And the event should include an 'r' tag with the website URL
    And the URL should be normalized according to RFC 3986
    And the reaction should be properly associated with the website

  Scenario: Website reaction with fragment
    Given I am reacting to a website URL with fragment
    When I create a website reaction
    Then the 'r' tag should include the full URL with fragment
    And the fragment should be preserved in the reaction
    And the reaction should be treated as different from the base URL
    And the reaction should be properly associated with the specific section

  Scenario: Reaction content validation
    Given I am creating a reaction
    When I validate the reaction content
    Then the content should be user-generated
    Then the content should indicate the reaction value
    And the content should be "+" for like, "-" for dislike, or an emoji
    And the content should be properly formatted and valid

  Scenario: Reaction event signing
    Given I am creating a reaction
    When I sign the reaction event
    Then the event should be properly signed with my private key
    And the signature should be valid and verifiable
    And the event should include all required fields
    And the event should be ready for publishing to relays

  Scenario: Reaction event publishing
    Given I have created a signed reaction event
    When I publish the reaction
    Then the event should be sent to appropriate relays
    And the event should be properly formatted
    And the event should include all required tags
    And the event should be associated with the target event

  Scenario: Reaction display and grouping
    Given I am viewing multiple reactions to an event
    When I display the reactions
    Then like reactions ("+") should be grouped together
    And dislike reactions ("-") should be grouped together
    And emoji reactions should be grouped by emoji type
    And each group should show the total count
    And the reactions should be clearly distinguishable

  Scenario: Reaction removal and modification
    Given I have created a reaction to an event
    When I want to modify my reaction
    Then I should be able to remove my existing reaction
    And I should be able to change my reaction to a different type
    And the change should be reflected immediately
    And the reaction counts should update accordingly
    And the modification should be properly signed and published

  Scenario: Reaction synchronization
    Given I am viewing reactions to an event
    When new reactions are published by others
    Then the reactions should be synchronized in real-time
    And the reaction counts should update automatically
    And new reactions should appear in the appropriate groups
    And the synchronization should be smooth and reliable

  Scenario: Reaction error handling
    Given I am trying to create a reaction
    When the reaction fails to publish
    Then the app should handle the error gracefully
    And I should see an appropriate error message
    And the app should provide retry options
    And the app should not lose my reaction data
    And the app should attempt to publish again when possible

  Scenario: Reaction privacy and security
    Given I am creating reactions
    When I publish reactions
    Then my reactions should be properly signed
    And my reactions should be associated with my identity
    And the app should respect privacy settings
    And the app should handle private reactions appropriately
    And the app should maintain security of my private key

  # NIP-84 Specific Scenarios

  Scenario: Highlight event structure (NIP-84 kind 9802)
    Given I am creating a highlight of content
    When I create a highlight event
    Then the event should be of kind 9802
    And the content should contain the highlighted text
    And the content may be empty for non-text media
    And the event should be properly signed with my nostr key
    And the event should be published to relays

  Scenario: Highlight source tagging (NIP-84)
    Given I am creating a highlight
    When I tag the source of the highlight
    Then the event should include an 'a' tag for addressable events
    And the event should include an 'e' tag for regular events
    And the event should include an 'r' tag for URLs
    And the URL should be cleaned of trackers and non-useful query parameters
    And the source should be properly referenced

  Scenario: Highlight attribution (NIP-84)
    Given I am creating a highlight
    When I include author attribution
    Then the event should include 'p' tags for original authors
    And the 'p' tags should include relay hints
    And the 'p' tags should include role information (author, editor)
    And the attribution should be properly formatted
    And the attribution should help identify content creators

  Scenario: Highlight context (NIP-84)
    Given I am creating a highlight
    When I include context information
    Then the event should include a 'context' tag
    And the context should provide surrounding content
    And the context should help understand the highlight
    And the context should be properly formatted
    And the context should enhance the highlight display

  Scenario: Quote highlight creation (NIP-84)
    Given I am creating a quote highlight
    When I add a comment to the highlight
    Then the event should include a 'comment' tag
    And the highlight should be rendered like a quote repost
    And the highlight should be the quoted note
    And the comment should provide additional context
    And the quote highlight should prevent duplicate notes

  Scenario: Highlight of nostr event
    Given I am highlighting content from a nostr event
    When I create the highlight
    Then the event should include an 'a' tag for addressable events
    And the event should include an 'e' tag for regular events
    And the event should include proper relay hints
    And the event should include author attribution if available
    And the highlight should be properly associated with the source

  Scenario: Highlight of URL content
    Given I am highlighting content from a URL
    When I create the highlight
    Then the event should include an 'r' tag with the URL
    And the URL should be cleaned of trackers
    And the URL should be cleaned of non-useful query parameters
    And the event should include author attribution if available
    And the highlight should be properly associated with the URL

  Scenario: Highlight of non-text media
    Given I am highlighting non-text media (audio/video)
    When I create the highlight
    Then the content field may be empty
    And the event should include proper source tagging
    And the event should include author attribution if available
    And the event should include context if helpful
    And the highlight should be properly associated with the media

  Scenario: Highlight with multiple authors
    Given I am highlighting content with multiple authors
    When I create the highlight
    Then the event should include multiple 'p' tags
    And each 'p' tag should include the author's pubkey
    And each 'p' tag should include relay hints
    And each 'p' tag should include the author's role
    And the attribution should be comprehensive

  Scenario: Highlight with context
    Given I am highlighting a subset of a paragraph
    When I create the highlight
    Then the event should include a 'context' tag
    And the context should include surrounding content
    And the context should help understand the highlight
    And the context should be properly formatted
    And the context should enhance readability

  Scenario: Quote highlight rendering
    Given I am viewing a quote highlight
    When I display the highlight
    Then it should be rendered like a quote repost
    And the highlight should be the quoted note
    And the comment should provide additional context
    And the display should be visually distinct
    And the source should be clearly indicated

  Scenario: Highlight mention attributes
    Given I am creating a highlight with mentions
    When I include p-tag mentions
    Then the p-tags should have a 'mention' attribute
    And the mention attribute should distinguish from authors
    And the mentions should be properly formatted
    And the mentions should be clickable in the UI

  Scenario: Highlight URL attributes
    Given I am creating a highlight with URLs
    When I include r-tag URLs from comments
    Then the r-tags should have a 'mention' attribute
    And the mention attribute should distinguish from source URLs
    And the source URL should have a 'source' attribute
    And the URLs should be properly formatted
    And the URLs should be clickable in the UI

  Scenario: Highlight source URL cleaning
    Given I am highlighting content from a URL
    When I clean the source URL
    Then trackers should be removed from the URL
    And non-useful query parameters should be removed
    And the URL should be normalized
    And the cleaned URL should be used in the 'r' tag
    And the cleaning should be done with best effort

  Scenario: Highlight event signing
    Given I am creating a highlight
    When I sign the highlight event
    Then the event should be properly signed with my private key
    And the signature should be valid and verifiable
    And the event should include all required fields
    And the event should be ready for publishing to relays

  Scenario: Highlight event publishing
    Given I have created a signed highlight event
    When I publish the highlight
    Then the event should be sent to appropriate relays
    And the event should be properly formatted
    And the event should include all required tags
    And the event should be associated with the source content

  Scenario: Highlight display
    Given I am viewing highlights on content
    When I display the highlights
    Then the highlights should be clearly visible
    And the highlighted text should be emphasized
    And the source should be clearly indicated
    And the attribution should be displayed
    And the context should be available if included

  Scenario: Highlight interaction
    Given I am viewing a highlight
    When I interact with the highlight
    Then I should be able to view the source content
    And I should be able to see the attribution
    And I should be able to see the context if available
    And I should be able to reply to the highlight
    And the interaction should be smooth and intuitive

  Scenario: Highlight synchronization
    Given I am viewing highlights on content
    When new highlights are published by others
    Then the highlights should be synchronized in real-time
    And the highlight counts should update automatically
    And new highlights should appear in the display
    And the synchronization should be smooth and reliable

  Scenario: Highlight error handling
    Given I am trying to create a highlight
    When the highlight fails to publish
    Then the app should handle the error gracefully
    And I should see an appropriate error message
    And the app should provide retry options
    And the app should not lose my highlight data
    And the app should attempt to publish again when possible

  Scenario: Highlight privacy and security
    Given I am creating highlights
    When I publish highlights
    Then my highlights should be properly signed
    And my highlights should be associated with my identity
    And the app should respect privacy settings
    And the app should handle private highlights appropriately
    And the app should maintain security of my private key

  Scenario: Highlight moderation
    Given I am viewing highlights
    When I see inappropriate highlights
    Then I should be able to report problematic highlights
    And the app should provide moderation tools for highlights
    And the app should handle highlight moderation appropriately
    And the app should maintain a safe environment
    And the app should respect community guidelines

  Scenario: Highlight search and filtering
    Given I am viewing many highlights
    When I want to find specific highlights
    Then I should be able to search through highlights
    And I should be able to filter by source type
    And I should be able to filter by author
    And I should be able to filter by content type
    And the search and filtering should be fast and responsive

  Scenario: Highlight analytics
    Given I am viewing highlights
    When I look at highlight data
    Then I should see meaningful analytics about highlights
    And the analytics should help understand engagement
    And the analytics should be privacy-respecting
    And the analytics should provide useful insights
    And the analytics should help identify valuable content

  Scenario: Highlight export and sharing
    Given I have created highlights
    When I want to export or share highlights
    Then I should be able to export highlight data
    And I should be able to share highlights with others
    And the export should include proper attribution
    And the sharing should respect privacy settings
    And the export should be in a standard format

  Scenario: Highlight backup and sync
    Given I have created highlights
    When I want to backup or sync highlights
    Then I should be able to backup highlight data
    And I should be able to sync highlights across devices
    And the backup should include all highlight metadata
    And the sync should be secure and reliable
    And the sync should respect user preferences

  # NIP-51 Bookmark and Mute List Scenarios

  Scenario: Bookmark header card (NIP-51 kind 10003)
    Given I am viewing a publication header card
    When I tap the bookmark button on the header card
    Then the app should create a kind 10003 bookmark event
    And the event should include the publication in appropriate tags
    And the event should be properly signed with my nostr key
    And the event should be published to relays
    And the bookmark should be saved locally
    And the bookmark button should show as bookmarked

  Scenario: Bookmark different publication types
    Given I am viewing different types of publications
    When I bookmark the header cards
    Then the app should support bookmarking kind 30023 articles
    And the app should support bookmarking kind 30041 notes
    And the app should support bookmarking kind 30818 wikis
    And the app should support bookmarking kind 30040 indexes
    And the app should include appropriate tags for each type

  Scenario: Bookmark display and management
    Given I have bookmarked several publications
    When I view my bookmarks
    Then I should see all my bookmarked publications
    And the publications should be organized by type
    And the publications should show their source information
    And I should be able to access the original content
    And I should be able to remove bookmarks
    And I should be able to organize bookmarks into sets

  Scenario: Mute list filtering (NIP-51 kind 10000)
    Given I have a mute list configured
    When I fetch publications from relays
    Then the app should filter out publications from muted pubkeys
    And the app should filter out publications with muted hashtags
    And the app should filter out publications with muted words
    And the app should filter out publications in muted threads
    And the filtering should be applied consistently across all content types

  Scenario: Mute list management
    Given I want to manage my mute list
    When I access mute list settings
    Then I should be able to add new pubkeys to mute
    And I should be able to add new hashtags to mute
    And I should be able to add new words to mute
    And I should be able to add new threads to mute
    And I should be able to remove items from mute
    And I should be able to view all muted items
    And changes should be published to relays

  Scenario: Mute list creation and sync
    Given I want to create a mute list
    When I create a mute list
    Then the app should create a kind 10000 mute event
    And the event should include muted pubkeys in 'p' tags
    And the event should include muted hashtags in 't' tags
    And the event should include muted words in 'word' tags
    And the event should include muted threads in 'e' tags
    And the event should be properly signed and published
    And the mute list should be synchronized across devices

  Scenario: Bookmark sets (NIP-51 kind 30003)
    Given I want to organize bookmarks into categories
    When I create a bookmark set
    Then the app should create a kind 30003 bookmark set event
    And the event should include a 'd' tag for the set identifier
    And the event should include optional 'title', 'image', and 'description' tags
    And the event should include bookmarked publications in appropriate tags
    And the bookmark set should be properly categorized
    And the event should be properly signed and published

  Scenario: Bookmark set management
    Given I have created bookmark sets
    When I manage my bookmark sets
    Then I should be able to create multiple bookmark sets
    And I should be able to organize bookmarks by category
    And I should be able to switch between bookmark sets
    And I should be able to edit set metadata
    And I should be able to move bookmarks between sets
    And the set management should be intuitive

  Scenario: Mute list privacy (NIP-51 encryption)
    Given I want to keep some mute list items private
    When I add private items to my mute list
    Then the app should encrypt the private items using NIP-04
    And the encrypted items should be stored in the content field
    And the encryption should use the author's public and private keys
    And the private items should not be visible to others
    And the private items should be properly decrypted when viewing

  Scenario: Bookmark and mute list synchronization
    Given I have bookmarks and mute lists
    When I sync across devices
    Then the bookmarks should be synchronized in real-time
    And the mute lists should be synchronized in real-time
    And the list items should be properly ordered
    And the private items should be properly encrypted
    And the public items should be properly shared
    And the synchronization should be secure and reliable

  Scenario: Bookmark and mute list error handling
    Given I am trying to create or modify bookmarks or mute lists
    When the operation fails
    Then the app should handle the error gracefully
    And I should see an appropriate error message
    And the app should provide retry options
    And the app should not lose my bookmark or mute data
    And the app should attempt to publish again when possible

  Scenario: Bookmark and mute list privacy and security
    Given I am creating bookmarks and mute lists
    When I manage my lists
    Then my private items should be properly encrypted
    And my encryption keys should be secure
    And the app should respect privacy settings
    And the app should handle private lists appropriately
    And the app should maintain security of my private key

  Scenario: Bookmark and mute list moderation
    Given I am viewing bookmarks and mute lists from other users
    When I see inappropriate list content
    Then I should be able to report problematic lists
    And the app should provide moderation tools for lists
    And the app should handle list moderation appropriately
    And the app should maintain a safe environment
    And the app should respect community guidelines

  Scenario: Bookmark and mute list search and filtering
    Given I am viewing many bookmarks and mute lists
    When I want to find specific items
    Then I should be able to search through bookmarks
    And I should be able to search through mute lists
    And I should be able to filter by content type
    And I should be able to filter by author
    And I should be able to filter by date
    And the search and filtering should be fast and responsive

  Scenario: Bookmark and mute list analytics
    Given I am viewing bookmarks and mute lists
    When I look at list data
    Then I should see meaningful analytics about bookmarks
    And I should see meaningful analytics about mute lists
    And the analytics should help understand usage patterns
    And the analytics should be privacy-respecting
    And the analytics should provide useful insights

  Scenario: Bookmark and mute list export and sharing
    Given I have created bookmarks and mute lists
    When I want to export or share lists
    Then I should be able to export bookmark data
    And I should be able to export mute list data
    And I should be able to share lists with others
    And the export should include proper metadata
    And the sharing should respect privacy settings
    And the export should be in a standard format

  Scenario: Bookmark and mute list backup and sync
    Given I have created bookmarks and mute lists
    When I want to backup or sync lists
    Then I should be able to backup list data
    And I should be able to sync lists across devices
    And the backup should include all list metadata
    And the sync should be secure and reliable
    And the sync should respect user preferences

  Scenario: Bookmark and mute list UI enhancement
    Given I am viewing bookmarks and mute lists with metadata
    When I display the lists
    Then lists with 'title' tags should show the title
    And lists with 'image' tags should show the image
    And lists with 'description' tags should show the description
    And the UI should be enhanced with the metadata
    And the display should be visually appealing
    And the interface should be intuitive and user-friendly 