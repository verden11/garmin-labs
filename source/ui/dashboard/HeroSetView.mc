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

        // Five content rows (title, rank/streak, 3 missions) spread evenly
        // across the space above the footer, instead of the fixed generic
        // band step every other screen uses — with only 3 missions left
        // (Pro Run removed), the fixed step left a dead gap above the
        // footer; this always fills it, regardless of row count.
        var top = layout.shortInset();
        var bottom = layout.footerRowTop();
        var step = (bottom - top) / 5;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), top, Graphics.FONT_XTINY, "HEROSET", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), top + step, Graphics.FONT_XTINY, "R" + state.rank + "  STREAK " + state.streak, Graphics.TEXT_JUSTIFY_CENTER);

        drawMission(dc, layout, top + step * 2, "PUSH-UPS", state.pushups);
        drawMission(dc, layout, top + step * 3, "SIT-UPS", state.situps);
        drawMission(dc, layout, top + step * 4, "SQUATS", state.squats);

        dc.setColor(state.storageWarning ? Graphics.COLOR_RED : Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        var footerText = state.storageWarning ? "! COULD NOT SAVE" : "UP/DN/SEL: MENU";
        var footerWidth = dc.getTextWidthInPixels(footerText, Graphics.FONT_XTINY);
        var footerHeight = dc.getFontHeight(Graphics.FONT_XTINY);
        var footerY = layout.fitCenteredY(layout.footerRowBottom(), top + step * 4, footerWidth, footerHeight);
        dc.drawText(layout.centerX(), footerY, Graphics.FONT_XTINY, footerText, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onShow() as Void {
        _dayTracker.start();
    }

    function onHide() as Void {
        _dayTracker.stop();
    }

    private function drawMission(dc as Dc, layout as HeroSetLayout, y as Lang.Number, label as Lang.String, count as Lang.Number) as Void {
        var textHeight = dc.getFontHeight(Graphics.FONT_XTINY);
        var done = count >= HeroSetConfig.MISSION_GOAL;
        dc.setColor(done ? Graphics.COLOR_GREEN : Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.leftInset(y, textHeight), y, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(layout.rightInset(y, textHeight), y, Graphics.FONT_XTINY, count + "/" + HeroSetConfig.MISSION_GOAL, Graphics.TEXT_JUSTIFY_RIGHT);
        drawBar(dc, layout, y + textHeight + 2, count, HeroSetConfig.MISSION_GOAL);
    }

    // Thin chord-aware progress bar below the mission label.
    private function drawBar(dc as Dc, layout as HeroSetLayout, y as Lang.Number, value, goal) as Void {
        var barHeight = layout.shortInset() / 6;
        var left = layout.leftInset(y, barHeight);
        var right = layout.rightInset(y, barHeight);
        if (right <= left) {
            return;
        }
        var fraction = value >= goal ? 1.0 : (value <= 0 ? 0.0 : value.toFloat() / goal.toFloat());

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.fillRectangle(left, y, right - left, barHeight);
        if (fraction > 0.0) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
            dc.fillRectangle(left, y, ((right - left) * fraction).toNumber(), barHeight);
        }
    }
}
