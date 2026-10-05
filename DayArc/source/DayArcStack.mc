import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// The vertical + width budget for one active frame (DESIGN.md "Layout"): which font tier every row
// gets and where every row sits, decided by a measured dry run of the WHOLE stack — clock, date,
// hero label, hero icon+value, gauge, sub line(s) and, in Pro, the divider + a minimum grid block.
// DayArcDraw draws exactly what this plans, so dry run and real draw cannot drift apart.
// Why (owner's first wrist photo, 2026-09-28): rows stacked top-down with fonts picked per row by
// WIDTH only, nothing budgeted total HEIGHT, so on fr965 the sub row hit y=429 (chord -18) as "4...".
// The ladder (DayArcConfig.STACK_LEVELS) tries the largest tiers first and steps down only as
// needed, ending in TRIM rungs that drop optional rows; if even those cannot fit, prune() drops any
// row that would cross the usable bottom, so a plan is always safe to draw (`fits` says whether it
// is a real fit or a last resort). Rows are sized against fixed worst-case strings (DayArcSizing).
// Font box heights are conservative (number fonts carry padding above the digits), so a plan may
// look a touch smaller than necessary — the wrist tunes that, not a guess.
class DayArcStack {
    static const ROW_CLOCK = 0;
    static const ROW_DATE = 1;
    static const ROW_LABEL = 2;
    static const ROW_HERO = 3;
    static const ROW_GAUGE = 4;
    static const ROW_SUB = 5;
    static const ROW_GRID = 6;
    static const ROW_COUNT = 7;
    private static const SEARCH_STEP_PERMILLE = 8;

    // The plan: tiers, and each row's top y (-1 = absent) and height.
    var level as Number = 0;
    var fits as Boolean = false;
    var clockFont as Graphics.FontDefinition = DayArcLayout.CLOCK_FONTS[0];
    var heroFont as Graphics.FontDefinition = DayArcLayout.HERO_FONTS[0];
    var textFont as Graphics.FontDefinition = DayArcLayout.LABEL_FONTS[0];
    var gap as Number = 0;
    var subLineCount as Number = 1;
    var gridRows as Number = 0;
    var ys as Array<Number> = [-1, -1, -1, -1, -1, -1, -1] as Array<Number>;
    var hs as Array<Number> = [0, 0, 0, 0, 0, 0, 0] as Array<Number>;

    // What the plan was sized for (read by DayArcStackFit and DayArcPlanCache).
    var layout as DayArcLayout;
    var strings as Dictionary;
    var pro as Boolean;
    var cells as Array<Dictionary> = [] as Array<Dictionary>;
    var iconWidth as Number = 0;
    var smallIcon as Boolean = false;   // the hero icon beside MEDIUM and MILD (ADR-017), not the one beside HOT
    var plannedSub as Array<String> = [] as Array<String>;

    private var _dc as Graphics.Dc or Null;
    private var _window as Number;
    private var _hasGauge as Boolean;
    private var _iconHeight as Number = 0;
    // The two hero icon sizes of this screen (ADR-017): [large width, large height, small width, small height], 0 when the window has none.
    private var _iconSizes as Array<Number> = [0, 0, 0, 0] as Array<Number>;

    static function plan(dc as Graphics.Dc, layout as DayArcLayout, window as Number, hero as Dictionary) as DayArcStack {
        var stack = new DayArcStack(dc, layout, window, hero);
        stack.solve();
        return stack;
    }

    function initialize(dc as Graphics.Dc, layoutIn as DayArcLayout, window as Number, hero as Dictionary) {
        _dc = dc;
        layout = layoutIn;
        _window = window;
        _hasGauge = hero.hasKey(:gauge) && hero.get(:gauge) != null;
        // Night carries an empty :cells in Pro but draws no grid: it must plan (and centre) exactly as
        // Simple's does — night is the one window where the two densities render identically.
        pro = hero.hasKey(:cells) && window != DayArcConfig.WINDOW_NIGHT;
        if (pro) {
            cells = DayArcSizing.sizedCells(dc, hero.get(:cells) as Array<Dictionary>);
        }
        strings = DayArcSizing.strings(dc, window, hero);
        loadIconSizes(window);
    }

    private function loadIconSizes(window as Number) as Void {
        var ids = [DayArcIcons.heroFor(window, DayArcConfig.ACCENT_AUTO), DayArcIcons.heroSmallFor(window, DayArcConfig.ACCENT_AUTO)] as Array<ResourceId or Null>;
        for (var i = 0; i < ids.size(); i++) {
            var id = ids[i];
            if (id != null) {
                var icon = WatchUi.loadResource(id) as WatchUi.BitmapResource;
                _iconSizes[2 * i] = icon.getWidth();
                _iconSizes[2 * i + 1] = icon.getHeight();
            }
        }
    }

