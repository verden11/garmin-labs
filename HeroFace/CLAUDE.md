# HeroFace — CLAUDE.md

Garmin watch face (Connect IQ, Monkey C) from studio Verden. Time-first, in
HeroSet's visual language: bezel ring, three mission bars, gold streak.
124 products (117 round + 7 Instinct, ADR-002 (Instinct family), proposed, simulator only), `minApiLevel` 3.0.0. Paid, USD 2.00, 15 languages.

**Free + Pro (proposed, UNRELEASED, [`docs/decisions.md`](docs/decisions.md) ADR-001 "Free + Pro ladder"; the owner has not signed off, so the old plan's decision 8 (`docs/archive/plan.md`), the price, still governs):**
the live paid app (`manifest.xml`, `monkey.jungle`, app id `8cd8f7f5-…`) becomes **HeroFace Pro** 1.1.0, behaviour unchanged; a new **Free** twin (`manifest.free.xml`,
`monkey.free.jungle`, app id `be68898f-995b-45d9-860e-42ad508bd7fd`, 1.0.0) is built beside it from the same source, split at compile time with `(:pro)` / `(:free)`.
Free: Everyday and HeroSet mode, slots fixed to Auto, Accent 0 to 2, no seconds, no temperature. Pro adds the metric per slot, Seconds and the temperature. Both keep the shipped three accents.
Names, prices, icons, uploads are the owner's (the on-watch names "HeroFace" and "HeroFace Pro" are placeholders).

**Read first:** [`docs/status.md`](docs/status.md) (where things stand, evidence, gates; open items are in the root [`ROADMAP.md`](../ROADMAP.md)), then [`docs/archive/plan.md`](docs/archive/plan.md) (the finished build plan, and why),
[`PRODUCT.md`](PRODUCT.md) (product truth), [`DESIGN.md`](DESIGN.md) (the visual system),
[`docs/compatibility.md`](docs/compatibility.md) (products and the evidence per screen size).

## Fast facts

- Works **without HeroSet**: bars are steps, intensity minutes and floors, each
  with a fallback chain so no watch draws an empty bar; the ring is the day as
  a whole; the gold line is the step-goal streak. With HeroSet installed on a
  CIQ 4.2+ watch, the bars become push-ups/sit-ups/squats and the ring the XP
  into the current rank.
- The HeroSet link is one **private complication** (HeroSet [ADR-044](../HeroSet/docs/decisions.md#adr-044),
  `HeroSetComplicationPublisher`). Value:
  `v|dayKey|push|sit|squat|rank|rankPct|streak|lastDoneDay|goal`. Field order
  is a cross-project contract: changing it on one side breaks the other. New
  fields append and stay optional on this side (`goal` did); only a breaking
  change bumps the version, which makes the face drop the value entirely. Both apps must
  be signed with the same key (`~/.garmin-connectiq/keys/developer_key`).
- One build for every product; newer APIs sit behind `has` checks
  (`Toybox has :Complications`, `:Weather`, `ActivityMonitor has
  :getHeartRateHistory`). No bitmaps, no per-device resources.
- Build (Pro; `monkey.free.jungle` is Free): `monkeyc -d fr965 -f monkey.jungle -o bin/HeroFace.prg -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3`
  (strict is clean on both jungles; the project used to be built only at the default level).
- Tier-only code is `(:pro)` / `(:free)` (a `(:free)` twin returns the default); Free never reads Slot1-3, Seconds or Weather, and has no
  `Toybox.Weather` read and no `onPartialUpdate`. `Application.Properties.getValue` of a key missing from the properties file throws `InvalidKeyException` (SDK 9.2.0 reference).
  `AppName` lives only in `resources-free/strings` and `resources-pro/strings`, never in `resources/` or a `resources-<lang>/`; each jungle appends its tier folder to every `base.lang.<l>`
  (`python3 tools/check_strings.py`). There is **no settings file in the shared `resources/`**.
- Tests: Pro **24**, Free **24** (22 shared; Pro-only `disabledSecondsDrawNoSecondsBox`, `proSettingsReadTheirDefaults`; Free-only `freeReturnsDefaultsForProKeys`, `freeMissingPropertyKeyThrows`),
  **PASSED in the simulator** on fr965, fenix5s and fr55 on both jungles (2026-10-01; the ten-size fit loop and the memory view on fenix5s/vivoactive3 not yet run; nothing on a wrist): `tools/run_tests.sh <device> [jungle] [testName] [expectedCount]` (jungle defaults to `monkey.jungle`, Pro; run both; `EXPECT=24` fails a full run on a count mismatch).
  Trust the printed `PASSED (…)` line, not the exit code. A hung run means the
  simulator needs restarting.
- Compile every product, both jungles, no simulator: `tools/compile_sweep.sh`. Prove the packages: `tools/check_free_package.sh [--build]` (Free has no Slot/Seconds/Weather key and no "Pro" word; Pro has them).
  Store packages: Free `dist/HeroFaceFree.iq`, Pro `dist/HeroFacePro.iq` (`dist/old/` holds the earlier packages).
- Screen check per size: `tools/run_tests.sh <device> <jungle> everyStateFitsThisDisplay`.
  `heroFaceLayoutReport` prints every row's box, which is how layout is read
  without a screenshot.
- The FR965 has run it (2026-09-20 onward): install, render, the HeroSet link,
  reboot survival and a full day of always-on wear. Battery, ghosting, the
  seconds power budget and settings delivery are still open — see
  [`docs/status.md`](docs/status.md) §1. Simulator evidence is not device evidence; say so
  when reporting.

## House rules

Same as HeroSet ([`../HeroSet/CLAUDE.md`](../HeroSet/CLAUDE.md) house rules), which this project mirrors:

- Every function: typed params and `as` return type. No `as Any`. Cast only
  after an `instanceof` or null guard.
- No magic numbers: tunables and keys in `HeroFaceConfig`, geometry in
  `HeroFaceLayout`, colours in `HeroFacePalette`, text in `strings.xml`.
- Text fit is measured, never guessed: draw through `HeroFaceDraw.text`, pick
  wording with `firstFitting`/`firstWithin`.
- Render only in `onUpdate`/`onPartialUpdate`; gather data in
  `HeroFaceReadings`, draw from a `HeroFaceState`. That split is what lets the
  screen-fit test render the widest states.
- One class per file, `HeroFace` prefix. Functions ≲30 lines, files ≲250.
- A value the watch does not have is hidden, never faked or zero-filled.
- Comments explain *why*.
- Storage key spellings never change once shipped.

## Keeping things in sync

- Behaviour change → update [`docs/status.md`](docs/status.md) / [`docs/decisions.md`](docs/decisions.md) (and [`DESIGN.md`](DESIGN.md) if it is visual).
- Contract change → both projects and HeroSet's [ADR-044](../HeroSet/docs/decisions.md#adr-044) (the complication contract), same session. The Free + Pro split touches none of it.
- New product or layout change → run the screen-fit test for that screen size
  and update [`docs/compatibility.md`](docs/compatibility.md).
- Test count appears in `README.md` and here (**Pro 25, Free 25** on round products; **21 each** on an Instinct: the five colour-only accent tests drop, a mono test and the window layout test join); update both.
- **Instinct family (ADR-002, proposed; 7 products, 1-bit, a round window top right):** `HeroFacePalette` is two classes, `(:color)` and `(:mono)`, chosen by the jungles (`base.excludeAnnotations = <tier>;mono`, and per Instinct product `<product>.excludeAnnotations = <tier>;color`; a per-product line **replaces** the base list, so restate the tier's own). The Accent setting is its own file (`resources-accent-<tier>`; Pro's Seconds and Weather are in `resources-pro-tail`) and the Instinct `resourcePath` leaves the accent folder out. The visible area is a circle about 98 px in radius (`HeroFaceLayout.VISIBLE_RADIUS_PX`), not the whole square: **screenshot the simulator for every layout change** (`docs/development.md`). `tools/fit_languages.sh <product>` runs the per-language fit.
- A new language: its line in **both** manifests and **both** jungles; its folder must not define `AppName` (`python3 tools/check_strings.py`).
- A change to a tier's settings: both `resources-*/settings` folders, and `tools/check_free_package.sh` (it pins each tier's keys and lists).
