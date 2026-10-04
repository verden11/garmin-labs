---
name: Two Suns
description: The time on black, a 24-hour sky ring round the bezel, and the day's Body Battery as a curve under it, drawn with primitives and system fonts.
colors:
  ground: "#000000"
  text: "#FFFFFF"
  muted: "#AAAAAA"
  sleep-text: "#5555AA"
  night: "#5555AA"
  twilight: "#AAAAFF"
  golden: "#FF5500"
  curve-fill: "#5555AA"
  curve-fill-stale: "#555555"
  accent-sky: "#55AAFF"
  accent-mint: "#55FFAA"
  accent-autumn: "#FFAA00"
  accent-violet: "#AA55FF"
  accent-pink: "#FF55AA"
  accent-winter: "#FFFFFF"
typography:
  time:
    fontFamily: "Graphics.FONT_NUMBER_HOT → FONT_NUMBER_MEDIUM → FONT_NUMBER_MILD"
    fontSize: "largest whose height is under 23% of the shorter screen side"
  value:
    fontFamily: "Graphics.FONT_SMALL → FONT_TINY → FONT_XTINY"
    fontSize: "largest under 8% of the shorter side"
  sun-line:
    fontFamily: "Graphics.FONT_TINY → FONT_XTINY"
    fontSize: "largest under 7.5% of the shorter side; longest wording that fits the chord"
  date:
    fontFamily: "Graphics.FONT_TINY → FONT_XTINY"
    fontSize: "largest under 6% of the shorter side"
  sleep-time:
    fontFamily: "Graphics.FONT_NUMBER_MEDIUM → FONT_NUMBER_MILD"
    fontSize: "two sizes below awake"
spacing:
  d: "min(width,height)"
  ring-width: "d × 0.025"
  ring-gap: "d × 0.010"
  text-margin: "d × 0.020"
  row-gap: "d × 0.014"
  span: "0.8 of the content circle's height, centred"
  band-gap: "d × 0.025"
components:
  sky-ring:
    textColor: "{colors.night}"
    height: "{spacing.ring-width}"
  energy-curve:
    textColor: "{colors.curve-fill}"
---

# Design

The visual system **as built** (2026-09-26). **The owner has not approved the look**, the rectangular screens have not been looked at by eye, the launcher icon is a placeholder, and **no screenshot of the face exists** (this environment cannot capture the simulator). Everything here is read from the code and the simulator's layout report; nothing has been seen on a watch. The owner may replace the direction with a design-tool mock-up ([`docs/archive/plan.md`](docs/archive/plan.md) phase 4 gate); then this file and the spec change.

## Direction

**Two suns.** Black ground. The time is the hero. Around the bezel a 24-hour ring is the sky's sun; under the time the watch's Body Battery for the last 24 hours is a curve; one sentence at the bottom is the light left or the next sunrise. One accent colour, chosen in settings, carries both "daylight still to come" and the Body Battery value. A state is never colour alone.

## Rows, top to bottom

watch battery (muted, optional, Pro) · date (muted, optional) · **time** · weather (Pro) · Body Battery band = [bolt gauge] [value] [curve] · sun sentence.

Each row takes the largest font up to a height cap (share of D, the shorter screen side); the rows are then stacked from their measured heights and centred (Days To Go ADR-012). Every text is measured against the round chord at its row: the sun sentence steps down through its wordings (full, shorter, shortest) and fonts, and only when nothing fits does it end in "...". Rectangular screens (Venu Sq 2, Sq 2 Music, Venu X1) keep the round design centred and sized by D; not approved by eye.

**Drop order** when the stack is taller than the span (800 permille of the content circle): the date, then the curve, then the sun line. The time and the Body Battery value never drop. A curve whose chord width is under 180 permille of D is dropped too; the glyph and value stay.

Sample, `fr965` (454 px, simulator layout report, 2026-09-26): ring radius 218, ring width 11, content radius 204, span 326; time box 168 by 103 px at y=148; band at y=257 to 306 with the glyph 36 by 20, the value box 37 px tall and the curve 236 by 49; sun line 37 px tall at y=312.

## Ring encoding

