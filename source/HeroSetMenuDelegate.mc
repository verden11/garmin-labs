import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        var store = getApp().getStore();

        if (item == :start_pushups) {
            var pushupsView = new HeroSetWorkoutView(:pushups);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.pushView(pushupsView, new HeroSetWorkoutDelegate(pushupsView), WatchUi.SLIDE_UP);
        } else if (item == :start_situps) {
            var situpsView = new HeroSetWorkoutView(:situps);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.pushView(situpsView, new HeroSetWorkoutDelegate(situpsView), WatchUi.SLIDE_UP);
        } else if (item == :start_squats) {
            var squatsView = new HeroSetWorkoutView(:squats);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.pushView(squatsView, new HeroSetWorkoutDelegate(squatsView), WatchUi.SLIDE_UP);
        } else if (item == :manual_pushups) {
            store.add(:pushups, 10);
        } else if (item == :manual_situps) {
            store.add(:situps, 10);
        } else if (item == :manual_squats) {
            store.add(:squats, 10);
        } else if (item == :pro_run) {
            var runView = new HeroSetRunView();
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.pushView(runView, new HeroSetRunDelegate(runView), WatchUi.SLIDE_UP);
        }

        if (item != :start_pushups && item != :start_situps && item != :start_squats && item != :pro_run) {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        WatchUi.requestUpdate();
    }

}
