import Toybox.Lang;
import Toybox.Test;
import Toybox.Time;
import Toybox.Time.Gregorian;

// The small date line ("Fri 25 Dec 2026") formats a Moment built from the
// target y/m/d. Gregorian.moment() reads its fields as UTC, so it must be read
// back with utcInfo(); info() would shift the day in any time zone west of UTC.
// (Run in the simulator's own zone, UTC+2/3, on 2026-09-26; the west-of-UTC case
// is covered by this reasoning, not yet by a run: see plan phase 2.)
(:test)
function targetDateFormatsWithoutShift(logger as Test.Logger) as Boolean {
    var moment = Gregorian.moment({:year => 2026, :month => 12, :day => 25});
    var info = Gregorian.utcInfo(moment, Time.FORMAT_SHORT);
    Test.assertEqual(info.year, 2026);
    Test.assertEqual(info.month, 12);
    Test.assertEqual(info.day, 25);
    Test.assertEqual(info.day_of_week, Gregorian.DAY_FRIDAY);
    // The FORMAT_MEDIUM words (day_of_week "Fri", month "Dec" in English) follow the device
    // language, so they are not asserted: this test must pass in every simulator language.
    var words = Gregorian.utcInfo(moment, Time.FORMAT_MEDIUM);
    Test.assert(words.day_of_week instanceof String && words.month instanceof String);
    return true;
}
