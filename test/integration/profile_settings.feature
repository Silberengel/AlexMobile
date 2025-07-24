Feature: Profile Settings
  As a user
  I want to manage my profile and app settings
  So that I can customize my experience and control my data

  Background:
    Given I am authenticated with a nostr key
    And the app supports profile and settings functionality
    And I have access to various configuration options

  Scenario: Notifications display
    Given I am viewing a profile page
    When I look at the Notifications tab
    Then I should see all notifications that the npub has received
    And the newest notifications should be higher-up on the list
  
  Scenario: Reading progress display
    Given I am viewing the profile page of the logged-in npub (if there is one)
    When I look at the Currently Reading tab
    Then I should see progress bars with links to whatever I have been reading
    And the links should go to the last place read
    And the newest entries should be higher-up on the list
  
  Scenario: Profile metadata display
    Given I am viewing a profile page
    When I look at the profile metadata
    Then I should see the user's display name
    And I should see the user's avatar/picture
    And I should see the user's about/bio information
    And I should see the user's website link
    And I should see the user's public key (npub)
    And I should see when the profile was last updated

  Scenario: Profile settings access
    Given I am logged in and viewing my own profile
    When I access the settings section
    Then I should see a settings button or tab
    And I should be able to access authentication preferences
    And I should be able to access relay preferences
    And I should be able to access notification preferences
    And I should be able to access theme preferences

  Scenario: Authentication status display
    Given I am in the profile settings
    When I access authentication settings
    Then I should see my current authentication status
    And I should be able to view my public key
    And I should be able to log out
    And I should be able to manage my keys

  Scenario: Authentication method selection
    Given I am in the authentication settings
    When I choose an authentication method
    Then I should be able to use Amber login
    And I should be able to use npub-only login
    And I should be able to use nsec login with encrypted local storage
    And the selected method should be properly configured

  Scenario: Basic relay connection display
    Given I am in the profile settings
    When I access relay preferences
    Then I should see my current relay connections
    And I should see the connection status for each relay
    And I should be able to test relay connections
    And I should be able to view basic relay health data

  Scenario: Notification preferences
    Given I am in the profile settings
    When I access notification preferences
    Then I should be able to enable/disable notifications
    And I should be able to configure notification types
    And I should be able to set notification frequency
    And I should be able to configure notification sounds
    And I should be able to manage notification privacy
    And I should be able to set certain events and npubs to "quiet" mode, to stop receiving notifications from them
    And I should be able to set a custom zap-comment minimum threshold (0 to 21000, default 21 sats)
    And I should be able to choose to turn off zap-comments, entirely

  Scenario: Theme preferences
    Given I am in the profile settings
    When I access theme preferences
    Then I should be able to choose between light and dark themes
    And I should be able to enable auto theme switching
    And I should be able to customize accent colors
    And I should be able to adjust font sizes
    And I should be able to customize reading preferences

  Scenario: Data export
    Given I am in the profile settings
    When I access data management
    Then I should be able to export my events as jsonl
    And I should be able to select which events to export
    And I should be able to choose export format
    And the export should include all event metadata
    And exporting a kind 30040 should also export all of its indexed-content events

  Scenario: Data backup and sync
    Given I am in the data management section
    When I perform backup operations
    Then I should be able to force-sync with local relays
    And I should be able to force-sync with remote relays
    And I should be able to sync data across devices with bluetooth, if the other device has the Alex Reader app
    And I should see backup progress indicators
    And syncing should ensure that 30040s always come along with their indexed-content

  Scenario: Cache and storage management
    Given I am in the data management section
    When I manage storage
    Then I should be able to clear cached data
    And I should be able to view storage usage
    And I should be able to manage storage quotas
    And I should see storage usage statistics

  Scenario: Profile editing
    Given I am viewing my own profile
    When I want to edit my profile
    Then I should be able to update my display name
    And I should be able to update my avatar
    And I should be able to update my bio
    And I should be able to update my website
    And the changes should be published as kind 0 events

  Scenario: Profile privacy settings
    Given I am in the profile settings
    When I access privacy settings
    Then I should be able to control profile visibility
    And I should be able to manage data sharing preferences
    And I should be able to control what information is public
    And I should be able to manage my mute lists

  Scenario: Reading progress management
    Given I am viewing my reading progress
    When I manage reading progress
    Then I should be able to clear reading progress for specific items
    And I should be able to reset reading progress for all items
    And I should be able to export reading progress data
    And I should be able to import reading progress from other devices

  Scenario: App performance settings
    Given I am in the profile settings
    When I access performance settings
    Then I should be able to configure cache size limits
    And I should be able to set data retention policies
    And I should be able to configure background sync frequency
    And I should be able to manage memory usage

  Scenario: Security settings
    Given I am in the profile settings
    When I access security settings
    Then I should be able to configure encryption settings
    And I should be able to manage key storage
    And I should be able to set app lock preferences
    And I should be able to configure backup encryption

  Scenario: Accessibility settings
    Given I am in the profile settings
    When I access accessibility settings
    Then I should be able to adjust text size
    And I should be able to enable high contrast mode
    And I should be able to configure screen reader support
    And I should be able to adjust touch sensitivity

  Scenario: Language and region settings
    Given I am in the profile settings
    When I access language settings
    Then I should be able to change the app language
    And I should be able to set date and time formats
    And I should be able to configure currency display
    And I should be able to set regional preferences