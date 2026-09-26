import Toybox.Lang;
import Toybox.Test;

// English words are asserted, so these tests assume the simulator runs in
// English (as does every other word test in this project).
function settingsFor(unit as Number, name as String) as DaysToGoSettings {
    return new DaysToGoSettings({"Unit" => unit, "Name" => name} as Dictionary);
}

function resultOf(phase as Number, days as Number, seconds as Number) as DaysToGoResult {
    return new DaysToGoResult(phase, days, seconds, 2026, 12, 25);
}

(:test)
function upcomingShowsDaysAndRing(logger as Test.Logger) as Boolean {
    var state = DaysToGoReadings.build(settingsFor(0, "Xmas"), resultOf(DaysToGoConfig.PHASE_UPCOMING, 91, 0), 2026, false);
    Test.assertEqual(state.hero, "91");
    Test.assertEqual(state.captionLines[0], "DAYS");
    Test.assertEqual(state.name, "Xmas");
    Test.assertEqual(state.ringPermille, 499);   // sqrt(91 / 365)
    Test.assert(state.dateLines.size() >= 2);
    return true;
}

// The last days must stay visible, and the ring must never grow as the day nears.
(:test)
function ringStaysVisibleAndShrinksMonotonically(logger as Test.Logger) as Boolean {
    Test.assert(DaysToGoReadings.ringPermilleFor(1) >= 50);
    var previous = DaysToGoReadings.ringPermilleFor(DaysToGoConfig.DAYS_PER_YEAR);
    Test.assertEqual(previous, DaysToGoConfig.PERMILLE);
    for (var days = DaysToGoConfig.DAYS_PER_YEAR - 1; days >= 1; days--) {
        var now = DaysToGoReadings.ringPermilleFor(days);
        Test.assert(now <= previous);
        previous = now;
    }
    return true;
}

(:test)
function oneDayUsesSingular(logger as Test.Logger) as Boolean {
    var state = DaysToGoReadings.build(settingsFor(0, ""), resultOf(DaysToGoConfig.PHASE_UPCOMING, 1, 0), 2026, false);
    Test.assertEqual(state.captionLines[0], "DAY");
    return true;
}

(:test)
function farEventShowsTrackOnly(logger as Test.Logger) as Boolean {
    var state = DaysToGoReadings.build(settingsFor(0, ""), resultOf(DaysToGoConfig.PHASE_UPCOMING, 12775, 0), 2026, false);
    Test.assertEqual(state.ringPermille, 0);
    // A year out to the day is still inside the window: full accent ring.
    var year = DaysToGoReadings.build(settingsFor(0, ""), resultOf(DaysToGoConfig.PHASE_UPCOMING, 365, 0), 2026, false);
    Test.assertEqual(year.ringPermille, DaysToGoConfig.PERMILLE);
    var over = DaysToGoReadings.build(settingsFor(0, ""), resultOf(DaysToGoConfig.PHASE_UPCOMING, 366, 0), 2026, false);
    Test.assertEqual(over.ringPermille, 0);
    Test.assertEqual(state.hero, "12775");
    return true;
}

(:test)
function weeksModeSplitsWeeksAndDays(logger as Test.Logger) as Boolean {
    var state = DaysToGoReadings.build(settingsFor(1, ""), resultOf(DaysToGoConfig.PHASE_UPCOMING, 45, 0), 2026, false);
    Test.assertEqual(state.hero, "6");
    Test.assertEqual(state.captionLines[0], "WEEKS + 3 DAYS");
    Test.assertEqual(state.captionLines.size(), 1);
    var even = DaysToGoReadings.build(settingsFor(1, ""), resultOf(DaysToGoConfig.PHASE_UPCOMING, 14, 0), 2026, false);
    Test.assertEqual(even.hero, "2");
    Test.assertEqual(even.captionLines.size(), 1);
    var one = DaysToGoReadings.build(settingsFor(1, ""), resultOf(DaysToGoConfig.PHASE_UPCOMING, 8, 0), 2026, false);
    Test.assertEqual(one.captionLines[0], "WEEK + 1 DAY");
    return true;
}

