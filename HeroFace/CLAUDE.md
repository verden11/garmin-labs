# HeroFace — CLAUDE.md

Garmin watch face (Connect IQ, Monkey C) from studio Verden. Time-first, HeroSet's visual language: bezel ring, three mission bars, gold streak.
129 products (117 round + 7 Instinct, ADR-002 (Instinct family), accepted 2026-10-04, simulator only; + 5 rectangle, ADR-005 (Venu Sq / Sq 2 / X1, the ring as a frame), look approved by the owner 2026-10-08, simulator only), `minApiLevel` 3.0.0. Paid at $2.50 tier ([ADR-004](docs/decisions.md#adr-004), price: the $2.50 tier for every paid app; set in upload form with next version upload, live at $2.00 tier until then, no price number in listing or site text), 15 languages.

**Free + Pro (approved by the owner 2026-10-04, both uploaded 2026-10-04; Pro update live, Free pending Garmin review on 2026-10-10 (ROADMAP 7.12), [`docs/decisions.md`](docs/decisions.md) ADR-001 "Free + Pro ladder"; replaces old plan's decision 8 (`docs/archive/plan.md`), the price, day-45 price-flip rule retired):**
live paid app (`manifest.xml`, `monkey.jungle`, app id `8cd8f7f5-…`) becomes **HeroFace Pro** 1.1.0, behaviour unchanged; new **Free** twin (`manifest.free.xml`,
`monkey.free.jungle`, app id `be68898f-995b-45d9-860e-42ad508bd7fd`, 1.0.0) built beside it from same source, split at compile time with `(:pro)` / `(:free)`.
Free: Everyday and HeroSet mode, slots fixed to Auto, Accent 0 to 2, no seconds, no temperature. Pro adds metric per slot, Seconds, temperature. Both keep three accents (Magenta recoloured `#FFAAFF` 2026-10-04 to clear 3:1 track rule, ADR-003).
Names, icons, uploads are owner's (on-watch names "HeroFace" and "HeroFace Pro" confirmed pair, 2026-10-04). Pro price: $2.50 tier ([ADR-004](docs/decisions.md#adr-004), price: the $2.50 tier for every paid app); Free is free.

**Read first:** [`docs/status.md`](docs/status.md) (where things stand, evidence, gates; open items in root [`ROADMAP.md`](../ROADMAP.md)), then [`docs/archive/plan.md`](docs/archive/plan.md) (finished build plan, and why),
[`PRODUCT.md`](PRODUCT.md) (product truth), [`DESIGN.md`](DESIGN.md) (visual system),
[`docs/compatibility.md`](docs/compatibility.md) (products, evidence per screen size).

## Fast facts

- Works **without HeroSet**: bars = steps, intensity minutes, floors, each
  with fallback chain so no watch draws empty bar; ring = day as
  whole; gold line = step-goal streak. With HeroSet installed on
  CIQ 4.2+ watch, bars become push-ups/sit-ups/squats, ring the XP
  into current rank.
- HeroSet link = one **private complication** (HeroSet [ADR-044](../HeroSet/docs/decisions.md#adr-044),
  `HeroSetComplicationPublisher`). Value:
  `v|dayKey|push|sit|squat|rank|rankPct|streak|lastDoneDay|goal`. Field order
  = cross-project contract: changing on one side breaks other. New
  fields append, stay optional on this side (`goal` did); only breaking
  change bumps version, which makes face drop value entirely. Both apps must
  be signed with same key (`~/.garmin-connectiq/keys/developer_key`).
- One build for every product; newer APIs behind `has` checks
  (`Toybox has :Complications`, `:Weather`, `ActivityMonitor has
  :getHeartRateHistory`). No bitmaps, no per-device resources.
- Build (Pro; `monkey.free.jungle` is Free): `monkeyc -d fr965 -f monkey.jungle -o bin/HeroFace.prg -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3`
  (strict clean on both jungles; project used to be built only at default level).
- Tier-only code is `(:pro)` / `(:free)` (a `(:free)` twin returns default); Free never reads Slot1-3, Seconds or Weather, has no
  `Toybox.Weather` read and no `onPartialUpdate`. `Application.Properties.getValue` of key missing from properties file throws `InvalidKeyException` (SDK 9.2.0 reference).
  `AppName` lives only in `resources-free/strings` and `resources-pro/strings`, never in `resources/` or a `resources-<lang>/`; each jungle appends its tier folder to every `base.lang.<l>`
  (`python3 tools/check_strings.py`). **No settings file in shared `resources/`**.
- Tests, latest run 2026-10-06 (rectangles' square design pass and reviewer fixes, ADR-005 amendment; container simulator, no wrist): Pro 27 and Free 27 PASSED on venusq, venusqm, venusq2, venusq2m, venux1, fr965, fr255s and fenix5s, 23 each on instincte40mm; 15/15 languages on venusq, venusq2, venux1 on both tiers (Free sweep re-run 2026-10-06 with `tier=free` confirmed: `fit_languages.sh` did not pass TIER into container before then). Earlier run 2026-10-05 (rectangles, ADR-005): Pro 26 and Free 26 PASSED on venusq, venusqm, venusq2, venusq2m, venux1, fr965, fr255s and fenix5s, Pro 22 and Free 22 on instincte40mm, screen-fit test included.
- Tests, first run: Pro **24**, Free **24** (22 shared; Pro-only `disabledSecondsDrawNoSecondsBox`, `proSettingsReadTheirDefaults`; Free-only `freeReturnsDefaultsForProKeys`, `freeMissingPropertyKeyThrows`),
  **PASSED in the simulator** on fr965, fenix5s and fr55 on both jungles (2026-10-01; ten-size fit loop (both tiers) and memory view run 2026-10-04, see compatibility.md; nothing on a wrist): `tools/run_tests.sh <device> [jungle] [testName] [expectedCount]` (jungle defaults to `monkey.jungle`, Pro; run both; `EXPECT=24` fails full run on count mismatch).
  Trust printed `PASSED (…)` line, not exit code. Hung run = simulator needs restart.
- Compile every product, both jungles, no simulator: `tools/compile_sweep.sh`. Prove packages: `tools/check_free_package.sh [--build]` (Free has no Slot/Seconds/Weather key and no "Pro" word; Pro has them).
  Store packages: Free `dist/HeroFaceFree.iq`, Pro `dist/HeroFacePro.iq`.
- Screen check per size: `tools/run_tests.sh <device> <jungle> everyStateFitsThisDisplay`.
  `heroFaceLayoutReport` prints every row's box, how layout is read
  without screenshot.
- FR965 has run it (2026-09-20 onward): install, render, HeroSet link,
  reboot survival, full day of always-on wear. Battery, ghosting, seconds power budget, settings delivery still open — see
  [`docs/status.md`](docs/status.md) §1. Simulator evidence is not device evidence; say so
  when reporting.

## House rules

Same as HeroSet ([`../HeroSet/CLAUDE.md`](../HeroSet/CLAUDE.md) house rules), which this project mirrors:

- Every function: typed params and `as` return type. No `as Any`. Cast only
  after `instanceof` or null guard.
- No magic numbers: tunables and keys in `HeroFaceConfig`, geometry in
  `HeroFaceLayout`, colours in `HeroFacePalette`, text in `strings.xml`.
- Text fit measured, never guessed: draw through `HeroFaceDraw.text`, pick
  wording with `firstFitting`/`firstWithin`.
- Render only in `onUpdate`/`onPartialUpdate`; gather data in
  `HeroFaceReadings`, draw from `HeroFaceState`. Split lets
  screen-fit test render widest states.
- One class per file, `HeroFace` prefix. Functions ≲30 lines, files ≲250.
- Value the watch does not have is hidden, never faked or zero-filled.
- Comments explain *why*.
- Storage key spellings never change once shipped.

## Keeping things in sync

- Behaviour change → update [`docs/status.md`](docs/status.md) / [`docs/decisions.md`](docs/decisions.md) (and [`DESIGN.md`](DESIGN.md) if visual).
- Contract change → both projects and HeroSet's [ADR-044](../HeroSet/docs/decisions.md#adr-044) (complication contract), same session. Free + Pro split touches none of it.
- New product or layout change → run screen-fit test for that screen size
  and update [`docs/compatibility.md`](docs/compatibility.md).
- Test count appears in `README.md` and here (**Pro 28, Free 28** on round and rectangle products; **24 each** on an Instinct (`alwaysOnGreyReadsOnBlack` joined 2026-10-08, ADR-006): five colour-only accent tests drop, mono test and window layout test join; `rectangleRingStaysOnTheDisplay` and `streakOutranksTemperatureAndDoneRowsMatch` run everywhere, ADR-005); update both.
- **Instinct family (ADR-002, accepted 2026-10-04; 7 products, 1-bit, round window top right):** `HeroFacePalette` is two classes, `(:color)` and `(:mono)`, chosen by jungles (`base.excludeAnnotations = <tier>;mono`, and per Instinct product `<product>.excludeAnnotations = <tier>;color`; per-product line **replaces** base list, so restate tier's own). Accent setting is own file (`resources-accent-<tier>`; Pro's Seconds and Weather in `resources-pro-tail`) and Instinct `resourcePath` leaves accent folder out. Visible area = circle about 98 px radius (`HeroFaceLayout.VISIBLE_RADIUS_PX`), not whole square: **screenshot simulator for every layout change** (`docs/development.md`). `tools/fit_languages.sh <product>` runs per-language fit.
- **Rectangle family (ADR-005, proposed 2026-10-05; `venusq`, `venusqm`, `venusq2`, `venusq2m`, `venux1`):** `HeroFaceLayout.frame()` is `HeroFaceFrame` there (null elsewhere): ring as frame along screen edges (`box`, `fillFor`, `HeroFaceRing.frame`), row inset inside it (`inset`), rectangle's own stack (`stack`: time sized by its digits' ink, `DIGIT_HEIGHT_PERMILLE`, slack shared by three gaps, `secondsTimeFont` only while seconds draw; ADR-005 amendment 2026-10-05). Round and Instinct paths do not reach that code. `HeroFaceLayout.mc` still over 250-line house rule (Instinct window code next candidate to move out). Venu Sq / Sq Music not on Garmin's paid-app list (Free-only reach). Screenshot every layout change there too.
- New language: its line in **both** manifests and **both** jungles; its folder must not define `AppName` (`python3 tools/check_strings.py`).
- Change to tier's settings: both `resources-*/settings` folders, and `tools/check_free_package.sh` (pins each tier's keys and lists).