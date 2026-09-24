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

    // Some products map START to no behavior (d2airx10's simulator
    // definition), so the select behavior never fires and START would do
    // nothing despite the `START: MENU` hint. Where START is select,
    // onSelect already returned true and this never runs.
    function onKey(keyEvent as WatchUi.KeyEvent) as Boolean {
        return HeroSetInput.isStart(keyEvent) ? onMenu() : false;
    }

}
