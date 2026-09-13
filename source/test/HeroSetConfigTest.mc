import Toybox.Lang;
import Toybox.Test;

(:test)
function configKeepsMissionAndSensorContracts(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetConfig.MISSION_GOAL, 100);
    Test.assertEqual(HeroSetConfig.SENSOR_SAMPLE_RATE, 25);
    Test.assertEqual(HeroSetConfig.SENSOR_COOLDOWN_MS, 600);
    return true;
}
