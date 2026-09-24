import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.Test;

// Storage that refuses one key, as a full flash would refuse the write that
// tipped it over.
class HeroSetFailingStorage extends HeroSetTestStorage {

    var failingKey as Lang.String;

    function initialize(key as Lang.String) {
        HeroSetTestStorage.initialize();
        failingKey = key;
    }

    function setValue(key as Lang.String, value as Storage.ValueType) as Void {
        if (key.equals(failingKey)) {
            throw new Lang.OperationNotAllowedException("storage full");
        }
        HeroSetTestStorage.setValue(key, value);
    }
}

// The count write fails but the XP and credit writes after it succeed; the
// footer must still say COULD NOT SAVE (ADR-010), until the next save that
// writes cleanly.
(:test)
function aFailedWriteStaysFlaggedThroughTheRestOfTheSave(logger as Test.Logger) as Lang.Boolean {
    var store = new HeroSetStore(new HeroSetFailingStorage("hero_pushups"), new HeroSetTestClock());
    store.add(:pushups, 5);
    Test.assert(store.hasWriteFailure());
    store.add(:situps, 5);
    Test.assert(!store.hasWriteFailure());
    return true;
}

// The on-watch log viewer reads these as mmdd, so September stays four
// digits wide.
(:test)
function validationLogLinesAreMonthDayLabelCountsError(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    store.logValidationTrial(:pushups, 10, 12);
    store.logValidationTrial(:squats, 9, 7);
    var log = store.getValidationLog();
    Test.assertEqual(log[0], "0911 PU 10->12 +2");
    Test.assertEqual(log[1], "0911 SQ 9->7 -2");
    return true;
}
