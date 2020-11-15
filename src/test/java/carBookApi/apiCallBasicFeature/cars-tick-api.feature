@carApiCall
@carsTick
Feature: to test car reset api call
  # This feature is sanity check of v1/tick api - 8 test cases (pass 4, failed 4)
  # Including positive / negative testing to verify response code, response message
  # Missing or invalid authorization token
  # Unsupported methods for endpoints
  # Unsupported protocol
  # Post with extra request data

  Background: declare common variables
    * url carBookBaseUrl

  @carsTimeUnitCallSuccess
  @smoke
  Scenario: Simulate booked cars time unit successfully
    Given path '/v1/tick'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request ""
    When method POST
    Then match responseStatus == payloadMessage.good_response_car_tick.response_code
    And match response == payloadMessage.good_response_car_tick.response_message
    * def expectedResponseMinTime = 1000
    * def expectedResponseMaxTime = 2500
    * assert responseTime > expectedResponseMinTime && responseTime < expectedResponseMaxTime

  @carsTimeUnitCallInvalidProtocol
  Scenario: Simulate booked cars with invalid Protocol - valid failed (No response: Connection refused: connect)
    Given url 'http://interview.dev.motional.cc/v1/tick'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request ""
    When method POST
    And match response contains payloadMessage.invalid_protocol.response_message

  @carsTickWithRequestData
  Scenario: Simulate booked cars unit time with request content, expected server ignore, 200
    Given path '/v1/tick'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request "sljflasjdflds"
    When method POST
    Then match responseStatus == payloadMessage.good_response_car_reset.response_code
    And match response == payloadMessage.good_response_car_reset.response_message

  @carsTickWithInvalidSignature
  @smoke
  Scenario: Simulate booked cars unit time with invalid signature, expected Unauthorized error 401
    Given path '/v1/tick'
    And header x-fas-signature = '9e4051e203a747ba9999cfb6268cbb56ec'
    And request ""
    When method POST
    Then match responseStatus == payloadMessage.invalid_Auth.response_code
    And match response == payloadMessage.invalid_Auth.response_message

  @carsTickCallWithoutSignature
  @smoke
  Scenario: Booked cars unit time call without signature, expected missing authentication error 401 - valid failed (return 403)
   # And header x-fas-signature = '9e4051e203a747ba9ssscfb6268cbb56ec'
    Given path '/v1/tick'
    And request ""
    When method PUT
    Then match responseStatus == payloadMessage.missing_Auth.response_code
    And match response == payloadMessage.missing_Auth.response_message

  @carsTickCallInvalidSignatureKey
  @smoke
  Scenario: Booked cars unit time call with invalid signature Key, expected Unauthorized error 401
    Given path '/v1/tick'
    And header "x-fas-signature" = '9e4051e203a747ba93cfb6268cbb56ec'
    And request ""
    When method POST
    Then match responseStatus == payloadMessage.invalid_Auth.response_code
    And match response == payloadMessage.invalid_Auth.response_message
    And print response

   # method is not allowed error
  @carsTickCallMethodNotAllowedGET
  Scenario: Reset call with MethodNotAllowed (Get), expected error 405 - valid failed (return 403)
    Given path '/v1/tick'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request ""
    When method GET
    And print response
    Then match responseStatus == payloadMessage.method_not_allowed.response_code
    And match response == payloadMessage.method_not_allowed.response_message


  # method is not allowed error
  @carsTickCallMethodNotAllowedPUT
  Scenario: Booked cars unit time call with MethodNotAllowed(PUT), expected error 405 -  valid failed (return 403)
    Given path '/v1/tick'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request ""
    When method PUT
    And print response
    Then match responseStatus == payloadMessage.method_not_allowed.response_code
    And match response == payloadMessage.method_not_allowed.response_message
