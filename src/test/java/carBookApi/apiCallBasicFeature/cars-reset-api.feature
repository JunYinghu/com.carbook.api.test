@carApiCall
@carsStateResetAll
Feature: to test car reset api call
  # This feature is sanity check of v1/reset api - 8 cases （pass 4, failed 4)
  # Including positive / negative testing to verify response code, response message
  # Missing or invalid authorization token
  # Unsupported methods for endpoints
  # Unsupported protocol
  # Post with extra request data

  Background: declare common variables
    * url carBookBaseUrl

  @carsStateResetCallSuccess
  @smoke
  Scenario: Reset all cars are in initial state successfully
    Given path '/v1/reset'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request ""
    When method PUT
    Then match responseStatus == payloadMessage.good_response_car_reset.response_code
    And match response == payloadMessage.good_response_car_reset.response_message
    * def expectedResponseMinTime = 1000
    * def expectedResponseMaxTime = 2500
    * assert responseTime > expectedResponseMinTime && responseTime < expectedResponseMaxTime

  @carsStateResetCallWithRequestData
  Scenario: Simulate booked cars state reset call with request data, expected 200, ignore request data
    Given path '/v1/reset'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request "&&&&&???"
    When method PUT
    Then status 200
    And match response == 'null'

  @carsStateResetCallInvalidProtocol
  Scenario: Reset call with invalid Protocol - valid failed (clarification: did not response Connection refused: connect)
    Given url 'http://interview.dev.motional.cc/v1/reset'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request ""
    When method POST
    And match response contains payloadMessage.invalid_protocol.response_message

  @carsStateResetCallInvalidSignature
  @smoke
  Scenario: Reset call with invalid signature, expected Unauthorized error 401
    Given path '/v1/reset'
    And header x-fas-signature = '9e4051e203a747ba9ssscfb6268cbb56ec'
    And request ""
    When method PUT
    And print response
    Then match responseStatus == payloadMessage.invalid_Auth.response_code
    And match response == payloadMessage.invalid_Auth.response_message

  @carsStateResetCallWithoutSignature
  @smoke
  Scenario: Reset call without signature, expected missing authentication error 401 - valid failed (returned unauthorized)
   # And header x-fas-signature = '9e4051e203a747ba9ssscfb6268cbb56ec'
    Given path '/v1/reset'
    And request ""
    When method PUT
    Then match responseStatus == payloadMessage.missing_Auth.response_code
    And match response == payloadMessage.missing_Auth.response_message
    And print response

  @carsStateResetCallInvalidSignatureKey@smoke
  Scenario: Reset call with invalid signature Key, expected Unauthorized error 401
    Given path '/v1/reset'
    And header x-fasd-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request ""
    When method PUT
    And print response
    Then match responseStatus == payloadMessage.invalid_Auth.response_code
    And match response == payloadMessage.invalid_Auth.response_message


  # method not allowed error
  @carsStateResetCallMethodNotAllowedGET
  Scenario: Reset call with MethodNotAllowed (Get), expected error 405 - valid failed (returned 403, with missing authentication token)
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request ""
    When method GET
    And print response
    Then match responseStatus == payloadMessage.method_not_allowed.response_code
    And match response == payloadMessage.method_not_allowed.response_message


  # method not allowed error
  @carsStateResetCallMethodNotAllowedPOST
  Scenario: Reset call with MethodNotAllowed(POST), expected error 405 - valid failed (returned 403, with missing authentication token)
    Given path '/v1/reset'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request ""
    When method POST
    And print response
    Then match responseStatus == payloadMessage.method_not_allowed.response_code
    And match response == payloadMessage.method_not_allowed.response_message
