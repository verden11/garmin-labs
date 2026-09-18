import Toybox.Lang;

// Store build stand-in (ADR-033): v1 ships without Connect sync because the
// watch saved more than one activity a day (ADR-030), and without the Fit
// permission a sync feature would need. Same interface as the dev-build
// class, so callers don't branch on the build.
(:nosync)
class HeroSetSyncCoordinator {

    static function beginSet(sync as HeroSetActivitySync) as Void {
    }

    static function setEnabled(enabled as Lang.Boolean) as Void {
    }
}
