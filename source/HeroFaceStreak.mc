import Toybox.ActivityMonitor;
import Toybox.Application;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;

// Step-goal streak without HeroSet. The watch keeps only ~7 days of history,
// so the streak through yesterday is also stored and extended from there;
// that lets it grow past a week.
class HeroFaceStreak {

    private var _day as Number = -1;
    private var _throughYesterday as Number?;

    // Days in a row the step goal was met, today included once met. Null
    // when the watch has no step goal at all, so the face hides the row.
    function current(stepsToday as Number, goalToday as Number) as Number? {
        if (goalToday <= 0) {
            return null;
        }
        var today = HeroFaceStreak.dayIndex(Time.today());
        if (today != _day) {
            _day = today;
            _throughYesterday = refresh(today - 1);
        }
        var base = _throughYesterday != null ? _throughYesterday : 0;
        return stepsToday >= goalToday ? base + 1 : base;
    }

    private function refresh(yesterday as Number) as Number {
        var stored = Application.Storage.getValue(HeroFaceConfig.STREAK_KEY);
        var previous = (stored instanceof Array && stored.size() == 2 && stored[0] instanceof Number && stored[1] instanceof Number)
            ? stored as Array<Number>
            : null;
        var streak = HeroFaceStreak.throughYesterday(history(), yesterday, previous);
        Application.Storage.setValue(HeroFaceConfig.STREAK_KEY, [yesterday, streak] as Array<Number>);
        return streak;
    }

    // Day index -> goal met, from the watch's daily history.
    private static function history() as Dictionary<Number, Boolean> {
        var met = {} as Dictionary<Number, Boolean>;
        var days = ActivityMonitor.getHistory();
        for (var i = 0; i < days.size(); i++) {
            var day = days[i];
            var start = day.startOfDay;
            if (start != null && day.steps != null && day.stepGoal != null && day.stepGoal > 0) {
                met[dayIndex(start)] = day.steps >= day.stepGoal;
            }
        }
        return met;
    }

    // Pure streak math, unit-tested. `met` covers only the days the watch
    // still remembers. `stored` is [endDay, length] from an earlier run: it
    // continues the run when its end sits inside the met days, or right
    // before the oldest remembered day.
    static function throughYesterday(met as Dictionary<Number, Boolean>, yesterday as Number, stored as Array<Number>?) as Number {
        var run = 0;
        while (met.hasKey(yesterday - run) && met[yesterday - run] == true) {
            run++;
        }
        if (stored == null) {
            return run;
        }
        var gap = yesterday - stored[0];
        var reachesEdge = !met.hasKey(yesterday - run);
        if (gap >= 0 && (gap < run || (gap == run && reachesEdge))) {
            var extended = stored[1] + gap;
            return extended > run ? extended : run;
        }
        return run;
    }

    // Local calendar day number. Rounding from mid-day keeps it stable across
    // DST changes, where local midnight is 23 or 25 hours from the last one.
    static function dayIndex(moment as Time.Moment) as Number {
        var offset = System.getClockTime().timeZoneOffset;
        return (moment.value() + offset + HeroFaceConfig.HALF_DAY_SECONDS) / HeroFaceConfig.SECONDS_PER_DAY;
    }
}
