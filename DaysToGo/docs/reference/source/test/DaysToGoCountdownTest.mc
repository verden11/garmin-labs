import Toybox.Lang;
import Toybox.Test;

// Test helpers. hour -1 = all day, year 0 = every year.
function resolveAt(month as Number, day as Number, year as Number, hour as Number,
                   nowYear as Number, nowMonth as Number, nowDay as Number, nowSecond as Number) as DaysToGoResult {
    var event = new DaysToGoEvent(month, day, year, hour);
    return DaysToGoCountdown.resolve(event, new DaysToGoLocalTime(nowYear, nowMonth, nowDay, nowSecond));
}

// Event Countdown's 2022 bug: entering tomorrow counted two days.
(:test)
function tomorrowIsOneDay(logger as Test.Logger) as Boolean {
    var r = resolveAt(9, 27, 2026, -1, 2026, 9, 26, 0);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);
    Test.assertEqual(r.days, 1);
    r = resolveAt(9, 27, 2026, -1, 2026, 9, 26, 86399);
    Test.assertEqual(r.days, 1);                        // 23:59:59 the day before is still 1
    r = resolveAt(9, 27, 2026, -1, 2026, 9, 27, 0);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);  // flips at local midnight
    return true;
}

// New Year Countdown's 2019 bug: it counted to 31 Dec, not 1 Jan.
(:test)
function newYearsEveIsNotNewYear(logger as Test.Logger) as Boolean {
    var r = resolveAt(1, 1, 0, -1, 2026, 12, 31, 43200);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);
    Test.assertEqual(r.days, 1);
    Test.assertEqual(r.year, 2027);
    r = resolveAt(1, 1, 0, -1, 2026, 12, 30, 0);
    Test.assertEqual(r.days, 2);
    r = resolveAt(1, 1, 0, -1, 2027, 1, 1, 100);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    // The day after, an every-year event rolls to the next year: 2027 is not a leap year, so 364 days.
    r = resolveAt(1, 1, 0, -1, 2027, 1, 2, 100);
    Test.assertEqual(r.days, 364);
    Test.assertEqual(r.year, 2028);
    return true;
}

(:test)
function aPastEventCountsUp(logger as Test.Logger) as Boolean {
    var r = resolveAt(9, 20, 2026, -1, 2026, 9, 26, 0);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_PAST);
    Test.assertEqual(r.days, 6);
    return true;
}

(:test)
function leapDayEvents(logger as Test.Logger) as Boolean {
    // A specific 29 Feb 2027 does not exist.
    var r = resolveAt(2, 29, 2027, -1, 2026, 9, 26, 0);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_INVALID);
    // Every year: 2027 is common, so the next one is 28 Feb 2027.
    r = resolveAt(2, 29, 0, -1, 2026, 9, 26, 0);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);
    Test.assertEqual(r.month, 2);
    Test.assertEqual(r.day, 28);
    Test.assertEqual(r.year, 2027);
    // From 1 Mar 2027 the next is 29 Feb 2028, a leap year: 365 days away.
    r = resolveAt(2, 29, 0, -1, 2027, 3, 1, 0);
    Test.assertEqual(r.day, 29);
    Test.assertEqual(r.year, 2028);
    Test.assertEqual(r.days, 365);
    // On 28 Feb 2027 it is the day.
    r = resolveAt(2, 29, 0, -1, 2027, 2, 28, 5);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    return true;
}

(:test)
function timedEvents(logger as Test.Logger) as Boolean {
    // Event 25 Dec 18:00. On 24 Dec 10:00 it is 32 h away: still "1 day".
    var r = resolveAt(12, 25, 2026, 18, 2026, 12, 24, 36000);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);
    Test.assertEqual(r.days, 1);
    // 24 Dec 20:00: 22 h, so hours.
    r = resolveAt(12, 25, 2026, 18, 2026, 12, 24, 72000);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(r.seconds, 79200);
    // The same day at 10:00: 8 h.
    r = resolveAt(12, 25, 2026, 18, 2026, 12, 25, 36000);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(r.seconds, 28800);
    // Exactly 18:00 and later that day: arrived. Next day: 1 day since.
    r = resolveAt(12, 25, 2026, 18, 2026, 12, 25, 64800);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    r = resolveAt(12, 25, 2026, 18, 2026, 12, 25, 80000);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    r = resolveAt(12, 25, 2026, 18, 2026, 12, 26, 0);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_PAST);
    Test.assertEqual(r.days, 1);
    // An every-year timed event rolls once its hour is reached.
    r = resolveAt(12, 25, 0, 18, 2026, 12, 25, 64800);
    Test.assertEqual(r.year, 2027);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);
    // A midnight event: arrived at 00:00, hours the minute before.
    r = resolveAt(12, 25, 2026, 0, 2026, 12, 25, 0);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    r = resolveAt(12, 25, 2026, 0, 2026, 12, 24, 86000);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    return true;
}

(:test)
function farFutureAndBoundaries(logger as Test.Logger) as Boolean {
    var r = resolveAt(12, 31, 2050, -1, 2026, 1, 1, 0);
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);
    Test.assertEqual(r.days, 9130);   // python: (date(2050,12,31) - date(2026,1,1)).days
    r = resolveAt(3, 1, 2028, -1, 2028, 2, 29, 0);
    Test.assertEqual(r.days, 1);      // leap day to 1 March
    r = resolveAt(1, 1, 2027, -1, 2026, 12, 31, 0);
    Test.assertEqual(r.days, 1);      // year boundary
    return true;
}

