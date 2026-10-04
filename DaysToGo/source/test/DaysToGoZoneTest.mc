import Toybox.Lang;
import Toybox.Test;

// Pro only: an event with a minute and a time zone (docs/decisions.md ADR-018, the event minute and zone).
// The rule table in the ADR is d (calendar days from the watch's today to the written date) and r (seconds to the
// event's instant); each test below names the row it checks. hour is the real hour 0..23; offsets are minutes east of UTC.

function zoneAt(minutes as Number) as Number {
    return DaysToGoConfig.ZONE_UTC_INDEX + minutes / 15;
}

function seconds(hour as Number, minute as Number, second as Number) as Number {
    return hour * 3600 + minute * 60 + second;
}

// An event on a written date at hour:minute in zoneMinutes (null = the watch's own zone); the watch's local date and time
// of day, and its own offset from UTC in minutes. (Monkey C on the older products allows 9 arguments at most, hence the split.)
function zEvent(month as Number, day as Number, year as Number, hour as Number, minute as Number, zoneMinutes as Number?) as DaysToGoEvent {
    var zone = zoneMinutes == null ? DaysToGoConfig.ZONE_WATCH : zoneAt(zoneMinutes as Number);
    return new DaysToGoEvent(month, day, year, hour, minute, zone);
}

function zNow(year as Number, month as Number, day as Number, second as Number, watchMinutes as Number) as DaysToGoLocalTime {
    return new DaysToGoLocalTime(year, month, day, second, watchMinutes * 60);
}

function resolveZ(event as DaysToGoEvent, now as DaysToGoLocalTime) as DaysToGoResult {
    return DaysToGoCountdown.resolve(event, now);
}

// Settings list value to offset: 1 is UTC-12:00, 49 is UTC+00:00, 105 is UTC+14:00; 0 and anything else is the watch's zone.
(:test, :pro)
function zoneSettingMapsToOffsets(logger as Test.Logger) as Boolean {
    Test.assert(DaysToGoEvent.zoneOffset(0) == null);
    Test.assertEqual(DaysToGoEvent.zoneOffset(1) as Number, -12 * 3600);
    Test.assertEqual(DaysToGoEvent.zoneOffset(49) as Number, 0);
    Test.assertEqual(DaysToGoEvent.zoneOffset(105) as Number, 14 * 3600);
    Test.assertEqual(DaysToGoEvent.zoneOffset(zoneAt(345)) as Number, 345 * 60);    // Nepal, UTC+05:45
    Test.assertEqual(DaysToGoEvent.zoneOffset(zoneAt(-570)) as Number, -570 * 60);  // Marquesas, UTC-09:30
    Test.assert(DaysToGoEvent.zoneOffset(106) == null);
    Test.assert(DaysToGoEvent.zoneOffset(-1) == null);
    return true;
}

// Row "default zone": no zone chosen is the wall clock, so a minute alone behaves like Hour did, to the minute.
// Also "minute rollover": the last second before the minute is HOURS and reads 0:01; the minute itself is TODAY.
(:test, :pro)
function defaultZoneCountsToTheMinute(logger as Test.Logger) as Boolean {
    var r = resolveZ(zEvent(12, 25, 2026, 18, 30, null), zNow(2026, 12, 25, seconds(10, 39, 0), 60));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "7:51");
    r = resolveZ(zEvent(12, 25, 2026, 18, 30, null), zNow(2026, 12, 25, seconds(18, 29, 59), 60));
    Test.assertEqual(r.seconds, 1);
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "0:01");
    r = resolveZ(zEvent(12, 25, 2026, 18, 30, null), zNow(2026, 12, 25, seconds(18, 29, 0), 60));
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "0:01");
    r = resolveZ(zEvent(12, 25, 2026, 18, 30, null), zNow(2026, 12, 25, seconds(18, 30, 0), 60));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    r = resolveZ(zEvent(12, 25, 2026, 18, 30, null), zNow(2026, 12, 25, seconds(23, 59, 59), 60));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);    // stays today until midnight
    r = resolveZ(zEvent(12, 25, 2026, 18, 30, null), zNow(2026, 12, 26, 0, 60));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_PAST);
    Test.assertEqual(r.days, 1);
    return true;
}

