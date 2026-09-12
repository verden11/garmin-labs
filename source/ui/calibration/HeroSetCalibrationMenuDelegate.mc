import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetCalibrationMenuDelegate extends WatchUi.MenuInputDelegate {
    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Lang.Symbol) as Void {
        var exercise = item == :calibrate_pushups ? :pushups : (item == :calibrate_situps ? :situps : :squats);
        var view = new HeroSetCalibrationView(exercise);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.pushView(view, new HeroSetCalibrationDelegate(view), WatchUi.SLIDE_UP);
    }
}
