import Toybox.Lang;
import Toybox.Test;

// Free-only readings tests (docs/decisions.md ADR-020, Free + Pro ladder, and ADR-021, Body Battery in Free). They use the
// helpers readingsState and readingsSky from TwoSunsReadingsTest.mc.

// Free: the Body Battery is Garmin's own number and nothing else (no history, so no curve and no stale state).
// A valid number is shown and fills the pill; null, "not worn" (127) and out-of-range are "--" with a hollow pill,
// never blank, never a word about the person (docs/decisions.md ADR-021, Body Battery in Free).
(:test, :free)
function freeBatteryIsTheComplicationOnly(logger as Test.Logger) as Boolean {
    var shown = readingsState(null, 62, true);
    Test.assertEqual(shown.batteryText, "62");
    Test.assertEqual(sunPresent(shown.batteryLevel), 62);
    Test.assert(shown.curve == null);
    Test.assert(!shown.batteryStale);
    var none = readingsState(null, null, true);
    Test.assertEqual(none.batteryText, "--");
    Test.assert(none.batteryLevel == null);
    Test.assert(none.curve == null);
    Test.assert(!none.batteryStale);
    Test.assertEqual(TwoSunsReadings.batteryColor(none), TwoSunsPalette.MUTED);
    Test.assertEqual(readingsState(null, 127, true).batteryText, "--");
    Test.assertEqual(readingsState(null, -1, true).batteryText, "--");
    Test.assertEqual(readingsState(null, 101, true).batteryText, "--");
    return true;
}

// Free: whatever a caller passes, there is no curve, no stale flag, no date row, no golden arc and the ring
// has noon at the top, so no Pro state is reachable through the settings or the readings.
(:test, :free)
function freeStateHasNoProState(logger as Test.Logger) as Boolean {
    var settings = new TwoSunsSettings({"Accent" => 1, "Orientation" => 1, "Golden" => 1, "Curve" => 1, "Date" => 1} as Dictionary);
    var time = new TwoSunsLocalTime(2026, 9, 27, 15 * 60 + 5, 60, 0);
    var state = TwoSunsReadings.build(settings, time, false, readingsSky(TwoSunsConfig.SKY_NO_DATA), null, 40, [] as Array<String>);
    Test.assertEqual(state.time, "3:05");
    Test.assertEqual(state.accent, TwoSunsPalette.ACCENTS[1]);
    Test.assertEqual(state.orientation, TwoSunsConfig.ORIENTATION_NOON_TOP);
    Test.assert(!state.goldenArc);
    Test.assert(!state.showDate);
    Test.assert(state.curve == null);
    Test.assert(!state.curveOn);   // no curve room either: Free's band is the centred pair (ADR-028 amendment 2026-10-08)
    Test.assert(!state.batteryStale);
    Test.assertEqual(state.skyLine, "No sun data");
    return true;
}