// Midnight edge. A midnight event with a zone: the minute before it is HOURS, the instant is TODAY, in the watch's own clock.
(:test, :pro)
function midnightEdgeWithAZone(logger as Test.Logger) as Boolean {
    // Event 25 Dec 00:00 UTC+0, watch UTC+2: the instant is 02:00 on the watch.
    var r = resolveZ(zEvent(12, 25, 2026, 0, 0, 0), zNow(2026, 12, 24, seconds(23, 59, 59), 120));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(r.seconds, 7201);
    r = resolveZ(zEvent(12, 25, 2026, 0, 0, 0), zNow(2026, 12, 25, seconds(1, 59, 59), 120));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(r.seconds, 1);
    r = resolveZ(zEvent(12, 25, 2026, 0, 0, 0), zNow(2026, 12, 25, seconds(2, 0, 0), 120));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    return true;
}

// The count is local calendar days whatever the zone: it drops by one exactly at the watch's midnight (ADR-004 holds).
(:test, :pro)
function dayCountFlipsAtWatchMidnightWhateverTheZone(logger as Test.Logger) as Boolean {
    var zones = [-720, -570, 0, 345, 840] as Array<Number>;
    var watches = [-720, 0, 540, 840] as Array<Number>;
    for (var i = 0; i < zones.size(); i++) {
        for (var j = 0; j < watches.size(); j++) {
            var before = resolveZ(zEvent(7, 20, 2027, 20, 15, zones[i]), zNow(2027, 7, 9, seconds(23, 59, 59), watches[j]));
            var after = resolveZ(zEvent(7, 20, 2027, 20, 15, zones[i]), zNow(2027, 7, 10, 0, watches[j]));
            Test.assertEqual(before.phase, DaysToGoConfig.PHASE_UPCOMING);
            Test.assertEqual(before.days, 11);
            Test.assertEqual(after.days, 10);
        }
    }
    return true;
}

// Travel day, the event east of the watch: an event at 09:00 in Tokyo (UTC+9) on 10 Jun, a watch in New York (UTC-4).
// The instant is 00:00 UTC on 10 Jun = 20:00 on 9 Jun in New York.
(:test, :pro)
function travelDayEventEastOfTheWatch(logger as Test.Logger) as Boolean {
    var r = resolveZ(zEvent(6, 10, 2027, 9, 0, 540), zNow(2027, 6, 8, seconds(20, 0, 0), -240));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);   // exactly 24 h away: still the day count
    Test.assertEqual(r.days, 2);
    r = resolveZ(zEvent(6, 10, 2027, 9, 0, 540), zNow(2027, 6, 8, seconds(20, 0, 1), -240));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(r.seconds, 86399);
    r = resolveZ(zEvent(6, 10, 2027, 9, 0, 540), zNow(2027, 6, 9, 0, -240));
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "20:00");
    r = resolveZ(zEvent(6, 10, 2027, 9, 0, 540), zNow(2027, 6, 9, seconds(19, 59, 59), -240));
    Test.assertEqual(r.seconds, 1);
    // The instant has arrived (20:00 on the 9th): TODAY, and it stays TODAY through the written date, the 10th.
    r = resolveZ(zEvent(6, 10, 2027, 9, 0, 540), zNow(2027, 6, 9, seconds(20, 0, 0), -240));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    r = resolveZ(zEvent(6, 10, 2027, 9, 0, 540), zNow(2027, 6, 10, seconds(23, 59, 59), -240));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    r = resolveZ(zEvent(6, 10, 2027, 9, 0, 540), zNow(2027, 6, 11, 0, -240));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_PAST);
    Test.assertEqual(r.days, 1);
    return true;
}

