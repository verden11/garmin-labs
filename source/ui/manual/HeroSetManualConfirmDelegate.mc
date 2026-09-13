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
            // Pop the confirmation, then the picker below it (the
            // confirmation is only ever pushed over the picker).
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
