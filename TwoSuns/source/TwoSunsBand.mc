import Toybox.Lang;

// The Body Battery band on one row: [level pill] [value] [curve], centred as a block and kept inside
// the round chord of the content circle. Pure numbers (TwoSunsBand.plan); the drawing reads them.
// When the chord is too narrow for a curve of useful width, the curve is dropped and the glyph and
// value stay: the value is never dropped (docs/spec.md "Design brief").
class TwoSunsBand {
    var glyphLeft as Number = 0;
    var glyphTop as Number = 0;
    var glyphWidth as Number = 0;
    var glyphHeight as Number = 0;
    var valueCenterX as Number = 0;
    var hasCurve as Boolean = false;
    var curveLeft as Number = 0;
    var curveTop as Number = 0;
    var curveWidth as Number = 0;
    var curveHeight as Number = 0;

    static function plan(layout as TwoSunsLayout, bandTop as Number, bandHeight as Number, valueWidth as Number,
                         valueHeight as Number, wantCurve as Boolean) as TwoSunsBand {
        var band = new TwoSunsBand();
        var radius = layout.contentRadius();
        var chordLeft = layout.leftInsetWithin(radius, bandTop, bandHeight);
        var chordWidth = layout.rightInsetWithin(radius, bandTop, bandHeight) - chordLeft;
        var gap = layout.bandGap();
        band.glyphHeight = valueHeight * TwoSunsConfig.GLYPH_HEIGHT_PERCENT / TwoSunsConfig.PERCENT;
        band.glyphWidth = band.glyphHeight * TwoSunsConfig.GLYPH_ASPECT_PERMILLE / TwoSunsConfig.PERMILLE;
        var fixed = band.glyphWidth + gap + valueWidth;
        var curveWidth = chordWidth - fixed - gap;
        var cap = layout.capFor(TwoSunsConfig.CURVE_MAX_WIDTH_PERMILLE);
        curveWidth = curveWidth > cap ? cap : curveWidth;
        band.hasCurve = wantCurve && curveWidth >= layout.capFor(TwoSunsConfig.CURVE_MIN_WIDTH_PERMILLE);
        var total = band.hasCurve ? fixed + gap + curveWidth : fixed;
        var left = layout.centerX() - total / 2;
        left = left < chordLeft ? chordLeft : left;
        band.glyphLeft = left;
        band.glyphTop = bandTop + (bandHeight - band.glyphHeight) / 2;
        band.valueCenterX = left + band.glyphWidth + gap + valueWidth / 2;
        band.curveLeft = left + fixed + gap;
        band.curveTop = bandTop;
        band.curveWidth = band.hasCurve ? curveWidth : 0;
        band.curveHeight = bandHeight;
        return band;
    }
}
