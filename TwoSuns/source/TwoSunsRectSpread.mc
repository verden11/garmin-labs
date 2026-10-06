import Toybox.Graphics;
import Toybox.Lang;

// A rectangle's awake rows, spread over the inner box (docs/decisions.md ADR-028, the rectangle track). The round stack is
// centred with one small gap between font boxes, but a number font's box is mostly empty above and below its digits, so
// on a rectangle the time looked far from the row under it while the rows below it huddled together. Here the slack of the
// box is shared out so the visible gaps are even: the time's empty band under its baseline (its descent; digits have
// none) and an equal band above are not counted as gap. Font boxes never overlap: each gap is at least the round gap.
// The battery strip, when the battery row is kept, comes off the top of the box first.
class TwoSunsRectSpread {

    static function spread(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, centred as TwoSunsRows) as TwoSunsRows {
        var heights = [frame.dateHeight(dc), dc.getFontHeight(frame.timeFont), frame.weatherHeight, frame.bandHeight, frame.lineHeight(dc)] as Array<Number>;
        var pads = [0, timePad(dc, frame.timeFont, heights[1]), 0, 0, 0] as Array<Number>;
        var top = layout.centerY() - layout.spanHeight() / 2 + frame.batteryStrip;
        var bottom = layout.centerY() + layout.spanHeight() / 2;
        var visible = 0;
        var count = 0;
        for (var i = 0; i < heights.size(); i++) {
            if (heights[i] > 0) {
                visible += heights[i] - 2 * pads[i];
                count++;
            }
        }
        var gap = (bottom - top - visible) / (count + 1);
        if (gap > layout.gap()) {
            var tops = place(heights, pads, top, gap, layout.gap());
            if (tops[tops.size() - 1] <= bottom) {
                return toRows(heights, tops);
            }
        }
        return shifted(centred, frame.batteryStrip / 2);   // no slack worth sharing: the centred stack, below the strip
    }

    private static function shifted(rows as TwoSunsRows, dy as Number) as TwoSunsRows {
        rows.dateTop += dy;
        rows.timeTop += dy;
        rows.weatherTop += dy;
        rows.bandTop += dy;
        rows.lineTop += dy;
        return rows;
    }

    // Each present row's top, then (last) where the stack ends.
    private static function place(heights as Array<Number>, pads as Array<Number>, top as Number, gap as Number, minGap as Number) as Array<Number> {
        var tops = [] as Array<Number>;
        var y = top + gap;
        var end = top;
        for (var i = 0; i < heights.size(); i++) {
            if (heights[i] <= 0) {
                tops.add(0);
                continue;
            }
            var at = y - pads[i];
            at = at < end + minGap && end > top ? end + minGap : at;
            tops.add(at);
            end = at + heights[i];
            y = end - pads[i] + gap;
        }
        tops.add(end);
        return tops;
    }

    private static function toRows(heights as Array<Number>, tops as Array<Number>) as TwoSunsRows {
        var rows = new TwoSunsRows();
        rows.dateTop = tops[0];
        rows.timeTop = tops[1];
        rows.weatherTop = tops[2];
        rows.bandTop = tops[3];
        rows.lineTop = tops[4];
        return rows;
    }

    // The empty band under the time's digits (the font's descent), never more than a quarter of its box.
    private static function timePad(dc as Graphics.Dc, font as Graphics.FontDefinition, height as Number) as Number {
        var descent = Graphics.getFontDescent(font);
        return descent < height / 4 ? descent : height / 4;
    }
}
