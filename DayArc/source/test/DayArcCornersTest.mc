import Toybox.Lang;
import Toybox.Test;

// Pro's upper-corner fields (DayArcCorners): at most CORNER_SLOTS cells leave the grid, and only
// icon-only ones; everything else stays in the grid in its original order. Run once per device
// (fit differs by chord) — it logs how many corners each window places.
(:test, :pro)
function cornersTakeOnlyIconOnlyCellsAndKeepTheRestInOrder(logger as Test.Logger) as Boolean {
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var variants = [2, 4] as Array<Number>; // midday-data, evening-data
    var windows = [DayArcConfig.WINDOW_MIDDAY, DayArcConfig.WINDOW_EVENING] as Array<Number>;
    for (var v = 0; v < variants.size(); v++) {
        var hero = dayArcWorstHero(variants[v], windows[v]);
        var plan = DayArcStack.plan(dc, layout, windows[v], hero);
        var cells = hero.get(:cells) as Array<Dictionary>;
        var rest = DayArcCorners.draw(dc, layout, plan, "Thu 01", cells); // the simulator's own date string is this short; WORST_DATE is the planner's wide case
        var moved = cells.size() - rest.size();
        logger.debug("pillHeight=" + layout.pillHeight(dc) + " dateRowHeight=" + plan.hs[DayArcStack.ROW_DATE]);
        logger.debug(dc.getWidth() + "x" + dc.getHeight() + " window=" + windows[v] + " corners=" + moved + " of " + cells.size() + " cells, dateRow=" + plan.ys[DayArcStack.ROW_DATE]);
        Test.assertMessage(moved >= 0 && moved <= DayArcConfig.CORNER_SLOTS, "window " + windows[v] + ": " + moved + " corner cells");
        var next = 0;
        for (var i = 0; i < cells.size(); i++) {
            if (next < rest.size() && cells[i] == rest[next]) {
                next++;
            } else {
                Test.assertMessage(DayArcGrid.isIconOnly(cells[i]), "window " + windows[v] + ": a labelled cell left the grid");
            }
        }
        Test.assertMessage(next == rest.size(), "window " + windows[v] + ": the grid cells lost their order");
    }
    return true;
}
