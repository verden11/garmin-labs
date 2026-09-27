# Compatibility

Status: 2026-09-27. The 69 products that can run a watch face at Connect IQ 4.2 or newer in SDK 9.2.0 (`deviceGroup` in the SDK's `Devices/*/compiler.json`), less three Instinct products (below). Permissions `SensorHistory`, `ComplicationSubscriber` and `Positioning` (confirmed, not provisional — [ADR-005](decisions.md#adr-005-location-order-and-the-positioning-permission)) are declared on all of them. **Everything below is simulator evidence except the sunrise/sunset and Positioning device checks (`../device-test/`); nothing else has run on a wrist.**

## Supported products

One build for all of them: rows are stacked from measured font heights, so there are no per-device resources; the face draws only with primitives and system fonts. Watch-face memory is at least 128 KB on all 69. Memory used in a normal (non-test) run has **not** been recorded for this face.

| Screen | Products | `manifest` ids | Fit test run on (simulator) |
|---|---|---|---|
| 466 px AMOLED | 1 | `fenix9pro51mm` | `fenix9pro51mm` |
| 454 px AMOLED | 14 | `approachs7047mm`, `d2mach2`, `d2mach2pro`, `descentmk351mm`, `epix2pro51mm`, `fenix847mm`, `fenix8pro47mm`, `fenix947mm`, `fenix9pro47mm`, `fr57047mm`, `fr965`, `fr970`, `venu3`, `venu445mm` | `fr965` (also `venu3`, full suite) |
| 448 × 486 px AMOLED | 1 | `venux1` | **not run** |
| 416 px AMOLED | 12 | `d2airx10`, `d2mach1`, `epix2`, `epix2pro47mm`, `fenix843mm`, `fenix943mm`, `fenix9pro43mm`, `fenixe`, `fr265`, `instinct3amoled50mm`, `venu2`, `venu2plus` | `epix2` |
| 390 px AMOLED | 19 | `approachs50`, `approachs7042mm`, `descentg2`, `descentmk343mm`, `epix2pro42mm`, `fr165`, `fr165m`, `fr170`, `fr170m`, `fr57042mm`, `fr70`, `instinct3amoled45mm`, `instinctcrossoveramoled`, `marq2`, `marq2aviator`, `venu3s`, `venu441mm`, `vivoactive5`, `vivoactive6` | `fr165` |
| 360 px AMOLED | 2 | `fr265s`, `venu2s` | `fr265s` |
| 320 × 360 px AMOLED | 2 | `venusq2`, `venusq2m` | `venusq2` |
| 280 px MIP | 6 | `enduro3`, `fenix7x`, `fenix7xpro`, `fenix7xpronowifi`, `fenix8solar51mm`, `fenix9prosolar51mm` | `fenix7x` |
| 260 px MIP | 8 | `fenix7`, `fenix7pro`, `fenix7pronowifi`, `fenix8solar47mm`, `fenix9prosolar47mm`, `fr255`, `fr255m`, `fr955` | `fenix7` |
| 240 px MIP | 2 | `fenix7s`, `fenix7spro` | `fenix7s` |
| 218 px MIP | 2 | `fr255s`, `fr255sm` | `fr255s` |

By screen: 51 AMOLED and 18 MIP products; 66 round and 3 rectangular. Checked by script on 2026-09-26 against the installed SDK's device files (`Devices/<id>/compiler.json` and `simulator.json`): every product's screen width and display type match this table, the shape counts are 66 round and 3 rectangle, and the watch-face memory limit is 131,072 bytes (128 KB) on all 69. The list in this table equals the `<iq:product>` lines of `manifest.xml`.

The fēnix 9 family, FR70 and FR170 (API 6.0) are in by API level; the SDK's device lists omit them (documentation lag, not evidence the APIs are missing), so their first run is a risk: verify on a real watch or say so on the listing.

## Rectangular AMOLED

`venusq2` and `venusq2m` (320 × 360) and `venux1` (448 × 486). The face keeps its round design: the ring is a circle the size of the shorter side, centred, with black bars above and below. Text is checked against the round chord, which is stricter than a rectangle needs. **Not looked at by eye; the look on a rectangle is not approved.** `venusq2` has been through the fit test; `venux1` has not been run at all.

## Excluded, and why

- **Instinct 3 Solar 45 mm, Instinct E 40 mm and 45 mm**: semi-octagon, 64 KB watch-face memory, monochrome. Days To Go excluded Instinct for the same reason. (The Instinct 3 AMOLED 45 and 50 mm and the Instinct Crossover AMOLED are in the table above.)
- **Every product below API 4.2** (no `Complications`): see the tier plan.
- **The fēnix 5 Plus family** has no Body Battery in the SDK's lists and is out permanently.

## Tiers below v1 (plan, not built)

| Tier | API | Products | Has | Plan |
|---|---|---|---|---|
| A (v1) | 4.2 and up | 69 (72 by API level, less 3 Instinct) | Complications, Body Battery history, Weather | This build |
| B | 3.4 to 4.1 | 23, all MIP: fēnix 6 family, FR55, FR945 LTE, MARQ Gen 1, Enduro, Descent Mk2, Instinct 2 family | Body Battery history, `Weather`, **no Complications** | Version 1.1, only if the location probes show a source that works: sunrise and sunset must come from the calculation and a location, the failure path the rival reviews describe |
| C | 3.3 | 16 (FR245, FR745, FR945, vívoactive 4, Venu, fēnix 5 Plus family, Venu Sq and Sq Music) | no Complications; some have no Body Battery | Never: a paid app is sold only on products at CIQ 3.4 and up |
| D | below 3.3 | 34 | no `Weather.getSunrise`, no Body Battery history | Never |

Counts are from `research_notes/Body Battery and sun face research/platform.md` §7 (API levels from the SDK, 2026-09-26). The SDK's supported-device lists for the three APIs, matched by name, show the fēnix 9 family, FR70 and FR170 as supporting none; that is documentation lag.

## Paid distribution

A paid app is sold only on the SDK's App_Sales product list (lowest tier CIQ 3.4) and in its country list, so the store's list will be shorter than this manifest. **No watch count goes in the listing.**

## The export and "89 devices"

`monkeyc -e -r -f monkey.jungle -o dist/TwoSuns.iq -y $KEY` prints "89 OUT OF 89 DEVICES BUILT" for a manifest of 69 products. Inspected 2026-09-27 (`p7zip`, the `.iq` is a 7z archive): its own `manifest.xml` lists 89 `<iq:product>` entries, but keyed by internal build **part numbers** (e.g. `006-B4776-00`), not by the device ids our source manifest uses (`fr965` etc.) — this SDK version's package format does not carry human-readable device names in that tag, so the 89 could not be matched back to specific watch models from the archive alone. The build console names a device only when it warns (57 of the 89, all just the known launcher-icon-scaling notice); the other 32 build silently, with no id printed anywhere. **Still unresolved, but the size of the gap is now confirmed by the archive itself, not just the console's count line.** The only way left to resolve it is what the checklist already says: at upload, the store form's own "Compatible Devices" list is authoritative and reads the actual package, not our guess.

## Evidence

Screen-fit test (`tools/fit_all.sh` runs `tools/run_tests.sh <device>` on ten devices, so the whole suite of 120 tests, the two fit tests included). It renders 31 states (10 sun states times 3 Body Battery states, plus one with the date off) at the device's real resolution and fonts, and the always-on frame at each of the nine drift positions, and fails on text outside the round display, an overlap, a text cut with "...", a dropped row that should be there, or a stack taller than the span. Simulator only, 2026-09-26, SDK 9.2.0, English strings.

| Screen | Device run | Result |
|---|---|---|
| 218 px MIP | `fr255s` | pass (120 of 120) |
| 240 px MIP | `fenix7s` | pass |
| 260 px MIP | `fenix7` | pass |
| 280 px MIP | `fenix7x` | pass |
| 360 px AMOLED | `fr265s` | pass |
| 390 px AMOLED | `fr165` | pass |
| 416 px AMOLED | `epix2` | pass |
| 454 px AMOLED | `fr965` | pass (`venu3` too) |
| 466 px AMOLED | `fenix9pro51mm` | pass |
| 320 × 360 AMOLED (rectangle) | `venusq2` | pass |
| 448 × 486 AMOLED (rectangle) | `venux1` | pass |

That is 10 of 11 screen sizes from `tools/fit_all.sh` (one product each), superseded by the full sweep below. `fr265s` (360 px) and `venusq2` failed an earlier, stronger version of the test with one sentence wording; the three wordings fixed it ([ADR-014](decisions.md#adr-014-three-wordings-for-the-sun-sentence)). **`tools/fit_products.sh`, the full 69-product sweep, ran 2026-09-27**: `done: 69 pass, 0 fail`, `PASSED (passed=122, failed=0, errors=0)` on every product including Venu X1 (`bin/fit-products.txt`). This run predates the on-watch Customize menu (ADR-019); the earlier compile-only sweep (all 69, `-w --typecheck 3`, zero errors) is superseded by this one.

## What was NOT tested

- **The rectangles by eye** (Venu Sq 2, Sq 2 Music, Venu X1): the fit test passed on all three, but the owner has not looked at them.
- **MIP contrast in daylight** (night track `#5555AA` is 3.3:1 and the stale fill and always-on text `#555555` 2.8:1, computed from hex values, not measured).
- **Always-on on a real AMOLED**: lit-pixel share, ghosting, whether the screen blanks.
- **Translations in any language.** The tests run in English; the date line in the test states is fixed English ("Wed 30 Sep"). `tools/fit_languages.sh` was written and not run. `tools/check_strings.py` checks parity and length only.
- **Real data**: the simulator has no GPS position, canned weather, canned Complication sun values and synthetic Body Battery history; layout and logic are proved, data never.
- **Memory** in a normal run, **battery** and **CPU**.
- **The `.iq` package contents** (89 versus 69).
- Everything on a wrist, including the fēnix 9 family, FR70 and FR170 first runs.
