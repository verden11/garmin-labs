import Toybox.Graphics;
import Toybox.Lang;

// A rectangle's second fitting pass (docs/decisions.md ADR-028, the rectangle track): once every row has its place, the
// time takes the largest font the inner box still holds, by height and by the width of the widest time ("00:00", so the
// size does not change from minute to minute), and the Body Battery number grows with it (Free up to FONT_LARGE, Pro, whose
// band shares its row with the curve, up to FONT_SMALL) so the energy reading stays clearly second. A size only fits
// when the rows can still be spread evenly over the box (TwoSunsRectSpread), the time's digits fit the box's width at
// their place and the weather row keeps its lead cell: rows are never dropped for it. Pure measuring; TwoSunsFrame applies
// the result.
(:rect)
class TwoSunsRectFit {

    // [time font, value font] for the largest time that fits, or null when nothing beats the frame's own fonts. The strip for
    // the watch battery row is kept only when the row will then fit and draw; when it would not draw anyway, the time takes
    // that room too (a setting that shows nothing must not cost the time a size).
    static function pick(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Array<Graphics.FontDefinition>? {
        var reserve = topReserve(dc, layout, frame, state);
        frame.batteryStrip = 0;
        frame.timeFitsByInk = true;
        if (reserve > 0) {
            var withRow = pickWithin(dc, layout, frame, state, reserve);
            if (batteryFits(dc, layout, frame, state, withRow, plannedWeatherHeight(dc, layout, frame, state), reserve)) {
                frame.batteryStrip = reserve;
                return withRow;
            }
        }
        return pickWithin(dc, layout, frame, state, 0);
    }

    // The time font the awake frame draws for this state (the always-on frame steps two below it).
    static function awakeTimeFont(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState) as Graphics.FontDefinition {
        return new TwoSunsFrame(dc, layout, state, false).timeFont;
    }

    private static function pickWithin(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState,
                                       strip as Number) as Array<Graphics.FontDefinition>? {
        var fonts = TwoSunsLayout.RECT_TIME_FONTS;
        var weatherH = plannedWeatherHeight(dc, layout, frame, state);
        var values = valueGrowFonts(frame);
        for (var i = 0; i < fonts.size(); i++) {
            var value = valueFor(dc, values, frame.valueFont, dc.getFontHeight(fonts[i]));
            var current = fonts[i] == frame.timeFont;
            if (current && value == frame.valueFont) {
                frame.timeFitsByInk = fits(dc, layout, frame, state, strip, weatherH, fonts[i], value);
                return null;   // nothing bigger fits: keep the frame's fonts
            }
            if (fits(dc, layout, frame, state, strip, weatherH, fonts[i], value)) {
                return [fonts[i], value] as Array<Graphics.FontDefinition>;
            }
            if (current) {
                return null;   // never smaller than the frame's own time
            }
        }
        return null;
    }

    private static function fits(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState, strip as Number,
                                 weatherH as Number, time as Graphics.FontDefinition, value as Graphics.FontDefinition) as Boolean {
        var rows = TwoSunsRectSpread.rowsFor(dc, layout, frame, time, value, weatherH, strip);
        return rows != null && timeFits(dc, layout, time, rows.timeTop, state.time) && weatherFitsAt(dc, layout, frame, state, rows.weatherTop);
    }

    // The weather row height the time is sized for: the row's own while the Weather setting is on, whether or not there is
    // data right now, so the time does not change size when data comes and goes.
    (:pro)
    private static function plannedWeatherHeight(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Number {
        var full = state.weatherOn ? TwoSunsWeatherRow.height(dc, layout, TwoSunsConfig.WEATHER_ROW_FULL) : 0;
        return full > frame.weatherHeight ? full : frame.weatherHeight;
    }

    (:free)
    private static function plannedWeatherHeight(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Number {
        return 0;
    }

    // The value fonts the number may grow into: Free's grows with the time; Pro's shares its band with the curve and keeps
    // its size.
    (:pro)
    private static function valueGrowFonts(frame as TwoSunsFrame) as Array<Graphics.FontDefinition> {
        return TwoSunsLayout.RECT_PRO_VALUE_FONTS;
    }

    (:free)
    private static function valueGrowFonts(frame as TwoSunsFrame) as Array<Graphics.FontDefinition> {
        return TwoSunsLayout.RECT_FREE_VALUE_FONTS;
    }

    // Whether the weather row's lead cell fits at `top` (true when there is no row), without changing the frame.
    (:pro)
    private static function weatherFitsAt(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState, top as Number) as Boolean {
        var weather = state.weather;
        return frame.weatherMode == TwoSunsConfig.WEATHER_ROW_NONE || weather == null
            || TwoSunsWeatherRow.aheadThatFit(dc, layout, weather, frame.weatherMode, top) >= 0;
    }

    (:free)
    private static function weatherFitsAt(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState, top as Number) as Boolean {
        return true;
    }

    // Room the time leaves for the watch battery row at the top of the box (the row and its gap; no twin below), only
    // while the Battery setting is on: with it off (the default) the time takes that room too.
    (:pro)
    private static function topReserve(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Number {
        var top = frame.rows.timeTop;
        return state.watchBattery == null ? 0 : top - TwoSunsBatteryRow.top(dc, layout, top);   // the row and its gap, no twin below
    }

    // Whether the watch battery row fits in a `strip` at the top of the box above the stack drawn with `picked` (or the
    // frame's own fonts when null), planned with the weather row the setting asks for (`weatherH`), so the answer does not
    // change when weather data comes and goes.
    (:pro)
    private static function batteryFits(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState,
                                        picked as Array<Graphics.FontDefinition>?, weatherH as Number, strip as Number) as Boolean {
        var percent = state.watchBattery;
        if (percent == null) {
            return false;
        }
        var time = picked == null ? frame.timeFont : picked[0];
        var value = picked == null ? frame.valueFont : picked[1];
        return TwoSunsRectSpread.rowsFor(dc, layout, frame, time, value, weatherH, strip) != null
            && TwoSunsBatteryRow.fits(dc, layout, layout.centerY() - layout.spanHeight() / 2, percent);
    }

    (:free)
    private static function batteryFits(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState,
                                        picked as Array<Graphics.FontDefinition>?, weatherH as Number, strip as Number) as Boolean {
        return false;
    }

    (:free)
    private static function topReserve(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Number {
        return 0;
    }

    // The largest value font no taller than the share of the time's height (TwoSunsLayout.RECT_VALUE_TO_TIME_PERMILLE),
    // never smaller than the frame's own.
    private static function valueFor(dc as Graphics.Dc, values as Array<Graphics.FontDefinition>, own as Graphics.FontDefinition,
                                     timeH as Number) as Graphics.FontDefinition {
        var cap = timeH * TwoSunsLayout.RECT_VALUE_TO_TIME_PERMILLE / TwoSunsConfig.PERMILLE;
        for (var i = 0; i < values.size(); i++) {
            var h = dc.getFontHeight(values[i]);
            if (h <= cap && h > dc.getFontHeight(own)) {
                return values[i];
            }
        }
        return own;
    }

    // Whether the widest time and this one fit the box's width across the digits (the font box less its empty bands).
    private static function timeFits(dc as Graphics.Dc, layout as TwoSunsLayout, font as Graphics.FontDefinition, top as Number,
                                     time as String) as Boolean {
        var h = dc.getFontHeight(font);
        var pad = TwoSunsRectSpread.timePad(font, h);
        var radius = layout.contentRadius();
        var width = layout.rightInsetWithin(radius, top + pad, h - 2 * pad) - layout.leftInsetWithin(radius, top + pad, h - 2 * pad);
        return dc.getTextWidthInPixels(TwoSunsConfig.WIDEST_TIME, font) <= width && dc.getTextWidthInPixels(time, font) <= width;
    }
}
