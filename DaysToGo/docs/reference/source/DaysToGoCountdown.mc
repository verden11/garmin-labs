import Toybox.Lang;

// Pure: no clock, settings or drawing in here, so every edge case is a unit test.
class DaysToGoCountdown {

    static function resolve(event as DaysToGoEvent, now as DaysToGoLocalTime) as DaysToGoResult {
        var year = event.year;
        var day = event.day;
        if (year == DaysToGoConfig.EVERY_YEAR) {
            // 31 Apr and 30 Feb exist in no year; 29 Feb is fine (it exists in a leap year).
            if (!DaysToGoCalendar.isValid(DaysToGoConfig.LEAP_SAMPLE_YEAR, event.month, event.day)) {
                return new DaysToGoResult(DaysToGoConfig.PHASE_INVALID, 0, 0, now.year, event.month, event.day);
            }
            year = nextOccurrenceYear(event, now);
            day = leapAdjusted(year, event.month, event.day);
        } else if (!DaysToGoCalendar.isValid(year, event.month, day)) {
            return new DaysToGoResult(DaysToGoConfig.PHASE_INVALID, 0, 0, year, event.month, day);
        }
        var diff = DaysToGoCalendar.dayNumber(year, event.month, day) - now.dayNumber();
        return classify(diff, eventSecond(event), event.hour != DaysToGoConfig.NO_HOUR, now, year, event.month, day);
    }

    // Days (or seconds, for a timed event inside its last 24 h) until the
    // event, or how long since. diff is whole calendar days from today.
    private static function classify(diff as Number, eventSec as Number, timed as Boolean, now as DaysToGoLocalTime,
                                     year as Number, month as Number, day as Number) as DaysToGoResult {
        if (timed) {
            var remaining = diff * DaysToGoConfig.SECONDS_PER_DAY + eventSec - now.secondOfDay;
            if (remaining > 0) {
                if (remaining < DaysToGoConfig.SECONDS_PER_DAY) {
                    return new DaysToGoResult(DaysToGoConfig.PHASE_HOURS, 0, remaining, year, month, day);
                }
                return new DaysToGoResult(DaysToGoConfig.PHASE_UPCOMING, diff, 0, year, month, day);
            }
            // The time has arrived: it stays "today" until midnight.
            if (diff >= 0) {
                return new DaysToGoResult(DaysToGoConfig.PHASE_TODAY, 0, 0, year, month, day);
            }
        } else if (diff > 0) {
            return new DaysToGoResult(DaysToGoConfig.PHASE_UPCOMING, diff, 0, year, month, day);
        } else if (diff == 0) {
            return new DaysToGoResult(DaysToGoConfig.PHASE_TODAY, 0, 0, year, month, day);
        }
        return new DaysToGoResult(DaysToGoConfig.PHASE_PAST, -diff, 0, year, month, day);
    }

    // This year's occurrence unless it is over: a past date, or today with
    // the hour already reached. An all-day event stays "today" until midnight.
    private static function nextOccurrenceYear(event as DaysToGoEvent, now as DaysToGoLocalTime) as Number {
        var day = leapAdjusted(now.year, event.month, event.day);
        var eventDay = DaysToGoCalendar.dayNumber(now.year, event.month, day);
        var today = now.dayNumber();
        var over = eventDay < today
            || (eventDay == today && event.hour != DaysToGoConfig.NO_HOUR && now.secondOfDay >= eventSecond(event));
        return over ? now.year + 1 : now.year;
    }

    // 29 Feb in a common year is counted to 28 Feb.
    static function leapAdjusted(year as Number, month as Number, day as Number) as Number {
        var moved = month == 2 && day == DaysToGoConfig.LEAP_DAY && !DaysToGoCalendar.isLeap(year);
        return moved ? DaysToGoConfig.LEAP_DAY_FALLBACK : day;
    }

    private static function eventSecond(event as DaysToGoEvent) as Number {
        return event.hour == DaysToGoConfig.NO_HOUR ? 0 : event.hour * DaysToGoConfig.SECONDS_PER_HOUR;
    }
}
