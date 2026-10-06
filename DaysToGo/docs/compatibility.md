# Compatibility

Status: 2026-10-05. HeroFace's 117 products, plus 5 rectangular ones and the 7 Instinct products below (129): every round watch-face product at Connect IQ 3.0 or newer in SDK 9.2.0 (the list was made and checked for HeroFace, `../../HeroFace/docs/compatibility.md`). No permissions, so no product is excluded for a permission. **Everything below is simulator evidence; nothing has run on a wrist.**

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

**Square design since 2026-10-05 (ADR-019 (rectangles get a square design), unreleased):** the ring is a rounded-rectangle track along the glass edge and the rows run the box inside it; see "Rectangles: the square design" below. (Before: the round design, a circle the size of the shorter side, centred, with black bars.) All three are CIQ 5+ with 128 KB watch-face memory. Simulator only; the look on a rectangle is **not approved by the owner** (owner approves the simulator screenshots before any upload). The settings-screen list in the SDK was not checked for these three.

### Venu Sq and Venu Sq Music (added 2026-10-05, simulator only)

| Screen | Products | `manifest` ids |
|---|---|---|
| 240 × 240 LCD | 2 | `venusq`, `venusqm` |

The first-generation Venu Sq: a square **LCD** (not AMOLED), 16-bit colour, CIQ 3.3.6 (some part numbers 3.3.1), launcher icon 36 px. Watch-face memory from the SDK's `compiler.json`: **`venusq` 98,304 B (the 96 KB class), `venusqm` 524,288 B**. Nothing on record excluded them; ADR-006 (device set) simply added the three CIQ 5+ rectangles in 2026-09. They take the existing rectangle path (`SCREEN_SHAPE_RECTANGLE`, no per-device resources, no jungle lines): on a square screen the ring fills the screen edge to edge, as on a round watch, with no bars. **Not on Garmin's paid list** ("Paid vs free reach" below): only Days To Go (Free) reaches them. **Superseded 2026-10-05 by ADR-019 (rectangles get a square design):** all five rectangles now draw the rounded-rectangle track and the square stack ("Rectangles: the square design" below).

