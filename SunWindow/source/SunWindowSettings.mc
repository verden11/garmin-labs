import Toybox.Application;
import Toybox.Lang;

// What the wearer chose, validated: a missing key, a wrong type from an old phone app or a value nobody offers still
// gives a correct screen, never a crash. One setting only (ADR-009): the accent colour id.
class SunWindowSettings {

    static function accent() as Number {
        try {
            return clamp(Application.Properties.getValue(SunWindowConfig.KEY_ACCENT));
        } catch (e instanceof Lang.Exception) {
            return SunWindowConfig.ACCENT_DEFAULT;
        }
    }

    // A whole number from 0 to the last id, else the default.
    static function clamp(value as Object or Null) as Number {
        return value instanceof Lang.Number && value >= 0 && value < SunWindowConfig.ACCENT_COUNT ? value : SunWindowConfig.ACCENT_DEFAULT;
    }

    static function save(id as Number) as Void {
        try {
            Application.Properties.setValue(SunWindowConfig.KEY_ACCENT, clamp(id));
        } catch (e instanceof Lang.Exception) {
            // A store that refuses the write must not take the menu down with it.
        }
    }
}
