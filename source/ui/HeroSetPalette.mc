// Color roles shared by every screen (ADR-031). Roles, not hues: gold is
// what the user keeps (rank, XP, streak), blue is today's effort still
// under way (bars, the live count, reps being added), green is a finished
// goal. Blue vs gold is the pairing that stays distinct under red/green
// color blindness, and no state relies on color alone (full bars, DONE,
// "!" carry the same meaning).
class HeroSetPalette {
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    // Hints and secondary lines; DK_GRAY was too low-contrast on AMOLED (ADR-028).
    static const MUTED = 0xAAAAAA;
    // Unfilled ring and bar tracks.
    static const TRACK = 0x555555;
    static const GOLD = 0xFFAA00;
    // 0x55 red lifts the blue fill to 3:1 against TRACK (0x00AAFF was 2.91),
    // so a part-filled bar still reads; every channel stays MIP-safe.
    static const EFFORT = 0x55AAFF;
    static const DONE = 0x00FF00;
    static const ALERT = 0xFF0000;
}
