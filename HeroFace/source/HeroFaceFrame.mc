import Toybox.Graphics;
import Toybox.Lang;

// The rectangle family's geometry (ADR-005: Venu Sq, Sq 2, X1). The ring becomes an open-bottom rounded rectangle along
// the screen's edges, rows fit inside it, and the time is sized and placed by its digits' ink rather than its font box:
// a number font's box carries a third of empty headroom and descent, which on a rectangle left a hole under a small time.
// Round and Instinct products never build one (HeroFaceLayout.frame() is null there).
class HeroFaceFrame {

    // A quarter circle is pi/2 of its radius long.
    private static const QUARTER_ARC_PERMILLE = 1571;
    // Digits fill about this share of a number font's ascent, and a time has nothing below the baseline. Measured off
    // simulator screenshots on 2026-10-05: 0.68 on venusq and venusq2, 0.69 on venux1 (DayArc's DIGIT_HEIGHT_PERMILLE
    // is the same 720). Rounded up so the box the fit test checks always covers the ink.
    private static const DIGIT_HEIGHT_PERMILLE = 720;
    private static const TIME_SAMPLE = "00:00";

    private var _width as Number;
    private var _height as Number;
    private var _edge as Number;
    private var _radius as Number;
    private var _pad as Number;

    // The centreline sits a quarter inset in from the glass (a visible margin, about 8 px at 448); each corner is a
    // quarter circle centred 1.5 insets in from both edges. The Venu X1's glass corner measures about 68 px (1.55
    // insets) off its device skin, so the frame runs nearly concentric with it and the margin stays even round the
    // corner. The Venu Sq / Sq 2 glass is almost square (about 7 px); there the round corner is the design's own.
    function initialize(width as Number, height as Number, inset as Number, ringWidth as Number, textMargin as Number) {
        _width = width;
        _height = height;
        _edge = inset / 4;
        _radius = inset * 3 / 2 - _edge;
        _pad = ringWidth / 2 + textMargin / 2;
    }

    // The centreline: [left x, top y, right x, y where the sides' straight runs end, corner radius]. The bottom edge
    // is the open gap where the footer lives.
    function box() as [Number, Number, Number, Number, Number] {
        return [_edge, _edge, _width - _edge, _height - _edge - _radius, _radius];
    }

    // Length in px: two sides, two top corners (a quarter circle each), the top.
    function length() as Number {
        var b = box();
        return 2 * (b[3] - b[1] - b[4]) + 2 * quarterArc(b[4]) + (b[2] - b[0] - 2 * b[4]);
    }

    static function quarterArc(radius as Number) as Number {
        return radius * QUARTER_ARC_PERMILLE / 1000;
    }

    // Px to fill for a 0-1000 share of the path's length: any progress shows a pixel, a full share the whole path.
    function fillFor(permille as Number) as Number {
        if (permille <= 0) {
            return 0;
        }
        var all = length();
        if (permille >= 1000) {
            return all;
        }
        var fill = all * permille / 1000;
        return fill < 1 ? 1 : fill;
    }

    // A row's side inset: half the ring width plus half the text margin inside the centreline, and inside a rounded
    // corner at all four corners (the X1's glass is rounded at the bottom too, where the frame is open).
    function inset(y as Number, height as Number) as Number {
        var edge = _edge + _pad;
        var radius = _radius - _pad;
        var dyTop = edge + radius - y;
        var dyBottom = y + height - (_height - edge - radius);
        var dy = dyTop > dyBottom ? dyTop : dyBottom;
        return dy > 0 ? edge + radius - HeroFaceLayout.chordHalfWidth(radius, dy) : edge;
    }

    // Px of a number font's digits, from the baseline up.
    static function inkHeight(font as Graphics.FontDefinition) as Number {
        return Graphics.getFontAscent(font) * DIGIT_HEIGHT_PERMILLE / 1000;
    }

    // The round stack's order (date, time, streak and temperature, missions, footer in the open bottom) with half-inset
    // top and bottom margins (no chord to clear). The time takes the largest font whose ink fits the band and whose
    // widest time fits the frame; what height is left is shared evenly by the three gaps around the time and above the
    // footer, so the stack is balanced instead of leaving a hole under the time.
    function stack(dc as Graphics.Dc, layout as HeroFaceLayout) as Void {
        var line = dc.getFontHeight(Graphics.FONT_XTINY);
        var gap = layout.stackGap();
        var margin = layout.shortInset() / 2;
        var missions = layout.missionHeight(dc);
        layout.footerTop = _height - margin - line;
        var underTop = layout.footerTop - gap * 3 - missions - line;
        layout.topRowTop = margin + layout.ringWidth();
        var bandTop = layout.topRowTop + line;
        layout.timeFont = pickTimeFont(dc, bandTop, underTop, gap, 0);
        // Pro's seconds sit right of the time on its baseline and the time stays centred, so with seconds on the time
        // keeps their width free on both sides (HeroFaceClock picks this font only while seconds are drawn).
        var eights = dc.getTextWidthInPixels("88", Graphics.FONT_XTINY);
        var zeros = dc.getTextWidthInPixels("00", Graphics.FONT_XTINY);
        layout.secondsTimeFont = pickTimeFont(dc, bandTop, underTop, gap, 2 * (gap * 2 + (eights > zeros ? eights : zeros)));
        var share = (underTop - bandTop - inkHeight(layout.timeFont)) / 3;
        layout.underTimeTop = underTop - share;
        layout.missionTop = layout.underTimeTop + line + gap;
        layout.timeTop = inkTopFor(layout.timeFont, bandTop + share);
        var secondsInk = inkHeight(layout.secondsTimeFont);
        layout.secondsTimeTop = inkTopFor(layout.secondsTimeFont, bandTop + (layout.underTimeTop - bandTop - secondsInk) / 2);
        layout.columnLeft = inset(layout.missionTop, missions);
        layout.columnWidth = (_width - 2 * layout.columnLeft - layout.columnGap() * 2) / 3;
    }

    // The font-box top that puts the digits' ink top at `inkTop`.
    private static function inkTopFor(font as Graphics.FontDefinition, inkTop as Number) as Number {
        return inkTop - Graphics.getFontAscent(font) + inkHeight(font);
    }

    // Largest number font whose ink leaves a stack gap above and below it in the band and whose widest time, plus
    // `reserve`, fits the frame's inside at that height.
    private function pickTimeFont(dc as Graphics.Dc, top as Number, bottom as Number, gap as Number, reserve as Number) as Graphics.FontDefinition {
        var fonts = [Graphics.FONT_NUMBER_THAI_HOT, Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM] as Array<Graphics.FontDefinition>;
        for (var i = 0; i < fonts.size(); i++) {
            var ink = inkHeight(fonts[i]);
            var y = top + (bottom - top - ink) / 2;
            var room = _width - 2 * inset(y, ink) - reserve;
            if (ink <= bottom - top - 2 * gap && dc.getTextWidthInPixels(TIME_SAMPLE, fonts[i]) <= room) {
                return fonts[i];
            }
        }
        return Graphics.FONT_NUMBER_MILD;
    }
}
