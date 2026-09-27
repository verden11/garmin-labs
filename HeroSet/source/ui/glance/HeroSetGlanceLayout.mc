import Toybox.Lang;

// Geometry of the app glance: one text row over one row of three pill bars,
// inside the rectangle the system gives a glance (140x79 up to 359x130 px,
// 63 px tall on the fenix 7 family). HeroSetLayout is the round display's
// chord geometry and does not apply to this rectangle. Pure arithmetic on the
// width, height and the text row's font height, so tests can check every
// product's area without drawing.
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

    private var _width as Lang.Number;
    private var _height as Lang.Number;
    private var _textHeight as Lang.Number;

    function initialize(width as Lang.Number, height as Lang.Number, textHeight as Lang.Number) {
        _width = width;
        _height = height;
        _textHeight = textHeight;
    }

    // Never less than the outline plus a pixel, so the outline stays inside
    // the area on the smallest glances too.
    function pad() as Lang.Number {
        var pad = _height / PAD_DIVISOR;
        return pad < OUTLINE + 1 ? OUTLINE + 1 : pad;
    }

    // Width available to the text row, before any check mark.
    function contentWidth() as Lang.Number {
        return _width - SIDES * pad();
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
        return _width / PILL_GAP_DIVISOR;
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
