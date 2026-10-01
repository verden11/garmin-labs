import Toybox.Application;
import Toybox.Lang;

// The one wearer setting (ADR-014): Accent colour. Read fresh at draw time — never cached in
// initialize — so a change from the phone, or the watch's own Customize menu (DayArcApp), applies
// on the next update without a restart. Every failure mode (missing key, wrong type from an old
// phone app, a list value nobody offers) falls back to Auto: settings that don't stick are this
// category's #1 complaint, so this must never crash or draw garbage.
class DayArcSettings {
    static const KEY_ACCENT = "Accent";

    static function accentChoice() as Number {
        var value = null;
        try {
            value = Application.Properties.getValue(KEY_ACCENT);
        } catch (e instanceof Lang.Exception) {
            value = null;
        }
        return clampAccent(value);
    }

    // Pure, so it is unit-tested without touching real Properties (which persist in the simulator).
    static function clampAccent(value as Object or Null) as Number {
        if (value instanceof Lang.Number && value >= 0 && value < DayArcConfig.ACCENT_CHOICES) {
            return value;
        }
        return DayArcConfig.ACCENT_AUTO;
    }
}
