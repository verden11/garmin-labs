import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Sensor;
import Toybox.WatchUi;

// Every counted set is a real ActivityRecording session (SPORT_TRAINING /
// SUB_SPORT_STRENGTH_TRAINING) so Garmin's own engine computes calories, HR,
// and training effect from live sensor data and folds the result into
// Garmin Connect / Training Status the same as any native activity (ADR-016).
// Manual entry stays local-only: there is no real elapsed-time/HR signal to
// record, so no session is created for it.
class HeroSetWorkoutView extends WatchUi.View {

    private var _exercise;
    private var _detected = 0;
    private var _running = true;
    private var _sensorManager;
    private var _saved = false;
    private var _sampleRate;
    private var _counter;
    private var _session;
    private var _coveredByChild = false;

    function initialize(exercise as Lang.Symbol) {
        View.initialize();
        _exercise = exercise;
        var store = getApp().getStore();
        _sampleRate = store.getCalibrationRate(exercise);
        _counter = new HeroSetRepCounter(store.getCalibrationArm(exercise), store.getCalibrationRelease(exercise), store.getCalibrationRate(exercise), store.getCalibrationCooldownMs(exercise));
        _sensorManager = new HeroSetSensorManager();
    }

    function onShow() as Void {
        _coveredByChild = false;
        if (_session == null && !_saved) {
            _session = createSession(_exercise);
            if (_session != null) {
                try { _session.start(); } catch (e) {}
            }
        }
        enableSensors();
    }

    // Fires both for a temporary child overlay (menu/confirm) and for a real
    // exit. `_coveredByChild` (set by the delegates right before they push
    // one of those overlays) is the only way to tell them apart.
    function onHide() as Void {
        disableSensors();
        if (!_coveredByChild && !_saved) {
            discardSession();
        }
    }

    // Called by the delegates right before pushing the workout menu or the
    // save confirmation, so onHide knows this is a temporary cover, not a
    // real exit.
    function beginChildOverlay() as Void {
        _coveredByChild = true;
    }

    function toggleRunning() as Void {
        _running = !_running;
        if (_running) {
            _counter.reset();
            _saved = false;
            enableSensors();
            if (_session != null) {
                try { _session.start(); } catch (e) {}
            }
        } else {
            disableSensors();
            if (_session != null) {
                try { _session.stop(); } catch (e) {}
            }
        }
        WatchUi.requestUpdate();
    }

    function adjust(amount as Lang.Number) as Void {
        _detected = _detected + amount;
        if (_detected < 0) {
            _detected = 0;
        }
        WatchUi.requestUpdate();
    }

    function saveSet() as Void {
        if (_saved) {
            return;
        }
        _saved = true;
        if (_detected > 0) {
            getApp().getStore().add(_exercise, _detected);
            saveSession();
        } else {
            discardSession();
        }
    }

    function getExercise() as Lang.Symbol {
        return _exercise;
    }

    function getCount() as Lang.Number {
        return _detected;
    }

    private function enableSensors() as Void {
        if (!_running) {
            return;
        }
        _sensorManager.start(self.onSensorData, _sampleRate);
    }

    private function disableSensors() as Void {
        _sensorManager.stop();
    }

    private function createSession(exercise as Lang.Symbol) as ActivityRecording.Session? {
        if (!(Toybox has :ActivityRecording)) {
            return null;
        }
        var name = exercise == :pushups ? "Push-ups" : (exercise == :situps ? "Sit-ups" : "Squats");
        try {
            // SUB_SPORT_STRENGTH_TRAINING triggers the watch's own native
            // strength-training UI (auto set/rest detection, vibrate/beep at
            // set boundaries) on top of this view — confirmed stuck on a
            // native "Set 1" screen on a physical FR965. SPORT_GENERIC/
            // SUB_SPORT_GENERIC is the documented neutral default: no
            // device-side auto-tracking behavior attached.
            return ActivityRecording.createSession({
                :name => name,
                :sport => Activity.SPORT_GENERIC,
                :subSport => Activity.SUB_SPORT_GENERIC
            });
        } catch (e) {
            return null;
        }
    }

    private function saveSession() as Void {
        if (_session == null) {
            return;
        }
        try {
            _session.stop();
            _session.save();
        } catch (e) {}
        _session = null;
    }

    private function discardSession() as Void {
        if (_session == null) {
            return;
        }
        try {
            _session.stop();
            if (_session has :discard) {
                _session.discard();
            }
        } catch (e) {}
        _session = null;
    }

    private function onSensorData(data as Sensor.SensorData) as Void {
        if (!_running || data == null || data.accelerometerData == null) {
            return;
        }

        var x = data.accelerometerData.x as Lang.Array;
        var y = data.accelerometerData.y as Lang.Array;
        var z = data.accelerometerData.z as Lang.Array;
        if (x == null || y == null || z == null) {
            return;
        }

        for (var i = 0; i < x.size(); i++) {
            if (_counter.feedSample(x[i], y[i], z[i])) {
                _detected += 1;
                WatchUi.requestUpdate();
            }
        }
    }

    function onUpdate(dc as Dc) as Void {
        var layout = new HeroSetLayout(dc);
        var label = _exercise == :pushups ? "PUSH-UPS" : (_exercise == :situps ? "SIT-UPS" : "SQUATS");
        var state = _running ? "COUNTING" : "PAUSED";

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(layout.centerX(), layout.bandTop(0), Graphics.FONT_SMALL, label, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(1), Graphics.FONT_LARGE, _detected, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(2), Graphics.FONT_SMALL, state, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(3), Graphics.FONT_XTINY, liveMetricsText(), Graphics.TEXT_JUSTIFY_CENTER);
        drawFooterLine(dc, layout, layout.footerRowTop(), "MENU: ADJUST");
        drawFooterLine(dc, layout, layout.footerRowBottom(), "SELECT: PAUSE");
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

    // Live read-only view of what Garmin's own engine is computing for this
    // session right now (same fields any native activity exposes).
    private function liveMetricsText() as Lang.String {
        var info = Activity.getActivityInfo();
        var calories = info.calories;
        var hr = info.currentHeartRate;
        var parts = "CAL " + (calories == null ? "--" : calories.toString());
        parts += "  HR " + (hr == null ? "--" : hr.toString());
        return parts;
    }
}
