import Toybox.Graphics;
import Toybox.Lang;

// Today's three missions as thick bars (ADR-031): label and count share one
// line with the bar under it. The bar length carries the glance; the numbers
// are the detail.
class HeroSetMissionBars {

    private var _labels as Lang.Array<Lang.String>;
    private var _doneLabels as Lang.Array<Lang.String>;
    // Set by draw() for the row helpers below: the goal is per-draw state,
    // not per-instance, and threading it through five signatures buys
    // nothing while draw() is the only way into them.
    private var _goal as Lang.Number = HeroSetConfig.DEFAULT_MISSION_GOAL;
    // Same per-draw state: false when a DONE label can't share its row with
    // the count even at the smallest font.
    private var _doneWords as Lang.Boolean = true;

    function initialize() {
        var exercises = HeroSetRules.EXERCISES;
        _labels = [] as Lang.Array<Lang.String>;
        _doneLabels = [] as Lang.Array<Lang.String>;
        for (var i = 0; i < exercises.size(); i++) {
            var label = HeroSetText.exerciseLabel(exercises[i]);
            _labels.add(label);
            _doneLabels.add(HeroSetText.format(Rez.Strings.dashboard_mission_done, [label]));
        }
    }

    // One row per count, splitting [top, bottom] evenly.
    function draw(dc as Graphics.Dc, layout as HeroSetLayout, top as Lang.Number, bottom as Lang.Number, counts as Lang.Array<Lang.Number>, goal as Lang.Number) as Void {
        _goal = goal;
        var pitch = (bottom - top) / counts.size();
        var column = column(layout, top, bottom - top);
        _doneWords = true;
        var font = countFont(dc, layout, pitch, counts, column);
        if (font == null) {
            // Long translations (Ukrainian, Danish, Dutch, ...) on 360 px:
            // the full bar and a count at goal still say done without green.
            _doneWords = false;
            font = countFont(dc, layout, pitch, counts, column);
        }
        if (font == null) {
            font = Graphics.FONT_XTINY;
        }
        for (var i = 0; i < counts.size(); i++) {
            drawRow(dc, layout, top + pitch * i, i, counts[i], font, column);
        }
    }

    // All rows share the edges of the block's narrowest point, so labels,
    // counts and bars line up as columns (ADR-031). Measured against the
    // content circle, so the bars stay clear of the XP ring.
    function column(layout as HeroSetLayout, blockTop as Lang.Number, blockHeight as Lang.Number) as [Lang.Number, Lang.Number] {
        var radius = layout.contentRadius();
        return [layout.leftInsetWithin(radius, blockTop, blockHeight), layout.rightInsetWithin(radius, blockTop, blockHeight)];
    }

    // Uppercase labels and digits have no descenders, so a row needs only the
    // count font's ascent above its bar, not the font's full height.
    function rowHeight(layout as HeroSetLayout, font as Graphics.FontDefinition) as Lang.Number {
        return Graphics.getFontAscent(font) + layout.stackGap() + layout.barHeight();
    }

    // One count font for all rows so the block reads as a unit: the largest
    // whose row fits the pitch and whose label + count fit the column; null
    // when none does.
    function countFont(dc as Graphics.Dc, layout as HeroSetLayout, pitch as Lang.Number, counts as Lang.Array<Lang.Number>, column as [Lang.Number, Lang.Number]) as Graphics.FontDefinition? {
        var fonts = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Lang.Array<Graphics.FontDefinition>;
        for (var f = 0; f < fonts.size(); f++) {
            if (rowsFit(dc, layout, pitch, counts, fonts[f], column)) {
                return fonts[f];
            }
        }
        return null;
    }

    private function rowsFit(dc as Graphics.Dc, layout as HeroSetLayout, pitch as Lang.Number, counts as Lang.Array<Lang.Number>, font as Graphics.FontDefinition, column as [Lang.Number, Lang.Number]) as Lang.Boolean {
        if (rowHeight(layout, font) > pitch) {
            return false;
        }
        var available = column[1] - column[0];
        for (var i = 0; i < counts.size(); i++) {
            var needed = dc.getTextWidthInPixels(labelFor(i, counts[i]), Graphics.FONT_XTINY) + layout.stackGap() + dc.getTextWidthInPixels(counts[i].toString(), font);
            if (needed > available) {
                return false;
            }
        }
        return true;
    }

    // DONE in the label means a finished goal never depends on the green alone.
    private function labelFor(index as Lang.Number, count as Lang.Number) as Lang.String {
        return count >= _goal && _doneWords ? _doneLabels[index] : _labels[index];
    }

    // The XTINY label shares the count's baseline so mixed sizes read as one
    // line.
    private function drawRow(dc as Graphics.Dc, layout as HeroSetLayout, y as Lang.Number, index as Lang.Number, count as Lang.Number, font as Graphics.FontDefinition, column as [Lang.Number, Lang.Number]) as Void {
        var baseline = y + Graphics.getFontAscent(font);
        var done = count >= _goal;
        dc.setColor(done ? HeroSetPalette.DONE : HeroSetPalette.TEXT, HeroSetPalette.BACKGROUND);
        HeroSetDraw.text(dc, layout, column[0], baseline - Graphics.getFontAscent(Graphics.FONT_XTINY), Graphics.FONT_XTINY, labelFor(index, count), Graphics.TEXT_JUSTIFY_LEFT);
        HeroSetDraw.text(dc, layout, column[1], y, font, count.toString(), Graphics.TEXT_JUSTIFY_RIGHT);
        drawBar(dc, layout, baseline + layout.stackGap(), count, column);
    }

    // Pill-shaped track and fill; a fill shorter than the bar is tall gets a
    // smaller corner radius so its rounded ends never overlap.
    private function drawBar(dc as Graphics.Dc, layout as HeroSetLayout, y as Lang.Number, count as Lang.Number, column as [Lang.Number, Lang.Number]) as Void {
        var height = layout.barHeight();
        var width = column[1] - column[0];
        if (width <= 0) {
            return;
        }
        var goal = _goal;
        var done = count >= goal;
        dc.setColor(HeroSetPalette.TRACK, HeroSetPalette.BACKGROUND);
        dc.fillRoundedRectangle(column[0], y, width, height, height / 2);
        var fill = done ? width : (count <= 0 ? 0 : width * count / goal);
        if (fill > 0) {
            dc.setColor(done ? HeroSetPalette.DONE : HeroSetPalette.EFFORT, HeroSetPalette.BACKGROUND);
            dc.fillRoundedRectangle(column[0], y, fill, height, (fill < height ? fill : height) / 2);
        }
    }
}
