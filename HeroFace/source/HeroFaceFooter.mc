import Toybox.Graphics;
import Toybox.Lang;

// Battery, heart rate and unread notifications in the ring's bottom gap.
// Icons are drawn from primitives (no bitmaps, no font glyphs), each with its
// number beside it; items drop from the right when the gap is too narrow.
class HeroFaceFooter {

    private static const BATTERY = 0;
    private static const HEART = 1;
    private static const NOTIFICATION = 2;

    static function draw(dc as Graphics.Dc, layout as HeroFaceLayout, state as HeroFaceState) as Void {
        var kinds = [BATTERY] as Array<Number>;
        // The icon says "battery", so the number needs no percent sign: that keeps
        // all three items inside the ring's gap on small screens.
        var texts = [state.battery.toString()] as Array<String>;
        if (state.heartRate != null) {
            kinds.add(HEART);
            texts.add((state.heartRate as Number).toString());
        }
        if (state.notifications > 0) {
            kinds.add(NOTIFICATION);
            texts.add(state.notifications.toString());
        }
        var top = layout.footerTop;
        var room = layout.rightInset(top, dc.getFontHeight(Graphics.FONT_XTINY)) - layout.leftInset(top, dc.getFontHeight(Graphics.FONT_XTINY)) - layout.textMargin();
        while (kinds.size() > 1 && totalWidth(dc, layout, texts) > room) {
            kinds = kinds.slice(0, -1);
            texts = texts.slice(0, -1);
        }
        var x = layout.centerX() - totalWidth(dc, layout, texts) / 2;
        for (var i = 0; i < kinds.size(); i++) {
            x = drawItem(dc, layout, x, top, kinds[i], texts[i], state);
        }
    }

    private static function iconSize(layout as HeroFaceLayout) as Number {
        return Graphics.getFontAscent(Graphics.FONT_XTINY) * 2 / 3;
    }

    private static function totalWidth(dc as Graphics.Dc, layout as HeroFaceLayout, texts as Array<String>) as Number {
        var width = 0;
        for (var i = 0; i < texts.size(); i++) {
            width += iconSize(layout) + layout.stackGap() + dc.getTextWidthInPixels(texts[i], Graphics.FONT_XTINY);
        }
        return width + layout.stackGap() * 3 * (texts.size() - 1);
    }

    // Returns the x where the next item starts.
    private static function drawItem(dc as Graphics.Dc, layout as HeroFaceLayout, x as Number, top as Number, kind as Number, text as String, state as HeroFaceState) as Number {
        var size = iconSize(layout);
        var baseline = top + Graphics.getFontAscent(Graphics.FONT_XTINY);
        var low = kind == BATTERY && state.battery <= HeroFaceConfig.LOW_BATTERY_PERCENT;
        dc.setColor(low ? HeroFacePalette.ALERT : HeroFacePalette.MUTED, Graphics.COLOR_TRANSPARENT);
        if (kind == BATTERY) {
            drawBattery(dc, x, baseline - size, size, state.battery);
        } else if (kind == HEART) {
            drawHeart(dc, x, baseline - size, size);
        } else {
            drawBubble(dc, x, baseline - size, size);
        }
        var textX = x + size + layout.stackGap();
        HeroFaceDraw.text(dc, layout, textX, top, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_LEFT);
        return textX + dc.getTextWidthInPixels(text, Graphics.FONT_XTINY) + layout.stackGap() * 3;
    }

    // Outline with a nub and a fill proportional to charge.
    private static function drawBattery(dc as Graphics.Dc, x as Number, y as Number, size as Number, percent as Number) as Void {
        var height = size * 3 / 5;
        var top = y + (size - height);
        var nub = size / 8 > 1 ? size / 8 : 1;
        var body = size - nub;
        dc.drawRectangle(x, top, body, height);
        dc.fillRectangle(x + body, top + height / 4, nub, height / 2);
        var inner = (body - 4) * (percent < 0 ? 0 : (percent > 100 ? 100 : percent)) / 100;
        if (inner > 0) {
            dc.fillRectangle(x + 2, top + 2, inner, height - 4);
        }
    }

    // Two circles over a triangle.
    private static function drawHeart(dc as Graphics.Dc, x as Number, y as Number, size as Number) as Void {
        var r = size / 4;
        dc.fillCircle(x + r, y + r + 1, r);
        dc.fillCircle(x + size - r, y + r + 1, r);
        dc.fillPolygon([[x, y + r + 1], [x + size, y + r + 1], [x + size / 2, y + size]] as Array<[Numeric, Numeric]>);
    }

    // Filled speech bubble: a rounded body with a tail.
    private static function drawBubble(dc as Graphics.Dc, x as Number, y as Number, size as Number) as Void {
        var body = size * 3 / 4;
        dc.fillRoundedRectangle(x, y, size, body, size / 5);
        dc.fillPolygon([[x + size / 5, y + body - 1], [x + size / 2, y + body - 1], [x + size / 5, y + size]] as Array<[Numeric, Numeric]>);
    }
}
