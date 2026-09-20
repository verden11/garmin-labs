import Toybox.Graphics;
import Toybox.Lang;

// The time, the largest thing on the face, with optional seconds tucked
// against its right edge on the digits' baseline.
class HeroFaceClock {

    // Returns the seconds' box [x, y, width, height] for partial updates, or
    // null when no seconds are drawn.
    static function draw(dc as Graphics.Dc, layout as HeroFaceLayout, state as HeroFaceState) as Array<Number>? {
        var font = layout.timeFont;
        dc.setColor(HeroFacePalette.TEXT, Graphics.COLOR_TRANSPARENT);
        HeroFaceDraw.text(dc, layout, layout.centerX(), layout.timeTop, font, state.time, Graphics.TEXT_JUSTIFY_CENTER);
        var seconds = state.seconds;
        if (seconds == null) {
            return null;
        }
        var x = layout.centerX() + dc.getTextWidthInPixels(state.time, font) / 2 + layout.stackGap() * 2;
        var width = dc.getTextWidthInPixels("00", Graphics.FONT_XTINY);
        var height = dc.getFontHeight(Graphics.FONT_XTINY);
        // On the digits' baseline, but never so low that it reaches the row
        // below: on a small screen the time's box already ends close to it.
        var y = layout.timeTop + Graphics.getFontAscent(font) - Graphics.getFontAscent(Graphics.FONT_XTINY);
        var floor = layout.underTimeTop - layout.stackGap() - height;
        if (y > floor) {
            y = floor;
        }
        // No room beside a wide time on a small screen: skip seconds rather
        // than let them touch the ring.
        if (x + width > layout.rightInsetWithin(layout.contentRadius(), y, height)) {
            return null;
        }
        dc.setColor(HeroFacePalette.MUTED, Graphics.COLOR_TRANSPARENT);
        HeroFaceDraw.text(dc, layout, x, y, Graphics.FONT_XTINY, seconds, Graphics.TEXT_JUSTIFY_LEFT);
        return [x, y, width, height] as Array<Number>;
    }
}
