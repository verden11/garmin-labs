import Toybox.Lang;
import Toybox.Test;

(:test)
function temperatureConvertsBothUnits(logger as Test.Logger) as Boolean {
    Test.assertEqual(DayArcFormat.temperatureIn(null, false), "--");
    Test.assertEqual(DayArcFormat.temperatureIn(0.0, false), "0°");
    Test.assertEqual(DayArcFormat.temperatureIn(0.0, true), "32°");
    Test.assertEqual(DayArcFormat.temperatureIn(100.0, true), "212°");
    Test.assertEqual(DayArcFormat.temperatureIn(20.0, false), "20°");
    // 15.5C -> 59.9F: must round to 60, not truncate to 59 (the bug this test exists to catch).
    Test.assertEqual(DayArcFormat.temperatureIn(15.5, true), "60°");
    return true;
}

(:test)
function distanceConvertsBothUnits(logger as Test.Logger) as Boolean {
    Test.assertEqual(DayArcFormat.distanceMetersIn(null, false), "--");
    Test.assertEqual(DayArcFormat.distanceMetersIn(10000.0, false), "10.0 km");
    Test.assertEqual(DayArcFormat.distanceMetersIn(1609.34, true), "1.0 mi");
    return true;
}

// Both the main clock and Pro's sunrise/sunset grid cells go through this — an earlier version
// had a second, 24-hour-only copy of this logic for the grid cells that ignored the device
// setting entirely (code review, 2026-09-28).
(:test)
function clockTimeRespectsBothHourFormats(logger as Test.Logger) as Boolean {
    Test.assertEqual(DayArcFormat.clockTime(0, 5, true), "00:05");
    Test.assertEqual(DayArcFormat.clockTime(13, 5, true), "13:05");
    Test.assertEqual(DayArcFormat.clockTime(0, 5, false), "12:05");
    Test.assertEqual(DayArcFormat.clockTime(12, 0, false), "12:00");
    Test.assertEqual(DayArcFormat.clockTime(13, 5, false), "1:05");
    Test.assertEqual(DayArcFormat.clockTime(23, 59, false), "11:59");
    return true;
}

// The recovery cell showed "R… 2501": the SDK's value is minutes, the grid wants a short hours reading.
(:test)
function recoveryMinutesReadAsHours(logger as Test.Logger) as Boolean {
    Test.assertEqual(DayArcFormat.hoursFromMinutes(null), "--");
    Test.assertEqual(DayArcFormat.hoursFromMinutes(0), "0h");
    Test.assertEqual(DayArcFormat.hoursFromMinutes(29), "0h");
    Test.assertEqual(DayArcFormat.hoursFromMinutes(30), "1h");
    Test.assertEqual(DayArcFormat.hoursFromMinutes(2501), "42h");
    return true;
}

(:test)
function countAndPercentHandleNull(logger as Test.Logger) as Boolean {
    Test.assertEqual(DayArcFormat.count(null), "--");
    Test.assertEqual(DayArcFormat.count(42), "42");
    Test.assertEqual(DayArcFormat.percent(null), "--");
    Test.assertEqual(DayArcFormat.percent(87), "87%");
    return true;
}
