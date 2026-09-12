import Toybox.Lang;

// Calibration fits detection thresholds from counted cycles. The provisional
// SAMPLE_* thresholds are used DURING calibration so real cycles are caught;
// the fitted thresholds are half the mean cycle excursion, clamped to a safe
// range, and only stored when the session is strong enough.
class HeroSetCalibration {
    static function armThresholdFrom(meanPeak as Lang.Number, meanValley as Lang.Number) as Lang.Number {
        var half = meanPeak / 2;
        return half < 60 ? 60 : (half > 500 ? 500 : half);
    }

    static function releaseThresholdFrom(meanPeak as Lang.Number, meanValley as Lang.Number) as Lang.Number {
        var half = meanValley / 2;
        return half < 50 ? 50 : (half > 400 ? 400 : half);
    }

    static function isUsable(cycles as Lang.Number, meanPeak as Lang.Number, meanValley as Lang.Number) as Lang.Boolean {
        return cycles >= HeroSetConfig.CALIBRATION_REQUIRED_CYCLES && meanPeak >= HeroSetConfig.CALIBRATION_MIN_PEAK && meanValley >= HeroSetConfig.CALIBRATION_MIN_VALLEY;
    }
}
