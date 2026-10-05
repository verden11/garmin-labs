import Toybox.Graphics;
import Toybox.Lang;

// Text-fitting draw helpers shared by every screen. HeroSetLayout answers
// geometry; this answers "which string/font actually fits at that row" by
// measuring rendered pixels (ADR-018), never by guessing a character budget.
class HeroSetDraw {

    // Test-only: when non-null, every text draw whose box pokes outside the
    // display (the round chord at its row) is recorded in `misfits`, and
    // every text box in `boxes` as [left, top, width, height, text], so each
    // supported device's real fonts can be checked for clipping and overlap
    // without a screenshot (HeroSetScreenFitTest, ADR-034). Null in the app:
    // one null check per draw.
    static var misfits as Lang.Array<Lang.String>?;
    static var boxes as Lang.Array<Lang.Array>?;

    // Every view draws text through here instead of dc.drawText.
    static function text(dc as Graphics.Dc, layout as HeroSetLayout, x as Lang.Number, y as Lang.Number, font as Graphics.FontDefinition, str as Lang.String, justify as Graphics.TextJustification) as Void {
        dc.drawText(x, y, font, str, justify);
        var log = misfits;
        if (log == null) {
            return;
        }
        if (!fitsDisplay(dc, layout, x, y, font, str, justify)) {
            log.add(str + " y=" + y);
        }
        var drawn = boxes;
        if (drawn != null) {
            var width = dc.getTextWidthInPixels(str, font);
            drawn.add([leftEdge(x, width, justify), y, width, dc.getFontHeight(font), str]);
        }
    }

    // Centered text, the common case; cut with a "." if even the chord at y
    // is too narrow for it (see truncated). The x is the center of the row's usable
    // band, which is the screen's center everywhere but beside a subscreen
    // window (HeroSetLayout.rowCenterX).
    static function centered(dc as Graphics.Dc, layout as HeroSetLayout, y as Lang.Number, font as Graphics.FontDefinition, str as Lang.String) as Void {
        text(dc, layout, layout.rowCenterX(y, dc.getFontHeight(font)), y, font, fitted(dc, layout, y, font, str), Graphics.TEXT_JUSTIFY_CENTER);
    }

    private static function leftEdge(x as Lang.Number, width as Lang.Number, justify as Graphics.TextJustification) as Lang.Number {
        if (justify == Graphics.TEXT_JUSTIFY_CENTER) {
            return x - width / 2;
        }
        return justify == Graphics.TEXT_JUSTIFY_RIGHT ? x - width : x;
    }

    private static function fitsDisplay(dc as Graphics.Dc, layout as HeroSetLayout, x as Lang.Number, y as Lang.Number, font as Graphics.FontDefinition, str as Lang.String, justify as Graphics.TextJustification) as Lang.Boolean {
        var width = dc.getTextWidthInPixels(str, font);
        var height = dc.getFontHeight(font);
        var left = leftEdge(x, width, justify);
        return y >= 0 && y + height <= layout.height() && left >= layout.leftInset(y, height) && left + width <= layout.rightInset(y, height);
    }

    // Instructional hint in the shared hint style, walked up off the bezel
    // until it fits. Returns the y it landed on so callers can stack rows
    // directly above it.
    static function hint(dc as Graphics.Dc, layout as HeroSetLayout, maxY as Lang.Number, minY as Lang.Number, text as Lang.String) as Lang.Number {
        var width = dc.getTextWidthInPixels(text, Graphics.FONT_XTINY);
        var height = dc.getFontHeight(Graphics.FONT_XTINY);
        var y = layout.fitCenteredY(maxY, minY, width, height);
        dc.setColor(HeroSetPalette.MUTED, HeroSetPalette.BACKGROUND);
        HeroSetDraw.centered(dc, layout, y, Graphics.FONT_XTINY, text);
        return y;
    }

    // Screen title in the first band, where the round screen is narrowest:
    // shrinks to fit rather than clip long translations (e.g. Dutch
    // BUIKSPIEROEFENINGEN), and moves down into a wider chord when even the
    // smallest font is too wide there (360 px). Returns the y just below it.
    static function title(dc as Graphics.Dc, layout as HeroSetLayout, text as Lang.String) as Lang.Number {
        var y = layout.bandTop(0);
        var fonts = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Lang.Array<Graphics.FontDefinition>;
        var font = largestFont(dc, layout, layout.displayRadius(), layout.textMargin(), y, text, fonts);
        if (layout.subscreen() != null || layout.rectangle()) {
            // Beside a subscreen window, or on a rectangle, there is no wider
            // chord to move down to (walking down only ran the title into the
            // rows below: Danish on venusq2, ADR-058), so cut the word instead.
            text = fitted(dc, layout, y, font, text);
        }
        while (!layout.rectangle() && y < layout.centerY() && !fits(dc, layout, layout.displayRadius(), layout.textMargin(), y, text, font)) {
            y += 2;
        }
        dc.setColor(HeroSetPalette.TEXT, HeroSetPalette.BACKGROUND);
        HeroSetDraw.centered(dc, layout, y, font, text);
        return y + dc.getFontHeight(font);
    }

