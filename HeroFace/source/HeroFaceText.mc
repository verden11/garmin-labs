import Toybox.Lang;
import Toybox.WatchUi;

// All visible words come from strings.xml, so a translation is a new
// resources-<lang>/ folder and no code change. Strings are loaded once and
// cached: the face redraws every second while awake.
class HeroFaceText {

    private static var _cache as Dictionary<ResourceId, String> = {} as Dictionary<ResourceId, String>;

    static function get(id as ResourceId) as String {
        var hit = _cache[id];
        if (hit != null) {
            return hit;
        }
        var loaded = WatchUi.loadResource(id) as String;
        _cache[id] = loaded;
        return loaded;
    }

    static function format(id as ResourceId, args as Array) as String {
        return Lang.format(get(id), args);
    }

    // [long, short] label for a mission column, longest first.
    static function labels(kind as Number) as Array<String> {
        if (kind == HeroFaceConfig.STEPS) {
            return [get(Rez.Strings.label_steps), get(Rez.Strings.label_steps_short)] as Array<String>;
        } else if (kind == HeroFaceConfig.CALORIES) {
            return [get(Rez.Strings.label_calories), get(Rez.Strings.label_calories_short)] as Array<String>;
        } else if (kind == HeroFaceConfig.INTENSITY) {
            return [get(Rez.Strings.label_intensity), get(Rez.Strings.label_intensity_short)] as Array<String>;
        } else if (kind == HeroFaceConfig.DISTANCE) {
            var unit = HeroFaceMetrics.distanceDivisor() == HeroFaceConfig.CM_PER_TENTH_MILE ? get(Rez.Strings.label_miles) : get(Rez.Strings.label_km);
            return [unit] as Array<String>;
        } else if (kind == HeroFaceConfig.FLOORS) {
            return [get(Rez.Strings.label_floors), get(Rez.Strings.label_floors_short)] as Array<String>;
        } else if (kind == HeroFaceConfig.PUSHUPS) {
            return [get(Rez.Strings.label_pushups), get(Rez.Strings.label_pushups_short)] as Array<String>;
        } else if (kind == HeroFaceConfig.SITUPS) {
            return [get(Rez.Strings.label_situps), get(Rez.Strings.label_situps_short)] as Array<String>;
        } else if (kind == HeroFaceConfig.SQUATS) {
            return [get(Rez.Strings.label_squats), get(Rez.Strings.label_squats_short)] as Array<String>;
        }
        return [get(Rez.Strings.label_move)] as Array<String>;
    }

    // Value wordings, longest first: 12345 steps can shrink to 12.3K.
    static function values(metric as HeroFaceMetric) as Array<String> {
        var value = metric.value;
        if (metric.kind == HeroFaceConfig.MOVE) {
            return [value > 0 ? get(Rez.Strings.value_move_alert) : get(Rez.Strings.value_move_ok)] as Array<String>;
        }
        if (metric.kind == HeroFaceConfig.DISTANCE) {
            return [(value / 10.0).format("%.1f"), (value / 10).toString()] as Array<String>;
        }
        var full = value.toString();
        if (value < 1000) {
            return [full] as Array<String>;
        }
        var thousands = (value / 1000.0).format(value < 100000 ? "%.1f" : "%d");
        return [full, format(Rez.Strings.value_thousands, [thousands]), format(Rez.Strings.value_thousands, [value / 1000])] as Array<String>;
    }
}
