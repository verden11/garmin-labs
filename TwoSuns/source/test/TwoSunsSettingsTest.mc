import Toybox.Application;
import Toybox.Lang;
import Toybox.Test;

// The phone can hand the face anything (missing keys, old types, a list value no longer offered).
// Every bad value must fall back to the working default.
(:test)
function badSettingsFallBackToDefaults(logger as Test.Logger) as Boolean {
    var s = new TwoSunsSettings({"Accent" => 6, "Orientation" => 2, "Golden" => -1, "Curve" => "x", "Date" => 2.5} as Dictionary);
    Test.assertEqual(s.accent, 0);
    Test.assertEqual(s.orientation, TwoSunsConfig.ORIENTATION_NOON_TOP);
    Test.assert(!s.golden);
    Test.assert(s.curve);
    Test.assert(s.date);
    return true;
}

(:test)
function missingSettingsFallBackToDefaults(logger as Test.Logger) as Boolean {
    var s = new TwoSunsSettings({} as Dictionary);
    Test.assertEqual(s.accent, 0);
    Test.assertEqual(s.orientation, TwoSunsConfig.ORIENTATION_NOON_TOP);
    Test.assert(!s.golden);
    Test.assert(s.curve);
    Test.assert(s.date);
    return true;
}

(:test)
function goodSettingsPassThrough(logger as Test.Logger) as Boolean {
    var s = new TwoSunsSettings({"Accent" => 5, "Orientation" => 1, "Golden" => 1, "Curve" => 0, "Date" => 0} as Dictionary);
    Test.assertEqual(s.accent, 5);
    Test.assertEqual(s.orientation, TwoSunsConfig.ORIENTATION_MIDNIGHT_TOP);
    Test.assert(s.golden);
    Test.assert(!s.curve);
    Test.assert(!s.date);
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
(:test)
function loadReadsRealPropertiesAndStaysInRange(logger as Test.Logger) as Boolean {
    var s = TwoSunsSettings.load();
    Test.assert(s.accent >= 0 && s.accent < TwoSunsConfig.ACCENT_COUNT);
    Test.assert(s.orientation == TwoSunsConfig.ORIENTATION_NOON_TOP || s.orientation == TwoSunsConfig.ORIENTATION_MIDNIGHT_TOP);
    Test.assert(Application.Properties.getValue(TwoSunsConfig.KEY_CURVE) instanceof Number);
    return true;
}
