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
    private var _dropsLastRep;
    private var _counter;
    private var _metrics;
    private var _refreshTimer;
    private var _setBegun = false;

    function initialize(exercise as Lang.Symbol) {
        View.initialize();
        _exercise = exercise;
        _label = HeroSetText.exerciseLabel(exercise);
        _todayFormat = HeroSetText.load(Rez.Strings.today_progress);
        _finishHint = HeroSetText.load(Rez.Strings.workout_hint_finish);
        var learned = getApp().getStore().getLearningState(exercise);
        var threshold = HeroSetThresholdLearner.threshold(learned);
        _dropsLastRep = HeroSetThresholdLearner.dropsLastRep(learned);
        _counter = new HeroSetRepCounter(threshold, HeroSetConfig.SENSOR_SAMPLE_RATE, HeroSetConfig.SENSOR_COOLDOWN_MS, HeroSetRepCounter.integratesMotion(exercise));
        _sensorManager = new HeroSetSensorManager();
        _metrics = new HeroSetWorkoutMetrics();
    }

    function onShow() as Void {
        _storedCount = getApp().getStore().getCount(_exercise);
        _metrics.begin();
        _sensorManager.start(method(:onSensorData), HeroSetConfig.SENSOR_SAMPLE_RATE);
        enableHeartRate();
        startRefresh();
        // Opt-in Connect sync (ADR-043): this view's first show starts the
        // set's lap; later shows (Resume, notification dismissed) only
        // restart the timer onHide paused.
        var sync = getApp().getSync();
        if (_setBegun) {
            sync.resumeSet();
        } else {
            _setBegun = true;
            sync.beginSet(_exercise);
        }
    }

    function onHide() as Void {
        stopRefresh();
        _sensorManager.stop();
        disableHeartRate();
        getApp().getSync().pauseSet();
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
        var count = getCount();
        if (count <= 0) {
            return;
        }
        HeroSetSaveFeedback.save(getApp().getStore(), _exercise, count);
        getApp().getSync().setSaved(count);
    }

    // Screen-fit tests need the widest counts without running sensors.
    // (:debug) for the same reason as HeroSetApp.swapStoreForTest.
    (:debug)
    function setCountsForTest(detected as Lang.Number, stored as Lang.Number) as Void {
        _detected = detected;
        _storedCount = stored;
        _metrics.begin();
    }

    function getExercise() as Lang.Symbol {
        return _exercise;
    }

    // What the set is worth once it ends: when this user's last counted rep
    // has been learned to be getting up (ADR-040), it doesn't count. The live
    // screen still shows every detected rep.
    function getCount() as Lang.Number {
        return _dropsLastRep && _detected > 0 ? _detected - 1 : _detected;
    }

    function getDetectedCount() as Lang.Number {
        return _detected;
    }

    function getTrace() as HeroSetSwingTrace {
        return _counter.getTrace();
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
        dc.setColor(HeroSetPalette.TEXT, HeroSetPalette.BACKGROUND);
        dc.clear();
        var labelBottom = HeroSetDraw.title(dc, layout, _label);

        var footerY = HeroSetDraw.hint(dc, layout, layout.footerRowBottom(), labelBottom, _finishHint);
        var metricsY = footerY - dc.getFontHeight(Graphics.FONT_XTINY);
        dc.setColor(HeroSetPalette.MUTED, HeroSetPalette.BACKGROUND);
        var metrics = HeroSetDraw.firstFitting(dc, layout, layout.displayRadius(), layout.textMargin(), metricsY, Graphics.FONT_XTINY, _metrics.candidates());
        HeroSetDraw.text(dc, layout, layout.centerX(), metricsY, Graphics.FONT_XTINY, metrics, Graphics.TEXT_JUSTIFY_CENTER);

        var todayY = metricsY - dc.getFontHeight(Graphics.FONT_TINY);
        var total = _storedCount + _detected;
        dc.setColor(total >= HeroSetConfig.MISSION_GOAL ? HeroSetPalette.DONE : HeroSetPalette.TEXT, HeroSetPalette.BACKGROUND);
        HeroSetDraw.text(dc, layout, layout.centerX(), todayY, Graphics.FONT_TINY, Lang.format(_todayFormat, [total, HeroSetConfig.MISSION_GOAL]), Graphics.TEXT_JUSTIFY_CENTER);

        drawCount(dc, layout, labelBottom, todayY);
    }

    private function drawCount(dc as Dc, layout as HeroSetLayout, top as Lang.Number, bottom as Lang.Number) as Void {
        var text = _detected.toString();
        var fonts = [Graphics.FONT_NUMBER_THAI_HOT, Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Lang.Array<Graphics.FontDefinition>;
        var font = HeroSetDraw.largestFontInBand(dc, layout, top, bottom, text, fonts);
        var y = HeroSetDraw.centeredTop(top, bottom, dc.getFontHeight(font));
        // Effort, not gold: the reps only become something the user keeps
        // once the set is saved.
        dc.setColor(HeroSetPalette.EFFORT, HeroSetPalette.BACKGROUND);
        HeroSetDraw.text(dc, layout, layout.centerX(), y, font, text, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
