import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// The strings DayArcStack sizes every row against: a FIXED worst case per row
// (DayArcConfig.WORST_*), or the live string when it is WIDER — measured in pixels at the largest
// font of its family, since character counts mislead in a proportional font — so the chosen font
// tiers don't flicker between readings. `covers` says whether a later live hero still fits the plan
// that was sized for an earlier one; DayArcPlanCache replans when it doesn't.
class DayArcSizing {
    static function strings(dc as Graphics.Dc, window as Number, hero as Dictionary) as Dictionary {
        var text = DayArcLayout.LABEL_FONTS[0];
        var worstValue = window == DayArcConfig.WINDOW_MORNING ? DayArcConfig.WORST_TEMPERATURE : DayArcConfig.WORST_COUNT;
        var date = hero.get(:dateText);
        var sub = hero.hasKey(:sub) ? hero.get(:sub) : null;
        var value = hero.hasKey(:value) ? hero.get(:value) : null;
        return {
            :date => date instanceof String ? wider(dc, date, DayArcConfig.WORST_DATE, text) : null,
            :liveDate => date instanceof String ? date : null,   // what DayArcStackFit asks the corner fields about (the sized :date is the worst case)
            :label => hero.get(:label),
            :value => wider(dc, value instanceof String ? value : worstValue, worstValue, DayArcLayout.HERO_FONTS[0]),
            :sub => sub instanceof String ? wider(dc, sub, worstSub(window), text) : null,
        } as Dictionary;
    }

    // True when every live string of `hero` is no wider than what `sized` (from strings()) planned
    // for it, and no live string appeared where the plan has no row for it. A live string that is
    // absent or null draws nothing, so it always fits.
    static function covers(dc as Graphics.Dc, sized as Dictionary, hero as Dictionary) as Boolean {
        var text = DayArcLayout.LABEL_FONTS[0];
        return coveredBy(dc, sized.get(:date), hero.get(:dateText), text)
            && coveredBy(dc, sized.get(:label), hero.get(:label), text)
            && coveredBy(dc, sized.get(:value), hero.get(:value), DayArcLayout.HERO_FONTS[0])
            && coveredBy(dc, sized.get(:sub), hero.hasKey(:sub) ? hero.get(:sub) : null, text);
    }

    // Pro's grid: the plan checked its grid rows against the cell values of the moment it was made, so a value that later
    // grows wider (steps 999 -> 1000) must replan, or the grid drops a row the plan reserved room for and leaves a gap
    // (1.17, FR255S). A calendar title (:flex) is exempt: it may end in "..." whatever its width. One-way: a narrower value
    // keeps the plan, so tiers do not flicker.
    static function cellsCovered(dc as Graphics.Dc, planned as Array<Dictionary>, hero as Dictionary) as Boolean {
        var live = hero.get(:cells);
        if (!(live instanceof Array)) {
            return true;
        }
        var cells = live as Array<Dictionary>;
        for (var i = 0; i < cells.size(); i++) {
            if (cells[i].hasKey(:flex)) {
                continue;
            }
            if (i >= planned.size() || dc.getTextWidthInPixels(cells[i].get(:value) as String, DayArcLayout.CELL_FONT) > dc.getTextWidthInPixels(planned[i].get(:value) as String, DayArcLayout.CELL_FONT)) {
                return false;
            }
        }
        return true;
    }

    private static function coveredBy(dc as Graphics.Dc, planned as Object or Null, live as Object or Null, font as Graphics.FontDefinition) as Boolean {
        if (!(live instanceof String)) {
            return true;
        }
        if (!(planned instanceof String)) {
            return false;
        }
        return dc.getTextWidthInPixels(live, font) <= dc.getTextWidthInPixels(planned, font);
    }

    private static function worstSub(window as Number) as String {
        if (window == DayArcConfig.WINDOW_MORNING) {
            return DayArcConfig.WORST_MORNING_SUB;
        }
        if (window == DayArcConfig.WINDOW_EVENING) {
            return Lang.format(WatchUi.loadResource(Rez.Strings.evening_battery_of_100) as String, [DayArcConfig.BODY_BATTERY_MAX]);
        }
        return "";
    }

    private static function wider(dc as Graphics.Dc, a as String, b as String, font as Graphics.FontDefinition) as String {
        return dc.getTextWidthInPixels(a, font) >= dc.getTextWidthInPixels(b, font) ? a : b;
    }
}
