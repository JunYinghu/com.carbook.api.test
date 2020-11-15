@carApiCall
@carBook
@E2E
Feature: to test user is able to book a car successfully
  # This feature mainly to test car book post API with input data type - 25 cases (pass 10, failed 15)
  # Include positive / negative
  # Include to verify total_time, response code, response message
  # Data type, Boundary value testing
  # noted
  # failed cases due to response status (500)
  # -0, 000000012 - server will ignore pre-fix 0, and -

  # basic api endpoint with header
  Background: declare common variables
    * url 'https://interview.dev.motional.cc/v1/book'
    # pre-condition: call once - all cars are in initial state
    * callonce read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    * def javaMethod = Java.type('com.carsystem.karate.util.UnitTimeCalculator')
    * def headerInfo = {x-fas-signature: '9e4051e203a747ba93cfb6268cbb56ec', Content-Type:'application/json'}

  @carBookVerifyCarIdTotalTime
    @smoke
  Scenario Outline: System return correct payload (car_id and total_time) as per given Customer /Destination location
    # all cars are in in initial state
    And  headers headerInfo
    And request {"source":<customer>,"destination":<destination>}
    When method POST
    Then status 200
    And print response
    And match response.car_id == <car_id>
    * def customer = <customer>
    * def destination = <destination>
    * def carLocation = <car_location>
    And match response.total_time ==  <total_time>
    Examples:
      | car_location | customer     | destination | car_id | total_time                                                                                  |
      | {x:0,y:0}    | {x:-3,y:6}   | {x:8,y:-10} | 1      | javaMethod.getUnitTime(carLocation,customer) + javaMethod.getUnitTime(customer,destination) |
      | {x:0,y:0}    | {x:1,y:3000} | {x:2,y:9}   | 2      | javaMethod.getUnitTime(carLocation,customer) + javaMethod.getUnitTime(customer,destination) |
      | {x:0,y:0}    | {x:1090,y:5} | {x:10,y:9}  | 3      | javaMethod.getUnitTime(carLocation,customer) + javaMethod.getUnitTime(customer,destination) |

  @carBookMaxMinLocation
  Scenario Outline: To test max / min location combination
     # pre-condition: all cars are in initial state
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    And  headers headerInfo
    And request {"source":<customer>,"destination":<destination>}
    When method POST
    Then status 200
    And print response
    And match response.car_id == <car_id>
    * def customer = <customer>
    * def destination = <destination>
    * def carLocation = <car_location>
    And match response.total_time ==  <total_time>

    Examples:
      | car_location | customer                    | destination                   | car_id | total_time                                                                                 |
      | {x:0,y:0}    | {x:2147483647,y:2147483647} | {x:-2147483648,y:-2147483648} | 1      | javaMethod.getUnitTime(carLocation,customer) +javaMethod.getUnitTime(customer,destination) |
      | {x:0,y:0}    | {x:-2147483648,y:5}         | {x:-10,y:-2147483647}         | 1      | javaMethod.getUnitTime(carLocation,customer) +javaMethod.getUnitTime(customer,destination) |
      | {x:0,y:0}    | {x:2147483647,y:3}          | {x:-2147483648,y:2147483647}  | 1      | javaMethod.getUnitTime(carLocation,customer) +javaMethod.getUnitTime(customer,destination) |
      | {x:0,y:0}    | {x:0,y:0}                   | {x:0,y:0}                     | 1      | javaMethod.getUnitTime(carLocation,customer) +javaMethod.getUnitTime(customer,destination) |

  @carBookInvalidCustomerLocation
  Scenario Outline: To test Customer Location with given special value
     # pre-condition: all cars are in initial state
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    And  headers headerInfo
    And request {"source":<customer>,"destination":<destination>}
    When method POST
    Then match responseStatus == <expected_code>
    And print response
    And match response contains <expected_payload>

    Examples:
      | customer                     | destination                   | expected_code                                                 | expected_payload                                                 |
      | {x:-0,y:0}                   | {x:2,y:9}                     | payloadMessage.good_response_car_book_available.response_code | payloadMessage.good_response_car_book_available.response_message |
      | {x:'t',y:5}                  | {x:10,y:0}                    | payloadMessage.unknown_field_value.response_code              | payloadMessage.unknown_field_value.response_message              |
      | {x:0,y:--0}                  | {x:2,y:0}                     | payloadMessage.unknown_field_value.response_code              | payloadMessage.unknown_field_value.response_message              |
      | {x:2147483648,y:-2147483648} | {x:-2147483648,y:-2147483648} | payloadMessage.unknown_field_value.response_code              | payloadMessage.unknown_field_value.response_message              |
      | {x:000000000019,y:00003}     | {x:19,y:0}                    | payloadMessage.good_response_car_book_available.response_code | payloadMessage.good_response_car_book_available.response_message |

  @carBookInvalidDestination
  Scenario Outline: To test Destination with given special value
     # pre-condition: all cars are in initial state
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    And  headers headerInfo
    And request {"source":<customer>,"destination":<destination>}
    When method POST
    And print response
    Then match responseStatus == <expected_code>
    And match response contains <expected_payload>

    Examples:
      | customer                     | destination                   | expected_code                                    | expected_payload                                    |
      | {x:0,y:0}                    | {x:--2,y:9}                   | payloadMessage.unknown_field_value.response_code | payloadMessage.unknown_field_value.response_message |
      | {x:4,y:5}                    | {x:0,y:-0.5}                  | payloadMessage.unknown_field_value.response_code | payloadMessage.unknown_field_value.response_message |
      | {x:0,y:0}                    | {x:'t',y:0}                   | payloadMessage.unknown_field_value.response_code | payloadMessage.unknown_field_value.response_message |
      | {x:0,y:0}                    | {x:'null',y:0}                | payloadMessage.unknown_field_value.response_code | payloadMessage.unknown_field_value.response_message |
      | {x:2147483647,y:-2147483648} | {x:-2147483649,y:-2147483649} | payloadMessage.unknown_field_value.response_code | payloadMessage.unknown_field_value.response_message |
      | {x:0,y:0}                    | {x: ,y:0}                     | payloadMessage.unknown_field_value.response_code | payloadMessage.unknown_field_value.response_message |
      | {x:0,y:0}                    | {x:_0,y:9}                    | payloadMessage.unknown_field_value.response_code | payloadMessage.unknown_field_value.response_code    |

  @carBookMixInvalidLocation
  Scenario Outline: To test mix of invalid location combination
     # pre-condition: all cars are in initial state
    * call read('classpath:reuseFeature/reuse-common-call.feature@reuseResetCall')
    And  headers headerInfo
    And request {"source":<customer>,"destination":<destination>}
    When method POST
    And print response
    Then match responseStatus == <expected_code>
    And match response contains <expected_payload>

    Examples:
      | customer                     | destination                   | expected_code                                                 | expected_payload                                                 |
      | {x:00,y:-00}                 | {x:-2,y:9}                    | payloadMessage.good_response_car_book_available.response_code | payloadMessage.good_response_car_book_available.response_message |
      | {x:04,y:'null'}              | {x:0,y:-0}                    | payloadMessage.unknown_field_value.response_code              | payloadMessage.unknown_field_value.response_message              |
      | {x:0,y:'0'}                  | {x:'999',y:0}                 | payloadMessage.unknown_field_value.response_code              | payloadMessage.unknown_field_value.response_message              |
      | {x:0,y:0.5}                  | {x:--2,y:9}                   | payloadMessage.unknown_field_value.response_code              | payloadMessage.unknown_field_value.response_message              |
      | {x:2147483648,y:2147483648}  | {x:-2147483649,y:-2147483649} | payloadMessage.unknown_field_value.response_code              | payloadMessage.unknown_field_value.response_message              |
      | {x:11111111111,y:1111111119} | {x:-1111111111,y:33333333333} | payloadMessage.unknown_field_value.response_code              | payloadMessage.unknown_field_value.response_message              |