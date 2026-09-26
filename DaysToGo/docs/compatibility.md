# Compatibility

Status: 2026-09-26. HeroFace's 117 products, plus 3 rectangular ones below: every round watch-face product at Connect IQ 3.0 or newer in SDK 9.2.0 (the list was made and checked for HeroFace, `../../HeroFace/docs/compatibility.md`). No permissions, so no product is excluded for a permission. **Everything below is simulator evidence; nothing has run on a wrist.**

## Supported products

One build for all of them: rows are stacked from measured font heights, so there are no per-device resources. The smallest watch-face memory
budget among them is 96 KB, which is why the face draws only with primitives
and system fonts.

| Screen | Products | `manifest` ids |
|---|---|---|
| 466 px AMOLED | 1 | `fenix9pro51mm` |
| 454 px AMOLED | 14 | `approachs7047mm`, `d2mach2`, `d2mach2pro`, `descentmk351mm`, `epix2pro51mm`, `fenix847mm`, `fenix8pro47mm`, `fenix947mm`, `fenix9pro47mm`, `fr57047mm`, `fr965`, `fr970`, `venu3`, `venu445mm` |
| 416 px AMOLED | 12 | `d2airx10`, `d2mach1`, `epix2`, `epix2pro47mm`, `fenix843mm`, `fenix943mm`, `fenix9pro43mm`, `fenixe`, `fr265`, `instinct3amoled50mm`, `venu2`, `venu2plus` |
| 390 px AMOLED | 22 | `approachs50`, `approachs7042mm`, `d2air`, `descentg2`, `descentmk343mm`, `epix2pro42mm`, `fr165`, `fr165m`, `fr170`, `fr170m`, `fr57042mm`, `fr70`, `instinct3amoled45mm`, `instinctcrossoveramoled`, `marq2`, `marq2aviator`, `venu`, `venu3s`, `venu441mm`, `venud`, `vivoactive5`, `vivoactive6` |
| 360 px AMOLED | 2 | `fr265s`, `venu2s` |
| 280 px MIP | 9 | `descentmk2`, `enduro`, `enduro3`, `fenix6xpro`, `fenix7x`, `fenix7xpro`, `fenix7xpronowifi`, `fenix8solar51mm`, `fenix9prosolar51mm` |
| 260 px MIP | 14 | `approachs62`, `fenix6`, `fenix6pro`, `fenix7`, `fenix7pro`, `fenix7pronowifi`, `fenix8solar47mm`, `fenix9prosolar47mm`, `fr255`, `fr255m`, `fr955`, `legacyherofirstavenger`, `legacysagadarthvader`, `vivoactive4` |
| 240 px MIP | 35 | `d2charlie`, `d2delta`, `d2deltapx`, `d2deltas`, `descentmk1`, `descentmk2s`, `fenix5`, `fenix5plus`, `fenix5splus`, `fenix5x`, `fenix5xplus`, `fenix6s`, `fenix6spro`, `fenix7s`, `fenix7spro`, `fr245`, `fr245m`, `fr645`, `fr645m`, `fr745`, `fr935`, `fr945`, `fr945lte`, `marqadventurer`, `marqathlete`, `marqaviator`, `marqcaptain`, `marqcommander`, `marqdriver`, `marqexpedition`, `marqgolfer`, `vivoactive3`, `vivoactive3d`, `vivoactive3m`, `vivoactive3mlte` |
| 218 px MIP | 7 | `fenix5s`, `fenixchronos`, `fr255s`, `fr255sm`, `legacyherocaptainmarvel`, `legacysagarey`, `vivoactive4s` |
| 208 px MIP | 1 | `fr55` |
## Rectangular AMOLED (added 2026-09-26)

| Screen | Products | `manifest` ids |
|---|---|---|
| 320 × 360 AMOLED | 2 | `venusq2`, `venusq2m` |
| 448 × 486 AMOLED | 1 | `venux1` |

The face keeps its round design: the ring is a circle the size of the shorter side, centred, with black bars above and below. Text is checked against the round chord, which is stricter than a rectangle needs. All three are CIQ 5+ with 128 KB watch-face memory. Simulator only; the look on a rectangle is **not approved by the owner**. The settings-screen list in the SDK was not checked for these three.

## The watch's own settings screen

`AppBase.getSettingsView` (on-watch "Set date") is listed in the SDK for 94 of the 117 products by name match. The 23 not listed are the D2 Charlie/Delta family, Descent Mk1, the vívoactive 3 family, FR645/935, fēnix Chronos, Approach S62 (older CIQ 3.x), and the newest (fēnix 9 family, FR70, FR170). On those the phone is the only way to set the date. The listing and support page must not promise the watch route on every watch, and the FR965 test (plan phase 3, T4) says nothing about the others.

## Paid distribution

A paid app is sold only on the SDK's App_Sales product list (lowest tier CIQ 3.4) and in its country list, so the store's list will be shorter than this manifest. No watch count goes in the listing.

## Evidence

Screen-fit test (`tools/fit_all.sh`, simulator only): renders the widest states and the always-on frame at nine drift positions, fails on text outside the round display or overlapping.

| Screen | Device run | Result |
|---|---|---|
| 208 px MIP | `fr55` | pass |
| 218 px MIP | `fenix5s` | pass |
| 240 px MIP | `fenix5` | pass |
| 260 px MIP | `vivoactive4` | pass |
| 280 px MIP | `fenix7x` | pass |
| 360 px AMOLED | `fr265s` | pass |
| 390 px AMOLED | `fr165` | pass |
| 416 px AMOLED | `epix2` | pass |
| 454 px AMOLED | `fr965` | pass |
| 466 px AMOLED | `fenix9pro51mm` | pass |
| 320 × 360 AMOLED (rectangle) | `venusq2`, `venusq2m` | pass |
| 448 × 486 AMOLED (rectangle) | `venux1` | pass |

Each run is 43 tests (the sweep of 2026-09-26 ran 42; the truncation test was added after), 2026-09-26, SDK 9.2.0 simulator. Not proven by these runs: legibility, MIP contrast, the always-on lit-pixel share (owner's heat map), other languages (the tests run in English; switch the simulator language and re-run `everyStateFitsThisDisplay` for German, Dutch, Finnish, Lithuanian, Ukrainian).

## Languages and time zone (simulator, 2026-09-26)

- **Translations on the smallest screen (fr55, 208 px):** all 14 languages plus English pass `everyStateFitsThisDisplay` and `alwaysOnFrameFitsAtEveryDrift` (`tools/fit_languages.sh`, which overlays each language's strings). In the 14 languages the six word tests report errors by design (they assert English wording). Not covered: the weekday and month words, which come from the simulator's own language (English), so the date line was not measured in translation; and native-speaker quality.
- **West of UTC:** the full suite (42 tests) passes on fr965 with the simulator started under `TZ=America/Los_Angeles`. That the simulator really used that zone is assumed from the environment variable, not observed.

## Memory (normal run, simulator, 2026-09-26)

| Device | Used | Total | Share |
|---|---|---|---|
| `fenix6pro` | 30,608 B | 110,408 B | 28% |
| `fr55` (smallest budget, 96 KB class) | 30,568 B | 94,024 B | 33% |

Target was 60% or less. A test run reports the harness's own 8 MB and is not meaningful.
