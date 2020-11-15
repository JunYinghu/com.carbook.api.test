@carApiCall
Feature: to test car book api call
  # This feature is sanity check of v1/book api - 13 cases （Pass - 4, failed -9)
  # Including positive / negative testing to verify response code, response message, resposne time
  # Missing or invalid authorization token
  # Missing required content-type
  # Invalid content-type value
  # Unsupported methods for endpoints
  # Unsupported protocol
  # Post without / with invalid request data / data format


  Background: declare common variables
    * url carBookBaseUrl
    * def requestJson = read ('classpath:src/test/resources/carBookData.json')

  @carBookVerifyResponse
  @smoke
  Scenario: To verify return payload content - failed case (payload with extra field)
    # pre-condition: all cars are in initial state
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And header Content-Type = 'application/json'
    And request requestJson
    When method POST
    Then match responseStatus == payloadMessage.good_response_car_book_available.response_code
    And match responseType == 'json'
    * match response.car_id == '#present'
    * match response.total_time == '#present'
    * match response.car_id == '#number'
    * match response.total_time == '#number'
    * match header Content-Type == 'application/json'
    * def expectedResponseMinTime = 1000
    * def expectedResponseMaxTime = 2500
    * assert responseTime > expectedResponseMinTime && responseTime < expectedResponseMaxTime
    * match response == payloadMessage.good_response_car_book_available.response_message

  @carsBookCallInvalidProtocol
  Scenario: car book call with invalid Protocol - valid failed (No response: Connection refused: connect)
    Given url 'http://interview.dev.motional.cc/v1/book'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And header Content-Type = 'application/json'
    And request requestJson
    When method POST
    And match response contains payloadMessage.invalid_protocol.response_message

  @carBookCallWithoutRequestData
  @smoke
  Scenario: car book call without request data, expected bad request 400  - valid failed (returned 500 error)
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And header Content-Type = 'application/json'
    And request ''
    When method POST
    Then match responseStatus == payloadMessage.missing_field_value.response_code
    And match response == payloadMessage.missing_field_value.response_message

  @carBookCallInvalidSignature
  @smoke
  Scenario: Car book call with invalid signature, expected Unauthorized error 401
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header x-fas-signature = '9e4051e203a747ba93cfb6dfsfs268cbb56ec'
    And header Content-Type = 'application/json'
    And request requestJson
    When method POST
    Then match responseStatus == payloadMessage.invalid_Auth.response_code
    And match response == payloadMessage.invalid_Auth.response_message
    And print response

  @carBookCallWithoutSignature
  @smoke
  Scenario: Car book call without signature, expected missing authentication error 401  - valid failed  (return unauthorized)
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header Content-Type = 'application/json'
    And request requestJson
    When method POST
    Then match responseStatus == payloadMessage.missing_Auth.response_code
    And match response == payloadMessage.missing_Auth.response_message
    And print response

  @carBookCallWithoutContentType
  Scenario: Car book call without ContentType, expected missing content type error 400 - valid failed (it ignore this missed content-type, response 200)
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request requestJson
    When method POST
    Then match responseStatus == payloadMessage.missing_content_type.response_code
    And match response == payloadMessage.missing_content_type.response_message
    And print response

  @carBookCallInvalidContentType
  @smoke
    Scenario: Car book call Invalid Content Type , expected error 415 - valid failed (return 500)
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header Content-Type = 'application/text'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request requestJson
    When method POST
    Then match responseStatus == payloadMessage.unsupported_media_type.response_code
    And match response == payloadMessage.unsupported_media_type.response_message
    And print response

  @carBookCallInvalidRequestContent
  Scenario: Car book call Invalid Request data format, expected bad request error 400
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header Content-Type = 'application/json'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request karate.readAsString('classpath:src/test/resources/carBookData_invalid.json')
    When method POST
    And print response
    Then match responseStatus == payloadMessage.invalid_request_format.response_code
    And match response == payloadMessage.invalid_request_format.response_message

  @carBookCallInvalidRequestContentFormat
  Scenario: Car book call Invalid Request data type, expected bad request error 400
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header Content-Type = 'application/json'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request karate.readAsString('classpath:src/test/resources/uploadImage.png')
    When method POST
    And print response
    Then match responseStatus == payloadMessage.invalid_request_format.response_code
    And match response == payloadMessage.invalid_request_format.response_message

  @carBookCallRequestReadTxt
  Scenario: Car book call Request data Type (txt), expected 200
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header Content-Type = 'application/json'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And request karate.readAsString('classpath:src/test/resources/carBookData.txt')
    When method POST
    Then match responseStatus == payloadMessage.good_response_car_book_available.response_code
    And match response contains payloadMessage.good_response_car_book_available.response_message
    And print response

  @carBookCallInvalidSignatureKey
  @smoke
  Scenario: Car book call with invalid signature Key, expected Unauthorized error 401
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header x-fasd-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And header Content-Type = 'application/json'
    And request requestJson
    When method POST
    Then match responseStatus == payloadMessage.invalid_Auth.response_code
    And match response == payloadMessage.invalid_Auth.response_message
    And print response

  # method is not allowed error
  @carBookCallMethodNotAllowedGET
  Scenario: Care book call with Method Not Allowed (Get), expected 405 - valid failed (return 403, missing authentication Token)
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And header Content-Type = 'application/json'
    And request requestJson
    When method GET
    And print response
    Then match responseStatus == payloadMessage.method_not_allowed.response_code
    And match response == payloadMessage.method_not_allowed.response_message


  # method is not allowed error
  @carBookCallMethodNotAllowedPUT
  Scenario: Car book call with Method Not Allowed (PUT), expected error 405 - valid failed (return 403, missing authentication Token)
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And header Content-Type = 'application/json'
    And request requestJson
    When method PUT
    And print response
    Then match responseStatus == payloadMessage.method_not_allowed.response_code
    And match response == payloadMessage.method_not_allowed.response_message


  @carBookBatchRequest
  Scenario: Car book call to verify batch request - valid failed (return 500)
    # pre-condition: all cars are in initial state
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    Given path '/v1/book'
    And header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'
    And header Content-Type = 'application/json'
    And request karate.readAsString('classpath:src/test/resources/carBookData_batch.json')
    When method POST
    Then match responseStatus == payloadMessage.missing_field_value.response_code
    And match response == payloadMessage.missing_field_value.response_message