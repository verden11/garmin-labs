import Toybox.Lang;

// Everything one draw needs, decided by pure functions from the clock, the stored place and the watch's weather
// (SunWindowReader.build). No colour is chosen here: the state is a word and a shape (DESIGN.md "Colour rule").
(:glance)
class SunWindowState {
    var kind as Number;
    var day as SunWindowSunDay or Null = null;   // null while there is no place
    var minuteOfDay as Number = 0;
    var offsetMinutes as Number = 0;
    var latitude as Double = 0.0d;
    var longitude as Double = 0.0d;
    var skyKnown as Boolean = true;              // false: the watch gave no UV reading ("No weather" under OPEN)

    function initialize(kind as Number) {
        self.kind = kind;
    }

    function isClosed() as Boolean {
        return kind == SunWindowConfig.STATE_CLOSED_BEFORE || kind == SunWindowConfig.STATE_CLOSED_AFTER || kind == SunWindowConfig.STATE_CLOSED_SKY;
    }

    // The diagram and the times need a place and a day.
    function hasSun() as Boolean {
        return day != null;
    }

    function hasWindow() as Boolean {
        var d = day;
        return d != null && d.hasWindow;
    }
}
