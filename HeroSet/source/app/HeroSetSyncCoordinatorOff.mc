import Toybox.Lang;

// Store build stand-in (ADR-033): no Fit permission, so nothing may record
// until Connect sync passes device acceptance (ADR-043). Same interface as
// the dev-build class, so callers don't branch on the build.
(:nosync)
class HeroSetSyncCoordinator {

    function initialize(store as HeroSetStore) {
    }

    function beginSet(exercise as Lang.Symbol) as Void {
    }

    function resumeSet() as Void {
    }

    function pauseSet() as Void {
    }

    function setSaved(reps as Lang.Number) as Void {
    }

    function stop() as Void {
    }

    function setEnabled(enabled as Lang.Boolean) as Void {
    }
}
