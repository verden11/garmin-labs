import Toybox.Lang;
import Toybox.Math;
import Toybox.Test;

// The platform facts the sun maths leans on (SDK docs; never run before on a watch): Math returns a Double only for a
// Long or Double argument, and Math.PI is a Float. SunWindowConfig.PI is the Double the maths uses.
(:test)
function mathKeepsDoublesAsDoubles(logger as Test.Logger) as Boolean {
    Test.assert(Math.sin(0.5d) instanceof Lang.Double);
    Test.assert(Math.PI instanceof Lang.Float);
    Test.assertMessage((SunWindowConfig.PI - 3.141592653589793d).abs() < 1.0e-12d, "Double pi " + SunWindowConfig.PI);
    return true;
}

// Midsummer Vilnius: the window the fixtures give (10:26 to 16:16) and the mid-winter day that never reaches the line.
(:test)
function vilniusWindowAndWinter(logger as Test.Logger) as Boolean {
    var summer = SunWindowSun.day(SunWindowCalendar.dayNumber(2026, 6, 21), 54.687d, 25.28d, 180);
    Test.assert(summer.hasWindow);
    Test.assertMessage((summer.open - 626).abs() <= 1, "open " + summer.open);
    Test.assertMessage((summer.close - 976).abs() <= 1, "close " + summer.close);
    var winter = SunWindowSun.day(SunWindowCalendar.dayNumber(2026, 12, 21), 54.687d, 25.28d, 120);
    Test.assert(!winter.hasWindow);
    return true;
}

// The poles and the equator, the southern summer, and a place on the edge: no crash, the right answer.
(:test)
function extremePlaces(logger as Test.Logger) as Boolean {
    var day = SunWindowCalendar.dayNumber(2026, 6, 21);
    Test.assert(!SunWindowSun.day(day, 89.9d, 0.0d, 0).hasWindow);          // the sun stays near the horizon
    Test.assert(!SunWindowSun.day(day, -89.9d, 0.0d, 0).hasWindow);
    Test.assert(SunWindowSun.day(day, 1.352d, 103.82d, 480).hasWindow);       // Singapore, all year
    Test.assert(SunWindowSun.day(SunWindowCalendar.dayNumber(2026, 12, 21), -33.868d, 151.209d, 660).hasWindow);
    Test.assert(!SunWindowSun.day(SunWindowCalendar.dayNumber(2026, 6, 21), -33.868d, 151.209d, 600).hasWindow);
    return true;
}

// The sun is at its highest when the equation of time and longitude put solar noon there: elevation peaks at the window's middle.
(:test)
function windowIsCentredOnSolarNoon(logger as Test.Logger) as Boolean {
    var d = SunWindowSun.day(SunWindowCalendar.dayNumber(2026, 6, 21), 54.687d, 25.28d, 180);
    var middle = (d.open + d.close) / 2;
    var noon = SunWindowSun.elevation(54.687d, 25.28d, d.declination, d.equation, (middle - 180).toDouble());
    var before = SunWindowSun.elevation(54.687d, 25.28d, d.declination, d.equation, (middle - 180 - 30).toDouble());
    Test.assert(noon > before);
    Test.assertMessage(noon > 45.0d, "noon " + noon);
    return true;
}

// UTC+13 and +14 west of the date line: the window is on the right local day, inside the day (code review 2026-10-10).
(:test)
function windowStaysInTheLocalDayAtUtcPlus13And14(logger as Test.Logger) as Boolean {
    var day = SunWindowCalendar.dayNumber(2026, 1, 15);
    var apia = SunWindowSun.day(day, -13.833d, -171.75d, 780);
    var kiritimati = SunWindowSun.day(day, 1.87d, -157.4d, 840);
    Test.assert(apia.hasWindow && apia.open > 0 && apia.close < 1440);
    Test.assert(kiritimati.hasWindow && kiritimati.open > 0 && kiritimati.close < 1440);
    Test.assert(SunWindowReader.kindFor(apia, (apia.open + apia.close) / 2, false) == SunWindowConfig.STATE_OPEN);
    return true;
}

// A rounded place of 179.96 degrees east is still a place after the round trip through Storage.
(:test)
function placeNearTheDateLineSurvivesRounding(logger as Test.Logger) as Boolean {
    var place = SunWindowPlace.pick([[-16.8, 179.96]] as Array<Array<Float> or Null>);
    Test.assert(place != null);
    if (place != null) {
        Test.assert(SunWindowPlace.fromStorage([place[0], place[1]] as Array<Float>) != null);
    }
    return true;
}

// Every edge minute is a real crossing: the sun is at or above the line there and not at the minute outside the window.
(:test)
function edgeMinutesBracketTheLine(logger as Test.Logger) as Boolean {
    var dayNumber = SunWindowCalendar.dayNumber(2026, 6, 21);
    var d = SunWindowSun.day(dayNumber, 54.687d, 25.28d, 180);
    var inside = SunWindowSun.elevationAtUtc(54.687d, 25.28d, dayNumber, (d.open - 180).toDouble());
    var outside = SunWindowSun.elevationAtUtc(54.687d, 25.28d, dayNumber, (d.open - 1 - 180).toDouble());
    Test.assertMessage(inside >= 44.99d, "inside " + inside);
    Test.assertMessage(outside < 45.01d, "outside " + outside);
    var lastIn = SunWindowSun.elevationAtUtc(54.687d, 25.28d, dayNumber, (d.close - 180).toDouble());
    var firstOut = SunWindowSun.elevationAtUtc(54.687d, 25.28d, dayNumber, (d.close + 1 - 180).toDouble());
    Test.assertMessage(lastIn >= 44.99d, "closing edge inside " + lastIn);
    Test.assertMessage(firstOut < 45.01d, "closing edge outside " + firstOut);
    return true;
}
