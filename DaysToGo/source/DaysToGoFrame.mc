import Toybox.Graphics;
import Toybox.Lang;

// The fonts and row positions for one state on this display. Fonts come first
// (each row takes the largest that stays under its height cap), then the rows
// are stacked from those heights, so a small screen gives the hero less room
// instead of overlapping rows.
class DaysToGoFrame {
    var timeFont as Graphics.FontDefinition;
    var nameFont as Graphics.FontDefinition;
    var captionFont as Graphics.FontDefinition;
    var smallFont as Graphics.FontDefinition;
    var rows as DaysToGoRows;
    // Optional rows that survived: on a small screen they are dropped, footer
    // first, then name, then date, until the hero has room for its smallest font.
    var showName as Boolean;
    var showDate as Boolean;
    var showFooter as Boolean;
    // The bottom line shares the date's line (a row of its own would squeeze the hero out), so it is not dropped.
    var footerWithDate as Boolean = false;
    // The name steps down a font before it is cut short with "...".
    var nameFonts as Array<Graphics.FontDefinition>;

    // `sleeping` keeps only the time and the hero (always-on).
    function initialize(dc as Graphics.Dc, layout as DaysToGoLayout, state as DaysToGoState, sleeping as Boolean) {
        if (layout.subscreen() == null) {
            timeFont = DaysToGoDraw.fontUpTo(dc, DaysToGoLayout.TIME_FONTS, layout.capFor(DaysToGoLayout.TIME_MAX_PERMILLE));
        } else {
            var cap = layout.capFor(DaysToGoLayout.TIME_BESIDE_WINDOW_MAX_PERMILLE);
            timeFont = DaysToGoDraw.fontUpToWidth(dc, DaysToGoLayout.TIME_FONTS, cap, layout.topBandWidth(cap), state.time);
        }
        nameFont = DaysToGoDraw.fontUpTo(dc, DaysToGoLayout.NAME_FONTS, layout.capFor(DaysToGoLayout.NAME_MAX_PERMILLE));
        nameFonts = DaysToGoDraw.fontsFrom(DaysToGoLayout.NAME_FONTS, nameFont);
        captionFont = DaysToGoDraw.fontUpTo(dc, DaysToGoLayout.CAPTION_FONTS, layout.capFor(DaysToGoLayout.CAPTION_MAX_PERMILLE));
        smallFont = DaysToGoDraw.fontUpTo(dc, DaysToGoLayout.SMALL_FONTS, layout.capFor(DaysToGoLayout.SMALL_MAX_PERMILLE));
        showName = !sleeping && state.name.length() > 0;
        showDate = !sleeping && state.dateLines.size() > 0;
        // No room for the footer on the Instinct (the window takes the top, the hero the rest, ADR-015).
        showFooter = !sleeping && state.footer != null && layout.subscreen() == null;
        var hasCaption = !sleeping && state.captionLines.size() > 0;
        var heroFonts = DaysToGoLayout.heroFonts(state.heroIsWord, sleeping);
        var minHero = dc.getFontHeight(heroFonts[heroFonts.size() - 1]);
        rows = plan(dc, layout, hasCaption);
        while (rows.heroHeight < minHero && (showFooter || showName || showDate)) {
            if (showFooter && showDate && !footerWithDate) {
                footerWithDate = true;
            } else if (showFooter) {
                showFooter = false;
                footerWithDate = false;
            } else if (showName) {
                showName = false;
            } else {
                showDate = false;
            }
            rows = plan(dc, layout, hasCaption);
        }
    }

    private function plan(dc as Graphics.Dc, layout as DaysToGoLayout, hasCaption as Boolean) as DaysToGoRows {
        return layout.rows(
            dc.getFontHeight(timeFont),
            showName ? dc.getFontHeight(nameFont) : 0,
            hasCaption ? dc.getFontHeight(captionFont) : 0,
            showDate ? dc.getFontHeight(smallFont) : 0,
            showFooter && !footerWithDate ? dc.getFontHeight(smallFont) : 0);
    }
}
