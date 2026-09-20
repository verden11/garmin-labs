import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        var menu = new Rez.Menus.MainMenu();
        HeroSetMenuDelegate.prepare(menu);
        WatchUi.pushView(menu, new HeroSetMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onSelect() as Boolean {
        return onMenu();
    }

    function onNextPage() as Boolean {
        return onMenu();
    }

    function onPreviousPage() as Boolean {
        return onMenu();
    }

}
