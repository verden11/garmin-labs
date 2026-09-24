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
        mode = number(HeroFaceConfig.SETTING_MODE, HeroFaceConfig.MODE_AUTO);
        slots = [] as Array<Number>;
        for (var i = 0; i < HeroFaceConfig.SETTING_SLOTS.size(); i++) {
            slots.add(number(HeroFaceConfig.SETTING_SLOTS[i], HeroFaceConfig.METRIC_AUTO));
        }
        accent = HeroFacePalette.accent(number(HeroFaceConfig.SETTING_ACCENT, 0));
        seconds = flag(HeroFaceConfig.SETTING_SECONDS, false);
        weather = flag(HeroFaceConfig.SETTING_WEATHER, true);
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