// Travel day, the event west of the watch: 20:00 in New York (UTC-4) on 8 Jun, a watch in Tokyo (UTC+9).
// The instant is 09:00 on 9 Jun in Tokyo, a day after the written date: HOURS starts and TODAY ends on the watch's 9th.
(:test, :pro)
function travelDayEventWestOfTheWatch(logger as Test.Logger) as Boolean {
    var r = resolveZ(zEvent(6, 8, 2027, 20, 0, -240), zNow(2027, 6, 9, 0, 540));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);      // the written date is yesterday here, the event is not over
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "9:00");
    r = resolveZ(zEvent(6, 8, 2027, 20, 0, -240), zNow(2027, 6, 9, seconds(9, 0, 0), 540));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    r = resolveZ(zEvent(6, 8, 2027, 20, 0, -240), zNow(2027, 6, 9, seconds(23, 59, 59), 540));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    r = resolveZ(zEvent(6, 8, 2027, 20, 0, -240), zNow(2027, 6, 10, 0, 540));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_PAST);
    Test.assertEqual(r.days, 1);
    return true;
}

// The written date is already today but the instant is more than a day away: a day count of at least 1, never "0 DAYS".
// Watch UTC+1, event 25 Dec 23:00 at UTC-10 (the instant is 10:00 on 26 Dec on the watch, 34 h after its 25 Dec midnight).
(:test, :pro)
function writtenDateReachedInstantStillAhead(logger as Test.Logger) as Boolean {
    var r = resolveZ(zEvent(12, 25, 2026, 23, 0, -600), zNow(2026, 12, 25, 0, 60));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);
    Test.assertEqual(r.days, 1);
    r = resolveZ(zEvent(12, 25, 2026, 23, 0, -600), zNow(2026, 12, 25, seconds(10, 0, 0), 60));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);   // exactly 24 h away
    r = resolveZ(zEvent(12, 25, 2026, 23, 0, -600), zNow(2026, 12, 25, seconds(10, 0, 1), 60));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "24:00");
    // On the 26th the written date is behind: HOURS, not "1 DAY SINCE", until 10:00; then TODAY (never skipped).
    r = resolveZ(zEvent(12, 25, 2026, 23, 0, -600), zNow(2026, 12, 26, 0, 60));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "10:00");
    r = resolveZ(zEvent(12, 25, 2026, 23, 0, -600), zNow(2026, 12, 26, seconds(10, 0, 0), 60));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    r = resolveZ(zEvent(12, 25, 2026, 23, 0, -600), zNow(2026, 12, 27, 0, 60));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_PAST);
    Test.assertEqual(r.days, 1);
    return true;
}

// Zone extremes, +14 and -12, against a watch on UTC and against each other (a 26 h shift, the largest there is).
(:test, :pro)
function zoneExtremesPlus14AndMinus12(logger as Test.Logger) as Boolean {
    // Event 1 Jan 2027 00:30 at UTC+14: the instant is 10:30 UTC on 31 Dec. Watch on UTC at 08:00: 2 h 30 left.
    var r = resolveZ(zEvent(1, 1, 2027, 0, 30, 840), zNow(2026, 12, 31, seconds(8, 0, 0), 0));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "2:30");
    r = resolveZ(zEvent(1, 1, 2027, 0, 30, 840), zNow(2026, 12, 31, seconds(10, 30, 0), 0));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);      // arrived on the 31st, which is before the written date
    r = resolveZ(zEvent(1, 1, 2027, 0, 30, 840), zNow(2027, 1, 1, 100, 0));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);      // the written date is still today
    r = resolveZ(zEvent(1, 1, 2027, 0, 30, 840), zNow(2027, 1, 2, 0, 0));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_PAST);
    // Event 1 Jan 2027 12:00 at UTC-12: the instant is 00:00 UTC on 2 Jan. Watch on UTC at 12:00 on the 1st: 12 h.
    r = resolveZ(zEvent(1, 1, 2027, 12, 0, -720), zNow(2027, 1, 1, seconds(12, 0, 0), 0));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "12:00");
    r = resolveZ(zEvent(1, 1, 2027, 12, 0, -720), zNow(2027, 1, 2, 0, 0));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    // The widest shift, the event at UTC-12 and the watch at UTC+14 (26 h ahead). Event 25 Dec 23:59: the instant is 11:59 UTC
    // on the 26th, which is 01:59 on the 27th for the watch. From the watch's 25 Dec 00:00 that is 49 h 59 min away.
    r = resolveZ(zEvent(12, 25, 2026, 23, 59, -720), zNow(2026, 12, 25, 0, 840));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);
    Test.assertEqual(r.days, 1);                                // the written date is today, still never "0 DAYS"
    r = resolveZ(zEvent(12, 25, 2026, 23, 59, -720), zNow(2026, 12, 26, 0, 840));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);   // 25 h 59 min: the written date is behind, the count never negative
    Test.assertEqual(r.days, 1);
    r = resolveZ(zEvent(12, 25, 2026, 23, 59, -720), zNow(2026, 12, 26, seconds(2, 0, 0), 840));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "23:59");
    r = resolveZ(zEvent(12, 25, 2026, 23, 59, -720), zNow(2026, 12, 27, seconds(1, 59, 0), 840));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    r = resolveZ(zEvent(12, 25, 2026, 23, 59, -720), zNow(2026, 12, 28, 0, 840));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_PAST);
    Test.assertEqual(r.days, 1);
    return true;
}

