import Toybox.Lang;
import Toybox.System;
import Toybox.Test;

// Learning from saved counts (ADR-040) on synthetic swing traces: each
// number is one full swing of that size (up to +a, down to -a, back to 0).
// Simulator evidence only: which habits real wrists have is for gate 2.
(:test)
class HeroSetLearnerHarness {

    static function trace(swings as Lang.Array<Lang.Number>) as HeroSetSwingTrace {
        var trace = new HeroSetSwingTrace(HeroSetConfig.SENSOR_COOLDOWN_MS * HeroSetConfig.SENSOR_SAMPLE_RATE / 1000);
        var n = 0;
        for (var s = 0; s < swings.size(); s++) {
            var a = swings[s].toFloat();
            var shape = [0.0, a, -a, 0.0] as Lang.Array<Lang.Float>;
            var steps = [6, 12, 6] as Lang.Array<Lang.Number>;
            for (var leg = 0; leg < 3; leg++) {
                for (var i = 0; i < steps[leg]; i++) {
                    trace.feed(shape[leg] + (shape[leg + 1] - shape[leg]) * i / steps[leg], n);
                    n += 1;
                }
            }
        }
        trace.feed(0.0, n);
        return trace;
    }

    // Saves the same set `times` in a row, as a user repeating it would.
    static function learn(state as Lang.Array<Lang.Float>, swings as Lang.Array<Lang.Number>, saved as Lang.Number, times as Lang.Number) as Lang.Array<Lang.Float> {
        for (var i = 0; i < times; i++) {
            var next = HeroSetThresholdLearner.updated(state, trace(swings), saved);
            Test.assert(next != null);
            state = next as Lang.Array<Lang.Float>;
        }
        return state;
    }

    static function repeated(size as Lang.Number, count as Lang.Number) as Lang.Array<Lang.Number> {
        var swings = [] as Lang.Array<Lang.Number>;
        for (var i = 0; i < count; i++) {
            swings.add(size);
        }
        return swings;
    }

    // What the workout screen would hand the picker for this set.
    static function finishedCount(state as Lang.Array<Lang.Float>, swings as Lang.Array<Lang.Number>) as Lang.Number {
        var count = trace(swings).countAt(HeroSetThresholdLearner.threshold(state).toFloat());
        return HeroSetThresholdLearner.dropsLastRep(state) && count > 0 ? count - 1 : count;
    }
}

(:test)
function freshLearnerStartsAtTheDefault(logger as Test.Logger) as Lang.Boolean {
    var state = HeroSetThresholdLearner.initialState();
    var threshold = HeroSetThresholdLearner.threshold(state);
    Test.assert(threshold > HeroSetConfig.DEFAULT_THRESHOLD * 0.85 && threshold < HeroSetConfig.DEFAULT_THRESHOLD * 1.15);
    Test.assert(!HeroSetThresholdLearner.dropsLastRep(state));
    return true;
}

// Gentle reps below the default: the fresh detector misses every one, the
// corrections teach it to see them.
(:test)
function learnsToSeeSmallReps(logger as Test.Logger) as Lang.Boolean {
    var swings = [55, 50, 60, 52, 58, 50, 54, 56, 51, 53] as Lang.Array<Lang.Number>;
    var state = HeroSetThresholdLearner.initialState();
    Test.assertEqual(HeroSetLearnerHarness.finishedCount(state, swings), 0);
    state = HeroSetLearnerHarness.learn(state, swings, 10, 3);
    Test.assertEqual(HeroSetLearnerHarness.finishedCount(state, swings), 10);
    return true;
}

// Big reps with arm wobble between them that the default counts as reps.
(:test)
function learnsToIgnoreWobbleBetweenReps(logger as Test.Logger) as Lang.Boolean {
    var swings = [] as Lang.Array<Lang.Number>;
    for (var i = 0; i < 10; i++) {
        swings.add(300);
        swings.add(100);
    }
    var state = HeroSetThresholdLearner.initialState();
    Test.assertEqual(HeroSetLearnerHarness.finishedCount(state, swings), 20);
    state = HeroSetLearnerHarness.learn(state, swings, 10, 3);
    Test.assertEqual(HeroSetLearnerHarness.finishedCount(state, swings), 10);
    return true;
}

// Getting up after the last rep is the biggest swing of the set (the +1/+2
// seen on the watch, 2026-09-18). No threshold drops it alone; the learner
// must switch to dropping the last rep and keep seeing the smallest reps.
(:test)
function learnsThatTheLastSwingIsGettingUp(logger as Test.Logger) as Lang.Boolean {
    var swings = [150, 155, 160, 165, 170, 175, 180, 185, 190, 195, 500] as Lang.Array<Lang.Number>;
    var state = HeroSetThresholdLearner.initialState();
    Test.assertEqual(HeroSetLearnerHarness.finishedCount(state, swings), 11);
    state = HeroSetLearnerHarness.learn(state, swings, 10, 5);
    Test.assert(HeroSetThresholdLearner.dropsLastRep(state));
    Test.assertEqual(HeroSetLearnerHarness.finishedCount(state, swings), 10);
    var weakerSet = [120, 130, 200, 200, 200, 200, 200, 200, 200, 200, 480] as Lang.Array<Lang.Number>;
    Test.assertEqual(HeroSetLearnerHarness.finishedCount(state, weakerSet), 10);
    return true;
}

// One mistyped count after several agreeing sets must not undo them.
(:test)
function oneMistypedCountDoesNotUndoLearning(logger as Test.Logger) as Lang.Boolean {
    var swings = HeroSetLearnerHarness.repeated(55, 10);
    var state = HeroSetLearnerHarness.learn(HeroSetThresholdLearner.initialState(), swings, 10, 5);
    state = HeroSetLearnerHarness.learn(state, swings, 3, 1);
    Test.assertEqual(HeroSetLearnerHarness.finishedCount(state, swings), 10);
    return true;
}

// Reps the movement can't explain at any threshold (done without the
// watch, typed into this set) teach nothing.
(:test)
function unexplainedRepsAreNotLearned(logger as Test.Logger) as Lang.Boolean {
    var swings = HeroSetLearnerHarness.repeated(200, 5);
    var state = HeroSetThresholdLearner.initialState();
    Test.assert(HeroSetThresholdLearner.updated(state, HeroSetLearnerHarness.trace(swings), 20) == null);
    Test.assert(HeroSetThresholdLearner.updated(state, HeroSetLearnerHarness.trace(swings), 0) == null);
    return true;
}

// Learning runs when START saves the set: the longest trace it accepts (24
// replays of ~TRACE_MAX_POINTS) must finish inside the watchdog budget.
(:test)
function longestLearnableSetFinishes(logger as Test.Logger) as Lang.Boolean {
    var swings = HeroSetLearnerHarness.repeated(200, HeroSetConfig.TRACE_MAX_POINTS / 2 - 1);
    var trace = HeroSetLearnerHarness.trace(swings);
    Test.assert(trace.isComplete());
    var started = System.getTimer();
    Test.assert(HeroSetThresholdLearner.updated(HeroSetThresholdLearner.initialState(), trace, swings.size()) != null);
    logger.debug("learning from " + swings.size() + " reps took " + (System.getTimer() - started) + " ms");
    return true;
}
