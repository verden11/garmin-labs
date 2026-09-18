import Toybox.Lang;
import Toybox.Math;
import Toybox.Test;

// Accuracy on physically shaped traces (HeroSetMotionFixture, ADR-032).
// These are the simulator stand-in for launch gate 2, not proof of it: real
// wrists add movement the fixtures don't model.

(:test)
function pushupsCountTenAtEveryTempo(logger as Test.Logger) as Lang.Boolean {
    HeroSetRepCounterHarness.assertTenAtEveryTempo(:pushups, HeroSetConfig.DEFAULT_ARM_THRESHOLD, HeroSetConfig.DEFAULT_RELEASE_THRESHOLD);
    return true;
}

(:test)
function situpsCountTenAtEveryTempo(logger as Test.Logger) as Lang.Boolean {
    HeroSetRepCounterHarness.assertTenAtEveryTempo(:situps, HeroSetConfig.DEFAULT_ARM_THRESHOLD, HeroSetConfig.DEFAULT_RELEASE_THRESHOLD);
    return true;
}

// The watch counted 19/10: braking at the bottom and pushing up are two
// acceleration lobes of the same sign.
(:test)
function squatsCountOncePerRepAtEveryTempo(logger as Test.Logger) as Lang.Boolean {
    HeroSetRepCounterHarness.assertTenAtEveryTempo(:squats, HeroSetConfig.DEFAULT_ARM_THRESHOLD, HeroSetConfig.DEFAULT_RELEASE_THRESHOLD);
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
        var counter = HeroSetRepCounterHarness.newCounter(exercises[e], HeroSetConfig.CALIBRATION_SAMPLE_ARM, HeroSetConfig.CALIBRATION_SAMPLE_RELEASE);
        Test.assertEqual(HeroSetMotionFixture.idle(counter, 60 * HeroSetConfig.SENSOR_SAMPLE_RATE), 0);
    }
    return true;
}

// Calibrating with brisk reps must not set thresholds that slow reps can't
// reach. Before the squat height signal, squats calibrated fast counted 0/10
// slow ones.
(:test)
function calibrationFromFastRepsCountsEveryTempo(logger as Test.Logger) as Lang.Boolean {
    var exercises = [:pushups, :situps, :squats] as Lang.Array<Lang.Symbol>;
    for (var e = 0; e < exercises.size(); e++) {
        var fitted = HeroSetRepCounterHarness.calibrate(exercises[e], HeroSetMotionFixture.fast());
        HeroSetRepCounterHarness.assertTenAtEveryTempo(exercises[e], fitted[0], fitted[1]);
    }
    return true;
}

(:test)
function calibrationFromSlowRepsCountsEveryTempo(logger as Test.Logger) as Lang.Boolean {
    var exercises = [:pushups, :situps, :squats] as Lang.Array<Lang.Symbol>;
    for (var e = 0; e < exercises.size(); e++) {
        var fitted = HeroSetRepCounterHarness.calibrate(exercises[e], HeroSetMotionFixture.slow());
        HeroSetRepCounterHarness.assertTenAtEveryTempo(exercises[e], fitted[0], fitted[1]);
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

(:test)
function resetClearsPartialCycleState(logger as Test.Logger) as Lang.Boolean {
    var counter = HeroSetRepCounterHarness.defaultCounter(:situps);
    Test.assertEqual(HeroSetMotionFixture.reps(counter, :situps, 3, HeroSetMotionFixture.medium()), 3);
    // Tilt away and stop there: half a rep.
    for (var i = 0; i < 25; i++) {
        var angle = Math.toRadians(70.0 * i / 25.0);
        counter.feedSample((1000.0 * Math.sin(angle)).toNumber(), (-1000.0 * Math.cos(angle)).toNumber(), 0);
    }
    counter.reset();
    // Tilting back alone must not complete a rep begun before the reset.
    var afterReset = 0;
    for (var i = 25; i >= 0; i--) {
        var angle = Math.toRadians(70.0 * i / 25.0);
        if (counter.feedSample((1000.0 * Math.sin(angle)).toNumber(), (-1000.0 * Math.cos(angle)).toNumber(), 0)) {
            afterReset += 1;
        }
    }
    Test.assertEqual(afterReset, 0);
    return true;
}

// Squats integrate their signal, so reset also clears velocity and height:
// stale height from before an abandoned calibration can't swing a rep.
// Known limit (ADR-032): the height signal swings back past zero after any
// single up or down movement, so one isolated movement after a reset (or
// standing up from a kneel mid-set) can still count as a rep.
(:test)
function resetLeavesNoSquatHeightBehind(logger as Test.Logger) as Lang.Boolean {
    var counter = HeroSetRepCounterHarness.defaultCounter(:squats);
    Test.assertEqual(HeroSetMotionFixture.reps(counter, :squats, 3, HeroSetMotionFixture.fast()), 3);
    counter.reset();
    Test.assertEqual(HeroSetMotionFixture.idle(counter, 5 * HeroSetConfig.SENSOR_SAMPLE_RATE), 0);
    Test.assertEqual(HeroSetMotionFixture.reps(counter, :squats, 3, HeroSetMotionFixture.medium()), 3);
    return true;
}
