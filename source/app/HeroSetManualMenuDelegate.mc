import Toybox.Lang;
import Toybox.WatchUi;

// Number picker for manual entry. One-tap +10 on the main menu is gone;
// manual adjustments now require an explicit amount selection, which also
// means adjustments route through the same XP rules as everything else.
class HeroSetManualMenuDelegate extends WatchUi.MenuInputDelegate {

    private var _exercise;

    function initialize(exercise as Lang.Symbol) {
        MenuInputDelegate.initialize();
        _exercise = exercise;
    }

    function onMenuItem(item as Lang.Symbol) as Void {
        getApp().getStore().add(_exercise, amountFor(item));
        // Close the picker, then the main menu that hosted it: the picker is
        // only ever pushed from the main menu, so two pops are deterministic.
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
    }

    private function amountFor(item as Lang.Symbol) as Lang.Number {
        if (item == :manual_add_1) {
            return 1;
        }
        if (item == :manual_add_5) {
            return 5;
        }
        if (item == :manual_add_10) {
            return 10;
        }
        if (item == :manual_sub_1) {
            return -1;
        }
        if (item == :manual_sub_5) {
            return -5;
        }
        if (item == :manual_sub_10) {
            return -10;
        }
        return 0;
    }
}
