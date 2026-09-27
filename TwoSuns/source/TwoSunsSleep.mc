import Toybox.Graphics;
import Toybox.Lang;

// AMOLED always-on: Garmin allows at most 10% of pixels lit and none for more than 3 minutes. So only
// the time, the Body Battery number and the sun sentence, dim, no ring and no curve, and the whole
// block steps across a 3 x 3 grid once a minute (Days To Go ADR-007).
class TwoSunsSleep {

    // `minute` picks the spot on the grid (the view passes the clock's minute).
    static function draw(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState, minute as Number) as Void {
        dc.setColor(TwoSunsPalette.SLEEP_TEXT, TwoSunsPalette.BACKGROUND);
        dc.clear();
        var grid = TwoSunsConfig.BURN_IN_GRID;
        var step = layout.driftStep();
        var dx = (minute % grid - 1) * step;
        var dy = (minute / grid % grid - 1) * step;
        // Fit against a circle smaller by the widest drift, so a shifted block stays inside.
        var radius = layout.contentRadius() - step;
        var frame = new TwoSunsFrame(dc, layout, state, true);
        var rows = frame.rows;
        dc.setColor(TwoSunsPalette.SLEEP_TEXT, Graphics.COLOR_TRANSPARENT);
        TwoSunsDraw.line(dc, layout, radius, rows.timeTop + dy, dc.getFontHeight(frame.timeFont),
                         frame.timeFonts, [state.time] as Array<String>, dx);
        TwoSunsDraw.line(dc, layout, radius, rows.bandTop + dy, frame.bandHeight,
                         frame.valueFonts, [state.batteryText] as Array<String>, dx);
        if (frame.showLine) {
            TwoSunsDraw.line(dc, layout, radius, rows.lineTop + dy, dc.getFontHeight(frame.lineFont),
                             frame.lineFonts, state.skyLines, dx);
        }
    }
}
