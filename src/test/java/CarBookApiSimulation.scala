import java.io.FileInputStream
import java.util.Properties

import com.intuit.karate.gatling.PreDef.karateFeature
import io.gatling.core.Predef.{Simulation, openInjectionProfileFactory, rampUsers, scenario}
import io.gatling.core.structure.ScenarioBuilder

import scala.concurrent.duration.DurationInt

class CarBookApiSimulation extends Simulation {
  val carBook: ScenarioBuilder = scenario("carBook").exec(karateFeature("classpath:reuseFeature/reuse-common-call.feature@reuseBookCallPerformance"))
  val carTick: ScenarioBuilder = scenario("carTick").exec(karateFeature("classpath:reuseFeature/reuse-common-call.feature@reuseTickCall"))
  val carReset: ScenarioBuilder = scenario("carReset").exec(karateFeature("classpath:reuseFeature/reuse-common-call.feature@reuseResetCall"))

  val properties = new Properties()
  val propertiesPath: String = Thread.currentThread().getContextClassLoader.getResource("application.properties").getPath
  properties.load(new FileInputStream(propertiesPath))
  val runDuration: Int = properties.getProperty("runDuration", "30").toInt
  val rampUser: Int = properties.getProperty("rampUser", "15").toInt

  setUp(
    carBook.inject(rampUsers(rampUser) during (runDuration seconds)),
    carTick.inject(rampUsers(rampUser) during (runDuration seconds)),
    carReset.inject(rampUsers(rampUser) during (runDuration seconds))
  )

}
