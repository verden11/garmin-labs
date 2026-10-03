import Toybox.Lang;

// The numbers read from Toybox.Weather, as plain values, so the plan (TwoSunsWeatherPlan) is pure and testable
// without the module. Times are epoch seconds; temperatures are Celsius, as Garmin gives them.
(:pro)
class TwoSunsWeatherData {
    var condition as Number or Null = null;
    var feels as Numeric or Null = null;          // CurrentConditions.feelsLikeTemperature: wind chill or heat index
    var temperature as Numeric or Null = null;
    var observed as Number or Null = null;        // when the current conditions were observed
    var hourTimes as Array<Number> = [] as Array<Number>;
    var hourConditions as Array<Number or Null> = [] as Array<Number or Null>;
    var dayTimes as Array<Number> = [] as Array<Number>;
    var dayConditions as Array<Number or Null> = [] as Array<Number or Null>;
    var dayHighs as Array<Numeric or Null> = [] as Array<Numeric or Null>;
    var dayLows as Array<Numeric or Null> = [] as Array<Numeric or Null>;

    // Nothing at all came back (a phone that never synced): not a reading, so the source keeps its last good one.
    function isEmpty() as Boolean {
        return condition == null && feels == null && temperature == null && hourTimes.size() == 0 && dayTimes.size() == 0;
    }
}
