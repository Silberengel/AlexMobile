Feature: Authentication
  As a user
  I want to authenticate with the Nostr network
  So that I can access personalized content and features

  Background:
    Given I am on the home screen
    And the app is running

  Scenario: Authentication status display
    Given I am not authenticated
    When I look at the app bar
    Then I should see a login icon
    And the icon should be clearly visible
    And the icon should indicate unauthenticated state
    When I become authenticated
    Then I should see a person icon
    And the icon should indicate authenticated state

  Scenario: Login functionality
    Given I am not authenticated
    When I tap the authentication icon
    Then the app should attempt to log me in
    And the authentication process should be initiated
    And the app should show a loading state during login
    When the login is successful
    Then I should see the person icon
    And my authentication status should be updated
    And the app should remember my authentication state

  Scenario: Logout functionality
    Given I am authenticated
    When I tap the authentication icon
    Then the app should log me out
    And the authentication process should be completed
    And I should see the login icon
    And my authentication status should be updated
    And the app should clear my authentication state

  Scenario: Authentication state persistence
    Given I have successfully logged in
    When I close the app
    And I reopen the app
    Then I should still be authenticated
    And I should see the person icon
    And my authentication state should be preserved

  Scenario: Authentication error handling
    Given I attempt to log in
    When the authentication fails
    Then the app should handle the error gracefully
    And I should remain unauthenticated
    And I should see the login icon
    And the app should continue to function normally

  Scenario: Authentication during app initialization
    Given the app is starting up
    When the app checks authentication status
    Then the app should determine if I am authenticated
    And the app should display the appropriate icon
    And the authentication state should be consistent

  Scenario: Authentication with network connectivity
    Given I have no internet connectivity
    When I attempt to authenticate
    Then the app should handle the network error
    And I should remain unauthenticated
    And the app should show appropriate error feedback
    When I regain internet connectivity
    Then I should be able to authenticate successfully

  Scenario: Authentication state changes
    Given I am authenticated
    When my authentication expires
    Then the app should detect the expired authentication
    And I should be automatically logged out
    And I should see the login icon
    And the app should prompt me to log in again

  Scenario: Authentication with local relay
    Given I am connected to a local relay
    When I attempt to authenticate
    Then the authentication should work with the local relay
    And my authentication should be valid for local content
    And I should be able to access local publications

  Scenario: Authentication UI feedback
    Given I am in the authentication process
    When the authentication is in progress
    Then I should see a loading indicator
    And the loading indicator should be visible
    And the loading indicator should show progress
    When the authentication completes
    Then the loading indicator should disappear
    And the appropriate authentication icon should be shown

  Scenario: Authentication with multiple relays
    Given I am connected to multiple relays
    When I authenticate
    Then my authentication should be valid across all relays
    And I should be able to access content from all relays
    And my authentication state should be synchronized

  Scenario: Authentication state management
    Given the app is managing authentication state
    When the authentication state changes
    Then the app should update the UI accordingly
    And the app should notify relevant components
    And the app should maintain consistency across screens
    And the app should handle state transitions smoothly

  Scenario: Authentication with offline mode
    Given I am offline
    When I attempt to authenticate
    Then the app should handle the offline state
    And I should remain unauthenticated
    And the app should indicate that authentication requires connectivity
    When I come back online
    Then I should be able to authenticate successfully

  Scenario: Authentication icon interaction
    Given I am on the home screen
    When I tap the authentication icon
    Then the icon should respond to the tap
    And the tap should trigger the appropriate action
    And the icon should provide visual feedback
    And the action should be executed promptly

  Scenario: Authentication state synchronization
    Given I am authenticated on multiple devices
    When my authentication state changes on one device
    Then the change should be reflected across all devices
    And the authentication should remain consistent
    And the app should handle synchronization gracefully

  Scenario: Authentication with demo data
    Given I am using the app with demo data
    When I authenticate
    Then the authentication should work normally
    And I should have access to both demo and authenticated content
    And the app should distinguish between demo and real content

  Scenario: Authentication error recovery
    Given I encounter an authentication error
    When I retry the authentication
    Then the app should attempt to authenticate again
    And the app should handle the retry gracefully
    And the app should provide appropriate feedback
    And the app should not get stuck in an error state

  # NIP-46 Nostr Remote Signing Scenarios

  Scenario: Remote signer connection initiation (NIP-46)
    Given I want to connect to a remote signer
    When I initiate a remote signer connection
    Then the app should generate a client keypair
    And the app should create a connection request (kind 24133)
    And the app should encrypt the request using NIP-44
    And the app should p-tag the remote signer pubkey
    And the app should send the request to the specified relays
    And the app should wait for a connection response

  Scenario: Remote signer connection response handling (NIP-46)
    Given I have sent a connection request to a remote signer
    When I receive a connection response
    Then the app should decrypt the response using NIP-44
    And the app should validate the response format
    And the app should extract the remote signer pubkey
    And the app should verify the response signature
    And the app should establish the connection if successful
    And the app should handle connection errors appropriately

  Scenario: Remote signer public key retrieval (NIP-46)
    Given I am connected to a remote signer
    When I request the user public key
    Then the app should send a 'get_public_key' request
    And the app should encrypt the request using NIP-44
    And the app should wait for the public key response
    And the app should extract and store the user pubkey
    And the app should differentiate between client and user pubkeys
    And the app should use the user pubkey for event signing

  Scenario: Remote event signing (NIP-46)
    Given I am connected to a remote signer
    When I want to sign an event
    Then the app should create a 'sign_event' request
    And the app should include the event data in the request
    And the app should encrypt the request using NIP-44
    And the app should send the request to the remote signer
    And the app should wait for the signed event response
    And the app should extract the signed event from the response
    And the app should verify the event signature
    And the app should publish the signed event to relays

  Scenario: Remote signer ping functionality (NIP-46)
    Given I am connected to a remote signer
    When I want to check the connection status
    Then the app should send a 'ping' request
    And the app should encrypt the request using NIP-44
    And the app should wait for a 'pong' response
    And the app should handle the ping response appropriately
    And the app should use ping to maintain connection health
    And the app should detect connection issues through ping failures

  Scenario: Remote signer NIP-04 encryption (NIP-46)
    Given I am connected to a remote signer
    When I want to encrypt content using NIP-04
    Then the app should send a 'nip04_encrypt' request
    And the app should include the target pubkey and plaintext
    And the app should encrypt the request using NIP-44
    And the app should wait for the NIP-04 ciphertext response
    And the app should extract and use the encrypted content
    And the app should handle encryption errors appropriately

  Scenario: Remote signer NIP-04 decryption (NIP-46)
    Given I am connected to a remote signer
    When I want to decrypt NIP-04 content
    Then the app should send a 'nip04_decrypt' request
    And the app should include the sender pubkey and ciphertext
    And the app should encrypt the request using NIP-44
    And the app should wait for the decrypted plaintext response
    And the app should extract and use the decrypted content
    And the app should handle decryption errors appropriately

  Scenario: Remote signer NIP-44 encryption (NIP-46)
    Given I am connected to a remote signer
    When I want to encrypt content using NIP-44
    Then the app should send a 'nip44_encrypt' request
    And the app should include the target pubkey and plaintext
    And the app should encrypt the request using NIP-44
    And the app should wait for the NIP-44 ciphertext response
    And the app should extract and use the encrypted content
    And the app should handle encryption errors appropriately

  Scenario: Remote signer NIP-44 decryption (NIP-46)
    Given I am connected to a remote signer
    When I want to decrypt NIP-44 content
    Then the app should send a 'nip44_decrypt' request
    And the app should include the sender pubkey and ciphertext
    And the app should encrypt the request using NIP-44
    And the app should wait for the decrypted plaintext response
    And the app should extract and use the decrypted content
    And the app should handle decryption errors appropriately

  Scenario: Remote signer connection with bunker URL (NIP-46)
    Given I have a bunker connection URL
    When I initiate a connection using the bunker URL
    Then the app should parse the bunker URL format
    And the app should extract the remote signer pubkey
    And the app should extract the relay URLs
    And the app should extract the optional secret
    And the app should send a 'connect' request with the secret
    And the app should validate the connection response
    And the app should establish the connection if successful

  Scenario: Remote signer connection with nostrconnect URL (NIP-46)
    Given I have a nostrconnect URL
    When I initiate a connection using the nostrconnect URL
    Then the app should parse the nostrconnect URL format
    And the app should extract the client pubkey
    And the app should extract the relay URLs
    And the app should extract the required secret
    And the app should extract optional permissions and metadata
    And the app should send a 'connect' request with the secret
    And the app should validate the connection response
    And the app should establish the connection if successful

  Scenario: Remote signer permissions management (NIP-46)
    Given I am connecting to a remote signer
    When I specify requested permissions
    Then the app should include permissions in the connect request
    And the app should format permissions as comma-separated list
    And the app should support method-specific permissions
    And the app should support kind-specific signing permissions
    And the app should respect permission restrictions
    And the app should handle permission denials appropriately

  Scenario: Remote signer auth challenges (NIP-46)
    Given I am connected to a remote signer
    When the remote signer requires authentication
    Then the app should receive an auth challenge response
    And the app should extract the auth URL from the error field
    And the app should display the auth URL to the user
    And the app should wait for authentication completion
    And the app should handle the post-auth response
    And the app should continue with the original request

  Scenario: Remote signer discovery via NIP-05 (NIP-46)
    Given I want to discover remote signers
    When I query a domain's NIP-05 endpoint
    Then the app should request the `/.well-known/nostr.json?name=_` endpoint
    And the app should extract the remote signer pubkey
    And the app should extract the relay list
    And the app should extract the nostrconnect URL template
    And the app should use this information for connection
    And the app should validate the domain's NIP-89 event

  Scenario: Remote signer discovery via NIP-89 (NIP-46)
    Given I want to discover remote signers
    When I search for NIP-89 events with kind 24133
    Then the app should find remote signer discovery events
    And the app should extract relay information from events
    And the app should extract nostrconnect URL information
    And the app should verify the event author against NIP-05 data
    And the app should use this information for connection
    And the app should provide a list of available remote signers

  Scenario: Remote signer connection security (NIP-46)
    Given I am connecting to a remote signer
    When I establish the connection
    Then the app should use NIP-44 encryption for all communication
    And the app should validate all response signatures
    And the app should verify the remote signer pubkey
    And the app should use secure relay connections
    And the app should handle connection spoofing attempts
    And the app should maintain connection security throughout

  Scenario: Remote signer error handling (NIP-46)
    Given I am using a remote signer
    When I encounter an error during signing
    Then the app should handle the error gracefully
    And the app should display appropriate error messages
    And the app should retry failed requests when appropriate
    And the app should fall back to local signing if available
    And the app should maintain app functionality despite errors
    And the app should provide clear error recovery options

  Scenario: Remote signer connection state management (NIP-46)
    Given I am using a remote signer
    When the connection state changes
    Then the app should track the connection status
    And the app should update the UI accordingly
    And the app should handle connection timeouts
    And the app should attempt reconnection when appropriate
    And the app should notify the user of connection issues
    And the app should maintain app functionality during disconnections

  Scenario: Remote signer performance optimization (NIP-46)
    Given I am using a remote signer
    When I perform signing operations
    Then the app should optimize request frequency
    And the app should cache connection information
    And the app should minimize network overhead
    And the app should handle concurrent requests efficiently
    And the app should provide responsive user feedback
    And the app should maintain smooth user experience

  Scenario: Remote signer privacy protection (NIP-46)
    Given I am using a remote signer
    When I perform signing operations
    Then the app should protect user privacy
    And the app should minimize data exposure
    And the app should use secure communication channels
    And the app should handle sensitive data appropriately
    And the app should respect user privacy preferences
    And the app should comply with privacy requirements

  # NIP-42 Authentication of clients to relays Scenarios

  Scenario: Relay authentication challenge handling (NIP-42)
    Given I am connecting to a relay that requires authentication
    When the relay sends an AUTH challenge
    Then the app should receive the challenge string
    And the app should store the challenge for the relay
    And the app should prepare to respond to the challenge
    And the app should maintain the challenge for the connection duration
    And the app should handle multiple challenges from the same relay

  Scenario: Relay authentication event creation (NIP-42)
    Given I have received an AUTH challenge from a relay
    When I create an authentication response
    Then the app should create a kind 22242 ephemeral event
    And the event should include a 'relay' tag with the relay URL
    And the event should include a 'challenge' tag with the challenge string
    And the event should have a current timestamp
    And the event should be properly signed
    And the event should not be published or queried

  Scenario: Relay authentication event verification (NIP-42)
    Given I am a relay receiving an AUTH event
    When I verify the authentication event
    Then I should verify the event kind is 22242
    And I should verify the created_at is within ~10 minutes
    And I should verify the challenge tag matches the sent challenge
    And I should verify the relay tag matches the relay URL
    And I should verify the event signature
    And I should exclude kind 22242 events from broadcasting

  Scenario: Relay authentication flow for REQ messages (NIP-42)
    Given I am requesting data from a relay that requires authentication
    When I send a REQ message without authentication
    Then the relay should send an AUTH challenge
    And the relay should respond with CLOSED and auth-required message
    And I should send an AUTH event with the signed challenge
    And the relay should respond with OK for the AUTH event
    And I should be able to retry the original REQ message
    And the relay should serve the requested data

  Scenario: Relay authentication flow for EVENT messages (NIP-42)
    Given I am publishing an event to a relay that requires authentication
    When I send an EVENT message without authentication
    Then the relay should send an AUTH challenge
    And the relay should respond with OK and auth-required message
    And I should send an AUTH event with the signed challenge
    And the relay should respond with OK for the AUTH event
    And I should be able to retry the original EVENT message
    And the relay should accept and broadcast the event

  Scenario: Relay authentication session management (NIP-42)
    Given I am authenticated to a relay
    When I perform operations on the relay
    Then the authentication should be valid for the connection duration
    And I should not need to re-authenticate for subsequent operations
    And the relay should remember my authentication status
    And I should be able to perform multiple operations
    And the authentication should persist until connection closes

  Scenario: Relay authentication error handling (NIP-42)
    Given I am attempting to authenticate to a relay
    When the authentication fails
    Then the app should handle the error gracefully
    And the app should display appropriate error messages
    And the app should retry authentication when appropriate
    And the app should fall back to unauthenticated mode if needed
    And the app should maintain app functionality despite auth failures
    And the app should provide clear error recovery options

  Scenario: Relay authentication for restricted resources (NIP-42)
    Given I am accessing restricted resources on a relay
    When I request access to kind 4 DMs
    Then the relay should require authentication
    And the relay should send an AUTH challenge
    And I should authenticate with the relay
    And the relay should grant access to the restricted resources
    And I should be able to access the DMs after authentication
    And the relay should maintain access control

  Scenario: Relay authentication for paid services (NIP-42)
    Given I am using a relay that requires payment
    When I attempt to publish events
    Then the relay should require authentication
    And the relay should verify my payment status
    And the relay should grant access based on payment
    And I should be able to publish events after authentication
    And the relay should maintain payment-based access control
    And the relay should handle payment verification

  Scenario: Relay authentication for whitelisted users (NIP-42)
    Given I am using a relay with whitelist restrictions
    When I attempt to access relay services
    Then the relay should require authentication
    And the relay should verify my whitelist status
    And the relay should grant access based on whitelist
    And I should be able to access services after authentication
    And the relay should maintain whitelist-based access control
    And the relay should handle whitelist verification

  Scenario: Relay authentication challenge timing (NIP-42)
    Given I am connecting to a relay
    When the relay sends an AUTH challenge
    Then the challenge should be valid for the connection duration
    And the challenge should be replaced by new challenges
    And I should respond to the current challenge
    And I should handle challenge timing appropriately
    And I should not use expired challenges
    And I should request new challenges when needed

  Scenario: Relay authentication URL normalization (NIP-42)
    Given I am authenticating to a relay
    When I verify the relay URL in the AUTH event
    Then the app should apply URL normalization techniques
    And the app should check if the domain name is correct
    And the app should handle URL variations appropriately
    And the app should verify the relay tag matches the URL
    And the app should handle URL parsing errors
    And the app should maintain URL consistency

  Scenario: Relay authentication for subscription limits (NIP-42)
    Given I am subscribing to relay data
    When the relay has subscription limits
    Then the relay should require authentication
    And the relay should verify my subscription status
    And the relay should grant access based on limits
    And I should be able to subscribe after authentication
    And the relay should maintain subscription-based access control
    And the relay should handle subscription verification

  Scenario: Relay authentication for event publishing limits (NIP-42)
    Given I am publishing events to a relay
    When the relay has publishing limits
    Then the relay should require authentication
    And the relay should verify my publishing permissions
    And the relay should grant access based on limits
    And I should be able to publish events after authentication
    And the relay should maintain publishing-based access control
    And the relay should handle publishing verification

  Scenario: Relay authentication session persistence (NIP-42)
    Given I am authenticated to a relay
    When I reconnect to the relay
    Then I should need to re-authenticate
    And the app should handle re-authentication automatically
    And the app should maintain authentication state appropriately
    And the app should handle connection interruptions
    And the app should provide seamless re-authentication
    And the app should handle authentication timeouts

  Scenario: Relay authentication for multiple relays (NIP-42)
    Given I am connected to multiple relays
    When some relays require authentication
    Then the app should handle authentication per relay
    And the app should maintain separate authentication states
    And the app should authenticate to each relay independently
    And the app should handle different authentication requirements
    And the app should maintain authentication across relays
    And the app should handle relay-specific authentication

  Scenario: Relay authentication for relay discovery (NIP-42)
    Given I am discovering new relays
    When I connect to relays that require authentication
    Then the app should handle authentication during discovery
    And the app should authenticate to discovered relays
    And the app should maintain authentication for discovered relays
    And the app should handle authentication requirements during discovery
    And the app should provide authentication feedback during discovery
    And the app should handle discovery authentication errors

  Scenario: Relay authentication for relay switching (NIP-42)
    Given I am switching between relays
    When the new relay requires authentication
    Then the app should handle authentication during switching
    And the app should authenticate to the new relay
    And the app should maintain authentication state during switching
    And the app should handle different authentication requirements
    And the app should provide seamless relay switching
    And the app should handle switching authentication errors

  Scenario: Relay authentication for relay fallback (NIP-42)
    Given I am using relay fallback mechanisms
    When fallback relays require authentication
    Then the app should handle authentication for fallback relays
    And the app should authenticate to fallback relays
    And the app should maintain authentication across fallbacks
    And the app should handle different fallback authentication requirements
    And the app should provide seamless fallback authentication
    And the app should handle fallback authentication errors 