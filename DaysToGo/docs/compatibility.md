# Compatibility

Status: 2026-10-03. HeroFace's 117 products, plus 3 rectangular ones below: every round watch-face product at Connect IQ 3.0 or newer in SDK 9.2.0 (the list was made and checked for HeroFace, `../../HeroFace/docs/compatibility.md`). No permissions, so no product is excluded for a permission. **Everything below is simulator evidence; nothing has run on a wrist.**

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

## Free and Pro builds (ADR-014 (Free + Pro ladder), accepted 2026-10-04, UNRELEASED)

Two builds, one source: **Pro** (`manifest.xml`, the live app id, `monkey.jungle`) and **Free** (`manifest.free.xml`, new app id, `monkey.free.jungle`). Both list the **same 120 products**, `minApiLevel` 3.0.0, the same 15 languages and an empty permission list; `tools/compile_sweep.sh` refuses to run if the two manifests' product lists differ. Free's permissions are a subset of Pro's, never more.

- **Why a Free twin matters here:** a paid app is sold only on Garmin's own list, so the paid listing can never reach some of the 120 products; a free app is not held to that list (plan WP4: 33 more products; the Free listing's real device list is only known after approval, so no count goes in any listing).
- Compile evidence, 2026-10-01 (compile only, simulator not used, SDK 9.2.0): both jungles, normal and test builds, `-w --typecheck 3`, zero warnings on `fr965` and `venux1`; on `fr55` and `venusq2` only the known launcher-icon size notice (the placeholder icon, unchanged from before this work). The whole-manifest sweep is `tools/compile_sweep.sh`.
- Tests: the 43 existing tests are shared (one, the steps wording, is now Pro-only); there are 6 new shared tests (the accent table, Unit unset), 2 Pro-only (the steps wording moved here, Pro settings pass-through) and 3 Free-only. Totals: Pro 50, Free 51. **Run in the simulator 2026-10-01 (main thread): Pro 50 and Free 51 PASSED on `fr965`, `fr55` and `venusq2`.** Not run on a wrist.
- Screen fit: `tools/fit_all.sh` (the ten devices `fr55`, `fenix5s`, `fenix5`, `vivoactive4`, `fenix7x`, `fr265s`, `fr165`, `epix2`, `fr965`, `fenix9pro51mm`) passes on **both** jungles, simulator, 2026-10-01. Free memory use was **not measured separately at the time** (read 2026-10-04: "Measured 2026-10-04" below); the fit tests passing is the only Free layout evidence, and the three rectangles were run for tests on `venusq2` only.
- The on-watch "Customize" menu is the same in both tiers: one item, "Set date" (no accent item, no Pro item).

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

**Look at the picker (found while measuring; not fixed here).** `DaysToGoSettingsDelegate.pushDatePicker` builds a plain `WatchUi.Picker` and never clears its background (the SDK's own Picker sample overrides `onUpdate` to clear to black first). In the harness the picker draws on a **white** background on the colour MIP screens `fr955` and `fenix5s`, with the white title and white item text (outlined in black) hardly readable, while the Menu2 before it is black. On the 1-bit Instinct the picker is white on black and readable, but the three columns are cut ("Octobe", "ery ye" on the E 40 mm). The owner's FR965 check (AMOLED) opened the picker fine; no MIP watch has been tried, so check the date picker on a MIP watch before the listing says the on-watch route works there. It may be a harness effect (the app type is `watch-app`, not a watch face), which is why this is a flag and not a defect.

## Paid distribution

A paid app (Pro) is sold only on the SDK's App_Sales product list (lowest tier CIQ 3.4) and in its country list, so the store's list will be shorter than this manifest. No watch count goes in the listing.

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
