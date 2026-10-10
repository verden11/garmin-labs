import Toybox.Lang;
import Toybox.Test;

// The rule in one place (SunWindowReader.build): every branch, the clock edges, the place and the weather nulls.
(:test)
function everyStateBranch(logger as Test.Logger) as Boolean {
    var bright = SunWindowTestStates.SKY_BRIGHT;
    Test.assertEqual(SunWindowTestStates.vilnius(9 * 60, bright).kind, SunWindowConfig.STATE_CLOSED_BEFORE);
    Test.assertEqual(SunWindowTestStates.vilnius(13 * 60, bright).kind, SunWindowConfig.STATE_OPEN);
    Test.assertEqual(SunWindowTestStates.vilnius(13 * 60, SunWindowTestStates.SKY_LOW_UV).kind, SunWindowConfig.STATE_CLOSED_SKY);
    Test.assertEqual(SunWindowTestStates.vilnius(18 * 60, bright).kind, SunWindowConfig.STATE_CLOSED_AFTER);
    var winter = SunWindowReader.build(SunWindowTestStates.time(2026, 12, 21, 12 * 60, 120), SunWindowTestStates.VILNIUS, false, false, bright, true);
    Test.assertEqual(winter.kind, SunWindowConfig.STATE_NONE_TODAY);
    var none = SunWindowReader.build(SunWindowTestStates.time(2026, 6, 21, 12 * 60, 180), null, false, false, bright, true);
    Test.assertEqual(none.kind, SunWindowConfig.STATE_ONCE);
    Test.assertEqual(SunWindowReader.build(SunWindowTestStates.time(2026, 6, 21, 0, 180), null, true, false, bright, true).kind, SunWindowConfig.STATE_LOCATING);
    Test.assertEqual(SunWindowReader.build(SunWindowTestStates.time(2026, 6, 21, 0, 180), null, false, true, bright, true).kind, SunWindowConfig.STATE_NO_FIX);
    return true;
}

// The window's own edges: the first and last whole minute are inside, the minutes next to them are not.
(:test)
function windowEdgesAreInclusive(logger as Test.Logger) as Boolean {
    var day = SunWindowTestStates.vilnius(0, SunWindowTestStates.SKY_BRIGHT).day as SunWindowSunDay;
    var bright = SunWindowTestStates.SKY_BRIGHT;
    Test.assertEqual(SunWindowTestStates.vilnius(day.open - 1, bright).kind, SunWindowConfig.STATE_CLOSED_BEFORE);
    Test.assertEqual(SunWindowTestStates.vilnius(day.open, bright).kind, SunWindowConfig.STATE_OPEN);
    Test.assertEqual(SunWindowTestStates.vilnius(day.close, bright).kind, SunWindowConfig.STATE_OPEN);
    Test.assertEqual(SunWindowTestStates.vilnius(day.close + 1, bright).kind, SunWindowConfig.STATE_CLOSED_AFTER);
    return true;
}

// Midnight: the minute before and the minute after belong to different dates; each is judged against its own day.
(:test)
function midnightRollsToTheNextDay(logger as Test.Logger) as Boolean {
    var bright = SunWindowTestStates.SKY_BRIGHT;
    var late = SunWindowReader.build(SunWindowTestStates.time(2026, 6, 21, 1439, 180), SunWindowTestStates.VILNIUS, false, false, bright, true);
    var early = SunWindowReader.build(SunWindowTestStates.time(2026, 6, 22, 0, 180), SunWindowTestStates.VILNIUS, false, false, bright, true);
    Test.assertEqual(late.kind, SunWindowConfig.STATE_CLOSED_AFTER);
    Test.assertEqual(early.kind, SunWindowConfig.STATE_CLOSED_BEFORE);
    var lateDay = late.day as SunWindowSunDay;
    var earlyDay = early.day as SunWindowSunDay;
    Test.assert((earlyDay.open - lateDay.open).abs() <= 2);   // a day moves the edge by seconds at midsummer
    return true;
}

