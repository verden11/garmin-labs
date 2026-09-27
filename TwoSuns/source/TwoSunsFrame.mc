import Toybox.Graphics;
import Toybox.Lang;

// The fonts and row positions for one state on this display. Fonts come first (each row takes the
// largest that stays under its height cap), then the rows are stacked from those heights. When the
// stack is too tall for the display, optional rows drop in this order: date, curve, sun line.
// The time and the Body Battery value never drop.
class TwoSunsFrame {
    var dateFont as Graphics.FontDefinition;
    var timeFont as Graphics.FontDefinition;
    var valueFont as Graphics.FontDefinition;
    var lineFont as Graphics.FontDefinition;
    // Each row may step down from its font, never up: the fonts from the chosen one on.
    var dateFonts as Array<Graphics.FontDefinition>;
    var timeFonts as Array<Graphics.FontDefinition>;
    var valueFonts as Array<Graphics.FontDefinition>;
    var lineFonts as Array<Graphics.FontDefinition>;
    var rows as TwoSunsRows;
    var bandHeight as Number = 0;
    var band as TwoSunsBand;
    var showDate as Boolean;
    var showCurve as Boolean;
    var showLine as Boolean;

    // `sleeping` keeps only the time, the value and the sun line (always-on).
    function initialize(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState, sleeping as Boolean) {
        dateFont = TwoSunsDraw.fontUpTo(dc, TwoSunsLayout.DATE_FONTS, layout.capFor(TwoSunsLayout.DATE_MAX_PERMILLE));
        // Always-on time is two steps below whatever awake would pick right now, not a separate fixed
        // list — so it stays visibly smaller than awake on every screen, not just the ones where awake
        // happens to land on its largest font (TwoSunsLayout.SLEEP_TIME_FONTS comment; 2026-09-27).
        var awakeTimeFont = TwoSunsDraw.fontUpTo(dc, TwoSunsLayout.TIME_FONTS, layout.capFor(TwoSunsLayout.TIME_MAX_PERMILLE));
        if (sleeping) {
            timeFonts = TwoSunsDraw.fontsBelow(TwoSunsLayout.TIME_FONTS, awakeTimeFont, 2);
            timeFont = timeFonts[0];
        } else {
            timeFont = awakeTimeFont;
            timeFonts = TwoSunsDraw.fontsFrom(TwoSunsLayout.TIME_FONTS, timeFont);
        }
        valueFont = TwoSunsDraw.fontUpTo(dc, TwoSunsLayout.VALUE_FONTS, layout.capFor(TwoSunsLayout.VALUE_MAX_PERMILLE));
        lineFont = TwoSunsDraw.fontUpTo(dc, TwoSunsLayout.LINE_FONTS, layout.capFor(TwoSunsLayout.LINE_MAX_PERMILLE));
        dateFonts = TwoSunsDraw.fontsFrom(TwoSunsLayout.DATE_FONTS, dateFont);
        valueFonts = TwoSunsDraw.fontsFrom(TwoSunsLayout.VALUE_FONTS, valueFont);
        lineFonts = TwoSunsDraw.fontsFrom(TwoSunsLayout.LINE_FONTS, lineFont);
        showDate = !sleeping && state.showDate && state.dateLines.size() > 0;
        showCurve = !sleeping && state.curve != null;
        showLine = state.skyLines.size() > 0;
        rows = dropRowsUntilItFits(dc, layout);
        band = planBand(dc, layout, state);
        if (showCurve && !band.hasCurve) {
            showCurve = false;   // no room for a useful curve on this chord: the glyph and the value stay
            rows = plan(dc, layout);
            band = planBand(dc, layout, state);
        }
    }

    // Drops optional rows (date, then curve, then line) until the stack fits the span, then returns the rows.
    private function dropRowsUntilItFits(dc as Graphics.Dc, layout as TwoSunsLayout) as TwoSunsRows {
        var stacked = plan(dc, layout);
        while (layout.stackHeight(dateHeight(dc), dc.getFontHeight(timeFont), bandHeight, lineHeight(dc)) > layout.spanHeight()
               && (showDate || showCurve || showLine)) {
            if (showDate) {
                showDate = false;
            } else if (showCurve) {
                showCurve = false;
            } else {
                showLine = false;
            }
            stacked = plan(dc, layout);
        }
        return stacked;
    }

    // The widest value the band must hold is measured, not guessed: the text itself or "100".
    private function planBand(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState) as TwoSunsBand {
        var widest = dc.getTextWidthInPixels(TwoSunsConfig.BATTERY_MAX.toString(), valueFont);
        var width = dc.getTextWidthInPixels(state.batteryText, valueFont);
        return TwoSunsBand.plan(layout, rows.bandTop, bandHeight, width > widest ? width : widest, dc.getFontHeight(valueFont), showCurve);
    }

    private function plan(dc as Graphics.Dc, layout as TwoSunsLayout) as TwoSunsRows {
        var valueHeight = dc.getFontHeight(valueFont);
        var curveHeight = layout.capFor(TwoSunsLayout.CURVE_BAND_PERMILLE);
        bandHeight = showCurve && curveHeight > valueHeight ? curveHeight : valueHeight;
        return layout.rows(dateHeight(dc), dc.getFontHeight(timeFont), bandHeight, lineHeight(dc));
    }

    private function dateHeight(dc as Graphics.Dc) as Number {
        return showDate ? dc.getFontHeight(dateFont) : 0;
    }

    private function lineHeight(dc as Graphics.Dc) as Number {
        return showLine ? dc.getFontHeight(lineFont) : 0;
    }
}
