import Toybox.Lang;
import Toybox.WatchUi;

// Delta picker input: one step is one rep (HeroSetPickerDelegate).
class HeroSetManualPickerDelegate extends HeroSetPickerDelegate {

    private var _view as HeroSetManualPickerView;

    function initialize(view as HeroSetManualPickerView) {
        HeroSetPickerDelegate.initialize();
        _view = view;
    }

    function adjust(steps as Lang.Number) as Void {
        _view.adjust(steps);
    }

    function commit() as Void {
        _view.saveEntry();
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
