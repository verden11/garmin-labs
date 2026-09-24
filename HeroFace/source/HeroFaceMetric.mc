import Toybox.Lang;

// One mission slot's reading. goal 0 means the watch sets no goal for it, so
// it gets a value but no bar.
class HeroFaceMetric {
    var kind as Number;
    var value as Number;
    var goal as Number;

    function initialize(kind_ as Number, value_ as Number, goal_ as Number) {
        kind = kind_;
        value = value_;
        goal = goal_;
    }

    function hasBar() as Boolean {
        return goal > 0;
    }

    // Move bar is inverted: the watch reports inactivity, the bar shows
    // activity, so "full" means "moved enough" like every other bar.
    function permille() as Number {
        if (goal <= 0) {
            return 0;
        }
        var part = kind == HeroFaceConfig.MOVE ? goal - value : value;
        if (part <= 0) {
            return 0;
        }
        return part >= goal ? 1000 : part * 1000 / goal;
    }

    // Move never counts as "done": it resets every time the user sits.
    function isDone() as Boolean {
        return kind != HeroFaceConfig.MOVE && goal > 0 && value >= goal;
    }

    function isAlert() as Boolean {
        return kind == HeroFaceConfig.MOVE && value > 0;
    }
}
