import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :start_pushups) {
            pushWorkout(:pushups);
        } else if (item == :start_situps) {
            pushWorkout(:situps);
        } else if (item == :start_squats) {
            pushWorkout(:squats);
        } else if (item == :manual_pushups) {
            pushManualPicker(:pushups);
        } else if (item == :manual_situps) {
            pushManualPicker(:situps);
        } else if (item == :manual_squats) {
            pushManualPicker(:squats);
        } else if (item == :pro_run) {
            var runView = new HeroSetRunView();
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.pushView(runView, new HeroSetRunDelegate(runView), WatchUi.SLIDE_UP);
        } else if (item == :calibration) {
            WatchUi.pushView(new Rez.Menus.CalibrationMenu(), new HeroSetCalibrationMenuDelegate(), WatchUi.SLIDE_UP);
        }
        WatchUi.requestUpdate();
    }

    private function pushWorkout(exercise as Lang.Symbol) as Void {
        var workoutView = new HeroSetWorkoutView(exercise);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.pushView(workoutView, new HeroSetWorkoutDelegate(workoutView), WatchUi.SLIDE_UP);
    }

    // Manual entry opens a number picker on top of the main menu; the picker
    // applies its amount and pops both itself and the menu.
    private function pushManualPicker(exercise as Lang.Symbol) as Void {
        WatchUi.pushView(new Rez.Menus.ManualMenu(), new HeroSetManualMenuDelegate(exercise), WatchUi.SLIDE_UP);
    }
}