// DST-boundary day. London moves from GMT to BST at 01:00 UTC on Sunday 28 Mar 2027. An event at 12:00 on that day
// in UTC+1 (the offset in force on the event day, which the wearer chooses), seen from a watch still on GMT.
(:test, :pro)
function dstBoundaryDayIsExactWithAnExplicitOffset(logger as Test.Logger) as Boolean {
    var r = resolveZ(zEvent(3, 28, 2027, 12, 0, 60), zNow(2027, 3, 27, seconds(18, 0, 0), 0));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "17:00");   // 18:00 GMT to 11:00 UTC
    // The same event from the watch after its own clock moved (03:00 BST, offset +1): the same instant, 9 h to go.
    r = resolveZ(zEvent(3, 28, 2027, 12, 0, 60), zNow(2027, 3, 28, seconds(3, 0, 0), 60));
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "9:00");
    // The default zone is the watch's wall clock and knows nothing of a change in between: one hour too long (the known
    // limit, ADR-018). The wearer who wants the exact figure on a DST day picks the offset.
    r = resolveZ(zEvent(3, 28, 2027, 12, 0, null), zNow(2027, 3, 27, seconds(18, 0, 0), 0));
    Test.assertEqual(DaysToGoReadings.hoursText(r.seconds), "18:00");
    return true;
}

// Event already passed, with a zone: counted in watch-local calendar days from the written date (or from the day the
// instant fell on, when that is later), and an every-year event rolls to next year only once it is over.
(:test, :pro)
function passedEventsAndEveryYearRollover(logger as Test.Logger) as Boolean {
    var r = resolveZ(zEvent(6, 1, 2027, 10, 0, 0), zNow(2027, 6, 3, 0, 0));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_PAST);
    Test.assertEqual(r.days, 2);
    // Every year, 10 Jun 09:00 in Tokyo, a watch in New York: TODAY through the 10th, over from the 11th, then 364 days.
    r = resolveZ(zEvent(6, 10, 0, 9, 0, 540), zNow(2026, 6, 10, seconds(23, 0, 0), -240));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    r = resolveZ(zEvent(6, 10, 0, 9, 0, 540), zNow(2026, 6, 11, 0, -240));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);
    Test.assertEqual(r.year, 2027);
    Test.assertEqual(r.days, 364);
    // Across New Year: every year 31 Dec 23:00 at UTC-12, a watch at UTC+14. The instant is 01:00 on 2 Jan for the watch, so on
    // 1 Jan 04:00 (21 h before it) last year's occurrence is still alive; once it is over (3 Jan) the next is a year away.
    r = resolveZ(zEvent(12, 31, 0, 23, 0, -720), zNow(2027, 1, 1, seconds(4, 0, 0), 840));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_HOURS);
    Test.assertEqual(r.year, 2026);
    r = resolveZ(zEvent(12, 31, 0, 23, 0, -720), zNow(2027, 1, 2, seconds(1, 0, 0), 840));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    Test.assertEqual(r.year, 2026);
    r = resolveZ(zEvent(12, 31, 0, 23, 0, -720), zNow(2027, 1, 3, 0, 840));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);
    Test.assertEqual(r.year, 2027);
    return true;
}

