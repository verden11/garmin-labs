import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class DaysToGoSettingsDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        if (item.getId() == DaysToGoSettingsMenu.ITEM_DATE) {
            pushDatePicker();
        }
    }

    private function pushDatePicker() as Void {
        var font = columnFont();
        var months = monthColumn(font);
        var days = numberColumn(DaysToGoConfig.FIRST_DAY_OF_MONTH, DaysToGoConfig.MAX_DAY_OF_MONTH, null, font);
        var years = numberColumn(DaysToGoConfig.PICKER_FIRST_YEAR, DaysToGoConfig.PICKER_LAST_YEAR,
                                 twoLines(WatchUi.loadResource(Rez.Strings.year_every) as String), font);
        var title = new WatchUi.Text({
            :text => WatchUi.loadResource(Rez.Strings.menu_set_date) as String,
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_SMALL,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_BOTTOM
        });
        // Column order follows the Date style setting: Month, Day, Year or Day, Month, Year.
        var monthFirst = DaysToGoDateText.monthFirstFor(readStyle());
        var monthIndex = defaultIndex(months, DaysToGoConfig.KEY_MONTH);
        var dayIndex = defaultIndex(days, DaysToGoConfig.KEY_DAY);
        var yearIndex = defaultIndex(years, DaysToGoConfig.KEY_YEAR);
        var picker = new DaysToGoDatePicker(title,
            monthFirst ? [months, days, years] : [days, months, years],
            monthFirst ? [monthIndex, dayIndex, yearIndex] : [dayIndex, monthIndex, yearIndex]);
        WatchUi.pushView(picker, new DaysToGoDatePickerDelegate(monthFirst), WatchUi.SLIDE_UP);
    }

    private function readStyle() as Number {
        return DaysToGoSettings.load().dateStyle;
    }

    // "Every year" is wider than a third of a small screen: break it after its first word.
    private function twoLines(text as String) as String {
        var space = text.find(" ");
        return space == null ? text : text.substring(0, space) + "\n" + text.substring(space + 1, text.length());
    }

    // Three columns share the screen, so the font steps down with its width.
    private function columnFont() as Graphics.FontDefinition {
        var width = System.getDeviceSettings().screenWidth;
        if (width <= DaysToGoConfig.PICKER_TINY_FONT_MAX_PX) {
            return Graphics.FONT_TINY;
        }
        return width <= DaysToGoConfig.PICKER_SMALL_FONT_MAX_PX ? Graphics.FONT_SMALL : Graphics.FONT_MEDIUM;
    }

    // The short month words ("Oct"), in the watch's language: the same words the face's date line uses.
    private function monthColumn(font as Graphics.FontDefinition) as DaysToGoColumnFactory {
        var values = [] as Array<Number>;
        var labels = [] as Array<String>;
        for (var month = 1; month <= DaysToGoConfig.MONTHS_PER_YEAR; month++) {
            values.add(month);
            labels.add(DaysToGoDateText.monthWord(month));
        }
        return new DaysToGoColumnFactory(values, labels, font);
    }

    // first..last, plus a leading 0 entry when zeroLabel is given ("Every year").
    private function numberColumn(first as Number, last as Number, zeroLabel as String?, font as Graphics.FontDefinition) as DaysToGoColumnFactory {
        var values = [] as Array<Number>;
        var labels = [] as Array<String>;
        if (zeroLabel != null) {
            values.add(0);
            labels.add(zeroLabel);
        }
        for (var n = first; n <= last; n++) {
            values.add(n);
            labels.add(n.toString());
        }
        return new DaysToGoColumnFactory(values, labels, font);
    }

    private function defaultIndex(column as DaysToGoColumnFactory, key as String) as Number {
        var saved = Application.Properties.getValue(key);
        return saved instanceof Number ? column.indexOf(saved) : 0;
    }
}
