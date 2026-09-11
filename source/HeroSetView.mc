import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) as Void {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var store = getApp().getStore();
        var width = dc.getWidth();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(width / 2, 8, Graphics.FONT_SMALL, "HEROSET", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, 30, Graphics.FONT_SMALL, "DAILY MISSION", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(18, 48, Graphics.FONT_XTINY, "RANK " + store.getRank(), Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(width - 18, 48, Graphics.FONT_XTINY, "STREAK " + store.getStreak(), Graphics.TEXT_JUSTIFY_RIGHT);

        drawMission(dc, 68, "PUSH-UPS", store.getCount(:pushups), 100);
        drawMission(dc, 118, "SIT-UPS", store.getCount(:situps), 100);
        drawMission(dc, 168, "SQUATS", store.getCount(:squats), 100);
        drawRunMission(dc, 218, store.getRunDistance());

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, dc.getHeight() - 24, Graphics.FONT_XTINY, "SELECT: LOG REPS", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawMission(dc as Dc, y as Lang.Number, label as Lang.String, count as Lang.Number, goal as Lang.Number) as Void {
        var width = dc.getWidth();
        var barWidth = width - 36;
        var shownCount = count > goal ? goal : count;
        var filledWidth = (barWidth * shownCount) / goal;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(18, y, Graphics.FONT_SMALL, label, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(width - 18, y, Graphics.FONT_SMALL, count + "/" + goal, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.fillRectangle(18, y + 20, barWidth, 7);
        dc.setColor(count >= goal ? Graphics.COLOR_GREEN : Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.fillRectangle(18, y + 20, filledWidth, 7);
    }

    private function drawRunMission(dc as Dc, y as Lang.Number, distance as Lang.Float) as Void {
        var width = dc.getWidth();
        var barWidth = width - 36;
        var shownDistance = distance > 10.0 ? 10.0 : distance;
        var filledWidth = (barWidth * shownDistance / 10.0).toNumber();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(18, y, Graphics.FONT_SMALL, "PRO RUN", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(width - 18, y, Graphics.FONT_SMALL, distance + "/10.0 KM", Graphics.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.fillRectangle(18, y + 20, barWidth, 7);
        dc.setColor(distance >= 10.0 ? Graphics.COLOR_GREEN : Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.fillRectangle(18, y + 20, filledWidth, 7);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
