import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// The glance: the app's name, then the state as a mark and a word (docs/spec.md, DESIGN.md). Everything is read at each
// draw by SunWindowReader (no stored state, so nothing outlives midnight) and nothing is written. No background fill:
// the system draws the themed card, and an opaque fill would paint over it. The system draws the launcher icon at the
// left of the card; the dc starts to its right.
(:glance)
class SunWindowGlanceView extends WatchUi.GlanceView {
    // Mark size, the gap before the word and the mark's vertical centre, as percent of the word font's height.
    static const MARK_PERCENT = 90;
    static const WORD_INDENT_PERCENT = 115;
    static const MARK_CENTRE_PERCENT = 62;
    // Indexes into plan().
    static const TITLE_TOP = 0;
    static const WORD_TOP = 1;
    static const WORD_LEFT = 2;
    static const MARK_SIZE = 3;
    static const WORD_FONT = 4;

    function initialize() {
        GlanceView.initialize();
    }

    function onUpdate(dc as Dc) as Void {
        drawState(dc, SunWindowReader.read(false, false, SunWindowConfig.GLANCE_READS_WEATHER));
    }

    // Where each piece goes for this state on this dc: [title top, word top, word left, mark size, word font]. A state
    // with no mark ("Open once") has its word at the left edge and a mark size of 0. Shared by drawing and the fit test.
    static function plan(dc as Dc, kind as Number) as Array {
        var font = Graphics.FONT_GLANCE;
        var small = Graphics.FONT_XTINY;
        var wordHeight = dc.getFontHeight(font);
        var titleHeight = dc.getFontHeight(small);
        var middle = (dc.getHeight() - titleHeight - wordHeight) / 2;
        var titleTop = SunWindowPalette.MONO ? SunWindowConfig.GLANCE_MONO_TITLE_TOP : (middle > 0 ? middle : 0);
        var wordTop = titleTop + titleHeight;
        // The room for the state row: the whole glance, or on the Instinct what is left of the round sub-window.
        var room = SunWindowPalette.MONO && SunWindowConfig.GLANCE_MONO_ROOM < dc.getWidth() ? SunWindowConfig.GLANCE_MONO_ROOM : dc.getWidth();
        if (!SunWindowMark.isDrawn(kind)) {
            return [titleTop, wordTop, 0, 0, font] as Array;
        }
        var left = wordHeight * WORD_INDENT_PERCENT / SunWindowConfig.PERCENT;
        var width = dc.getTextWidthInPixels(SunWindowText.word(kind), font);
        if (width + left <= room) {
            return [titleTop, wordTop, left, wordHeight * MARK_PERCENT / SunWindowConfig.PERCENT, font] as Array;
        }
        // Not beside the mark. The 1-bit Instinct drops the mark and keeps the word (the word carries the state there); any
        // other glance drops to the small font. Shorter before smaller is the rule elsewhere; here the words are fixed.
        if (SunWindowPalette.MONO) {
            return [titleTop, wordTop, 0, 0, width <= room ? font : small] as Array;
        }
        return [titleTop, wordTop, left, wordHeight * MARK_PERCENT / SunWindowConfig.PERCENT, small] as Array;
    }

    // Split from onUpdate so tests can draw a state into a bitmap at any product's glance size.
    function drawState(dc as Dc, state as SunWindowState) as Void {
        var p = plan(dc, state.kind);
        var wordHeight = dc.getFontHeight(Graphics.FONT_GLANCE);
        dc.setColor(SunWindowPalette.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(0, p[TITLE_TOP] as Number, Graphics.FONT_XTINY, SunWindowText.load(Rez.Strings.AppName), Graphics.TEXT_JUSTIFY_LEFT);
        if (!SunWindowMark.isDrawn(state.kind)) {
            dc.drawText(0, p[WORD_TOP] as Number, Graphics.FONT_GLANCE, SunWindowText.once(), Graphics.TEXT_JUSTIFY_LEFT);
            return;
        }
        if ((p[MARK_SIZE] as Number) > 0) {
            SunWindowMark.draw(dc, wordHeight / 2, (p[WORD_TOP] as Number) + wordHeight * MARK_CENTRE_PERCENT / SunWindowConfig.PERCENT, p[MARK_SIZE] as Number, state.kind);
        }
        dc.setColor(SunWindowPalette.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(p[WORD_LEFT] as Number, p[WORD_TOP] as Number, p[WORD_FONT] as Graphics.FontDefinition, SunWindowText.word(state.kind), Graphics.TEXT_JUSTIFY_LEFT);
    }
}
