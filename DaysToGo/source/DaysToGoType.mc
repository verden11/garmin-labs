import Toybox.Graphics;
import Toybox.Lang;

// Type by role: each row's height cap, its fonts (largest first) and the sizes of the marks and unit letters
// drawn beside text. Split out of DaysToGoLayout (2026-10-05), which keeps the geometry.
class DaysToGoType {
    // Row height caps in thousandths of D. A row takes the largest font up to
    // its cap (or the smallest font, on a screen too small for the cap), and
    // the hero gets whatever height the other rows leave.
    static const TIME_MAX_PERMILLE = 130;
    // Beside the Instinct window the time may be taller: it has the band left of the window to itself (ADR-015).
    static const TIME_BESIDE_WINDOW_MAX_PERMILLE = 200;
    static const NAME_MAX_PERMILLE = 90;
    static const CAPTION_MAX_PERMILLE = 90;
    static const SMALL_MAX_PERMILLE = 80;

    // Fonts by role, largest first; DaysToGoDraw.line takes the first that fits.
    static const TIME_FONTS = [Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const HERO_NUMBER_FONTS = [Graphics.FONT_NUMBER_THAI_HOT, Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Array<Graphics.FontDefinition>;
    // Number fonts have no letters, so TODAY and SET A DATE use these.
    static const HERO_WORD_FONTS = [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    // Always-on hero: two sizes smaller than awake, to stay far under the 10% lit-pixel limit.
    static const SLEEP_HERO_FONTS = [Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Array<Graphics.FontDefinition>;
    static function heroFonts(word as Boolean, sleeping as Boolean) as Array<Graphics.FontDefinition> {
        if (word) {
            return HERO_WORD_FONTS;
        }
        return sleeping ? SLEEP_HERO_FONTS : HERO_NUMBER_FONTS;
    }

    // Pro's "8h 06m" (DaysToGoHoursHero): the letters are at most this share of the digits' font height, and
    // their box is lifted by this share of it so they sit on the digits' baseline (tuned on screenshots, 2026-10-05).
    static const HOURS_UNIT_MAX_PERMILLE = 450;
    static const HOURS_UNIT_LIFT_PERMILLE = 130;
    // A number font's ascent carries empty padding above the digits: the digits' ink is about this share of it (103 of
    // 151 px on the Venu X1's largest number font, measured off a screenshot, 2026-10-07). Used only to balance a
    // rectangle's spare height in ink (ADR-019); a wrong value moves the hero a few pixels, it never clips.
    static const HERO_DIGIT_INK_PERMILLE = 680;

    // Marks before a row's words (DaysToGoMark): height as a share of the row's font, centred this far down the
    // font's box (where its capitals sit), a gap after it, and the stroke as a share of the height (tuned on screenshots).
    static const MARK_SIZE_PERMILLE = 450;
    static const MARK_CENTER_PERMILLE = 560;
    static const MARK_GAP_PERMILLE = 400;
    static const MARK_PEN_DIVISOR = 5;
    static const MARK_MIN_PX = 6;

    static const NAME_FONTS = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const CAPTION_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const SMALL_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
}
