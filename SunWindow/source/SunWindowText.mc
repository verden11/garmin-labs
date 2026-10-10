import Toybox.Lang;
import Toybox.WatchUi;

// The words the glance draws. Strings it uses are `scope="glance"` in strings.xml. The foreground-only words
// (reason lines, empty states) live in SunWindowReasons so this class stays glance-clean.
(:glance)
class SunWindowText {

    // The state word, or "" for a state with none.
    static function word(kind as Number) as String {
        if (kind == SunWindowConfig.STATE_OPEN) {
            return load(Rez.Strings.state_open);
        }
        if (kind == SunWindowConfig.STATE_NONE_TODAY) {
            return load(Rez.Strings.state_none);
        }
        if (kind == SunWindowConfig.STATE_CLOSED_BEFORE || kind == SunWindowConfig.STATE_CLOSED_AFTER || kind == SunWindowConfig.STATE_CLOSED_SKY) {
            return load(Rez.Strings.state_closed);
        }
        return "";
    }

    // The glance's line for a state with no word: only "open the app once" can happen there (the glance never asks for a place).
    static function once() as String {
        return load(Rez.Strings.glance_once);
    }

    // loadResource is typed as a union of every resource kind; anything but a String renders blank rather than crashing mid-draw.
    static function load(id as Lang.ResourceId) as String {
        var value = WatchUi.loadResource(id);
        return value instanceof Lang.String ? value : "";
    }
}
