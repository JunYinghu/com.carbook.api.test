@ignore
Feature: here is basic verification response for each Api call
  # This is common re-use feature
  # Not use in this cases due to un-clear header verification

  Scenario: to verify basic response

    #And match response.Access-Control-Allow-Origin == *
    And match response.Connection == 'keep-alive'
    And match response.Content-Length == 59
    And match response.Content-Security-Policy == 'default-src 'none'; frame-ancestors 'none''
    And match response.Content-Type == 'application/json'
    And match response.Strict-Transport-Security == 'max-age=63072000'
    And match response.X-Amzn-Trace-Id == 'Root=1-5f97ea2b-251cc0664d00dee0178bc18c;Sampled=0'
    And match response.X-Content-Type-Options == 'nosniff'
    And match response.x-amz-apigw-id == 'VEGGzFLLIAMFnCA='
    And match response.x-amzn-RequestId == '47c0d895-125a-4e0a-9e9b-5c12deb4b7a0'