# Car book system API Testing Project
This repo holds the code for assignment <Car book system> API testing
It is divided into smoke , e2e testing covering api basic negative and positive as well as performance testing
All test cases runner has been tested on Window and Linux

## Prerequisites
You will need
 - java 8 and above
 - maven 3.5.3 and above
 - Docker 19.03.13

## Library
Reference to following libraries / frameworks
  - Karate 0.9.5
  - Cucumber 5.3.0
  - junit 1.5
  - karate-gatling 0.9.5 (for api performance run)

## Installation and Pre-Config
  - Simply clone car-book-api
  - You may ignore pre-config to use default

### Pre-Config Performance Testing
   - Go to folder and modify application.properties
 ```   
   cd car-book-api-test/src/main/resources/application.properties 
     
   rampUser=1000
   runDuration=60
 ```

### Pre-Config Verified Payload

You may config returned payload with response code as per given input, 
It is very flexible way to re-define response message and code.
```
cd car-book-api-test/src/test/resource/verifiedPayloadAndCode.json
```

## Test Case Run
 - Run desired command as the following approaches

### Dock

#### Run Smoke Test
  - generating junit report
  - including smoke test
```
    cd car-book-api-test/CICD   
    docker-compose run mavensmoke
```
#### Run All Test
   - generating cucumber report
   - parallel run
   - including all test 
```
    cd car-book-api-test/CICD   
    docker-compose run mavenfull   
```

#### Performance Run
   - generating gatling report
```
    cd car-book-api-test/CICD   
    docker-compose run performancerun   
```

### Debug Run

#### Run Smoke Test
  - generating junit report
```
    cd car-book-api-test
    mvn test -Dtest=CarBookApiSmokeRunner
```
#### Run All Test
   - generating cucumber report
```
    cd car-book-api-test
    mvn test -Dtest=CarBookApiFullTestRunner
```

#### Performance Run
   - generating gatling report
```
    cd car-book-api-test
    mvn test-compile gatling:test
```


## Report
 
 ### Junit Report
  ```
      cd car-book-api-test/target/surefire-reports
  ```
 ### Cucumber Report
  ```
      cd car-book-api-test/target/cucumber-html-reports/overview-features.html
  ```

 ### Performance Report
 ```
     cd car-book-api-test/target/gatling
 ```
  
## Test Categories / Coverage

### 3 API Call Basic Verification
   - Execute API call with valid required parameters
   - Positive + optional parameters  
   - Negative testing – valid input
   - Negative testing – invalid input
   - Destructive testing
   - Security and Authorization

### E2E API Verification
   - Positive - positive response
   - positive - negative response
   - Negative - positive response

### Performance
   - covered 3 basic api (success call)

