import Toybox.Lang;
import Toybox.Test;

// Pro only: the history buckets need SensorHistory, which the Free build does not have (docs/decisions.md ADR-020, Free + Pro ladder).
// Epoch seconds used as "now" in these tests; only differences matter.
(:pro, :debug)
const BATTERY_TEST_NOW = 1800000000;

(:pro, :debug)
function batteryCurve(values as Array<Numeric or Null>, agesMinutes as Array<Number>) as TwoSunsBatteryCurve {
    var whens = [] as Array<Number or Null>;
    for (var i = 0; i < agesMinutes.size(); i++) {
        whens.add(BATTERY_TEST_NOW - agesMinutes[i] * TwoSunsConfig.SECONDS_PER_MINUTE);
    }
    return TwoSunsBattery.build(values, whens, BATTERY_TEST_NOW);
}

(:pro, :debug)
function batteryFilled(curve as TwoSunsBatteryCurve) as Number {
    var filled = 0;
    for (var i = 0; i < curve.buckets.size(); i++) {
        if (curve.buckets[i] != null) {
            filled++;
        }
    }
    return filled;
}

(:test, :pro)
function batteryEmptyHasNothing(logger as Test.Logger) as Boolean {
    var curve = batteryCurve([] as Array<Numeric or Null>, [] as Array<Number>);
    Test.assert(curve.current == null);
    Test.assert(curve.newestWhen == null);
    Test.assert(!curve.stale);
    Test.assertEqual(batteryFilled(curve), 0);
    Test.assertEqual(curve.buckets.size(), TwoSunsConfig.BATTERY_BUCKETS);
    return true;
}

// Null, negative, above 100 and 127 (not worn) are dropped; 0 and 100 are real.
(:test, :pro)
function batteryDropsInvalidValues(logger as Test.Logger) as Boolean {
    var values = [null, -1, 101, 127, 250.5, 0, 100] as Array<Numeric or Null>;
    var curve = batteryCurve(values, [10, 20, 30, 40, 50, 60, 70] as Array<Number>);
    Test.assertEqual(batteryFilled(curve), 2);
    Test.assertEqual(sunPresent(curve.current), 0);   // the newest valid is the 0 at 60 minutes ago
    var notWorn = batteryCurve([127, 127] as Array<Numeric or Null>, [5, 6] as Array<Number>);
    Test.assert(notWorn.current == null);
    return true;
}

(:test, :pro)
function batteryOneSampleIsCurrent(logger as Test.Logger) as Boolean {
    var curve = batteryCurve([61] as Array<Numeric or Null>, [3] as Array<Number>);
    Test.assertEqual(sunPresent(curve.current), 61);
    Test.assertEqual(batteryFilled(curve), 1);
    Test.assert(!curve.stale);
    return true;
}

// Floats round to the nearest whole number.
(:test, :pro)
function batteryRoundsFloats(logger as Test.Logger) as Boolean {
    var curve = batteryCurve([61.6, 40.4] as Array<Numeric or Null>, [1, 20] as Array<Number>);
    Test.assertEqual(sunPresent(curve.current), 62);
    return true;
}

// Samples arrive newest first from SensorHistory, but nothing here may depend on it.
(:test, :pro)
function batteryOrderDoesNotMatter(logger as Test.Logger) as Boolean {
    var newestFirst = batteryCurve([70, 60, 50] as Array<Numeric or Null>, [5, 65, 125] as Array<Number>);
    var oldestFirst = batteryCurve([50, 60, 70] as Array<Numeric or Null>, [125, 65, 5] as Array<Number>);
    Test.assertEqual(sunPresent(newestFirst.current), 70);
    Test.assertEqual(sunPresent(oldestFirst.current), 70);
    for (var i = 0; i < TwoSunsConfig.BATTERY_BUCKETS; i++) {
        Test.assert(newestFirst.buckets[i] == oldestFirst.buckets[i]);
    }
    return true;
}

// The newest sample in a 15-minute bucket is the one drawn.
(:test, :pro)
function batteryBucketKeepsNewest(logger as Test.Logger) as Boolean {
    var curve = batteryCurve([30, 40] as Array<Numeric or Null>, [2, 1] as Array<Number>);
    Test.assertEqual(batteryFilled(curve), 1);
    Test.assertEqual(sunPresent(curve.buckets[TwoSunsConfig.BATTERY_BUCKETS - 1]), 40);
    return true;
}

// A gap of hours leaves empty buckets in the middle, and the ends land in the first and last bucket.
(:test, :pro)
function batteryGapLeavesHoles(logger as Test.Logger) as Boolean {
    var curve = batteryCurve([80, 20] as Array<Numeric or Null>, [1430, 5] as Array<Number>);
    Test.assertEqual(batteryFilled(curve), 2);
    Test.assertEqual(sunPresent(curve.buckets[0]), 80);
    Test.assertEqual(sunPresent(curve.buckets[TwoSunsConfig.BATTERY_BUCKETS - 1]), 20);
    return true;
}

// Older than 24 hours is outside the curve; a sample stamped a few minutes ahead is clock skew and kept
// in the last bucket; one stamped an hour ahead is dropped.
(:test, :pro)
function batteryWindowEdges(logger as Test.Logger) as Boolean {
    var old = batteryCurve([55] as Array<Numeric or Null>, [1441] as Array<Number>);
    Test.assert(old.current == null);
    var skew = batteryCurve([55] as Array<Numeric or Null>, [-4] as Array<Number>);
    Test.assertEqual(sunPresent(skew.buckets[TwoSunsConfig.BATTERY_BUCKETS - 1]), 55);
    var future = batteryCurve([55] as Array<Numeric or Null>, [-60] as Array<Number>);
    Test.assert(future.current == null);
    var atStart = batteryCurve([55] as Array<Numeric or Null>, [1440] as Array<Number>);
    Test.assertEqual(sunPresent(atStart.buckets[0]), 55);
    return true;
}

// Newest sample older than 60 minutes: the value is still there, flagged stale.
(:test, :pro)
function batteryStaleAfterAnHour(logger as Test.Logger) as Boolean {
    var fresh = batteryCurve([50] as Array<Numeric or Null>, [60] as Array<Number>);
    Test.assert(!fresh.stale);
    var stale = batteryCurve([50] as Array<Numeric or Null>, [61] as Array<Number>);
    Test.assert(stale.stale);
    Test.assertEqual(sunPresent(stale.current), 50);
    return true;
}

// Mismatched arrays never read past the shorter one.
(:test, :pro)
function batteryMismatchedArrays(logger as Test.Logger) as Boolean {
    var curve = TwoSunsBattery.build([10, 20, 30] as Array<Numeric or Null>,
        [BATTERY_TEST_NOW - 60] as Array<Number or Null>, BATTERY_TEST_NOW);
    Test.assertEqual(sunPresent(curve.current), 10);
    return true;
}

// A null timestamp drops that sample only.
(:test, :pro)
function batteryNullWhenIsDropped(logger as Test.Logger) as Boolean {
    var curve = TwoSunsBattery.build([10, 20] as Array<Numeric or Null>,
        [null, BATTERY_TEST_NOW - 60] as Array<Number or Null>, BATTERY_TEST_NOW);
    Test.assertEqual(sunPresent(curve.current), 20);
    return true;
}
