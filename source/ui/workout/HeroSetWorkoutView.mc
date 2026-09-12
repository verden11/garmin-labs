import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetWorkoutView extends WatchUi.View {

    private var _exercise;
    private var _detected = 0;
    private var _running = true;
    private var _sensorManager;
    private var _saved = false;
    private var _sampleRate;
    private var _counter;

    function initialize(exercise as Lang.Symbol) {
        View.initialize();
        _exercise = exercise;
        var store = getApp().getStore();
        _sampleRate = store.getCalibrationRate(exercise);
        _counter = new HeroSetRepCounter(store.getCalibrationArm(exercise), store.getCalibrationRelease(exercise), store.getCalibrationRate(exercise), store.getCalibrationCooldownMs(exercise));
        _sensorManager = new HeroSetSensorManager();
    }

    function onShow() as Void {
        enableSensors();
    }

    function onHide() as Void {
        disableSensors();
    }

    function toggleRunning() as Void {
        _running = !_running;
        if (_running) {
            _counter.reset();
            _saved = false;
            enableSensors();
        } else {
            disableSensors();
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

    private function onSensorData(data) as Void {
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
        dc.drawText(layout.centerX(), layout.footerRowTop(), Graphics.FONT_XTINY, "MENU: ADJUST / FINISH", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(layout.centerX(), layout.footerRowBottom(), Graphics.FONT_XTINY, "SELECT: PAUSE", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
