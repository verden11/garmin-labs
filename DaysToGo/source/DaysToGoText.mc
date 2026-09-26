import Toybox.Lang;
import Toybox.WatchUi;

// All words on the face come from strings.xml, so a translation is a new
// resources-<lang>/ folder and no code change.
class DaysToGoText {
    static function get(id as ResourceId) as String {
        return WatchUi.loadResource(id) as String;
    }

    static function format(id as ResourceId, args as Array) as String {
        return Lang.format(get(id), args);
    }
}
