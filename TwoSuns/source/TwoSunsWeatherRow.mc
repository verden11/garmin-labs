import Toybox.Graphics;
import Toybox.Lang;

// The weather row's sizes and drawing (docs/decisions.md ADR-022, Weather row in Pro). Two forms: the full row
// is a lead cell (the condition icon and the feels-like temperature; or the next day's weekday, icon, high and
// low) and up to three ahead cells (an icon over its hour); the compact row is one line the height of the
// smallest label font, the lead cell only (and a forecast's low; no hour labels, so no ahead cells), for a screen too short for the full one.
// The lead icon is coloured and bigger than the ahead icons, its number is one fixed hue, everything else is mono. Cells
// are measured against the round chord: ahead cells go first, a forecast's low last (ROADMAP 13.40), and a lead that
// does not fit makes the frame try the compact row, then drop the row.
(:pro)
class TwoSunsWeatherRow {
    private static const LEAD_ICON_PERCENT = 140;     // the lead icon against an ahead icon (the approved mockup: 43 against 31 px)
    private static const ARROW_BLOCK_PERCENT = 80;    // the next-day arrow and its space before the weekday, of the label height
    private static const ARROW_LENGTH_PERCENT = 52;   // the arrow's length
    private static const ARROW_HEAD_PERCENT = 21;     // the head's half height
    private static const ARROW_HEAD_LENGTH_PERCENT = 25;   // the head's length
    private static const ARROW_PEN_DIVISOR = 11;      // the shaft's pen, a share of the label height
    private static const LOW_GAP_PERCENT = 40;        // the next day's low sits this far (of the label height) after its high

    static function labelFont() as Graphics.FontDefinition {
        return TwoSunsLayout.DATE_FONTS[TwoSunsLayout.DATE_FONTS.size() - 1];
    }

    static function iconSize(layout as TwoSunsLayout) as Number {
        var size = layout.capFor(TwoSunsConfig.WEATHER_ICON_PERMILLE);
        return size < TwoSunsConfig.WEATHER_ICON_MIN_PX ? TwoSunsConfig.WEATHER_ICON_MIN_PX : size;
    }

    // The row's height: the icon over the label, or one label line; 0 when the row is not drawn.
    static function height(dc as Graphics.Dc, layout as TwoSunsLayout, mode as Number) as Number {
        var label = dc.getFontHeight(labelFont());
        if (mode == TwoSunsConfig.WEATHER_ROW_FULL) {
            return iconSize(layout) + label;
        }
        return mode == TwoSunsConfig.WEATHER_ROW_COMPACT ? label : 0;
    }

    // How many ahead cells fit the chord at this row, or -1 when the lead cell alone does not. A day's forecast keeps
    // its low before any cell: a high alone reads as the temperature now (ROADMAP 13.40). The compact row has no hour
    // labels, so it draws no ahead cells: three icons with no hours said nothing (design critique 2026-10-05, ROADMAP 13.14).
    static function aheadThatFit(dc as Graphics.Dc, layout as TwoSunsLayout, weather as TwoSunsWeather, mode as Number, top as Number) as Number {
        var room = roomAt(dc, layout, mode, top);
        var compact = mode == TwoSunsConfig.WEATHER_ROW_COMPACT;
        if (compact && !weather.hasLead()) {
            return -1;
        }
        var most = compact ? 0 : weather.aheadKinds.size();
        var withLow = hasLow(weather);
        // Before sunrise there is no weekday to say "forecast": without its low the high reads as now, so no row.
        var passes = withLow && weather.dayLabel.length() == 0 ? 1 : 2;
        for (var pass = 0; pass < passes; pass++) {
            for (var count = most; count >= 0; count--) {
                if (totalWidth(dc, layout, weather, mode, count, withLow) <= room) {
                    return count;
                }
            }
            withLow = false;
        }
        return -1;
    }

    // A day's low is drawn whenever the row with it fits the chord (it outranks every ahead cell).
    static function lowKept(dc as Graphics.Dc, layout as TwoSunsLayout, weather as TwoSunsWeather, mode as Number, top as Number, ahead as Number) as Boolean {
        return hasLow(weather) && totalWidth(dc, layout, weather, mode, ahead, true) <= roomAt(dc, layout, mode, top);
    }

    private static function hasLow(weather as TwoSunsWeather) as Boolean {
        return weather.nextDay && weather.lowText.length() > 0 && weather.leadText.length() > 0;   // a low is drawn after its high
    }

    // Which planned cell the i-th drawn one is, when `count` of `size` fit: spread over the plan, so the last (the one
    // nearest sunset) always stays, with the first when two fit (ROADMAP 13.40).
    static function pick(i as Number, count as Number, size as Number) as Number {
        return count < 2 ? size - 1 : (i * (size - 1) + (count - 1) / 2) / (count - 1);
    }

