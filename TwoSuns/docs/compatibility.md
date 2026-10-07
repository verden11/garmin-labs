# Compatibility

Status: 2026-10-04. The 69 products that can run a watch face at Connect IQ 4.2 or newer in SDK 9.2.0 (`deviceGroup` in the SDK's `Devices/*/compiler.json`), less three Instinct products (below). Permissions `SensorHistory`, `ComplicationSubscriber` and `Positioning` (confirmed, not provisional — [ADR-005](decisions.md#adr-005-location-order-and-the-positioning-permission)) are declared on all of them. **Everything below is simulator evidence except the sunrise/sunset and Positioning device checks (`../device-test/`); nothing else has run on a wrist.**

## Supported products

One build for all of them: rows are stacked from measured font heights, so there are no per-device resources; the face draws only with primitives and system fonts. Watch-face memory is at least 128 KB on all 69. Memory used in a normal (`-r`) run was read on 2026-10-04 ("Measured 2026-10-04" below): 46.0 of 123.8 kB (Pro, round) and 45.9 of 59.8 kB (Pro, Instinct E).

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

The fēnix 9 family, FR70 and FR170 (API 6.0) are in by API level; the SDK's device lists omit them (documentation lag, not evidence the APIs are missing), so their first run is a risk: verify on a real watch before any claim (listing text never names watch models; the store's device tab is the claim).

## Rectangular AMOLED

`venusq2` and `venusq2m` (320 × 360) and `venux1` (448 × 486). **Since 2026-10-05 a square form (ADR-028, the rectangle track, proposed; simulator only; look approval open):** the sky ring is a rounded-rectangle track along the glass, the rows are measured against the rounded box inside it, and the time takes the largest font the box still holds (`../DESIGN.md` "Rectangle"). Before that the face kept its round design centred (screenshots `../../device-test/rect-review/before/`).

- Glass corners, measured off the alpha mask of the SDK's device images: about 10 px on `venusq2` (`venusq2.png`), 68 px on `venux1` (`device.png`). The track's centreline corner is 48 px and 67 px (150 permille of D), inset 9 px and 11 px (enough for the sun marker and its halo, `TwoSunsLayout.trackInsetFor`); `trackStaysOnTheDisplay` checks its outer edge every 5 minutes and `sunMarkerStaysOnTheGlass` the marker and halo every minute against those glass corners.
- Tests 2026-10-05/06, container simulator: Pro and Free full suites pass on `venusq2` and `venux1` (Pro 165, Free 76, 2026-10-07, the build reviewed in the fifth design review), including `everyStateFitsThisDisplay` and `alwaysOnFrameFitsAtEveryDrift`. `venusq2m` is compile-only (same screen as `venusq2`). Per-language screen fit (`tools/fit_languages.sh`, 15 languages, 2026-10-06): `everyStateFitsThisDisplay` and `alwaysOnFrameFitsAtEveryDrift` pass in every language on `venusq2` and `venux1`, both tiers (the 7 other errors per non-English run are the English-wording tests, expected under a string overlay). Note: `TIER=free` does not reach the container through `docker/run.sh`; the Free run was started with `docker/run.sh TwoSuns /ciq-docker/ciq-run.sh env TIER=free CIQ_IN_DOCKER=1 zsh tools/fit_languages.sh ...`.
- Seen in screenshots (simulator, canned sun times, curve and weather; recaptured 2026-10-07 on the final build, `../../device-test/rect-review/after/`): both tiers and both sizes in the morning, day, evening and night, the marker on a corner at 09:30, 14:30 and 21:30, the empty state (Free "No sun data", Pro "No place yet", `--` and the hollow bolt), a Body Battery value of 22 (dimmed accent) and always-on; Pro also with its default settings, with the battery row on and the weather row off, midnight at the top, a stale curve, and a sunrise tick with the morning golden hour on the top-left corner (sun times moved for the shot). With weather, battery and golden hour on, both sizes show every Pro row together (battery, date, time, weather, band, sun line) with the sun sentence's full wording. 24-hour burn-in (the simulator's heat map, always-on): no burn-in detected, peak luminance 1.03% (Pro) and 1.27% (Free) on `venusq2`, 1.57% (Pro and Free) on `venux1` (2026-10-07, final build).
- **Not seen:** any rectangle on a wrist.

## Instinct E and Instinct 3 Solar (added 2026-10-04, ADR-024, accepted 2026-10-04, simulator only)

`instincte40mm` (166 x 166, window 52 px), `instincte45mm` and `instinct3solar45mm` (176 x 176, window 62 px) join both manifests: **72 products**. CIQ 6.0 (Complications, `SensorHistory`, `Weather` all there), 1-bit (palette `000000`/`FFFFFF` only), **watch-face memory 65,536 B** (the other 69 have at least 128 KB).

