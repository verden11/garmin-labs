import Toybox.Application.Storage;
import Toybox.Lang;

// Persistent backend. Storage.setValue may throw StorageFullException when
// the device flash is full; it propagates on purpose — HeroSetStore._set
// catches it and surfaces a visible "couldn't save" indicator instead of
// crashing mid-set.
class HeroSetPersistentStorage extends HeroSetStorage {

    function initialize() {
        HeroSetStorage.initialize();
    }

    function getValue(key as Lang.String) as Storage.ValueType? {
        return Storage.getValue(key);
    }

    function setValue(key as Lang.String, value as Storage.ValueType) as Void {
        Storage.setValue(key, value);
    }
}
