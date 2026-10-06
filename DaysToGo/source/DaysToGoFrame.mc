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
    private var _sleeping as Boolean = false;

    // `sleeping` keeps only the time and the hero (always-on).
    function initialize(dc as Graphics.Dc, layout as DaysToGoLayout, state as DaysToGoState, sleeping as Boolean) {
        if (layout.subscreen() == null) {
            timeFont = DaysToGoDraw.fontUpTo(dc, DaysToGoType.TIME_FONTS, layout.capFor(DaysToGoType.TIME_MAX_PERMILLE));
        } else {
            var cap = layout.capFor(DaysToGoType.TIME_BESIDE_WINDOW_MAX_PERMILLE);
            timeFont = DaysToGoDraw.fontUpToWidth(dc, DaysToGoType.TIME_FONTS, cap, layout.topBandWidth(cap), state.time);
        }
        nameFont = DaysToGoDraw.fontUpTo(dc, DaysToGoType.NAME_FONTS, layout.capFor(DaysToGoType.NAME_MAX_PERMILLE));
        nameFonts = DaysToGoDraw.fontsFrom(DaysToGoType.NAME_FONTS, nameFont);
        captionFont = DaysToGoDraw.fontUpTo(dc, DaysToGoType.CAPTION_FONTS, layout.capFor(DaysToGoType.CAPTION_MAX_PERMILLE));
        smallFont = DaysToGoDraw.fontUpTo(dc, DaysToGoType.SMALL_FONTS, layout.capFor(DaysToGoType.SMALL_MAX_PERMILLE));
        showName = !sleeping && state.name.length() > 0;
        showDate = !sleeping && state.dateLines.size() > 0;
        // No room for the footer on the Instinct (the window takes the top, the hero the rest, ADR-015).
        showFooter = !sleeping && state.footer != null && layout.subscreen() == null;
        var hasCaption = !sleeping && state.captionLines.size() > 0;
        var heroFonts = DaysToGoType.heroFonts(state.heroIsWord, sleeping);
        var minHero = dc.getFontHeight(heroFonts[heroFonts.size() - 1]);
        _sleeping = sleeping;
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
        if (layout.track() != null && !sleeping) {
            settle(dc, state.heroIsWord);
        }
    }

    // A rectangle's hero band is taller than its largest number font (ADR-019). The number takes the largest font whose
    // digits (its ascent: digits have no descent) fit the band, and the caption sits a row gap under their baseline, in the
    // font's empty padding; the spare height is split in font units, half above the number and half below the last row,
    // which lifts the bottom rows off the corners' curve. A word hero (TODAY, SET A DATE) gets the same lift, so its date
    // sits where a number face's does, and is centred in what is left. The width check stays with DaysToGoDraw.
    private function settle(dc as Graphics.Dc, word as Boolean) as Void {
        var font = numberFontFor(dc, rows.heroHeight);
        if (font == null) {
            return;
        }
        var ink = Graphics.getFontAscent(font);
        var slack = rows.heroHeight - ink;
        var lift = slack - slack / 2;
        if (word) {
            rows.heroHeight -= lift;
        } else {
            rows.heroTop += slack / 2;
            rows.heroHeight = dc.getFontHeight(font);
        }
        rows.captionTop = rows.captionTop > 0 ? rows.captionTop - lift : 0;
        rows.dateTop = rows.dateTop > 0 ? rows.dateTop - lift : 0;
        rows.footerTop = rows.footerTop > 0 ? rows.footerTop - lift : 0;
    }

    // The largest awake number font whose digits fit `band`, or null (none fits, or the API has no font ascent).
    private function numberFontFor(dc as Graphics.Dc, band as Number) as Graphics.FontDefinition? {
        if (!(Graphics has :getFontAscent)) {
            return null;
        }
        var fonts = DaysToGoType.heroFonts(false, false);
        for (var i = 0; i < fonts.size(); i++) {
            if (Graphics.getFontAscent(fonts[i]) <= band) {
                return fonts[i];
            }
        }
        return null;
    }

    private function plan(dc as Graphics.Dc, layout as DaysToGoLayout, hasCaption as Boolean) as DaysToGoRows {
        return layout.rows(
            dc.getFontHeight(timeFont),
            showName ? dc.getFontHeight(nameFont) : 0,
            hasCaption ? dc.getFontHeight(captionFont) : 0,
            showDate ? dc.getFontHeight(smallFont) : 0,
            showFooter && !footerWithDate ? dc.getFontHeight(smallFont) : 0,
            _sleeping);
    }
}
