import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Continuous delta picker: Up/Down step the delta by 1 (held Up/Down
// auto-repeats and accelerates via HeroSetManualPickerDelegate), replacing
// the old discrete +1/+5/+10 menu items entirely.
class HeroSetManualPickerView extends WatchUi.View {

    private var _exercise;
    private var _delta = 0;
    private var _saved = false;

    function initialize(exercise as Lang.Symbol) {
        View.initialize();
        _exercise = exercise;
    }

    function adjust(amount as Lang.Number) as Void {
        _delta += amount;
        WatchUi.requestUpdate();
    }

    function getDelta() as Lang.Number {
        return _delta;
    }

    function getExercise() as Lang.Symbol {
        return _exercise;
    }

    function saveEntry() as Void {
        if (_saved) {
            return;
        }
        _saved = true;
        if (_delta != 0) {
            getApp().getStore().add(_exercise, _delta);
        }
    }

    function onUpdate(dc as Dc) as Void {
        var layout = new HeroSetLayout(dc);
        var label = _exercise == :pushups ? "PUSH-UPS" : (_exercise == :situps ? "SIT-UPS" : "SQUATS");
        var current = getApp().getStore().getCount(_exercise);
        var resulting = current + _delta;
        if (resulting < 0) {
            resulting = 0;
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(layout.centerX(), layout.bandTop(0), Graphics.FONT_SMALL, label, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(_delta < 0 ? Graphics.COLOR_RED : Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(1), Graphics.FONT_LARGE, deltaText(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), layout.bandTop(2), Graphics.FONT_SMALL, resulting + "/" + HeroSetConfig.MISSION_GOAL, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        drawFooterLine(dc, layout, layout.footerRowTop(), "HOLD UP/DN: FAST");
        drawFooterLine(dc, layout, layout.footerRowBottom(), "SELECT: SAVE");
    }

    // Centered footer text, shifted up off the bezel if it wouldn't
    // otherwise fit the round chord at its natural row (measured against the
    // real rendered width, not a guessed character budget).
    private function drawFooterLine(dc as Dc, layout as HeroSetLayout, maxY as Lang.Number, text as Lang.String) as Void {
        var textWidth = dc.getTextWidthInPixels(text, Graphics.FONT_XTINY);
        var textHeight = dc.getFontHeight(Graphics.FONT_XTINY);
        var y = layout.fitCenteredY(maxY, layout.bandTop(2), textWidth, textHeight);
        dc.drawText(layout.centerX(), y, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function deltaText() as Lang.String {
        return _delta > 0 ? ("+" + _delta) : _delta.toString();
    }
}
