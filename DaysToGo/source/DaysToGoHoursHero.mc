import Toybox.Graphics;
import Toybox.Lang;

// Pro's last 24 hours as "8h 06m": the digits in the hero's number font, the unit letters in a small
// letter font (number fonts have no letters). "8:06" under the time read as a second clock (ROADMAP 13.2).
class DaysToGoHoursHero {

    // Between "8h" and "06m": two spaces of the letter font, so the hours do not run into the minutes.
    private static const GAP = "  ";

    // Same contract as DaysToGoDraw.line for a hero "H:MM": the largest font whose whole group fits the band and
    // the chord, else the smallest.
    static function draw(dc as Graphics.Dc, layout as DaysToGoLayout, radius as Number, top as Number, bandHeight as Number,
                         fonts as Array<Graphics.FontDefinition>, hero as String, dx as Number) as Void {
        var colon = hero.find(":");
        if (colon == null) {
            DaysToGoDraw.line(dc, layout, radius, top, bandHeight, fonts, [hero] as Array<String>, dx);
            return;
        }
        var parts = [hero.substring(0, colon) as String, hero.substring(colon + 1, hero.length()) as String] as Array<String>;
        var units = unitWords();
        for (var f = 0; f < fonts.size(); f++) {
            var height = dc.getFontHeight(fonts[f]);
            var y = top + (bandHeight - height) / 2;
            var unitFont = unitFontFor(dc, height);
            var width = groupWidth(dc, fonts[f], unitFont, parts, units);
            var room = layout.rightInsetWithin(radius, y, height) - layout.leftInsetWithin(radius, y, height);
            if ((height <= bandHeight && width <= room) || f == fonts.size() - 1) {
                drawGroup(dc, layout, layout.rowCenterX(y, height) + dx - width / 2, y, height, fonts[f], unitFont, parts, units);
                return;
            }
        }
    }

    private static function drawGroup(dc as Graphics.Dc, layout as DaysToGoLayout, left as Number, y as Number, height as Number,
                                      font as Graphics.FontDefinition, unitFont as Graphics.FontDefinition,
                                      parts as Array<String>, units as Array<String>) as Void {
        var unitY = unitTop(dc, y, height, font, unitFont);
        var x = left;
        for (var i = 0; i < parts.size(); i++) {
            x = drawLeft(dc, layout, x, y, font, parts[i]);
            x = drawLeft(dc, layout, x, unitY, unitFont, units[i]);
            if (i < parts.size() - 1) {
                x += dc.getTextWidthInPixels(GAP, unitFont);
            }
        }
    }

    // The letters sit on the digits' baseline: the fonts' ascents where the API has them, else a measured lift.
    private static function unitTop(dc as Graphics.Dc, y as Number, height as Number, font as Graphics.FontDefinition,
                                    unitFont as Graphics.FontDefinition) as Number {
        if (Graphics has :getFontAscent) {
            // Kept inside the hero's own box: a letter font's padding below its baseline can be deeper than the digits'.
            var top = y + Graphics.getFontAscent(font) - Graphics.getFontAscent(unitFont);
            var lowest = y + height - dc.getFontHeight(unitFont);
            return top > lowest ? lowest : top;
        }
        return y + height - dc.getFontHeight(unitFont) - height * DaysToGoLayout.HOURS_UNIT_LIFT_PERMILLE / DaysToGoConfig.PERMILLE;
    }

    // Draws `str` from `x` (through DaysToGoDraw.text, so the fit test sees its box) and returns where it ends.
    private static function drawLeft(dc as Graphics.Dc, layout as DaysToGoLayout, x as Number, y as Number,
                                     font as Graphics.FontDefinition, str as String) as Number {
        var width = dc.getTextWidthInPixels(str, font);
        DaysToGoDraw.text(dc, layout, x + width / 2, y, font, str, Graphics.TEXT_JUSTIFY_CENTER);
        return x + width;
    }

    private static function groupWidth(dc as Graphics.Dc, font as Graphics.FontDefinition, unitFont as Graphics.FontDefinition,
                                       parts as Array<String>, units as Array<String>) as Number {
        var width = dc.getTextWidthInPixels(GAP, unitFont);
        for (var i = 0; i < parts.size(); i++) {
            width += dc.getTextWidthInPixels(parts[i], font) + dc.getTextWidthInPixels(units[i], unitFont);
        }
        return width;
    }

    // The largest letter font no taller than a share of the digits' font.
    private static function unitFontFor(dc as Graphics.Dc, heroHeight as Number) as Graphics.FontDefinition {
        return DaysToGoDraw.fontUpTo(dc, DaysToGoLayout.HERO_WORD_FONTS, heroHeight * DaysToGoLayout.HOURS_UNIT_MAX_PERMILLE / DaysToGoConfig.PERMILLE);
    }

    // Pro only: timed events are Pro (docs/decisions.md ADR-018); the letters are in resources-pro/strings/units.xml.
    (:pro)
    private static function unitWords() as Array<String> {
        return [DaysToGoText.get(Rez.Strings.unit_hours), DaysToGoText.get(Rez.Strings.unit_minutes)] as Array<String>;
    }

    (:free)
    private static function unitWords() as Array<String> {
        return ["", ""] as Array<String>;
    }
}
