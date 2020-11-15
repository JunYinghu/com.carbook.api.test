function(callTimes){
       var bookCallTotalTime;
        for (i=0;i<callTimes;i++){
            karate.call('classpath:reuseFeature/reuse-common-call.feature@reuseTickCall')
          }
   }