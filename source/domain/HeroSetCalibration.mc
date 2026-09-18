import Toybox.Lang;

// Calibration fits detection thresholds from counted cycles. The provisional
// SAMPLE_* thresholds are used DURING calibration so real cycles are caught;
// the fitted thresholds are a fraction of the mean cycle swing on each side,
// clamped to a safe range whose floor is the provisional threshold, and only
// stored when the session is strong enough.
class HeroSetCalibration {
    static function armThresholdFrom(meanPeak as Lang.Number) as Lang.Number {
        return clamp(fitted(meanPeak), HeroSetConfig.CALIBRATION_ARM_MIN, HeroSetConfig.CALIBRATION_ARM_MAX);
    }

    static function releaseThresholdFrom(meanValley as Lang.Number) as Lang.Number {
        return clamp(fitted(meanValley), HeroSetConfig.CALIBRATION_RELEASE_MIN, HeroSetConfig.CALIBRATION_RELEASE_MAX);
    }

    private static function fitted(meanSwing as Lang.Number) as Lang.Number {
        return meanSwing * HeroSetConfig.CALIBRATION_FIT_PERCENT / 100;
    }

    private static function clamp(value as Lang.Number, low as Lang.Number, high as Lang.Number) as Lang.Number {
        return value < low ? low : (value > high ? high : value);
    }

    static function isUsable(cycles as Lang.Number, meanPeak as Lang.Number, meanValley as Lang.Number) as Lang.Boolean {
        return cycles >= HeroSetConfig.CALIBRATION_REQUIRED_CYCLES && meanPeak >= HeroSetConfig.CALIBRATION_MIN_PEAK && meanValley >= HeroSetConfig.CALIBRATION_MIN_VALLEY;
    }
}