    // Solves the plan, then drops the Dc: a plan is cached across frames, a Dc lives one callback.
    function solve() as Void {
        search();
        if (!fits) {
            prune();
        }
        _dc = null;
    }

    private function dc() as Graphics.Dc {
        return _dc as Graphics.Dc;
    }

    // The passes over the ladder (ADR-016, ADR-017): the rungs that keep the hero label with the grid, then (Pro only)
    // without it; the same two for the rungs that drop the label; then the TRIM rungs. So a grid row is never bought with
    // the label while a Simple-like plan keeps it. A second sub line is tried only when one line at this rung failed
    // because the sub text itself did not fit its row, never just to split a string that already fits.
    private function search() as Void {
        var drop = DayArcConfig.STACK_FIRST_DROP_LABEL;
        var trim = DayArcConfig.STACK_FIRST_TRIM;
        if (!tryPass(0, drop, false) || (pro && !tryPass(0, drop, true)) || !tryPass(drop, trim, false) || (pro && !tryPass(drop, trim, true))) {
            return;
        }
        tryPass(trim, DayArcConfig.STACK_LEVELS.size(), false);
    }

    // True when no rung of the pass fits; false (and the plan is solved) when one does.
    private function tryPass(from as Number, to as Number, noGrid as Boolean) as Boolean {
        for (var rung = from; rung < to; rung++) {
            if (attempt(rung, 1, noGrid)) {
                return false;
            }
            if (strings.get(:sub) != null && !DayArcStackFit.rowFits(self, dc(), ROW_SUB) && attempt(rung, DayArcConfig.MAX_SUB_LINES, noGrid)) {
                return false;
            }
        }
        return true;
    }

    // Where Pro's grid rows begin (no divider since E1; the lift budget is part of the grid block).
    function gridTop() as Number {
        return ys[ROW_GRID];
    }

    // Live sub line(s) at draw time: two only if the plan budgeted two AND this live string does not
    // fit one line at its row ("Weather unavailable" stays on one line even under a two-line plan).
    function subLines(target as Graphics.Dc, sub as String) as Array<String> {
        var y = ys[ROW_SUB];
        var lineHeight = target.getFontHeight(textFont);
        if (subLineCount != DayArcConfig.MAX_SUB_LINES || (y >= 0 && target.getTextWidthInPixels(sub, textFont) <= rowWidth(y, lineHeight))) {
            return [sub] as Array<String>;
        }
        return DayArcText.split(target, sub, textFont);
    }

    // Active windows fit against the arc-aware chord; night has no arc and uses the plain chord.
    function rowWidth(y as Number, height as Number) as Number {
        if (_window == DayArcConfig.WINDOW_NIGHT) {
            return layout.rowMaxWidth(y, height);
        }
        return DayArcArc.rowMaxWidth(layout, y, height);
    }

    // Row heights and tiers for one rung, then centre (or, in Pro, top-anchor) the stack, slide it
    // down until the rows up near the arc clear it, and check everything.
    private function attempt(rung as Number, lines as Number, noGrid as Boolean) as Boolean {
        var t = DayArcConfig.STACK_LEVELS[rung];
        level = rung;
        // On a 1-bit watch the clock starts one tier down: with no hue the biggest digits read first, and they must be the hero's.
        // On a rectangle too (ADR-019, reviewer): the square's extra height went to the clock first, and on the Venu X1 a grey
        // "20:02" ended up 0.9 of the hero's height and twice its width. Not at night, where the time is the read.
        var floor = DayArcPalette.MONO || (layout.isRectangle() && _window != DayArcConfig.WINDOW_NIGHT) ? 1 : 0;
        clockFont = DayArcLayout.CLOCK_FONTS[DayArcText.max(t[DayArcConfig.LEVEL_CLOCK], floor)];
        heroFont = DayArcLayout.HERO_FONTS[t[DayArcConfig.LEVEL_HERO]];
        smallIcon = t[DayArcConfig.LEVEL_HERO] != 0;
        iconWidth = _iconSizes[smallIcon ? 2 : 0];
        _iconHeight = _iconSizes[smallIcon ? 3 : 1];
        textFont = DayArcLayout.LABEL_FONTS[t[DayArcConfig.LEVEL_TEXT]];
        gap = layout.rowGap() / t[DayArcConfig.LEVEL_GAP_DIVISOR];
        gridRows = noGrid ? 0 : t[DayArcConfig.LEVEL_GRID_ROWS];
        var trim = t[DayArcConfig.LEVEL_TRIM];
        subLineCount = trim == DayArcConfig.TRIM_NONE ? lines : 1;
        measure(trim, t[DayArcConfig.LEVEL_DROP_LABEL] == 1);
        var total = totalHeight();
        var limit = layout.gridBottom();
        var start = layout.topMargin();
        if (hs[ROW_GRID] == 0 && total < limit - start) {   // a stack with no grid block centres, Pro's included
            start += (limit - start - total) / 2;
        }
        if (_window == DayArcConfig.WINDOW_NIGHT) {
            // Night is just the clock and the date: both below the Instinct's window, so they share one centre
            // (beside it the clock would centre in the narrow band and the date on the screen). No-op elsewhere.
            start = layout.belowWindow(start);
        }
        var step = DayArcText.max(1, layout.permille(SEARCH_STEP_PERMILLE));
        place(start);
        while (start + total <= limit && !DayArcStackFit.topRowsFit(self, dc())) {
            start += step;
            place(start);
        }
        fits = start + total <= limit && DayArcStackFit.allRowsFit(self, dc()) && DayArcStackFit.gridFits(self, dc());
        if (fits && pro && hs[ROW_GRID] > 0 && layout.subscreen() == null) {
            clearClock(limit - start - total);
        }
        return fits;
    }

