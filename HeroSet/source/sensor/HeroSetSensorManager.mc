import Toybox.Lang;
import Toybox.Sensor;
import Toybox.System;

class HeroSetSensorManager {
    private var _enabled as Lang.Boolean = false;

    function initialize() {
    }

    function start(callback as Method(data as Sensor.SensorData) as Void, sampleRate as Lang.Number) as Lang.Boolean {
        if (_enabled || !(Sensor has :registerSensorDataListener)) {
            return _enabled;
        }
        try {
            Sensor.registerSensorDataListener(callback, {
                :period => HeroSetConfig.SENSOR_PERIOD_SECONDS,
                :accelerometer => {
                    :enabled => true,
                    :sampleRate => sampleRate
                }
            });
            _enabled = true;
        } catch (e) {
            _enabled = false;
            System.println("[HeroSet] SensorManager.start: caught " + e.getErrorMessage());
        }
        return _enabled;
    }

    function stop() as Void {
        if (_enabled && (Sensor has :unregisterSensorDataListener)) {
            Sensor.unregisterSensorDataListener();
        }
        _enabled = false;
    }
}
