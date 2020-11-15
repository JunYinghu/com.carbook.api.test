@carApiCall
@carBook
@E2E
Feature: to verify e2e car booking with different condition
  # This feature mainly to verify payload as per car available status and location - 4 cases
  # verify payload, response code
  # carBookNoCarAvailable
  # carBookNearestAvailableCar
  # carBookCarsParkSameSpot
  # carBookAvailableCar

  Background: declare common variables
    * url carBookBaseUrl
    * def javaMethod = Java.type('com.carsystem.karate.util.UnitTimeCalculator')
    * def headerInfo = {x-fas-signature: '9e4051e203a747ba93cfb6268cbb56ec', Content-Type:'application/json'}
    * def bookAllCars = 'classpath:carBookApi/carBookE2EFeature/car-book-basic.feature@carBookVerifyCarIdTotalTime'
    * def reUseCallReset = 'classpath:reuseFeature/reuse-common-call.feature@reuseResetCall'
    * def reUseCallBook = 'classpath:reuseFeature/reuse-common-call.feature@reuseBookCall'
    * def requestJson = read ('classpath:src/test/resource/carBookData.json')

  @carBookNoCarAvailable
  Scenario: Verify no car available
    # pre-condition: all cars are booked
    Given call read(bookAllCars)
    Given path 'v1/book'
    Given headers headerInfo
    Given request requestJson
    When method POST
    Then match responseStatus == payloadMessage.good_response_car_book_no_available.response_code
    And match response == payloadMessage.good_response_car_book_no_available.response_message


  @carBookNearestAvailableCar
  Scenario Outline: Verify 2 cars are available on the different place, the nearest car id will be assigned for the request of new coming booking
    Given call read(reUseCallReset)
    Given call read(reUseCallBook) [{preCustomer: {x:50,y:-4}, preDestination: {x:7,y:4}}]
    Given call read(reUseCallBook) [{preCustomer: {x:-2,y:-4}, preDestination: {x:-6,y:-4}}]
    Given call read(reUseCallBook) [{preCustomer: {x:2,y:4}, preDestination: {x:6,y:4}}]
    But call read('utility.js') response.total_time
    Given path '/v1/book'
    And headers headerInfo
    And request {"source":<customer>,"destination":<destination>}
    When method POST
    Then match response contains <expected_payload>
    * def currentCarLocation = <car_location>
    * def currentCustomer = <customer>
    * def currentDestination = <destination>
    And response.total_time == <expected_totalTime>
    Examples:
      | car_location | customer  | destination | expected_payload                      | expected_totalTime                                                                                                       |
      | {x:6,y:4}    | {x:7,y:5} | {x:8,y:20}  | {"car_id": 3,"total_time": "#ignore"} | javaMethod.getUnitTime(currentCarLocation,currentCustomer) +javaMethod.getUnitTime(currentCustomer,currentDestination) |

  @carBookCarsParkSameSpot
  Scenario Outline: Verify 3 cars park on the same spot and when new customer book a car, the smaller car_id returned
    * def preCustomer = {x:-3,y:6}
    * def preDestination = {x:2,y:8}
    # pre-condition: all cars reset in the
    Given call read(reUseCallReset)
    Given call read(reUseCallBook) preCustomer, preDestination
    Given call read(reUseCallBook) preCustomer, preDestination
    Given call read(reUseCallBook) preCustomer, preDestination
    But call read('utility.js') response.total_time
    Given path '/v1/book'
    And headers headerInfo
    And request {"source":<customer>,"destination":<destination>}
    When method POST
    Then match response contains <expected_payload>
    * def currentCarLocation = <car_location>
    * def currentCustomer = <customer>
    * def currentDestination = <destination>
    And assert response.total_time == <expected_totalTime>

    Examples:
      | car_location    | customer   | destination | expected_payload                      | expected_totalTime                                                                                                       |
      | $preDestination | {x:-9,y:6} | {x:8,y:20}  | {"car_id": 1,"total_time": "#ignore"} | javaMethod.getUnitTime(currentCarLocation,currentCustomer) +javaMethod.getUnitTime(currentCustomer,currentDestination) |

  @carBookAvailableCar
  Scenario Outline: Verify 1 car is available, the car id will be assigned for the request of new coming booking (regardless of id, total_time)
    Given call read(reUseCallReset)
    Given call read(reUseCallBook) [{preCustomer: {x:50,y:4}, preDestination: {x:50,y:4}}]
    Given def returnedCarObject = call read(reUseCallBook) [{preCustomer: {x:-1,y:0}, preDestination: {x:-3,y:-4}}]
    Given call read(reUseCallBook) [{preCustomer: {x:2,y:4}, preDestination: {x:6,y:4}}]
    But call read('utility.js') returnedCarObject[0].response.total_time
    Given path '/v1/book'
    And headers headerInfo
    And request {"source":<customer>,"destination":<destination>}
    When method POST
    Then match response contains <expected_payload>
    * def currentCarLocation = <car_location>
    * def currentCustomer = <customer>
    * def currentDestination = <destination>
    And response.total_time == <expected_totalTime>
    Examples:
      | car_location | customer  | destination | expected_payload                      | expected_totalTime                                                                                                       |
      | {x:6,y:4}    | {x:7,y:5} | {x:8,y:20}  | {"car_id": 2,"total_time": "#ignore"} | javaMethod.getUnitTime(currentCarLocation,currentCustomer) +javaMethod.getUnitTime(currentCustomer,currentDestination) |
