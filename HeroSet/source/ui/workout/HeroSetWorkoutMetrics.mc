import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.Sensor;
import Toybox.System;

// No FIT activity backs these readouts (ADR-016 superseded — see ADR-021):
// one Garmin Connect activity per set cluttered the timeline/Strava feed.
// Instead this reads two things Garmin already computes with no recording
// session and no permission beyond Sensor: on-demand heart rate
// (Sensor.getInfo().heartRate) and the day's cumulative calories
// (ActivityMonitor.getInfo().calories) — the delta from set start is this
// set's attributable estimate. No Training Effect/Status without a saved
// activity; that trade is accepted.
class HeroSetWorkoutMetrics {

    private var _startedAt as Lang.Number?;
    private var _startCalories as Lang.Number?;
    private var _wideFormat as Lang.String;
    private var _tightFormat as Lang.String;

    function initialize() {
        // Loaded once: the workout view redraws every second.
        _wideFormat = HeroSetText.load(Rez.Strings.workout_metrics_wide);
        _tightFormat = HeroSetText.load(Rez.Strings.workout_metrics_tight);
    }

    // Called on every show; only the first show sets the baseline, so
    // resuming from the Back menu doesn't restart the clock or calories.
    function begin() as Void {
        if (_startedAt == null) {
            _startedAt = System.getTimer();
        }
        if (_startCalories == null) {
            _startCalories = currentDailyCalories();
        }
    }

    // Widest first; the caller picks whichever fits the row.
    function candidates() as Lang.Array<Lang.String> {
        var args = [elapsedText(), hrText(), caloriesText()];
        return [Lang.format(_wideFormat, args), Lang.format(_tightFormat, args)];
    }

    private function elapsedText() as Lang.String {
        var startedAt = _startedAt;
        return HeroSetText.duration(startedAt == null ? 0 : System.getTimer() - startedAt);
    }

    private function hrText() as Lang.String {
        var info = Sensor.getInfo();
        var hr = info == null ? null : info.heartRate;
        return hr instanceof Lang.Number ? hr.toString() : "--";
    }

    private function caloriesText() as Lang.String {
        var start = _startCalories;
        var current = currentDailyCalories();
        if (start == null || current == null) {
            return "--";
        }
        var delta = current - start;
        return (delta < 0 ? 0 : delta).toString();
    }

    private function currentDailyCalories() as Lang.Number? {
        var info = ActivityMonitor.getInfo();
        var calories = info == null ? null : info.calories;
        return calories instanceof Lang.Number ? calories : null;
    }
}
