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
    logger.debug("sync toggle index " + menu.findItemById(:sync_toggle) + ", validation log index " + menu.findItemById(:validation_log));
    return true;
}
