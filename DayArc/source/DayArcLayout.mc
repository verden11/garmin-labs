import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// Geometry, measured once per display, off the shorter screen side (TwoSuns's own proven pattern,
// reused: `contentRadius`/chord-inset math validated across all 69 products in that project's fit
// sweep). A rectangular AMOLED product (Venu Sq 2, Venu X1) gets the same round-centred content,
// shorter side sets the scale, extra width becomes side margin — deliberate, not a bug, same as
// TwoSuns ADR-009.
class DayArcLayout {
    private static const PERMILLE = 1000;
    static const CLOCK_MAX_PERMILLE = 200;
    private static const TOP_MARGIN_PERMILLE = 60;
    private static const BOTTOM_MARGIN_PERMILLE = 60;
    private static const ROW_GAP_PERMILLE = 18;
    private static const SIDE_MARGIN_PERMILLE = 20;
    static const GRID_COLUMNS = 2;

    // Window-progress arc (ADR-013): drawn just inside the bezel, thin enough to read as a hairline
    // accent, not a ring competing with the clock/hero for attention. Its radius is DERIVED (see
    // arcRadius()) from the clock's own start margin, not an independent inset — watch-design-
    // reviewer, 2026-09-28, found the arc and the clock's top margin were picked independently with
    // no cross-check and could overlap on a round display (fr965: arc at y=36-44, clock starting at
    // y=27 with a 128px-tall font reaching to y=155). ARC_CLOCK_GAP_PERMILLE is the one genuinely
    // independent choice left: how much visible daylight to leave between the two.
    private static const ARC_WIDTH_PERMILLE = 18;
    private static const ARC_CLOCK_GAP_PERMILLE = 10;

    // Pro's hero/grid divider (ADR-013): a hairline, not a rule heavy enough to read as its own row.
    private static const DIVIDER_WIDTH_PERMILLE = 400;

    // Icon bitmaps (ADR-013) are fixed-pixel resources, not runtime-scaled (DESIGN.md
    // "Implementation note" — plain dc.drawBitmap, no :tintColor/drawBitmap2, sidesteps the
    // FR165/165m tint bug by not tinting at all). GRID_ICON_SIZE must match the pixel size baked
    // into resources-pro/drawables/icons/grid_*.svg at generation time.
    static const GRID_ICON_SIZE = 22;
    private static const HERO_ICON_GAP_PERMILLE = 20;
    private static const GRID_ICON_GAP_PERMILLE = 10;

    // Grid cell layout (DESIGN.md "Layout": "each cell reserves a measured share for its label,
    // capped at 55% of the column"; watch-design-reviewer, 2026-09-28: this ratio and the value/
    // label gap were bare literals in DayArcDraw, against this file's own "no magic numbers" rule).
    private static const GRID_LABEL_MAX_PERMILLE = 550;
    private static const GRID_VALUE_GAP_PERMILLE = 9; // ~4px on fr965's 454px display

