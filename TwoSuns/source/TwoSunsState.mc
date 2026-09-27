import Toybox.Lang;

// Everything the view draws, already in words. The view never computes.
class TwoSunsState {
    var time as String = "";
    var dateLines as Array<String> = [] as Array<String>;   // longest first
    var showDate as Boolean = true;
    var batteryText as String = "";                          // "62" or "--"
    var batteryLevel as Number or Null = null;               // 0 to 100 when the value is a number, for the level pill
    var batteryStale as Boolean = false;
    // The colour the value, pill and dot draw in: the chosen accent when the level is fresh and not low,
    // dim(accent) when it is fresh but low (see TwoSunsConfig.BATTERY_LOW_THRESHOLD). Stale overrides both
    // with a plain muted grey, drawn by the view itself, not carried here.
    var batteryAccent as Number = TwoSunsPalette.ACCENTS[0];
    var curve as TwoSunsBatteryCurve or Null = null;         // null: no curve to draw
    var skyLine as String = "";                              // the full sentence
    var skyLines as Array<String> = [] as Array<String>;     // longest first: the full sentence, then a shorter wording when there is one
    var sky as TwoSunsSky = new TwoSunsSky();
    var nowMinute as Number = 0;                             // local minutes since midnight
    var accent as Number = TwoSunsPalette.ACCENTS[0];
    var goldenArc as Boolean = false;                        // the Golden hour setting
    var orientation as Number = TwoSunsConfig.ORIENTATION_NOON_TOP;
}
