import Toybox.Lang;
import Toybox.WatchUi;

// Back-menu for the delta picker with a pending correction: Save / Discard /
// Keep Editing. Navigation lives in HeroSetExitMenuDelegate.
class HeroSetManualExitMenuDelegate extends HeroSetExitMenuDelegate {

    private var _view as HeroSetManualPickerView;

    function initialize(view as HeroSetManualPickerView) {
        HeroSetExitMenuDelegate.initialize();
        _view = view;
    }

    function save() as Void {
        _view.saveEntry();
    }
}
