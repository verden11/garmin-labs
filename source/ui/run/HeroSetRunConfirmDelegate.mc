import Toybox.Lang;
import Toybox.WatchUi;

// Response handler for the run back-confirmation ("Save run?").
// CONFIRM: save the FIT activity and bank the distance. CANCEL: discard the
// activity and leave without writing anything.
class HeroSetRunConfirmDelegate extends WatchUi.ConfirmationDelegate {

    private var _view;

    function initialize(view as HeroSetRunView) {
        ConfirmationDelegate.initialize();
        _view = view;
    }

    function onResponse(response as WatchUi.Confirm) as Boolean {
        if (response == WatchUi.CONFIRM_YES) {
            _view.finishRun();
        } else {
            _view.discardRun();
        }
        // Pop the confirmation, then the run view below it (the confirmation
        // is only ever pushed over the run view).
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
        return true;
    }
}
