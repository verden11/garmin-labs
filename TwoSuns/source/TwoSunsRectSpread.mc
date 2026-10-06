import Toybox.Graphics;
import Toybox.Lang;

// A rectangle's awake rows, spread over the inner box (docs/decisions.md ADR-028, the rectangle track). The round stack is
// centred with one small gap between font boxes, but a number font's box is mostly empty above and below its digits, so
// on a rectangle the time looked far from the row under it while the rows below it huddled together. The time keeps its
// centred place (where its width was measured); the rows below it share out the room between the time's digits and the
// bottom of the box so the visible gaps are even, and so does the date above it. The time's empty band under its baseline
// (its descent; digits have none) and an equal band above are not counted as gap. Font boxes never overlap: each gap is at
// least the round gap. The battery strip, when the battery row is kept, comes off the top of the box first.
class TwoSunsRectSpread {

    static function spread(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, centred as TwoSunsRows) as TwoSunsRows {
        var rows = shifted(centred, frame.batteryStrip / 2);
        var timeH = dc.getFontHeight(frame.timeFont);
        var pad = timePad(frame.timeFont, timeH);
        var boxTop = layout.centerY() - layout.spanHeight() / 2 + frame.batteryStrip;
        var boxBottom = layout.centerY() + layout.spanHeight() / 2;
        var below = place([frame.weatherHeight, frame.bandHeight, frame.lineHeight(dc)] as Array<Number>,
                          rows.timeTop + timeH - pad, rows.timeTop + timeH, boxBottom, layout.gap());
        if (below != null && lineKeepsItsWording(dc, layout, frame, rows.lineTop, below[2])) {
            rows.weatherTop = below[0];
            rows.bandTop = below[1];
            rows.lineTop = below[2];
        }
        var above = place([frame.dateHeight(dc)] as Array<Number>, boxTop, boxTop, rows.timeTop + pad, layout.gap());
        if (above != null && above[0] + frame.dateHeight(dc) + layout.gap() <= rows.timeTop) {
            rows.dateTop = above[0];
        }
        return rows;
    }

    // Tops for the present rows (height > 0) between the visible edge `from` and `to`, with even gaps; the first top is never
    // above `firstMin` plus the round gap. Null when there is no row, or no room to do better than the centred stack.
    private static function place(heights as Array<Number>, from as Number, firstMin as Number, to as Number, minGap as Number) as Array<Number>? {
        var total = 0;
        var count = 0;
        for (var i = 0; i < heights.size(); i++) {
            total += heights[i];
            count += heights[i] > 0 ? 1 : 0;
        }
        var gap = count == 0 ? 0 : (to - from - total) / (count + 1);
        if (gap < minGap) {
            return null;
        }
        var tops = [] as Array<Number>;
        var y = from + gap;
        y = y < firstMin + minGap ? firstMin + minGap : y;
        for (var i = 0; i < heights.size(); i++) {
            tops.add(heights[i] > 0 ? y : 0);
            y += heights[i] > 0 ? heights[i] + gap : 0;
        }
        return y - gap > to ? null : tops;
    }

    // Whether the sun sentence still fits its longest wording at its spread place when it did at its centred one (the box's
    // rounded corners narrow the bottom): if not, the centred places stand, so it never steps down for the sake of even gaps.
    private static function lineKeepsItsWording(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, was as Number, now as Number) as Boolean {
        var lines = frame.lineCandidates;
        var h = frame.lineHeight(dc);
        if (h <= 0 || lines.size() == 0) {
            return true;
        }
        var radius = layout.contentRadius();
        return !TwoSunsDraw.fits(dc, layout, radius, was, h, frame.lineFont, lines[0]) || TwoSunsDraw.fits(dc, layout, radius, now, h, frame.lineFont, lines[0]);
    }

    private static function shifted(rows as TwoSunsRows, dy as Number) as TwoSunsRows {
        rows.dateTop += dy;
        rows.timeTop += dy;
        rows.weatherTop += dy;
        rows.bandTop += dy;
        rows.lineTop += dy;
        return rows;
    }

    // The empty band under the time's digits (the font's descent), never more than a quarter of its box.
    private static function timePad(font as Graphics.FontDefinition, height as Number) as Number {
        var descent = Graphics.getFontDescent(font);
        return descent < height / 4 ? descent : height / 4;
    }
}
