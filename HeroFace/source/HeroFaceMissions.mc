import Toybox.Graphics;
import Toybox.Lang;

// Three mission columns under the time: value, HeroSet's pill bar, label.
// Bar length carries the glance; a finished goal also turns its label green
// and adds a drawn check, so "done" never depends on colour alone.
class HeroFaceMissions {

    static function draw(dc as Graphics.Dc, layout as HeroFaceLayout, state as HeroFaceState) as Void {
        var metrics = state.metrics;
        var step = layout.columnWidth + layout.columnGap();
        for (var i = 0; i < metrics.size(); i++) {
            drawColumn(dc, layout, layout.columnLeft + step * i, metrics[i], state.accent);
        }
    }

    private static function drawColumn(dc as Graphics.Dc, layout as HeroFaceLayout, left as Number, metric as HeroFaceMetric, accent as Number) as Void {
        var width = layout.columnWidth;
        var center = left + width / 2;
        var line = dc.getFontHeight(Graphics.FONT_XTINY);
        var gap = layout.stackGap();
        var top = layout.missionTop;
        var value = HeroFaceDraw.firstWithin(dc, width, Graphics.FONT_XTINY, HeroFaceText.values(metric));
        if (layout.subscreen() != null) {
            value = HeroFaceDraw.truncated(dc, value, Graphics.FONT_XTINY, width);
        }
        if (value.length() > 0) {
            dc.setColor(metric.isAlert() ? HeroFacePalette.ALERT : HeroFacePalette.TEXT, Graphics.COLOR_TRANSPARENT);
            var valueWidth = dc.getTextWidthInPixels(value, Graphics.FONT_XTINY);
            HeroFaceDraw.text(dc, layout, inside(dc, layout, center - valueWidth / 2, valueWidth, top), top, Graphics.FONT_XTINY, value, Graphics.TEXT_JUSTIFY_LEFT);
        }
        var barTop = top + line + gap;
        if (metric.hasBar()) {
            drawBar(dc, left, barTop, width, layout.barHeight(), metric, accent);
        }
        drawLabel(dc, layout, center, width, barTop + layout.barHeight() + gap, metric);
    }

    // Pill track and fill; a fill shorter than the bar is tall gets a smaller
    // corner radius so its rounded ends never cross (HeroSetMissionBars).
    private static function drawBar(dc as Graphics.Dc, left as Number, top as Number, width as Number, height as Number, metric as HeroFaceMetric, accent as Number) as Void {
        dc.setColor(HeroFacePalette.TRACK, Graphics.COLOR_TRANSPARENT);
        if (HeroFacePalette.MONO) {
            // A 1-bit display has no dim: the track is an outline, the fill solid over it.
            dc.drawRoundedRectangle(left, top, width, height, height / 2);
        } else {
            dc.fillRoundedRectangle(left, top, width, height, height / 2);
        }
        var fill = width * metric.permille() / 1000;
        if (fill <= 0) {
            return;
        }
        dc.setColor(metric.isDone() ? HeroFacePalette.DONE : accent, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(left, top, fill, height, (fill < height ? fill : height) / 2);
    }

    // A finished goal: a drawn check beside its label in green. On the 1-bit Instinct the columns are about 42 px and
    // "check + STEP" did not fit ("ST."), so the label itself is reversed (black on a white pill) instead, which costs
    // two pixels each side and no check; the full solid bar says "done" there as well (ADR-002 amendment, 2026-10-04).
    private static function drawLabel(dc as Graphics.Dc, layout as HeroFaceLayout, center as Number, width as Number, top as Number, metric as HeroFaceMetric) as Void {
        var done = metric.isDone();
        var reversed = done && HeroFacePalette.MONO;
        var check = done && !reversed ? checkWidth(dc) : 0;
        var pad = reversed ? layout.doneLabelPad() : 0;
        var icon = HeroFaceIcon.drawsFor(metric.kind);
        var label = "";
        var textWidth = 0;
        if (icon) {
            textWidth = HeroFaceIcon.width(metric.kind, HeroFaceIcon.size());
        } else {
            label = HeroFaceDraw.firstWithin(dc, width - check - 2 * pad, Graphics.FONT_XTINY, HeroFaceText.labels(metric.kind));
            if (layout.subscreen() != null) {
                // The Instinct's columns are about 40 px: a long translation is cut with a "." rather than reaching the next one.
                label = HeroFaceDraw.truncated(dc, label, Graphics.FONT_XTINY, width - check - 2 * pad);
            }
            textWidth = dc.getTextWidthInPixels(label, Graphics.FONT_XTINY);
        }
        var left = inside(dc, layout, center - (textWidth + check) / 2, textWidth + check, top);
        dc.setColor(done ? HeroFacePalette.DONE : HeroFacePalette.MUTED, Graphics.COLOR_TRANSPARENT);
        if (reversed) {
            var line = dc.getFontHeight(Graphics.FONT_XTINY);
            dc.fillRoundedRectangle(left - pad, top, textWidth + 2 * pad, line, line / 4);
            dc.setColor(HeroFacePalette.BACKGROUND, Graphics.COLOR_TRANSPARENT);
        } else if (done) {
            drawCheck(dc, left, top + Graphics.getFontAscent(Graphics.FONT_XTINY), checkWidth(dc) * 2 / 3);
        }
        if (icon) {
            // On the capital line of the word it replaces: from the font's ascent down to its baseline.
            var baseline = top + Graphics.getFontAscent(Graphics.FONT_XTINY);
            HeroFaceIcon.draw(dc, metric.kind, left + check, baseline - HeroFaceIcon.size(), HeroFaceIcon.size());
            HeroFaceDraw.box(layout, left + check, baseline - HeroFaceIcon.size(), textWidth, HeroFaceIcon.size(), "icon" + metric.kind);
        } else {
            HeroFaceDraw.text(dc, layout, left + check, top, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    // A label wider than its outer column slides inward to stay inside the rectangle's frame (on a round watch the
    // chord below the content radius already leaves it room). Long translations on a Venu Sq, ROADMAP 13.36.
    private static function inside(dc as Graphics.Dc, layout as HeroFaceLayout, left as Number, width as Number, top as Number) as Number {
        if (!layout.rectangle()) {
            return left;
        }
        var line = dc.getFontHeight(Graphics.FONT_XTINY);
        var min = layout.leftInset(top, line);
        var max = layout.rightInset(top, line) - width;
        return left < min ? min : (left > max ? max : left);
    }

    // Check mark sized off the label font, plus a gap before the label.
    private static function checkWidth(dc as Graphics.Dc) as Number {
        return Graphics.getFontAscent(Graphics.FONT_XTINY) * 3 / 4;
    }

    // Two strokes sitting on the label's baseline.
    private static function drawCheck(dc as Graphics.Dc, left as Number, baseline as Number, size as Number) as Void {
        var pen = size / 5 > 1 ? size / 5 : 2;
        dc.setPenWidth(pen);
        var midX = left + size / 3;
        dc.drawLine(left, baseline - size / 2, midX, baseline - pen / 2);
        dc.drawLine(midX, baseline - pen / 2, left + size, baseline - size);
        dc.setPenWidth(1);
    }
}
