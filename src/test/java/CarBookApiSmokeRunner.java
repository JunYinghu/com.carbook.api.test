import com.intuit.karate.junit5.Karate;

public class CarBookApiSmokeRunner {

   /* // run basic feature
    @Karate.Test
    Karate testApiCallBasic() {
        return Karate.run("classpath:carBookApi/apiCallBasicFeature").relativeTo(getClass());
    }*/

    // run basic smoke test
    @Karate.Test
    Karate testApiSmoke() {
        return Karate.run("classpath:carBookApi").tags("@smoke").relativeTo(getClass());
    }

  /*// run E2E feature
    @Karate.Test
    Karate testCarBookE2E() {
        return Karate.run("classpath:carBookApi/carBookE2EFeature").relativeTo(getClass());
    }*/


}
