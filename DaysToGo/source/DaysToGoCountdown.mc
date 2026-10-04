import Toybox.Lang;

// Pure: no clock, settings or drawing in here, so every edge case is a unit test.
// The day count is whole local calendar days (ADR-004). A timed event also has an instant (its time in its own zone,
// ADR-018 (the event minute and zone)); the instant only decides when HOURS starts and when TODAY arrives.
class DaysToGoCountdown {

    static function resolve(event as DaysToGoEvent, now as DaysToGoLocalTime) as DaysToGoResult {
        if (event.year == DaysToGoConfig.EVERY_YEAR) {
            // 31 Apr and 30 Feb exist in no year; 29 Feb is fine (it exists in a leap year).
            if (!DaysToGoCalendar.isValid(DaysToGoConfig.LEAP_SAMPLE_YEAR, event.month, event.day)) {
                return new DaysToGoResult(DaysToGoConfig.PHASE_INVALID, 0, 0, now.year, event.month, event.day);
            }
            return nextOccurrence(event, now);
        }
        if (!DaysToGoCalendar.isValid(event.year, event.month, event.day)) {
            return new DaysToGoResult(DaysToGoConfig.PHASE_INVALID, 0, 0, event.year, event.month, event.day);
        }
        return occurrence(event, event.year, event.day, now);
    }

    // The first of last year's, this year's and next year's occurrence that is not over. Last year's matters only
    // across New Year, when a zone keeps a timed event alive after its written day (ADR-018); otherwise it is PAST.
    // A timed event whose time has arrived stays "today" until midnight, same as a one-off event.
    private static function nextOccurrence(event as DaysToGoEvent, now as DaysToGoLocalTime) as DaysToGoResult {
        var result = occurrence(event, now.year - 1, leapAdjusted(now.year - 1, event.month, event.day), now);
        for (var year = now.year; result.phase == DaysToGoConfig.PHASE_PAST; year++) {
            result = occurrence(event, year, leapAdjusted(year, event.month, event.day), now);
        }
        return result;
    }

    private static function occurrence(event as DaysToGoEvent, year as Number, day as Number, now as DaysToGoLocalTime) as DaysToGoResult {
        var eventDay = DaysToGoCalendar.dayNumber(year, event.month, day);
        if (event.hour == DaysToGoConfig.NO_HOUR) {
            return allDay(eventDay - now.dayNumber(), year, event.month, day);
        }
        return timed(event, eventDay, now, year, day);
    }

    // An all-day event: calendar days only, no zone and no clock (ADR-004).
    private static function allDay(diff as Number, year as Number, month as Number, day as Number) as DaysToGoResult {
        if (diff > 0) {
            return new DaysToGoResult(DaysToGoConfig.PHASE_UPCOMING, diff, 0, year, month, day);
        }
        if (diff == 0) {
            return new DaysToGoResult(DaysToGoConfig.PHASE_TODAY, 0, 0, year, month, day);
        }
        return new DaysToGoResult(DaysToGoConfig.PHASE_PAST, -diff, 0, year, month, day);
    }

    // A timed event. remaining is the seconds to the event's instant. It is the same number on any watch zone.
    //   0 < remaining < 24 h  HOURS, shown as H:MM
    //   remaining >= 24 h     UPCOMING, the calendar days to the written date (at least 1: a zone can put the instant
    //                         more than a day off while the written date is already today)
    //   remaining <= 0        TODAY until the last local day it can still be called the event's: the later of the
    //                         written date and the watch-local day the instant fell on; then PAST, counted from it
    private static function timed(event as DaysToGoEvent, eventDay as Number, now as DaysToGoLocalTime,
                                  year as Number, day as Number) as DaysToGoResult {
        var shift = shiftSeconds(event, now);
        var eventSec = event.hour * DaysToGoConfig.SECONDS_PER_HOUR + event.minute * DaysToGoConfig.SECONDS_PER_MINUTE;
        var diff = eventDay - now.dayNumber();
        var remaining = diff * DaysToGoConfig.SECONDS_PER_DAY + eventSec - now.secondOfDay + shift;
        if (remaining >= DaysToGoConfig.SECONDS_PER_DAY) {
            return new DaysToGoResult(DaysToGoConfig.PHASE_UPCOMING, diff > 1 ? diff : 1, 0, year, event.month, day);
        }
        if (remaining > 0) {
            return new DaysToGoResult(DaysToGoConfig.PHASE_HOURS, 0, remaining, year, event.month, day);
        }
        var arrival = eventDay + floorDiv(eventSec + shift, DaysToGoConfig.SECONDS_PER_DAY);
        var since = now.dayNumber() - (arrival > eventDay ? arrival : eventDay);
        if (since <= 0) {
            return new DaysToGoResult(DaysToGoConfig.PHASE_TODAY, 0, 0, year, event.month, day);
        }
        return new DaysToGoResult(DaysToGoConfig.PHASE_PAST, since, 0, year, event.month, day);
    }

    // How far the watch's wall clock is ahead of the event's wall clock right now: 0 for the watch's own zone.
    private static function shiftSeconds(event as DaysToGoEvent, now as DaysToGoLocalTime) as Number {
        var offset = DaysToGoEvent.zoneOffset(event.zone);
        return offset == null ? 0 : now.offset - (offset as Number);
    }

    // Integer division that rounds toward minus infinity (Monkey C's rounds toward zero).
    private static function floorDiv(value as Number, by as Number) as Number {
        return value >= 0 ? value / by : -((-value + by - 1) / by);
    }

    // 29 Feb in a common year is counted to 28 Feb.
    static function leapAdjusted(year as Number, month as Number, day as Number) as Number {
        var moved = month == 2 && day == DaysToGoConfig.LEAP_DAY && !DaysToGoCalendar.isLeap(year);
        return moved ? DaysToGoConfig.LEAP_DAY_FALLBACK : day;
    }
}
