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
        dc.setColor(metric.isAlert() ? HeroFacePalette.ALERT : HeroFacePalette.TEXT, Graphics.COLOR_TRANSPARENT);
        HeroFaceDraw.text(dc, layout, center, top, Graphics.FONT_XTINY, value, Graphics.TEXT_JUSTIFY_CENTER);
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
        dc.fillRoundedRectangle(left, top, width, height, height / 2);
        var fill = width * metric.permille() / 1000;
        if (fill <= 0) {
            return;
        }
        dc.setColor(metric.isDone() ? HeroFacePalette.DONE : accent, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(left, top, fill, height, (fill < height ? fill : height) / 2);
    }

    private static function drawLabel(dc as Graphics.Dc, layout as HeroFaceLayout, center as Number, width as Number, top as Number, metric as HeroFaceMetric) as Void {
        var done = metric.isDone();
        var check = done ? checkWidth(dc) : 0;
        var label = HeroFaceDraw.firstWithin(dc, width - check, Graphics.FONT_XTINY, HeroFaceText.labels(metric.kind));
        var textWidth = dc.getTextWidthInPixels(label, Graphics.FONT_XTINY);
        var left = center - (textWidth + check) / 2;
        dc.setColor(done ? HeroFacePalette.DONE : HeroFacePalette.MUTED, Graphics.COLOR_TRANSPARENT);
        if (done) {
            drawCheck(dc, left, top + Graphics.getFontAscent(Graphics.FONT_XTINY), checkWidth(dc) * 2 / 3);
        }
        HeroFaceDraw.text(dc, layout, left + check, top, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_LEFT);
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
