import Toybox.Lang;
import Toybox.Math;
import Toybox.Test;

// Feeds a synthetic push-up waveform: az = 1000 + 300*sin(theta),
// ay = 200*cos(theta). The L2 magnitude swings roughly 1020 baseline,
// +280 peak, -320 valley. Returns the number of counted cycles.
function feedFixture(counter as HeroSetRepCounter, cycles as Lang.Number, samplesPerCycle as Lang.Number) as Lang.Number {
    var theta = 0.0;
    var step = (2.0 * 3.14159) / samplesPerCycle.toFloat();
    var count = 0;
    for (var c = 0; c < cycles; c++) {
        for (var s = 0; s < samplesPerCycle; s++) {
            var ay = 200.0 * Math.cos(theta);
            var az = 1000.0 + 300.0 * Math.sin(theta);
            if (counter.feedSample(0, ay.toNumber(), az.toNumber())) {
                count += 1;
            }
            theta = theta + step;
        }
    }
    return count;
}

(:test)
function magnitudeBaselineRemovesGravity(logger as Test.Logger) as Lang.Boolean {
    var counter = new HeroSetRepCounter(45, 30, 25, 600);
    for (var i = 0; i < 200; i++) {
        Test.assert(!counter.feedSample(0, 0, 1000));
    }
    return true;
}

(:test)
function countsSyntheticTenRepCycle(logger as Test.Logger) as Lang.Boolean {
    var counter = new HeroSetRepCounter(45, 30, 25, 600);
    var count = feedFixture(counter, 10, 30);
    for (var i = 0; i < 5; i++) {
        counter.feedSample(0, 0, 1000);
    }
    Test.assertEqual(count, 10);
    return true;
}

(:test)
function fittedThresholdsRecountTheSameFixture(logger as Test.Logger) as Lang.Boolean {
    var counter = new HeroSetRepCounter(45, 30, 25, 600);
    var peakSum = 0.0;
    var valleySum = 0.0;
    var count = 0;
    var theta = 0.0;
    var step = (2.0 * 3.14159) / 30.0;
    for (var c = 0; c < 10; c++) {
        for (var s = 0; s < 30; s++) {
            var ay = 200.0 * Math.cos(theta);
            var az = 1000.0 + 300.0 * Math.sin(theta);
            if (counter.feedSample(0, ay.toNumber(), az.toNumber())) {
                count += 1;
                peakSum += counter.getLastCyclePeak();
                valleySum += counter.getLastCycleValley();
            }
            theta = theta + step;
        }
    }
    Test.assertEqual(count, 10);
    var meanPeak = peakSum / 10;
    var meanValley = valleySum / 10;
    var arm = HeroSetCalibration.armThresholdFrom(meanPeak.toNumber(), meanValley.toNumber());
    var release = HeroSetCalibration.releaseThresholdFrom(meanPeak.toNumber(), meanValley.toNumber());
    var fitted = new HeroSetRepCounter(arm, release, 25, 600);
    Test.assertEqual(feedFixture(fitted, 10, 30), 10);
    return true;
}

(:test)
function noiseDoesNotCount(logger as Test.Logger) as Lang.Boolean {
    var counter = new HeroSetRepCounter(45, 30, 25, 600);
    for (var i = 0; i < 500; i++) {
        var delta = ((i * 7919) % 41) - 20;
        Test.assert(!counter.feedSample(0, 0, 1000 + delta));
    }
    return true;
}

(:test)
function slowDriftWithoutTurningPointsDoesNotCount(logger as Test.Logger) as Lang.Boolean {
    var counter = new HeroSetRepCounter(45, 30, 25, 600);
    counter.feedSample(0, 0, 1000);
    for (var i = 1; i <= 200; i++) {
        Test.assert(!counter.feedSample(0, 0, 1000 + i));
    }
    return true;
}

(:test)
function cooldownBlocksRapidDoubleCount(logger as Test.Logger) as Lang.Boolean {
    var counter = new HeroSetRepCounter(45, 30, 25, 600);
    var count = feedFixture(counter, 10, 10);
    Test.assert(count >= 1);
    Test.assert(count < 10);
    return true;
}

(:test)
function resetClearsPartialCycleState(logger as Test.Logger) as Lang.Boolean {
    var counter = new HeroSetRepCounter(45, 30, 25, 600);
    Test.assertEqual(feedFixture(counter, 1, 30), 1);

    // Half of the next cycle: theta continues from 2*pi to 3*pi.
    var theta = 2.0 * 3.14159;
    var step = (2.0 * 3.14159) / 30.0;
    for (var s = 0; s < 15; s++) {
        var ay = 200.0 * Math.cos(theta);
        var az = 1000.0 + 300.0 * Math.sin(theta);
        counter.feedSample(0, ay.toNumber(), az.toNumber());
        theta = theta + step;
    }

    counter.reset();

    // Remaining half: theta continues from 3*pi to 4*pi.
    var afterReset = 0;
    for (var s = 0; s < 15; s++) {
        var ay = 200.0 * Math.cos(theta);
        var az = 1000.0 + 300.0 * Math.sin(theta);
        if (counter.feedSample(0, ay.toNumber(), az.toNumber())) {
            afterReset += 1;
        }
        theta = theta + step;
    }
    Test.assertEqual(afterReset, 0);
    return true;
}
