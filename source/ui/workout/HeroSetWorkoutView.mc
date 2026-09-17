import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Sensor;
import Toybox.System;
import Toybox.Timer;
import Toybox.WatchUi;

// Live set screen: the rep count dominates, with today's running total and
// the no-FIT-session HR/calorie/elapsed readouts (HeroSetWorkoutMetrics,
// ADR-021) underneath.
class HeroSetWorkoutView extends WatchUi.View {

    private var _exercise;
    private var _label;
    private var _todayFormat;
    private var _finishHint;
    private var _detected = 0;
    private var _storedCount = 0;
    private var _sensorManager;
    private var _saved = false;
    private var _sampleRate;
    private var _counter;
    private var _metrics;
    private var _refreshTimer;
    private var _activitySync;

    function initialize(exercise as Lang.Symbol) {
        View.initialize();
        _exercise = exercise;
        _label = HeroSetText.exerciseLabel(exercise);
        _todayFormat = HeroSetText.load(Rez.Strings.today_progress);
        _finishHint = HeroSetText.load(Rez.Strings.workout_hint_finish);
        var store = getApp().getStore();
        _sampleRate = store.getCalibrationRate(exercise);
        _counter = new HeroSetRepCounter(store.getCalibrationArm(exercise), store.getCalibrationRelease(exercise), store.getCalibrationRate(exercise), store.getCalibrationCooldownMs(exercise));
        _sensorManager = new HeroSetSensorManager();
        _metrics = new HeroSetWorkoutMetrics();
        _activitySync = new HeroSetActivitySync();
    }

    function onShow() as Void {
        _storedCount = getApp().getStore().getCount(_exercise);
        _metrics.begin();
        enableSensors();
        enableHeartRate();
        startRefresh();
        beginActivitySync();
    }

    function onHide() as Void {
        stopRefresh();
        disableSensors();
        disableHeartRate();
        if (getApp().getStore().isSyncEnabled()) {
            _activitySync.endSet();
        }
    }

    // Opt-in Garmin Connect/Strava sync (ADR-025) — one combined FIT
    // activity per day spanning every set, paused between sets via
    // onHide/onShow so its duration reflects only real exercise time.
    private function beginActivitySync() as Void {
        HeroSetSyncCoordinator.beginSet(_activitySync);
    }

    // HR/calories/elapsed change between reps; rep detection alone would
    // leave them frozen until the next rep.
    private function startRefresh() as Void {
        if (_refreshTimer != null) {
            return;
        }
        _refreshTimer = new Timer.Timer();
        _refreshTimer.start(method(:onRefreshTick), HeroSetConfig.LIVE_REFRESH_MS, true);
    }

    private function stopRefresh() as Void {
        if (_refreshTimer != null) {
            _refreshTimer.stop();
            _refreshTimer = null;
        }
    }

    // Public: method(:symbol) needs indirect lookup, which can't see
    // private methods (ADR-023).
    function onRefreshTick() as Void {
        WatchUi.requestUpdate();
    }

    // Quick-save path: Save in the Back menu banks the detected count as-is,
    // no adjustment step (HeroSetWorkoutEndMenuDelegate). The primary Finish
    // path never calls this — it hands the detected count to
    // HeroSetManualPickerView instead, where the same reward feedback lives.
    function saveSet() as Void {
        if (_saved) {
            return;
        }
        _saved = true;
        if (_detected <= 0) {
            return;
        }
        var store = getApp().getStore();
        var countBefore = store.getCount(_exercise);
        var completedBefore = store.isDailyMissionComplete();
        store.add(_exercise, _detected);
        HeroSetSaveFeedback.show(_exercise, _detected, countBefore, store.getCount(_exercise), completedBefore, store.isDailyMissionComplete());
    }

    function getExercise() as Lang.Symbol {
        return _exercise;
    }

    function getCount() as Lang.Number {
        return _detected;
    }

    private function enableSensors() as Void {
        _sensorManager.start(method(:onSensorData), _sampleRate);
    }

    private function disableSensors() as Void {
        _sensorManager.stop();
    }

