import Toybox.Lang;
import Toybox.Test;

(:test)
function epochAndKnownDays(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsCalendar.dayNumber(1970, 1, 1), 0);
    Test.assertEqual(TwoSunsCalendar.dayNumber(2000, 1, 1), TwoSunsConfig.J2000_DAY_NUMBER);
    Test.assertEqual(TwoSunsCalendar.dayNumber(2000, 3, 1), 11017);
    Test.assertEqual(TwoSunsCalendar.dayNumber(2026, 9, 26), 20722);
    // 2100 is not a leap year, 2000 is.
    Test.assertEqual(TwoSunsCalendar.dayNumber(2100, 3, 1) - TwoSunsCalendar.dayNumber(2100, 2, 28), 1);
    Test.assertEqual(TwoSunsCalendar.dayNumber(2000, 3, 1) - TwoSunsCalendar.dayNumber(2000, 2, 28), 2);
    return true;
}

// Every day from 1970 to 2100 is one more than the day before it, and fromDayNumber undoes dayNumber.
(:test)
function everyDayAdvancesByOneAndRoundTrips(logger as Test.Logger) as Boolean {
    var previous = TwoSunsCalendar.dayNumber(1970, 1, 1) - 1;
    for (var year = 1970; year <= 2100; year++) {
        for (var month = 1; month <= 12; month++) {
            for (var day = 1; day <= TwoSunsCalendar.daysInMonth(year, month); day++) {
                var number = TwoSunsCalendar.dayNumber(year, month, day);
                Test.assertEqual(number, previous + 1);
                previous = number;
                var back = TwoSunsCalendar.fromDayNumber(number);
                Test.assertEqual(back[0], year);
                Test.assertEqual(back[1], month);
                Test.assertEqual(back[2], day);
            }
        }
    }
    return true;
}

(:test)
function validity(logger as Test.Logger) as Boolean {
    Test.assert(TwoSunsCalendar.isValid(2028, 2, 29));
    Test.assert(TwoSunsCalendar.isValid(2000, 2, 29));
    Test.assert(!TwoSunsCalendar.isValid(2027, 2, 29));
    Test.assert(!TwoSunsCalendar.isValid(2100, 2, 29));
    Test.assert(!TwoSunsCalendar.isValid(2026, 4, 31));
    Test.assert(!TwoSunsCalendar.isValid(2026, 13, 1));
    Test.assert(!TwoSunsCalendar.isValid(2026, 0, 1));
    Test.assert(!TwoSunsCalendar.isValid(1969, 12, 31));
    return true;
}
