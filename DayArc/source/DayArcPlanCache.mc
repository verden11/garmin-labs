import Toybox.Graphics;
import Toybox.Lang;

// Holds the last DayArcStack plan so it is measured once, not on every update. A cached plan is
// reused only while (a) the window and the hero's optional rows are unchanged (`keyFor`) AND (b) every
// live string is still covered by what the plan was sized for (DayArcSizing.covers) — a date that
// flips null <-> present, or a sub line that turns out wider, rebuilds the plan instead of drawing a
// stale one. The draw path is also safe on a stale plan regardless (DayArcDraw null-guards every
// live string and truncates each row against its own chord).
class DayArcPlanCache {
    private static const KEY_LABEL = 10;
    private static const KEY_GAUGE = 20;
    private static const KEY_SUB = 40;
    private static const KEY_CELLS = 80;
    private static const KEY_DATE = 160;

    private var _plan as DayArcStack or Null = null;
    private var _key as Number = -1;

    // The display or its fonts changed (onLayout).
    function reset() as Void {
        _plan = null;
        _key = -1;
    }

    function get(dc as Graphics.Dc, layout as DayArcLayout, window as Number, hero as Dictionary) as DayArcStack {
        var key = keyFor(window, hero);
        var plan = _plan;
        if (plan == null || key != _key || !DayArcSizing.covers(dc, plan.strings, hero)) {
            plan = DayArcStack.plan(dc, layout, window, hero);
            _plan = plan;
            _key = key;
        }
        return plan;
    }

    // Which optional rows a hero carries.
    static function keyFor(window as Number, hero as Dictionary) as Number {
        var k = window;
        k += hero.get(:label) != null ? KEY_LABEL : 0;
        k += hero.hasKey(:gauge) && hero.get(:gauge) != null ? KEY_GAUGE : 0;
        k += hero.hasKey(:sub) && hero.get(:sub) != null ? KEY_SUB : 0;
        k += hero.hasKey(:cells) ? KEY_CELLS : 0;
        k += hero.get(:dateText) != null ? KEY_DATE : 0;
        return k;
    }
}