// Presets are events with fixed fields; custom passes the settings through.
(:test)
function presetsIgnoreCustomFields(logger as Test.Logger) as Boolean {
    var e = DaysToGoEvent.fromSettings(DaysToGoConfig.EVENT_NEW_YEAR, 7, 7, 2030, 10);
    Test.assertEqual(e.month, 1);
    Test.assertEqual(e.day, 1);
    Test.assertEqual(e.year, DaysToGoConfig.EVERY_YEAR);
    Test.assertEqual(e.hour, DaysToGoConfig.NO_HOUR);
    e = DaysToGoEvent.fromSettings(DaysToGoConfig.EVENT_CHRISTMAS, 7, 7, 2030, 9);
    Test.assertEqual(e.month, 12);
    Test.assertEqual(e.day, 25);
    // Custom passes month, day and year through and converts the raw hour setting: 19 means 18:00.
    e = DaysToGoEvent.fromSettings(DaysToGoConfig.EVENT_CUSTOM, 7, 8, 2030, 19);
    Test.assertEqual(e.month, 7);
    Test.assertEqual(e.day, 8);
    Test.assertEqual(e.year, 2030);
    Test.assertEqual(e.hour, 18);
    e = DaysToGoEvent.fromSettings(DaysToGoConfig.EVENT_CUSTOM, 7, 8, 2030, 0);
    Test.assertEqual(e.hour, DaysToGoConfig.NO_HOUR);
    return true;
}

// The phone's Day list offers 1..31 for every month, and so does the picker, so
// impossible every-year dates must be reported, never counted to the next real day.
(:test)
function impossibleEveryYearDatesAreInvalid(logger as Test.Logger) as Boolean {
    var dates = [[4, 31], [6, 31], [9, 31], [11, 31], [2, 30], [2, 31], [13, 1], [0, 5], [1, 0], [1, 32]] as Array<Array<Number>>;
    for (var i = 0; i < dates.size(); i++) {
        var r = resolveAt(dates[i][0], dates[i][1], DaysToGoConfig.EVERY_YEAR, DaysToGoConfig.NO_HOUR, 2026, 9, 26, 0);
        Test.assertEqual(r.phase, DaysToGoConfig.PHASE_INVALID);
    }
    // 29 Feb every year stays valid.
    var leap = resolveAt(2, 29, DaysToGoConfig.EVERY_YEAR, DaysToGoConfig.NO_HOUR, 2026, 9, 26, 0);
    Test.assertEqual(leap.phase, DaysToGoConfig.PHASE_UPCOMING);
    // A specific-year impossible date is invalid too.
    var fixed = resolveAt(4, 31, 2027, DaysToGoConfig.NO_HOUR, 2026, 9, 26, 0);
    Test.assertEqual(fixed.phase, DaysToGoConfig.PHASE_INVALID);
    return true;
}

(:test)
function hourSettingNeverNegative(logger as Test.Logger) as Boolean {
    Test.assertEqual(DaysToGoEvent.hourFromSetting(0), DaysToGoConfig.NO_HOUR);
    Test.assertEqual(DaysToGoEvent.hourFromSetting(1), 0);      // 00:00
    Test.assertEqual(DaysToGoEvent.hourFromSetting(19), 18);    // 18:00
    Test.assertEqual(DaysToGoEvent.hourFromSetting(24), 23);    // 23:00
    Test.assertEqual(DaysToGoEvent.hourFromSetting(25), DaysToGoConfig.NO_HOUR);
    Test.assertEqual(DaysToGoEvent.hourFromSetting(-1), DaysToGoConfig.NO_HOUR);
    return true;
}

// 1 March 2028 from every day of 2026, against an independent day-by-day walk.
(:test)
function matchesDayByDayWalk(logger as Test.Logger) as Boolean {
    var year = 2026;
    var month = 1;
    var day = 1;
    while (year == 2026) {
        var walk = 0;
        var wy = year;
        var wm = month;
        var wd = day;
        while (!(wy == 2028 && wm == 3 && wd == 1)) {
            wd++;
            if (wd > DaysToGoCalendar.daysInMonth(wy, wm)) {
                wd = 1;
                wm++;
                if (wm > 12) {
                    wm = 1;
                    wy++;
                }
            }
            walk++;
        }
        var r = resolveAt(3, 1, 2028, -1, year, month, day, 0);
        Test.assertEqual(r.days, walk);
        day++;
        if (day > DaysToGoCalendar.daysInMonth(year, month)) {
            day = 1;
            month++;
            if (month > 12) {
                month = 1;
                year++;
            }
        }
    }
    return true;
}

// The clock reader returns a plausible date and a time of day inside one day.
(:test)
function localTimeIsSane(logger as Test.Logger) as Boolean {
    var now = DaysToGoLocalTime.now();
    Test.assert(DaysToGoCalendar.isValid(now.year, now.month, now.day));
    Test.assert(now.secondOfDay >= 0 && now.secondOfDay < DaysToGoConfig.SECONDS_PER_DAY);
    return true;
}
