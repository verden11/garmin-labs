import Toybox.Graphics;
import Toybox.Lang;

// The fonts and row positions for one state on this display. Fonts come first (each row takes the
// largest that stays under its height cap), then the rows are stacked from those heights. When the
// stack is too tall for the display, optional rows give way in this order: the weather row steps down to its
// one-line form, then the date, the curve, the weather row and the sun line drop (docs/decisions.md ADR-016,
// amended by ADR-022, Weather row in Pro). The time and the Body Battery value never drop.
class TwoSunsFrame {
    var dateFont as Graphics.FontDefinition;
    var timeFont as Graphics.FontDefinition;
    var valueFont as Graphics.FontDefinition;
    var lineFont as Graphics.FontDefinition;
    // Each row may step down from its font, never up: the fonts from the chosen one on.
    var dateFonts as Array<Graphics.FontDefinition>;
    var timeFonts as Array<Graphics.FontDefinition>;
    var valueFonts as Array<Graphics.FontDefinition>;
    var lineFonts as Array<Graphics.FontDefinition>;
    var rows as TwoSunsRows;
    var bandHeight as Number = 0;
    var band as TwoSunsBand;
    var showDate as Boolean;
    var showCurve as Boolean;
    var showLine as Boolean;
    var weatherMode as Number = TwoSunsConfig.WEATHER_ROW_NONE;   // Pro: none, the full row or the one-line row
    var weatherHeight as Number = 0;
    var weatherAhead as Number = 0;                                // ahead cells that fit the chord
    var weatherBoxCount as Number = 0;                             // boxes the weather row draws: the lead cell and each ahead cell
    var showBattery as Boolean = false;                            // Pro: the watch battery row above the stack, when the chord has room
    var batteryTop as Number = 0;

    // `sleeping` keeps only the time, the value and the sun line (always-on).
    function initialize(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState, sleeping as Boolean) {
        dateFont = TwoSunsDraw.fontUpTo(dc, TwoSunsLayout.DATE_FONTS, layout.capFor(TwoSunsLayout.DATE_MAX_PERMILLE));
        // Always-on time is two steps below whatever awake would pick right now, not a separate fixed
        // list — so it stays visibly smaller than awake on every screen, not just the ones where awake
        // happens to land on its largest font (TwoSunsLayout.SLEEP_TIME_FONTS comment; 2026-09-27).
        var awakeTimeFont = TwoSunsDraw.fontUpTo(dc, TwoSunsLayout.TIME_FONTS, layout.capFor(TwoSunsLayout.TIME_MAX_PERMILLE));
        if (sleeping) {
            timeFonts = TwoSunsDraw.fontsBelow(TwoSunsLayout.TIME_FONTS, awakeTimeFont, 2);
            timeFont = timeFonts[0];
        } else {
            timeFont = awakeTimeFont;
            timeFonts = TwoSunsDraw.fontsFrom(TwoSunsLayout.TIME_FONTS, timeFont);
        }
        var valueList = valueFontList(sleeping);
        valueFont = TwoSunsDraw.fontUpTo(dc, valueList, layout.capFor(valueCap(sleeping)));
        lineFont = TwoSunsDraw.fontUpTo(dc, TwoSunsLayout.LINE_FONTS, layout.capFor(TwoSunsLayout.LINE_MAX_PERMILLE));
        dateFonts = TwoSunsDraw.fontsFrom(TwoSunsLayout.DATE_FONTS, dateFont);
        valueFonts = TwoSunsDraw.fontsFrom(valueList, valueFont);
        lineFonts = TwoSunsDraw.fontsFrom(TwoSunsLayout.LINE_FONTS, lineFont);
        showDate = !sleeping && state.showDate && state.dateLines.size() > 0;
        var curve = state.curve;
        // A rectangle's band spans the box, so a curve with no line (a lone dot) would float at its far end: there the bolt
        // and the number stand alone until two neighbouring samples exist (ADR-028).
        showCurve = !sleeping && curve != null && (layout.track() == null || curve.hasALine());
        showLine = state.skyLines.size() > 0;
        weatherMode = startingWeatherMode(state, sleeping);
        rows = dropRowsUntilItFits(dc, layout);
        band = planBand(dc, layout, state);
        if (showCurve && !band.hasCurve) {
            showCurve = false;   // no room for a useful curve on this chord: the glyph and the value stay
            rows = plan(dc, layout);
            band = planBand(dc, layout, state);
        }
        if (weatherMode != TwoSunsConfig.WEATHER_ROW_NONE && !weatherFits(dc, layout, state)) {
            weatherMode = TwoSunsConfig.WEATHER_ROW_NONE;   // not even the lead cell fits the chord at its row
            rows = plan(dc, layout);
            band = planBand(dc, layout, state);
        }
        if (!sleeping && layout.track() != null) {
            growTime(dc, layout, state);
        }
        weatherBoxCount = countWeatherBoxes(state);
        planBattery(dc, layout, state, sleeping);
    }

