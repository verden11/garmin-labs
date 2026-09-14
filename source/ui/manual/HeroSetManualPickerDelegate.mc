import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

// A single Up/Down press steps the delta by 1. Holding the key auto-repeats
// via a fixed-interval timer and accelerates the step size the longer it's
// held, so a large correction doesn't need dozens of individual presses.
class HeroSetManualPickerDelegate extends WatchUi.BehaviorDelegate {

    private const HOLD_INTERVAL_MS = 150;

    private var _view;
    private var _holdTimer;
    private var _holdDirection = 0;
    private var _holdTicks = 0;

    function initialize(view as HeroSetManualPickerView) {
        BehaviorDelegate.initialize();
        _view = view;
        _holdTimer = new Timer.Timer();
    }

    function onKeyPressed(keyEvent as WatchUi.KeyEvent) as Lang.Boolean {
        var key = keyEvent.getKey();
        if (key != WatchUi.KEY_UP && key != WatchUi.KEY_DOWN) {
            return false;
        }
        _holdDirection = key == WatchUi.KEY_UP ? 1 : -1;
        _holdTicks = 0;
        _view.adjust(_holdDirection);
        _holdTimer.start(method(:onHoldTick), HOLD_INTERVAL_MS, true);
        return true;
    }

    function onKeyReleased(keyEvent as WatchUi.KeyEvent) as Lang.Boolean {
        var key = keyEvent.getKey();
        if (key != WatchUi.KEY_UP && key != WatchUi.KEY_DOWN) {
            return false;
        }
        _holdTimer.stop();
        _holdDirection = 0;
        return true;
    }

    function onHoldTick() as Void {
        _holdTicks += 1;
        _view.adjust(stepFor(_holdTicks) * _holdDirection);
    }

    // 1 for the first ~0.6s held, then 2, then 5 — accelerating rate, not a
    // fixed jump, so short taps still move by exactly 1.
    private function stepFor(ticks as Lang.Number) as Lang.Number {
        if (ticks < 4) {
            return 1;
        }
        if (ticks < 12) {
            return 2;
        }
        return 5;
    }

    function onSelect() as Lang.Boolean {
        _holdTimer.stop();
        _view.saveEntry();
        // Every caller pops its own predecessor view before pushing the
        // picker (HeroSetMenuDelegate, HeroSetWorkoutDelegate), so the
        // picker always sits directly on the dashboard — one pop is
        // deterministic regardless of which screen opened it.
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
        return true;
    }

    // Back never silently drops a pending correction: with a non-zero delta,
    // pop a "Save +N?" confirmation instead of leaving.
    function onBack() as Lang.Boolean {
        if (_view.getDelta() != 0) {
            _holdTimer.stop();
            WatchUi.pushView(
                new WatchUi.Confirmation("Save " + deltaLabel() + "?"),
                new HeroSetManualConfirmDelegate(_view),
                WatchUi.SLIDE_UP
            );
            return true;
        }
        return false;
    }

    private function deltaLabel() as Lang.String {
        var delta = _view.getDelta();
        return delta > 0 ? ("+" + delta) : delta.toString();
    }
}
