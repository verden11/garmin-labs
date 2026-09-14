import Toybox.Lang;
import Toybox.WatchUi;

// Response handler for the manual-entry back-confirmation ("Save +N?").
// CONFIRM: bank the delta and leave. CANCEL: return to the picker, delta
// untouched.
class HeroSetManualConfirmDelegate extends WatchUi.ConfirmationDelegate {

    private var _view;

    function initialize(view as HeroSetManualPickerView) {
        ConfirmationDelegate.initialize();
        _view = view;
    }

    function onResponse(response as WatchUi.Confirm) as Boolean {
        if (response == WatchUi.CONFIRM_YES) {
            _view.saveEntry();
            // Pop the confirmation, then the picker below it. The picker
            // always sits directly on the dashboard (its caller pops its
            // own predecessor before pushing it — see
            // HeroSetManualPickerDelegate.onSelect), so these two pops land
            // on the dashboard regardless of which screen opened the picker.
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        } else {
            // Back into the picker; the delta is untouched.
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        WatchUi.requestUpdate();
        return true;
    }
}
