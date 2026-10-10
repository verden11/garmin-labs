import Toybox.Graphics;
import Toybox.Lang;

// The one move (DESIGN.md): today's sun path over a dashed 45-degree line, the part above the line (the window) thick in
// the accent, and the sun disc at "now": filled when the window is open, an outline otherwise. The path is drawn from the
// declination and equation of time at local solar noon (a day's change is under a fifth of a degree, invisible here);
// the window segment is pinned to the exact open and close minutes the times row shows. The accent marks nothing: it is
// the same in every state. Foreground only; the glance draws SunWindowMark instead.
class SunWindowDiagram {
    static const AXIS_START_MINUTE = 240;     // 04:00: one time axis for every day, so summer and winter compare
    static const AXIS_END_MINUTE = 1350;      // 22:30
    static const PATH_STEPS = 48;
    static const WINDOW_STEP_MINUTES = 20;
    static const WINDOW_PEN_MULTIPLE = 3;     // the window is this many line widths thick
    static const SILL_DASH_MULTIPLE = 2;      // dash and gap of the 45-degree line, in line widths

    static function draw(dc as Dc, layout as SunWindowLayout, state as SunWindowState, accent as Number) as Void {
        var day = state.day;
        if (day == null) {
            return;
        }
        var pen = layout.lineWidth();
        var horizon = layout.horizonY();
        drawHorizon(dc, layout, pen);
        drawSill(dc, layout, horizon - (SunWindowConfig.ELEVATION_DEG * layout.pxPerDegree()).toNumber(), pen);
        dc.setColor(SunWindowPalette.TRACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(pen);
        drawPath(dc, layout, state, day, AXIS_START_MINUTE, AXIS_END_MINUTE, PATH_STEPS);
        if (day.hasWindow) {
            dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(pen * WINDOW_PEN_MULTIPLE);
            var steps = (day.close - day.open) / WINDOW_STEP_MINUTES + 1;
            drawPath(dc, layout, state, day, day.open, day.close, steps < 2 ? 2 : steps);
        }
        dc.setPenWidth(1);
        drawSun(dc, layout, state, day, accent, pen);
    }

    private static function drawHorizon(dc as Dc, layout as SunWindowLayout, pen as Number) as Void {
        dc.setColor(SunWindowPalette.TRACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(pen);
        dc.drawLine(layout.pathLeft() - layout.overhang(), layout.horizonY(), layout.pathRight() + layout.overhang(), layout.horizonY());
        dc.setPenWidth(1);
    }

    // The 45-degree line as dashes (there is no dashed pen), muted; white on the Instinct.
    private static function drawSill(dc as Dc, layout as SunWindowLayout, y as Number, pen as Number) as Void {
        dc.setColor(SunWindowPalette.MUTED, Graphics.COLOR_TRANSPARENT);
        // Half a line, but never under 2 px on the 1-bit Instinct (a 1 px stroke is too thin to trust there).
        var sillPen = pen / 2;
        dc.setPenWidth(sillPen < (SunWindowPalette.MONO ? SunWindowLayout.MIN_LINE : 1) ? (SunWindowPalette.MONO ? SunWindowLayout.MIN_LINE : 1) : sillPen);
        var dash = pen * SILL_DASH_MULTIPLE;
        for (var x = layout.pathLeft(); x < layout.pathRight(); x += dash * 2) {
            var end = x + dash > layout.pathRight() ? layout.pathRight() : x + dash;
            dc.drawLine(x, y, end, y);
        }
        dc.setPenWidth(1);
    }

    // The path between two local minutes in `steps` strokes; strokes below the horizon are left out.
    private static function drawPath(dc as Dc, layout as SunWindowLayout, state as SunWindowState, day as SunWindowSunDay,
                                     from as Number, to as Number, steps as Number) as Void {
        var lastX = 0;
        var lastY = 0;
        var haveLast = false;
        for (var i = 0; i <= steps; i++) {
            var minute = from + (to - from) * i / steps;
            var degrees = sunHeight(state, day, minute);
            if (degrees < 0.0) {
                haveLast = false;
                continue;
            }
            var px = xAt(layout, minute);
            var y = layout.horizonY() - (degrees * layout.pxPerDegree()).toNumber();
            if (haveLast) {
                dc.drawLine(lastX, lastY, px, y);
            }
            lastX = px;
            lastY = y;
            haveLast = true;
        }
    }

    // The sun at "now": above the horizon only. Filled when the window is open, an outline otherwise.
    private static function drawSun(dc as Dc, layout as SunWindowLayout, state as SunWindowState, day as SunWindowSunDay,
                                    accent as Number, pen as Number) as Void {
        var degrees = sunHeight(state, day, state.minuteOfDay);
        // Off the time axis (a midsummer night north of the Arctic circle) there is no path to put the dot on.
        if (degrees < 0.0 || state.minuteOfDay < AXIS_START_MINUTE || state.minuteOfDay > AXIS_END_MINUTE) {
            return;
        }
        var cx = xAt(layout, state.minuteOfDay);
        var cy = layout.horizonY() - (degrees * layout.pxPerDegree()).toNumber();
        var radius = layout.dotRadius();
        dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
        if (state.kind == SunWindowConfig.STATE_OPEN) {
            dc.fillCircle(cx, cy, radius);
            return;
        }
        dc.setColor(SunWindowPalette.BACKGROUND, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, cy, radius);
        dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(pen);
        dc.drawCircle(cx, cy, radius - pen / 2);
        dc.setPenWidth(1);
    }

    // The sun's height in degrees at a local minute of today, as a Float for drawing.
    static function sunHeight(state as SunWindowState, day as SunWindowSunDay, localMinute as Number) as Float {
        return SunWindowSun.elevation(state.latitude, state.longitude, day.declination, day.equation,
                                      (localMinute - state.offsetMinutes).toDouble()).toFloat();
    }

    static function xAt(layout as SunWindowLayout, minute as Number) as Number {
        var span = AXIS_END_MINUTE - AXIS_START_MINUTE;
        var left = layout.pathLeft();
        return left + (layout.pathRight() - left) * (minute - AXIS_START_MINUTE) / span;
    }
}