- **What shows.** The bezel hides the corners: the visible area is the square cut by a circle about 98 px in radius. `TwoSunsLayout` clips rows to it; the screen-fit test fails any text box outside it or under the window (`collectWindowAndCorners`).
- **As built.** The sky ring is a 24-hour dial in the window; time and date left of it; weather row (Pro), Body Battery and the sun line below. **No watch battery row, no golden hour, no Accent setting** (an Instinct Free has no settings at all).
- **Memory (normal run, `-r` like the store export, simulator):** **Pro 45.8 kB and Free 25.9 kB used (45.9 and 26.1 kB on 2026-10-04, below) of the 59.8 kB the simulator reports** (the status bar after the face drew, `instincte40mm` and `instincte45mm` alike, 2026-10-04): Pro uses about 77% of the budget, so it has the least headroom of any face on these watches. The on-watch Customize menu was measured later in a harness ("Measured 2026-10-04" below: about 49 kB, 82%, at worst); a longer weather list and a refreshed Body Battery history were not exercised, so the peak is still not measured: **a real-watch memory check is needed before an upload.**
- **Tests, 2026-10-04, container simulator:** Pro 146/146 on `instincte40mm`, `instincte45mm`, `instinct3solar45mm`; Free 60/60 on `instincte40mm`, `instincte45mm`; round and rectangular controls Pro 154/154 on `fr965`, `fr255s`, `venusq2`, Free 67/67 on `fr965`. Per-language screen fit (15 languages) passes on `instincte40mm` and `instincte45mm` (Pro) and `instincte40mm` (Free; `tools/fit_languages.sh`). Compile sweep, both jungles, every product: 72/72 pass on each (`tools/compile_sweep.sh`). `tools/check_free_package.sh --build`: OK (93 part numbers; Free has no settings file on the Instinct parts, Pro no Accent or Golden there).
- **Not proven:** anything on a watch (real bezel margins, contrast, the location and Weather behaviour on an Instinct E / 3 Solar, the on-watch Customize menu).

## Excluded, and why

- **The Instinct 2 family and Descent G1** (CIQ 3.4, no Complications) and `instinctcrossover` (analog hands). Instinct 3 Solar 45 mm and Instinct E 40 / 45 mm were excluded by ADR-009 and are now included (below, ADR-024). (The Instinct 3 AMOLED 45 and 50 mm and the Instinct Crossover AMOLED are in the table above.)
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

## Free and Pro builds (ADR-020 (Free + Pro ladder), accepted and uploaded 2026-10-04)

Two builds, one source: **Pro** (`manifest.xml`, the live app id, `monkey.jungle`) and **Free** (`manifest.free.xml`, new app id, `monkey.free.jungle`). Both list the **same 69 products**, `minApiLevel` 4.2.0 and the same 15 languages; `tools/compile_sweep.sh` refuses to run if the two manifests' product lists differ. **Permissions differ, and Free's are a subset of Pro's**: Free declares `ComplicationSubscriber` only; Pro declares `ComplicationSubscriber`, `SensorHistory` and `Positioning` (the sentence at the top of this file describes Pro).

