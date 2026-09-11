import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Sensor;
import Toybox.WatchUi;

class HeroSetWorkoutView extends WatchUi.View {

    private var _exercise;
    private var _detected = 0;
    private var _running = true;
    private var _sensorEnabled = false;
    private var _previousSignal;
    private var _armed = false;
    private var _cooldown = 0;

    function initialize(exercise as Lang.Symbol) {
        View.initialize();
        _exercise = exercise;
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
        if (!_running || _sensorEnabled || !(Sensor has :registerSensorDataListener)) {
            return;
        }

        try {
            Sensor.registerSensorDataListener(method(:onSensorData), {
                :period => 1,
                :accelerometer => {
                    :enabled => true,
                    :sampleRate => 25
                }
            });
            _sensorEnabled = true;
        } catch (e) {
            _sensorEnabled = false;
        }
    }

    private function disableSensors() as Void {
        if (_sensorEnabled && (Sensor has :unregisterSensorDataListener)) {
            Sensor.unregisterSensorDataListener();
        }
        _sensorEnabled = false;
    }

    private function onSensorData(data as Sensor.SensorData) as Void {
        if (!_running || data == null || data.accelerometerData == null) {
            return;
        }

        var x = data.accelerometerData.x;
        var y = data.accelerometerData.y;
        var z = data.accelerometerData.z;
        if (x == null || y == null || z == null) {
            return;
        }

        for (var i = 0; i < x.size(); i++) {
            var signal = absolute(x[i]) + absolute(y[i]) + absolute(z[i]);
            if (_previousSignal != null) {
                var delta = signal - _previousSignal;
                if (_cooldown > 0) {
                    _cooldown -= 1;
                }
                if (!_armed && delta > 250) {
                    _armed = true;
                } else if (_armed && delta < -180 && _cooldown == 0) {
                    _detected += 1;
                    _cooldown = 12;
                    _armed = false;
                    WatchUi.requestUpdate();
                }
            }
            _previousSignal = signal;
        }
    }

    private function absolute(value as Lang.Number) as Lang.Number {
        return value < 0 ? -value : value;
    }

    function onUpdate(dc as Dc) as Void {
        var width = dc.getWidth();
        var label = _exercise == :pushups ? "PUSH-UPS" : (_exercise == :situps ? "SIT-UPS" : "SQUATS");
        var state = _running ? "COUNTING" : "PAUSED";

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(width / 2, 16, Graphics.FONT_SMALL, label, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, 50, Graphics.FONT_LARGE, _detected, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, 108, Graphics.FONT_SMALL, state, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, dc.getHeight() - 34, Graphics.FONT_XTINY, "MENU: ADJUST / FINISH", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, dc.getHeight() - 18, Graphics.FONT_XTINY, "SELECT: PAUSE", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
