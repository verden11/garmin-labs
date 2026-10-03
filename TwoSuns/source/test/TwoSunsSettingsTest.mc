import Toybox.Application;
import Toybox.Lang;
import Toybox.Test;

// The phone can hand the face anything (missing keys, old types, a list value no longer offered).
// Every bad value must fall back to the working default. The five-setting tests are Pro only (docs/decisions.md ADR-020,
// Free + Pro ladder); Free has the tests at the end of this file and the accent tests in TwoSunsAccentTest.
(:test, :pro)
function badSettingsFallBackToDefaults(logger as Test.Logger) as Boolean {
    var s = new TwoSunsSettings({"Accent" => 6, "Orientation" => 2, "Golden" => -1, "Curve" => "x", "Date" => 2.5, "Weather" => 7, "Battery" => -3} as Dictionary);
    Test.assertEqual(s.accent, 0);
    Test.assertEqual(s.orientation, TwoSunsConfig.ORIENTATION_NOON_TOP);
    Test.assert(!s.golden);
    Test.assert(s.curve);
    Test.assert(s.date);
    Test.assert(s.weather);
    Test.assert(s.battery);
    return true;
}

(:test, :pro)
function missingSettingsFallBackToDefaults(logger as Test.Logger) as Boolean {
    var s = new TwoSunsSettings({} as Dictionary);
    Test.assertEqual(s.accent, 0);
    Test.assertEqual(s.orientation, TwoSunsConfig.ORIENTATION_NOON_TOP);
    Test.assert(!s.golden);
    Test.assert(s.curve);
    Test.assert(s.date);
    Test.assert(s.weather);
    Test.assert(s.battery);
    return true;
}

(:test, :pro)
function goodSettingsPassThrough(logger as Test.Logger) as Boolean {
    var s = new TwoSunsSettings({"Accent" => 5, "Orientation" => 1, "Golden" => 1, "Curve" => 0, "Date" => 0, "Weather" => 0, "Battery" => 0} as Dictionary);
    Test.assertEqual(s.accent, 5);
    Test.assertEqual(s.orientation, TwoSunsConfig.ORIENTATION_MIDNIGHT_TOP);
    Test.assert(s.golden);
    Test.assert(!s.curve);
    Test.assert(!s.date);
    Test.assert(!s.weather);
    Test.assert(!s.battery);
    return true;
}

// The palette has one colour for each offered accent, in the same order as the settings list
// (tools/gen_settings.py ACCENTS): sky, mint, autumn, violet, pink, winter. Sky is the default (index 0):
// blue carries no "status" meaning, unlike the old amber default.
(:test)
function accentsAreInTheSettingsOrder(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsPalette.ACCENTS.size(), TwoSunsConfig.ACCENT_COUNT);
    var expected = [0x55AAFF, 0x55FFAA, 0xFFAA00, 0xAA55FF, 0xFF55AA, 0xFFFFFF] as Array<Number>;
    for (var i = 0; i < expected.size(); i++) {
        Test.assertEqual(TwoSunsPalette.ACCENTS[i], expected[i]);
    }
    return true;
}

// The real Properties read works on the running app and gives values the face can draw. It cannot check
// the defaults themselves: the simulator keeps the last saved settings, so a changed default in
// properties.xml does not show up here. `python3 tools/gen_settings.py --check` verifies the files instead.
(:test, :pro)
function loadReadsRealPropertiesAndStaysInRange(logger as Test.Logger) as Boolean {
    var s = TwoSunsSettings.load();
    Test.assert(s.accent >= 0 && s.accent < TwoSunsConfig.ACCENT_COUNT);
    Test.assert(s.orientation == TwoSunsConfig.ORIENTATION_NOON_TOP || s.orientation == TwoSunsConfig.ORIENTATION_MIDNIGHT_TOP);
    Test.assert(Application.Properties.getValue(TwoSunsConfig.KEY_CURVE) instanceof Number);
    return true;
}

// Free: Accent is the only setting. A dictionary that carries the four Pro keys (an old phone, a test) gives the
// Free values: noon at the top, no golden arc, no curve, no date row. Free never asks for those keys.
(:test, :free)
function freeReturnsDefaultsForProKeys(logger as Test.Logger) as Boolean {
    var s = new TwoSunsSettings({"Accent" => 3, "Orientation" => 1, "Golden" => 1, "Curve" => 1, "Date" => 1, "Weather" => 1, "Battery" => 1} as Dictionary);
    Test.assertEqual(s.accent, 3);
    Test.assertEqual(s.orientation, TwoSunsConfig.ORIENTATION_NOON_TOP);
    Test.assert(!s.golden);
    Test.assert(!s.curve);
    Test.assert(!s.date);
    Test.assert(!s.weather && !s.battery);
    var empty = new TwoSunsSettings({} as Dictionary);
    Test.assertEqual(empty.accent, 0);
    Test.assertEqual(empty.orientation, TwoSunsConfig.ORIENTATION_NOON_TOP);
    Test.assert(!empty.golden && !empty.curve && !empty.date && !empty.weather && !empty.battery);
    return true;
}

// The real Properties path in Free: the properties file has only Accent, and the result is the Free values. This cannot
// tell "never asked for a Pro key" from "asked and caught the exception": that is proved by the Free .prg containing
// no Pro key (tools/check_free_package.sh) and by the Pro keys' constants being (:pro), not by this test.
(:test, :free)
function freeLoadReadsAccentOnly(logger as Test.Logger) as Boolean {
    var s = TwoSunsSettings.load();
    Test.assert(s.accent >= 0 && s.accent < TwoSunsConfig.ACCENT_COUNT);
    Test.assertEqual(s.orientation, TwoSunsConfig.ORIENTATION_NOON_TOP);
    Test.assert(!s.golden && !s.curve && !s.date && !s.weather && !s.battery);
    return true;
}

// The assumption the Free build leans on (SDK 9.2.0 docs: getValue throws InvalidKeyException for a key the properties
// file does not define). Free code never reads a Pro key, so nothing depends on it; this test just records what the
// simulator does. If it fails, only this test is wrong: no shipped Free path calls getValue for those keys.
(:test, :free)
function freeMissingPropertyKeyThrows(logger as Test.Logger) as Boolean {
    var threw = false;
    try {
        Application.Properties.getValue("Curve");
    } catch (e instanceof Application.Properties.InvalidKeyException) {
        threw = true;
    }
    Test.assertMessage(threw, "getValue of a key missing from the Free properties file did not throw");
    return true;
}