    // The Body Battery number's fonts and height cap: Pro shares the stack with the weather, battery and date rows and
    // the curve, so it keeps the small size; Free has room for a size up while awake (TwoSunsLayout.VALUE_FREE_FONTS).
    (:pro)
    private function valueFontList(sleeping as Boolean) as Array<Graphics.FontDefinition> {
        return TwoSunsLayout.VALUE_FONTS;
    }

    (:free)
    private function valueFontList(sleeping as Boolean) as Array<Graphics.FontDefinition> {
        return sleeping ? TwoSunsLayout.VALUE_FONTS : TwoSunsLayout.VALUE_FREE_FONTS;
    }

    (:pro)
    private function valueCap(sleeping as Boolean) as Number {
        return TwoSunsLayout.VALUE_MAX_PERMILLE;
    }

    (:free)
    private function valueCap(sleeping as Boolean) as Number {
        return sleeping ? TwoSunsLayout.VALUE_MAX_PERMILLE : TwoSunsLayout.VALUE_FREE_MAX_PERMILLE;
    }

    // Steps the weather row down, then drops optional rows (date, curve, weather row, line) until the stack fits
    // the span, then returns the rows.
    private function dropRowsUntilItFits(dc as Graphics.Dc, layout as TwoSunsLayout) as TwoSunsRows {
        var stacked = plan(dc, layout);
        while (layout.stackHeight(dateHeight(dc), dc.getFontHeight(timeFont), weatherHeight, bandHeight, lineHeight(dc)) > layout.spanHeight()
               && (showDate || showCurve || showLine || weatherMode != TwoSunsConfig.WEATHER_ROW_NONE)) {
            if (weatherMode == TwoSunsConfig.WEATHER_ROW_FULL) {
                weatherMode = TwoSunsConfig.WEATHER_ROW_COMPACT;
            } else if (showDate) {
                showDate = false;
            } else if (showCurve) {
                showCurve = false;
            } else if (weatherMode != TwoSunsConfig.WEATHER_ROW_NONE) {
                weatherMode = TwoSunsConfig.WEATHER_ROW_NONE;
            } else {
                showLine = false;
            }
            stacked = plan(dc, layout);
        }
        return stacked;
    }

    // A rectangle (ADR-028, the rectangle track): once every row has its place, the time takes the largest font the inner
    // box still holds, by height and by width, measured. Awake only; round and Instinct screens keep their cap. The width is
    // measured on the widest time ("00:00"), so the size does not change from minute to minute.
    private function growTime(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState) as Void {
        var fonts = TwoSunsLayout.RECT_TIME_FONTS;
        var room = layout.spanHeight() - topReserve(dc, layout, state);
        var radius = layout.contentRadius();
        for (var i = 0; i < fonts.size() && fonts[i] != timeFont; i++) {
            var h = dc.getFontHeight(fonts[i]);
            if (layout.stackHeight(dateHeight(dc), h, weatherHeight, bandHeight, lineHeight(dc)) > room) {
                continue;
            }
            var top = layout.rows(dateHeight(dc), h, weatherHeight, bandHeight, lineHeight(dc)).timeTop;
            var width = layout.rightInsetWithin(radius, top, h) - layout.leftInsetWithin(radius, top, h);
            if (dc.getTextWidthInPixels(TwoSunsConfig.WIDEST_TIME, fonts[i]) <= width && dc.getTextWidthInPixels(state.time, fonts[i]) <= width) {
                timeFont = fonts[i];
                timeFonts = TwoSunsDraw.fontsFrom(fonts, timeFont);
                rows = plan(dc, layout);
                band = planBand(dc, layout, state);
                if (weatherMode != TwoSunsConfig.WEATHER_ROW_NONE && !weatherFits(dc, layout, state)) {
                    weatherMode = TwoSunsConfig.WEATHER_ROW_NONE;
                    rows = plan(dc, layout);
                    band = planBand(dc, layout, state);
                }
                return;
            }
        }
    }

