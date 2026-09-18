import Toybox.Lang;
import Toybox.Test;

// Shared steps for HeroSetRepCounterTest. A class, because the test runner
// treats every (:test) function as a test case.
(:test)
class HeroSetRepCounterHarness {

    static function newCounter(exercise as Lang.Symbol, arm as Lang.Number, release as Lang.Number) as HeroSetRepCounter {
        return new HeroSetRepCounter(arm, release, HeroSetConfig.SENSOR_SAMPLE_RATE, HeroSetConfig.SENSOR_COOLDOWN_MS, HeroSetRepCounter.integratesMotion(exercise));
    }

    static function defaultCounter(exercise as Lang.Symbol) as HeroSetRepCounter {
        return newCounter(exercise, HeroSetConfig.DEFAULT_ARM_THRESHOLD, HeroSetConfig.DEFAULT_RELEASE_THRESHOLD);
    }

    static function allTempos() as Lang.Array<Lang.Array<Lang.Number> > {
        return [HeroSetMotionFixture.fast(), HeroSetMotionFixture.medium(), HeroSetMotionFixture.slow(), HeroSetMotionFixture.verySlow()] as Lang.Array<Lang.Array<Lang.Number> >;
    }

    static function assertTenAtEveryTempo(exercise as Lang.Symbol, arm as Lang.Number, release as Lang.Number) as Void {
        var tempos = allTempos();
        for (var t = 0; t < tempos.size(); t++) {
            Test.assertEqual(HeroSetMotionFixture.reps(newCounter(exercise, arm, release), exercise, 10, tempos[t]), 10);
        }
    }

    // Mirrors HeroSetCalibrationView: provisional thresholds, mean swing per
    // counted cycle, fitted thresholds. Returns [arm, release].
    static function calibrate(exercise as Lang.Symbol, tempo as Lang.Array<Lang.Number>) as Lang.Array<Lang.Number> {
        var counter = newCounter(exercise, HeroSetConfig.CALIBRATION_SAMPLE_ARM, HeroSetConfig.CALIBRATION_SAMPLE_RELEASE);
        var peakSum = 0.0;
        var valleySum = 0.0;
        var cycles = 0;
        for (var r = 0; r < HeroSetConfig.CALIBRATION_REQUIRED_CYCLES; r++) {
            if (HeroSetMotionFixture.reps(counter, exercise, 1, tempo) > 0) {
                cycles += 1;
                peakSum += counter.getLastCyclePeak();
                valleySum += counter.getLastCycleValley();
            }
        }
        Test.assertEqual(cycles, HeroSetConfig.CALIBRATION_REQUIRED_CYCLES);
        var meanPeak = (peakSum / cycles).toNumber();
        var meanValley = (valleySum / cycles).toNumber();
        Test.assert(HeroSetCalibration.isUsable(cycles, meanPeak, meanValley));
        return [HeroSetCalibration.armThresholdFrom(meanPeak), HeroSetCalibration.releaseThresholdFrom(meanValley)] as Lang.Array<Lang.Number>;
    }
}
