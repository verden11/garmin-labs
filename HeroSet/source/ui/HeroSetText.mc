import Toybox.Lang;
import Toybox.WatchUi;

// One source for user-visible text: every view used to carry its own copy of
// the exercise-label ternary and "+N" formatting, which drifted apart.
class HeroSetText {

    private static const MS_PER_SECOND = 1000;
    private static const SECONDS_PER_MINUTE = 60;

    // loadResource is typed as a union of every resource kind; a String id
    // that somehow resolves to something else renders blank rather than
    // crashing mid-draw.
    static function load(id as Lang.ResourceId) as Lang.String {
        var value = WatchUi.loadResource(id);
        return value instanceof Lang.String ? value : "";
    }

    static function format(id as Lang.ResourceId, args as Lang.Array) as Lang.String {
        return Lang.format(load(id), args);
    }

    static function exerciseLabel(exercise as Lang.Symbol) as Lang.String {
        if (exercise == :pushups) {
            return load(Rez.Strings.exercise_pushups);
        }
        if (exercise == :situps) {
            return load(Rez.Strings.exercise_situps);
        }
        return load(Rez.Strings.exercise_squats);
    }

    static function signed(amount as Lang.Number) as Lang.String {
        return amount > 0 ? ("+" + amount) : amount.toString();
    }

    // Menu titles: "1 rep" / "5 reps", or "+5 reps" for a pending delta.
    static function reps(amount as Lang.Number, showSign as Lang.Boolean) as Lang.String {
        var number = showSign ? signed(amount) : amount.toString();
        var id = amount.abs() == 1 ? Rez.Strings.menu_title_rep : Rez.Strings.menu_title_reps;
        return format(id, [number]);
    }

    // "mm:ss" from milliseconds; minutes keep growing past 59 rather than
    // rolling into hours — sets and a day's recorded time stay short.
    static function duration(ms as Lang.Number) as Lang.String {
        var seconds = ms / MS_PER_SECOND;
        return (seconds / SECONDS_PER_MINUTE).format("%02d") + ":" + (seconds % SECONDS_PER_MINUTE).format("%02d");
    }

    static function todayProgress(count as Lang.Number, goal as Lang.Number) as Lang.String {
        return format(Rez.Strings.today_progress, [count, goal]);
    }
}
