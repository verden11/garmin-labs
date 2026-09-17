import Toybox.Lang;
import Toybox.WatchUi;

// Each Up/Down press steps the delta by exactly 1. No hold-to-accelerate
// (ADR-029): on the FR965 long-pressing Up/Down opens watch-level shortcuts,
// so a hold can't be claimed as an in-app gesture. Page behaviors rather
// than raw key events, so a press is one step and nothing else.
class HeroSetManualPickerDelegate extends WatchUi.BehaviorDelegate {

    private var _view;

    function initialize(view as HeroSetManualPickerView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onPreviousPage() as Lang.Boolean {
        _view.adjust(1);
        return true;
    }

    function onNextPage() as Lang.Boolean {
        _view.adjust(-1);
        return true;
    }

    function onSelect() as Lang.Boolean {
        _view.saveEntry();
        // Every caller pops its own predecessor view before pushing the
        // picker (HeroSetMenuDelegate, HeroSetWorkoutDelegate), so the
        // picker always sits directly on the dashboard — one pop is
        // deterministic regardless of which screen opened it.
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
        return true;
    }

    // Back never silently drops a pending correction: with a non-zero delta,
    // offer Save/Discard/Keep Editing instead of leaving.
    function onBack() as Lang.Boolean {
        var delta = _view.getDelta();
        if (delta == 0) {
            return false;
        }
        var menu = new Rez.Menus.ManualExitMenu();
        menu.setTitle(HeroSetText.reps(delta, true));
        WatchUi.pushView(menu, new HeroSetManualExitMenuDelegate(_view), WatchUi.SLIDE_UP);
        return true;
    }
}
