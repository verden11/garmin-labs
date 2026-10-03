// The Instinct palette (ADR-055): the display shows black and white only, and
// how it would round any other color is unspecified, so no role leans on it.
// Every role is white on black; what colour said on the other products,
// the screens say with shape and words instead: an outlined track under a
// solid fill, DONE spelled out, signs on every delta. Same class name and
// roles as HeroSetPalette, selected per product by the `color`/`mono`
// annotations in the jungles.
(:glance :mono)
class HeroSetPalette {
    // True where tracks must be drawn as outlines, because "dim" does not exist.
    static const MONO = true;
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xFFFFFF;
    static const TRACK = 0xFFFFFF;
    static const GOLD = 0xFFFFFF;
    static const EFFORT = 0xFFFFFF;
    static const DONE = 0xFFFFFF;
    static const ALERT = 0xFFFFFF;
}
