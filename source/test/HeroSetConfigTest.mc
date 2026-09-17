import Toybox.Lang;
import Toybox.Test;

(:test)
function configKeepsMissionAndSensorContracts(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetConfig.MISSION_GOAL, 100);
    Test.assertEqual(HeroSetConfig.XP_PER_REP, 2);
    Test.assertEqual(HeroSetConfig.RANK_XP_STEP, 300);
    Test.assertEqual(HeroSetConfig.RANK_COST_CAP_RANK, 14);
    Test.assertEqual(HeroSetConfig.SENSOR_SAMPLE_RATE, 25);
    Test.assertEqual(HeroSetConfig.SENSOR_COOLDOWN_MS, 600);
    return true;
}
