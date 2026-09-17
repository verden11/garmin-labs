import Toybox.Lang;
import Toybox.WatchUi;

// Back-menu for the picker with a pending delta. The picker always sits
// directly on the dashboard (every caller pops its own predecessor first,
// ADR-024), so leaving through this menu is exactly two pops regardless of
// which screen opened the picker; Keep Editing is one.
class HeroSetManualExitMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _view as HeroSetManualPickerView;

    function initialize(view as HeroSetManualPickerView) {
        Menu2InputDelegate.initialize();
        _view = view;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        if (id == :save) {
            _view.saveEntry();
            leavePicker();
        } else if (id == :discard) {
            // Nothing banked means nothing to validate either — saveEntry
            // is the only place a validation trial is logged (ADR-026).
            HeroSetSaveFeedback.showDiscarded();
            leavePicker();
        } else {
            keepEditing();
        }
    }

    function onBack() as Void {
        keepEditing();
    }

    private function keepEditing() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    private function leavePicker() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
    }
}
