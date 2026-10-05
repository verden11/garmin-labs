import Toybox.Graphics;
import Toybox.Lang;

// Mission icons drawn from primitives in place of a clipped word: footprints for steps, a flame for calories, a
// pulse line for intensity minutes, stairs for floors (design critique 2026-10-05, ROADMAP 13.11: "INT" and "FLR" were the words
// that fit a third of the screen). Distance (KM/MI), MOVE and HeroSet's three exercises keep their words.
class HeroFaceIcon {

    static function drawsFor(kind as Number) as Boolean {
        return kind == HeroFaceConfig.STEPS || kind == HeroFaceConfig.CALORIES || kind == HeroFaceConfig.INTENSITY
            || kind == HeroFaceConfig.FLOORS;
    }

    // The icon's height: the label font's capital height, so it sits where the word sat.
    static function size() as Number {
        return Graphics.getFontAscent(Graphics.FONT_XTINY) * HeroFaceLayout.ICON_SIZE_PERMILLE / 1000;
    }

    static function width(kind as Number, s as Number) as Number {
        return kind == HeroFaceConfig.CALORIES ? s * 3 / 4 : s;
    }

    // Draws the icon with its box's top-left at (x, top), in the colour already set.
    static function draw(dc as Graphics.Dc, kind as Number, x as Number, top as Number, s as Number) as Void {
        var pen = s / 6 > 1 ? s / 6 : 2;
        dc.setPenWidth(pen);
        if (kind == HeroFaceConfig.STEPS) {
            footprint(dc, x + s / 4, top + s * 9 / 16, s);
            footprint(dc, x + s * 3 / 4, top + s * 7 / 16, s);
        } else if (kind == HeroFaceConfig.CALORIES) {
            var w = s * 3 / 4;
            dc.fillPolygon(points(x, top, w, s, [[50, 0], [92, 52], [86, 82], [50, 100], [14, 82], [8, 52], [32, 30], [40, 52]]));
        } else if (kind == HeroFaceConfig.INTENSITY) {
            // A pulse line, not a bolt: across the studio the bolt means Body Battery (Two Suns, DayArc; ROADMAP 13.19).
            var p = points(x, top, s, s, [[0, 55], [28, 55], [42, 10], [62, 95], [76, 55], [100, 55]]);
            for (var i = 0; i < p.size() - 1; i++) {
                dc.drawLine(p[i][0], p[i][1], p[i + 1][0], p[i + 1][1]);
            }
        } else {
            // Three steps rising to the right, drawn as one stroke.
            var step = s / 3;
            var y = top + s - pen / 2;
            var cx = x;
            for (var i = 0; i < 3; i++) {
                dc.drawLine(cx, y, cx + step, y);
                dc.drawLine(cx + step, y, cx + step, y - step);
                cx += step;
                y -= step;
            }
        }
        dc.setPenWidth(1);
    }

    // A shape given in hundredths of its box, placed at (x, top) and scaled to w by h.
    private static function points(x as Number, top as Number, w as Number, h as Number, shape as Array<Array<Number>>) as Array<[Numeric, Numeric]> {
        var result = [] as Array<[Numeric, Numeric]>;
        for (var i = 0; i < shape.size(); i++) {
            result.add([x + shape[i][0] * w / 100, top + shape[i][1] * h / 100]);
        }
        return result;
    }

    // One footprint centred on (cx, cy): a sole above a separate heel.
    private static function footprint(dc as Graphics.Dc, cx as Number, cy as Number, s as Number) as Void {
        var rx = s / 7 + 1;
        dc.fillEllipse(cx, cy - s / 8, rx, s / 4);
        dc.fillCircle(cx, cy + s / 4, s / 9 + 1);
    }
}