// The 2026-04-05 end of Australian summer time: the same place, two days apart, and the clock edge falls back by the hour
// (the clock reads an hour less at the same sun), less the few minutes the season's own drift adds.
(:test)
function summerTimeEndMovesTheClockEdge(logger as Test.Logger) as Boolean {
    var before = SunWindowSun.day(SunWindowCalendar.dayNumber(2026, 4, 4), -33.868d, 151.209d, 660);
    var after = SunWindowSun.day(SunWindowCalendar.dayNumber(2026, 4, 6), -33.868d, 151.209d, 600);
    Test.assert(before.hasWindow && after.hasWindow);
    var shift = after.open - before.open;
    Test.assertMessage(shift < -50 && shift > -70, "open moved " + shift);
    return true;
}

// A missing weather reading never demotes and never reads as "no weather" when the weather was not read at all.
(:test)
function weatherNullsAndTheUnreadSky(logger as Test.Logger) as Boolean {
    var noWeather = SunWindowTestStates.vilnius(13 * 60, SunWindowTestStates.SKY_UNKNOWN);
    Test.assertEqual(noWeather.kind, SunWindowConfig.STATE_OPEN);
    Test.assert(!noWeather.skyKnown);
    var unread = SunWindowReader.build(SunWindowTestStates.time(2026, 6, 21, 13 * 60, 180), SunWindowTestStates.VILNIUS, false, false,
                                       SunWindowTestStates.SKY_UNKNOWN, false);
    Test.assertEqual(unread.kind, SunWindowConfig.STATE_OPEN);
    Test.assert(unread.skyKnown);
    return true;
}

// The southern summer: Sydney in December has a window around local noon at +11:00.
(:test)
function southernHemisphere(logger as Test.Logger) as Boolean {
    var state = SunWindowReader.build(SunWindowTestStates.time(2026, 12, 21, 12 * 60, 660), SunWindowTestStates.SYDNEY, false, false,
                                      SunWindowTestStates.SKY_BRIGHT, true);
    Test.assertEqual(state.kind, SunWindowConfig.STATE_OPEN);
    return true;
}

// The reasons and times under the word, in 24 h and 12 h, for each closed state.
(:test)
function reasonLines(logger as Test.Logger) as Boolean {
    var before = SunWindowTestStates.vilnius(9 * 60, SunWindowTestStates.SKY_BRIGHT);
    Test.assertEqual(SunWindowReasons.reason(before, true), "Opens 10:26");
    // The stored place is rounded to 0.1 degree (54.7, 25.3), a minute off the fixtures' exact Vilnius: close 16:15, not 16:16.
    Test.assertEqual(SunWindowReasons.times(before, true), "10:26-16:15");
    Test.assertEqual(SunWindowReasons.times(before, false), "10:26a-4:15p");
    Test.assertEqual(SunWindowReasons.reason(SunWindowTestStates.vilnius(18 * 60, SunWindowTestStates.SKY_BRIGHT), true), "Closed for today");
    Test.assertEqual(SunWindowReasons.reason(SunWindowTestStates.vilnius(13 * 60, SunWindowTestStates.SKY_LOW_UV), true), "Cloud cover");
    Test.assertEqual(SunWindowReasons.reason(SunWindowTestStates.vilnius(13 * 60, SunWindowTestStates.SKY_UNKNOWN), true), "No weather");
    Test.assertEqual(SunWindowReasons.reason(SunWindowTestStates.vilnius(13 * 60, SunWindowTestStates.SKY_BRIGHT), true), "");
    var states = SunWindowTestStates.all();
    Test.assertEqual(SunWindowReasons.reason(states[5], true), "Sun stays low");
    Test.assertEqual(SunWindowReasons.times(states[5], true), "");
    Test.assertEqual(SunWindowReasons.reason(states[7], true), "No place yet");
    Test.assertEqual(SunWindowReasons.times(states[7], true), "Press START");
    return true;
}
