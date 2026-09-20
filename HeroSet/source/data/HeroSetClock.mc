import Toybox.Lang;

// Clock seam so store tests can advance days deterministically. The real
// clock reads the local calendar day.
class HeroSetClock {
    function initialize() {
    }

    function todayKey() as Lang.Number {
        return HeroSetCalendar.todayKey();
    }
}
