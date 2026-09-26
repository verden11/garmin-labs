import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;

// The small date line. Words, never numbers, so it cannot be misread
// (03/04 is 3 April or 4 March). Weekday and month come from the system in the
// watch's language; the order is the one thing the system does not tell us,
// hence the Date style setting.
class DaysToGoDateText {

    // Candidates, longest first, for DaysToGoDraw.firstFitting.
    static function lines(weekday as String, day as Number, month as String, year as Number, monthFirst as Boolean, showYear as Boolean) as Array<String> {
        var date = monthFirst ? month + " " + day : day + " " + month;
        var result = [] as Array<String>;
        if (showYear) {
            result.add(weekday + " " + date + " " + year);
            result.add(date + " " + year);
        } else {
            result.add(weekday + " " + date);
        }
        result.add(date);
        return result;
    }

    static function monthFirst(style as Number, english as Boolean, statute as Boolean) as Boolean {
        if (style == DaysToGoConfig.STYLE_AUTO) {
            return english && statute;
        }
        return style == DaysToGoConfig.STYLE_MONTH_FIRST;
    }

    // The order for this watch: the Date style setting, resolved against the system language and units.
    static function monthFirstFor(style as Number) as Boolean {
        var device = System.getDeviceSettings();
        // systemLanguage is API 3.1; the manifest goes down to 3.0, so guard it.
        var english = (device has :systemLanguage) && device.systemLanguage == System.LANGUAGE_ENG;
        return monthFirst(style, english, device.distanceUnits == System.UNIT_STATUTE);
    }

    // The system writes the words in the watch's language, but only from a
    // Moment, so each word is read from a safe 2026 date: the weekday from the
    // Sunday plus the event's weekday (worked out on the calendar, not the
    // clock), the month from the 1st of that month. Gregorian.moment() reads
    // its fields as UTC, so read it back with utcInfo(); info() would shift
    // the day west of UTC.
    static function forDate(year as Number, month as Number, day as Number, currentYear as Number, monthFirst as Boolean) as Array<String> {
        var weekday = DaysToGoCalendar.weekday(year, month, day);
        var dayWord = Gregorian.utcInfo(Gregorian.moment({:year => DaysToGoConfig.WORD_YEAR, :month => 1, :day => DaysToGoConfig.WORD_SUNDAY_DAY + weekday}), Time.FORMAT_MEDIUM);
        var monthWord = Gregorian.utcInfo(Gregorian.moment({:year => DaysToGoConfig.WORD_YEAR, :month => month, :day => DaysToGoConfig.WORD_MONTH_DAY}), Time.FORMAT_MEDIUM);
        return lines(dayWord.day_of_week as String, day, monthWord.month as String, year, monthFirst, year != currentYear);
    }
}
