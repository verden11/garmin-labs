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
        var shift = drift(layout, minute);
        var dx = shift[0];
        var dy = shift[1];
        // Fit against a circle smaller by the widest drift, so a shifted block stays inside.
        var radius = layout.contentRadius() - layout.driftStep();
        var frame = new DaysToGoFrame(dc, layout, state, true);
        var rows = frame.rows;
        dc.setColor(DaysToGoPalette.SLEEP_TEXT, Graphics.COLOR_TRANSPARENT);
        DaysToGoView.drawHero(dc, layout, radius, rows.heroTop + dy, rows.heroHeight, state, true, dx);
        DaysToGoDraw.line(dc, layout, radius, rows.timeTop + dy, dc.getFontHeight(frame.timeFont),
                          [frame.timeFont] as Array<Graphics.FontDefinition>, [state.time] as Array<String>, dx);
    }

    // The block's offset [dx, dy] at this minute: one of the 3 x 3 spots, centred on zero. Shared with the error frame
    // (DaysToGoView.drawFallback), so nothing drawn while asleep on AMOLED stands still.
    static function drift(layout as DaysToGoLayout, minute as Number) as Array<Number> {
        var grid = DaysToGoConfig.BURN_IN_GRID;
        var step = layout.driftStep();
        return [(minute % grid - 1) * step, (minute / grid % grid - 1) * step] as Array<Number>;
    }
}
