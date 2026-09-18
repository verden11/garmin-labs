import Toybox.Lang;

// Store build stand-in for the recording wrapper (ADR-033): records nothing.
(:nosync)
class HeroSetActivitySync {

    function beginSet() as Lang.Number {
        return 0;
    }

    function endSet() as Void {
    }

    function closeOpenSession() as Lang.Number {
        return 0;
    }
}
