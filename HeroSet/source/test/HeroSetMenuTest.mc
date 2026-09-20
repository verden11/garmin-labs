import Toybox.Lang;
import Toybox.Test;
import Toybox.WatchUi;

// Stamping live state onto the real main menu resource. The store build's
// menu has no sync toggle (ADR-033), and an unguarded getItem(-1) there would
// crash every main-menu open; compile the tests with store.jungle to cover it.
(:test)
function mainMenuPrepareHandlesEitherBuildsMenu(logger as Test.Logger) as Lang.Boolean {
    var menu = new Rez.Menus.MainMenu();
    HeroSetMenuDelegate.prepare(menu);
    Test.assert(menu.findItemById(:start_pushups) >= 0);
    // Both builds carry the goal item, and prepare stamps the live value.
    var goalIndex = menu.findItemById(:daily_goal);
    Test.assert(goalIndex >= 0);
    // prepare stamps the live goal, not just the static resource label.
    Test.assertEqual(menu.getItem(goalIndex).getSubLabel(), getApp().getStore().getGoal().toString());
    logger.debug("sync toggle index " + menu.findItemById(:sync_toggle) + ", validation log index " + menu.findItemById(:validation_log));
    return true;
}
