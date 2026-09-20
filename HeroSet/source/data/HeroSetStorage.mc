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

