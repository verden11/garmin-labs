import Toybox.Lang;
import Toybox.WatchUi;

// Hold-to-launch (CIQ 4.2+ watches that support it): opens HeroSet when the
// face is linked to it. The system only calls onPress where supported.
class HeroFaceDelegate extends WatchUi.WatchFaceDelegate {

    private var _link as HeroFaceLink;

    function initialize(link as HeroFaceLink) {
        WatchFaceDelegate.initialize();
        _link = link;
    }

    function onPress(event as WatchUi.ClickEvent) as Boolean {
        return _link.open();
    }

    // Drawing seconds went over the power budget, so the system will stop
    // calling onPartialUpdate. Turn them off rather than leave a frozen number
    // sitting beside the time.
    function onPowerBudgetExceeded(info as WatchUi.WatchFacePowerInfo) as Void {
        var view = getApp().view();
        if (view != null) {
            view.disableSeconds();
        }
    }
}
