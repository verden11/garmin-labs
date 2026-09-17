import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

// Redraws the dashboard when the local calendar day changes while it stays
// open, so counts visibly reset at midnight without a relaunch.
class HeroSetDayTracker {
    private var _timer;
    private var _dayKey;

    function initialize() {
        _dayKey = HeroSetCalendar.todayKey();
    }

    function start() as Void {
        if (_timer != null) {
            return;
        }
        _timer = new Timer.Timer();
        _timer.start(method(:onTimer), HeroSetConfig.DAY_CHECK_INTERVAL_MS, true);
    }

    function stop() as Void {
        if (_timer != null) {
            _timer.stop();
            _timer = null;
        }
    }

    function onTimer() as Void {
        var today = HeroSetCalendar.todayKey();
        if (today != _dayKey) {
            _dayKey = today;
            WatchUi.requestUpdate();
        }
    }
}
