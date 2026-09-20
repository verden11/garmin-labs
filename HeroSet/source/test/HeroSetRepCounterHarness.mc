import Toybox.Lang;
import Toybox.Test;

// Shared steps for HeroSetRepCounterTest. A class, because the test runner
// treats every (:test) function as a test case.
(:test)
class HeroSetRepCounterHarness {

    static function newCounter(exercise as Lang.Symbol, threshold as Lang.Number) as HeroSetRepCounter {
        return new HeroSetRepCounter(threshold, HeroSetConfig.SENSOR_SAMPLE_RATE, HeroSetConfig.SENSOR_COOLDOWN_MS, HeroSetRepCounter.integratesMotion(exercise));
    }

    static function defaultCounter(exercise as Lang.Symbol) as HeroSetRepCounter {
        return newCounter(exercise, HeroSetConfig.DEFAULT_THRESHOLD);
    }

    static function allTempos() as Lang.Array<Lang.Array<Lang.Number> > {
        return [HeroSetMotionFixture.fast(), HeroSetMotionFixture.medium(), HeroSetMotionFixture.slow(), HeroSetMotionFixture.verySlow()] as Lang.Array<Lang.Array<Lang.Number> >;
    }

    static function assertTenAtEveryTempo(exercise as Lang.Symbol, threshold as Lang.Number) as Void {
        var tempos = allTempos();
        for (var t = 0; t < tempos.size(); t++) {
            Test.assertEqual(HeroSetMotionFixture.reps(newCounter(exercise, threshold), exercise, 10, tempos[t]), 10);
        }
    }
}
