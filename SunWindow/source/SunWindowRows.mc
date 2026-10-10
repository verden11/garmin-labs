import Toybox.Graphics;
import Toybox.Lang;

// The words under the picture, planned before they are drawn so the fit tests read the same plan the screen uses.
// Each row is [text, font, colour, top y]. A row takes the first font of its chain that fits the screen at its height;
// a longer sentence never shrinks past the chain's end (shorter wording is chosen in strings.xml, not here).
class SunWindowRows {
    static const TEXT = 0;
    static const FONT = 1;
    static const COLOUR = 2;
    static const TOP = 3;

    static function wordChain(large as Boolean) as Array<Graphics.FontDefinition> {
        return (large ? [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY]
            : [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY]) as Array<Graphics.FontDefinition>;
    }

    static function reasonChain() as Array<Graphics.FontDefinition> {
        return [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    }

    static function timesChain() as Array<Graphics.FontDefinition> {
        return [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    }

    static function plan(dc as Dc, layout as SunWindowLayout, state as SunWindowState, is24Hour as Boolean) as Array<Array> {
        var rows = build(dc, layout, state, is24Hour, layout.rowsTop(state.hasSun()));
        if (state.hasSun() || rows.size() == 0) {
            return rows;
        }
        // The empty states have no picture: centre their rows on the screen (a second pass, because the font follows the room).
        var last = rows[rows.size() - 1];
        var bottom = (last[TOP] as Number) + dc.getFontHeight(last[FONT] as Graphics.FontDefinition);
        return build(dc, layout, state, is24Hour, (layout.height - (bottom - (rows[0][TOP] as Number))) / 2);
    }

    private static function build(dc as Dc, layout as SunWindowLayout, state as SunWindowState, is24Hour as Boolean, top as Number) as Array<Array> {
        var rows = [] as Array<Array>;
        var y = top;
        var word = SunWindowText.word(state.kind);
        var reason = SunWindowReasons.reason(state, is24Hour);
        var times = SunWindowReasons.times(state, is24Hour);
        if (word.length() > 0) {
            y = add(dc, layout, rows, word, wordChain(layout.startsLarge()), SunWindowPalette.TEXT, y);
        }
        if (reason.length() > 0) {
            y = add(dc, layout, rows, reason, reasonChain(), word.length() > 0 ? SunWindowPalette.MUTED : SunWindowPalette.TEXT, y);
        }
        if (times.length() > 0) {
            add(dc, layout, rows, times, timesChain(), SunWindowPalette.MUTED, y);
        }
        return rows;
    }

    // Appends the row and returns the y under it.
    private static function add(dc as Dc, layout as SunWindowLayout, rows as Array<Array>, text as String,
                                chain as Array<Graphics.FontDefinition>, colour as Number, y as Number) as Number {
        var font = fit(dc, layout, text, chain, y);
        rows.add([text, font, colour, y] as Array);
        return y + dc.getFontHeight(font);
    }

    static function fit(dc as Dc, layout as SunWindowLayout, text as String, chain as Array<Graphics.FontDefinition>, y as Number) as Graphics.FontDefinition {
        for (var i = 0; i < chain.size(); i++) {
            var height = dc.getFontHeight(chain[i]);
            if (dc.getTextWidthInPixels(text, chain[i]) <= 2 * layout.halfWidth(y, y + height)) {
                return chain[i];
            }
        }
        return chain[chain.size() - 1];
    }

    static function draw(dc as Dc, layout as SunWindowLayout, rows as Array<Array>) as Void {
        for (var i = 0; i < rows.size(); i++) {
            var row = rows[i];
            dc.setColor(row[COLOUR] as Number, Graphics.COLOR_TRANSPARENT);
            dc.drawText(layout.centerX(), row[TOP] as Number, row[FONT] as Graphics.FontDefinition, row[TEXT] as String, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}
