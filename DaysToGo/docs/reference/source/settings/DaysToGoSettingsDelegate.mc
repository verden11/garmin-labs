import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
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
        var months = monthColumn();
        var days = numberColumn(1, DaysToGoConfig.MAX_DAY_OF_MONTH, null);
        var years = numberColumn(DaysToGoConfig.PICKER_FIRST_YEAR, DaysToGoConfig.PICKER_LAST_YEAR,
                                 WatchUi.loadResource(Rez.Strings.year_every) as String);
        var title = new WatchUi.Text({
            :text => WatchUi.loadResource(Rez.Strings.menu_set_date) as String,
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_SMALL,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_BOTTOM
        });
        var picker = new WatchUi.Picker({
            :title => title,
            :pattern => [months, days, years],
            :defaults => [defaultIndex(months, DaysToGoConfig.KEY_MONTH), defaultIndex(days, DaysToGoConfig.KEY_DAY), defaultIndex(years, DaysToGoConfig.KEY_YEAR)]
        });
        WatchUi.pushView(picker, new DaysToGoDatePickerDelegate(), WatchUi.SLIDE_UP);
    }

    private function monthColumn() as DaysToGoColumnFactory {
        var ids = [Rez.Strings.month_1, Rez.Strings.month_2, Rez.Strings.month_3, Rez.Strings.month_4,
                   Rez.Strings.month_5, Rez.Strings.month_6, Rez.Strings.month_7, Rez.Strings.month_8,
                   Rez.Strings.month_9, Rez.Strings.month_10, Rez.Strings.month_11, Rez.Strings.month_12];
        var values = [] as Array<Number>;
        var labels = [] as Array<String>;
        for (var i = 0; i < ids.size(); i++) {
            values.add(i + 1);
            labels.add(WatchUi.loadResource(ids[i]) as String);
        }
        return new DaysToGoColumnFactory(values, labels);
    }

    // first..last, plus a leading 0 entry when zeroLabel is given ("Every year").
    private function numberColumn(first as Number, last as Number, zeroLabel as String?) as DaysToGoColumnFactory {
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
        return new DaysToGoColumnFactory(values, labels);
    }

    private function defaultIndex(column as DaysToGoColumnFactory, key as String) as Number {
        var saved = Application.Properties.getValue(key);
        return saved instanceof Number ? column.indexOf(saved) : 0;
    }
}
