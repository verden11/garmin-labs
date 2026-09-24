import Toybox.Graphics;
import Toybox.Lang;

// Text drawing that measures instead of guessing (HeroSet ADR-018): every
// string is checked against the round chord at its row, so long values and
// future translations pick a shorter candidate rather than clip.
class HeroFaceDraw {

    // Test-only: when non-null, text outside the display is logged in
    // `misfits` and every text box in `boxes` as [left, top, width, height,
    // text], so the screen-fit test catches clipping and overlap per device.
    static var misfits as Array<String>?;
    static var boxes as Array<Array>?;

    static function text(dc as Graphics.Dc, layout as HeroFaceLayout, x as Number, y as Number, font as Graphics.FontDefinition, str as String, justify as Graphics.TextJustification) as Void {
        dc.drawText(x, y, font, str, justify);
        var log = misfits;
        var drawn = boxes;
        if (log == null && drawn == null) {
            return;
        }
        var width = dc.getTextWidthInPixels(str, font);
        var height = dc.getFontHeight(font);
        var left = leftEdge(x, width, justify);
        if (log != null && (y < 0 || y + height > layout.height() || left < layout.leftInset(y, height) || left + width > layout.rightInset(y, height))) {
            log.add(str + " y=" + y);
        }
        if (drawn != null) {
            drawn.add([left, y, width, height, str]);
        }
    }

    static function leftEdge(x as Number, width as Number, justify as Graphics.TextJustification) as Number {
        if (justify == Graphics.TEXT_JUSTIFY_CENTER) {
            return x - width / 2;
        }
        return justify == Graphics.TEXT_JUSTIFY_RIGHT ? x - width : x;
    }

    // Does centred text fit the chord of `radius` at row y, with `margin` px
    // of total breathing room?
    static function fits(dc as Graphics.Dc, layout as HeroFaceLayout, radius as Number, margin as Number, y as Number, str as String, font as Graphics.FontDefinition) as Boolean {
        var height = dc.getFontHeight(font);
        var available = layout.rightInsetWithin(radius, y, height) - layout.leftInsetWithin(radius, y, height) - margin;
        return dc.getTextWidthInPixels(str, font) <= available;
    }

    // First candidate that fits, else the last (shortest) one.
    static function firstFitting(dc as Graphics.Dc, layout as HeroFaceLayout, radius as Number, margin as Number, y as Number, font as Graphics.FontDefinition, candidates as Array<String>) as String {
        for (var i = 0; i < candidates.size() - 1; i++) {
            if (fits(dc, layout, radius, margin, y, candidates[i], font)) {
                return candidates[i];
            }
        }
        return candidates[candidates.size() - 1];
    }

    // First candidate no wider than `width`, else the last one.
    static function firstWithin(dc as Graphics.Dc, width as Number, font as Graphics.FontDefinition, candidates as Array<String>) as String {
        for (var i = 0; i < candidates.size() - 1; i++) {
            if (dc.getTextWidthInPixels(candidates[i], font) <= width) {
                return candidates[i];
            }
        }
        return candidates[candidates.size() - 1];
    }
}