    private function enableHeartRate() as Void {
        if (Sensor has :setEnabledSensors) {
            try {
                Sensor.setEnabledSensors([Sensor.SENSOR_ONBOARD_HEARTRATE]);
            } catch (e) {
                System.println("[HeroSet] enableHeartRate: caught " + e.getErrorMessage());
            }
        }
    }

    private function disableHeartRate() as Void {
        if (Sensor has :setEnabledSensors) {
            try {
                Sensor.setEnabledSensors([]);
            } catch (e) {
                System.println("[HeroSet] disableHeartRate: caught " + e.getErrorMessage());
            }
        }
    }

    // Public, not private (ADR-023): `method(:onSensorData)` — required by
    // Sensor.registerSensorDataListener per Garmin's own SDK sample — needs
    // indirect symbol lookup, which the compiler will not resolve for a
    // private method. The previous `self.onSensorData` bare method reference
    // compiled fine and worked in the simulator, but real FR965 firmware
    // silently failed to dispatch the callback (crash: "Unexpected Type
    // Error" / "Error in sensor data callback", no stack trace, found via
    // git bisect against commit e134e74).
    public function onSensorData(data as Sensor.SensorData) as Void {
        if (data == null || data.accelerometerData == null) {
            return;
        }

        var x = data.accelerometerData.x;
        var y = data.accelerometerData.y;
        var z = data.accelerometerData.z;
        if (!(x instanceof Array) || !(y instanceof Array) || !(z instanceof Array)) {
            return;
        }

        for (var i = 0; i < x.size(); i++) {
            if (_counter.feedSample(x[i], y[i], z[i])) {
                _detected += 1;
                vibrateForRep();
                WatchUi.requestUpdate();
            }
        }
    }

    // The wrist is moving through the exercise, so a glance at the screen
    // isn't reliable mid-set. The rep that carries today's total over the
    // goal gets the goal buzz instead; crossedGoal is transition-only and
    // the total only grows during a set, so it fires at most once.
    private function vibrateForRep() as Void {
        var total = _storedCount + _detected;
        if (HeroSetRules.crossedGoal(total - 1, total)) {
            HeroSetHaptics.goalReached();
        } else {
            HeroSetHaptics.rep();
        }
    }

    // Rows are stacked upward from the bezel-fitted footer so the count can
    // take whatever height is left between the label and today's total.
    function onUpdate(dc as Dc) as Void {
        var layout = new HeroSetLayout(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(layout.centerX(), layout.bandTop(0), Graphics.FONT_SMALL, _label, Graphics.TEXT_JUSTIFY_CENTER);
        var labelBottom = layout.bandTop(0) + dc.getFontHeight(Graphics.FONT_SMALL);

        var footerY = HeroSetDraw.hint(dc, layout, layout.footerRowBottom(), labelBottom, _finishHint);
        var metricsY = footerY - dc.getFontHeight(Graphics.FONT_XTINY);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        var metrics = HeroSetDraw.firstFitting(dc, layout, metricsY, Graphics.FONT_XTINY, _metrics.candidates());
        dc.drawText(layout.centerX(), metricsY, Graphics.FONT_XTINY, metrics, Graphics.TEXT_JUSTIFY_CENTER);

        var todayY = metricsY - dc.getFontHeight(Graphics.FONT_TINY);
        var total = _storedCount + _detected;
        dc.setColor(total >= HeroSetConfig.MISSION_GOAL ? Graphics.COLOR_GREEN : Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), todayY, Graphics.FONT_TINY, Lang.format(_todayFormat, [total, HeroSetConfig.MISSION_GOAL]), Graphics.TEXT_JUSTIFY_CENTER);

        drawCount(dc, layout, labelBottom, todayY);
    }

    private function drawCount(dc as Dc, layout as HeroSetLayout, top as Lang.Number, bottom as Lang.Number) as Void {
        var text = _detected.toString();
        var fonts = [Graphics.FONT_NUMBER_THAI_HOT, Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Lang.Array<Graphics.FontDefinition>;
        var font = HeroSetDraw.largestFontInBand(dc, layout, top, bottom, text, fonts);
        var y = HeroSetDraw.centeredTop(top, bottom, dc.getFontHeight(font));
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), y, font, text, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