Minutes of the local day, 4 minutes to a degree (marker and tick precision about +-1 degree), clockwise, noon at the top by default (setting: midnight at the top). Drawn in this order, later on top of earlier:

| Layer | Colour | When |
|---|---|---|
| Night track, the whole circle | `#5555AA` | always |
| Civil twilight | `#AAAAFF` | with a place: from the calculated dawn to sunrise and sunset to dusk; the whole stretch on a polar-night day |
| Daylight already gone | the accent with each `FF` channel dropped to `AA` | sunrise to now |
| Daylight still to come | the accent | now to sunset |
| Golden hour | `#FF5500` | Golden hour setting on, and a place is known: after sunrise and before sunset |
| Sunrise and sunset ticks | white, 2 px, across the ring | when the time exists |
| Sun marker at now | white, black halo | solid when the sun is up (day, midnight sun), an outline when it is not |

No place and no sun data: a plain night track and no marker. Midnight sun: fully lit. Polar night: dim, with twilight if it can be calculated. A missing sunrise or sunset (a transition day) runs the daylight to the edge of the day and gets no tick. An arc under one degree still draws.

## Energy curve, glyph and value

- **Curve.** 96 buckets of 15 minutes across the band, x by bucket, y by level from 0 (bottom) to 100 (top). A fill in `#5555AA` (fresh) or `#555555` (stale), a white line over it (`#AAAAAA` when stale), a gap where a bucket has no sample (never interpolated). The newest point is a solid dot, in the current battery colour (below), or an outline dot when stale. Width up to 520 permille of D.
- **Glyph.** A bolt gauge (ADR-023, replacing the level pill of 2026-09-27): a dim `#555555` bolt filled from the bottom to the level in the current battery colour, the fill clipped to the bolt's own edges; as tall as the value font, 0.6 as wide. Hollow (a muted outline, no fill) when the value is stale or `--`. Chosen so it cannot be mistaken for the watch battery row (a rectangle with a nub). Never seen on a screen.
- **Value and current battery colour.** The accent when the level is at or above 30 (`TwoSunsConfig.BATTERY_LOW_THRESHOLD`); `dim(accent)` below it (ADR-008 amendment, 2026-09-27) — the same dim the ring uses for daylight already gone, so it stays the same hue, one step darker, never a different colour. `#AAAAAA` when stale (overrides the level colour), `--` when there is no valid sample. Applies to the value text, the pill's fill and the curve's current-point dot; the curve's own fill and line colours do not change with the current level, since they show the last 24 hours, not just now.
- **Stale is a shape as well as a colour**: hollow glyph, outline dot.
- Never any face, mood, verdict word, hue change or threshold shown in words ([ADR-008](docs/decisions.md#adr-008-no-verdicts-on-body-battery)).

## Palette and contrast

All values have channels 00, 55, AA or FF, the device-safe palette (why: see `watch-design-kit`'s `watch-design-lead` skill). Contrast ratios below are **computed from the hex values against black (WCAG formula), not measured on a screen**.

| Colour | Hex | Against black |
|---|---|---|
| Text, white accent | `#FFFFFF` | 21.0 : 1 |
| Muted | `#AAAAAA` | 9.0 : 1 |
| Night track, curve fill (fresh), always-on text | `#5555AA` | 3.3 : 1 |
| Twilight | `#AAAAFF` | 9.9 : 1 |
| Golden hour | `#FF5500` | 6.6 : 1 |
| Stale curve fill (awake only) | `#555555` | 2.8 : 1 |

Accents (default first) and their "gone" form: sky `#55AAFF` 8.6 : 1 → `#55AAAA` 7.7 (default, chosen 2026-09-27 over the old amber default: blue carries no "status" meaning, so it never misreads as a low value); mint `#55FFAA` 16.3 → `#55AAAA` 7.7; autumn (the old "amber", renamed not recoloured) `#FFAA00` 11.0 → `#AAAA00` 8.5; violet `#AA55FF` 5.5 → `#AA55AA` 4.6; pink `#FF55AA` 7.1 → `#AA55AA` 4.6; winter (the old "white") `#FFFFFF` 21.0 → `#55AAAA` 7.7 (nudged from the naive `#AAAAAA`, which is bit-identical to MUTED/stale — see "watch-design-reviewer findings, 2026-09-27" below). The unit test `dimPartsStayReadable` asserts at least 3:1 for the night track and for every accent's gone form; `dimNeverEqualsMuted` (new) asserts no accent's gone form ever equals MUTED.

Always-on text is `#5555AA`, 3.3:1 (fixed 2026-09-27, ADR-007 amendment, `docs/decisions.md`). Stale curve fill stays `#555555`, 2.8:1 (awake-only, carried by shape too); still worth a look-approval check in daylight on a MIP watch. `TwoSunsPalette.TRACK` (`#555555`) is defined but no code draws it.

## Accent ids, and the Free build (ADR-020, accepted 2026-10-04, UNRELEASED)

Accent ids are **append-only**: a shipped id never changes its colour (`shippedAccentIdsKeepTheirColours`), an unknown or out-of-range id draws the default (id 0). Both tiers offer ids 0 to 5, the shipped list: 0 sky `#55AAFF` (default), 1 mint `#55FFAA`, 2 autumn `#FFAA00`, 3 violet `#AA55FF`, 4 pink `#FF55AA`, 5 winter `#FFFFFF`. The plan's ids 6 to 11 are **deferred, not built**; when they land they are Pro only and appended: 6 cyan `#00FFFF`, 7 lime `#55FF55`, 8 yellow `#FFFF55`, 9 magenta `#FF55FF`; orange and coral are **not admitted** for this face (golden hour is `#FF5500`, and no accent or dimmed accent may equal it: `noAccentIsTheGoldenHourColour`). Amber, orange, coral and red are never the default on a Body Battery face (ADR-017, ring, curve and glyph encodings, the amber-read-as-"low" lesson). The accent tests check every channel is 00/55/AA/FF and the accent and its dimmed form are at least 3:1 on black.

The Free build draws the same face with fewer parts: no curve, no date row, no twilight or golden-hour arc, noon at the top; the time, the level pill with Garmin's number (or `--` and a hollow pill), the ring from Garmin's own sunrise and sunset, and the sun sentence. Because the date row and the curve are absent the rows re-stack from the same measured fonts (ADR-016, rows follow font heights), so the time and the band sit differently from Pro's default. **No mockup, screenshot or look approval exists for that layout**; nothing was redesigned. Free has no stale state: the pill is hollow only for `--` (ADR-021, Body Battery in Free).

## Weather row (Pro, ADR-022, proposed, BUILT and UNRELEASED; the owner approved the mockup 2026-10-03; never seen on a screen)

A row between the time and the Body Battery band: **now** = a condition icon (1.4 times an ahead icon) in one fixed hue per icon type (sun and bolt `#FFFF55`, cloud and snow `#FFFFFF`, rain `#00AAFF`) and the feels-like number in one hue whatever the condition (`#FFFF55`); **ahead** = up to three mono `#AAAAAA` icons, hour under each, even steps to sunset; after sunset the next daylight day (chevron and weekday, icon, high and low; the low goes first on a wide row), before sunrise the same without the label. One-line compact form on screens too short (the 218 px products, by the simulator's fonts), then gone. Order of giving way: compact, date, curve, weather row, sun line. Icons are primitives (`TwoSunsWeatherIcons`), seven kinds. Not drawn always-on. Mockup: `docs/archive/weather-mockup.html`. Reserved: no accent may equal a weather hue (`noAccentIsAWeatherHue`). The built row has no screenshot: only `twoSunsLayoutReport` boxes. **The time moves 37 px (454 px) when the row appears or disappears** (setting off, data aged out after 3 hours, no data, no daily entry after sunset); a failed read keeps the last good data so a flaky read does not cause it. Design review: ADR-022.

## Watch battery row (Pro, ADR-023, proposed, BUILT and UNRELEASED; never seen on a screen)

One muted `#AAAAAA` row above the first row of the stack: a classic battery (outline, nub, fill) and the whole percent, centred. It lives in the strip between the stack and the ring, so it never moves another row, and it is drawn only where its ink fits the round chord (drawn on 280, 390, 416, 454 and 466 px screens, not on 360 px, by the simulator's fonts). Setting `Battery`, On by default. No charging mark, no low colour. Not drawn always-on. The next-day marker in the weather row is an arrow (shaft and filled head, muted), not a character.

## Always-on (AMOLED)

Only on watches that require burn-in protection. The time, the Body Battery value and the sun sentence, `#5555AA`, the block stepping across a 3 × 3 grid every minute in steps of 3.5% of D (15 px on 454); the time is always two font sizes below whatever awake just picked (derived at draw time, `TwoSunsDraw.fontsBelow`, ADR-007 amendment, `docs/decisions.md`). No ring, curve, glyph or date. Text is fitted against a circle smaller by one step, so a shifted block stays inside. MIP watches keep the full face. **Not measured on a watch:** lit-pixel share, ghosting, whether the screen blanks — Garmin's published burn-in limit is cited in the ADR-007 amendment of 2026-10-04 (`docs/decisions.md`); `watch-design-kit`'s `knowledge/platform-facts.md` still tags it unverified.

### Always-on text colour against Garmin's "avoid much white or blue" (finding, 2026-10-04, ROADMAP 10.17; no colour changed)

Garmin's watch-face page says, for always-on: "Avoid using much white or blue. Consider using light gray instead." It gives no reason, no threshold for "much", and no measure. Our always-on text is `#5555AA`, a blue-family colour (blue channel `AA`, red and green `55`). Facts, computed from the hex values: relative luminance `#555555` 0.09 (2.8:1 on black), `#5555AA` 0.11 (3.3:1), `#AAAAAA` 0.40 (9.0:1), white 1.00. (1) On Venu 2 and later Garmin's rule is under 10% of the screen's *luminance*, and a block of time, number and sun line in `#5555AA` is a small area at about a ninth of white's luminance per pixel, so the share is small whatever the exact area; (2) the original Venu's rule counts lit pixels in any colour but black, so colour does not matter there; (3) Garmin's "light gray" (`#AAAAAA`) would draw the same blue channel (`AA`) as ours plus red and green, about 3.5 times the luminance, so it is not a way to use less blue; the only colour with less blue that still clears our own 3:1 bar is a non-blue one (for example `#AA5555`, 4.1:1), and why Garmin names blue is not stated (any reason about subpixel ageing is our inference, not Garmin's). **Finding:** the choice sits between our 3:1 contrast bar (why `#555555` was raised in the 2026-09-27 amendment) and a piece of advice with no stated reason; the pixel and luminance budgets are met with margin by arithmetic, but unmeasured. Keep `#5555AA` until the heat map and an always-on night on a wrist (ROADMAP 3.1) say otherwise; if the owner wants to follow the advice literally, it is a one-constant change (`TwoSunsPalette.SLEEP_TEXT`) and a look-approval question, not a change made here.

## Failure display

If reading the sources throws, the face draws a single "?" so it is never blank. Every known failure has words instead: "No place yet", "No sun data", `--`.

## Constraints

Primitives and system fonts only, no bitmaps (the launcher icon aside). Every colour in the 64-colour palette. The launcher icon (`resources/drawables/launcher_icon.svg`, 65 by 65: a grey ring, an amber arc and a white dot on black — drawn before the default accent changed; the icon does not follow the accent setting) is a generic **placeholder, not approved**; the real icon is the owner's and must not contain "Body Battery".

## Instinct E and Instinct 3 Solar (1-bit, a round window top right; ADR-024, accepted 2026-10-04, simulator only, look approved 2026-10-04)

Black and white only: every colour role is white. **The sky ring becomes a 24-hour dial in the round window**, the same shapes in miniature: a hairline circle is the night, the daylight still to come is the thick arc, daylight gone and twilight are hairlines over it, ticks mark sunrise and sunset, the sun is a solid dot while it is up and an outline when it is not. The time and the date share the band left of the window; the weather row (Pro), the Body Battery bolt and value (with the curve in Pro) and the sun line sit below it. No watch battery row, no golden hour, no accent. What shows is the square cut by a circle about 98 px in radius (the bezel hides the corners), so rows are clipped to a 97 px circle against their ink.
