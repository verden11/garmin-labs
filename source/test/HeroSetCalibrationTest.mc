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
function thresholdsFitAFractionOfMeanSwing(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetCalibration.armThresholdFrom(300), 300 * HeroSetConfig.CALIBRATION_FIT_PERCENT / 100);
    Test.assertEqual(HeroSetCalibration.releaseThresholdFrom(250), 250 * HeroSetConfig.CALIBRATION_FIT_PERCENT / 100);
    return true;
}

(:test)
function thresholdsClampToSafeRange(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetCalibration.armThresholdFrom(50), HeroSetConfig.CALIBRATION_ARM_MIN);
    Test.assertEqual(HeroSetCalibration.armThresholdFrom(5000), HeroSetConfig.CALIBRATION_ARM_MAX);
    Test.assertEqual(HeroSetCalibration.releaseThresholdFrom(5000), HeroSetConfig.CALIBRATION_RELEASE_MAX);
    return true;
}

// A rep that counted while calibrating must be able to count in a workout.
(:test)
function fittedFloorNeverExceedsCalibrationThresholds(logger as Test.Logger) as Lang.Boolean {
    Test.assert(HeroSetConfig.CALIBRATION_ARM_MIN <= HeroSetConfig.CALIBRATION_SAMPLE_ARM);
    Test.assert(HeroSetConfig.CALIBRATION_RELEASE_MIN <= HeroSetConfig.CALIBRATION_SAMPLE_RELEASE);
    return true;
}
