import Toybox.Lang;

// Geometry of the app glance: one text row over one row of three pill bars,
// inside the rectangle the system gives a glance (140x79 up to 359x130 px,
// 63 px tall on the fenix 7 family). HeroSetLayout is the round display's
// chord geometry and does not apply to this rectangle. Pure arithmetic on the
// width, height and the text row's font height, so tests can check every
// product's area without drawing.
// On the Instinct E and 3 Solar the system draws the glance under the round
// subscreen window (ADR-055); `window` is [left, bottom] of that window in
// screen coordinates (from WatchUi.getSubscreen, null everywhere else) and both
// rows then stop left of it. The glance area's own origin is not available to an app, so it is a
// constant read off the SDK's device data.
(:glance)
class HeroSetGlanceLayout {

    // Left/right/top/bottom padding as a fraction of the height: round
    // bezels clip the left edge of glance content on some products.
    private static const PAD_DIVISOR = 8;
    // Each pill's outline is drawn this far outside its bar, and the pen goes
    // back to this after the check mark.
    static const OUTLINE = 1;
    static const DEFAULT_PEN = 1;
    private static const SIDES = 2;
    private static const PILL_HEIGHT_DIVISOR = 10;
    private static const PILL_MIN_HEIGHT = 4;
    private static const ROW_GAP_DIVISOR = 14;
    private static const PILL_GAP_DIVISOR = 20;
    // glance.contentArea x and y in simulator.json of instincte40mm,
    // instincte45mm and instinct3solar45mm (the only products with a window
    // and a glance): where the glance's (0, 0) lies on the screen.
    static const WINDOW_AREA_X = 9;
    static const WINDOW_AREA_Y = 19;

    private var _width as Lang.Number;
    private var _height as Lang.Number;
    private var _textHeight as Lang.Number;
    private var _window as [Lang.Number, Lang.Number]?;

    function initialize(width as Lang.Number, height as Lang.Number, textHeight as Lang.Number, window as [Lang.Number, Lang.Number]?) {
        _width = width;
        _height = height;
        _textHeight = textHeight;
        _window = window;
    }

    // Never less than the outline plus a pixel, so the outline stays inside
    // the area on the smallest glances too.
    function pad() as Lang.Number {
        var pad = _height / PAD_DIVISOR;
        return pad < OUTLINE + 1 ? OUTLINE + 1 : pad;
    }

    // Where the rows end: the padded right edge, or left of the subscreen window
    // (and its bezel ring, about a pad wide) when the block shares its height.
    function rightEdge() as Lang.Number {
        var window = _window;
        if (window == null || window[1] - WINDOW_AREA_Y + pad() <= textTop()) {
            return _width - pad();
        }
        return window[0] - WINDOW_AREA_X - pad();
    }

    // Width available to the text row, before any check mark.
    function contentWidth() as Lang.Number {
        return rightEdge() - pad();
    }

    function pillHeight() as Lang.Number {
        var h = _height / PILL_HEIGHT_DIVISOR;
        return h < PILL_MIN_HEIGHT ? PILL_MIN_HEIGHT : h;
    }

    private function rowGap() as Lang.Number {
        return _height / ROW_GAP_DIVISOR;
    }

    private function blockHeight() as Lang.Number {
        return _textHeight + rowGap() + pillHeight();
    }

    // The block is centred vertically; a block taller than the area (a very
    // large glance font) starts at the top and clips at the bottom rather than
    // above the area.
    function textTop() as Lang.Number {
        var top = (_height - blockHeight()) / 2;
        return top < 0 ? 0 : top;
    }

    function pillTop() as Lang.Number {
        return textTop() + _textHeight + rowGap();
    }

    function pillGap() as Lang.Number {
        // The width the rows have to share, which is the whole area unless a window narrows it.
        return (rightEdge() + pad()) / PILL_GAP_DIVISOR;
    }

    function pillWidth(count as Lang.Number) as Lang.Number {
        return (contentWidth() - pillGap() * (count - 1)) / count;
    }

    function pillLeft(index as Lang.Number, count as Lang.Number) as Lang.Number {
        return pad() + (pillWidth(count) + pillGap()) * index;
    }

    function fitsHeight() as Lang.Boolean {
        return blockHeight() <= _height;
    }
}
