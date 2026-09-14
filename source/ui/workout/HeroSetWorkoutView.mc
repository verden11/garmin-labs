import Toybox.ActivityMonitor;
import Toybox.Attention;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Sensor;
import Toybox.System;
import Toybox.WatchUi;

// No FIT activity is created here (ADR-016 superseded — see ADR-021): one
// Garmin Connect activity per set cluttered the timeline/Strava feed. Instead
// this reads two things Garmin already computes with no recording session
// and no permission beyond Sensor: on-demand heart rate
// (Sensor.getInfo().heartRate) and the day's cumulative calories
// (ActivityMonitor.getInfo().calories) — the delta from workout-start is this
// set's attributable estimate. No Training Effect/Status without a saved
// activity; that trade is accepted.
class HeroSetWorkoutView extends WatchUi.View {

    private var _exercise;
    private var _detected = 0;
    private var _sensorManager;
    private var _saved = false;
    private var _sampleRate;
    private var _counter;
    private var _startCalories;

    function initialize(exercise as Lang.Symbol) {
        View.initialize();
        _exercise = exercise;
        var store = getApp().getStore();
        _sampleRate = store.getCalibrationRate(exercise);
        _counter = new HeroSetRepCounter(store.getCalibrationArm(exercise), store.getCalibrationRelease(exercise), store.getCalibrationRate(exercise), store.getCalibrationCooldownMs(exercise));
        _sensorManager = new HeroSetSensorManager();
    }

    function onShow() as Void {
        if (_startCalories == null) {
            _startCalories = currentDailyCalories();
        }
        enableSensors();
        enableHeartRate();
    }

    function onHide() as Void {
        disableSensors();
        disableHeartRate();
    }

    // Quick-save path: Back-confirm banks the detected count as-is, no
    // adjustment step (HeroSetWorkoutDelegate.onBack). The primary Finish
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
        var completedBefore = store.isDailyMissionComplete();
        store.add(_exercise, _detected);
        HeroSetSaveFeedback.show(_detected, completedBefore, store.isDailyMissionComplete());
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

    // Tactile confirmation per rep — the wrist is moving through the
    // exercise, so a glance at the screen isn't reliable mid-set.
    private function vibrateForRep() as Void {
        if (Attention has :vibrate) {
            Attention.vibrate([new Attention.VibeProfile(HeroSetConfig.REP_VIBE_DUTY_CYCLE, HeroSetConfig.REP_VIBE_DURATION_MS)]);
        }
    }

    function onUpdate(dc as Dc) as Void {
        var layout = new HeroSetLayout(dc);
        var label = _exercise == :pushups ? "PUSH-UPS" : (_exercise == :situps ? "SIT-UPS" : "SQUATS");

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(layout.centerX(), layout.bandTop(0), Graphics.FONT_SMALL, label, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(1), Graphics.FONT_LARGE, _detected, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(2), Graphics.FONT_SMALL, "COUNTING", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(3), Graphics.FONT_XTINY, liveMetricsText(), Graphics.TEXT_JUSTIFY_CENTER);
        drawFooterLine(dc, layout, layout.footerRowBottom(), "SELECT: FINISH");
    }

    // Centered footer text, shifted up off the bezel if it wouldn't
    // otherwise fit the round chord at its natural row (measured against the
    // real rendered width, not a guessed character budget).
    private function drawFooterLine(dc as Dc, layout as HeroSetLayout, maxY as Lang.Number, text as Lang.String) as Void {
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        var textWidth = dc.getTextWidthInPixels(text, Graphics.FONT_XTINY);
        var textHeight = dc.getFontHeight(Graphics.FONT_XTINY);
        var y = layout.fitCenteredY(maxY, layout.bandTop(3), textWidth, textHeight);
        dc.drawText(layout.centerX(), y, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // No FIT session backs these — HR is a live on-demand read, calories is
    // the delta of Garmin's own whole-day cumulative total since this set
    // started (see class comment). Both are real Garmin-computed numbers.
    private function liveMetricsText() as Lang.String {
        var hrInfo = Sensor.getInfo();
        var hr = hrInfo == null ? null : hrInfo.heartRate;
        var calories = sessionCalories();
        var parts = "CAL " + (calories == null ? "--" : calories.toString());
        parts += "  HR " + (hr == null ? "--" : hr.toString());
        return parts;
    }

    private function sessionCalories() as Lang.Number? {
        if (_startCalories == null) {
            return null;
        }
        var current = currentDailyCalories();
        if (current == null) {
            return null;
        }
        var delta = current - _startCalories;
        return delta < 0 ? 0 : delta;
    }

    private function currentDailyCalories() as Lang.Number? {
        var info = ActivityMonitor.getInfo();
        return info == null ? null : info.calories;
    }
}
