import Toybox.Lang;
import Toybox.Test;

(:test)
function isUsableRequiresTenCycles(logger as Test.Logger) as Lang.Boolean {
    Test.assert(!HeroSetCalibration.isUsable(9, 300, 240));
    Test.assert(HeroSetCalibration.isUsable(10, 300, 240));
    return true;
}

(:test)
function isUsableRejectsWeakCycles(logger as Test.Logger) as Lang.Boolean {
    Test.assert(!HeroSetCalibration.isUsable(10, 40, 30));
    Test.assert(!HeroSetCalibration.isUsable(10, 200, 40));
    return true;
}

(:test)
function thresholdsFitHalfOfMeanCycles(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetCalibration.armThresholdFrom(300, 240), 150);
    Test.assertEqual(HeroSetCalibration.releaseThresholdFrom(300, 240), 120);
    return true;
}

(:test)
function thresholdsClampToSafeRange(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetCalibration.armThresholdFrom(50, 50), 60);
    Test.assertEqual(HeroSetCalibration.armThresholdFrom(2000, 2000), 500);
    Test.assertEqual(HeroSetCalibration.releaseThresholdFrom(2000, 2000), 400);
    return true;
}
