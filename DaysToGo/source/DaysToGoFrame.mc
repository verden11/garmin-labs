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

    // `sleeping` keeps only the time and the hero (always-on).
    function initialize(dc as Graphics.Dc, layout as DaysToGoLayout, state as DaysToGoState, sleeping as Boolean) {
        timeFont = DaysToGoDraw.fontUpTo(dc, DaysToGoLayout.TIME_FONTS, layout.capFor(DaysToGoLayout.TIME_MAX_PERMILLE));
        nameFont = DaysToGoDraw.fontUpTo(dc, DaysToGoLayout.NAME_FONTS, layout.capFor(DaysToGoLayout.NAME_MAX_PERMILLE));
        captionFont = DaysToGoDraw.fontUpTo(dc, DaysToGoLayout.CAPTION_FONTS, layout.capFor(DaysToGoLayout.CAPTION_MAX_PERMILLE));
        smallFont = DaysToGoDraw.fontUpTo(dc, DaysToGoLayout.SMALL_FONTS, layout.capFor(DaysToGoLayout.SMALL_MAX_PERMILLE));
        showName = !sleeping && state.name.length() > 0;
        showDate = !sleeping && state.dateLines.size() > 0;
        showFooter = !sleeping && state.footer != null;
        var hasCaption = !sleeping && state.captionLines.size() > 0;
        var heroFonts = DaysToGoLayout.heroFonts(state.heroIsWord, sleeping);
        var minHero = dc.getFontHeight(heroFonts[heroFonts.size() - 1]);
        rows = plan(dc, layout, hasCaption);
        while (rows.heroHeight < minHero && (showFooter || showName || showDate)) {
            if (showFooter) {
                showFooter = false;
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
            showFooter ? dc.getFontHeight(smallFont) : 0);
    }
}