- **Why a Free twin matters here:** a paid app is sold only on Garmin's own list, so the paid listing can reach fewer than the 69 products; a free app may not be held to that list (**to verify** against the SDK's `Monetization/App_Sales` and the store form; the Free listing's real device list is only known after approval, so no count goes in any listing).
- Compile evidence, 2026-10-01 (compile only, simulator not used, SDK 9.2.0): both jungles, normal and test (`-t`) builds, `-w --typecheck 3`, on the ten `fit_all.sh` devices (`fr255s`, `fenix7s`, `fenix7`, `fenix7x`, `fr265s`, `fr165`, `epix2`, `fr965`, `venusq2`, `fenix9pro51mm`) and `venux1` (the 11 screen classes in the table above, the smallest round screen `fr255s` among them): 44 of 44 builds pass; zero warnings on `fr965`, `fenix9pro51mm` and `venux1`, and on the others only the known launcher-icon size notice (the placeholder icon, unchanged by this work). The whole-manifest sweep (`tools/compile_sweep.sh`, normal builds, 2026-10-01): **69 of 69 pass on each jungle, 0 fail**; 57 products per jungle carry only the launcher-icon size notice, 12 are warning-free.
- Tests: Pro 154, Free 67 (`development.md`). Run 2026-10-03 in the container: **Pro 154 passed** and **Free 67 passed** on the ten `fit_all.sh` devices (`fr255s`, `fenix7s`, `fenix7`, `fenix7x`, `fr265s`, `fr165`, `epix2`, `fr965`, `venusq2`, `fenix9pro51mm`). Simulator only.
- **Watch battery row (Pro, ADR-023), live-state boxes from `twoSunsLayoutReport` 2026-10-03:** drawn on `fenix7x` (280), `fr165` (390), `epix2` (416), `fr965` (454) and `fenix9pro51mm` (466); not drawn on `fr265s` and `venusq2` (360). Not measured: the other products.
- **Weather row (Pro, ADR-022), fit measured 2026-10-03 in the simulator** (`twoSunsLayoutReport`, `everyStateFitsThisDisplay` with four weather states, `weatherRowFormFollowsTheScreen`): the two-line row on 240 px and larger round screens (and the 320 by 360 `venusq2`), the one-line row beside the date on 218 px (`fr255s`). `fr265s` (360 px) has the least room (4 px spare). Not run: `venux1`, `fenix9pro51mm`, the other 60 products' real fonts.
- Screen fit for Free is **not measured**, and its memory was read only on `fr255s` (26.1 kB of 123.8 kB) and the Instinct E (26.1 kB of 59.8 kB), 2026-10-04: Free draws fewer rows (no date, no curve), so each state is a subset of what Pro already fits and its fit is expected to be no worse, but that is inference. Run `tools/fit_all.sh monkey.free.jungle`.
- The on-watch Customize menu has the Accent item only in Free; Pro's has the five.

## Measured 2026-10-04 (simulator)

Container simulator, SDK 9.2.0, English strings, the tree at `c0eead8` (Free's larger Body Battery number). **Simulator numbers, not device proof: nothing here ran on a wrist, and the simulator's weather, Body Battery and sun values are canned.** Memory is read off the simulator window's status bar ("used/limit kB", 1 kB = 1,024 B) of a `-r` build (the store export's flags) after the face drew (`FLAGS="-r -w" docker/shot.sh TwoSuns <jungle> <device>`).

| Device | Tier | Check | Result | Limit | Share |
|---|---|---|---|---|---|
| `instincte40mm` | Pro | face drawn | 45.9 kB used | 59.8 kB | **77%** |
| `instincte45mm` | Pro | face drawn | 45.9 kB used | 59.8 kB | **77%** |
| `instincte40mm` | Free | face drawn | 26.1 kB used | 59.8 kB | 44% |
| `fr255s` (218 px MIP) | Pro / Free | face drawn | 46.0 / 26.1 kB used | 123.8 kB | 37% / 21% |
| `fenix7s` (240 px MIP) | Pro | face drawn | 46.0 kB used | 123.8 kB | 37% |
| `fr955` (260 px MIP) | Pro | face drawn | 46.0 kB used | 123.8 kB | 37% |
| `instincte40mm` | Pro | Customize menu open (harness, below) | 42.0 kB used | n/a (harness 123.8 kB) | n/a |
| `instincte40mm` | Pro | "Ring orientation" list open | 42.9 kB used | n/a | n/a |
| `instincte40mm` | Pro | after toggling Curve, Date, Weather, Battery and scrolling | 42.0 kB used | n/a | n/a |
| `instincte40mm` | Pro | harness baseline (empty view, same code) | 39.6 kB used | n/a | n/a |

The Instinct Pro face at **77% of the simulator's budget (13.9 kB free) is the tightest figure of any face**; it is not within 5% of the limit, but it is the one to watch when the face grows (the Pro `.prg` already carries the weather row and the battery row). The earlier reading (45.8 kB) moved by 0.1 kB. Free on an Instinct is 26.1 kB (it was 25.9 kB before `c0eead8`).

**How the Customize menu was measured (and what that is worth).** The simulator has no route to the on-watch Customize screen (File > Edit Watch Face is greyed on every device tried) and a watch face may not `pushView`. So, in a private copy only (the repo is untouched), the manifest type was changed to `watch-app`, the `ComplicationSubscriber` permission removed (a watch-app cannot hold it) and the three `Complications` reads in `TwoSunsSources` stubbed to null (a few hundred bytes of code; the face is not shown), and `getInitialView` returned the real `TwoSunsSettingsMenu` and `TwoSunsSettingsDelegate`; the skin's Select, Down and Back buttons were clicked to open the Ring orientation list, back out, and toggle the four Pro toggles (the Instinct menu has no Accent and no Golden item). The reading is "this code with the menu on screen and no watch-face view"; the limit shown is the harness app's, not the face's 59.8 kB. Against an empty-view baseline of 39.6 kB the menu costs 2.4 kB and the orientation list 0.9 kB more. **Worst case if the real watch kept the face resident under the menu:** 45.9 + 2.4 + 0.9 = 49.2 kB of 59.8 kB (82%, 10.6 kB free); if it runs Customize without the face (the settings entry point is `getSettingsView`, not `getInitialView`), about 42.9 kB (72%). Either way the menu does not push the Instinct Pro past its limit; which of the two the real watch does, and which limit applies in that mode, is not known. The weather list, a refreshed Body Battery history and a real `Weather` object graph were not exercised (the simulator's canned weather is what drew the weather row above), so **a real-watch memory check on an Instinct E / 3 Solar is still needed before an upload**.

