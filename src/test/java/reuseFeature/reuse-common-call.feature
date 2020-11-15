@reuseAPiCall
Feature: here are basic call for re-use
 #this is common re-use feature

  # basic api endpoint with header
  Background: declare common variables
    * url carBookBaseUrl
    * header x-fas-signature = '9e4051e203a747ba93cfb6268cbb56ec'

  @reuseBookCall
  Scenario: Send book request once
    Given path '/v1/book'
    * def headerInfo = {x-fas-signature: '9e4051e203a747ba93cfb6268cbb56ec', Content-Type:'application/json'}
    And headers headerInfo
    # the customer , destination are expected to be set as a call arg
    And request {"source":#(preCustomer),"destination":#(preDestination)}
    When method POST
    Then status 200

  @reuseBookCallPerformance
  Scenario: Send book request once
    Given path '/v1/book'
    * def headerInfo = {x-fas-signature: '9e4051e203a747ba93cfb6268cbb56ec', Content-Type:'application/json'}
    And headers headerInfo
    # the customer , destination are expected to be set as a call arg
    And request {"source":{x:3,y:4},"destination":{x:7,y:10}}
    When method POST
    Then status 200


  @reuseTickCall
  Scenario: request booked cars movement once
    Given path '/v1/tick'
    And request ''
    When method POST
    Then status 200
    And match response == 'null'

  @reuseResetCall
  Scenario: request all cars reset call once
    Given path '/v1/reset'
    And request ""
    When method PUT
    Then status 200
    And match response == 'null'
    And print "all cars reset"