    // `text` if it is at most `maxWidth` px wide in `font`, else its longest
    // prefix that fits with a "." after it (a long translation, e.g. Swedish
    // ARMHÄVNINGAR in a 95 px band, still reads as its word).
    static function truncated(dc as Graphics.Dc, text as Lang.String, font as Graphics.FontDefinition, maxWidth as Lang.Number) as Lang.String {
        var length = text.length();
        if (dc.getTextWidthInPixels(text, font) <= maxWidth) {
            return text;
        }
        while (length > 1) {
            length--;
            var cut = text.substring(0, length) + ".";
            if (dc.getTextWidthInPixels(cut, font) <= maxWidth) {
                return cut;
            }
        }
        return text.substring(0, 1);
    }

    // `text` cut to the chord the row at y offers (see truncated).
    static function fitted(dc as Graphics.Dc, layout as HeroSetLayout, y as Lang.Number, font as Graphics.FontDefinition, text as Lang.String) as Lang.String {
        var height = dc.getFontHeight(font);
        return truncated(dc, text, font, layout.rightInsetWithin(layout.displayRadius(), y, height) - layout.leftInsetWithin(layout.displayRadius(), y, height));
    }

    // Does centered text fit the chord at row y, inside `radius` and with
    // `margin` px of total breathing room? Against the display radius the
    // margin keeps text off the bezel; against the dashboard's content
    // radius it is 0, because that radius already includes its own margin.
    static function fits(dc as Graphics.Dc, layout as HeroSetLayout, radius as Lang.Number, margin as Lang.Number, y as Lang.Number, text as Lang.String, font as Graphics.FontDefinition) as Lang.Boolean {
        var height = dc.getFontHeight(font);
        var available = layout.rightInsetWithin(radius, y, height) - layout.leftInsetWithin(radius, y, height) - margin;
        return dc.getTextWidthInPixels(text, font) <= available;
    }

    // First candidate that fits, else the last (shortest) one — values like
    // rank/streak grow without bound, so the caller supplies tighter fallbacks.
    static function firstFitting(dc as Graphics.Dc, layout as HeroSetLayout, radius as Lang.Number, margin as Lang.Number, y as Lang.Number, font as Graphics.FontDefinition, candidates as Lang.Array<Lang.String>) as Lang.String {
        for (var i = 0; i < candidates.size() - 1; i++) {
            if (fits(dc, layout, radius, margin, y, candidates[i], font)) {
                return candidates[i];
            }
        }
        return candidates[candidates.size() - 1];
    }

    // Largest-first font list; falls back to the last (smallest) font.
    static function largestFont(dc as Graphics.Dc, layout as HeroSetLayout, radius as Lang.Number, margin as Lang.Number, y as Lang.Number, text as Lang.String, fonts as Lang.Array<Graphics.FontDefinition>) as Graphics.FontDefinition {
        for (var i = 0; i < fonts.size() - 1; i++) {
            if (fits(dc, layout, radius, margin, y, text, fonts[i])) {
                return fonts[i];
            }
        }
        return fonts[fonts.size() - 1];
    }

    // Largest font whose box also fits vertically inside [top, bottom], once
    // centered there. Always measured against the display, never a smaller
    // concentric circle.
    static function largestFontInBand(dc as Graphics.Dc, layout as HeroSetLayout, top as Lang.Number, bottom as Lang.Number, text as Lang.String, fonts as Lang.Array<Graphics.FontDefinition>) as Graphics.FontDefinition {
        for (var i = 0; i < fonts.size() - 1; i++) {
            var height = dc.getFontHeight(fonts[i]);
            if (height <= bottom - top && fits(dc, layout, layout.displayRadius(), layout.textMargin(), centeredTop(top, bottom, height), text, fonts[i])) {
                return fonts[i];
            }
        }
        return fonts[fonts.size() - 1];
    }

    static function centeredTop(top as Lang.Number, bottom as Lang.Number, height as Lang.Number) as Lang.Number {
        return top + (bottom - top - height) / 2;
    }
}