    static const CLOCK_FONTS = [Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Array<Graphics.FontDefinition>;
    static const HERO_FONTS = [Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Array<Graphics.FontDefinition>;
    static const LABEL_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const SUB_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const CELL_FONT = Graphics.FONT_XTINY;

    private var _width as Number;
    private var _height as Number;
    private var _d as Number;
    private var _radius as Number;

    function initialize(dc as Graphics.Dc) {
        _width = dc.getWidth();
        _height = dc.getHeight();
        _d = _width < _height ? _width : _height;
        _radius = _d / 2;
    }

    function width() as Number {
        return _width;
    }

    function height() as Number {
        return _height;
    }

    function centerX() as Number {
        return _width / 2;
    }

    function centerY() as Number {
        return _height / 2;
    }

    // Radius of the inscribed circle every centred element is already measured against (the
    // rectangular-product convention above) — same circle the arc is drawn just inside of.
    function radius() as Number {
        return _radius;
    }

    // How far the inscribed circle's own top edge sits below the screen's actual top (0 for a
    // round/square display; positive slack for a taller-than-wide rectangle like Venu Sq 2/X1,
    // where _d is the WIDTH but centerY is half the taller HEIGHT). topMargin()/gridBottom() both
    // measure from these edges, not from y=0/_height directly — watch-design-reviewer, 2026-09-28:
    // measuring from y=0 let the clock row's farthestDy exceed the circle's own radius on Venu Sq 2
    // (320x360: topMargin=19 landed 1px above the circle's actual top edge at y=20), making
    // chordHalfWidth's guard return 0 and rowMaxWidth go negative for an otherwise valid row.
    private function circleTop() as Number {
        return centerY() - _radius;
    }

    private function circleBottomSlack() as Number {
        return _height - (centerY() + _radius);
    }

    // Derived from the clock's own start margin, not an independent inset (see the field comment
    // above ARC_CLOCK_GAP_PERMILLE): the arc's outer edge must clear the clock's very first pixel
    // row by at least ARC_CLOCK_GAP_PERMILLE, regardless of how tall the clock font itself measures.
    function arcRadius() as Number {
        return radius() - permille(TOP_MARGIN_PERMILLE) + arcPenWidth() / 2 + permille(ARC_CLOCK_GAP_PERMILLE);
    }

    function arcPenWidth() as Number {
        return permille(ARC_WIDTH_PERMILLE);
    }

    // Dc.drawArc's own convention: 0=3 o'clock, 90=12 o'clock, counter-clockwise positive. The full
    // track spans ARC_SPAN_DEGREES centred on 90 (top); the progress fill shrinks from the start
    // edge toward the end edge as `fraction` (0..1) grows.
    function arcTrackStartDegrees() as Number {
        return 90 + DayArcConfig.ARC_SPAN_DEGREES / 2;
    }

    function arcTrackEndDegrees() as Number {
        return 90 - DayArcConfig.ARC_SPAN_DEGREES / 2;
    }

    // Rounds toward arcTrackStartDegrees() at fraction 0 — Dc.drawArc treats equal start/end
    // degrees as a full circle (SDK docs), so DayArcDraw must skip drawing when this returns the
    // same value as arcTrackStartDegrees(), not draw a zero-length arc.
    function arcProgressEndDegrees(fraction as Float) as Number {
        var clamped = fraction < 0.0 ? 0.0 : (fraction > 1.0 ? 1.0 : fraction);
        return arcTrackStartDegrees() - (DayArcConfig.ARC_SPAN_DEGREES * clamped).toNumber();
    }

    function dividerWidth(y as Number) as Number {
        return rowMaxWidth(y, 1) * DIVIDER_WIDTH_PERMILLE / PERMILLE;
    }

    function heroIconGap() as Number {
        return permille(HERO_ICON_GAP_PERMILLE);
    }

    function gridIconGap() as Number {
        return permille(GRID_ICON_GAP_PERMILLE);
    }

    // Row height for a grid that carries icons: tall enough for whichever is taller, the cell font
    // or a grid icon, so two icon-carrying rows never overlap (the fixed-pixel icon can be taller
    // than FONT_XTINY on a small screen where permille shrinks everything else but not the icon).
    function gridRowHeight(dc as Graphics.Dc) as Number {
        var fontHeight = dc.getFontHeight(CELL_FONT);
        var tallest = fontHeight > GRID_ICON_SIZE ? fontHeight : GRID_ICON_SIZE;
        return tallest + rowGap();
    }

    function leftInset(y as Number, boxHeight as Number) as Number {
        return centerX() - chordHalfWidth(_radius, farthestDy(y, boxHeight));
    }

    function rightInset(y as Number, boxHeight as Number) as Number {
        return centerX() + chordHalfWidth(_radius, farthestDy(y, boxHeight));
    }

    // The real chord width at this row, minus a small side margin — for every centred text row,
    // not just the grid (watch-design-reviewer, 2026-09-28: the active/idle frames used to fall
    // back to a flat `width() - margin` for everything but the grid, contradicting DESIGN.md's own
    // "width-fit against the round chord" claim and understating the true clip risk near the top of
    // a round display).
    function rowMaxWidth(y as Number, boxHeight as Number) as Number {
        return rightInset(y, boxHeight) - leftInset(y, boxHeight) - 2 * permille(SIDE_MARGIN_PERMILLE);
    }

    private function farthestDy(y as Number, boxHeight as Number) as Number {
        var dyTop = y - centerY();
        var dyBottom = y + boxHeight - centerY();
        return dyTop.abs() > dyBottom.abs() ? dyTop : dyBottom;
    }

    static function chordHalfWidth(radius as Number, dy as Number) as Number {
        var inside = radius * radius - dy * dy;
        if (inside <= 0) {
            return 0;
        }
        return Math.sqrt(inside).toNumber();
    }

    function permille(value as Number) as Number {
        return _d * value / PERMILLE;
    }

    function driftStep() as Number {
        return permille(DayArcConfig.BURN_IN_STEP_PERMILLE);
    }

    function topMargin() as Number {
        return circleTop() + permille(TOP_MARGIN_PERMILLE);
    }

    function rowGap() as Number {
        return permille(ROW_GAP_PERMILLE);
    }

    // Everything below the sub line, down to the bottom margin: where Pro's grid lives. Empty (top
    // == bottom) when nothing fits, which DayArcDraw treats as "no grid," not an error.
    function gridTop(dc as Graphics.Dc, subBottom as Number) as Number {
        return subBottom + rowGap();
    }

    function gridBottom() as Number {
        return _height - circleBottomSlack() - permille(BOTTOM_MARGIN_PERMILLE);
    }

    // One grid row's column width, from THIS row's own chord (not the narrowest row's): rows near
    // the vertical centre are wider than rows near the bezel. DayArcGrid decides how many rows fit.
    function gridRowColumnWidth(rowTop as Number, rowHeight as Number) as Number {
        return rowMaxWidth(rowTop, rowHeight) / GRID_COLUMNS;
    }

    // DESIGN.md "Layout": a cell's label is capped at this share of its remaining column width
    // (after any icon reservation), so the value always keeps a legible minimum.
    function gridLabelMaxWidth(remainingColumnWidth as Number) as Number {
        return remainingColumnWidth * GRID_LABEL_MAX_PERMILLE / PERMILLE;
    }

    function gridValueGap() as Number {
        return permille(GRID_VALUE_GAP_PERMILLE);
    }
}
