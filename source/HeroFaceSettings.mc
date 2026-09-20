import Toybox.Application;
import Toybox.Lang;

// User settings from Garmin Connect, read once and on onSettingsChanged.
class HeroFaceSettings {
    var mode as Number;
    var slots as Array<Number>;
    var accent as Number;
    var seconds as Boolean;
    var weather as Boolean;

    function initialize() {
        mode = number("Mode", HeroFaceConfig.MODE_AUTO);
        slots = [
            number("Slot1", HeroFaceConfig.METRIC_AUTO),
            number("Slot2", HeroFaceConfig.METRIC_AUTO),
            number("Slot3", HeroFaceConfig.METRIC_AUTO)
        ] as Array<Number>;
        accent = HeroFacePalette.accent(number("Accent", 0));
        seconds = flag("Seconds", false);
        weather = flag("Weather", true);
    }

    // A property missing after an update (or a wrong type pushed by an old
    // phone app) falls back to the default instead of crashing the face.
    private static function number(key as String, fallback as Number) as Number {
        var value = read(key);
        return value instanceof Number ? value : fallback;
    }

    private static function flag(key as String, fallback as Boolean) as Boolean {
        var value = read(key);
        return value instanceof Boolean ? value : fallback;
    }

    private static function read(key as String) as Application.PropertyValueType or Null {
        try {
            return Application.Properties.getValue(key);
        } catch (e instanceof Application.Properties.InvalidKeyException) {
            return null;
        }
    }
}
