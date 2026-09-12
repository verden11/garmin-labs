import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetRunDelegate extends WatchUi.BehaviorDelegate {

    private var _view;

    function initialize(view as HeroSetRunView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    // Select and Menu are the advertised "save" affordance: stop, save the
    // FIT activity, bank the distance, and leave.
    function onSelect() as Lang.Boolean {
        _view.finishRun();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
        return true;
    }

    function onMenu() as Lang.Boolean {
        return onSelect();
    }

    // Back no longer commits silently: ask save-or-discard before leaving a
    // live recording.
    function onBack() as Lang.Boolean {
        if (_view.isRecording()) {
            _view.askSaveOrDiscard();
            return true;
        }
        return false;
    }
}
