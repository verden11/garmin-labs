import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

class HeroSetDayTracker {
    private var _timer;
    private var _dayKey;
    private var _dirty = false;

    function initialize() {
        _dayKey = HeroSetCalendar.todayKey();
    }

    function start() as Void {
        if (_timer != null) {
            return;
        }
        _timer = new Timer.Timer();
        _timer.start(method(:onTimer), 60000, true);
    }

    function stop() as Void {
        if (_timer != null) {
            _timer.stop();
            _timer = null;
        }
    }

    function consumeDirty() as Lang.Boolean {
        var dirty = _dirty;
        _dirty = false;
        return dirty;
    }

    function onTimer() as Void {
        var today = HeroSetCalendar.todayKey();
        if (today != _dayKey) {
            _dayKey = today;
            _dirty = true;
            WatchUi.requestUpdate();
        }
    }
}
