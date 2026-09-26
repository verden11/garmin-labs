import Toybox.Lang;
import Toybox.Test;

// The phone can hand the face anything (missing keys, old types, a list value
// no longer offered). Every bad value must fall back to the working default.
(:test)
function badSettingsFallBackToDefaults(logger as Test.Logger) as Boolean {
    var s = new DaysToGoSettings({
        "Event" => 9, "Name" => 5, "Month" => 13, "Day" => 0, "Year" => 1969, "Hour" => 25,
        "Unit" => -1, "DateStyle" => "x", "Footer" => 3, "Accent" => 6
    } as Dictionary);
    Test.assertEqual(s.event, DaysToGoConfig.EVENT_NEW_YEAR);
    Test.assertEqual(s.name, "");
    Test.assertEqual(s.month, 1);
    Test.assertEqual(s.day, 1);
    Test.assertEqual(s.year, DaysToGoConfig.EVERY_YEAR);
    Test.assertEqual(s.hour, DaysToGoConfig.HOUR_SETTING_ALL_DAY);
    Test.assertEqual(s.unit, DaysToGoConfig.UNIT_DAYS);
    Test.assertEqual(s.dateStyle, DaysToGoConfig.STYLE_AUTO);
    Test.assertEqual(s.footer, DaysToGoConfig.FOOTER_NONE);
    Test.assertEqual(s.accent, 0);
    return true;
}

(:test)
function missingSettingsFallBackToDefaults(logger as Test.Logger) as Boolean {
    var s = new DaysToGoSettings({} as Dictionary);
    Test.assertEqual(s.event, DaysToGoConfig.EVENT_NEW_YEAR);
    Test.assertEqual(s.month, 1);
    Test.assertEqual(s.year, DaysToGoConfig.EVERY_YEAR);
    return true;
}

(:test)
function goodSettingsPassThrough(logger as Test.Logger) as Boolean {
    var s = new DaysToGoSettings({
        "Event" => 2, "Name" => "70.3", "Month" => 9, "Day" => 30, "Year" => 2027, "Hour" => 19,
        "Unit" => 1, "DateStyle" => 2, "Footer" => 2, "Accent" => 5
    } as Dictionary);
    Test.assertEqual(s.event, DaysToGoConfig.EVENT_CUSTOM);
    Test.assertEqual(s.name, "70.3");
    Test.assertEqual(s.month, 9);
    Test.assertEqual(s.day, 30);
    Test.assertEqual(s.year, 2027);
    Test.assertEqual(s.hour, 19);
    Test.assertEqual(s.unit, DaysToGoConfig.UNIT_WEEKS);
    Test.assertEqual(s.dateStyle, DaysToGoConfig.STYLE_MONTH_FIRST);
    Test.assertEqual(s.footer, DaysToGoConfig.FOOTER_STEPS);
    Test.assertEqual(s.accent, 5);
    return true;
}

(:test)
function longNameIsCutToSixteen(logger as Test.Logger) as Boolean {
    var s = new DaysToGoSettings({"Name" => "ABCDEFGHIJKLMNOPQRSTUVWXYZ"} as Dictionary);
    Test.assertEqual(s.name, "ABCDEFGHIJKLMNOP");
    return true;
}

// Saved years are held to the picker's range; anything else is "every year".
(:test)
function yearOutsidePickerRangeIsEveryYear(logger as Test.Logger) as Boolean {
    Test.assertEqual(new DaysToGoSettings({"Year" => 2200} as Dictionary).year, DaysToGoConfig.EVERY_YEAR);
    Test.assertEqual(new DaysToGoSettings({"Year" => 2025} as Dictionary).year, DaysToGoConfig.EVERY_YEAR);
    Test.assertEqual(new DaysToGoSettings({"Year" => 2060} as Dictionary).year, 2060);
    return true;
}

// The real Properties path: the shipped defaults are the working New Year face.
(:test)
function shippedDefaultsAreNewYearsDay(logger as Test.Logger) as Boolean {
    var s = DaysToGoSettings.load();
    Test.assertEqual(s.event, DaysToGoConfig.EVENT_NEW_YEAR);
    Test.assertEqual(s.year, DaysToGoConfig.EVERY_YEAR);
    Test.assertEqual(s.unit, DaysToGoConfig.UNIT_DAYS);
    Test.assertEqual(s.accent, 0);
    return true;
}
