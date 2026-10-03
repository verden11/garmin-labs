import Toybox.Application;
import Toybox.Lang;

// What the wearer chose, validated. Every value is clamped to something the face can draw, so a
// missing key, a wrong type from an old phone app or a list value nobody offers still gives a
// correct face (never a crash). Pro defaults: sky, noon at the top, golden hour off, curve on, date on, weather on, watch battery on.
//
// Free build (docs/decisions.md ADR-020, Free + Pro ladder): only Accent is a setting. The other four fields keep the
// values they are declared with, which are exactly what Free draws (noon at the top, no golden arc, no curve, no date
// row), whatever a caller passes in; Free never asks the system for the four Pro keys.
class TwoSunsSettings {
    var accent as Number;
    var orientation as Number = TwoSunsConfig.ORIENTATION_NOON_TOP;
    var golden as Boolean = false;
    var curve as Boolean = false;
    var date as Boolean = false;
    var weather as Boolean = false;
    var battery as Boolean = false;

    function initialize(values as Dictionary) {
        accent = within(values, TwoSunsConfig.KEY_ACCENT, TwoSunsConfig.ACCENT_COUNT - 1, 0);
        readPro(values);
    }

    // Pro: the six settings only Pro has.
    (:pro)
    private function readPro(values as Dictionary) as Void {
        orientation = within(values, TwoSunsConfig.KEY_ORIENTATION, TwoSunsConfig.ORIENTATION_MIDNIGHT_TOP, TwoSunsConfig.ORIENTATION_NOON_TOP);
        golden = within(values, TwoSunsConfig.KEY_GOLDEN, TwoSunsConfig.ON, TwoSunsConfig.OFF) == TwoSunsConfig.ON;
        curve = within(values, TwoSunsConfig.KEY_CURVE, TwoSunsConfig.ON, TwoSunsConfig.ON) == TwoSunsConfig.ON;
        date = within(values, TwoSunsConfig.KEY_DATE, TwoSunsConfig.ON, TwoSunsConfig.ON) == TwoSunsConfig.ON;
        weather = within(values, TwoSunsConfig.KEY_WEATHER, TwoSunsConfig.ON, TwoSunsConfig.ON) == TwoSunsConfig.ON;
        battery = within(values, TwoSunsConfig.KEY_BATTERY, TwoSunsConfig.ON, TwoSunsConfig.ON) == TwoSunsConfig.ON;
    }

    (:free)
    private function readPro(values as Dictionary) as Void {
    }

    // Read fresh on every update: a handful of lookups, and no cache to go stale.
    static function load() as TwoSunsSettings {
        var keys = [TwoSunsConfig.KEY_ACCENT] as Array<String>;
        keys.addAll(proKeys());
        var values = {} as Dictionary;
        for (var i = 0; i < keys.size(); i++) {
            values[keys[i]] = read(keys[i]);
        }
        return new TwoSunsSettings(values);
    }

    // The Pro-only keys. The Free properties file does not define them, so the Free build never asks the system for
    // them: no path in it depends on what a missing key does (SDK 9.2.0: getValue throws InvalidKeyException).
    (:pro)
    private static function proKeys() as Array<String> {
        return [TwoSunsConfig.KEY_ORIENTATION, TwoSunsConfig.KEY_GOLDEN, TwoSunsConfig.KEY_CURVE, TwoSunsConfig.KEY_DATE, TwoSunsConfig.KEY_WEATHER, TwoSunsConfig.KEY_BATTERY] as Array<String>;
    }

    (:free)
    private static function proKeys() as Array<String> {
        return [] as Array<String>;
    }

    private static function read(key as String) as Object? {
        try {
            return Application.Properties.getValue(key);
        } catch (e instanceof Application.Properties.InvalidKeyException) {
            return null;
        }
    }

    // A whole number from 0 to `last`, else the fallback.
    private static function within(values as Dictionary, key as String, last as Number, fallback as Number) as Number {
        var value = values[key] as Object?;
        return value instanceof Number && value >= 0 && value <= last ? value : fallback;
    }
}
