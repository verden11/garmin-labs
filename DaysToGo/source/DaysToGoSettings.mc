import Toybox.Application;
import Toybox.Lang;

// What the wearer chose, validated. Every value is clamped to something the
// face can draw, so a missing key, a wrong type from an old phone app or a
// list value nobody offers still gives a correct face (never a crash).
class DaysToGoSettings {
    var event as Number;
    var name as String;
    var month as Number;
    var day as Number;
    var year as Number;
    var hour as Number;      // the raw "Time of day" setting; DaysToGoEvent converts it
    var unit as Number;
    var dateStyle as Number;
    var footer as Number;
    var accent as Number;

    function initialize(values as Dictionary) {
        event = choice(values, DaysToGoConfig.KEY_EVENT, DaysToGoConfig.EVENT_CUSTOM, DaysToGoConfig.EVENT_NEW_YEAR);
        name = nameFrom(values[DaysToGoConfig.KEY_NAME] as Object?);
        month = within(values, DaysToGoConfig.KEY_MONTH, 1, DaysToGoConfig.MONTHS_PER_YEAR, 1);
        day = within(values, DaysToGoConfig.KEY_DAY, 1, DaysToGoConfig.MAX_DAY_OF_MONTH, 1);
        year = yearFrom(values[DaysToGoConfig.KEY_YEAR] as Object?);
        hour = within(values, DaysToGoConfig.KEY_HOUR, DaysToGoConfig.HOUR_SETTING_ALL_DAY, DaysToGoConfig.HOUR_SETTING_LAST, DaysToGoConfig.HOUR_SETTING_ALL_DAY);
        unit = choice(values, DaysToGoConfig.KEY_UNIT, DaysToGoConfig.UNIT_WEEKS, DaysToGoConfig.UNIT_DAYS);
        dateStyle = choice(values, DaysToGoConfig.KEY_DATE_STYLE, DaysToGoConfig.STYLE_MONTH_FIRST, DaysToGoConfig.STYLE_AUTO);
        footer = choice(values, DaysToGoConfig.KEY_FOOTER, DaysToGoConfig.FOOTER_STEPS, DaysToGoConfig.FOOTER_NONE);
        accent = within(values, DaysToGoConfig.KEY_ACCENT, 0, DaysToGoConfig.ACCENT_COUNT - 1, 0);
    }

    // Read fresh on every update: the on-watch picker writes Properties
    // without any callback, so a cache would hide the date it just saved.
    static function load() as DaysToGoSettings {
        var keys = [DaysToGoConfig.KEY_EVENT, DaysToGoConfig.KEY_NAME, DaysToGoConfig.KEY_MONTH, DaysToGoConfig.KEY_DAY,
                    DaysToGoConfig.KEY_YEAR, DaysToGoConfig.KEY_HOUR, DaysToGoConfig.KEY_UNIT, DaysToGoConfig.KEY_DATE_STYLE,
                    DaysToGoConfig.KEY_FOOTER, DaysToGoConfig.KEY_ACCENT];
        var values = {} as Dictionary;
        for (var i = 0; i < keys.size(); i++) {
            values[keys[i]] = read(keys[i]);
        }
        return new DaysToGoSettings(values);
    }

    private static function read(key as String) as Object? {
        try {
            return Application.Properties.getValue(key);
        } catch (e instanceof Application.Properties.InvalidKeyException) {
            return null;
        }
    }

    // A number from `first` to `last`, else the fallback.
    private static function within(values as Dictionary, key as String, first as Number, last as Number, fallback as Number) as Number {
        var value = values[key] as Object?;
        return value instanceof Number && value >= first && value <= last ? value : fallback;
    }

    // Same as within(), for a list whose entries are 0 to `last`.
    private static function choice(values as Dictionary, key as String, last as Number, fallback as Number) as Number {
        return within(values, key, 0, last, fallback);
    }

    private static function yearFrom(value as Object?) as Number {
        var valid = value instanceof Number && (value == DaysToGoConfig.EVERY_YEAR
            || (value >= DaysToGoConfig.PICKER_FIRST_YEAR && value <= DaysToGoConfig.PICKER_LAST_YEAR));
        return valid ? value as Number : DaysToGoConfig.EVERY_YEAR;
    }

    private static function nameFrom(value as Object?) as String {
        if (!(value instanceof String)) {
            return "";
        }
        return value.length() > DaysToGoConfig.NAME_MAX_LENGTH ? value.substring(0, DaysToGoConfig.NAME_MAX_LENGTH) as String : value;
    }
}
