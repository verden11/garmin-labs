import Toybox.Application.Storage;
import Toybox.Lang;

// Storage seam: production code uses the persistent Toybox storage; unit
// tests inject an in-memory implementation. The store never talks to
// Toybox.Application.Storage directly.
class HeroSetStorage {

    function initialize() {
    }

    function getValue(key as Lang.String) as Lang.Object? {
        return null;
    }

    function setValue(key as Lang.String, value as Lang.Object) as Void {
    }
}

// Persistent backend. Storage.setValue may throw StorageFullException when
// the device flash is full; catching it here keeps the app alive and lets the
// store surface a visible "couldn't save" indicator instead of crashing
// mid-set.
class HeroSetPersistentStorage extends HeroSetStorage {

    function initialize() {
        HeroSetStorage.initialize();
    }

    function getValue(key as Lang.String) as Lang.Object? {
        return Storage.getValue(key);
    }

    function setValue(key as Lang.String, value as Lang.Object) as Void {
        Storage.setValue(key, value);
    }
}
