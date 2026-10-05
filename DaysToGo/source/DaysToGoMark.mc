import Toybox.Graphics;
import Toybox.Lang;

// Small marks drawn from primitives in front of a word, so a row says what it is without a word in 15 languages
// (ROADMAP 13.3, 13.4): an arrow before the event's date while it is ahead, a battery or a pair of footprints
// before the bottom line. A row is a list of parts, each a String (drawn in the row's font) or a mark id.
class DaysToGoMark {

    // Like DaysToGoDraw.line, for rows of parts: the largest font and longest candidate (longest first) that fits.
    // Nothing fits: the last candidate's words alone, through DaysToGoDraw.line, which cuts them short with "...".
    static function line(dc as Graphics.Dc, layout as DaysToGoLayout, radius as Number, top as Number, bandHeight as Number,
                         fonts as Array<Graphics.FontDefinition>, candidates as Array<Array<Object>>) as Void {
        for (var f = 0; f < fonts.size(); f++) {
            var height = dc.getFontHeight(fonts[f]);
            var y = top + (bandHeight - height) / 2;
            var room = layout.rightInsetWithin(radius, y, height) - layout.leftInsetWithin(radius, y, height);
            for (var c = 0; c < candidates.size(); c++) {
                var width = widthOf(dc, fonts[f], candidates[c]);
                if (height <= bandHeight && width <= room) {
                    drawParts(dc, layout, layout.rowCenterX(y, height) - width / 2, y, fonts[f], candidates[c]);
                    return;
                }
            }
        }
        var last = candidates[candidates.size() - 1];
        var words = "";
        for (var i = 0; i < last.size(); i++) {
            words += last[i] instanceof String ? last[i] as String : "";
        }
        DaysToGoDraw.line(dc, layout, radius, top, bandHeight, fonts, [words] as Array<String>, 0);
    }

    private static function widthOf(dc as Graphics.Dc, font as Graphics.FontDefinition, parts as Array<Object>) as Number {
        var size = sizeFor(dc, font);
        var width = 0;
        for (var i = 0; i < parts.size(); i++) {
            width += parts[i] instanceof String ? dc.getTextWidthInPixels(parts[i] as String, font) : markWidth(parts[i] as Number, size);
        }
        return width;
    }

    private static function drawParts(dc as Graphics.Dc, layout as DaysToGoLayout, left as Number, y as Number,
                                      font as Graphics.FontDefinition, parts as Array<Object>) as Void {
        var size = sizeFor(dc, font);
        var centerY = y + dc.getFontHeight(font) * DaysToGoType.MARK_CENTER_PERMILLE / DaysToGoConfig.PERMILLE;
        var x = left;
        for (var i = 0; i < parts.size(); i++) {
            if (parts[i] instanceof String) {
                var width = dc.getTextWidthInPixels(parts[i] as String, font);
                DaysToGoDraw.text(dc, layout, x + width / 2, y, font, parts[i] as String, Graphics.TEXT_JUSTIFY_CENTER);
                x += width;
            } else {
                var kind = parts[i] as Number;
                drawMark(dc, kind, x, centerY, size);
                DaysToGoDraw.box(layout, x, centerY - size / 2, markWidth(kind, size) - gap(size), size, "mark" + kind);
                x += markWidth(kind, size);
            }
        }
    }

    // The mark's height: a share of the row's font, the size of its capitals.
    private static function sizeFor(dc as Graphics.Dc, font as Graphics.FontDefinition) as Number {
        var size = dc.getFontHeight(font) * DaysToGoType.MARK_SIZE_PERMILLE / DaysToGoConfig.PERMILLE;
        return size < DaysToGoType.MARK_MIN_PX ? DaysToGoType.MARK_MIN_PX : size;
    }

    private static function gap(size as Number) as Number {
        return size * DaysToGoType.MARK_GAP_PERMILLE / DaysToGoConfig.PERMILLE + 1;
    }

    // Ink width plus the gap after it.
    private static function markWidth(kind as Number, size as Number) as Number {
        var ink = kind == DaysToGoConfig.MARK_BATTERY ? size * 3 / 2 : size;
        return ink + gap(size);
    }

    private static function drawMark(dc as Graphics.Dc, kind as Number, x as Number, cy as Number, s as Number) as Void {
        var pen = s / DaysToGoType.MARK_PEN_DIVISOR;
        dc.setPenWidth(pen < 1 ? 1 : pen);
        if (kind == DaysToGoConfig.MARK_ARROW) {
            var head = s / 2;
            dc.drawLine(x, cy, x + s, cy);
            dc.fillPolygon([[x + s, cy], [x + s - head, cy - head], [x + s - head, cy + head]] as Array<[Numeric, Numeric]>);
        } else if (kind == DaysToGoConfig.MARK_BATTERY) {
            var body = s * 4 / 3;
            var h = s * 3 / 4;
            dc.drawRectangle(x, cy - h / 2, body, h);
            dc.fillRectangle(x + body, cy - h / 4, s / 6 + 1, h / 2);
        } else if (kind == DaysToGoConfig.MARK_STEPS) {
            footprint(dc, x + s / 4, cy + s / 8, s);
            footprint(dc, x + s * 3 / 4, cy - s / 8, s);
        }
        dc.setPenWidth(1);
    }

    // One footprint centred on (cx, cy): a sole above a separate heel, so two of them read as steps, not dots.
    private static function footprint(dc as Graphics.Dc, cx as Number, cy as Number, s as Number) as Void {
        var rx = s / 6 + 1;
        dc.fillEllipse(cx, cy - s / 8, rx, s / 4 + 1);
        dc.fillCircle(cx, cy + s / 4 + 1, s / 9 + 1);
    }
}
