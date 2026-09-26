import Toybox.Graphics;
import Toybox.Lang;

// Text drawing that measures instead of guessing: every string is checked
// against the round chord at its row, so a long name or translation picks a
// smaller font or a shorter wording rather than clip.
class DaysToGoDraw {

    // Test-only: when non-null, text outside the display is logged in
    // `misfits` and every text box in `boxes` as [left, top, width, height,
    // text], so the screen-fit test catches clipping and overlap per device.
    static var misfits as Array<String>?;
    static var boxes as Array<Array>?;

    static function text(dc as Graphics.Dc, layout as DaysToGoLayout, x as Number, y as Number, font as Graphics.FontDefinition, str as String, justify as Graphics.TextJustification) as Void {
        dc.drawText(x, y, font, str, justify);
        var log = misfits;
        var drawn = boxes;
        if (log == null && drawn == null) {
            return;
        }
        var width = dc.getTextWidthInPixels(str, font);
        var height = dc.getFontHeight(font);
        var left = x - width / 2;
        if (log != null && (y < 0 || y + height > layout.height() || left < layout.leftInset(y, height) || left + width > layout.rightInset(y, height))) {
            log.add(str + " y=" + y);
        }
        if (drawn != null) {
            drawn.add([left, y, width, height, str]);
        }
    }

    // The largest font (largest first) no taller than maxHeight, else the smallest.
    static function fontUpTo(dc as Graphics.Dc, fonts as Array<Graphics.FontDefinition>, maxHeight as Number) as Graphics.FontDefinition {
        for (var i = 0; i < fonts.size() - 1; i++) {
            if (dc.getFontHeight(fonts[i]) <= maxHeight) {
                return fonts[i];
            }
        }
        return fonts[fonts.size() - 1];
    }

    // Draws one line centred in its band, in the largest font (fonts are
    // listed largest first) and longest wording (candidates, longest first)
    // that fits: height within the band, width within the chord of `radius`
    // at that row; `dx` shifts it sideways (always-on drift). Nothing fits: the last font, cut short with "...".
    static function line(dc as Graphics.Dc, layout as DaysToGoLayout, radius as Number, top as Number, bandHeight as Number,
                         fonts as Array<Graphics.FontDefinition>, candidates as Array<String>, dx as Number) as Void {
        for (var f = 0; f < fonts.size(); f++) {
            for (var c = 0; c < candidates.size(); c++) {
                if (fits(dc, layout, radius, top, bandHeight, fonts[f], candidates[c])) {
                    centered(dc, layout, dx, top, bandHeight, fonts[f], candidates[c]);
                    return;
                }
            }
        }
        var font = fonts[fonts.size() - 1];
        var height = dc.getFontHeight(font);
        var y = top + (bandHeight - height) / 2;
        var room = layout.rightInsetWithin(radius, y, height) - layout.leftInsetWithin(radius, y, height);
        centered(dc, layout, dx, top, bandHeight, font, truncated(dc, candidates[candidates.size() - 1], font, room));
    }

    private static function centered(dc as Graphics.Dc, layout as DaysToGoLayout, dx as Number, top as Number, bandHeight as Number,
                                     font as Graphics.FontDefinition, str as String) as Void {
        text(dc, layout, layout.centerX() + dx, top + (bandHeight - dc.getFontHeight(font)) / 2, font, str, Graphics.TEXT_JUSTIFY_CENTER);
    }

    static function fits(dc as Graphics.Dc, layout as DaysToGoLayout, radius as Number, top as Number, bandHeight as Number,
                         font as Graphics.FontDefinition, str as String) as Boolean {
        var height = dc.getFontHeight(font);
        if (height > bandHeight) {
            return false;
        }
        var y = top + (bandHeight - height) / 2;
        var room = layout.rightInsetWithin(radius, y, height) - layout.leftInsetWithin(radius, y, height);
        return dc.getTextWidthInPixels(str, font) <= room;
    }

    // `str` cut to fit `width` in `font`, ending "..." when it was cut. Stops at the
    // first cut whose text plus "..." fits, so the marker is never lost.
    static function truncated(dc as Graphics.Dc, str as String, font as Graphics.FontDefinition, width as Number) as String {
        if (dc.getTextWidthInPixels(str, font) <= width) {
            return str;
        }
        var text = str;
        while (text.length() > 1) {
            text = text.substring(0, text.length() - 1) as String;
            if (dc.getTextWidthInPixels(text + "...", font) <= width) {
                return text + "...";
            }
        }
        return text;
    }
}