    // Pro's corner pills sit in the date row, right under the clock: where the planned stack leaves spare height, widen the
    // clock-to-date gap by up to one row gap (reviewer pass seven: the FR965 morning pills were 5 px under the digits).
    // Taken back if the lower rows then no longer fit their chords. With no spare height (the FR965 morning), and no label
    // row between the date and the hero, the date row alone moves down into the empty headroom above the hero's digits.
    private function clearClock(spare as Number) as Void {
        var wanted = layout.rowGap();
        var extra = DayArcText.max(0, DayArcText.min(spare, wanted));
        shiftFrom(ROW_DATE, ROW_COUNT, extra);
        var date = ys[ROW_LABEL] < 0 ? DayArcText.min(wanted - extra, gap) : 0;
        shiftFrom(ROW_DATE, ROW_LABEL, date);
        if (!(DayArcStackFit.allRowsFit(self, dc()) && DayArcStackFit.gridFits(self, dc()))) {
            shiftFrom(ROW_DATE, ROW_LABEL, -date);
            shiftFrom(ROW_DATE, ROW_COUNT, -extra);
        }
    }

    // Moves rows [from, to) down by dy (rows that are absent stay absent).
    private function shiftFrom(from as Number, to as Number, dy as Number) as Void {
        for (var i = from; i < to; i++) {
            ys[i] = ys[i] >= 0 ? ys[i] + dy : -1;
        }
    }

    private function measure(trim as Number, dropLabel as Boolean) as Void {
        var textHeight = dc().getFontHeight(textFont);
        var optional = trim == DayArcConfig.TRIM_NONE;
        hs[ROW_CLOCK] = DayArcText.inkHeight(dc(), clockFont);
        hs[ROW_DATE] = optional && strings.get(:date) != null ? textHeight : 0;
        hs[ROW_LABEL] = 0;
        hs[ROW_HERO] = 0;
        hs[ROW_GAUGE] = 0;
        hs[ROW_SUB] = 0;
        hs[ROW_GRID] = 0;
        if (_window == DayArcConfig.WINDOW_NIGHT) {
            return;
        }
        hs[ROW_LABEL] = optional && strings.get(:label) != null && !dropLabel ? textHeight : 0;
        hs[ROW_HERO] = DayArcText.max(DayArcText.inkHeight(dc(), heroFont), _iconHeight);
        hs[ROW_GAUGE] = _hasGauge ? layout.gaugeBoxHeight() : 0;
        var sub = strings.get(:sub) as String or Null;
        plannedSub = [] as Array<String>;
        if (sub != null && trim != DayArcConfig.TRIM_CORE) {
            plannedSub = subLineCount == DayArcConfig.MAX_SUB_LINES ? DayArcText.split(dc(), sub, textFont) : [sub] as Array<String>;
        }
        hs[ROW_SUB] = plannedSub.size() * textHeight;
        hs[ROW_GRID] = pro && optional && gridRows > 0 ? layout.gridReserve(dc(), gridRows) : 0;
    }

    private function totalHeight() as Number {
        var total = 0;
        var rows = 0;
        for (var i = 0; i < ROW_COUNT; i++) {
            if (hs[i] > 0) {
                total += hs[i];
                rows++;
            }
        }
        return total + gap * (rows > 0 ? rows - 1 : 0);
    }

    private function place(start as Number) as Void {
        var y = start;
        for (var i = 0; i < ROW_COUNT; i++) {
            ys[i] = hs[i] > 0 ? y : -1;
            y += hs[i] > 0 ? hs[i] + gap : 0;
        }
    }

    // The last resort when nothing fits: never draw a row whose bottom crosses the usable bottom.
    private function prune() as Void {
        var limit = layout.gridBottom();
        for (var i = 0; i < ROW_COUNT; i++) {
            if (ys[i] >= 0 && ys[i] + hs[i] > limit) {
                ys[i] = -1;
            }
        }
    }
}
