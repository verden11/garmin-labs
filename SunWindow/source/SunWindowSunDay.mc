import Toybox.Lang;

// What the sun does on one local day, for the one line the app draws (45 degrees): either a window between two whole
// minutes of the local day, or none (the highest sun stays under the line). Declination and equation of time are those
// of local solar noon: the full view's path uses them, and tests read them.
(:glance)
class SunWindowSunDay {
    var hasWindow as Boolean;
    var open as Number;          // first whole local minute with the sun at or above the line (ceil of the crossing)
    var close as Number;         // last whole local minute (floor of the crossing); both 0 when there is no window
    var declination as Double;   // radians, at local solar noon
    var equation as Double;      // equation of time at local solar noon, minutes

    function initialize(hasWindow as Boolean, open as Number, close as Number, declination as Double, equation as Double) {
        self.hasWindow = hasWindow;
        self.open = open;
        self.close = close;
        self.declination = declination;
        self.equation = equation;
    }
}
