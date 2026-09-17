import Toybox.Graphics;
import Toybox.Lang;

// Text-fitting draw helpers shared by every screen. HeroSetLayout answers
// geometry; this answers "which string/font actually fits at that row" by
// measuring rendered pixels (ADR-018), never by guessing a character budget.
class HeroSetDraw {

    // Instructional hint in the shared hint style, walked up off the bezel
    // until it fits. Returns the y it landed on so callers can stack rows
    // directly above it.
    static function hint(dc as Graphics.Dc, layout as HeroSetLayout, maxY as Lang.Number, minY as Lang.Number, text as Lang.String) as Lang.Number {
        return fittedLine(dc, layout, maxY, minY, text, HeroSetPalette.MUTED);
    }

    static function fittedLine(dc as Graphics.Dc, layout as HeroSetLayout, maxY as Lang.Number, minY as Lang.Number, text as Lang.String, color as Graphics.ColorType) as Lang.Number {
        var width = dc.getTextWidthInPixels(text, Graphics.FONT_XTINY);
        var height = dc.getFontHeight(Graphics.FONT_XTINY);
        var y = layout.fitCenteredY(maxY, minY, width, height);
        dc.setColor(color, Graphics.COLOR_BLACK);
        dc.drawText(layout.centerX(), y, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_CENTER);
        return y;
    }

    static function fitsCentered(dc as Graphics.Dc, layout as HeroSetLayout, y as Lang.Number, text as Lang.String, font as Graphics.FontDefinition) as Lang.Boolean {
        var height = dc.getFontHeight(font);
        var available = layout.rightInset(y, height) - layout.leftInset(y, height) - layout.textMargin();
        return dc.getTextWidthInPixels(text, font) <= available;
    }

    // Inside a concentric circle smaller than the display (the dashboard's
    // content radius already includes its margin, so none is subtracted).
    static function fitsWithin(dc as Graphics.Dc, layout as HeroSetLayout, radius as Lang.Number, y as Lang.Number, text as Lang.String, font as Graphics.FontDefinition) as Lang.Boolean {
        var height = dc.getFontHeight(font);
        var available = layout.rightInsetWithin(radius, y, height) - layout.leftInsetWithin(radius, y, height);
        return dc.getTextWidthInPixels(text, font) <= available;
    }

    static function firstFittingWithin(dc as Graphics.Dc, layout as HeroSetLayout, radius as Lang.Number, y as Lang.Number, font as Graphics.FontDefinition, candidates as Lang.Array<Lang.String>) as Lang.String {
        for (var i = 0; i < candidates.size() - 1; i++) {
            if (fitsWithin(dc, layout, radius, y, candidates[i], font)) {
                return candidates[i];
            }
        }
        return candidates[candidates.size() - 1];
    }

    static function largestFontWithin(dc as Graphics.Dc, layout as HeroSetLayout, radius as Lang.Number, y as Lang.Number, text as Lang.String, fonts as Lang.Array<Graphics.FontDefinition>) as Graphics.FontDefinition {
        for (var i = 0; i < fonts.size() - 1; i++) {
            if (fitsWithin(dc, layout, radius, y, text, fonts[i])) {
                return fonts[i];
            }
        }
        return fonts[fonts.size() - 1];
    }

    // First candidate that fits, else the last (shortest) one — values like
    // rank/streak grow without bound, so the caller supplies tighter fallbacks.
    static function firstFitting(dc as Graphics.Dc, layout as HeroSetLayout, y as Lang.Number, font as Graphics.FontDefinition, candidates as Lang.Array<Lang.String>) as Lang.String {
        for (var i = 0; i < candidates.size() - 1; i++) {
            if (fitsCentered(dc, layout, y, candidates[i], font)) {
                return candidates[i];
            }
        }
        return candidates[candidates.size() - 1];
    }

    // Largest font (largest-first list) whose box fits vertically inside
    // [top, bottom] and horizontally inside the chord once centered there;
    // falls back to the last (smallest) font.
    static function largestFontInBand(dc as Graphics.Dc, layout as HeroSetLayout, top as Lang.Number, bottom as Lang.Number, text as Lang.String, fonts as Lang.Array<Graphics.FontDefinition>) as Graphics.FontDefinition {
        for (var i = 0; i < fonts.size() - 1; i++) {
            var height = dc.getFontHeight(fonts[i]);
            if (height <= bottom - top && fitsCentered(dc, layout, centeredTop(top, bottom, height), text, fonts[i])) {
                return fonts[i];
            }
        }
        return fonts[fonts.size() - 1];
    }

    static function centeredTop(top as Lang.Number, bottom as Lang.Number, height as Lang.Number) as Lang.Number {
        return top + (bottom - top - height) / 2;
    }

    // Largest-first font list; falls back to the last (smallest) font.
    static function largestFont(dc as Graphics.Dc, layout as HeroSetLayout, y as Lang.Number, text as Lang.String, fonts as Lang.Array<Graphics.FontDefinition>) as Graphics.FontDefinition {
        for (var i = 0; i < fonts.size() - 1; i++) {
            if (fitsCentered(dc, layout, y, text, fonts[i])) {
                return fonts[i];
            }
        }
        return fonts[fonts.size() - 1];
    }
}
