import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

// Button-first and touch-first watches share one input path (ADR-048): the
// page behaviors arrive from UP/DOWN on a five-button watch and from swipes
// on a Venu or vívoactive, so only the hint text and the swipe direction
// differ. Asked at runtime rather than split per product in the jungles, so
// every product's simulator run exercises its own strings.
class HeroSetInput {

    // No UP key means the page behaviors can only come from swipes.
    static function touchFirst() as Lang.Boolean {
        return (System.getDeviceSettings().inputButtons & System.BUTTON_INPUT_UP) == 0;
    }

    // Step for the previous-page behavior. UP on the bezel raises the value;
    // a swipe down (same behavior) lowers it, because pushing the screen up
    // is what reads as "more" under a finger.
    static function previousPageStep() as Lang.Number {
        return touchFirst() ? -1 : 1;
    }

    static function adjustHint() as Lang.String {
        return HeroSetText.load(touchFirst() ? Rez.Strings.picker_hint_adjust_touch : Rez.Strings.picker_hint_adjust);
    }

    // A tap on a touchscreen also arrives as the select behavior. Commit
    // actions (Finish, Save) listen for the START key instead, so a palm or
    // a sweaty wrist brushing the screen can't end a set or teach the
    // detector an unchecked count (ADR-040).
    static function isStart(keyEvent as WatchUi.KeyEvent) as Lang.Boolean {
        return keyEvent.getKey() == WatchUi.KEY_ENTER;
    }
}
