import Toybox.Lang;
import Toybox.WatchUi;

// Input contract shared by the delta and goal pickers. Each Up/Down press
// (or swipe on a touch-first watch, ADR-048) is exactly one step: no
// hold-to-accelerate, because on the FR965 long-pressing Up/Down opens
// watch-level shortcuts (ADR-029). Page behaviors rather than raw key
// events, so a press is one step and nothing else.
//
// Save is the START key only: a tap is also the select behavior, and a
// stray tap must never save (ADR-048). Every caller pops its own
// predecessor before pushing a picker, so a picker sits directly on the
// dashboard and one pop is always right (ADR-024).
//
// Subclasses override `adjust` and `commit` — public override dispatch, the
// pattern HeroSetExitMenuDelegate uses for the same reason (ADR-023/036).
class HeroSetPickerDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function adjust(steps as Lang.Number) as Void {
    }

    function commit() as Void {
    }

    function onPreviousPage() as Lang.Boolean {
        adjust(HeroSetInput.previousPageStep());
        return true;
    }

    function onNextPage() as Lang.Boolean {
        adjust(-HeroSetInput.previousPageStep());
        return true;
    }

    function onSelect() as Lang.Boolean {
        return false;
    }

    function onKey(keyEvent as WatchUi.KeyEvent) as Lang.Boolean {
        if (!HeroSetInput.isStart(keyEvent)) {
            return false;
        }
        commit();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
        return true;
    }
}
