import Toybox.Application;
import Toybox.Lang;
import Toybox.Position;
import Toybox.Time;
import Toybox.WatchUi;

// The one class that asks the watch where it is, and the only one that writes Storage (the place, rounded to 0.1 degree,
// kept on the watch and never sent anywhere). Foreground only: the glance never calls Position (ADR-010). Position.getInfo()
// is the one source that gave a place on the owner's FR965 (probe, 2026-10-05: a last-known fix at once, accuracy 1);
// Activity.currentLocation and the weather observation location were null there (TwoSuns ADR-005). Calling it without the
// Positioning permission kills the app and cannot be caught: the manifest declares it.
class SunWindowSources {
    private var _askedAt as Number = 0;   // epoch seconds of the last one-shot request; 0 = none yet
    private var _failed as Boolean = false;

    // On show: take the watch's cached fix if there is one (it also moves a remembered place after travel); with no
    // place at all, ask for one.
    function refresh() as Void {
        takeCachedFix();
        if (storedPlace() == null && _askedAt == 0) {
            ask();
        }
    }

    // The watch's cached fix, kept when it is usable. Cheap: each minute's tick calls it.
    function takeCachedFix() as Void {
        try {
            remember(usable(Position.getInfo()));
        } catch (e instanceof Lang.Exception) {
            // No position service: the full view says so in words.
        }
    }

    // START: ask for a fresh fix (a no-fix state retries).
    // Ignored while a request is already out (on touch watches every tap is a START).
    function ask() as Void {
        var now = Time.now().value();
        if (_askedAt > 0 && !_failed && now - _askedAt < SunWindowConfig.LOCATE_SECONDS) {
            return;
        }
        _askedAt = now;
        _failed = false;
        try {
            Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
        } catch (e instanceof Lang.Exception) {
            _failed = true;   // no position service: the full view says "No place yet"
        }
    }

    function onPosition(info as Position.Info) as Void {
        var fix = usable(info);
        _failed = fix == null;
        remember(fix);
        WatchUi.requestUpdate();
    }

    // onHide also runs when the accent menu or a system overlay covers the view, so a request still waiting for its answer
    // is forgotten here and asked again on the next show.
    function stop() as Void {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        if (storedPlace() == null && !_failed) {
            _askedAt = 0;
        }
    }

    // True while a request is out, has no place to show for it, and is still inside LOCATE_SECONDS.
    function locating() as Boolean {
        return storedPlace() == null && _askedAt > 0 && !_failed && Time.now().value() - _askedAt < SunWindowConfig.LOCATE_SECONDS;
    }

    function failed() as Boolean {
        return storedPlace() == null && _askedAt > 0 && (_failed || Time.now().value() - _askedAt >= SunWindowConfig.LOCATE_SECONDS);
    }

    private function storedPlace() as Array<Float> or Null {
        return SunWindowPlace.fromStorage(Application.Storage.getValue(SunWindowConfig.KEY_PLACE));
    }

    // A fix as a rounded place, or null when it has no position, is below the quality bar or is a placeholder.
    private function usable(info as Position.Info) as Array<Float> or Null {
        var position = info.position;
        if (position == null || info.accuracy < SunWindowConfig.MIN_FIX_QUALITY) {
            return null;
        }
        var pair = position.toDegrees();
        return SunWindowPlace.pick([[pair[0].toFloat(), pair[1].toFloat()] as Array<Float>] as Array<Array<Float> or Null>);
    }

    // Saved only when it moved more than 0.1 degree: no writes for jitter.
    private function remember(fix as Array<Float> or Null) as Void {
        if (fix == null || !SunWindowPlace.shouldReplace(storedPlace(), fix)) {
            return;
        }
        try {
            Application.Storage.setValue(SunWindowConfig.KEY_PLACE, [fix[0], fix[1]] as Array<Application.Storage.ValueType>);
        } catch (e instanceof Lang.Exception) {
            // A full or failing store only loses the memory; the next draw reads what is stored.
        }
    }
}