    // Draws the lead cell and `ahead` ahead cells, centred as one group.
    static function draw(dc as Graphics.Dc, layout as TwoSunsLayout, weather as TwoSunsWeather, mode as Number, top as Number, ahead as Number) as Void {
        var rowHeight = height(dc, layout, mode);
        var gap = cellGap(layout);
        var withLow = lowKept(dc, layout, weather, mode, top, ahead);
        var leadW = leadWidth(dc, layout, weather, mode, withLow);
        var x = layout.rowCenterX(top, rowHeight) - totalWidth(dc, layout, weather, mode, ahead, withLow) / 2;
        if (leadW > 0) {
            drawLead(dc, layout, weather, mode, x, top, rowHeight, withLow);
            TwoSunsDraw.box(layout, x, top, leadW, rowHeight, "weather");
            x += leadW + 2 * gap;
        }
        for (var i = 0; i < ahead; i++) {
            var index = pick(i, ahead, weather.aheadKinds.size());
            var width = aheadWidth(dc, layout, weather, mode, index);
            drawAhead(dc, layout, weather, mode, index, x, top, rowHeight, width);
            TwoSunsDraw.box(layout, x, top, width, rowHeight, "weather");
            x += width + gap;
        }
    }

    private static function roomAt(dc as Graphics.Dc, layout as TwoSunsLayout, mode as Number, top as Number) as Number {
        var rowHeight = height(dc, layout, mode);
        var radius = layout.contentRadius();
        return layout.rightInsetWithin(radius, top, rowHeight) - layout.leftInsetWithin(radius, top, rowHeight);
    }

    private static function cellGap(layout as TwoSunsLayout) as Number {
        var gap = iconSize(layout) / 2;
        return gap < 2 ? 2 : gap;
    }

    private static function numberFont(dc as Graphics.Dc, rowHeight as Number) as Graphics.FontDefinition {
        return TwoSunsDraw.fontUpTo(dc, TwoSunsLayout.VALUE_FONTS, rowHeight);
    }

    private static function leadIcon(dc as Graphics.Dc, layout as TwoSunsLayout, weather as TwoSunsWeather, mode as Number) as Number {
        var row = height(dc, layout, mode);
        if (mode == TwoSunsConfig.WEATHER_ROW_COMPACT) {
            return row;
        }
        var big = iconSize(layout) * LEAD_ICON_PERCENT / TwoSunsConfig.PERCENT;
        return big < row ? big : row;
    }

    // The arrow, its space and the weekday; 0 when there is no weekday (before sunrise the date row already says it).
    private static function labelBlock(dc as Graphics.Dc, weather as TwoSunsWeather) as Number {
        if (weather.dayLabel.length() == 0) {
            return 0;
        }
        return dc.getFontHeight(labelFont()) * ARROW_BLOCK_PERCENT / TwoSunsConfig.PERCENT + dc.getTextWidthInPixels(weather.dayLabel, labelFont());
    }

    private static function totalWidth(dc as Graphics.Dc, layout as TwoSunsLayout, weather as TwoSunsWeather, mode as Number, ahead as Number, withLow as Boolean) as Number {
        var leadW = leadWidth(dc, layout, weather, mode, withLow);
        var gap = cellGap(layout);
        var total = leadW;
        if (ahead > 0) {
            total += (leadW > 0 ? 2 * gap : 0) + (ahead - 1) * gap;   // two gaps after the lead, one between ahead cells
            for (var i = 0; i < ahead; i++) {
                total += aheadWidth(dc, layout, weather, mode, pick(i, ahead, weather.aheadKinds.size()));
            }
        }
        return total;
    }

    private static function lowWidth(dc as Graphics.Dc, weather as TwoSunsWeather, withLow as Boolean) as Number {
        if (!withLow) {
            return 0;
        }
        return dc.getFontHeight(labelFont()) * LOW_GAP_PERCENT / TwoSunsConfig.PERCENT + dc.getTextWidthInPixels(weather.lowText, labelFont());
    }

    private static function leadWidth(dc as Graphics.Dc, layout as TwoSunsLayout, weather as TwoSunsWeather, mode as Number, withLow as Boolean) as Number {
        if (!weather.hasLead()) {
            return 0;
        }
        var gap = cellGap(layout);
        var iconW = weather.leadKind == TwoSunsConfig.WEATHER_NONE ? 0 : leadIcon(dc, layout, weather, mode);
        var textW = dc.getTextWidthInPixels(weather.leadText, numberFont(dc, height(dc, layout, mode)));
        var body = iconW + (iconW > 0 && textW > 0 ? gap : 0) + textW;
        var label = labelBlock(dc, weather);
        return (label > 0 ? label + gap : 0) + body + lowWidth(dc, weather, withLow);
    }

