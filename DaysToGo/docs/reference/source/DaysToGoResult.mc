import Toybox.Lang;

// What one event says about "now". Plain data: the view formats it.
class DaysToGoResult {
    var phase as Number;
    var days as Number;      // UPCOMING: days left. PAST: days since.
    var seconds as Number;   // HOURS only
    // The calendar date the count is aimed at, for the small date line.
    var year as Number;
    var month as Number;
    var day as Number;

    function initialize(phase as Number, days as Number, seconds as Number, year as Number, month as Number, day as Number) {
        self.phase = phase;
        self.days = days;
        self.seconds = seconds;
        self.year = year;
        self.month = month;
        self.day = day;
    }
}
