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

    static function truncated(dc as Graphics.Dc, str as String, font as Graphics.FontDefinition, maxWidth as Number) as String {
        if (dc.getTextWidthInPixels(str, font) <= maxWidth) {
            return str;
        }
        var text = str;
        while (text.length() > 1) {
            text = text.substring(0, text.length() - 1) as String;
            if (dc.getTextWidthInPixels(text + "...", font) <= maxWidth) {
                return text + "...";
            }
        }
        return text;
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
}
