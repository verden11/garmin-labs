import Toybox.Lang;
import Toybox.Test;

// Hand-written checks around the generated USNO reference tests. The tests are Pro only (TwoSunsSun is not compiled into
// Free: docs/decisions.md ADR-020, Free + Pro ladder); sunPresent is shared with the tests that run in both tiers.

(:debug)
function sunPresent(value as Number or Null) as Number {
    if (value == null) {
        Test.assertMessage(false, "expected a time, got null");
        return 0;
    }
    return value;
}

(:test, :pro)
function sunDayOrderIsSensible(logger as Test.Logger) as Boolean {
    // London, 27 September 2026, BST (+60): rise < noon < set, civil twilight outside them, golden hour inside.
    var sun = TwoSunsSun.compute(2026, 9, 27, 51.5, -0.12, 60);
    Test.assertEqual(sun.kind, TwoSunsConfig.SUN_NORMAL);
    var times = [sunPresent(sun.civilBegin), sunPresent(sun.rise), sunPresent(sun.goldenMorningEnd), sun.noon,
                 sunPresent(sun.goldenEveningStart), sunPresent(sun.set), sunPresent(sun.civilEnd)] as Array<Number>;
    for (var i = 1; i < times.size(); i++) {
        Test.assertMessage(times[i - 1] < times[i], "order broke at " + i);
    }
    return true;
}

// A sunset after local midnight is a minute count above 1440, not wrapped (Reykjavik, 21 June).
(:test, :pro)
function sunsetAfterMidnightIsNotWrapped(logger as Test.Logger) as Boolean {
    var sun = TwoSunsSun.compute(2026, 6, 21, 64.15, -21.94, 0);
    Test.assert(sunPresent(sun.set) > TwoSunsConfig.MINUTES_PER_DAY);
    return true;
}

// The equator's day is about 12 hours all year: a check that Float rounding does not drift with the date.
(:test, :pro)
function equatorDayIsAboutTwelveHours(logger as Test.Logger) as Boolean {
    for (var month = 1; month <= 12; month++) {
        var sun = TwoSunsSun.compute(2026, month, 15, 0.0, 0.0, 0);
        var length = sunPresent(sun.set) - sunPresent(sun.rise);
        Test.assertMessage(length > 715 && length < 730, "month " + month + " length " + length);
    }
    return true;
}

// Far future and far past years stay inside the Float budget (days since J2000, not a Julian date).
(:test, :pro)
function distantYearsStillGiveASensibleNoon(logger as Test.Logger) as Boolean {
    var years = [2001, 2038, 2060, 2100] as Array<Number>;
    for (var i = 0; i < years.size(); i++) {
        var sun = TwoSunsSun.compute(years[i], 6, 21, 51.5, 0.0, 60);
        Test.assertMessage(sun.noon > 12 * 60 + 55 && sun.noon < 13 * 60 + 15, "year " + years[i] + " noon " + sun.noon);
    }
    return true;
}
