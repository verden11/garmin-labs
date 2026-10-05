import Toybox.Lang;
import Toybox.Test;

(:test)
function calendarConsecutiveSameMonth(logger as Test.Logger) as Lang.Boolean {
    Test.assert(HeroSetCalendar.isConsecutiveDate(20260911, 20260912));
    return true;
}

(:test)
function calendarSameDayIsNotConsecutive(logger as Test.Logger) as Lang.Boolean {
    Test.assert(!HeroSetCalendar.isConsecutiveDate(20260911, 20260911));
    return true;
}

(:test)
function calendarGapResets(logger as Test.Logger) as Lang.Boolean {
    Test.assert(!HeroSetCalendar.isConsecutiveDate(20260910, 20260912));
    return true;
}

(:test)
function calendarMonthRollIsConsecutive(logger as Test.Logger) as Lang.Boolean {
    Test.assert(HeroSetCalendar.isConsecutiveDate(20260930, 20261001));
    return true;
}

(:test)
function calendarMonthGapResets(logger as Test.Logger) as Lang.Boolean {
    Test.assert(!HeroSetCalendar.isConsecutiveDate(20260929, 20261001));
    return true;
}

(:test)
function calendarYearRollIsConsecutive(logger as Test.Logger) as Lang.Boolean {
    Test.assert(HeroSetCalendar.isConsecutiveDate(20251231, 20260101));
    return true;
}

(:test)
function calendarLeapDayIsConsecutive(logger as Test.Logger) as Lang.Boolean {
    Test.assert(HeroSetCalendar.isConsecutiveDate(20240228, 20240229));
    return true;
}

(:test)
function calendarNonLeapFebruaryRollsToMarch(logger as Test.Logger) as Lang.Boolean {
    Test.assert(HeroSetCalendar.isConsecutiveDate(20260228, 20260301));
    return true;
}

(:test)
function calendarNonLeapFebruaryGapResets(logger as Test.Logger) as Lang.Boolean {
    Test.assert(!HeroSetCalendar.isConsecutiveDate(20260227, 20260301));
    return true;
}

(:test)
function calendarDstSpringForwardIsAConsecutiveDay(logger as Test.Logger) as Lang.Boolean {
    // US DST begins 2026-03-08: local midnights are 23h apart, but the
    // calendar keys are still consecutive integers.
    Test.assert(HeroSetCalendar.isConsecutiveDate(20260307, 20260308));
    return true;
}

(:test)
function calendarDstFallBackIsAConsecutiveDay(logger as Test.Logger) as Lang.Boolean {
    // US DST ends 2026-11-01: local midnights are 25h apart.
    Test.assert(HeroSetCalendar.isConsecutiveDate(20261101, 20261102));
    return true;
}

(:test)
function calendarTodayKeyIsACalendarIntegerNotAnEpoch(logger as Test.Logger) as Lang.Boolean {
    var key = HeroSetCalendar.todayKey();
    Test.assert(key > 20200000);
    Test.assert(key < 21000000);
    return true;
}

// Undoing today's completion restores yesterday as the last day (ADR-058),
// so the step back has to cross months, years and leap days.
(:test)
function calendarPreviousDayKeyInvertsConsecutiveDate(logger as Test.Logger) as Lang.Boolean {
    var days = [20260912, 20261001, 20260101, 20240301, 20260301, 20260501] as Lang.Array<Lang.Number>;
    var expected = [20260911, 20260930, 20251231, 20240229, 20260228, 20260430] as Lang.Array<Lang.Number>;
    for (var i = 0; i < days.size(); i++) {
        Test.assertEqual(HeroSetCalendar.previousDayKey(days[i]), expected[i]);
        Test.assert(HeroSetCalendar.isConsecutiveDate(expected[i], days[i]));
    }
    return true;
}
