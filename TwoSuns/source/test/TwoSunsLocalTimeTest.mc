import Toybox.Lang;
import Toybox.Test;

(:debug)
function localOffset(localDate as Array<Number>, localMinute as Number, utcDate as Array<Number>, utcMinute as Number) as Number {
    return TwoSunsLocalTime.offsetBetween(TwoSunsCalendar.dayNumber(localDate[0], localDate[1], localDate[2]), localMinute,
                                          TwoSunsCalendar.dayNumber(utcDate[0], utcDate[1], utcDate[2]), utcMinute);
}

// Local minus UTC in minutes, from two readings of one instant.
(:test)
function offsetForCommonZones(logger as Test.Logger) as Boolean {
    var d = [2026, 9, 27] as Array<Number>;
    Test.assertEqual(localOffset(d, 12 * 60 + 30, d, 11 * 60 + 30), 60);          // London BST
    Test.assertEqual(localOffset(d, 12 * 60 + 30, d, 12 * 60 + 30), 0);
    Test.assertEqual(localOffset(d, 12 * 60 + 15, d, 6 * 60 + 30), 345);         // Kathmandu +5:45
    Test.assertEqual(localOffset(d, 6 * 60, d, 16 * 60), -600);                   // Honolulu -10
    return true;
}

// When the local date and the UTC date differ, the day numbers decide (no wrapping guess).
(:test)
function offsetAcrossTheDateLine(logger as Test.Logger) as Boolean {
    var today = [2026, 9, 27] as Array<Number>;
    var tomorrow = [2026, 9, 28] as Array<Number>;
    var yesterday = [2026, 9, 26] as Array<Number>;
    // Kiritimati +14: 10:00 UTC on the 27th is 00:00 on the 28th.
    Test.assertEqual(localOffset(tomorrow, 0, today, 10 * 60), 14 * 60);
    // Baker Island -12: 03:00 UTC on the 27th is 15:00 on the 26th.
    Test.assertEqual(localOffset(yesterday, 15 * 60, today, 3 * 60), -12 * 60);
    // Sydney AEDT +11 across a month end: 20:00 UTC on 30 Sept is 07:00 on 1 Oct.
    Test.assertEqual(localOffset([2026, 10, 1], 7 * 60, [2026, 9, 30], 20 * 60), 11 * 60);
    return true;
}

(:test)
function tomorrowCrossesMonthAndYear(logger as Test.Logger) as Boolean {
    var time = new TwoSunsLocalTime(2026, 12, 31, 600, 0, 0);
    var next = time.tomorrow();
    Test.assertEqual(next[0], 2027);
    Test.assertEqual(next[1], 1);
    Test.assertEqual(next[2], 1);
    var leap = new TwoSunsLocalTime(2028, 2, 28, 600, 0, 0).tomorrow();
    Test.assertEqual(leap[1], 2);
    Test.assertEqual(leap[2], 29);
    return true;
}

// The real clock read gives a sane offset for this simulator's zone (any whole quarter hour from -12:00 to +14:00).
(:test)
function nowReadsARealOffset(logger as Test.Logger) as Boolean {
    var time = TwoSunsLocalTime.now();
    Test.assert(time.offsetMinutes >= -12 * 60 && time.offsetMinutes <= 14 * 60);
    Test.assertEqual(time.offsetMinutes % 15, 0);
    Test.assert(time.minuteOfDay >= 0 && time.minuteOfDay < TwoSunsConfig.MINUTES_PER_DAY);
    Test.assert(TwoSunsCalendar.isValid(time.year, time.month, time.day));
    return true;
}
