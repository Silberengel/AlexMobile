Feature: User Interactions
  As a user
  I want to interact with content and other users
  So that I can engage with the community and express my thoughts

  Background:
    Given I am authenticated with a nostr key
    And the app supports user interaction functionality
    And I have access to various content types

  Scenario: Reaction and comment display
    Given I am viewing a publication
    When I look at the interaction counters
    Then I should see reaction counts (zaps, likes, etc.)
    And I should see comment counts
    And I should see share counts
    And I should see reading time estimates
    And the counters should update in real-time

  Scenario: Adding reactions
    Given I am viewing a publication
    When I add a reaction
    Then I should be able to like the publication
    And I should be able to zap the publication
    And I should be able to use custom reaction emojis
    And the reaction should be published as a kind 7 event
    And the reaction counter should update immediately

  Scenario: Adding comments
    Given I am viewing a publication
    When I add a comment
    Then I should be able to write a comment
    And I should be able to submit the comment
    And the comment should be published as a kind 1 event
    And the comment should reference the original publication
    And the comment counter should update immediately

  Scenario: Highlighting content
    Given I am reading a publication
    When I highlight text
    Then I should be able to select text to highlight
    And I should be able to add notes to highlights
    And the highlights should be saved locally
    And the highlights should be published as kind 9802 events
    And I should be able to view my highlights later

  Scenario: Zapping content
    Given I am viewing a publication
    When I zap the publication
    Then I should be able to specify a zap amount
    And I should be able to add a zap comment
    And the zap should be published as a kind 9735 event
    And the zap should include proper metadata
    And the zap counter should update immediately

  Scenario: Threading and replies
    Given I am viewing a discussion
    When I participate in the discussion
    Then I should be able to reply to comments
    And I should be able to create threaded discussions
    And I should be able to follow discussion threads
    And I should be able to view discussion hierarchies

  Scenario: Privacy and moderation
    Given I am interacting with content
    When I manage privacy and moderation
    Then I should be able to set interaction privacy
    And I should be able to report inappropriate content
    And I should be able to block users
    And I should be able to mute discussions
    And I should be able to manage my interaction history

  Scenario: Search and discovery
    Given I am looking for content
    When I search for interactions
    Then I should be able to search my interactions
    And I should be able to search others' interactions
    And I should be able to filter by interaction type
    And I should be able to discover trending interactions

  Scenario: Interaction notifications
    Given I have interacted with content
    When I receive interaction notifications
    Then I should be notified of reactions to my content
    And I should be notified of comments on my content
    And I should be notified of zaps on my content
    And I should be able to manage notification preferences

  Scenario: Interaction history
    Given I have interacted with content
    When I view my interaction history
    Then I should see a history of my reactions
    And I should see a history of my comments
    And I should see a history of my zaps
    And I should be able to filter my interaction history

  Scenario: Interaction analytics
    Given I have interacted with content
    When I view interaction analytics
    Then I should see my interaction statistics
    And I should see content engagement metrics
    And I should see community interaction trends
    And I should be able to export interaction data

  Scenario: Discussions feed access
    Given I am viewing the app
    When I access the Discussions feature
    Then I should be able to click the profile icon in the top-right
    And I should see a "Discussions" option in the profile menu
    When I click "Discussions"
    Then I should be taken to the kind 11 bulletin-board style feed
    And I should see discussion threads
    And I should be able to participate in discussions
    And I should be able to create new discussion threads