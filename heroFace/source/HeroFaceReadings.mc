import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Weather;

// Gathers one frame's HeroFaceState from the watch. Everything here can come
// back null on some watch or at some moment; each field degrades to "not
// shown" rather than a fake value.
class HeroFaceReadings {

    static function take(settings as HeroFaceSettings, kinds as Array<Number>, streak as HeroFaceStreak, link as HeroFaceLink, withSeconds as Boolean) as HeroFaceState {
        var state = new HeroFaceState();
        var clock = System.getClockTime();
        state.time = timeText(clock.hour, clock.min, System.getDeviceSettings().is24Hour);
        state.seconds = withSeconds ? clock.sec.format("%02d") : null;
        state.dateLines = dateLines();
        state.temperature = settings.weather ? temperature() : null;
        state.accent = settings.accent;
        var hero = settings.mode == HeroFaceConfig.MODE_EVERYDAY ? null : heroProgress(link);
        if (hero != null) {
            fillHeroSet(state, hero);
        } else {
            fillEveryday(state, kinds, streak);
        }
        state.battery = System.getSystemStats().battery.toNumber();
        state.heartRate = heartRate();
        var count = System.getDeviceSettings().notificationCount;
        state.notifications = count != null ? count : 0;
        return state;
    }

    // 24 h keeps the leading zero (07:05); 12 h drops it (7:05), as Garmin's
    // own faces do.
    static function timeText(hour as Number, minute as Number, is24Hour as Boolean) as String {
        var hours = hour;
        if (!is24Hour) {
            hours = hour % HeroFaceConfig.HOURS_PER_HALF_DAY;
            if (hours == 0) {
                hours = HeroFaceConfig.HOURS_PER_HALF_DAY;
            }
            return hours + ":" + minute.format("%02d");
        }
        return hours.format("%02d") + ":" + minute.format("%02d");
    }

    // Weekday and month come from the system in the watch's language, so the
    // date is translated for free. It sits in the narrow row under the ring's
    // top, which fits the month but not a temperature beside it.
    private static function dateLines() as Array<String> {
        var info = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var full = (info.day_of_week + " " + info.day + " " + info.month).toUpper();
        var short = (info.day_of_week + " " + info.day).toUpper();
        return [full, short] as Array<String>;
    }

    private static function temperature() as String? {
        if (!(Toybox has :Weather)) {
            return null;
        }
        var conditions = Weather.getCurrentConditions();
        if (conditions == null || conditions.temperature == null) {
            return null;
        }
        var celsius = conditions.temperature as Numeric;
        var value = System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE ? celsius * 9 / 5.0 + 32 : celsius;
        return HeroFaceText.format(Rez.Strings.value_temperature, [value.toNumber()]);
    }

    private static function heroProgress(link as HeroFaceLink) as Array<Number>? {
        if (!link.isLinked()) {
            return null;
        }
        var today = Time.today();
        var yesterday = new Time.Moment(today.value() - HeroFaceConfig.HALF_DAY_SECONDS);
        return link.progress(dayKey(today), dayKey(yesterday));
    }

    // YYYYMMDD in local time, the key HeroSet publishes.
    static function dayKey(moment as Time.Moment) as Number {
        var info = Gregorian.info(moment, Time.FORMAT_SHORT);
        return (info.year as Number) * 10000 + (info.month as Number) * 100 + info.day;
    }

    private static function fillHeroSet(state as HeroFaceState, hero as Array<Number>) as Void {
        // HeroSet's daily goal is the user's own setting, published with the
        // rest; a hardcoded hundred would mis-draw every other goal.
        var goal = hero[HeroFaceContract.GOAL];
        state.metrics = [
            new HeroFaceMetric(HeroFaceConfig.PUSHUPS, hero[HeroFaceContract.PUSH], goal),
            new HeroFaceMetric(HeroFaceConfig.SITUPS, hero[HeroFaceContract.SIT], goal),
            new HeroFaceMetric(HeroFaceConfig.SQUATS, hero[HeroFaceContract.SQUAT], goal)
        ] as Array<HeroFaceMetric>;
        // Gold ring = XP into the current rank, exactly HeroSet's dashboard.
        state.ringPermille = hero[HeroFaceContract.RANK_PERCENT] * 10;
        state.ringColor = HeroFacePalette.GOLD;
        var rank = hero[HeroFaceContract.RANK];
        var days = hero[HeroFaceContract.STREAK];
        // No streak means the rank stands alone: "STREAK 0" is noise, and a
        // shortened "0D" was unreadable.
        state.streakLines = days > 0
            ? [HeroFaceText.format(Rez.Strings.rank_streak, [rank, days]), HeroFaceText.format(Rez.Strings.rank_only, [rank])] as Array<String>
            : [HeroFaceText.format(Rez.Strings.rank_only, [rank])] as Array<String>;
        state.streakKept = true;
    }

    private static function fillEveryday(state as HeroFaceState, kinds as Array<Number>, streak as HeroFaceStreak) as Void {
        var info = ActivityMonitor.getInfo();
        state.metrics = HeroFaceMetrics.read(kinds, info);
        state.ringPermille = dayScore(state.metrics);
        state.ringColor = state.ringPermille >= 1000 ? HeroFacePalette.DONE : state.accent;
        var steps = info.steps != null ? info.steps : 0;
        var goal = info.stepGoal != null ? info.stepGoal : 0;
        var days = streak.current(steps as Number, goal as Number);
        // A streak is something kept; on the first day there is nothing to
        // show, and "0-DAY STREAK" would be the first thing a new owner reads.
        if (days != null && days > 0) {
            state.streakLines = [
                HeroFaceText.format(Rez.Strings.streak_long, [days]),
                HeroFaceText.format(Rez.Strings.streak_short, [days])
            ] as Array<String>;
            state.streakKept = true;
        }
    }

    // The ring is the whole day at once: the average fill of the goal-bearing
    // missions, full only when every one is done.
    static function dayScore(metrics as Array<HeroFaceMetric>) as Number {
        var sum = 0;
        var count = 0;
        for (var i = 0; i < metrics.size(); i++) {
            if (metrics[i].hasBar()) {
                sum += metrics[i].permille();
                count++;
            }
        }
        return count > 0 ? sum / count : 0;
    }

    // currentHeartRate is often null while the face sleeps; the newest
    // sample from the watch's HR history is the same number Garmin shows.
    private static function heartRate() as Number? {
        var live = Activity.getActivityInfo();
        if (live != null && live.currentHeartRate != null) {
            return live.currentHeartRate;
        }
        if (!(ActivityMonitor has :getHeartRateHistory)) {
            return null;
        }
        var sample = ActivityMonitor.getHeartRateHistory(1, true).next();
        if (sample == null || sample.heartRate == null || sample.heartRate == ActivityMonitor.INVALID_HR_SAMPLE) {
            return null;
        }
        return sample.heartRate;
    }
}
