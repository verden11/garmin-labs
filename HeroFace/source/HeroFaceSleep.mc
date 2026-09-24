import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

// AMOLED always-on: Garmin allows at most 10% of pixels lit and no pixel lit
// for more than 3 minutes. So only a dim time, no ring or bars, and the whole
// block steps across a 3 x 3 grid once a minute.
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