- **Tests (container simulator, SDK 9.2.0):** full suite Pro 68/68 and Free 57/57 on `venusq` and on `venusqm`; `everyStateFitsThisDisplay` passes on both jungles on each. After the always-on fix: full suites on both jungles also pass on `venusq2`, `venux1`, `fr965`, `fr55`, `epix2`, `fr265s`. Compile sweep (`tools/compile_sweep.sh`, `-w --typecheck 3`, build container): **129/129 on each jungle**; at first 126 (Free) and 117 (Pro) passed, and every failure was a scattered undefined symbol or the compiler's "critical error", from two sweeps plus a test run compiling in one folder (the known parallel-compile artefact). All 15 passed when re-run alone. `venusq` and `venusqm` give only the launcher-icon size notice (36 px). `check_free_package.sh --build` was **not** run (it exports `.iq` packages; its expected count is now 129).
- **Memory** (`FLAGS="-r -w" docker/shot.sh`, the status bar after the face drew, default New Year state): `venusq` Pro **35.4 / 91.8 kB (39%)**, Free **32.5 / 91.8 kB (35%)**. Higher than `fr55` (31.5 / 28.7 kB) but about 56 kB of headroom. `venusqm` not read (5x the budget).
- **Looked at** (screenshots, `venusq`, 10:09 on 2026-10-04): the default face (both tiers); a 12-character name "Anna and Tom" with the date (both) and with Pro's battery and steps lines; Pro's last-24-hours `7h 51m` with the battery line; always-on. On 240 × 240 **nothing is dropped**: name, hero, DAYS, `→ Sat Dec 19` and the bottom line all show (unlike `venusq2`, ROADMAP 10.12: its 320 px circle is narrower against its 39 px rows). The hero steps down a size when the bottom line is on.
- **Found and fixed: the always-on time was cut to "1" on the rectangles** (`venusq`, and also the live `venusq2`, so `venusq2m` with the same screen; `venux1` not measured before the fix). The rectangle's taller stack (ADR-016 (bottom line and name step-down), amendment (3), 90 % of the content radius; amendment (5) is this fix) put the time row where the always-on circle (smaller by the drift step) is too narrow, so `DaysToGoDraw.line` truncated it on the top and middle rows of the drift grid. The always-on frame now plans with the round span on every product (time and hero only, so it needs no extra height); the awake face is unchanged. `alwaysOnFrameFitsAtEveryDrift` now also fails if the time is not drawn whole: it failed on `venusq` and `venusq2` before the fix (114 misses each) and passes after on `venusq`, `venusq2`, `venux1`, `fr965`. Screenshots after the fix: `10:10` whole on `venusq` (both tiers) and `venusq2`. **Superseded by ADR-019:** the always-on frame on a rectangle now uses the box inside the track, made smaller by the drift step (at least 24 px), not the round span.
- **Always-on in the simulator is the AMOLED frame** (dim time and hero, drifting): the `venusq` simulator reports burn-in protection although the watch is LCD. On a real Venu Sq the face may instead stay the full face when asleep (the MIP rule, `DaysToGoView`); which one it shows is for a wrist.
- **Not proven:** anything on a wrist; LCD daylight contrast; the on-watch "Customize" route on CIQ 3.3 (not checked in the SDK's list).

### Rectangles: the square design (ADR-019, 2026-10-05, simulator only)

Applies to all five rectangles (`venusq`, `venusqm`, `venusq2`, `venusq2m`, `venux1`). Geometry per size (centreline inset from the glass edge, stroke, centreline corner radius, rows' depth from the edge):

| Screen | Inset | Stroke | Corner | Rows' depth |
|---|---|---|---|---|
| 240 × 240 (`venusq`, `venusqm`) | 5 | 6 | 36 | 12 |
| 320 × 360 (`venusq2`, `venusq2m`) | 7 | 8 | 48 | 17 |
| 448 × 486 (`venux1`) | 9 | 11 | 67 | 22 |

Glass corner, measured off the alpha mask of the SDK device images (`~/Library/Application Support/Garmin/ConnectIQ/Devices/<id>/`): about 64 px on `venux1` (rows clear of the mask from about y 60, 20 px in along the diagonal), about 10 px on `venusq` and `venusq2`. The track's outer corner on `venux1` is 72 px around the same corner region and stays inside the glass at the 45° diagonal. Computed bound: the track's outer edge stays inside a rounded glass corner of up to about 46 px on the Sq, 62 px on the Sq 2 and 84 px on the X1; only a glass rounder than that would clip it.

- **Tests (container simulator, 2026-10-07, build `1058682`, the caption tuck):** Pro 69/69 on `venusq`, `venusq2`, `venux1`, `fr965`, Pro 67/67 on `instincte40mm`; Free 58/58 on `venusq`, `venusq2`, `venux1`, `fr55`, Free 56/56 on `instincte40mm`. **Earlier (2026-10-06, after the second reviewer pass):** Pro 69/69 and Free 58/58 on `venusq`, `venusq2`, `venux1`, `fr965`, `fr55`; Pro 67/67 and Free 56/56 on `instincte40mm` (new test `rectangleTrackFillMatchesItsShare`; `bottomLineIsDrawnNotSilentlyDropped` now runs on the rectangles and passes); the three rectangles re-run on both jungles after the 24 px drift floor. Compile sweep (2026-10-05, before the reviewer fixes): 129/129 on each jungle.
- **Looked at** (native captures, both tiers, `venusq`, `venusq2`, `venux1`; a 16-character name with the date and Pro's battery line, Pro's last 24 hours `7h 50m`, TODAY with the full accent track, a 45-day race, and on Pro the 95 % cap (364 days: the gap sits just left of 12 o'clock), more than a year (454 days: grey track only), past (DAYS SINCE: grey track only) and weeks (`6`, WEEKS + 3 DAYS); always-on; and `docker/shot.sh` on the X1 and Sq 2 skins): nothing is dropped on any size, Pro's bottom line included (it was dropped on the Sq 2 before). A number hero keeps a band exactly its font's height and the caption sits a row gap under the digits' baseline (inside the font's empty descent; the fit test logs ink on rectangles, ADR-019); the spare height is split above the number and below the last row. A word hero (TODAY, SET A DATE) keeps the plain stack. Every size and tier now keeps the full date wording (`→ Sun Mar 14 2027`; Free on `venusq2` took the short `→ Mar 14 2027` until the caption was tucked under the digits, 2026-10-07). The name fixture is now "Hawaii honeymoon" (16 characters, the setting's maximum). The skin captures (`docker/shot.sh`, default New Year face) are re-taken on the current build. The track sits inside the X1's rounded glass with an even gap at all four corners. Corner joins: the first build showed a thin dark seam where an arc met a straight run (anti-aliased arc ends); the arcs now overlap the runs by a degree, and the zoomed capture shows none.
- **On-watch date picker on the rectangles (`tools/picker_shot.sh monkey.free.jungle venusq venusq2 venux1`, private harness, simulator, 2026-10-07; not changed by ADR-019):** not right on any of the three. `venusq`: month and day columns show (`Sep 30`) but no year column. `venusq2`: the three columns are drawn on top of each other (`Se30` garbled in the middle). `venux1`: the system draws a one-column picker (`Sep` only, with a focus glow), so the three-column layout of ADR-005 (on-watch date picker) does not apply there. The phone is the route the design relies on; the picker on rectangles is open for the owner (fix it, or record that Set date is not offered there).
- **Always-on burn-in, 24-hour simulation:** on the first build `venux1` passed ("no screen burn-in detected", peak 0.85 %) and `venusq2` too (0.72 %), but **`venusq` failed**: "Screen update will be shut off due to pixels remaining on for 3 minutes or more than 10 % of pixels" (Power Mode "Always-Active", pixel usage 1.55 %, so the 3-minute rule). The build before ADR-019 (main at `a4b042a`) fails the same way. On a 240 px screen the 3.5 % drift step is 8 px, so some of the hero's pixels stayed lit for three minutes running. **Fix: a rectangle drifts at least 24 px** (`RECTANGLE_MIN_DRIFT_PX`, round products unchanged). With a 16 px floor the screen lasted 7 minutes before the warning; with 24 px the `venusq` run finished "no screen burn-in detected", peak 1.68 % (default New Year state). With the 24 px floor (build `e1bf7da`; the always-on frame is unchanged since, `DaysToGoFrame.settle` runs only awake) the 24-hour run on the long-name state passes on all three: `venusq` "24-Hour simulation finished, no screen burn-in detected", peak pixel usage 1.95 %; `venusq2` peak luminance 0.72 %; `venux1` 0.85 %. The Venu Sq is an LCD; whether the watch applies the rule is for a wrist.

## The watch's own settings screen

`AppBase.getSettingsView` (on-watch "Set date") is listed in the SDK for 94 of the 117 products by name match. The 23 not listed are the D2 Charlie/Delta family, Descent Mk1, the vívoactive 3 family, FR645/935, fēnix Chronos, Approach S62 (older CIQ 3.x), and the newest (fēnix 9 family, FR70, FR170). On those the phone is the only way to set the date. The listing and support page must not promise the watch route on every watch, and the FR965 test (plan phase 3, T4) says nothing about the others.

## Free and Pro builds (ADR-014 (Free + Pro ladder), accepted and uploaded 2026-10-04)

Two builds, one source: **Pro** (`manifest.xml`, the live app id, `monkey.jungle`) and **Free** (`manifest.free.xml`, new app id, `monkey.free.jungle`). Both list the **same products** (120 at the time; 129 since 2026-10-05), `minApiLevel` 3.0.0, the same 15 languages and an empty permission list; `tools/compile_sweep.sh` refuses to run if the two manifests' product lists differ. Free's permissions are a subset of Pro's, never more.

- **Why a Free twin matters here:** a paid app is sold only on Garmin's own list, so the paid listing can never reach some of the 120 products; a free app is not held to that list (plan WP4: 33 more products; the Free listing's real device list is only known after approval, so no count goes in any listing).
- Compile evidence, 2026-10-01 (compile only, simulator not used, SDK 9.2.0): both jungles, normal and test builds, `-w --typecheck 3`, zero warnings on `fr965` and `venux1`; on `fr55` and `venusq2` only the known launcher-icon size notice (the placeholder icon, unchanged from before this work). The whole-manifest sweep is `tools/compile_sweep.sh`.
- Tests: the 43 existing tests are shared (one, the steps wording, is now Pro-only); there are 6 new shared tests (the accent table, Unit unset), 2 Pro-only (the steps wording moved here, Pro settings pass-through) and 3 Free-only. Totals: Pro 50, Free 51. **Run in the simulator 2026-10-01 (main thread): Pro 50 and Free 51 PASSED on `fr965`, `fr55` and `venusq2`.** Not run on a wrist.
- Screen fit: `tools/fit_all.sh` (the ten devices `fr55`, `fenix5s`, `fenix5`, `vivoactive4`, `fenix7x`, `fr265s`, `fr165`, `epix2`, `fr965`, `fenix9pro51mm`) passes on **both** jungles, simulator, 2026-10-01. Free memory use was **not measured separately at the time** (read 2026-10-04: "Measured 2026-10-04" below); the fit tests passing is the only Free layout evidence, and the three rectangles were run for tests on `venusq2` only.
- The on-watch "Customize" menu is the same in both tiers: one item, "Set date" (no accent item, no Pro item).

**Long stacks, 2026-10-04 (ADR-016 amended, ROADMAP 10.12; simulator only).** A 12-character event name with a date and Pro's bottom line on:

| Product | Result |
|---|---|
| `venusq2`, `venusq2m` (320 x 360) | The stack now spans 90 % of the content radius on a rectangle (80 % before; 39 px rows left the hero too little height). The name shows again and the hero keeps its largest font; the date steps down to its shorter wording ("Dec 19", not "Sat Dec 19") in Pro and Free; **Pro's bottom line is still dropped** (it does not fit that chord). |
| `venux1` (448 x 486) | Name, date and bottom line all show (on its own row). Looked at. |
| `fr965`, `fr255s`, `epix2` | Unchanged by construction (the change is for rectangles only); name, date and bottom line show. Looked at. |
| `instinct3solar45mm`, `instinct2` (176 x 176) | **Still cut a 12-character name** ("Anna and T..."), Pro and Free: the 23 px smallest font is already used, and a two-line name was tried and rejected because the hero would lose its room (ADR-016). `instincte40mm` (166 px) shows it whole. Not screenshotted: `instincte45mm` (same 176 px screen), `instinct2s`, `instinct2x`, `descentg1`. |

Tests after the change: the full suite PASSED on both jungles on `fr965`, `fr255s`, `epix2`, `venusq2`, `venux1`, `instinct2`, `instincte40mm`, `instinct3solar45mm`: Pro 52 (50 on an Instinct), Free 53 (51 on an Instinct). Simulator only; nothing on a wrist.

## To the minute (ADR-018, built and uploaded in Pro 1.1.0 2026-10-04, simulator only)

Pro's headline: Minute and Event time zone (phone settings), the countdown to the instant in the event's zone. Container simulator, SDK 9.2.0, English strings, the tree at commit `a6c7a35`. **Not device proof: nothing ran on a wrist, and the real time-zone and DST behaviour of a watch is unmeasured.**

**Tests** (the full suite, `tools/run_tests.sh <device> [jungle]`; includes `everyStateFitsThisDisplay` and `alwaysOnFrameFitsAtEveryDrift`; the widest hours text, `24:00`, is among the fit states):

| Device | Pro | Free |
|---|---|---|
| `fr965`, `fr255s`, `epix2`, `venusq2`, `fr55`, `fenix5s` | 66/66 | 55/55 |
| `instincte40mm`, `instinct3solar45mm`, `instinct2`, `instinct2s` | 64/64 | 53/53 |

Found on the way: `fr55` (an older compiler target) refuses a method with more than 9 arguments ("Too many arguments passed to method"; it affected only a test helper, now split). Production methods take at most 7.

**Memory** (`FLAGS="-r -w" docker/shot.sh`, the store export's flags, the simulator window's status bar after the face drew, 1 kB = 1,024 B; the 96 KB class budget is 91.8 kB):

| Device | Tier and state | Used | Limit | Share |
|---|---|---|---|---|
| `fr55` | Pro, to the minute (8:06 HOURS, name, bottom line) | 31.5 kB | 91.8 kB | 34% |
| `fenix5s` | Pro, same state | 31.4 kB | 91.8 kB | 34% |
| `fr55` | Pro before this work (9:51 HOURS, same state otherwise; tree `d03e30a`) | 28.2 kB | 91.8 kB | 31% |
| `fr55` | Free (default New Year face) | 28.7 kB | 91.8 kB | 31% |
| `fenix5s` | Free, same | 28.6 kB | 91.8 kB | 31% |
| `fr55` | Free before this work (`d03e30a`) | 27.7 kB | 91.8 kB | 30% |
| `instincte40mm`, `instinct3solar45mm` | Pro, to the minute | 28.2 kB | 59.8 kB | 47% |

Pro grew about 3.3 kB (the arithmetic, 100 more phone strings, the settings keys); Free grew about 1.0 kB (the shared arithmetic, dead there: Free has no Minute or zone). Headroom on the smallest budget: about 60 kB. Compare the earlier readings above: the Instinct Pro figure moved from 24.9 kB (E 40 mm, default state) to 28.2 kB.

**Instinct** (looked at, screenshots of `instincte40mm` and `instinct3solar45mm`, Pro, 8:06 HOURS with a name): `H:MM` is text beside the window, fully inside the visible circle, no overlap with the window, the time or the caption; the gauge in the window shows the share of the 24 hours. No layout change. **Round and rectangular:** `fr55`, `fenix5s` looked at (the hero `8:06` and the bottom line fit); `venusq2` runs the fit test.

**Package.** `monkeyc -e -r` through `verden-ciq-build:9.2.0` (`docker/run.sh`), both jungles, 210 parts each. `tools/check_free_package.sh` with explicit file arguments: OK for both. Pro is 8.8 MB (was 7.5 MB: the labels and titles in 15 languages across 210 parts); the store limit for a package was not checked here.

**Not proven:** any wrist behaviour; that Garmin Connect renders a 60-entry Minute list and a 40-entry zone list as intended (the lists are plain `list` settings, the same type as the Year list); the phone round trip of the two new keys (wrist check W1 in `status.md`).

## Instinct family (added 2026-10-03, ADR-015, accepted 2026-10-04, simulator only)

Seven semi-octagon products join both manifests (127 products): `instinct2`, `instinct2s` (163 x 156), `instinct2x`, `descentg1` and `instincte45mm`, `instinct3solar45mm` (176 x 176), `instincte40mm` (166 x 166). `instinctcrossover` is left out (analog hands over the display, no window in the simulator). All are black and white (palette `000000`/`FFFFFF` only), **watch-face memory 65,536 B**, have a round window top right (62 px; 52 px on the E 40 mm, 54 px on the 2S), and are CIQ 3.4 (the Instinct 2 family) or 6.0 (E, 3 Solar). The face needs no Complications, so the CIQ 3.4 watches are reachable.

- **What shows.** The bezel hides the corners: the visible area is the square cut by a circle about 98 px in radius (96 to 100 px on all seven, from the alpha mask of the SDK's device images). Rows are clipped to a 96 px circle in `DaysToGoLayout`; the screen-fit test fails any text box whose corner leaves it (`collectCorners`) or that touches the window.
- **Layout (as built, measured on the Instinct 2 simulator).** Time (35 px) and event name share the band left of the window; the hero (44 px, `FONT_NUMBER_HOT`, the largest that fits the height left) is below it, then the caption and the date. The bezel ring is a gauge in the window. **No footer** (battery or steps, Pro) and **no Accent setting** (owner, 2026-10-03). The smallest font is 23 px tall on a 176 px screen (20 px on the 166), so the real face is less airy than the mockup (`docs/archive/instinct-mockup.html`).
- **Memory (normal run, `-r` like the store export, simulator):** 27.7 kB (Pro) and 27.3 kB (Free) used of the 59.8 kB the simulator reports, on `instinct2`; 24.5 kB and 24.2 kB on `instincte40mm` (the simulator window's status bar after the face drew, 2026-10-03; an earlier `System.getSystemStats` probe on the first build read 27.4 of 61.3 kB). The limit is 65,536 B: about half is free. The on-watch date picker's reading is in "Measured 2026-10-04" below (28.2 kB with the picker open, in a harness).
- **Tests, 2026-10-03, container simulator:** Pro 49/49 on `instinct2`, `instinct2s`, `instinct2x`, `descentg1`, `instincte40mm`, `instincte45mm`, `instinct3solar45mm` and Free 50/50 on `instinct2`, `instincte40mm`; round and rectangular controls Pro 51/51 on `fr965`, `fr55`, `venusq2`, Free 52/52 on `fr965`. Per-language screen fit (15 languages) passes on `instinct2`, `instinct2s` and `instincte40mm`. Compile sweep, both jungles, every product: 127/127 pass on both jungles (`tools/compile_sweep.sh`, `-w --typecheck 3`). `tools/check_free_package.sh --build`: OK (210 part numbers; no Accent key on the 7 Instinct parts, Accent ids 0 to 5 on the rest; Pro-only code present in every Pro part, so the per-product exclude kept `(:pro)`).
- **Not proven:** anything on a watch (real bezel margins, contrast, whether the on-watch "Customize" menu is offered on an Instinct: not checked for these 7).

## Measured 2026-10-04 (simulator)

Container simulator, SDK 9.2.0, English strings, the tree at `8828ab0` (the bottom line and name step-down change) and later. **Simulator numbers, not device proof: nothing here ran on a wrist.** Memory is read off the simulator window's status bar ("used/limit kB", 1 kB = 1,024 B) of a `-r` build (the store export's flags) after the face drew (`FLAGS="-r -w" docker/shot.sh DaysToGo <jungle> <device>`). A test run's memory is the harness's own and is not used.

| Device | Tier | Check | Result | Limit | Share |
|---|---|---|---|---|---|
| `fr55` (208 px MIP, 96 KB class) | Free | face drawn | 27.6 kB used | 91.8 kB | 30% |
| `fenix5s` (218 px MIP, 96 KB class) | Free | face drawn | 27.5 kB used | 91.8 kB | 30% |
| `fr55`, `fenix5s` | Free | full suite on `monkey.free.jungle` (`everyStateFitsThisDisplay`, `alwaysOnFrameFitsAtEveryDrift` included) | 53/53 PASSED on each | n/a | n/a |
| `fr955` (260 px MIP) | Pro | face drawn | 24.7 kB used | 123.8 kB | 20% |
| `fenix7s` (240 px MIP) | Pro | face drawn | 24.8 kB used | 123.8 kB | 20% |
| `instincte40mm` | Pro / Free | face drawn | 24.9 / 24.5 kB used | 59.8 kB | 42% / 41% |
| `fr955` | Pro | Customize menu open (harness, below) | 24.1 kB used | n/a (harness limit 763.6 kB) | n/a |
| `fr955` | Pro | date picker open, last state reached | 28.2 kB used | n/a | n/a |
| `fenix5s` | Free | Customize menu open | 26.8 kB used | n/a (harness 123.8 kB) | n/a |
| `fenix5s` | Free | date picker open, last state reached | 31.0 kB used | n/a | n/a |
| `instincte40mm` | Pro | Customize menu open | 24.0 kB used | n/a (harness 123.8 kB) | n/a |
| `instincte40mm` | Pro | date picker open, last state reached | 28.2 kB used | n/a | n/a |

Both Free screenshots (`fr55`, `fenix5s`) and the Pro ones (`fr955`, `fenix7s`, Instinct) were looked at: time, count, "DAYS", date and ring draw inside the bezel with no footer row; the ring track (`#555555`) is a dim grey on black on the MIP screens, the count and the date stay readable. Daylight contrast on a real MIP is not testable here. This closes the "Free memory use was **not measured**" gap above, including the smallest watch-face budget (91.8 kB): headroom about 64 kB, no limit risk. The Instinct figures moved up 0.3 to 0.4 kB against the 2026-10-03 reading (24.5 / 24.2 kB) with the 2026-10-04 layout change.

**How the Customize menu and the date picker were measured (and what that is worth).** The simulator has no route to the on-watch Customize screen: File > Edit Watch Face is greyed on every device tried (`fr955`, `fr965`, `fenix7`), and a watch face may not `pushView` (the app dies with "Page control not allowed in current app type"). So, in a private copy only (the repo is untouched), the manifest type was changed to `watch-app` and `getInitialView` returned the real `DaysToGoSettingsMenu` and `DaysToGoSettingsDelegate`; the skin's Select and Down buttons were clicked to open the real date picker and move through its three columns. The number is therefore "this app with the menu or picker on screen and no watch-face view": it contains the same code and resources, and the objects the menu and the picker allocate, and the limit shown (123.8 or 763.6 kB) is the harness app's, **not** the face's 91.8 kB or 59.8 kB, so no percentage of a limit is claimed. Reading: a baseline run of the same harness with an empty `WatchUi.View` gives 21.5 kB (Instinct E 40 mm, Pro) and 24.3 kB (`fenix5s`, Free), so the Customize menu itself costs about 2.5 kB and the date picker about 6.7 kB above the code image (Instinct 24.0 and 28.2 kB, `fenix5s` 26.8 and 31.0 kB). Worst case, if the real watch kept the face resident under the picker: 24.9 + 6.7 = 31.6 kB of 59.8 kB on an Instinct E 40 mm (53%), 27.5 + 6.7 = 34.2 kB of 91.8 kB on `fenix5s` (37%). Not near a limit. Whether the real watch runs Customize with the face loaded, and which limit applies in that mode, is not known.

**The picker, found while measuring and fixed 2026-10-04 (ROADMAP 10.13, ADR-005 amended; simulator only).** Before: `pushDatePicker` built a plain `WatchUi.Picker` that never cleared its background; in the harness it drew **white** on the colour MIP screens `fr955` and `fenix5s` (white text on white), and on the 1-bit Instinct the columns were cut ("Octobe", "ery ye" on the E 40 mm). Each picker column is clipped to about a third of the screen width (the focused column is centred, its neighbour sits one third of the width away), so a long label is cut whatever the font.

What changed: the month column shows the **short month word of the watch's language** (`DaysToGoDateText.monthWord`, the "Oct" the date row uses); the label font steps down with the screen width (tiny up to 176 px, small up to 280 px, medium above); "Every year" is broken after its first word onto two lines; the picker is the class `DaysToGoDatePicker`, which clears to black before drawing (as the SDK's `samples/Picker` does). Tooling: `tools/picker_shot.sh <jungle> <device>...` (`YEARFIRST=1` starts on the year column, the widest label) opens the real picker in the private-copy `watch-app` harness (`tools/picker_harness.sh`) with no button clicks.

Looked at (container simulator, harness, widest labels: September and "Every year"):

| Device | Screen | Result |
|---|---|---|
| `instincte40mm` (Pro) | 166 px | "Sep" and "30" whole; the year column's "Every / year" whole on two lines (the lower line sits just above the down arrow). |
| `instinct3solar45mm` (Pro) | 176 px | "Sep", "30" whole; "Every / year" whole but tight: the down arrow touches the foot of "year". |
| `fr965` (Pro) | 454 px AMOLED | "Set date" and "Sep" large on black, centred, nothing cut. |
| `fenix5s` (Free), `fr955` (Free) | 218 / 260 px MIP | Labels are whole ("Sep", "30", "Every / year"), **but the page is still white** (see next). |

**The white page on a colour MIP watch is not fixed here, and the simulator cannot show whether it is fixed.** The black clear in `onUpdate` has no visible effect on `fenix5s`: a harness with a red box drawn after `Picker.onUpdate`, with no `Picker.onUpdate` call at all, and with a black-clearing first view all showed the identical white page, and **the SDK's own `samples/Picker` DatePicker (with its black clear) is white on `fenix5s` the same way**. So the simulator draws the colour MIP picker natively and ignores the app's clear; the code now equals Garmin's reference, and whether a real MIP watch shows white on white stays open until the wrist check (ROADMAP 3.1). The owner's FR965 check (AMOLED) opened the picker fine, and the picker is black on AMOLED and Instinct here.

Tests after the change (unit suite incl. `everyStateFitsThisDisplay`, container simulator): Pro 52 (50 on the Instinct) on `fr965`, `fr255s`, `epix2`, `venusq2`, `instincte40mm`; Free 53 (51 on the Instinct) on the same five. Compile sweep, both jungles, 127 products, `-w --typecheck 3`: 126 pass on each at first; the one failure on each (`fenix9pro43mm` Pro, `fr255s` Free) was the compiler's "critical error" from two sweeps running in one folder (the known parallel-compile artefact) and both passed when re-run alone. The picker is not part of the suite (it needs the harness).

## Paid distribution

A paid app (Pro) is sold only on the SDK's App_Sales product list (lowest tier CIQ 3.4) and in its country list, so the store's list will be shorter than this manifest. No watch count goes in the listing.

### Paid vs free reach (2026-10-04)

Measured on the live 1.0.1 listing, by store part number against the manifest: **72 of 120 products are listed; 48 are not = 37 off the paid list (the Free-only reach: Forerunner 55, 245, 645, 745, 935, 945 and 945 LTE, vívoactive 3 and 4 families, fēnix 5 family, fēnix 6S, Enduro, D2 Charlie/Delta, Descent Mk1, Approach S62 and others) + 11 on the list but sold to no paid app** (MARQ Gen 1 x8, Descent Mk2/Mk2i, Mk2 S, D2 Air X10; Garmin does not say why). Of the 7 Instinct products added in 1.1.0, **Instinct E 40/45 mm and Instinct 3 Solar are on the paid list (3); Instinct 2, 2S, 2X and Descent G1 are not (4)**. So Days To Go Pro 1.1.0 can be sold on about 75 of 127 products, and only the Free twin reaches the other 52 (41 off the list + the 11 unsold). Both packages still carry all 127. Listing text never names watch models, in either listing; the store's device tab is the claim (owner, 2026-10-04; [`release-contract.md`](release-contract.md)). Sources: [`../../reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md) section 3, `research_notes/Free and Pro ladder/garmin_rules.md` "Re-read 2026-10-04".

**Venu Sq and Venu Sq Music (2026-10-05):** **not on the paid list.** Garmin's App Sales page (`developer.garmin.com/connect-iq/articles/monetization/App_Sales.html`, read 2026-10-05) lists Venu Sq 2 and Sq 2 Music (API 5.0) but no first-generation Venu Sq, and their CIQ 3.3.6 is below the lowest paid tier (3.4); `research_notes/Verden research distilled/opportunities.md` row 8 already said "not Venu Sq 1". Following the Instinct 2 precedent (ROADMAP 10.15): both packages carry them, only the Free twin reaches them, no listing text names them. So Pro can be sold on about 75 of 129 products and only Free reaches the other 54 (43 off the list + the 11 unsold). Not yet read off a store device list (they ship with the next upload).

### Eight-colour Forerunner 55 (2026-10-04)

Garmin: the Forerunner 45 and 55 use an eight-colour palette (black, white, red, green, blue, cyan, magenta, yellow; SDK `fr55/compiler.json` agrees: 4 bits per pixel, those eight entries), and `Dc.setColor` "will always map the input color to the closest color available on the device" (SDK FAQ, "How Do I Optimize Bitmaps"; the metric is not stated). Days To Go draws 64-colour values with greys and pastels: only black, white and the accent `FFFFFF` are in the eight. **Known:** the `fr55` simulator runs pass (Free 53/53, Pro suite) and the Free `fr55` and `fenix5s` screenshots were looked at 2026-10-04 (above: the ring track read as dim grey "on the MIP screens", not separated by watch, and no `fr55` capture is kept in the repository). **Not known:** how a real FR55 renders the rest. If the watch maps to the nearest palette entry by RGB distance (our assumption, computed 2026-10-04, not observed): `TRACK` 0x555555 becomes black, so the ring track would vanish against the black ground; `MUTED` 0xAAAAAA becomes white; the six accents collapse to four looks: 0x55FFAA and 0x55AAFF both cyan, 0xFF55AA and 0xAA55FF both magenta, 0xFFAA00 yellow, 0xFFFFFF white. Whether the simulator maps colours the way the watch does is unknown, so a simulator screenshot does not settle it. Only a wrist, or a build that draws the nearest eight colours, shows the truth. FR55 is in the manifest only; the listings do not name it.

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
| 240 × 240 LCD (square rectangle, added 2026-10-05) | `venusq`, `venusqm` | pass (both jungles, 2026-10-05) |

Each run is 43 tests (the sweep of 2026-09-26 ran 42; the truncation test was added after), 2026-09-26, SDK 9.2.0 simulator. Not proven by these runs: legibility, MIP contrast, the always-on lit-pixel share (owner's heat map), other languages (the tests run in English; switch the simulator language and re-run `everyStateFitsThisDisplay` for German, Dutch, Finnish, Lithuanian, Ukrainian).

## Languages and time zone (simulator, 2026-09-26)

- **Translations on the smallest screen (fr55, 208 px):** all 14 languages plus English pass `everyStateFitsThisDisplay` and `alwaysOnFrameFitsAtEveryDrift` (`tools/fit_languages.sh`, which overlays each language's strings). In the 14 languages the word tests report errors by design (six at the time; 8 on a Pro run since ADR-018, which added tests that read the English caption) (they assert English wording). Not covered: the weekday and month words, which come from the simulator's own language (English), so the date line was not measured in translation; and native-speaker quality.
- **West of UTC:** the full suite (42 tests) passes on fr965 with the simulator started under `TZ=America/Los_Angeles`. That the simulator really used that zone is assumed from the environment variable, not observed.

## Memory (normal run, simulator, 2026-09-26)

| Device | Used | Total | Share |
|---|---|---|---|
| `fenix6pro` | 30,608 B | 110,408 B | 28% |
| `fr55` (smallest budget, 96 KB class) | 30,568 B | 94,024 B | 33% |

Target was 60% or less. A test run reports the harness's own 8 MB and is not meaningful.
