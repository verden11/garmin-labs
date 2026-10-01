import Toybox.Application;
import Toybox.Lang;

// User settings from Garmin Connect, read once and on onSettingsChanged.
// Free reads Mode and Accent only; the slots stay Auto, and seconds and the
// temperature stay off (docs/decisions.md ADR-001, the Free + Pro ladder).
class HeroFaceSettings {
    var mode as Number;
    var slots as Array<Number>;
    var accent as Number;
    var seconds as Boolean;
    var weather as Boolean;

    function initialize() {
        mode = number(HeroFaceConfig.SETTING_MODE, HeroFaceConfig.MODE_AUTO);
        slots = readSlots();
        accent = HeroFacePalette.accent(number(HeroFaceConfig.SETTING_ACCENT, 0));
        seconds = readSeconds();
        weather = readWeather();
    }

    // Pro: the three "mission" lists.
    (:pro)
    private static function readSlots() as Array<Number> {
        var chosen = [] as Array<Number>;
        for (var i = 0; i < HeroFaceConfig.SETTING_SLOTS.size(); i++) {
            chosen.add(number(HeroFaceConfig.SETTING_SLOTS[i], HeroFaceConfig.METRIC_AUTO));
        }
        return chosen;
    }

    // Free: every slot is Auto, and no key is read.
    (:free)
    private static function readSlots() as Array<Number> {
        var chosen = [] as Array<Number>;
        for (var i = 0; i < HeroFaceConfig.SLOT_CHAINS.size(); i++) {
            chosen.add(HeroFaceConfig.METRIC_AUTO);
        }
        return chosen;
    }

    (:pro)
    private static function readSeconds() as Boolean {
        return flag(HeroFaceConfig.SETTING_SECONDS, false);
    }

    (:free)
    private static function readSeconds() as Boolean {
        return false;
    }

    (:pro)
    private static function readWeather() as Boolean {
        return flag(HeroFaceConfig.SETTING_WEATHER, true);
    }

    (:free)
    private static function readWeather() as Boolean {
        return false;
    }

    // A property missing after an update (or a wrong type pushed by an old
    // phone app) falls back to the default instead of crashing the face.
    private static function number(key as String, fallback as Number) as Number {
        var value = read(key);
        return value instanceof Number ? value : fallback;
    }

    (:pro)
    private static function flag(key as String, fallback as Boolean) as Boolean {
        var value = read(key);
        return value instanceof Boolean ? value : fallback;
    }

    private static function read(key as String) as Application.Properties.ValueType or Null {
        try {
            return Application.Properties.getValue(key);
        } catch (e instanceof Application.Properties.InvalidKeyException) {
            return null;
        }
    }
}
