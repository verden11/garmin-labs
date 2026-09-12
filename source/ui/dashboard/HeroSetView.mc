import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetView extends WatchUi.View {
    private var _dayTracker;

    function initialize() {
        View.initialize();
        _dayTracker = new HeroSetDayTracker();
    }

    function onUpdate(dc as Dc) as Void {
        _dayTracker.consumeDirty();
        var state = getApp().getStore().getDashboardState();
        var layout = new HeroSetLayout(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(0), Graphics.FONT_XTINY, "HEROSET", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(1), Graphics.FONT_XTINY, "R" + state.rank + "  STREAK " + state.streak, Graphics.TEXT_JUSTIFY_CENTER);

        drawMission(dc, layout, 2, "PUSH-UPS", state.pushups);
        drawMission(dc, layout, 3, "SIT-UPS", state.situps);
        drawMission(dc, layout, 4, "SQUATS", state.squats);
        drawRunMission(dc, layout, 5, state.runKm);

        dc.setColor(state.storageWarning ? Graphics.COLOR_RED : Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.footerRowBottom(), Graphics.FONT_XTINY, state.storageWarning ? "! COULD NOT SAVE" : "UP/DN/SEL: MENU", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onShow() as Void {
        _dayTracker.start();
    }

    function onHide() as Void {
        _dayTracker.stop();
    }

    private function drawMission(dc as Dc, layout as HeroSetLayout, band as Lang.Number, label as Lang.String, count as Lang.Number) as Void {
        var y = layout.bandTop(band);
        var done = count >= HeroSetConfig.MISSION_GOAL;
        dc.setColor(done ? Graphics.COLOR_GREEN : Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.leftInset(y), y, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(layout.rightInset(y), y, Graphics.FONT_XTINY, count + "/" + HeroSetConfig.MISSION_GOAL, Graphics.TEXT_JUSTIFY_RIGHT);
        drawBar(dc, layout, y + 8, count, HeroSetConfig.MISSION_GOAL);
    }

    private function drawRunMission(dc as Dc, layout as HeroSetLayout, band as Lang.Number, distance as Lang.Float) as Void {
        var y = layout.bandTop(band);
        var done = distance >= HeroSetConfig.RUN_GOAL_KM;
        dc.setColor(done ? Graphics.COLOR_GREEN : Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.leftInset(y), y, Graphics.FONT_XTINY, "PRO RUN", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(layout.rightInset(y), y, Graphics.FONT_XTINY, formatDistance(distance) + "/10 KM", Graphics.TEXT_JUSTIFY_RIGHT);
        drawBar(dc, layout, y + 8, distance, HeroSetConfig.RUN_GOAL_KM);
    }

    // Thin chord-aware progress bar under the mission label.
    private function drawBar(dc as Dc, layout as HeroSetLayout, y as Lang.Number, value, goal) as Void {
        var left = layout.leftInset(y);
        var right = layout.rightInset(y);
        if (right <= left) {
            return;
        }
        var fraction = value >= goal ? 1.0 : (value <= 0 ? 0.0 : value.toFloat() / goal.toFloat());
        var barHeight = layout.shortInset() / 6;

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.fillRectangle(left, y, right - left, barHeight);
        if (fraction > 0.0) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
            dc.fillRectangle(left, y, ((right - left) * fraction).toNumber(), barHeight);
        }
    }

    private function formatDistance(distance as Lang.Float) as Lang.String {
        var shownDistance = distance > HeroSetConfig.RUN_GOAL_KM ? HeroSetConfig.RUN_GOAL_KM : (distance < 0.0 ? 0.0 : distance);
        var tenths = (shownDistance * 10.0).toNumber();
        return (tenths / 10) + "." + (tenths % 10);
    }
}
