import Toybox.Graphics;
import Toybox.Lang;

// Measured text, never guessed (watch-design-lead handbook): the largest font in a list (largest
// first) whose width fits `maxWidth`, else the smallest, truncated with "...".
class DayArcText {
    static function fittingFont(dc as Graphics.Dc, fonts as Array<Graphics.FontDefinition>, str as String, maxWidth as Number) as Graphics.FontDefinition {
        for (var i = 0; i < fonts.size(); i++) {
            if (dc.getTextWidthInPixels(str, fonts[i]) <= maxWidth) {
                return fonts[i];
            }
        }
        return fonts[fonts.size() - 1];
    }

    // Never a bare stub: the result is the whole string, or at least one character PLUS the ellipsis,
    // or "" (draw nothing) when neither fits. A row with no room at all — a max width of 0 or less, or
    // one narrower than "X..." — used to come out as "4..." or a lone "4" (the owner's first wrist
    // photo, 2026-09-28); DayArcStack is the real guard, this is the backstop.
    static function truncated(dc as Graphics.Dc, str as String, font as Graphics.FontDefinition, maxWidth as Number) as String {
        if (maxWidth <= 0) {
            noteTruncated();
            return "";
        }
        if (dc.getTextWidthInPixels(str, font) <= maxWidth) {
            return str;
        }
        noteTruncated();
        var text = str;
        while (text.length() > 1) {
            text = text.substring(0, text.length() - 1) as String;
            if (dc.getTextWidthInPixels(text + "...", font) <= maxWidth) {
                return text + "...";
            }
        }
        return "";
    }

    // Test hook: how many strings have been shortened or dropped since the counter was last zeroed,
    // so a render test can assert that a plan left nothing truncated. Stripped from release builds.
    (:debug)
    static var truncatedCount as Number = 0;

    (:debug)
    static function noteTruncated() as Void {
        truncatedCount += 1;
    }

    (:release)
    static function noteTruncated() as Void {
    }

    // Centred on centerX, top-aligned at y, in the largest font from `fonts` that fits `maxWidth`.
    // Returns the y just below the drawn text, for stacking the next row.
    static function centered(dc as Graphics.Dc, centerX as Number, y as Number, fonts as Array<Graphics.FontDefinition>,
                              str as String, maxWidth as Number, color as Number) as Number {
        var font = fittingFont(dc, fonts, str, maxWidth);
        var fitted = truncated(dc, str, font, maxWidth);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, y, font, fitted, Graphics.TEXT_JUSTIFY_CENTER);
        return y + dc.getFontHeight(font);
    }

    // Same as centered() but in a font DayArcStack already chose (and already proved fits), so this
    // never re-picks a font per row.
    static function drawCentered(dc as Graphics.Dc, centerX as Number, y as Number, font as Graphics.FontDefinition,
                                  str as String, maxWidth as Number, color as Number) as Number {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, y, font, truncated(dc, str, font, maxWidth), Graphics.TEXT_JUSTIFY_CENTER);
        return y + dc.getFontHeight(font);
    }

    // Digits sit on the baseline and have no descender, so a digits-only row (clock, hero value)
    // needs only ascent worth of height, not the font box's full ascent + descent.
    static function inkHeight(dc as Graphics.Dc, font as Graphics.FontDefinition) as Number {
        return dc.getFontHeight(font) - Graphics.getFontDescent(font);
    }

    // Two lines split at the space that leaves the narrower widest line, preferring a double space
    // (DayArcFields joins the morning sub's segments with one) so "100% rain" is never cut in half.
    // No space to split at: one line.
    static function split(dc as Graphics.Dc, str as String, font as Graphics.FontDefinition) as Array<String> {
        var best = -1;
        var bestWidth = 0;
        var preferred = false;
        for (var i = 1; i < str.length() - 1; i++) {
            if (!isSpace(str, i)) {
                continue;
            }
            var dbl = isSpace(str, i - 1) || isSpace(str, i + 1);
            var first = str.substring(0, i) as String;
            var second = str.substring(i + 1, str.length()) as String;
            var w = max(dc.getTextWidthInPixels(first, font), dc.getTextWidthInPixels(second, font));
            if (best < 0 || (dbl && !preferred) || (dbl == preferred && w < bestWidth)) {
                best = i;
                bestWidth = w;
                preferred = dbl;
            }
        }
        if (best < 0) {
            return [str] as Array<String>;
        }
        return [trim(str.substring(0, best) as String), trim(str.substring(best + 1, str.length()) as String)] as Array<String>;
    }

    private static function isSpace(str as String, index as Number) as Boolean {
        return (str.substring(index, index + 1) as String).equals(" ");
    }

    private static function trim(str as String) as String {
        var text = str;
        while (text.length() > 1 && isSpace(text, text.length() - 1)) {
            text = text.substring(0, text.length() - 1) as String;
        }
        while (text.length() > 1 && isSpace(text, 0)) {
            text = text.substring(1, text.length()) as String;
        }
        return text;
    }

    static function max(a as Number, b as Number) as Number {
        return a > b ? a : b;
    }
}
