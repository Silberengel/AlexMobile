Feature: Zapping
  As a user
  I want to send lightning payments to authors and creators
  So that I can support content creators and engage with their work

  Background:
    Given I am viewing a publication in the reader screen
    And the publication has zapping capabilities
    And I have lightning wallet integration available

  Scenario: Zapping header card display
    Given I am viewing a publication
    When I look at the metadata card at the top
    Then I should see a lightning icon outline with a counter
    And the lightning icon should match the style of other counters
    And the counter should show the total number of zaps received
    And the lightning icon should be clearly visible and accessible

  Scenario: Zapping header card interaction
    Given I am viewing the zapping header card
    When I tap the lightning icon
    Then I should see a zapping interface
    And the interface should show a QR code
    And the interface should show copyable lightning text
    And I should be able to edit a comment for the zap
    And I should be able to include emojis in the comment

  Scenario: QR code generation
    Given I am in the zapping interface
    When I view the QR code
    Then the QR code should contain the lightning invoice
    And the QR code should be clearly visible and scannable
    And the QR code should be properly sized for mobile wallets
    And the QR code should include the zap amount and comment

  Scenario: Lightning text copying
    Given I am in the zapping interface
    When I view the lightning text
    Then the lightning text should be copyable
    And the lightning text should be the complete lightning invoice
    And the text should be clearly formatted and readable
    And I should be able to copy it to my clipboard easily

  Scenario: Zap comment editing
    Given I am in the zapping interface
    When I edit the zap comment
    Then I should be able to type my comment
    And I should be able to include emojis in the comment
    And the comment should have character limits if applicable
    And the comment should be included in the lightning invoice
    And the comment should be displayed when the zap is received

  Scenario: Emoji support in zap comments
    Given I am editing a zap comment
    When I want to add emojis
    Then I should have access to an emoji picker
    And I should be able to select emojis from the picker
    And the emojis should be properly displayed in the comment
    And the emojis should be included in the lightning invoice
    And the emojis should be displayed when the zap is received

  Scenario: Lightning wallet integration
    Given I have a lightning wallet installed
    When I scan the QR code or copy the lightning text
    Then my lightning wallet should open automatically
    And the lightning wallet should recognize the invoice
    And the lightning wallet should show the zap amount
    And the lightning wallet should show the zap comment
    And I should be able to confirm and send the zap

  Scenario: Zap amount configuration
    Given I am in the zapping interface
    When I view the zap settings
    Then I should see the minimum zap amount (default 20 sats)
    And I should be able to change the minimum zap amount
    And the minimum zap amount should be stored in settings
    And the minimum zap amount should be near relay settings
    And the setting should persist across app sessions

  Scenario: High-value zap display (over 20 sats)
    Given I am viewing the interactions display
    When there are zaps over the minimum threshold
    Then the high-value zaps should be displayed at the top
    And the high-value zaps should appear as if they were replies
    And the high-value zaps should have a prominent lightning icon
    And the zap comments should be displayed clearly
    And everyone should know they were zaps due to the lightning icon

  Scenario: Zap-comment threading
    Given I am viewing high-value zaps
    When I look at the zap-comments
    Then they should be threaded like regular comments
    And they should appear at the very top of the interactions
    And they should have a prominent lightning icon
    And the zap amount should be clearly displayed
    And the zap comment should be displayed like a regular comment

  Scenario: Low-value zap display (under 20 sats)
    Given I am viewing the interactions display
    When there are zaps under the minimum threshold
    Then the low-value zaps should be listed in a dropdown
    And the dropdown should be accessible from the zap counter
    And the dropdown should show who sent the zap
    And the dropdown should show how much the zap was
    And the dropdown should be analogous to emoji reactions

  Scenario: Zap counter dropdown
    Given I am viewing the zap counter
    When I tap on the zap counter
    Then I should see a dropdown with all zaps
    And the dropdown should show zap sender information
    And the dropdown should show zap amounts
    And the dropdown should be organized by zap amount
    And the dropdown should be easy to navigate

  Scenario: Zap sender information
    Given I am viewing zap information
    When I look at zap sender details
    Then I should see the sender's public key or name
    And I should see the zap amount clearly
    And I should see the zap timestamp
    And I should see the zap comment if provided
    And the information should be clearly formatted

  Scenario: Zap amount thresholds
    Given I am viewing zap settings
    When I configure zap thresholds
    Then I should be able to set the minimum threshold (default 20 sats)
    And the threshold should determine display behavior
    And zaps above the threshold should appear as comments
    And zaps below the threshold should appear in dropdown
    And the threshold should encourage higher-value zaps

  Scenario: Zap encouragement system
    Given I am viewing the interactions display
    When I see the zap system design
    Then the system should encourage zap-comments over regular comments
    Then the system should encourage zap-comments over highlights
    Then the system should encourage zap-comments over replies
    And the prominent lightning icons should make zaps stand out
    And the authors should receive more money from zaps

  Scenario: Zap statistics display
    Given I am viewing zap statistics
    When I look at the zap data
    Then I should see total zap amount received
    And I should see number of zaps received
    And I should see average zap amount
    And I should see zap trends over time
    And the statistics should help authors understand their earnings

  Scenario: Zap notification system
    Given I am an author receiving zaps
    When I receive a zap
    Then I should receive a notification
    And the notification should show the zap amount
    And the notification should show the zap comment
    And the notification should show the sender information
    And the notification should be timely and relevant

  Scenario: Zap privacy and security
    Given I am sending or receiving zaps
    When zaps are processed
    Then the lightning invoices should be properly signed
    And the zap amounts should be secure and private
    And the zap comments should be properly encrypted
    And the zap sender information should be handled securely
    And the app should respect privacy settings

  Scenario: Zap error handling
    Given I am attempting to send a zap
    When the zap fails
    Then the app should handle the error gracefully
    And I should see an appropriate error message
    And the app should provide retry options
    And the app should not lose my zap comment
    And the app should help troubleshoot lightning issues

  Scenario: Zap network connectivity
    Given I am sending a zap
    When there are network connectivity issues
    Then the app should handle offline scenarios
    And the zap should be queued for when connectivity returns
    And the app should provide clear status information
    And the app should retry when connectivity is restored
    And the app should not lose zap data

  Scenario: Zap wallet compatibility
    Given I am using different lightning wallets
    When I send zaps from different wallets
    Then the app should be compatible with major lightning wallets
    And the QR codes should be readable by all wallets
    And the lightning text should be compatible with all wallets
    And the app should handle different wallet responses
    And the app should provide wallet-specific guidance

  Scenario: Zap comment moderation
    Given I am viewing zap comments
    When I see inappropriate zap comments
    Then I should be able to report problematic zap comments
    And the app should provide moderation tools for zaps
    And the app should handle zap comment moderation appropriately
    And the app should maintain a safe environment for zaps
    And the app should respect community guidelines

  Scenario: Zap analytics for authors
    Given I am an author receiving zaps
    When I view my zap analytics
    Then I should see detailed zap statistics
    And I should see which content receives the most zaps
    And I should see zap trends and patterns
    And I should see my total earnings from zaps
    And the analytics should help me understand my audience

  Scenario: Zap integration with existing interactions
    Given I am viewing all interactions
    When I see zaps alongside other interactions
    Then zaps should integrate seamlessly with comments and highlights
    And zaps should be properly threaded with other interactions
    And zaps should respect the existing interaction hierarchy
    And zaps should enhance rather than disrupt the interaction flow
    And zaps should encourage more meaningful engagement

  # NIP-57 Specific Scenarios

  Scenario: LNURL pay endpoint integration
    Given I am viewing a publication with zapping capabilities
    When I initiate a zap
    Then the app should fetch the recipient's LNURL pay endpoint
    And the app should check if the endpoint supports nostr (allowsNostr: true)
    And the app should validate the nostrPubkey from the endpoint
    And the app should use the callback URL for zap requests
    And the app should respect minSendable and maxSendable limits

  Scenario: Zap request event creation (NIP-57 kind 9734)
    Given I am sending a zap
    When I create a zap request
    Then the app should create a kind 9734 event
    And the event should include the required tags (relays, amount, p)
    And the event should include optional tags (e, a, lnurl) if applicable
    And the event should be properly signed with my nostr key
    And the event should not be published to relays but sent to LNURL callback

  Scenario: Zap request validation
    Given I am receiving a zap request
    When the LNURL server validates the request
    Then the request should have a valid nostr signature
    And the request should have exactly one 'p' tag
    And the request should have 0 or 1 'e' tags
    And the request should have a 'relays' tag
    And the amount tag should match the query parameter
    And the request should be stored for later processing

  Scenario: Zap receipt event creation (NIP-57 kind 9735)
    Given a zap request has been paid
    When the lightning node processes the payment
    Then the LNURL server should create a kind 9735 zap receipt
    And the receipt should include the original zap request in description tag
    And the receipt should include the bolt11 invoice in bolt11 tag
    And the receipt should include the preimage tag
    And the receipt should be published to the relays specified in the request

  Scenario: Zap receipt validation
    Given I am viewing zap receipts
    When I validate a zap receipt
    Then the receipt pubkey should match the LNURL provider's nostrPubkey
    And the invoice amount should match the original zap request amount
    And the lnurl tag should match the recipient's lnurl
    And the description hash should match the bolt11 invoice
    And the receipt should be properly signed

  Scenario: Zap tag support for split payments
    Given I am viewing a publication with zap tags
    When I see multiple zap tags in the event
    Then I should parse all zap tags with their weights
    And I should calculate the percentage for each recipient
    And I should create separate zap requests for each recipient
    And I should split the zap amount according to the weights
    And I should display the split configuration to the user

  Scenario: Zap tag weight calculation
    Given I am processing zap tags with weights
    When I calculate the split percentages
    Then receivers without weights should not receive zaps
    Then receivers with weights should receive proportional amounts
    And the total should equal 100% of the zap amount
    And the split should be clearly displayed to the user

  Scenario: Zap request HTTP flow
    Given I am sending a zap request
    When I send the request to the LNURL callback
    Then I should use a GET request with proper query parameters
    And the parameters should include amount, nostr, and lnurl
    And the nostr parameter should be URI-encoded JSON
    And the response should contain a 'pr' key with the invoice
    And the invoice should be a valid bolt11 invoice

  Scenario: Zap receipt display
    Given I am viewing zap receipts
    When I display zap information
    Then I should show "zap authorized by [sender]" information
    And I should display the zap request content as the comment
    And I should show the zap amount clearly
    And I should show the zap timestamp
    And I should validate the receipt before displaying

  Scenario: Zap request content handling
    Given I am creating a zap request
    When I include content in the zap request
    Then the content should be optional and may be empty
    And the content should be included in the zap receipt description
    And the content should be displayed when the zap is received
    And the content should support emojis and formatting

  Scenario: Zap relay management
    Given I am sending a zap request
    When I specify relays for the zap receipt
    Then I should include multiple relay URLs in the relays tag
    And the relays should not be nested in additional lists
    And the LNURL server should publish receipts to all specified relays
    And the app should fetch receipts from the same relays

  Scenario: Zap event coordinate support
    Given I am zapping an addressable event
    When I include an 'a' tag in the zap request
    Then the 'a' tag should be a valid event coordinate
    And the coordinate should specify the target event
    And the zap receipt should include the same 'a' tag
    And the zap should be associated with the specific event

  Scenario: Zap sender identification
    Given I am viewing zap receipts
    When I see the 'P' tag in zap receipts
    Then the 'P' tag should contain the zap sender's pubkey
    And the 'P' tag should match the zap request pubkey
    And the sender information should be displayed clearly
    And the sender should be properly identified in the UI 