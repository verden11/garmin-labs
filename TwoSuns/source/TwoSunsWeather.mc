import Toybox.Lang;

// What the weather row draws, already in words and icon kinds (docs/decisions.md ADR-022, Weather row in Pro).
// Built only in Pro (TwoSunsWeatherPlan); the class is shared so TwoSunsState compiles in both tiers, and Free never builds one.
class TwoSunsWeather {
    var leadKind as Number = TwoSunsConfig.WEATHER_NONE;     // the icon of the lead cell: now, or the next day's condition
    var leadText as String = "";                             // the feels-like temperature "15°", or the next day's high
    var lowText as String = "";                              // the next day's low; empty in day mode
    var nextDay as Boolean = false;                          // the lead cell is the next daylight day: weekday with a chevron
    var dayLabel as String = "";                             // the weekday, in the watch's language
    var aheadKinds as Array<Number> = [] as Array<Number>;   // up to three conditions ahead, soonest first
    var aheadLabels as Array<String> = [] as Array<String>;  // the hour under each, same length

    function hasLead() as Boolean {
        return leadKind != TwoSunsConfig.WEATHER_NONE || leadText.length() > 0;
    }

    function isEmpty() as Boolean {
        return !hasLead() && aheadKinds.size() == 0;
    }
}
