import Toybox.Graphics;
import Toybox.Lang;

// AMOLED always-on: Garmin allows at most 10% of pixels lit and none for more
// than 3 minutes. So only the hero and the time, dim, no ring, and the whole
// block steps across a 3 x 3 grid once a minute.
class DaysToGoSleep {

    // `minute` picks the spot on the grid (the view passes the clock's minute).
    static function draw(dc as Graphics.Dc, layout as DaysToGoLayout, state as DaysToGoState, minute as Number) as Void {
        dc.setColor(DaysToGoPalette.SLEEP_TEXT, DaysToGoPalette.BACKGROUND);
        dc.clear();
        var grid = DaysToGoConfig.BURN_IN_GRID;
        var step = layout.driftStep();
        var dx = (minute % grid - 1) * step;
        var dy = (minute / grid % grid - 1) * step;
        // Fit against a circle smaller by the widest drift, so a shifted block stays inside.
        var radius = layout.contentRadius() - step;
        var frame = new DaysToGoFrame(dc, layout, state, true);
        var rows = frame.rows;
        dc.setColor(DaysToGoPalette.SLEEP_TEXT, Graphics.COLOR_TRANSPARENT);
        DaysToGoDraw.line(dc, layout, radius, rows.heroTop + dy, rows.heroHeight,
                          DaysToGoLayout.heroFonts(state.heroIsWord, true), [state.hero] as Array<String>, dx);
        DaysToGoDraw.line(dc, layout, radius, rows.timeTop + dy, dc.getFontHeight(frame.timeFont),
                          [frame.timeFont] as Array<Graphics.FontDefinition>, [state.time] as Array<String>, dx);
    }
}