    private static function aheadWidth(dc as Graphics.Dc, layout as TwoSunsLayout, weather as TwoSunsWeather, mode as Number, index as Number) as Number {
        if (mode == TwoSunsConfig.WEATHER_ROW_COMPACT) {
            return height(dc, layout, mode);
        }
        var label = dc.getTextWidthInPixels(weather.aheadLabels[index], labelFont());
        return label > iconSize(layout) ? label : iconSize(layout);
    }

    private static function drawLead(dc as Graphics.Dc, layout as TwoSunsLayout, weather as TwoSunsWeather, mode as Number, left as Number,
                                     top as Number, rowHeight as Number, withLow as Boolean) as Void {
        var gap = cellGap(layout);
        var icon = leadIcon(dc, layout, weather, mode);
        var labelH = dc.getFontHeight(labelFont());
        var hasIcon = weather.leadKind != TwoSunsConfig.WEATHER_NONE;
        var centerY = top + rowHeight / 2;
        var block = labelBlock(dc, weather);
        var x = left;
        if (block > 0) {
            drawDayLabel(dc, weather, left, centerY - labelH / 2, labelH);
            x += block + gap;
        }
        if (hasIcon) {
            TwoSunsWeatherIcons.draw(dc, weather.leadKind, x + icon / 2, centerY, icon, false);
            x += icon + gap;
        }
        if (weather.leadText.length() > 0) {
            drawLeadText(dc, weather, x, centerY, numberFont(dc, rowHeight), withLow);
        }
    }

    // The lead number in its one fixed hue (the same whatever the condition); the next day's low, muted and smaller, after its high.
    private static function drawLeadText(dc as Graphics.Dc, weather as TwoSunsWeather, x as Number, centerY as Number,
                                         font as Graphics.FontDefinition, withLow as Boolean) as Void {
        var labelH = dc.getFontHeight(labelFont());
        dc.setColor(TwoSunsPalette.WEATHER_NUMBER, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, centerY - dc.getFontHeight(font) / 2, font, weather.leadText, Graphics.TEXT_JUSTIFY_LEFT);
        if (withLow) {
            dc.setColor(TwoSunsPalette.MUTED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(x + dc.getTextWidthInPixels(weather.leadText, font) + labelH * LOW_GAP_PERCENT / TwoSunsConfig.PERCENT,
                        centerY - labelH / 2, labelFont(), weather.lowText, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    // An arrow and the weekday: the cell is the next day, not a mistake beside today's date. The arrow is a shaft and a
    // filled head, vector shapes like the weather icons (docs/decisions.md ADR-023).
    private static function drawDayLabel(dc as Graphics.Dc, weather as TwoSunsWeather, left as Number, top as Number, labelH as Number) as Void {
        var length = labelH * ARROW_LENGTH_PERCENT / TwoSunsConfig.PERCENT;
        var headLength = labelH * ARROW_HEAD_LENGTH_PERCENT / TwoSunsConfig.PERCENT;
        var half = labelH * ARROW_HEAD_PERCENT / TwoSunsConfig.PERCENT;
        var middle = top + labelH / 2;
        dc.setColor(TwoSunsPalette.MUTED, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(labelH / ARROW_PEN_DIVISOR < 1 ? 1 : labelH / ARROW_PEN_DIVISOR);
        dc.drawLine(left, middle, left + length - headLength, middle);
        dc.setPenWidth(1);
        dc.fillPolygon([[left + length - headLength, middle - half], [left + length, middle], [left + length - headLength, middle + half]] as Array<[Numeric, Numeric]>);
        dc.drawText(left + labelH * ARROW_BLOCK_PERCENT / TwoSunsConfig.PERCENT, top, labelFont(), weather.dayLabel, Graphics.TEXT_JUSTIFY_LEFT);
    }

    private static function drawAhead(dc as Graphics.Dc, layout as TwoSunsLayout, weather as TwoSunsWeather, mode as Number, index as Number,
                                      left as Number, top as Number, rowHeight as Number, width as Number) as Void {
        var centerX = left + width / 2;
        if (mode == TwoSunsConfig.WEATHER_ROW_COMPACT) {
            TwoSunsWeatherIcons.draw(dc, weather.aheadKinds[index], centerX, top + rowHeight / 2, width, true);
            return;
        }
        var icon = iconSize(layout);
        TwoSunsWeatherIcons.draw(dc, weather.aheadKinds[index], centerX, top + icon / 2, icon, true);
        dc.setColor(TwoSunsPalette.MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, top + icon, labelFont(), weather.aheadLabels[index], Graphics.TEXT_JUSTIFY_CENTER);
    }
}
