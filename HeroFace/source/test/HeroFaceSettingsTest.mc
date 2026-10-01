import Toybox.Application;
import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.Test;

// The two tiers' settings (docs/decisions.md ADR-001, the Free + Pro ladder). HeroFaceSettings reads the live
// Properties, which in the simulator start from the build's own properties.xml, so these check what each
// build declares and what it falls back to.

// Pro: every key is declared, with the shipped defaults (properties.xml): Auto slots, no seconds, temperature on.
(:test, :pro)
function proSettingsReadTheirDefaults(logger as Test.Logger) as Boolean {
    var s = new HeroFaceSettings();
    Test.assertEqual(s.mode, HeroFaceConfig.MODE_AUTO);
    Test.assertEqual(s.accent, HeroFacePalette.ACCENTS[0]);
    Test.assertEqual(s.slots.size(), HeroFaceConfig.SLOT_CHAINS.size());
    for (var i = 0; i < s.slots.size(); i++) {
        Test.assertEqual(s.slots[i], HeroFaceConfig.METRIC_AUTO);
    }
    Test.assertEqual(s.seconds, false);
    Test.assertEqual(s.weather, true);
    return true;
}

// Free: Slot1-3, Seconds and Weather are not in the Free properties file and the Free code never asks for them, so
// the slots are Auto, there are no seconds and no temperature, whatever the phone app holds.
(:test, :free)
function freeReturnsDefaultsForProKeys(logger as Test.Logger) as Boolean {
    var s = new HeroFaceSettings();
    Test.assertEqual(s.mode, HeroFaceConfig.MODE_AUTO);
    Test.assertEqual(s.accent, HeroFacePalette.ACCENTS[0]);
    Test.assertEqual(s.slots.size(), HeroFaceConfig.SLOT_CHAINS.size());
    for (var i = 0; i < s.slots.size(); i++) {
        Test.assertEqual(s.slots[i], HeroFaceConfig.METRIC_AUTO);
    }
    Test.assertEqual(s.seconds, false);
    Test.assertEqual(s.weather, false);
    // Through the real reader: no seconds text, no temperature.
    var kinds = HeroFaceMetrics.resolve(s.slots, ActivityMonitor.getInfo());
    var state = HeroFaceReadings.take(s, kinds, new HeroFaceStreak(), new HeroFaceLink(), s.seconds);
    Test.assert(state.seconds == null);
    Test.assert(state.temperature == null);
    return true;
}

// The assumption the Free build leans on (SDK 9.2.0 docs: getValue throws InvalidKeyException for a key the properties
// file does not define). Free code never reads these five keys, so nothing depends on it; this test records what the
// simulator does. If it fails, only this test is wrong: the shipped Free paths do not call getValue for them.
(:test, :free)
function freeMissingPropertyKeyThrows(logger as Test.Logger) as Boolean {
    var keys = ["Slot1", "Slot2", "Slot3", "Seconds", "Weather"] as Array<String>;
    for (var i = 0; i < keys.size(); i++) {
        var threw = false;
        try {
            Application.Properties.getValue(keys[i]);
        } catch (e instanceof Application.Properties.InvalidKeyException) {
            threw = true;
        }
        Test.assertMessage(threw, "getValue of " + keys[i] + ", missing from the Free properties file, did not throw");
    }
    return true;
}