// An all-day event ignores the zone and the minute: calendar days only, as in ADR-004, even if the settings hold them.
(:test, :pro)
function allDayEventIgnoresMinuteAndZone(logger as Test.Logger) as Boolean {
    var event = DaysToGoEvent.fromSettings(DaysToGoConfig.EVENT_CUSTOM, 6, 10, 2027, DaysToGoConfig.HOUR_SETTING_ALL_DAY, 45, 1);
    Test.assertEqual(event.hour, DaysToGoConfig.NO_HOUR);
    var r = DaysToGoCountdown.resolve(event, new DaysToGoLocalTime(2027, 6, 9, seconds(23, 59, 59), 14 * 3600));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_UPCOMING);
    Test.assertEqual(r.days, 1);
    r = DaysToGoCountdown.resolve(event, new DaysToGoLocalTime(2027, 6, 10, 0, -12 * 3600));
    Test.assertEqual(r.phase, DaysToGoConfig.PHASE_TODAY);
    return true;
}

// The Pro path end to end: the three phone settings, then the words. 19 is 18:00; 8:00 to 18:30 less 10:39 is 7:51.
(:test, :pro)
function minuteAndZoneReachTheFace(logger as Test.Logger) as Boolean {
    var s = new DaysToGoSettings({"Event" => 2, "Month" => 12, "Day" => 25, "Year" => 2026, "Hour" => 19,
                                  "Minute" => 30, "EventZone" => zoneAt(120)} as Dictionary);
    Test.assertEqual(s.minute, 30);
    Test.assertEqual(s.zone, zoneAt(120));
    var event = DaysToGoEvent.fromSettings(s.event, s.month, s.day, s.year, s.hour, s.minute, s.zone);
    // The event is 18:30 at UTC+2; the watch is on UTC+1 at 09:39, which is 10:39 at the event: 7 h 51 min.
    var r = DaysToGoCountdown.resolve(event, new DaysToGoLocalTime(2026, 12, 25, seconds(9, 39, 0), 3600));
    var state = DaysToGoReadings.build(s, r, 2026, false);
    Test.assertEqual(state.hero, "7:51");
    Test.assertEqual(state.captionLines[0], "HOURS");
    return true;
}

// Bad phone values fall back to the defaults: minute 0 and the watch's own zone.
(:test, :pro)
function badMinuteAndZoneFallBack(logger as Test.Logger) as Boolean {
    var s = new DaysToGoSettings({"Minute" => 60, "EventZone" => 106} as Dictionary);
    Test.assertEqual(s.minute, 0);
    Test.assertEqual(s.zone, DaysToGoConfig.ZONE_WATCH);
    s = new DaysToGoSettings({"Minute" => -1, "EventZone" => "x"} as Dictionary);
    Test.assertEqual(s.minute, 0);
    Test.assertEqual(s.zone, DaysToGoConfig.ZONE_WATCH);
    s = new DaysToGoSettings({"Minute" => 59, "EventZone" => 105} as Dictionary);
    Test.assertEqual(s.minute, 59);
    Test.assertEqual(s.zone, 105);
    return true;
}

// Free has neither setting: a dictionary that carries them (an old phone, a test) still gives the defaults.
(:test, :free)
function freeIgnoresMinuteAndZone(logger as Test.Logger) as Boolean {
    var s = new DaysToGoSettings({"Minute" => 30, "EventZone" => 1} as Dictionary);
    Test.assertEqual(s.minute, 0);
    Test.assertEqual(s.zone, DaysToGoConfig.ZONE_WATCH);
    return true;
}

// The clock reader's offset is the wall clock minus UTC, a whole number of quarter hours inside the real range.
(:test)
function localTimeOffsetIsSane(logger as Test.Logger) as Boolean {
    var offset = DaysToGoLocalTime.now().offset;
    Test.assert(offset >= -12 * 3600 && offset <= 14 * 3600);
    Test.assertEqual(offset % DaysToGoConfig.ZONE_STEP_SECONDS, 0);
    return true;
}
