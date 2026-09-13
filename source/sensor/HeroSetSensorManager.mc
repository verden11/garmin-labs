import Toybox.Lang;
import Toybox.Sensor;

class HeroSetSensorManager {
    private var _enabled = false;

    function initialize() {
    }

    function start(callback as Lang.Method, sampleRate as Lang.Number) as Lang.Boolean {
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
        }
        return _enabled;
    }

    function stop() as Void {
        if (_enabled && (Sensor has :unregisterSensorDataListener)) {
            Sensor.unregisterSensorDataListener();
        }
        _enabled = false;
    }

    function isEnabled() as Lang.Boolean {
        return _enabled;
    }
}
