import Toybox.Application;
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
    Test.assertEqual(s.unit, DaysToGoConfig.UNIT_WEEKS);
    Test.assertEqual(s.dateStyle, DaysToGoConfig.STYLE_MONTH_FIRST);
    Test.assertEqual(s.accent, 5);
    return true;
}

// Pro only: the Time of day and Bottom line lists pass through.
(:test, :pro)
function proSettingsPassThrough(logger as Test.Logger) as Boolean {
    var s = new DaysToGoSettings({"Hour" => 19, "Footer" => 2} as Dictionary);
    Test.assertEqual(s.hour, 19);
    Test.assertEqual(s.footer, DaysToGoConfig.FOOTER_STEPS);
    Test.assertEqual(DaysToGoEvent.fromSettings(DaysToGoConfig.EVENT_CUSTOM, 9, 30, 2027, s.hour).hour, 18);
    return true;
}

// Free: the two Pro keys do not exist, so even a dictionary that carries them (an old phone, a test) gives
// the defaults: an all-day event and no bottom line. ADR-014 (Free + Pro ladder).
(:test, :free)
function freeReturnsDefaultsForProKeys(logger as Test.Logger) as Boolean {
    var s = new DaysToGoSettings({"Hour" => 19, "Footer" => 2} as Dictionary);
    Test.assertEqual(s.hour, DaysToGoConfig.HOUR_SETTING_ALL_DAY);
    Test.assertEqual(s.footer, DaysToGoConfig.FOOTER_NONE);
    Test.assertEqual(DaysToGoEvent.fromSettings(DaysToGoConfig.EVENT_CUSTOM, 9, 30, 2027, s.hour).hour, DaysToGoConfig.NO_HOUR);
    var state = DaysToGoReadings.build(s, new DaysToGoResult(DaysToGoConfig.PHASE_UPCOMING, 5, 0, 2027, 9, 30), 2026, false);
    Test.assert(state.footer == null);
    return true;
}

// The real Properties path in Free: the properties file has no Hour or Footer, load() must not ask for them
// (see docs/development.md), and the result is still the defaults.
(:test, :free)
function freeLoadHasProDefaults(logger as Test.Logger) as Boolean {
    var s = DaysToGoSettings.load();
    Test.assertEqual(s.hour, DaysToGoConfig.HOUR_SETTING_ALL_DAY);
    Test.assertEqual(s.footer, DaysToGoConfig.FOOTER_NONE);
    return true;
}

// The assumption the Free build leans on (SDK 9.2.0 docs: getValue throws InvalidKeyException for a key the properties
// file does not define). Free code never reads Hour or Footer, so nothing depends on it; this test just records what the
// simulator does. If it fails, only this test is wrong: the shipped Free paths do not call getValue for those keys.
(:test, :free)
function freeMissingPropertyKeyThrows(logger as Test.Logger) as Boolean {
    var threw = false;
    try {
        Application.Properties.getValue("Hour");
    } catch (e instanceof Application.Properties.InvalidKeyException) {
        threw = true;
    }
    Test.assertMessage(threw, "getValue of a key missing from the Free properties file did not throw");
    return true;
}

// Unit unset (the wearer never touched Count in; in Free it has only the two lists): calendar days, from the real
// date arithmetic through to the words. Runs on both tiers.
(:test)
function unitUnsetCountsCalendarDays(logger as Test.Logger) as Boolean {
    var s = new DaysToGoSettings({"Event" => 2, "Month" => 12, "Day" => 25, "Year" => 2026} as Dictionary);
    Test.assertEqual(s.unit, DaysToGoConfig.UNIT_DAYS);
    var event = DaysToGoEvent.fromSettings(s.event, s.month, s.day, s.year, s.hour);
    var result = DaysToGoCountdown.resolve(event, new DaysToGoLocalTime(2026, 10, 26, 0));
    Test.assertEqual(result.phase, DaysToGoConfig.PHASE_UPCOMING);
    Test.assertEqual(result.days, 60);   // 5 + 30 + 25
    var state = DaysToGoReadings.build(s, result, 2026, false);
    Test.assertEqual(state.hero, "60");
    Test.assertEqual(state.captionLines[0], "DAYS");
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
