import Toybox.Lang;
import Toybox.Test;

(:test)
function calendarDayNumbers(logger as Test.Logger) as Boolean {
    Test.assertEqual(SunWindowCalendar.dayNumber(1970, 1, 1), 0);
    Test.assertEqual(SunWindowCalendar.dayNumber(2000, 1, 1), SunWindowConfig.J2000_DAY_NUMBER);
    Test.assertEqual(SunWindowCalendar.dayNumber(2026, 3, 1) - SunWindowCalendar.dayNumber(2026, 2, 28), 1);
    Test.assertEqual(SunWindowCalendar.dayNumber(2028, 3, 1) - SunWindowCalendar.dayNumber(2028, 2, 28), 2);   // a leap year
    Test.assert(SunWindowCalendar.isValid(2026, 10, 5));
    Test.assert(!SunWindowCalendar.isValid(2026, 2, 29));
    return true;
}

// The offset comes from the local and UTC readings of the same instant, day numbers included, so +14:00 and -10:00
// (the same clock time, a day apart) cannot be confused and no offset is wrapped.
(:test)
function localOffsetFromTwoReadings(logger as Test.Logger) as Boolean {
    Test.assertEqual(SunWindowLocalTime.offsetBetween(100, 600, 100, 420), 180);                  // UTC+3, same day
    Test.assertEqual(SunWindowLocalTime.offsetBetween(101, 30, 100, 1410), 60);                   // local is already tomorrow
    Test.assertEqual(SunWindowLocalTime.offsetBetween(100, 1410, 101, 30), -60);                  // local still yesterday
    Test.assertEqual(SunWindowLocalTime.offsetBetween(101, 0, 100, 10 * 60), 840);                // UTC+14: local midnight, UTC 10:00 the day before
    Test.assertEqual(SunWindowLocalTime.offsetBetween(100, 6 * 60, 100, 20 * 60), -840);          // UTC-14: local 06:00, UTC 20:00 the same day
    return true;
}

(:test)
function clockText(logger as Test.Logger) as Boolean {
    Test.assertEqual(SunWindowClock.text(626, true), "10:26");
    Test.assertEqual(SunWindowClock.text(626, false), "10:26");
    Test.assertEqual(SunWindowClock.text(976, false), "4:16");
    Test.assertEqual(SunWindowClock.text(0, false), "12:00");
    Test.assertEqual(SunWindowClock.text(65, true), "01:05");
    Test.assertEqual(SunWindowClock.text(-5, true), "23:55");        // wraps
    Test.assertEqual(SunWindowClock.text(1445, true), "00:05");
    Test.assertEqual(SunWindowClock.range(626, 975, true), "10:26-16:15");
    Test.assertEqual(SunWindowClock.range(626, 975, false), "10:26a-4:15p");
    Test.assertEqual(SunWindowClock.range(5, 1380, false), "12:05a-11:00p");
    return true;
}

(:test)
function placeRoundsToTenthOfADegree(logger as Test.Logger) as Boolean {
    var place = SunWindowPlace.pick([[51.5074, -0.1278]] as Array<Array<Float> or Null>);
    Test.assert(place != null);
    if (place != null) {
        Test.assertMessage((place[0] - 51.5).abs() < 0.0001, "lat " + place[0]);
        Test.assertMessage((place[1] + 0.1).abs() < 0.0001, "lon " + place[1]);
    }
    return true;
}

(:test)
function placeUsability(logger as Test.Logger) as Boolean {
    Test.assert(SunWindowPlace.isUsable(51.5, -0.12));
    Test.assert(SunWindowPlace.isUsable(0.0, 10.0));    // on the equator is a place
    Test.assert(SunWindowPlace.isUsable(-90.0, 179.9));
    Test.assert(!SunWindowPlace.isUsable(0.0, 0.0));    // no-fix placeholder
    Test.assert(!SunWindowPlace.isUsable(90.5, 0.0));
    Test.assert(!SunWindowPlace.isUsable(10.0, -181.0));
    Test.assert(!SunWindowPlace.isUsable(10.0, 180.0));  // a reported placeholder (D6 says whether the watch does it)
    return true;
}

// Replace only when more than 0.1 degree from the saved place, on either axis.
(:test)
function placeReplaceHysteresis(logger as Test.Logger) as Boolean {
    var saved = [51.5, -0.1] as Array<Float>;
    Test.assert(SunWindowPlace.shouldReplace(null, [51.5, -0.1] as Array<Float>));
    Test.assert(!SunWindowPlace.shouldReplace(saved, [51.5, -0.1] as Array<Float>));
    Test.assert(!SunWindowPlace.shouldReplace(saved, [51.56, -0.13] as Array<Float>));
    Test.assert(SunWindowPlace.shouldReplace(saved, [51.65, -0.1] as Array<Float>));
    Test.assert(SunWindowPlace.shouldReplace(saved, [51.5, 0.05] as Array<Float>));
    return true;
}

// Whatever Storage returns, only two usable numbers come back, and exactly what SunWindowSources writes ([lat, lon]) is read.
(:test)
function placeFromStorageTrustsNothing(logger as Test.Logger) as Boolean {
    Test.assert(SunWindowPlace.fromStorage(null) == null);
    Test.assert(SunWindowPlace.fromStorage("place") == null);
    Test.assert(SunWindowPlace.fromStorage([1.0] as Array<Float>) == null);
    Test.assert(SunWindowPlace.fromStorage([1.0, 2.0, 1234] as Array<Numeric>) == null);   // a three-element value is not ours
    Test.assert(SunWindowPlace.fromStorage(["a", 2.0] as Array<String or Float>) == null);
    Test.assert(SunWindowPlace.fromStorage([null, 2.0] as Array<Float or Null>) == null);
    Test.assert(SunWindowPlace.fromStorage([95.0, 2.0] as Array<Float>) == null);
    var written = SunWindowPlace.pick([[54.687, 25.28]] as Array<Array<Float> or Null>);
    Test.assert(written != null);
    if (written != null) {
        var back = SunWindowPlace.fromStorage([written[0], written[1]] as Array<Float>);
        Test.assert(back != null);
    }
    Test.assert(SunWindowPlace.fromStorage([51, -1] as Array<Number>) != null);   // whole degrees saved as Numbers
    return true;
}

// Only a UV reading under 3 demotes; a null is never a reason; cloud counts only when the D2 fallback is on.
(:test)
function weatherDemotionTruthTable(logger as Test.Logger) as Boolean {
    Test.assert(!SunWindowWeather.demotes([null, null] as Array<Numeric or Null>));
    Test.assert(SunWindowWeather.demotes([2.9, null] as Array<Numeric or Null>));
    Test.assert(SunWindowWeather.demotes([0.0, 0] as Array<Numeric or Null>));
    Test.assert(!SunWindowWeather.demotes([3.0, null] as Array<Numeric or Null>));
    Test.assert(!SunWindowWeather.demotes([8.0, 100] as Array<Numeric or Null>) || SunWindowConfig.USE_CLOUD_FALLBACK);
    Test.assert(!SunWindowWeather.demotes([null, 100] as Array<Numeric or Null>) || SunWindowConfig.USE_CLOUD_FALLBACK);
    Test.assert(SunWindowWeather.known([0.0, null] as Array<Numeric or Null>));
    Test.assert(!SunWindowWeather.known([null, null] as Array<Numeric or Null>));
    return true;
}
