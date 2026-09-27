import Toybox.Application;
import Toybox.Lang;

// What the wearer chose, validated. Every value is clamped to something the face can draw, so a
// missing key, a wrong type from an old phone app or a list value nobody offers still gives a
// correct face (never a crash). Defaults: sky, noon at the top, golden hour off, curve on, date on.
class TwoSunsSettings {
    var accent as Number;
    var orientation as Number;
    var golden as Boolean;
    var curve as Boolean;
    var date as Boolean;

    function initialize(values as Dictionary) {
        accent = within(values, TwoSunsConfig.KEY_ACCENT, TwoSunsConfig.ACCENT_COUNT - 1, 0);
        orientation = within(values, TwoSunsConfig.KEY_ORIENTATION, TwoSunsConfig.ORIENTATION_MIDNIGHT_TOP, TwoSunsConfig.ORIENTATION_NOON_TOP);
        golden = within(values, TwoSunsConfig.KEY_GOLDEN, TwoSunsConfig.ON, TwoSunsConfig.OFF) == TwoSunsConfig.ON;
        curve = within(values, TwoSunsConfig.KEY_CURVE, TwoSunsConfig.ON, TwoSunsConfig.ON) == TwoSunsConfig.ON;
        date = within(values, TwoSunsConfig.KEY_DATE, TwoSunsConfig.ON, TwoSunsConfig.ON) == TwoSunsConfig.ON;
    }

    // Read fresh on every update: a handful of lookups, and no cache to go stale.
    static function load() as TwoSunsSettings {
        var keys = [TwoSunsConfig.KEY_ACCENT, TwoSunsConfig.KEY_ORIENTATION, TwoSunsConfig.KEY_GOLDEN,
                    TwoSunsConfig.KEY_CURVE, TwoSunsConfig.KEY_DATE];
        var values = {} as Dictionary;
        for (var i = 0; i < keys.size(); i++) {
            values[keys[i]] = read(keys[i]);
        }
        return new TwoSunsSettings(values);
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
