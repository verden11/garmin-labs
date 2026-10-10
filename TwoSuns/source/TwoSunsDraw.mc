import Toybox.Graphics;
import Toybox.Lang;

// Text drawing that measures instead of guessing: every string is checked
// against the round chord at its row, so a long name or translation picks a
// smaller font or a shorter wording rather than clip.
class TwoSunsDraw {

    // Test-only: when non-null, text outside the display is logged in
    // `misfits` and every text box in `boxes` as [left, top, width, height,
    // text], so the screen-fit test catches clipping and overlap per device.
    static var misfits as Array<String>?;
    static var boxes as Array<Array>?;

    static function text(dc as Graphics.Dc, layout as TwoSunsLayout, x as Number, y as Number, font as Graphics.FontDefinition, str as String, justify as Graphics.TextJustification) as Void {
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

    // A rectangle's time, placed by its digits (TwoSunsRectSpread): drawn centred at `x`, and logged for the screen-fit
    // test by its digits' box (the font box less `pad` above and below, where a number font draws nothing).
    (:rect)
    static function inkText(dc as Graphics.Dc, layout as TwoSunsLayout, x as Number, y as Number, font as Graphics.FontDefinition,
                            str as String, pad as Number) as Void {
        dc.drawText(x, y, font, str, Graphics.TEXT_JUSTIFY_CENTER);
        var width = dc.getTextWidthInPixels(str, font);
        var inkTop = y + pad;
        var inkH = dc.getFontHeight(font) - 2 * pad;
        var log = misfits;
        if (log != null && (inkTop < 0 || inkTop + inkH > layout.height() || x - width / 2 < layout.leftInset(inkTop, inkH)
                            || x + width / 2 > layout.rightInset(inkTop, inkH))) {
            log.add(str + " y=" + y);
        }
        var drawn = boxes;
        if (drawn != null) {
            drawn.add([x - width / 2, inkTop, width, inkH, str]);
        }
    }

    // Test-only, like text(): logs a non-text box (the level pill, the curve) against the content circle
    // of the face, so it can neither touch the ring nor overlap a text.
    static function box(layout as TwoSunsLayout, x as Number, y as Number, width as Number, height as Number, label as String) as Void {
        var log = misfits;
        var drawn = boxes;
        if (log != null && (y < 0 || y + height > layout.height()
            || x < layout.leftInsetWithin(layout.contentRadius(), y, height) || x + width > layout.rightInsetWithin(layout.contentRadius(), y, height))) {
            log.add(label + " outside the content circle y=" + y);
        }
        if (drawn != null) {
            drawn.add([x, y, width, height, label]);
        }
    }

    // The largest font (fonts are listed largest first) no taller than maxHeight, else the smallest.
    static function fontUpTo(dc as Graphics.Dc, fonts as Array<Graphics.FontDefinition>, maxHeight as Number) as Graphics.FontDefinition {
        for (var i = 0; i < fonts.size() - 1; i++) {
            if (dc.getFontHeight(fonts[i]) <= maxHeight) {
                return fonts[i];
            }
        }
        return fonts[fonts.size() - 1];
    }

    // The fonts from `first` on (they are listed largest first), so a line may step down from the font its
    // row was sized for, never up.
    static function fontsFrom(fonts as Array<Graphics.FontDefinition>, first as Graphics.FontDefinition) as Array<Graphics.FontDefinition> {
        for (var i = 0; i < fonts.size(); i++) {
            if (fonts[i] == first) {
                return fonts.slice(i, fonts.size()) as Array<Graphics.FontDefinition>;
            }
        }
        return [fonts[fonts.size() - 1]] as Array<Graphics.FontDefinition>;
    }

    // The fonts starting `drop` steps below `first` in `fonts` (largest first), floored at the smallest —
    // for a row that must shrink further than another row's own choice, e.g. always-on time kept visibly
    // smaller than whatever awake picked, not just re-picking independently and sometimes landing on the
    // same size (caught by watch-design-reviewer, 2026-09-27: the old independent SLEEP_TIME_FONTS list
    // matched awake's font exactly whenever awake had already fallen back from its largest choice).
    static function fontsBelow(fonts as Array<Graphics.FontDefinition>, first as Graphics.FontDefinition, drop as Number) as Array<Graphics.FontDefinition> {
        for (var i = 0; i < fonts.size(); i++) {
            if (fonts[i] == first) {
                var start = i + drop;
                if (start >= fonts.size()) {
                    start = fonts.size() - 1;
                }
                return fonts.slice(start, fonts.size()) as Array<Graphics.FontDefinition>;
            }
        }
        return [fonts[fonts.size() - 1]] as Array<Graphics.FontDefinition>;
    }

    // Draws one line centred in its band, in the largest font (fonts are
    // listed largest first) and longest wording (candidates, longest first)
    // that fits: height within the band, width within the chord of `radius`
    // at that row; `dx` shifts it sideways (always-on drift). Nothing fits: the last font, cut short with "...".
    static function line(dc as Graphics.Dc, layout as TwoSunsLayout, radius as Number, top as Number, bandHeight as Number,
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
        var log = misfits;
        if (log != null) {
            log.add("cut: " + candidates[candidates.size() - 1] + " y=" + y);
        }
        centered(dc, layout, dx, top, bandHeight, font, truncated(dc, candidates[candidates.size() - 1], font, room));
    }

    private static function centered(dc as Graphics.Dc, layout as TwoSunsLayout, dx as Number, top as Number, bandHeight as Number,
                                     font as Graphics.FontDefinition, str as String) as Void {
        var y = top + (bandHeight - dc.getFontHeight(font)) / 2;
        text(dc, layout, layout.rowCenterX(y, dc.getFontHeight(font)) + dx, y, font, str, Graphics.TEXT_JUSTIFY_CENTER);
    }

    static function fits(dc as Graphics.Dc, layout as TwoSunsLayout, radius as Number, top as Number, bandHeight as Number,
                         font as Graphics.FontDefinition, str as String) as Boolean {
        var height = dc.getFontHeight(font);
        if (height > bandHeight) {
            return false;
        }
        var y = top + (bandHeight - height) / 2;
        var room = layout.rightInsetWithin(radius, y, height) - layout.leftInsetWithin(radius, y, height);
        return dc.getTextWidthInPixels(str, font) <= room;
    }

    // `str` cut to fit `width` in `font`, ending "..." when it was cut. Stops at the first cut whose text
    // plus "..." fits; only when even one character plus the marker is too wide does it come back bare.
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
