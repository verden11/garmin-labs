import Toybox.Lang;
import Toybox.Test;

(:test)
function dayFirstLinesWithYear(logger as Test.Logger) as Boolean {
    var lines = DaysToGoDateText.lines("Fri", 25, "Dec", 2026, false, true);
    Test.assertEqual(lines.size(), 3);
    Test.assertEqual(lines[0], "Fri 25 Dec 2026");
    Test.assertEqual(lines[1], "25 Dec 2026");
    Test.assertEqual(lines[2], "25 Dec");
    return true;
}

(:test)
function monthFirstLinesWithoutYear(logger as Test.Logger) as Boolean {
    var lines = DaysToGoDateText.lines("Wed", 30, "Sep", 2026, true, false);
    Test.assertEqual(lines.size(), 2);
    Test.assertEqual(lines[0], "Wed Sep 30");
    Test.assertEqual(lines[1], "Sep 30");
    return true;
}

(:test)
function monthFirstLinesWithYear(logger as Test.Logger) as Boolean {
    var lines = DaysToGoDateText.lines("Thu", 4, "Jul", 2030, true, true);
    Test.assertEqual(lines[0], "Thu Jul 4 2030");
    Test.assertEqual(lines[1], "Jul 4 2030");
    Test.assertEqual(lines[2], "Jul 4");
    return true;
}

// Automatic is month first only for English with statute miles (a proxy for
// the US); an explicit style always wins.
(:test)
function dateStyleAutomaticRule(logger as Test.Logger) as Boolean {
    Test.assert(DaysToGoDateText.monthFirst(DaysToGoConfig.STYLE_AUTO, true, true));
    Test.assert(!DaysToGoDateText.monthFirst(DaysToGoConfig.STYLE_AUTO, true, false));
    Test.assert(!DaysToGoDateText.monthFirst(DaysToGoConfig.STYLE_AUTO, false, true));
    Test.assert(DaysToGoDateText.monthFirst(DaysToGoConfig.STYLE_MONTH_FIRST, false, false));
    Test.assert(!DaysToGoDateText.monthFirst(DaysToGoConfig.STYLE_DAY_FIRST, true, true));
    return true;
}

// The year appears only when the target is not in the current year.
(:test)
function yearShownOnlyWhenNotCurrent(logger as Test.Logger) as Boolean {
    var thisYear = DaysToGoDateText.forDate(2026, 12, 25, 2026, false);
    var later = DaysToGoDateText.forDate(2027, 12, 25, 2026, false);
    Test.assertEqual(thisYear.size(), 2);
    Test.assertEqual(later.size(), 3);
    Test.assert(later[0].find("2027") != null);
    return true;
}

// Years past 2038 must still get a weekday and a month word (no 32-bit Moment).
(:test)
function farFutureDateHasWords(logger as Test.Logger) as Boolean {
    var lines = DaysToGoDateText.forDate(2060, 9, 30, 2026, false);
    Test.assertEqual(lines.size(), 3);
    Test.assert(lines[0].find("2060") != null);
    Test.assert(lines[0].find("30") != null);
    // Same weekday word as a near date that falls on the same weekday (Thu).
    var near = DaysToGoDateText.forDate(2026, 1, 1, 2026, false);
    Test.assertEqual(lines[0].substring(0, 3) as String, near[0].substring(0, 3) as String);
    return true;
}
