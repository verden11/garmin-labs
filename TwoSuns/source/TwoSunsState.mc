import Toybox.Lang;

// Everything the view draws, already in words. The view never computes.
class TwoSunsState {
    var time as String = "";
    var dateLines as Array<String> = [] as Array<String>;   // longest first
    var showDate as Boolean = true;
    var batteryText as String = "";                          // "62" or "--"
    var batteryLevel as Number or Null = null;               // 0 to 100 when the value is a number, for the level pill
    var batteryStale as Boolean = false;
    var curve as TwoSunsBatteryCurve or Null = null;         // null: no curve to draw
    var skyLine as String = "";                              // the full sentence
    var skyLines as Array<String> = [] as Array<String>;     // longest first: the full sentence, then a shorter wording when there is one
    var sky as TwoSunsSky = new TwoSunsSky();
    var nowMinute as Number = 0;                             // local minutes since midnight
    var accent as Number = TwoSunsPalette.ACCENTS[0];
    var goldenArc as Boolean = false;
    var weatherOn as Boolean = false;                        // Pro: the Weather setting (the row may still have no data)                        // the Golden hour setting
    var orientation as Number = TwoSunsConfig.ORIENTATION_NOON_TOP;
    var watchBattery as Number or Null = null;               // Pro: the watch's own charge, 0 to 100, null when the Battery setting is off
    var weather as TwoSunsWeather or Null = null;           // Pro: the weather row, null when there is nothing to show
}
