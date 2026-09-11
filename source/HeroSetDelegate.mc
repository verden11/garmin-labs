import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new HeroSetMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onSelect() as Boolean {
        return onMenu();
    }

}