(:test)
function underAWeekStaysInDays(logger as Test.Logger) as Boolean {
    var state = DaysToGoReadings.build(settingsFor(1, ""), resultOf(DaysToGoConfig.PHASE_UPCOMING, 6, 0), 2026, false);
    Test.assertEqual(state.hero, "6");
    Test.assertEqual(state.captionLines[0], "DAYS");
    return true;
}

(:test)
function hoursShowsHMM(logger as Test.Logger) as Boolean {
    Test.assertEqual(DaysToGoReadings.hoursText(3 * 3600 + 5 * 60), "3:05");
    Test.assertEqual(DaysToGoReadings.hoursText(1), "0:01");
    Test.assertEqual(DaysToGoReadings.hoursText(86399), "24:00");
    var state = DaysToGoReadings.build(settingsFor(0, ""), resultOf(DaysToGoConfig.PHASE_HOURS, 0, 43200), 2026, false);
    Test.assertEqual(state.captionLines[0], "HOURS");
    Test.assertEqual(state.ringPermille, 500);
    return true;
}

(:test)
function todayAndPastAndInvalid(logger as Test.Logger) as Boolean {
    var today = DaysToGoReadings.build(settingsFor(0, "Race"), resultOf(DaysToGoConfig.PHASE_TODAY, 0, 0), 2026, false);
    Test.assertEqual(today.hero, "TODAY");
    Test.assert(today.heroIsWord);
    Test.assertEqual(today.ringPermille, DaysToGoConfig.PERMILLE);
    var past = DaysToGoReadings.build(settingsFor(0, ""), resultOf(DaysToGoConfig.PHASE_PAST, 1, 0), 2026, false);
    Test.assertEqual(past.captionLines[0], "DAY SINCE");
    Test.assertEqual(past.ringPermille, 0);
    var many = DaysToGoReadings.build(settingsFor(0, ""), resultOf(DaysToGoConfig.PHASE_PAST, 400, 0), 2026, false);
    Test.assertEqual(many.captionLines[0], "DAYS SINCE");
    // An impossible date shows words only: no name, no date line, no ring track.
    var bad = DaysToGoReadings.build(settingsFor(0, "Race"), resultOf(DaysToGoConfig.PHASE_INVALID, 0, 0), 2026, false);
    Test.assertEqual(bad.hero, "SET A DATE");
    Test.assertEqual(bad.name, "");
    Test.assertEqual(bad.dateLines.size(), 0);
    Test.assert(!bad.ringTrack);
    return true;
}

(:test)
function clockWording(logger as Test.Logger) as Boolean {
    Test.assertEqual(DaysToGoReadings.timeText(7, 5, true), "07:05");
    Test.assertEqual(DaysToGoReadings.timeText(0, 0, false), "12:00");
    Test.assertEqual(DaysToGoReadings.timeText(13, 9, false), "1:09");
    Test.assertEqual(DaysToGoReadings.timeText(23, 59, true), "23:59");
    Test.assertEqual(DaysToGoReadings.timeText(12, 30, false), "12:30");
    return true;
}

(:test)
function stepsWording(logger as Test.Logger) as Boolean {
    Test.assertEqual(DaysToGoReadings.stepsText(950), "950");
    Test.assertEqual(DaysToGoReadings.stepsText(1234), "1.2K");
    Test.assertEqual(DaysToGoReadings.stepsText(99900), "99.9K");
    Test.assertEqual(DaysToGoReadings.stepsText(99949), "99.9K");
    Test.assertEqual(DaysToGoReadings.stepsText(99999), "100K");
    Test.assertEqual(DaysToGoReadings.stepsText(123456), "123K");
    return true;
}
