---
name: Two Suns
description: The time on black, a 24-hour sky ring round the bezel, and the day's Body Battery as a curve under it, drawn with primitives and system fonts.
colors:
  ground: "#000000"
  text: "#FFFFFF"
  muted: "#AAAAAA"
  sleep-text: "#5C5C5C"
  night: "#5555AA"
  twilight: "#AAAAFF"
  golden: "#FF5500"
  accent-sky: "#55AAFF"
  accent-mint: "#55FFAA"
  accent-autumn: "#FFAA00"
  accent-violet: "#AA55FF"
  accent-pink: "#FF55AA"
  accent-winter: "#FFFFFF"
typography:
  time:
    fontFamily: "Graphics.FONT_NUMBER_HOT → FONT_NUMBER_MEDIUM → FONT_NUMBER_MILD (rectangles: FONT_NUMBER_THAI_HOT first)"
    fontSize: "largest whose height is under 26% of the shorter screen side (260 permille); a rectangle's then grows into its box (ADR-028)"
  value:
    fontFamily: "Pro: Graphics.FONT_SMALL → FONT_TINY → FONT_XTINY; Free awake: FONT_MEDIUM first (ADR-025); rectangles grow it: Free FONT_LARGE → FONT_MEDIUM → FONT_SMALL, Pro FONT_SMALL → FONT_TINY"
    fontSize: "largest under 8% of the shorter side (Free awake 13%); on a rectangle up to 45% of the grown time font's height"
  sun-line:
    fontFamily: "Graphics.FONT_TINY → FONT_XTINY"
    fontSize: "largest under 7.5% of the shorter side; longest wording that fits the chord"
  date:
    fontFamily: "Graphics.FONT_TINY → FONT_XTINY"
    fontSize: "largest under 6% of the shorter side"
  sleep-time:
    fontFamily: "round: the TIME_FONTS list (FONT_NUMBER_HOT → MEDIUM → MILD); rectangles: FONT_NUMBER_THAI_HOT → HOT → MEDIUM → MILD → FONT_LARGE → FONT_MEDIUM"
    fontSize: "two steps below the awake time font in that list (floored at its last); on a rectangle below the grown awake time, so always smaller"
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
    textColor: "{colors.text}"
---

# Design

The visual system **as built** (2026-09-26; the owner shipped it as 1.0.0, uploaded 2026-09-27). Noted then: the rectangular screens had not been looked at by eye and the launcher icon is a placeholder. Simulator screenshots exist since 2026-10-04 (`../docker/SIMULATOR.md`); the rectangles have their own form since 2026-10-05 ("Rectangle" below). Everything here is read from the code and the simulator's layout report; nothing had been seen on a watch then (real-FR965 photos and look feedback came later: `docs/spec.md`). The owner may replace the direction with a design-tool mock-up ([`docs/archive/plan.md`](docs/archive/plan.md) phase 4 gate); then this file and the spec change.

## Direction

**Two suns.** Black ground. The time is the hero. Around the bezel a 24-hour ring is the sky's sun; under the time the watch's Body Battery for the last 24 hours is a curve; one sentence at the bottom is the light left or the next sunrise. One accent colour, chosen in settings, carries both "daylight still to come" and the Body Battery value. A state is never colour alone.

## Rows, top to bottom

watch battery (muted, optional, Pro) · date (muted, optional) · **time** · weather (Pro) · Body Battery band = [bolt] [value] [curve] · sun sentence.

Each row takes the largest font up to a height cap (share of D, the shorter screen side); the rows are then stacked from their measured heights and centred (Days To Go ADR-012). Every text is measured against the round chord at its row: the sun sentence steps down through its wordings (full, shorter, shortest) and fonts, and only when nothing fits does it end in "...". Rectangular screens (Venu Sq 2, Sq 2 Music, Venu X1) have their own square form: see "Rectangle" below (ADR-028 (the rectangle track), accepted 2026-10-08, look approved by the owner from simulator screenshots).

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

