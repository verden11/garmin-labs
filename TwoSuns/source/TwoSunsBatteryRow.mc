import Toybox.Graphics;
import Toybox.Lang;

// The watch's own battery, one muted row above the first row of the stack (docs/decisions.md ADR-023, Watch battery row):
// a classic battery (outline and nub, so it cannot be mistaken for the Body Battery bolt) and the percentage. It lives in
// the free strip between the stack and the ring, so it never moves another row. It is drawn only where it fits the round
// chord (measured on the row's ink, not its font box); on small screens there is no room and it is simply not drawn.
// Pro only, setting Battery.
(:pro)
class TwoSunsBatteryRow {
    private static const GLYPH_HEIGHT_PERCENT = 55;   // of the label font's height
    private static const GLYPH_ASPECT_PERCENT = 200;  // glyph width as a share of its height
    private static const NUB_WIDTH_PERCENT = 12;      // of the glyph height
    private static const NUB_HEIGHT_PERCENT = 30;
    private static const PAD_PERCENT = 14;            // the fill's inset, of the glyph height
    private static const CORNER_PERCENT = 20;
    private static const PEN_DIVISOR = 18;            // pen, a share of the label height
    private static const GAP_DIVISOR = 4;             // glyph to text, a share of the label height
    private static const INK_PERCENT = 65;            // the row's ink, of the label height

    static function text(percent as Number) as String {
        return percent.toString() + "%";
    }

    private static function font() as Graphics.FontDefinition {
        return TwoSunsLayout.DATE_FONTS[TwoSunsLayout.DATE_FONTS.size() - 1];
    }

    private static function glyphHeight(dc as Graphics.Dc) as Number {
        return dc.getFontHeight(font()) * GLYPH_HEIGHT_PERCENT / TwoSunsConfig.PERCENT;
    }

    private static function nubWidth(dc as Graphics.Dc) as Number {
        var width = glyphHeight(dc) * NUB_WIDTH_PERCENT / TwoSunsConfig.PERCENT;
        return width < 2 ? 2 : width;
    }

    // The whole row's width: glyph, nub, gap, text.
    static function width(dc as Graphics.Dc, percent as Number) as Number {
        var gh = glyphHeight(dc);
        return gh * GLYPH_ASPECT_PERCENT / TwoSunsConfig.PERCENT + nubWidth(dc) + dc.getFontHeight(font()) / GAP_DIVISOR
            + dc.getTextWidthInPixels(text(percent), font());
    }

    // The row sits one gap above `firstTop`, the top of the stack's first row.
    static function top(dc as Graphics.Dc, layout as TwoSunsLayout, firstTop as Number) as Number {
        return firstTop - layout.gap() - dc.getFontHeight(font());
    }

    // Whether the row's ink fits the round chord at that height and the display.
    static function fits(dc as Graphics.Dc, layout as TwoSunsLayout, top as Number, percent as Number) as Boolean {
        var ink = dc.getFontHeight(font()) * INK_PERCENT / TwoSunsConfig.PERCENT;
        var y = top + (dc.getFontHeight(font()) - ink) / 2;
        var radius = layout.contentRadius();
        return y >= 0 && layout.rightInsetWithin(radius, y, ink) - layout.leftInsetWithin(radius, y, ink) >= width(dc, percent);
    }

    static function draw(dc as Graphics.Dc, layout as TwoSunsLayout, top as Number, percent as Number) as Void {
        var labelH = dc.getFontHeight(font());
        var gh = glyphHeight(dc);
        var gw = gh * GLYPH_ASPECT_PERCENT / TwoSunsConfig.PERCENT;
        var pen = labelH / PEN_DIVISOR < 1 ? 1 : labelH / PEN_DIVISOR;
        var left = layout.centerX() - width(dc, percent) / 2;
        var gy = top + (labelH - gh) / 2;
        dc.setColor(TwoSunsPalette.MUTED, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(pen);
        dc.drawRoundedRectangle(left, gy, gw, gh, gh * CORNER_PERCENT / TwoSunsConfig.PERCENT);
        dc.setPenWidth(1);
        dc.fillRectangle(left + gw + 1, gy + (gh - gh * NUB_HEIGHT_PERCENT / TwoSunsConfig.PERCENT) / 2, nubWidth(dc), gh * NUB_HEIGHT_PERCENT / TwoSunsConfig.PERCENT);
        var pad = gh * PAD_PERCENT / TwoSunsConfig.PERCENT;
        dc.fillRectangle(left + pad, gy + pad, (gw - 2 * pad) * percent / TwoSunsConfig.BATTERY_MAX, gh - 2 * pad);
        dc.drawText(left + gw + nubWidth(dc) + labelH / GAP_DIVISOR, top, font(), text(percent), Graphics.TEXT_JUSTIFY_LEFT);
        var ink = labelH * INK_PERCENT / TwoSunsConfig.PERCENT;
        TwoSunsDraw.box(layout, left, top + (labelH - ink) / 2, width(dc, percent), ink, "battery");
    }
}
