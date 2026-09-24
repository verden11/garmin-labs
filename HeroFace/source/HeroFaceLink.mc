import Toybox.Application;
import Toybox.Complications;
import Toybox.Lang;
import Toybox.WatchUi;

// HeroSet's private complication (CIQ 4.2+, same developer key). Everything
// Complications-related sits behind `Toybox has :Complications`, so the same
// build runs on CIQ 3.x watches, where the link simply never connects.
class HeroFaceLink {

    // Only ever set on CIQ 4.2+; the type name alone is safe on older watches.
    private var _id as Complications.Id?;
    // Last value seen, cached so the face still has it after a reboot while
    // HeroSet isn't running to republish.
    private var _raw as String?;
    // Bumped on every change, so a frame cached this minute knows it is stale.
    private var _version as Number = 0;

    function initialize() {
        var cached = Application.Storage.getValue(HeroFaceConfig.HEROSET_KEY);
        _raw = cached instanceof String ? cached : null;
    }

    // Called at start and, while unlinked, once a minute: a face that is
    // already running when HeroSet gets installed links without a restart.
    function start() as Void {
        if (!(Toybox has :Complications)) {
            return;
        }
        var found = find();
        var id = found != null ? found.complicationId : null;
        if (found == null || id == null) {
            return;
        }
        try {
            Complications.registerComplicationChangeCallback(method(:onComplicationChanged));
            Complications.subscribeToUpdates(id);
        } catch (e instanceof Lang.Exception) {
            // Subscribing is the whole link; without it the face stays in
            // Everyday mode rather than failing to start.
            return;
        }
        _id = id;
        remember(found.value);
    }

    function isLinked() as Boolean {
        return _id != null;
    }

    function version() as Number {
        return _version;
    }

    // [push, sit, squat, rank, rankPercent, streak, goal] (HeroFaceContract), or
    // null when HeroSet isn't installed or hasn't published yet.
    function progress(today as Number, yesterday as Number) as Array<Number>? {
        return _id != null ? HeroFaceContract.parse(_raw, today, yesterday) : null;
    }

    // Hold-to-launch HeroSet from the face. False when there's nothing to open.
    function open() as Boolean {
        var id = _id;
        if (id == null || !(Complications has :exitTo)) {
            return false;
        }
        try {
            Complications.exitTo(id);
            return true;
        } catch (e instanceof Lang.Exception) {
            // AppNotInstalledException only exists on 4.2+, so it can't be named
            // here; any failure just means the press isn't handled.
            return false;
        }
    }

    function onComplicationChanged(id as Complications.Id) as Void {
        try {
            remember(Complications.getComplication(id).value);
        } catch (e instanceof Lang.Exception) {
            // ComplicationNotFoundException: HeroSet was uninstalled and the
            // system already dropped the subscription. Fall back to Everyday.
            _id = null;
            _raw = null;
            _version += 1;
            Application.Storage.deleteValue(HeroFaceConfig.HEROSET_KEY);
        }
        WatchUi.requestUpdate();
    }

    private function find() as Complications.Complication? {
        var iterator = Complications.getComplications();
        var complication = iterator.next();
        while (complication != null) {
            if (HeroFaceConfig.HEROSET_COMPLICATION_LABEL.equals(complication.longLabel)) {
                return complication;
            }
            complication = iterator.next();
        }
        return null;
    }

    private function remember(value as Object?) as Void {
        if (value instanceof String && !value.equals(_raw)) {
            _raw = value;
            _version += 1;
            Application.Storage.setValue(HeroFaceConfig.HEROSET_KEY, value);
        }
    }
}