    // Room the time leaves for the watch battery row above the centred stack (a strip at the top, and its twin below). Kept
    // whether the row is on or not, so the row never moves the stack (ADR-023, Watch battery row).
    (:pro)
    private function topReserve(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState) as Number {
        return 2 * (rows.timeTop - TwoSunsBatteryRow.top(dc, layout, rows.timeTop));
    }

    (:free)
    private function topReserve(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState) as Number {
        return 0;
    }

    // The widest value the band must hold is measured, not guessed: the text itself or "100".
    private function planBand(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState) as TwoSunsBand {
        var widest = dc.getTextWidthInPixels(TwoSunsConfig.BATTERY_MAX.toString(), valueFont);
        var width = dc.getTextWidthInPixels(state.batteryText, valueFont);
        return TwoSunsBand.plan(layout, rows.bandTop, bandHeight, width > widest ? width : widest, dc.getFontHeight(valueFont), showCurve);
    }

    private function plan(dc as Graphics.Dc, layout as TwoSunsLayout) as TwoSunsRows {
        var valueHeight = dc.getFontHeight(valueFont);
        var curveHeight = layout.capFor(TwoSunsLayout.CURVE_BAND_PERMILLE);
        bandHeight = showCurve && curveHeight > valueHeight ? curveHeight : valueHeight;
        weatherHeight = weatherRowHeight(dc, layout);
        return layout.rows(dateHeight(dc), dc.getFontHeight(timeFont), weatherHeight, bandHeight, lineHeight(dc));
    }

    // The watch battery row sits one gap above the first row of the stack, in the strip the stack leaves free; it is drawn
    // only where its ink fits the round chord. Pro only, awake only.
    (:pro)
    private function planBattery(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState, sleeping as Boolean) as Void {
        var percent = state.watchBattery;
        if (sleeping || percent == null) {
            return;
        }
        batteryTop = TwoSunsBatteryRow.top(dc, layout, showDate ? rows.dateTop : rows.timeTop);
        showBattery = TwoSunsBatteryRow.fits(dc, layout, batteryTop, percent);
    }

    (:free)
    private function planBattery(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState, sleeping as Boolean) as Void {
    }

    // The weather row only exists in Pro, awake, when there is something to show; Free has no weather at all.
    (:pro)
    private function startingWeatherMode(state as TwoSunsState, sleeping as Boolean) as Number {
        return !sleeping && state.weather != null ? TwoSunsConfig.WEATHER_ROW_FULL : TwoSunsConfig.WEATHER_ROW_NONE;
    }

    (:free)
    private function startingWeatherMode(state as TwoSunsState, sleeping as Boolean) as Number {
        return TwoSunsConfig.WEATHER_ROW_NONE;
    }

    (:pro)
    private function weatherRowHeight(dc as Graphics.Dc, layout as TwoSunsLayout) as Number {
        return TwoSunsWeatherRow.height(dc, layout, weatherMode);
    }

    (:free)
    private function weatherRowHeight(dc as Graphics.Dc, layout as TwoSunsLayout) as Number {
        return 0;
    }

    // Measures the ahead cells that fit the chord; false when the lead cell alone does not.
    (:pro)
    private function weatherFits(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState) as Boolean {
        var weather = state.weather;
        if (weather == null) {
            return false;
        }
        weatherAhead = TwoSunsWeatherRow.aheadThatFit(dc, layout, weather, weatherMode, rows.weatherTop);
        return weatherAhead >= 0;
    }

    (:free)
    private function weatherFits(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState) as Boolean {
        return false;
    }

    // The boxes the weather row draws (the lead cell and each ahead cell), for the screen-fit test.
    private function countWeatherBoxes(state as TwoSunsState) as Number {
        var weather = state.weather;
        if (weatherMode == TwoSunsConfig.WEATHER_ROW_NONE || weather == null) {
            return 0;
        }
        return weatherAhead + (weather.hasLead() ? 1 : 0);
    }

    private function dateHeight(dc as Graphics.Dc) as Number {
        return showDate ? dc.getFontHeight(dateFont) : 0;
    }

    private function lineHeight(dc as Graphics.Dc) as Number {
        return showLine ? dc.getFontHeight(lineFont) : 0;
    }
}
