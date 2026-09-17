import Toybox.Lang;
import Toybox.WatchUi;

// Menu2 never pops itself on select or Back, so both are explicit. The
// exercise menu is popped before the calibration view is pushed, leaving the
// view directly above the main menu — Back from calibration returns there.
class HeroSetCalibrationMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        var exercise = id == :calibrate_pushups ? :pushups : (id == :calibrate_situps ? :situps : :squats);
        var view = new HeroSetCalibrationView(exercise);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.pushView(view, new HeroSetCalibrationDelegate(view), WatchUi.SLIDE_UP);
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
