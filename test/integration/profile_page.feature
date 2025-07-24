Feature: Profile Page
  As a user
  I want to access and view profile pages
  So that I can manage my settings, view notifications, and see profile information including bookmarks and pinned notes

  Background:
    Given I am using the Alex Reader app
    And the app supports profile page functionality
    And I have access to various content types

  # Authenticated User Profile Scenarios

  Scenario: Access my own profile page
    Given I am logged in with my nostr key
    When I navigate to my profile page
    Then I should see my profile metadata prominently displayed
    And I should see my display name and avatar
    And I should see my about information
    And I should see my website link if available
    And I should see my public key (npub)
    And I should see tabs for different sections

  Scenario: Profile metadata display (NIP-01 kind 0)
    Given I am viewing a profile page
    When I look at the profile metadata
    Then I should see the user's display name
    And I should see the user's avatar/picture
    And I should see the user's about/bio information
    And I should see the user's website link
    And I should see the user's public key (npub)
    And I should see when the profile was last updated
    And the metadata should be properly formatted and displayed

  Scenario: Profile settings access
    Given I am logged in and viewing my own profile
    When I access the settings section
    Then I should see a settings button or tab
    And I should be able to access authentication settings
    And I should be able to access relay preferences
    And I should be able to access privacy settings
    And I should be able to access notification preferences
    And I should be able to access theme preferences
    And I should be able to access data management options

  Scenario: Authentication settings
    Given I am in the profile settings
    When I access authentication settings
    Then I should see my current authentication status
    And I should be able to view my public key
    And I should be able to change my authentication method
    And I should be able to log out
    And I should be able to manage my keys
    And I should see security recommendations

  Scenario: Relay preferences settings
    Given I am in the profile settings
    When I access relay preferences
    Then I should see my current relay connections
    And I should be able to add new relays
    And I should be able to remove relays
    And I should be able to configure read/write relays (NIP-51 kind 10002)
    And I should be able to configure search relays (NIP-51 kind 10007)
    And I should be able to configure blocked relays (NIP-51 kind 10006)
    And I should be able to test relay connections

  Scenario: Privacy settings
    Given I am in the profile settings
    When I access privacy settings
    Then I should be able to control what information is public
    And I should be able to manage my mute lists (NIP-51 kind 10000)
    And I should be able to control notification privacy
    And I should be able to manage data sharing preferences
    And I should be able to control profile visibility
    And I should see privacy recommendations

  Scenario: Notification preferences
    Given I am in the profile settings
    When I access notification preferences
    Then I should be able to enable/disable notifications
    And I should be able to configure notification types
    And I should be able to set notification frequency
    And I should be able to configure notification sounds
    And I should be able to manage notification privacy
    And I should be able to test notifications

  Scenario: Theme preferences
    Given I am in the profile settings
    When I access theme preferences
    Then I should be able to choose between light and dark themes
    And I should be able to enable auto theme switching
    And I should be able to customize accent colors
    And I should be able to adjust font sizes
    And I should be able to customize reading preferences
    And I should be able to preview theme changes

  Scenario: Data management
    Given I am in the profile settings
    When I access data management
    Then I should be able to export my data
    And I should be able to backup my data
    And I should be able to clear local cache
    And I should be able to manage stored content
    And I should be able to sync data across devices
    And I should see storage usage information

  Scenario: Notifications display
    Given I am logged in and viewing my profile
    When I access the notifications section
    Then I should see a notifications tab or button
    And I should see recent notifications
    And I should see unread notification indicators
    And I should be able to mark notifications as read
    And I should be able to clear notifications
    And I should be able to filter notifications by type
    And I should see notification timestamps

  Scenario: Notification types
    Given I am viewing notifications
    When I browse different notification types
    Then I should see reactions to my content (NIP-25)
    And I should see comments on my content (NIP-22)
    And I should see highlights of my content (NIP-84)
    And I should see zaps to my content (NIP-57)
    And I should see mentions of my pubkey
    And I should see follows and other social interactions
    And I should see system notifications

  # Public Profile Scenarios

  Scenario: View other user's profile
    Given I am viewing another user's profile
    When I access their profile page
    Then I should see their profile metadata prominently displayed
    And I should see their display name and avatar
    And I should see their about information
    And I should see their website link if available
    And I should see their public key (npub)
    And I should see tabs for different sections
    And I should not see private settings or notifications

  Scenario: Profile navigation
    Given I am viewing any profile page
    When I navigate through the profile sections
    Then I should see tabs for different sections
    And I should be able to switch between sections
    And I should see the current active section highlighted
    And I should be able to access bookmarks section
    And I should be able to access pinned notes section
    And I should be able to access publications section
    And I should be able to access interactions section

  # Bookmarks Section (NIP-51 kind 10003)

  Scenario: View user's bookmarks
    Given I am viewing a profile page
    When I access the bookmarks section
    Then I should see the user's bookmarked content
    And the bookmarks should be organized by type
    And I should see bookmarked articles (kind 30023)
    And I should see bookmarked notes (kind 1)
    And I should see bookmarked hashtags
    And I should see bookmarked URLs
    And I should see bookmark timestamps
    And I should be able to access the original content

  Scenario: Bookmark organization
    Given I am viewing bookmarks
    When I browse the bookmarks
    Then I should see bookmarks organized by content type
    And I should see bookmarks organized by date
    And I should see bookmark counts
    And I should see bookmark descriptions if available
    And I should be able to filter bookmarks
    And I should be able to search through bookmarks
    And I should see bookmark metadata

  Scenario: Bookmark sets display (NIP-51 kind 30003)
    Given I am viewing a user's bookmarks
    When the user has organized bookmarks into sets
    Then I should see bookmark sets with titles
    And I should see bookmark sets with descriptions
    And I should see bookmark sets with images if available
    And I should be able to browse different bookmark sets
    And I should see the number of items in each set
    And I should be able to access individual bookmark sets

  # Pinned Notes Section (NIP-51 kind 10001)

  Scenario: View user's pinned notes
    Given I am viewing a profile page
    When I access the pinned notes section
    Then I should see the user's pinned notes prominently displayed
    And the pinned notes should be kind 1 notes (NIP-51 kind 10001)
    And I should see the pinned notes in chronological order
    And I should see pinned note timestamps
    And I should see pinned note content previews
    And I should be able to access the full pinned notes
    And I should see pinned note metadata

  Scenario: Pinned notes display
    Given I am viewing pinned notes
    When I browse the pinned notes
    Then I should see pinned notes with proper formatting
    And I should see pinned notes with author information
    And I should see pinned notes with interaction counts
    And I should see pinned notes with timestamps
    And I should be able to interact with pinned notes
    And I should see pinned notes in a visually distinct format
    And I should see the total number of pinned notes

  Scenario: Pinned notes interaction
    Given I am viewing pinned notes
    When I interact with pinned notes
    Then I should be able to read the full pinned notes
    And I should be able to react to pinned notes (NIP-25)
    And I should be able to comment on pinned notes (NIP-22)
    And I should be able to highlight pinned notes (NIP-84)
    And I should be able to zap pinned notes (NIP-57)
    And I should be able to share pinned notes
    And I should be able to bookmark pinned notes

  # Publications Section

  Scenario: View user's publications
    Given I am viewing a profile page
    When I access the publications section
    Then I should see the user's published content
    And I should see articles (kind 30023)
    And I should see notes (kind 30041)
    And I should see wikis (kind 30818)
    And I should see indexes (kind 30040)
    And I should see publications organized by type
    And I should see publication timestamps
    And I should see publication metadata

  Scenario: Publication filtering
    Given I am viewing user's publications
    When I filter the publications
    Then I should be able to filter by content type
    And I should be able to filter by date range
    And I should be able to filter by tags
    And I should be able to search through publications
    And I should see publication counts by type
    And I should see publication statistics
    And I should be able to sort publications

  # Interactions Section

  Scenario: View user's interactions
    Given I am viewing a profile page
    When I access the interactions section
    Then I should see the user's recent interactions
    And I should see reactions given by the user (NIP-25)
    And I should see comments made by the user (NIP-22)
    And I should see highlights created by the user (NIP-84)
    And I should see zaps sent by the user (NIP-57)
    And I should see interactions organized by type
    And I should see interaction timestamps

  Scenario: Interaction filtering
    Given I am viewing user's interactions
    When I filter the interactions
    Then I should be able to filter by interaction type
    And I should be able to filter by date range
    And I should be able to filter by target content
    And I should be able to search through interactions
    And I should see interaction counts by type
    And I should see interaction statistics
    And I should be able to sort interactions

  # Profile Management (Authenticated Users Only)

  Scenario: Edit my profile metadata
    Given I am logged in and viewing my profile
    When I edit my profile information
    Then I should be able to update my display name
    And I should be able to update my avatar/picture
    And I should be able to update my about/bio
    And I should be able to update my website
    And I should be able to preview changes
    And I should be able to save changes
    And the changes should be published as kind 0 event
    And the changes should be signed with my key

  Scenario: Manage my bookmarks
    Given I am logged in and viewing my bookmarks
    When I manage my bookmarks
    Then I should be able to add new bookmarks
    And I should be able to remove bookmarks
    And I should be able to organize bookmarks into sets
    And I should be able to edit bookmark sets
    And I should be able to share bookmark sets
    And I should be able to export bookmarks
    And changes should be published to relays

  Scenario: Manage my pinned notes
    Given I am logged in and viewing my pinned notes
    When I manage my pinned notes
    Then I should be able to pin new notes
    And I should be able to unpin notes
    And I should be able to reorder pinned notes
    And I should be able to edit pinned notes list
    And I should be able to share pinned notes
    And I should be able to export pinned notes
    And changes should be published to relays

  Scenario: Profile privacy controls
    Given I am logged in and managing my profile
    When I configure privacy settings
    Then I should be able to control what information is public
    And I should be able to control bookmark visibility
    And I should be able to control pinned notes visibility
    And I should be able to control publication visibility
    And I should be able to control interaction visibility
    And I should be able to set profile access permissions
    And privacy settings should be properly applied

  # Profile Discovery and Navigation

  Scenario: Discover user profiles
    Given I am browsing the app
    When I discover user profiles
    Then I should be able to search for users by npub
    And I should be able to search for users by display name
    And I should be able to discover users through interactions
    And I should be able to discover users through publications
    And I should be able to discover users through bookmarks
    And I should be able to discover users through pinned notes
    And I should see user profile previews

  Scenario: Profile navigation from content
    Given I am viewing content in the app
    When I want to view the author's profile
    Then I should be able to tap on author information
    And I should be able to access the author's profile page
    And I should see the author's profile metadata
    And I should be able to view the author's bookmarks
    And I should be able to view the author's pinned notes
    And I should be able to view the author's publications
    And I should be able to view the author's interactions

  Scenario: Profile sharing
    Given I am viewing a profile page
    When I want to share the profile
    Then I should be able to share the profile URL
    And I should be able to share the profile npub
    And I should be able to share profile information
    And I should be able to copy profile details
    And I should be able to bookmark the profile
    And I should be able to follow the user
    And sharing should respect privacy settings

  # Profile Analytics and Insights

  Scenario: View profile analytics
    Given I am viewing a profile page
    When I access profile analytics
    Then I should see profile statistics
    And I should see publication counts
    And I should see interaction counts
    And I should see bookmark counts
    And I should see pinned note counts
    And I should see follower/following counts
    And I should see profile activity timeline
    And analytics should be privacy-respecting

  Scenario: Profile insights
    Given I am viewing profile analytics
    When I analyze the profile data
    Then I should see popular publications
    And I should see recent activity
    And I should see interaction patterns
    And I should see content preferences
    And I should see engagement metrics
    And I should see profile growth trends
    And insights should be useful and relevant

  # Profile Error Handling

  Scenario: Handle profile loading errors
    Given I am trying to view a profile
    When the profile fails to load
    Then I should see an appropriate error message
    And I should see retry options
    And I should see fallback profile information
    And I should be able to refresh the profile
    And I should be able to report the issue
    And the error should be handled gracefully

  Scenario: Handle missing profile data
    Given I am viewing a profile with missing data
    When I encounter missing profile information
    Then I should see placeholder content for missing fields
    And I should see appropriate default values
    And I should see indicators for missing data
    And I should be able to request missing data
    And the display should remain functional
    And the user experience should not be broken

  # Profile Performance

  Scenario: Profile page performance
    Given I am viewing a profile page
    When I interact with the profile
    Then the profile should load quickly
    And the profile should be responsive
    And the profile should handle large amounts of data
    And the profile should cache data appropriately
    And the profile should sync efficiently
    And the profile should work offline
    And the profile should provide smooth navigation

  Scenario: Profile data synchronization
    Given I am viewing a profile page
    When the profile data updates
    Then the profile should sync in real-time
    And the profile should show update indicators
    And the profile should handle conflicts gracefully
    And the profile should maintain data consistency
    And the profile should provide sync status
    And the profile should handle sync errors
    And the profile should prioritize important updates

  # NIP-58 Badge Scenarios

  Scenario: Display user badges on profile
    Given I am viewing a profile page
    When I look at the profile badges section
    Then I should see the user's awarded badges prominently displayed
    And the badges should be displayed in the user's chosen order
    And the badges should show high-resolution images when available
    And the badges should show appropriate thumbnails based on space
    And the badges should be clickable for more information
    And I should see badge names and descriptions
    And I should see badge issuer information

  Scenario: Badge definition display (NIP-58 kind 30009)
    Given I am viewing a badge on a profile
    When I click on a badge for more information
    Then I should see the badge definition details
    And I should see the badge name from the 'name' tag
    And I should see the badge description from the 'description' tag
    And I should see the high-resolution badge image (1024x1024 recommended)
    And I should see the badge issuer information
    And I should see when the badge was defined
    And I should see the badge's unique identifier

  Scenario: Badge award information (NIP-58 kind 8)
    Given I am viewing a badge on a profile
    When I access the badge award information
    Then I should see when the badge was awarded
    And I should see who awarded the badge
    And I should see the badge award event details
    And I should see the relay information for the award
    And I should see that the badge is immutable and non-transferrable
    And I should see the badge award event ID

  Scenario: Profile badges event (NIP-58 kind 30008)
    Given I am viewing a user's profile
    When I access the profile badges section
    Then I should see badges from the user's profile badges event
    And the badges should be displayed in the order specified by the user
    And I should see the 'd' tag with value 'profile_badges'
    And I should see ordered pairs of 'a' and 'e' tags
    And the 'a' tags should reference badge definitions (kind 30009)
    And the 'e' tags should reference badge awards (kind 8)
    And the profile should handle missing or invalid badge references gracefully

  Scenario: Badge thumbnail rendering
    Given I am viewing badges on a profile
    When I see the badge thumbnails
    Then the app should render appropriate thumbnail sizes
    And the app should use 512x512 for extra large thumbnails
    And the app should use 256x256 for large thumbnails
    And the app should use 64x64 for medium thumbnails
    And the app should use 32x32 for small thumbnails
    And the app should use 16x16 for extra small thumbnails
    And the app should choose the most appropriate size based on space available

  Scenario: Badge high-resolution display
    Given I am viewing a badge on a profile
    When I interact with the badge (click, tap, hover)
    Then the app should display the high-resolution version (1024x1024)
    And the high-resolution image should be properly formatted
    And the image should maintain the recommended 1:1 aspect ratio
    And the image should load quickly and efficiently
    And the image should be properly cached
    And the image should handle loading errors gracefully

  Scenario: Badge issuer whitelisting
    Given I am viewing badges on profiles
    When I see badges from different issuers
    Then the app should support whitelisting badge issuers
    And the app should display badges from whitelisted issuers prominently
    And the app should indicate which badges are from trusted issuers
    And the app should allow users to manage issuer whitelists
    And the app should provide issuer reputation information
    And the app should help users make informed decisions about badge issuers

  Scenario: Badge theme integration
    Given I am viewing badges on a profile
    When the app renders the badges
    Then the app may replace badge images to fit the client theme
    And the app may render fewer badges than specified by the user
    And the app should maintain badge meaning and context
    And the app should provide theme-consistent badge styling
    And the app should ensure badges remain recognizable
    And the app should respect user preferences for badge display

  Scenario: Badge management for authenticated users
    Given I am logged in and viewing my own profile
    When I manage my profile badges
    Then I should be able to accept or reject awarded badges
    And I should be able to choose the display order of badges
    And I should be able to hide badges I don't want to display
    And I should be able to update my profile badges event
    And I should be able to see all badges I've been awarded
    And I should be able to see badge issuer information
    And changes should be published to relays

  Scenario: Badge award notifications
    Given I am logged in and have been awarded a badge
    When I receive a badge award
    Then I should receive a notification about the badge award
    And I should see the badge definition details
    And I should see who awarded me the badge
    And I should be able to accept or reject the badge
    And I should be able to add the badge to my profile
    And I should be able to view the badge award event
    And the notification should include relevant badge information

  Scenario: Badge discovery and browsing
    Given I am browsing profiles
    When I see badges on different profiles
    Then I should be able to click on badges for more information
    And I should be able to see badge definitions
    And I should be able to see who issued the badges
    And I should be able to discover new badge types
    And I should be able to see badge popularity
    And I should be able to explore badge categories
    And I should be able to find badge issuers

  Scenario: Badge search and filtering
    Given I am viewing badges on profiles
    When I want to find specific badges
    Then I should be able to search for badges by name
    And I should be able to search for badges by issuer
    And I should be able to filter badges by category
    And I should be able to filter badges by popularity
    And I should be able to search for badge definitions
    And I should be able to find users with specific badges
    And the search should be fast and responsive

  Scenario: Badge analytics and insights
    Given I am viewing badges on profiles
    When I analyze badge data
    Then I should see popular badge types
    And I should see trusted badge issuers
    And I should see badge award patterns
    And I should see badge display preferences
    And I should see badge engagement metrics
    And I should see badge discovery trends
    And the analytics should be privacy-respecting

  Scenario: Badge sharing and social features
    Given I am viewing a badge on a profile
    When I want to share badge information
    Then I should be able to share badge definitions
    And I should be able to share badge awards
    And I should be able to share profile badges
    And I should be able to recommend badges to others
    And I should be able to discuss badges with other users
    And I should be able to create badge-related content
    And sharing should respect privacy settings

  Scenario: Badge error handling
    Given I am viewing badges on a profile
    When badge data is missing or invalid
    Then the app should handle missing badge definitions gracefully
    And the app should handle missing badge awards gracefully
    And the app should handle invalid badge references gracefully
    And the app should show appropriate fallback content
    And the app should provide error information when helpful
    And the app should maintain profile functionality
    And the app should not break the user experience

  Scenario: Badge synchronization
    Given I am viewing badges on a profile
    When badge data updates
    Then the badges should sync in real-time
    And new badge awards should appear immediately
    And badge display order changes should update
    And badge definition updates should be reflected
    And the sync should be efficient and reliable
    And the sync should handle conflicts gracefully
    And the sync should prioritize important updates

  Scenario: Badge accessibility
    Given I am viewing badges on a profile
    When I use accessibility features
    Then badges should have proper alt text descriptions
    And badges should be navigable with screen readers
    And badge information should be accessible
    And badge interactions should be keyboard accessible
    And badge content should have proper contrast ratios
    And badge information should be available in multiple formats
    And the accessibility should meet standard guidelines

  Scenario: Badge performance optimization
    Given I am viewing badges on a profile
    When I interact with badges
    Then badge images should load efficiently
    And badge thumbnails should be properly cached
    And badge data should be optimized for performance
    And badge rendering should be smooth and responsive
    And badge interactions should be fast
    And badge synchronization should be efficient
    And the performance should not impact profile loading

  Scenario: Badge privacy and security
    Given I am viewing badges on a profile
    When I consider badge privacy
    Then badge information should respect user privacy settings
    And badge awards should be properly authenticated
    And badge definitions should be verified
    And badge issuer information should be secure
    And badge data should be protected from tampering
    And badge sharing should respect privacy preferences
    And the security should meet standard requirements

  Scenario: Badge customization options
    Given I am logged in and managing my badges
    When I customize my badge display
    Then I should be able to choose which badges to display
    And I should be able to set the display order
    And I should be able to customize badge styling
    And I should be able to set badge visibility preferences
    And I should be able to organize badges into categories
    And I should be able to create custom badge collections
    And the customization should be saved and synced

  Scenario: Badge community features
    Given I am viewing badges in the community
    When I engage with badge-related content
    Then I should be able to discuss badges with other users
    And I should be able to recommend badges to others
    And I should be able to share badge stories
    And I should be able to participate in badge-related discussions
    And I should be able to discover new badge types
    And I should be able to connect with badge issuers
    And the community features should enhance the badge experience

  # NIP-54 Wiki Profile Scenarios

  Scenario: Display user's wiki articles on profile
    Given I am viewing a profile page
    When I access the wiki articles section
    Then I should see the user's wiki articles (kind 30818)
    And the articles should be organized by topic
    And I should see article titles and summaries
    And I should see article timestamps
    And I should see article metadata
    And I should be able to access the full wiki articles
    And I should see article statistics

  Scenario: Wiki article creation from profile (NIP-54 kind 30818)
    Given I am logged in and viewing my own profile
    When I create a new wiki article from my profile
    Then the app should create a kind 30818 addressable event
    And the event should include a 'd' tag with normalized lowercase identifier
    And the event should include a 'title' tag for display title
    And the event should include a 'summary' tag for display in lists
    And the content should be in AsciiDoc format
    And the event should be properly signed and published
    And the article should appear in my profile's wiki section

  Scenario: Wiki article management from profile
    Given I am logged in and viewing my own profile
    When I manage my wiki articles
    Then I should be able to see all my wiki articles
    And I should be able to edit my wiki articles
    And I should be able to delete my wiki articles
    And I should be able to organize my wiki articles
    And I should be able to see article statistics and engagement
    And I should be able to track article collaboration
    And changes should be published to relays

  Scenario: Wiki article collaboration tracking
    Given I am viewing a user's profile
    When I look at their wiki articles
    Then I should see articles they have created
    And I should see articles they have collaborated on
    And I should see articles they have forked
    And I should see articles they have contributed to
    And I should see their collaboration history
    And I should see their reputation as a wiki author
    And I should see their trusted status in the wiki community

  Scenario: Wiki article discovery through profiles
    Given I am browsing user profiles
    When I discover wiki articles through profiles
    Then I should be able to find wiki articles by author
    And I should be able to see popular wiki articles
    And I should be able to discover trusted wiki authors
    And I should be able to explore wiki article networks
    And I should be able to find related wiki articles
    And I should be able to see wiki collaboration patterns
    And I should be able to discover new wiki topics

  Scenario: Wiki article quality indicators on profile
    Given I am viewing a user's wiki articles on their profile
    When I assess the quality of their wiki contributions
    Then I should see article reaction counts and types
    And I should see author reputation and trust indicators
    And I should see article version history and stability
    And I should see collaboration patterns and attribution
    And I should see article completeness and accuracy indicators
    And I should see community feedback and recommendations
    And I should see article moderation status

  Scenario: Wiki article sharing from profile
    Given I am viewing a user's wiki articles on their profile
    When I want to share their wiki articles
    Then I should be able to share individual wiki articles
    And I should be able to share the user's wiki contributions
    And I should be able to recommend the user as a wiki author
    And I should be able to share wiki article collections
    And I should be able to discuss wiki articles with other users
    And I should be able to create content about their wiki work
    And sharing should respect privacy settings

  Scenario: Wiki article analytics on profile
    Given I am viewing a user's wiki articles on their profile
    When I analyze their wiki contributions
    Then I should see their wiki article statistics
    And I should see their collaboration patterns
    And I should see their article quality metrics
    And I should see their community engagement
    And I should see their wiki growth trends
    And I should see their trusted author status
    And the analytics should be privacy-respecting

  Scenario: Wiki article synchronization on profile
    Given I am viewing a user's wiki articles on their profile
    When wiki data updates
    Then I should see new wiki articles appear
    And I should see updated article statistics
    And I should see new collaboration activity
    And I should see updated quality indicators
    And I should see new community feedback
    And the synchronization should be efficient and reliable
    And I should be notified of significant wiki updates

  Scenario: Wiki article privacy and security on profile
    Given I am viewing wiki articles on profiles
    When I consider wiki privacy and security
    Then wiki article information should respect user privacy settings
    And wiki article content should be properly authenticated
    And wiki article collaboration should be verified
    And wiki article author information should be secure
    And wiki article data should be protected from tampering
    And wiki article sharing should respect privacy preferences
    And the security should meet standard requirements

  Scenario: Wiki article performance on profile
    Given I am viewing wiki articles on profiles
    When I interact with wiki article data
    Then wiki article lists should load efficiently
    And wiki article metadata should be properly cached
    And wiki article navigation should be optimized
    And wiki article rendering should be smooth
    And wiki article search should be fast
    And wiki article synchronization should be efficient
    And the performance should not impact profile loading

  # NIP-23 Long-form Content Profile Scenarios

  Scenario: Display user's long-form articles on profile
    Given I am viewing a profile page
    When I access the long-form articles section
    Then I should see the user's long-form articles (kind 30023)
    And the articles should be organized by topic
    And I should see article titles and summaries
    And I should see article timestamps
    And I should see article metadata
    And I should be able to access the full long-form articles
    And I should see article statistics

  Scenario: Long-form article creation from profile (NIP-23 kind 30023)
    Given I am logged in and viewing my own profile
    When I create a new long-form article from my profile
    Then the app should create a kind 30023 addressable event
    And the event should include a 'd' tag with article identifier
    And the event should include a 'title' tag for article title
    And the event should include a 'summary' tag for article summary
    And the event should include an 'image' tag for article image
    And the event should include a 'published_at' tag for first publication
    And the content should be in Markdown format
    And the event should be properly signed and published
    And the article should appear in my profile's articles section

  Scenario: Long-form article management from profile
    Given I am logged in and viewing my own profile
    When I manage my long-form articles
    Then I should be able to see all my long-form articles
    And I should be able to edit my long-form articles
    And I should be able to delete my long-form articles
    And I should be able to organize my long-form articles
    And I should be able to see article statistics and engagement
    And I should be able to track article collaboration
    And changes should be published to relays

  Scenario: Long-form article drafts management (NIP-23 kind 30024)
    Given I am logged in and viewing my own profile
    When I manage my article drafts
    Then I should be able to see all my article drafts (kind 30024)
    And I should be able to create new article drafts
    And I should be able to edit existing article drafts
    And I should be able to publish drafts as articles (kind 30023)
    And I should be able to delete article drafts
    And I should be able to organize article drafts
    And drafts should be properly saved and synced

  Scenario: Long-form article collaboration tracking
    Given I am viewing a user's profile
    When I look at their long-form articles
    Then I should see articles they have created
    And I should see articles they have collaborated on
    And I should see articles they have referenced
    And I should see articles they have contributed to
    And I should see their collaboration history
    And I should see their reputation as a long-form author
    And I should see their trusted status in the article community

  Scenario: Long-form article discovery through profiles
    Given I am browsing user profiles
    When I discover long-form articles through profiles
    Then I should be able to find long-form articles by author
    And I should be able to see popular long-form articles
    And I should be able to discover trusted long-form authors
    And I should be able to explore long-form article networks
    And I should be able to find related long-form articles
    And I should be able to see long-form collaboration patterns
    And I should be able to discover new long-form topics

  Scenario: Long-form article quality indicators on profile
    Given I am viewing a user's long-form articles on their profile
    When I assess the quality of their long-form contributions
    Then I should see article reaction counts and types
    And I should see author reputation and trust indicators
    And I should see article version history and stability
    And I should see collaboration patterns and attribution
    And I should see article completeness and accuracy indicators
    And I should see community feedback and recommendations
    And I should see article moderation status

  Scenario: Long-form article sharing from profile
    Given I am viewing a user's long-form articles on their profile
    When I want to share their long-form articles
    Then I should be able to share individual long-form articles
    And I should be able to share the user's long-form contributions
    And I should be able to recommend the user as a long-form author
    And I should be able to share long-form article collections
    And I should be able to discuss long-form articles with other users
    And I should be able to create content about their long-form work
    And sharing should respect privacy settings

  Scenario: Long-form article analytics on profile
    Given I am viewing a user's long-form articles on their profile
    When I analyze their long-form contributions
    Then I should see their long-form article statistics
    And I should see their collaboration patterns
    And I should see their article quality metrics
    And I should see their community engagement
    And I should see their long-form growth trends
    And I should see their trusted author status
    And the analytics should be privacy-respecting

  Scenario: Long-form article synchronization on profile
    Given I am viewing a user's long-form articles on their profile
    When long-form data updates
    Then I should see new long-form articles appear
    And I should see updated article statistics
    And I should see new collaboration activity
    And I should see updated quality indicators
    And I should see new community feedback
    And the synchronization should be efficient and reliable
    And I should be notified of significant long-form updates

  Scenario: Long-form article privacy and security on profile
    Given I am viewing long-form articles on profiles
    When I consider long-form privacy and security
    Then long-form article information should respect user privacy settings
    And long-form article content should be properly authenticated
    And long-form article collaboration should be verified
    And long-form article author information should be secure
    And long-form article data should be protected from tampering
    And long-form article sharing should respect privacy preferences
    And the security should meet standard requirements

  Scenario: Long-form article performance on profile
    Given I am viewing long-form articles on profiles
    When I interact with long-form article data
    Then long-form article lists should load efficiently
    And long-form article metadata should be properly cached
    And long-form article navigation should be optimized
    And long-form article rendering should be smooth
    And long-form article search should be fast
    And long-form article synchronization should be efficient
    And the performance should not impact profile loading

  Scenario: Long-form article version management on profile
    Given I am viewing a user's long-form articles on their profile
    When I want to manage article versions
    Then I should be able to see article edit history
    And I should be able to see when articles were last updated
    And I should be able to see the original published dates
    And I should be able to see article changes over time
    And I should be able to compare different versions
    And I should see version metadata and attribution
    And I should be able to track article evolution

  Scenario: Long-form article references and links on profile
    Given I am viewing a user's long-form articles on their profile
    When I examine article references and links
    Then I should see nostr links properly tagged in events
    And I should see references to other Nostr content
    And I should see article cross-references and citations
    And I should be able to navigate to referenced content
    And I should see reference context and descriptions
    And the references should follow NIP-27 specifications
    And I should be able to explore article networks

  Scenario: Long-form article tags and topics on profile
    Given I am viewing a user's long-form articles on their profile
    When I examine article tags and topics
    Then I should see article tags from 't' tags
    And I should be able to browse articles by topic
    And I should be able to discover related articles
    And I should be able to see popular topics
    And I should be able to explore topic networks
    And I should be able to find articles by hashtags
    And I should be able to discover new topics

  Scenario: Long-form article engagement metrics on profile
    Given I am viewing a user's long-form articles on their profile
    When I examine article engagement
    Then I should see article reaction counts and types
    And I should see article comment counts and activity
    And I should see article bookmark counts
    And I should see article highlight counts
    And I should see article zap counts and amounts
    And I should see article share counts
    And I should see overall article engagement trends

  # NKBIP-01 Curated Publications Profile Scenarios

  Scenario: Display user's curated publications on profile
    Given I am viewing a profile page
    When I access the curated publications section
    Then I should see the user's publication indexes (kind 30040)
    And the publications should be organized by type
    And I should see publication titles and summaries
    And I should see publication metadata (author, version, type)
    And I should be able to access the full publications
    And I should see publication statistics
    And I should see publication collaboration information

  Scenario: Curated publication creation from profile (NKBIP-01 kind 30040)
    Given I am logged in and viewing my own profile
    When I create a new curated publication from my profile
    Then the app should create a kind 30040 addressable event
    And the event should include a 'd' tag with publication identifier
    And the event should include a 'title' tag for publication title
    And the event should include an 'author' tag for publication author
    And the event should include a 'type' tag for publication type
    And the event should include an 'auto-update' tag for update behavior
    And the event should include 'a' tags for section references
    And the content field should be empty
    And the event should be properly signed and published
    And the publication should appear in my profile's publications section

  Scenario: Publication section creation from profile (NKBIP-01 kind 30041)
    Given I am logged in and viewing my own profile
    When I create a new publication section from my profile
    Then the app should create a kind 30041 addressable event
    And the event should include a 'd' tag with section identifier
    And the event should include a 'title' tag for section title
    And the content should be in AsciiDoc format
    And the content should support wikilinks
    And the event should be properly signed and published
    And the section should be properly linked to publications

  Scenario: Curated publication management from profile
    Given I am logged in and viewing my own profile
    When I manage my curated publications
    Then I should be able to see all my publication indexes
    And I should be able to edit my publication indexes
    And I should be able to delete my publication indexes
    And I should be able to organize my publications
    And I should be able to see publication statistics and engagement
    And I should be able to track publication collaboration
    And changes should be published to relays

  Scenario: Publication section management from profile
    Given I am logged in and viewing my own profile
    When I manage my publication sections
    Then I should be able to see all my publication sections
    And I should be able to create new publication sections
    And I should be able to edit existing publication sections
    And I should be able to delete publication sections
    And I should be able to organize publication sections
    And I should be able to link sections to publications
    And sections should be properly saved and synced

  Scenario: Publication collaboration tracking
    Given I am viewing a user's profile
    When I look at their curated publications
    Then I should see publications they have created
    And I should see publications they have collaborated on
    And I should see publications they have contributed sections to
    And I should see publications they have referenced
    And I should see their collaboration history
    And I should see their reputation as a publication curator
    And I should see their trusted status in the publication community

  Scenario: Publication discovery through profiles
    Given I am browsing user profiles
    When I discover curated publications through profiles
    Then I should be able to find publications by curator
    And I should be able to see popular publications
    And I should be able to discover trusted publication curators
    And I should be able to explore publication networks
    And I should be able to find related publications
    And I should be able to see publication collaboration patterns
    And I should be able to discover new publication types

  Scenario: Publication quality indicators on profile
    Given I am viewing a user's curated publications on their profile
    When I assess the quality of their publication contributions
    Then I should see publication reaction counts and types
    And I should see curator reputation and trust indicators
    And I should see publication version history and stability
    And I should see collaboration patterns and attribution
    And I should see publication completeness and accuracy indicators
    And I should see community feedback and recommendations
    And I should see publication moderation status

  Scenario: Publication sharing from profile
    Given I am viewing a user's curated publications on their profile
    When I want to share their publications
    Then I should be able to share individual publications
    And I should be able to share the user's publication contributions
    And I should be able to recommend the user as a publication curator
    And I should be able to share publication collections
    And I should be able to discuss publications with other users
    And I should be able to create content about their publication work
    And sharing should respect privacy settings

  Scenario: Publication analytics on profile
    Given I am viewing a user's curated publications on their profile
    When I analyze their publication contributions
    Then I should see their publication statistics
    And I should see their collaboration patterns
    And I should see their publication quality metrics
    And I should see their community engagement
    And I should see their publication growth trends
    And I should see their trusted curator status
    And the analytics should be privacy-respecting

  Scenario: Publication synchronization on profile
    Given I am viewing a user's curated publications on their profile
    When publication data updates
    Then I should see new publications appear
    And I should see updated publication statistics
    And I should see new collaboration activity
    And I should see updated quality indicators
    And I should see new community feedback
    And the synchronization should be efficient and reliable
    And I should be notified of significant publication updates

  Scenario: Publication privacy and security on profile
    Given I am viewing curated publications on profiles
    When I consider publication privacy and security
    Then publication information should respect user privacy settings
    And publication content should be properly authenticated
    And publication collaboration should be verified
    And publication curator information should be secure
    And publication data should be protected from tampering
    And publication sharing should respect privacy preferences
    And the security should meet standard requirements

  Scenario: Publication performance on profile
    Given I am viewing curated publications on profiles
    When I interact with publication data
    Then publication lists should load efficiently
    And publication metadata should be properly cached
    And publication navigation should be optimized
    And publication rendering should be smooth
    And publication search should be fast
    And publication synchronization should be efficient
    And the performance should not impact profile loading

  Scenario: Publication version management on profile
    Given I am viewing a user's curated publications on their profile
    When I want to manage publication versions
    Then I should be able to see publication edit history
    And I should be able to see when publications were last updated
    And I should be able to see the original published dates
    And I should be able to see publication changes over time
    And I should be able to compare different versions
    And I should see version metadata and attribution
    And I should be able to track publication evolution

  Scenario: Publication auto-update management on profile
    Given I am viewing a user's curated publications on their profile
    When I examine publication auto-update settings
    Then I should see auto-update settings for each publication
    And I should be able to configure auto-update behavior
    And I should be able to choose update preferences
    And I should be able to see update history
    And I should be able to manage update notifications
    And I should be able to control update frequency
    And I should be able to track update changes

  Scenario: Publication derivative works on profile
    Given I am viewing a user's curated publications on their profile
    When I examine derivative publications
    Then I should see original author attributions
    And I should see original event references
    And I should see proper licensing information
    And I should be able to access original publications
    And I should see modification history
    And I should see relationship indicators
    And I should see proper attribution chains

  Scenario: Publication wikilinks and references on profile
    Given I am viewing a user's curated publications on their profile
    When I examine publication wikilinks and references
    Then I should see wikilinks properly tagged in events
    And I should see references to other Nostr content
    And I should see publication cross-references
    And I should be able to navigate to referenced content
    And I should see reference context and descriptions
    And I should be able to explore publication networks
    And I should see proper link relationships

  Scenario: Publication tags and topics on profile
    Given I am viewing a user's curated publications on their profile
    When I examine publication tags and topics
    Then I should see publication tags from 't' tags
    And I should be able to browse publications by topic
    And I should be able to discover related publications
    And I should be able to see popular topics
    And I should be able to explore topic networks
    And I should be able to find publications by hashtags
    And I should be able to discover new topics

  Scenario: Publication engagement metrics on profile
    Given I am viewing a user's curated publications on their profile
    When I examine publication engagement
    Then I should see publication reaction counts and types
    And I should see publication comment counts and activity
    And I should see publication bookmark counts
    And I should see publication highlight counts
    And I should see publication zap counts and amounts
    And I should see publication share counts
    And I should see overall publication engagement trends

  # NIP-7D Threads Profile Scenarios

  Scenario: Display user's threads on profile
    Given I am viewing a profile page
    When I access the threads section
    Then I should see the user's created threads (kind 11)
    And the threads should be organized by recent activity
    And I should see thread titles and summaries
    And I should see thread timestamps
    And I should see thread metadata
    And I should be able to access the full threads
    And I should see thread statistics

  Scenario: Thread creation from profile (NIP-7D kind 11)
    Given I am logged in and viewing my own profile
    When I create a new thread from my profile
    Then the app should create a kind 11 event
    And the event should include a 'title' tag for the thread title
    And the event should contain the thread content
    And the event should be properly signed and published
    And the thread should appear in my profile's threads section
    And the thread should be displayed with the title prominently

  Scenario: Thread management from profile
    Given I am logged in and viewing my own profile
    When I manage my threads
    Then I should be able to see all my created threads
    And I should be able to edit my threads
    And I should be able to delete my threads
    And I should be able to organize my threads
    And I should be able to see thread statistics and engagement
    And I should be able to track thread collaboration
    And changes should be published to relays

  Scenario: Thread reply tracking
    Given I am viewing a user's profile
    When I look at their thread activity
    Then I should see threads they have created
    And I should see threads they have replied to
    And I should see their thread reply history
    And I should see their reputation as a thread participant
    And I should see their trusted status in the thread community
    And I should see their thread collaboration patterns
    And I should see their thread moderation history

  Scenario: Thread discovery through profiles
    Given I am browsing user profiles
    When I discover threads through profiles
    Then I should be able to find threads by author
    And I should be able to see popular threads
    And I should be able to discover trusted thread authors
    And I should be able to explore thread networks
    And I should be able to find related threads
    And I should be able to see thread collaboration patterns
    And I should be able to discover new thread topics

  Scenario: Thread quality indicators on profile
    Given I am viewing a user's threads on their profile
    When I assess the quality of their thread contributions
    Then I should see thread reaction counts and types
    And I should see author reputation and trust indicators
    And I should see thread engagement metrics
    And I should see thread collaboration patterns and attribution
    And I should see thread completeness and accuracy indicators
    And I should see community feedback and recommendations
    And I should see thread moderation status

  Scenario: Thread sharing from profile
    Given I am viewing a user's threads on their profile
    When I want to share their threads
    Then I should be able to share individual threads
    And I should be able to share the user's thread contributions
    And I should be able to recommend the user as a thread author
    And I should be able to share thread collections
    And I should be able to discuss threads with other users
    And I should be able to create content about their thread work
    And sharing should respect privacy settings

  Scenario: Thread analytics on profile
    Given I am viewing a user's threads on their profile
    When I analyze their thread contributions
    Then I should see their thread statistics
    And I should see their collaboration patterns
    And I should see their thread quality metrics
    And I should see their community engagement
    And I should see their thread growth trends
    And I should see their trusted author status
    And the analytics should be privacy-respecting

  Scenario: Thread synchronization on profile
    Given I am viewing a user's threads on their profile
    When thread data updates
    Then I should see new threads appear
    And I should see updated thread statistics
    And I should see new thread collaboration activity
    And I should see updated quality indicators
    And I should see new community feedback
    And the synchronization should be efficient and reliable
    And I should be notified of significant thread updates

  Scenario: Thread privacy and security on profile
    Given I am viewing threads on profiles
    When I consider thread privacy and security
    Then thread information should respect user privacy settings
    And thread content should be properly authenticated
    And thread collaboration should be verified
    And thread author information should be secure
    And thread data should be protected from tampering
    And thread sharing should respect privacy preferences
    And the security should meet standard requirements

  Scenario: Thread performance on profile
    Given I am viewing threads on profiles
    When I interact with thread data
    Then thread lists should load efficiently
    And thread metadata should be properly cached
    And thread navigation should be optimized
    And thread rendering should be smooth
    And thread search should be fast
    And thread synchronization should be efficient
    And the performance should not impact profile loading

  Scenario: Thread version management on profile
    Given I am viewing a user's threads on their profile
    When I want to manage thread versions
    Then I should be able to see thread edit history
    And I should be able to see when threads were last updated
    And I should be able to see the original published dates
    And I should be able to see thread changes over time
    And I should be able to compare different versions
    And I should see version metadata and attribution
    And I should be able to track thread evolution

  Scenario: Thread references and links on profile
    Given I am viewing a user's threads on their profile
    When I examine thread references and links
    Then I should see nostr links properly tagged in events
    And I should see references to other Nostr content
    And I should see thread cross-references and citations
    And I should be able to navigate to referenced content
    And I should see reference context and descriptions
    And the references should follow NIP-27 specifications
    And I should be able to explore thread networks

  Scenario: Thread tags and topics on profile
    Given I am viewing a user's threads on their profile
    When I examine thread tags and topics
    Then I should see thread tags from 't' tags
    And I should be able to browse threads by topic
    And I should be able to discover related threads
    And I should be able to see popular topics
    And I should be able to explore topic networks
    And I should be able to find threads by hashtags
    And I should be able to discover new topics

  Scenario: Thread engagement metrics on profile
    Given I am viewing a user's threads on their profile
    When I examine thread engagement
    Then I should see thread reaction counts and types
    And I should see thread reply counts and activity
    And I should see thread bookmark counts
    And I should see thread highlight counts
    And I should see thread zap counts and amounts
    And I should see thread share counts
    And I should see overall thread engagement trends

  Scenario: Thread notifications on profile
    Given I am viewing my profile
    When I access thread notifications
    Then I should see notifications for new replies to my threads
    And I should see notifications for mentions in threads
    And I should see notifications for thread interactions
    And I should be able to access threads from notifications
    And I should see notification settings for threads
    And I should be able to manage thread notification preferences
    And I should see thread notification history 