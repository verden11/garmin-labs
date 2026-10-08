import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

// Always-on where the watch reports requiresBurnInProtection (the AMOLEDs; in the simulator also the Venu Sq LCD):
// only a dim time, no ring or bars, and the whole block steps across a 3 x 3 grid once a minute. Garmin's lit-pixel and
// dwell limits are unverified here (watch-design-kit platform-facts.md); the evidence is the simulator heat map
// (DESIGN.md "Always-On Time").
class HeroFaceSleep {

    static function draw(dc as Graphics.Dc, layout as HeroFaceLayout) as Void {
        dc.setColor(HeroFacePalette.SLEEP_TEXT, HeroFacePalette.BACKGROUND);
        dc.clear();
        var clock = System.getClockTime();
        var grid = HeroFaceConfig.BURN_IN_GRID;
        var step = HeroFaceConfig.BURN_IN_STEP_PX;
        var dx = (clock.min % grid - 1) * step;
        var dy = (clock.min / grid % grid - 1) * step;
        var font = Graphics.FONT_NUMBER_MEDIUM;
        var time = HeroFaceReadings.timeText(clock.hour, clock.min, System.getDeviceSettings().is24Hour);
        var y = layout.centerY() - dc.getFontHeight(font) / 2 + dy;
        dc.drawText(layout.centerX() + dx, y, font, time, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