**MIP look (screenshots read by eye, `fr255s`, `fenix7s`, `fr955`).** The 24-hour ring, the time, the date, the Body Battery number and bolt and the sun sentence are readable; the weather row's three "ahead" icons are drawn in a mid grey (dimmer than the yellow now temperature) and are the faintest element, still readable on `fr955` and `fenix7s` (with the 4p / 8p / 11p labels) and on the 218 px `fr255s` (one-line row, no labels). Free on `fr255s` (time, bolt and number, sentence) is clean. Daylight legibility cannot be judged from a simulator picture.

## Paid distribution

A paid app (Pro) is sold only on the SDK's App_Sales product list (lowest tier CIQ 3.4) and in its country list, so the store's list will be shorter than this manifest. **No watch count and no watch model name goes in the listing; the store's device tab is the claim.**

## Paid vs free reach (2026-10-04)

Measured on the live 1.0.0 listing, by store part number against the manifest: **68 of 69 products are listed; 1 is not (D2 Air X10: on Garmin's paid list, yet sold to no paid app, reason unknown)**; 0 products are off the paid list. The 3 Instinct products added in 1.1.0 (72 in total) are on the paid list. So the paid Pro reaches about 71 of 72 products and a Free twin would add at most 1 (the unexplained one): **no Free-only reach to advertise**. No Instinct 2, 2S, 2X or Descent G1 exists in this app. Source: [`../../reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md) section 3.

## The export and "89 devices"

`monkeyc -e -r -f monkey.jungle -o dist/TwoSuns.iq -y $KEY` prints "89 OUT OF 89 DEVICES BUILT" for a manifest of 69 products. Inspected 2026-09-27 (`p7zip`, the `.iq` is a 7z archive): its own `manifest.xml` lists 89 `<iq:product>` entries, but keyed by internal build **part numbers** (e.g. `006-B4776-00`), not by the device ids our source manifest uses (`fr965` etc.) — this SDK version's package format does not carry human-readable device names in that tag, so the 89 could not be matched back to specific watch models from the archive alone. The build console names a device only when it warns (57 of the 89, all just the known launcher-icon-scaling notice); the other 32 build silently, with no id printed anywhere. **Still unresolved when this was written (2026-09-27), but the size of the gap is now confirmed by the archive itself, not just the console's count line.** The only way left to resolve it is what the checklist already says: at upload, the store form's own "Compatible Devices" list is authoritative and reads the actual package, not our guess.

**Update 2026-10-01 (SDK-file evidence, not the store's):** `tools/check_free_package.sh` maps the manifest's 69 product ids through the SDK's own `Devices/<id>/compiler.json` `partNumbers` and gets **exactly 89 part numbers, and both the Free and the Pro package contain all 89** (so the "89 OUT OF 89 DEVICES BUILT" line is consistent with some of the 69 products having more than one part number, which the SDK files show; whether those are hardware variants is **to verify**, and it is not 20 extra products). That explains the count; it does not replace the store form's Compatible Devices list, which stays authoritative.

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
- **MIP contrast in daylight** (night track `#5555AA` is 3.3:1 and the stale fill `#555555` 2.8:1; the always-on text is `#5C5C5C`, 3.1:1, AMOLED only, ADR-027, computed from hex values, not measured).
- **Always-on on a real AMOLED**: lit-pixel share, ghosting, whether the screen blanks.
- **Translations in any language.** The tests run in English; the date line in the test states is fixed English ("Wed 30 Sep"). `tools/fit_languages.sh` was written and not run. `tools/check_strings.py` checks parity and length only.
- **Real data**: the simulator has no GPS position, canned weather, canned Complication sun values and synthetic Body Battery history; layout and logic are proved, data never.
- **Memory** on a real watch (a normal `-r` run was read in the simulator on 2026-10-04, "Measured 2026-10-04" above), **battery** and **CPU**.
- **The `.iq` package contents** (89 versus 69).
- Everything on a wrist, including the fēnix 9 family, FR70 and FR170 first runs.
