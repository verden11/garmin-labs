import Toybox.Lang;
import Toybox.Math;
import Toybox.Test;

// Accuracy on physically shaped traces (HeroSetMotionFixture, ADR-032).
// These are the simulator stand-in for launch gate 2, not proof of it: real
// wrists add movement the fixtures don't model.

(:test)
function pushupsCountTenAtEveryTempo(logger as Test.Logger) as Lang.Boolean {
    HeroSetRepCounterHarness.assertTenAtEveryTempo(:pushups, HeroSetConfig.DEFAULT_THRESHOLD);
    return true;
}

(:test)
function situpsCountTenAtEveryTempo(logger as Test.Logger) as Lang.Boolean {
    HeroSetRepCounterHarness.assertTenAtEveryTempo(:situps, HeroSetConfig.DEFAULT_THRESHOLD);
    return true;
}

// The watch counted 19/10: braking at the bottom and pushing up are two
// acceleration lobes of the same sign.
(:test)
function squatsCountOncePerRepAtEveryTempo(logger as Test.Logger) as Lang.Boolean {
    HeroSetRepCounterHarness.assertTenAtEveryTempo(:squats, HeroSetConfig.DEFAULT_THRESHOLD);
    return true;
}

(:test)
function slowingRepsStillCount(logger as Test.Logger) as Lang.Boolean {
    var exercises = [:pushups, :situps, :squats] as Lang.Array<Lang.Symbol>;
    for (var e = 0; e < exercises.size(); e++) {
        Test.assertEqual(HeroSetMotionFixture.slowingReps(HeroSetRepCounterHarness.defaultCounter(exercises[e]), exercises[e], 10), 10);
    }
    return true;
}

(:test)
function stillWristDoesNotCount(logger as Test.Logger) as Lang.Boolean {
    var exercises = [:pushups, :situps, :squats] as Lang.Array<Lang.Symbol>;
    for (var e = 0; e < exercises.size(); e++) {
        var counter = HeroSetRepCounterHarness.newCounter(exercises[e], HeroSetConfig.LEARN_MIN_THRESHOLD.toNumber());
        Test.assertEqual(HeroSetMotionFixture.idle(counter, 60 * HeroSetConfig.SENSOR_SAMPLE_RATE), 0);
    }
    return true;
}

// Learning replays the set's trace instead of re-running the detector, so
// the replay must count what the detector counted, at any threshold.
(:test)
function traceReplayCountsWhatTheDetectorCounted(logger as Test.Logger) as Lang.Boolean {
    var exercises = [:pushups, :situps, :squats] as Lang.Array<Lang.Symbol>;
    var thresholds = [40, HeroSetConfig.DEFAULT_THRESHOLD, 150] as Lang.Array<Lang.Number>;
    var tempos = HeroSetRepCounterHarness.allTempos();
    for (var e = 0; e < exercises.size(); e++) {
        for (var h = 0; h < thresholds.size(); h++) {
            for (var t = 0; t < tempos.size(); t++) {
                var counter = HeroSetRepCounterHarness.newCounter(exercises[e], thresholds[h]);
                var live = HeroSetMotionFixture.reps(counter, exercises[e], 10, tempos[t]);
                Test.assertEqual(counter.getTrace().countAt(thresholds[h].toFloat()), live);
            }
        }
    }
    return true;
}

// Knocking the watch on the floor mid-set rings for a moment; a half-rep
// can't be shorter than SENSOR_COOLDOWN_MS, so the knock can't be a rep.
(:test)
function knockDoesNotCount(logger as Test.Logger) as Lang.Boolean {
    var counter = HeroSetRepCounterHarness.defaultCounter(:pushups);
    Test.assertEqual(HeroSetMotionFixture.idle(counter, 50), 0);
    var ring = [900, -800, 600, -500, 300, -200] as Lang.Array<Lang.Number>;
    var count = 0;
    for (var i = 0; i < ring.size(); i++) {
        if (counter.feedSample(ring[i], -1000, ring[i] / 2)) {
            count += 1;
        }
    }
    Test.assertEqual(count + HeroSetMotionFixture.idle(counter, 50), 0);
    return true;
}

(:test)
function slowPostureDriftDoesNotCount(logger as Test.Logger) as Lang.Boolean {
    var counter = HeroSetRepCounterHarness.defaultCounter(:pushups);
    for (var i = 0; i <= 500; i++) {
        var angle = Math.toRadians(30.0 * i / 500.0);
        Test.assert(!counter.feedSample((1000.0 * Math.sin(angle)).toNumber(), (-1000.0 * Math.cos(angle)).toNumber(), 0));
    }
    return true;
}
