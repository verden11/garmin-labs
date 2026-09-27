---
name: Two Suns
description: The time on black, a 24-hour sky ring round the bezel, and the day's Body Battery as a curve under it, drawn with primitives and system fonts.
colors:
  ground: "#000000"
  text: "#FFFFFF"
  muted: "#AAAAAA"
  sleep-text: "#555555"
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

The visual system **as built** (2026-09-26). **The owner has not approved the look**, the rectangular screens have not been looked at by eye, the launcher icon is a placeholder, and **no screenshot of the face exists** (this environment cannot capture the simulator). Everything here is read from the code and the simulator's layout report; nothing has been seen on a watch. The owner may replace the direction with a design-tool mock-up ([`docs/plan.md`](docs/plan.md) phase 4 gate); then this file and the spec change.

## Direction

**Two suns.** Black ground. The time is the hero. Around the bezel a 24-hour ring is the sky's sun; under the time the watch's Body Battery for the last 24 hours is a curve; one sentence at the bottom is the light left or the next sunrise. One accent colour, chosen in settings, carries both "daylight still to come" and the Body Battery value. A state is never colour alone.

## Rows, top to bottom

date (muted, optional) · **time** · Body Battery band = [level pill] [value] [curve] · sun sentence.

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
- **Glyph.** A level pill, not a battery: a plain rounded bar, 55% of the value font's height tall and 1.8 times as wide, filled left to right to the level in the current battery colour. No nub — changed 2026-09-27 from a battery-shaped glyph (outline + nub) on the owner's own-device photo: a battery shape reads as watch battery on a Garmin face regardless of its fill colour. Hollow (outline only) when the value is stale or `--`.
- **Value and current battery colour.** The accent when the level is at or above 30 (`TwoSunsConfig.BATTERY_LOW_THRESHOLD`); `dim(accent)` below it (ADR-008 amendment, 2026-09-27) — the same dim the ring uses for daylight already gone, so it stays the same hue, one step darker, never a different colour. `#AAAAAA` when stale (overrides the level colour), `--` when there is no valid sample. Applies to the value text, the pill's fill and the curve's current-point dot; the curve's own fill and line colours do not change with the current level, since they show the last 24 hours, not just now.
- **Stale is a shape as well as a colour**: hollow glyph, outline dot.
- Never any face, mood, verdict word, hue change or threshold shown in words ([ADR-008](docs/decisions.md#adr-008-no-verdicts-on-body-battery)).

## Palette and contrast

All values have channels 00, 55, AA or FF (the 64-colour palette), so MIP renders them exactly. Contrast ratios below are **computed from the hex values against black (WCAG formula), not measured on a screen**.

| Colour | Hex | Against black |
|---|---|---|
| Text, white accent | `#FFFFFF` | 21.0 : 1 |
| Muted | `#AAAAAA` | 9.0 : 1 |
| Night track, curve fill (fresh) | `#5555AA` | 3.3 : 1 |
| Twilight | `#AAAAFF` | 9.9 : 1 |
| Golden hour | `#FF5500` | 6.6 : 1 |
| Stale curve fill, always-on text | `#555555` | 2.8 : 1 |

Accents (default first) and their "gone" form: sky `#55AAFF` 8.6 : 1 → `#55AAAA` 7.7 (default, chosen 2026-09-27 over the old amber default: blue carries no "status" meaning, so it never misreads as a low value); mint `#55FFAA` 16.3 → `#55AAAA` 7.7; autumn (the old "amber", renamed not recoloured) `#FFAA00` 11.0 → `#AAAA00` 8.5; violet `#AA55FF` 5.5 → `#AA55AA` 4.6; pink `#FF55AA` 7.1 → `#AA55AA` 4.6; winter (the old "white") `#FFFFFF` 21.0 → `#AAAAAA` 9.0. The unit test `dimPartsStayReadable` asserts at least 3:1 for the night track and for every accent's gone form, and `ringColoursAreDistinctForEveryAccent` that the ring's five colours differ for every accent.

Open item for the look approval: the stale fill and the always-on text (`#555555`) are 2.8:1, under the 3:1 the design brief set for dim tracks. Stale is also carried by shape; the always-on text is dim on purpose (burn-in). Check both in daylight on a MIP watch and on an AMOLED at night. `TwoSunsPalette.TRACK` (`#555555`) is defined but no code draws it.

## Always-on (AMOLED)

Only on watches that require burn-in protection. The time, the Body Battery value and the sun sentence, all `#555555`, the block stepping across a 3 × 3 grid once a minute in steps of 3.5% of D (15 px on 454); the time two sizes smaller than awake (starts at `FONT_NUMBER_MEDIUM`). No ring, curve, glyph or date. Text is fitted against a circle smaller by one step, so a shifted block stays inside. MIP watches keep the full face. **Not measured on a watch:** lit-pixel share (Garmin's limit is 10%, a pixel on for at most three updates), ghosting, whether the screen blanks.

## Failure display

If reading the sources throws, the face draws a single "?" so it is never blank. Every known failure has words instead: "No place yet", "No sun data", `--`.

## Constraints

Primitives and system fonts only, no bitmaps (the launcher icon aside). Every colour in the 64-colour palette. The launcher icon (`resources/drawables/launcher_icon.svg`, 65 by 65: a grey ring, an amber arc and a white dot on black — drawn before the default accent changed; the icon does not follow the accent setting) is a generic **placeholder, not approved**; the real icon is the owner's and must not contain "Body Battery".
