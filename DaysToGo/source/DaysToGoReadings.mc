import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

// Turns settings plus the clock into a DaysToGoState. The only place that
// touches the system; everything it calls to decide is pure and tested.
class DaysToGoReadings {

    static function take(settings as DaysToGoSettings) as DaysToGoState {
        var now = DaysToGoLocalTime.now();
        var event = DaysToGoEvent.fromSettings(settings.event, settings.month, settings.day, settings.year, settings.hour);
        var device = System.getDeviceSettings();
        var monthFirst = DaysToGoDateText.monthFirstFor(settings.dateStyle);
        var hour = now.secondOfDay / DaysToGoConfig.SECONDS_PER_HOUR;
        var minute = now.secondOfDay % DaysToGoConfig.SECONDS_PER_HOUR / DaysToGoConfig.SECONDS_PER_MINUTE;
        var state = build(settings, DaysToGoCountdown.resolve(event, now), now.year, monthFirst);
        state.time = timeText(hour, minute, device.is24Hour);
        state.footer = footerText(settings.footer);
        return state;
    }

    // Pure: same inputs, same words.
    static function build(settings as DaysToGoSettings, result as DaysToGoResult, currentYear as Number, monthFirst as Boolean) as DaysToGoState {
        var state = new DaysToGoState();
        state.phase = result.phase;
        state.accent = DaysToGoPalette.accent(settings.accent);
        if (result.phase == DaysToGoConfig.PHASE_INVALID) {
            // Never a number or a date line for a date that does not exist.
            state.hero = DaysToGoText.get(Rez.Strings.cap_invalid);
            state.heroIsWord = true;
            state.ringTrack = false;
            return state;
        }
        state.name = settings.name;
        state.dateLines = DaysToGoDateText.forDate(result.year, result.month, result.day, currentYear, monthFirst);
        if (result.phase == DaysToGoConfig.PHASE_UPCOMING) {
            fillUpcoming(state, result.days, settings.unit == DaysToGoConfig.UNIT_WEEKS);
        } else if (result.phase == DaysToGoConfig.PHASE_HOURS) {
            state.hero = hoursText(result.seconds);
            state.captionLines = [DaysToGoText.get(Rez.Strings.cap_hours)] as Array<String>;
            state.ringPermille = result.seconds * DaysToGoConfig.PERMILLE / DaysToGoConfig.SECONDS_PER_DAY;
        } else if (result.phase == DaysToGoConfig.PHASE_TODAY) {
            state.hero = DaysToGoText.get(Rez.Strings.cap_today);
            state.heroIsWord = true;
            state.ringPermille = DaysToGoConfig.PERMILLE;
        } else {
            state.hero = result.days.toString();
            state.captionLines = [DaysToGoText.get(result.days == 1 ? Rez.Strings.cap_since_day : Rez.Strings.cap_since_days)] as Array<String>;
        }
        return state;
    }

    // Square root of the share of the year left, so the last days stay visible:
    // 1 day is 5% of the ring (linear would be 0.3%, a sliver), 30 days 29%, 91 days 50%.
    static function ringPermilleFor(days as Number) as Number {
        return (Math.sqrt(days.toFloat() / DaysToGoConfig.DAYS_PER_YEAR) * DaysToGoConfig.PERMILLE).toNumber();
    }

    // Weeks mode applies from one full week on; under that the days are the honest number.
    private static function fillUpcoming(state as DaysToGoState, days as Number, weeks as Boolean) as Void {
        // More than a year away: track only, so a full accent ring only ever means the day itself.
        state.ringPermille = days > DaysToGoConfig.DAYS_PER_YEAR ? 0 : ringPermilleFor(days);
        if (weeks && days >= DaysToGoConfig.DAYS_PER_WEEK) {
            var whole = days / DaysToGoConfig.DAYS_PER_WEEK;
            var rest = days % DaysToGoConfig.DAYS_PER_WEEK;
            var caption = DaysToGoText.get(whole == 1 ? Rez.Strings.cap_week : Rez.Strings.cap_weeks);
            state.hero = whole.toString();
            // One wording only: dropping "+ n DAYS" when tight would leave a wrong number.
            state.captionLines = [rest == 0 ? caption : caption + " + " + rest + " " + dayWord(rest)] as Array<String>;
            return;
        }
        state.hero = days.toString();
        state.captionLines = [dayWord(days)] as Array<String>;
    }

    private static function dayWord(days as Number) as String {
        return DaysToGoText.get(days == 1 ? Rez.Strings.cap_day : Rez.Strings.cap_days);
    }

    // H:MM, rounded up so it never reads 0:00 while time is still left.
    static function hoursText(seconds as Number) as String {
        var minutes = (seconds + DaysToGoConfig.SECONDS_PER_MINUTE - 1) / DaysToGoConfig.SECONDS_PER_MINUTE;
        return (minutes / DaysToGoConfig.SECONDS_PER_MINUTE) + ":" + (minutes % DaysToGoConfig.SECONDS_PER_MINUTE).format("%02d");
    }

    // 24 h keeps the leading zero (07:05); 12 h drops it (7:05), like Garmin's own faces.
    static function timeText(hour as Number, minute as Number, is24Hour as Boolean) as String {
        if (is24Hour) {
            return hour.format("%02d") + ":" + minute.format("%02d");
        }
        var hours = hour % DaysToGoConfig.HOURS_PER_HALF_DAY;
        return (hours == 0 ? DaysToGoConfig.HOURS_PER_HALF_DAY : hours) + ":" + minute.format("%02d");
    }

    // A value the watch does not have is hidden, never faked.
    private static function footerText(kind as Number) as String? {
        if (kind == DaysToGoConfig.FOOTER_BATTERY) {
            return System.getSystemStats().battery.toNumber() + "%";
        }
        if (kind == DaysToGoConfig.FOOTER_STEPS) {
            var steps = ActivityMonitor.getInfo().steps;
            return steps == null ? null : stepsText(steps);
        }
        return null;
    }

    // 950, 1.2K, 12.3K, 99.9K, then whole thousands (123K).
    static function stepsText(steps as Number) as String {
        if (steps < DaysToGoConfig.STEPS_SHORT_FROM) {
            return steps.toString();
        }
        var thousands = steps / DaysToGoConfig.STEPS_PER_THOUSAND;
        // 99,950 and up round to a 3-digit "100K", so it takes the whole-thousand form.
        var tenths = thousands < DaysToGoConfig.STEPS_TENTHS_BELOW;
        var text = tenths ? thousands.format("%.1f") : ((steps + DaysToGoConfig.STEPS_ROUND) / DaysToGoConfig.STEPS_SHORT_FROM).toString();
        return DaysToGoText.format(Rez.Strings.value_thousands, [text]);
    }
}
