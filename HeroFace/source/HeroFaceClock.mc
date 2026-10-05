import Toybox.Graphics;
import Toybox.Lang;

// The time, the largest thing on the face, with optional seconds tucked
// against its right edge on the digits' baseline.
class HeroFaceClock {

    // Returns the seconds' box [x, y, width, height] for partial updates, or
    // null when no seconds are drawn.
    static function draw(dc as Graphics.Dc, layout as HeroFaceLayout, state as HeroFaceState) as Array<Number>? {
        var seconds = state.seconds;
        // A rectangle keeps the seconds' width free beside a smaller time only while they are drawn (HeroFaceFrame).
        var font = seconds != null ? layout.secondsTimeFont : layout.timeFont;
        var empty = underTimeEmpty(layout, state);
        var top = seconds != null ? layout.secondsTimeTop : layout.timeTop;
        top = empty ? top + (dc.getFontHeight(Graphics.FONT_XTINY) + layout.stackGap()) / 2 : top;
        dc.setColor(HeroFacePalette.TEXT, Graphics.COLOR_TRANSPARENT);
        var center = layout.rowCenterX(top, dc.getFontHeight(font));
        if (layout.rectangle()) {
            // Placed by its digits' ink (HeroFaceFrame): the font box's empty headroom and descent may reach into the
            // rows around it, so the ink is what is checked for fit and overlap.
            dc.drawText(center, top, font, state.time, Graphics.TEXT_JUSTIFY_CENTER);
            var ink = HeroFaceFrame.inkHeight(font);
            var width = dc.getTextWidthInPixels(state.time, font);
            HeroFaceDraw.box(layout, center - width / 2, top + Graphics.getFontAscent(font) - ink, width, ink, state.time);
        } else {
            HeroFaceDraw.text(dc, layout, center, top, font, state.time, Graphics.TEXT_JUSTIFY_CENTER);
        }
        if (seconds == null) {
            return null;
        }
        var x = center + dc.getTextWidthInPixels(state.time, font) / 2 + layout.stackGap() * 2;
        // Widest two digits, so the partial-update clip box never cuts one off.
        var width = dc.getTextWidthInPixels("88", Graphics.FONT_XTINY);
        var zeros = dc.getTextWidthInPixels("00", Graphics.FONT_XTINY);
        width = zeros > width ? zeros : width;
        var height = dc.getFontHeight(Graphics.FONT_XTINY);
        // On the digits' baseline, but never so low that it reaches the row
        // below: on a small screen the time's box already ends close to it.
        var y = top + Graphics.getFontAscent(font) - Graphics.getFontAscent(Graphics.FONT_XTINY);
        var floor = (empty ? layout.missionTop : layout.underTimeTop) - layout.stackGap() - height;
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

    // Nothing under the time (no streak yet, no temperature: always so in Free on its first days): the time moves down
    // half that row, so no empty band sits between it and the missions (design critique 2026-10-05, ROADMAP 13.9).
    // Round screens only; beside the Instinct's window the time keeps its band.
    static function underTimeEmpty(layout as HeroFaceLayout, state as HeroFaceState) as Boolean {
        return layout.subscreen() == null && state.streakLines.size() == 0 && state.temperature == null;
    }
}