- **Curve.** Drawn only when two neighbouring buckets have samples; a lone dot is not drawn, on any shape (ADR-028 (the rectangle track) amendment 2026-10-08; unit tests, and simulator captures with the Curve setting on, its default, and a one-sample history: fr965 and venux1 in `../device-test/rect-review/aod-grey/TwoSuns/`; a forced one-sample history, Garmin's number null, on fr965, fr255s and instincte40mm Pro: `round-empty-pro-*-onesample-*.png` there, 2026-10-08). **The band keeps the curve's room whenever the Curve setting is on and the watch has the Body Battery history API, line or not, and even when one read throws** (ADR-028 amendment 2026-10-08, "the curve's room"; Pro only, Free has no curve): its height is the curve's and the bolt and number sit at its left edge from `--` and the first sample on, the room to their right empty until a line exists, so nothing moves when a curve first lands or when the last neighbouring pair ages out of the sliding 24-hour window. Before that amendment the round band was the value's height and the pair centred until a line existed, then the time moved up 6 px and the pair jumped 123 px left on fr965, and back again when the line aged out (captures `round-empty-pro-fr965-onesample-1-awake.png` and `-twosample-1-awake.png`). Captures with the room kept, Pro, Garmin's number null, empty, one, two, five (an hour) and 96 samples on fr965, fr255s, venusq2 and instincte40mm: `../device-test/rect-review/aod-grey/TwoSuns/curve-pro-*.png` (simulator only). On round the pair is then off-centre with nothing beside it until the first line: the place the wearer sees it all day once a curve exists, chosen over a repeating jump. **For about the first hour a new curve is still only a dot at the room's right end, then a short line pinned there for hours** (the `-twosample-` and `-hour-` captures; on fr965 the hour shows a stub left of the dot, on the Instinct still a dot), and the whole rule needs samples in neighbouring 15-minute buckets, so it stays that rare only **if** the watch records Body Battery at least every 15 minutes (unverified: ADR-015's cadence probe must report the gap distribution; a longer typical gap would leave the room empty most of the time). A minimum drawn length or span waits for that probe; the round look, this room included, was approved by the owner on 2026-10-08 (ADR-028 amendments). 96 buckets of 15 minutes across the band, x by bucket, y by level from 0 (bottom) to 100 (top). A white line (`#AAAAAA` when stale) with no fill (since 2026-10-05, ROADMAP 13.15: the old `#5555AA` / `#555555` fill read as part of the night sky), a gap where a bucket has no sample (never interpolated). The newest point is a solid dot, in the current battery colour (below), or an outline dot when stale. Width up to 520 permille of D.
- **Glyph.** A solid bolt in the current battery colour (since 2026-10-05, ROADMAP 13.16; before it, the bolt gauge of ADR-023, which replaced the level pill of 2026-09-27: a dim `#555555` bolt filled from the bottom to the level, the fill clipped to the bolt's own edges); as tall as the value font, 0.6 as wide. Hollow (a muted outline, no fill) when the value is stale or `--`. Chosen so it cannot be mistaken for the watch battery row (a rectangle with a nub). Seen in simulator screenshots (the gauge read as broken: owner, 2026-10-05, ROADMAP 13.16). On a rectangle the hollow outline's stroke scales with the bolt (a twentieth of its height, at least the round pen), so the grown Free bolt is not a hairline (ADR-028).
- **Value and current battery colour.** The accent, whatever the level (`TwoSunsReadings.batteryColor`): never a colour keyed to the reading (ADR-008 (no verdicts on Body Battery), amended 2026-10-08; until then it dimmed to `dim(accent)` below 30). `#AAAAAA` when stale (a reading over an hour old: age, not value) and for `--` when there is no valid sample, on every shape, beside a hollow bolt (ADR-028 amendment 2026-10-08). Unit tests for `--` and stale; round `--` captured 2026-10-08 (simulator only, `../device-test/rect-review/aod-grey/TwoSuns/round-empty-*-empty-*.png`: fr965 Pro and Free awake and always-on, fr255s Pro and instincte40mm Pro and Free awake and their sleep frames, which on MIP and 1-bit watches are the full face (on the Instinct `--` is white, the mono MUTED, and the hollow bolt carries the state); a patched private copy in the container, never the repo, with Garmin's number forced null and no history, sun times and the Pro place pinned as in `tools/listing_shots.sh`; the scenario is `round_empty.sh` beside the pictures): grey `--` beside a hollow grey bolt, no curve, and always-on a grey `--` with no bolt. Stale is not captured on round; a simulator capture shows a low reading in the full accent (`aod-grey-venux1-1-awake.png`, a 5 in sky blue, `../device-test/rect-review/aod-grey/TwoSuns/`). The bolt and the dot follow the same rule in `TwoSunsCurve` (hollow when `--` or stale, outline dot when stale), not through `batteryColor`. Applies to the value text, the bolt and the curve's current-point dot; the curve's line colour does not change with the current level, since they show the last 24 hours, not just now.
- **Stale is a shape as well as a colour**: hollow glyph, outline dot.
- Never any face, mood, verdict word, hue change or threshold shown in words ([ADR-008](docs/decisions.md#adr-008-no-verdicts-on-body-battery)).

## Palette and contrast

All values have channels 00, 55, AA or FF, the device-safe palette (why: see `watch-design-kit`'s `watch-design-lead` skill). Contrast ratios below are **computed from the hex values against black (WCAG formula), not measured on a screen**.

| Colour | Hex | Against black |
|---|---|---|
| Text, white accent | `#FFFFFF` | 21.0 : 1 |
| Muted | `#AAAAAA` | 9.0 : 1 |
| Night track | `#5555AA` | 3.3 : 1 |
| Always-on text (AMOLED sleep frame only; not 64-colour, AMOLED shows any value) | `#5C5C5C` | 3.1 : 1 |
| Twilight | `#AAAAFF` | 9.9 : 1 |
| Golden hour | `#FF5500` | 6.6 : 1 |
| Stale curve line (awake only) | `#AAAAAA` (muted) | 9.0 : 1 (no fill since 2026-10-05) |

Accents (default first) and their "gone" form: sky `#55AAFF` 8.6 : 1 → `#55AAAA` 7.7 (default, chosen 2026-09-27 over the old amber default: blue carries no "status" meaning, so it never misreads as a low value); mint `#55FFAA` 16.3 → `#55AAAA` 7.7; autumn (the old "amber", renamed not recoloured) `#FFAA00` 11.0 → `#AAAA00` 8.5; violet `#AA55FF` 5.5 → `#AA55AA` 4.6; pink `#FF55AA` 7.1 → `#AA55AA` 4.6; winter (the old "white") `#FFFFFF` 21.0 → `#55AAAA` 7.7 (nudged from the naive `#AAAAAA`, which is bit-identical to MUTED/stale — a watch-design-reviewer finding of 2026-09-27). The unit test `dimPartsStayReadable` asserts at least 3:1 for the night track and for every accent's gone form; `dimNeverEqualsMuted` (new) asserts no accent's gone form ever equals MUTED.

Always-on text is `#5C5C5C`, 3.1:1 (was `#555555` 2.8:1, then `#5555AA` 3.3:1 from 2026-09-27; now a grey, ADR-027 (always-on text is a dim grey), `docs/decisions.md`). The stale curve is the muted `#AAAAAA` line, 9:1 (no fill since 2026-10-05; the old stale fill was `#555555`, 2.8:1). `TwoSunsPalette.TRACK` (`#555555`) is defined but no code draws it.

## Accent ids, and the Free build (ADR-020, accepted and uploaded 2026-10-04)

Accent ids are **append-only**: a shipped id never changes its colour (`shippedAccentIdsKeepTheirColours`), an unknown or out-of-range id draws the default (id 0). Both tiers offer ids 0 to 5, the shipped list: 0 sky `#55AAFF` (default), 1 mint `#55FFAA`, 2 autumn `#FFAA00`, 3 violet `#AA55FF`, 4 pink `#FF55AA`, 5 winter `#FFFFFF`. The plan's ids 6 to 11 are **deferred, not built**; when they land they are Pro only and appended: 6 cyan `#00FFFF`, 7 lime `#55FF55`, 8 yellow `#FFFF55`, 9 magenta `#FF55FF`; orange and coral are **not admitted** for this face (golden hour is `#FF5500`, and no accent or dimmed accent may equal it: `noAccentIsTheGoldenHourColour`). Amber, orange, coral and red are never the default on a Body Battery face (ADR-017, ring, curve and glyph encodings, the amber-read-as-"low" lesson). The accent tests check every channel is 00/55/AA/FF and the accent and its dimmed form are at least 3:1 on black.

The Free build draws the same face with fewer parts: no curve, no date row, no twilight or golden-hour arc, noon at the top; the time, the bolt with Garmin's number (or `--` and a hollow bolt), the ring from Garmin's own sunrise and sunset, and the sun sentence. Because the date row and the curve are absent the rows re-stack from the same measured fonts (ADR-016, rows follow font heights), so the time and the band sit differently from Pro's default. No mockup or look approval exists for that layout; simulator screenshots exist (`../docker/SIMULATOR.md`; the rectangles' in `../device-test/rect-review/after/`); nothing was redesigned. Free has no stale state: the bolt is hollow only for `--` (ADR-021, Body Battery in Free).

**Defaults (2026-10-05, owner, ROADMAP 13.13): the weather row and the watch battery row are Off by default**, so the face a buyer first sees is the one the listing shows; each is one switch in the settings. On a screen too short for the full row, the compact row is the lead cell alone (ROADMAP 13.14: three icons with no hours said nothing).

## Weather row (Pro, ADR-022, proposed until the wrist check, built, uploaded in Pro 1.1.0 2026-10-04; the owner approved the mockup 2026-10-03; seen in simulator screenshots, and on the owner's FR965 in the 2026-10-03/04 wear check of the build before the 13.40 change)

A row between the time and the Body Battery band: **now** = a condition icon (1.4 times an ahead icon) in one fixed hue per icon type (sun and bolt `#FFFF55`, cloud and snow `#FFFFFF`, rain `#00AAFF`) and the feels-like number in one hue whatever the condition (`#FFFF55`); **ahead** = up to three mono `#AAAAAA` icons, hour under each, even steps to sunset; after sunset the next daylight day alone, on one line (arrow and weekday, the full-size icon, high and low; no hour cells), before sunrise today without the label, high and low, then its hours. A forecast's low outranks every hour cell, so a high never stands alone where it would read as "now"; cells that do not fit are dropped from the middle, so the strip still reaches sunset (ADR-022 amendment 2026-10-10). Hours read `7p` on a 12 hour clock and `09:00` / `19:00` on a 24 hour clock, like the face's own clock, never a bare number beside a temperature. One-line compact form on screens too short (the 218 px products, by the simulator's fonts), then gone. Order of giving way: compact, date, curve, weather row, sun line. Icons are primitives (`TwoSunsWeatherIcons`), seven kinds. Not drawn always-on. Mockup: `docs/archive/weather-mockup.html`. Reserved: no accent may equal a weather hue (`noAccentIsAWeatherHue`). The built row is seen in simulator screenshots (canned weather); the owner's FR965 wear check (2026-10-03/04) saw the build before 13.40. **The time moves 37 px (454 px) when the row appears or disappears** (setting off, data aged out after 3 hours, no data, no daily entry after sunset); a failed read keeps the last good data so a flaky read does not cause it. Design review: ADR-022.

## Watch battery row (Pro, ADR-023, proposed until the wrist check, built, uploaded in Pro 1.1.0 2026-10-04; seen in simulator screenshots only, never on a wrist)

One muted `#AAAAAA` row above the first row of the stack: a classic battery (outline, nub, fill) and the whole percent, centred. It lives in the strip between the stack and the ring, so it never moves another row on a round screen (on a rectangle its strip comes off the top of the box and can step the time down a size, ADR-028), and it is drawn only where its ink fits the round chord (round: drawn on 280, 390, 416, 454 and 466 px screens, not on the round 360 px, by the simulator's fonts; rectangles: drawn on both, in its own strip at the top of the box, ADR-028). Setting `Battery`, Off by default (since 2026-10-05, ROADMAP 13.13). No charging mark, no low colour. Not drawn always-on. The next-day marker in the weather row is an arrow (shaft and filled head, muted), not a character.

## Rectangle (Venu Sq 2, Sq 2 Music, Venu X1; ADR-028 (the rectangle track), accepted 2026-10-08, look approved by the owner from simulator screenshots; the 2026-10-08 changes, the round follow-up and the curve's room included, approved by the owner's "consider all UI changes approved" that day, relayed by the coordinator)

The square watches get a square face, not the round one inscribed in them. Same meanings, same rows and the same colours. The two rectangle-only differences of 2026-10-05 (a muted `--`, no lone-dot curve) apply to round too since 2026-10-08 (ADR-028 amendment), so only the geometry follows the screen.

- **The sky ring is a rounded-rectangle track** along the glass. It has the round ring's width (2.5% of D) and is inset like it (half the width plus a 1% gap), or further when the sun marker and its black halo would otherwise reach past the glass (the round ring's bezel hides that overhang; a rectangle's glass does not): the centreline is 9 px in on the 320 x 360 Venu Sq 2 and 11 px on the 448 x 486 Venu X1 (`TwoSunsLayout.trackInsetFor`), and `sunMarkerStaysOnTheGlass` checks the marker and halo against the measured glass corners at every minute, and its centreline corner radius is 150 permille of D (48 px and 67 px), which clears the Venu X1's rounded glass (68 px radius, measured off the alpha mask of the SDK's device image; the Venu Sq 2's glass corner is about 10 px). One proportion on every size, so the corners echo the round face rather than hug the Sq 2's near-square glass.
- **The 24 hours map to the track's length**: the track starts at top centre and runs clockwise; a share of the day is the same share of the length (two straight runs each way plus four quarter-circle corners), equal time per pixel. Noon at top centre by default, midnight there with the Orientation setting (Pro), so 18:00 is the middle of the right side and 06:00 of the left (noon at the top). Every layer of "Ring encoding" lies on that path in the same order and colours: night track, twilight, daylight gone, daylight still to come, golden hour, the sunrise and sunset ticks (across the track, perpendicular to it, reaching the same share of the ring width inward), and the sun marker (solid or outline). A stretch under a pixel still draws one.
- **The rows fill the rounded box inside the track** (the track's inside edge less the text margin, its corners concentric with the track's): every text and box is measured against that box at its row, corners included, instead of the round chord. The stack may use the whole box height (the round face keeps to 80% of its content circle).
- **The rows are spread over the box** (`TwoSunsRectSpread`): the gaps between the rows' boxes are all the same, the top and bottom margins included (the time's box measured by its digits; other rows by their font boxes, whose internal leading still adds a few pixels; proven on the arithmetic by `rectangleSpreadGapsAreEven`, judged by eye on the screenshots), so no band of black is left at the top or bottom. The other rows count by their font boxes: a row whose box has empty space of its own (the weather row's hour labels) still sits a little closer to the time's digits than the others do (about 10 px against about 24 px on the Venu Sq 2 with every Pro row on). The time's empty bands (its font's descent under the baseline, digits have none, and as much above) are not counted as gap, and a margin is never less than such a band, so every font box stays inside the box; font boxes never overlap (each gap is at least the round gap). The places depend only on the rows' heights, never on which wording the sun sentence takes (`rectangleRowsDoNotDependOnTheWording`), so nothing jumps as the sentence shortens; a long wording near the box's rounded bottom corners may step to its shorter form instead. Only when the rows cannot be spread with that minimum gap does the centred round stack stand. With the battery row kept, its strip (the row and one gap, no twin below) comes off the top of the box first.
- **The time grows into the box**: once every row has its place, the time takes the largest number font (`FONT_NUMBER_THAI_HOT` first) whose height still fits the stack in the box and whose width ("00:00", the widest time, so it does not change size from minute to minute) fits the box at its row. Rows are never dropped to make the time bigger: a size whose stack would push the weather row off its chord is skipped for the next smaller one (`TwoSunsRectFit`). The size is planned for the Weather **setting**, not for whether weather data is there right now: with Weather on, the row's height is kept for it even while the data is missing, so the time does not change size when data comes and goes (the remaining rows simply re-spread without it). In Pro, while the Battery setting is on, the time leaves room for the watch battery row at the top of the box (the row and one gap), but only when the row then fits and draws; with the setting off (the default), or where the row would not fit anyway, the time takes that room too, so a setting that shows nothing never costs the time a size (`rectangleBatteryCostsTheTimeOnlyWhenDrawn`). Switching the row on can step the time down a size (round keeps ADR-023's (watch battery row) rule that the row never moves the stack).
- **The Body Battery band spans the box**: bolt and number at its left edge, the curve to its right edge (no 520 permille cap). Pro's number takes one step up when the box has room (`FONT_SMALL` or `FONT_TINY`, no taller than 45% of the time font: it shares the band with the curve), so it is not lost under the large time. `--` is drawn muted, like the hollow bolt beside it, so the empty cell reads as one "no data" state, and a curve with no two neighbouring samples (a lone dot) is not drawn: a dot at the far end of an empty band reads as floating (the simulator's own history, 480 samples a minute apart from the clock into the future, leaves one sample in the face's 24-hour window: one dot). Both were rectangle-only on 2026-10-05; round follows since 2026-10-08 (ADR-028 amendment). With Curve on, the bolt and number stay at the band's left edge with the curve's room empty until a line exists (Pro; "Curve" above), so on a rectangle the time is sized for that room, as it is for the Weather setting.
- Free on a rectangle: the time, and the Body Battery number grows with it (`FONT_LARGE`, `FONT_MEDIUM` or `FONT_SMALL`, the largest no taller than 45% of the time font's height; both screens pick `FONT_LARGE`, `TwoSunsLayout.RECT_VALUE_TO_TIME_PERMILLE`), so the energy reading is clearly the second read, not an afterthought; the bolt scales with it; then the sun line. Measured (`twoSunsLayoutReport`, simulator, 2026-10-06): font heights XTINY to THAI_HOT are 39, 44, 51, 59, 68, 82, 105, 155, 181 px on `venusq2` and 37, 47, 53, 61, 71, 112, 152, 171, 209 px on `venux1`. So the round rule of ADR-025 (Free's Body Battery number is a size larger: the largest of MEDIUM, SMALL, TINY, XTINY under 130 permille of D) picks `FONT_XTINY` on `venusq2` (its cap is 41 px), the same size as Pro: the "size up" does not happen on that screen. The rectangle growth replaces it: Free draws the time in `FONT_NUMBER_HOT` (155 px) with the number in `FONT_LARGE` (68 px) on `venusq2`, and `FONT_NUMBER_THAI_HOT` (209 px) with `FONT_LARGE` (71 px) on `venux1`.
- Always-on: as round (time, number and sun line, `#5C5C5C`, drifting), fitted against the box less one drift step.
- Simulator layout (2026-10-05; screenshots recaptured 2026-10-07): see `docs/compatibility.md` "Rectangular AMOLED". Screenshots: `../device-test/rect-review/after/TwoSuns-*.png` (the `*-low.png` ones show the dim below 30 that ADR-008's 2026-10-08 amendment retired; simulator only; the simulator's sun times, curve and weather are canned).

## Always-on (AMOLED)

Only on watches that require burn-in protection. The time, the Body Battery value and the sun sentence, `#5C5C5C` (a dim grey, ADR-027 (always-on text is a dim grey)), the block stepping across a 3 × 3 grid every minute in steps of 3.5% of D (15 px on 454); the time is always two font sizes below whatever awake just picked (on a rectangle, below the grown awake time, in a list that continues past `FONT_NUMBER_MILD` to `FONT_LARGE` and `FONT_MEDIUM`, so it is always smaller; `rectangleAlwaysOnTimeIsSmaller`, ADR-028) (derived at draw time, `TwoSunsDraw.fontsBelow`, ADR-007 amendment, `docs/decisions.md`). No ring, curve, glyph or date. Text is fitted against a circle smaller by one step, so a shifted block stays inside. MIP watches keep the full face. Simulator: the simulator's 24-hour heat map (File > View Screen Heat Map, always-on) reports no burn-in detected, peak luminance 1.03% (Pro) and 1.27% (Free) on `venusq2`, 1.57% (Pro and Free) on `venux1` (2026-10-07, final build) (first run 2026-10-05, ADR-028, the rectangle track; `docs/compatibility.md`) and 1.09% on `fr965` (2026-10-05, `../docker/SIMULATOR.md`); re-run 2026-10-08 after the Body Battery colour change, Pro: 1.17% on `fr965` and 1.48% on `venux1` (`../device-test/rect-review/aod-grey/`); simulator only, the other round sizes not run, nothing on a wrist. **Not measured on a watch:** lit-pixel share, ghosting, whether the screen blanks — Garmin's published burn-in limit is cited in the ADR-007 amendment of 2026-10-04 (`docs/decisions.md`); `watch-design-kit`'s `knowledge/platform-facts.md` still tags it unverified.

### Always-on text colour against Garmin's "avoid much white or blue" (finding, 2026-10-04, ROADMAP 10.17; no colour changed)

Garmin's watch-face page says, for always-on: "Avoid using much white or blue. Consider using light gray instead." It gives no reason, no threshold for "much", and no measure. Our always-on text was `#5555AA`, a blue-family colour (blue channel `AA`, red and green `55`). Facts, computed from the hex values: relative luminance `#555555` 0.09 (2.8:1 on black), `#5555AA` 0.11 (3.3:1), `#AAAAAA` 0.40 (9.0:1), white 1.00. (1) On Venu 2 and later Garmin's rule is under 10% of the screen's *luminance*, and a block of time, number and sun line in `#5555AA` is a small area at about a ninth of white's luminance per pixel, so the share is small whatever the exact area; (2) the original Venu's rule counts lit pixels in any colour but black, so colour does not matter there; (3) Garmin's "light gray" (`#AAAAAA`) would draw the same blue channel (`AA`) as ours plus red and green, about 3.5 times the luminance, so it is not a way to use less blue; the only colour with less blue that still clears our own 3:1 bar is a non-blue one (for example `#AA5555`, 4.1:1), and why Garmin names blue is not stated (any reason about subpixel ageing is our inference, not Garmin's). **Finding:** the choice sits between our 3:1 contrast bar (why `#555555` was raised in the 2026-09-27 amendment) and a piece of advice with no stated reason; the pixel and luminance budgets are met with margin by arithmetic, but unmeasured. **Resolved 2026-10-04: the owner chose to follow the advice now** (ROADMAP 10.26, ADR-027 (always-on text is a dim grey)). `TwoSunsPalette.SLEEP_TEXT` is now `#5C5C5C`: neutral grey with no blue channel, 3.14:1 against black (above our own 3:1 bar; `#555555` at 2.8:1 is not), relative luminance 0.107 against `#5555AA`'s 0.113, so the luminance budget is a touch lower and the lit-pixel share is unchanged (same glyphs, same area). It is not a 64-colour value: only AMOLED draws the sleep frame, and AMOLED renders any value (a MIP watch never takes this path). Garmin's own "light gray" (`#AAAAAA`) was not used: 3.5 times the luminance, brighter than a persistent colour needs. The simulator's heat map has since run (see "Always-on (AMOLED)" above); an always-on night on a wrist (ROADMAP 3.1) is still open.

## Failure display

If reading the sources throws, the face draws a single "?" so it is never blank. Every known failure has words instead: "No place yet", "No sun data", `--`.

## Constraints

Primitives and system fonts only, no bitmaps (the launcher icon aside). Every colour in the 64-colour palette. The launcher icon (`resources/drawables/launcher_icon.svg`, 65 by 65: a grey ring, an amber arc and a white dot on black — drawn before the default accent changed; the icon does not follow the accent setting) is a generic **placeholder, not approved**; the real icon is the owner's and must not contain "Body Battery".

## Instinct E and Instinct 3 Solar (1-bit, a round window top right; ADR-024, accepted 2026-10-04, simulator only, look approved 2026-10-04)

Black and white only: every colour role is white. **The sky ring becomes a 24-hour dial in the round window**, the same shapes in miniature: a hairline circle is the night, the daylight still to come is the thick arc, daylight gone and twilight are hairlines over it, ticks mark sunrise and sunset, the sun is a solid dot while it is up and an outline when it is not. The time and the date share the band left of the window; the weather row (Pro), the Body Battery bolt and value (with the curve in Pro) and the sun line sit below it. No watch battery row, no golden hour, no accent. What shows is the square cut by a circle about 98 px in radius (the bezel hides the corners), so rows are clipped to a 97 px circle against their ink.
