import Toybox.Graphics;
import Toybox.Lang;

// A rectangle's awake rows, spread over the inner box (docs/decisions.md ADR-028, the rectangle track). The round stack is
// centred with one small gap between font boxes, but a number font's box is mostly empty above and below its digits, so
// on a rectangle the rows looked unevenly spaced. Here every visible gap is the same, the top and bottom margins included,
// and never less than the band gap: the time is placed by its digits (its font box less its descent, the empty band under
// the baseline, and as much above), so its empty bands may lie over a margin or a neighbour's gap but its digits never
// do. Places depend only on the rows' heights, never on which wording a sentence takes. A stack that cannot be spread so
// is null, and the centred round stack stands. The battery strip, when kept, comes off the top of the box first.
class TwoSunsRectSpread {

    // The rows for these fonts and this weather row height, below a `strip` px battery strip; null when they do not fit.
    static function rowsFor(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, time as Graphics.FontDefinition,
                            value as Graphics.FontDefinition, weatherH as Number, strip as Number) as TwoSunsRows? {
        var timeH = dc.getFontHeight(time);
        var heights = [frame.dateHeight(dc), timeH, weatherH, bandHeightFor(dc, layout, frame, value), frame.lineHeight(dc)] as Array<Number>;
        var pads = [0, timePad(time, timeH), 0, 0, 0] as Array<Number>;
        var top = layout.centerY() - layout.spanHeight() / 2 + strip;
        var tops = place(heights, pads, top, layout.centerY() + layout.spanHeight() / 2, layout.bandGap());
        if (tops == null) {
            return null;
        }
        var rows = new TwoSunsRows();
        rows.dateTop = tops[0];
        rows.timeTop = tops[1];
        rows.weatherTop = tops[2];
        rows.bandTop = tops[3];
        rows.lineTop = tops[4];
        return rows;
    }

    // Font box tops (0 for an absent row, height 0) between `top` and `bottom` with every visible gap the same, margins
    // included; `pads` is each box's empty band at its top and at its bottom. Null when that gap would be under `minGap`.
    static function place(heights as Array<Number>, pads as Array<Number>, top as Number, bottom as Number, minGap as Number) as Array<Number>? {
        var visible = 0;
        var count = 0;
        for (var i = 0; i < heights.size(); i++) {
            if (heights[i] > 0) {
                visible += heights[i] - 2 * pads[i];
                count++;
            }
        }
        var gap = count == 0 ? -1 : (bottom - top - visible) / (count + 1);
        if (gap < minGap) {
            return null;
        }
        var tops = [] as Array<Number>;
        var inkBottom = top;
        for (var i = 0; i < heights.size(); i++) {
            if (heights[i] <= 0) {
                tops.add(0);
                continue;
            }
            tops.add(inkBottom + gap - pads[i]);
            inkBottom += gap + heights[i] - 2 * pads[i];
        }
        return tops;
    }

    // The Body Battery band's height with this value font: the value, or the curve's when it is drawn and taller.
    static function bandHeightFor(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, value as Graphics.FontDefinition) as Number {
        var valueH = dc.getFontHeight(value);
        var curveH = layout.capFor(TwoSunsLayout.CURVE_BAND_PERMILLE);
        return frame.showCurve && curveH > valueH ? curveH : valueH;
    }

    // The empty band under the time's digits (the font's descent), never more than a quarter of its box; as much is
    // taken to be empty above them.
    static function timePad(font as Graphics.FontDefinition, height as Number) as Number {
        var descent = Graphics.getFontDescent(font);
        return descent < height / 4 ? descent : height / 4;
    }
}
