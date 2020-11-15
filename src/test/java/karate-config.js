function fn() {
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  var messageResult = karate.read('classpath:src/test/resource/verifiedPayloadAndCode.json');
  var protocol = 'https';
  var config = { carBookBaseUrl: protocol + '://interview.dev.motional.cc', payloadMessage: messageResult};
  return config;



  }


