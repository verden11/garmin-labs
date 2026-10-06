# Compatibility

Status: 2026-10-05. 129 products (117 round + 7 Instinct + 5 rectangle, below), every round watch-face product at Connect IQ
3.0 or newer in SDK 9.2.0. A watch face needs no buttons, so touch-only watches
(Venu, vívoactive, Instinct AMOLED) are supported here. HeroSet added Venu 2/3/4,
vívoactive 5/6, Approach S50/S70 and D2 Air X10 in its [ADR-048](../../HeroSet/docs/decisions.md#adr-048) (live in HeroSet 1.1.1); older Venu/vívoactive and Instinct are still HeroSet-less.

## Supported products

One build for all of them: the layout is proportional and every row is
measured, so there are no per-device resources. The smallest watch-face memory
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
## Free and Pro builds (ADR-001, the Free + Pro ladder; approved and uploaded 2026-10-04)

Two builds, one source: **Pro** (`manifest.xml`, the live app id, `monkey.jungle`) and **Free** (`manifest.free.xml`, new app id, `monkey.free.jungle`). Both list the **same products** (117 at the split, 124 with the Instinct family, 129 with the rectangles) (`tools/compile_sweep.sh` refuses to run if the two manifests' product lists differ), `minApiLevel` 3.0.0, the same 15 languages and the same single permission, `ComplicationSubscriber` (HeroSet mode needs it, so Free's permissions are equal to Pro's, never more).

- **Why a Free twin matters here:** a paid app is sold only on Garmin's own list, so the paid listing cannot reach every one of the 117 products; a free app is not held to that list (plan WP6: 33 more products). The Free listing's real device list is only known after approval, so no count goes in any listing.
- **What differs on the watch:** Free has no seconds and no temperature, and its three bars are always Auto; everything else on the face is identical. The row under the time carries the streak alone in Free (it already did when the temperature was off). The HeroSet link and its field order are unchanged (HeroSet [ADR-044](../../HeroSet/docs/decisions.md#adr-044), the complication contract).
- **Compile evidence, 2026-10-01 (compile only, simulator not used, SDK 9.2.0, `-w --typecheck 3`):** `tools/compile_sweep.sh` over all 117 manifest products for both jungles, run alone (one compile at a time in this folder): **117 pass, 0 fail on each**, zero warnings other than the known launcher-icon size notice (the 65 px icon scales on other sizes, the owner's call). An earlier pass run while I was also exporting and building tests in the same folder (and another project's sweep ran beside it) had three spurious failures (a compiler "critical error", an empty FAIL); each passed when re-run alone, so parallel compiles in one folder are not safe, and `tools/compile_sweep.sh` says so. Test builds (`-t`) compile on `fr965`, `fr55`, `fenix5s`, `vivoactive3`, `fenix9pro51mm` and `fr245` for both jungles. Both store packages were exported from the final source (`monkeyc -e -r`, 196 part numbers for the 117 product ids) and passed `tools/check_free_package.sh` (2026-10-01).
- **Size** (measured with `monkeyc -d <device> -f <jungle> -o bin/<name>.prg -y $KEY -w --typecheck 3`; the default check level gives identical sizes; `.prg` file size, not the runtime memory budget, which was **not measured**: fr965 / fr55 / fenix5s / vivoactive3 in bytes): the tree before this work 151,548 / 143,516 / 143,100 / 144,108; Pro now 152,300 / 144,268 / 143,852 / 144,860 (+752 each); Free now 150,716 / 142,508 / 142,108 / 143,116 (about 1.6 KB under Pro). Another build of the same tree reported Pro 152,220 and Free 150,636 on fr965 (80 B lower each, the same 1,584 B gap); I could not reproduce those numbers with the command above on three output names and did not find the cause (a build option or path difference), so treat the sizes as good to about 0.1 %. The 96 KB memory headroom of the smallest watches (fēnix 5S, vívoactive 3) was read in the simulator on 2026-10-04 (Free 29.7 kB, Pro 30.7 kB of 91.8 kB; "Measured 2026-10-04" below); the device half stays open in [`status.md`](status.md) §1.
- **Tests:** Pro 24 and Free 24 (22 shared) **PASSED in the simulator on both jungles on fr965, fenix5s and fr55, 2026-10-01** (including `freeMissingPropertyKeyThrows`, so the simulator throws for a missing key, and the Magenta known-issue test). **Run since (2026-10-04, see "Measured 2026-10-04" below):** the ten-size screen-fit loop on the Free jungle (25/25 on all ten sizes plus `vivoactive3`) and the memory view on `fenix5s` and `vivoactive3`, both tiers. **Pro ten-size loop: run 2026-10-04** (see below). A fit run on Free would not verify Free's own layout either: every state in `HeroFaceTestStates` carries seconds and a temperature, so the fit test draws Pro-shaped frames in both tiers (removing items cannot cause overflow, but the row under the time with the streak alone is never drawn by it; what Free really draws was looked at 2026-10-04, see below). Nothing on a wrist; a Free app id reading HeroSet's private complication has never been tried.
- **Tests, 2026-10-04 (after the Magenta recolour, ADR-003; container simulator, no wrist):** the full suite including `everyStateFitsThisDisplay` PASSED on both jungles: Pro 25 and Free 25 on `fr965`, `fr255s` and `epix2`; Pro 21 and Free 21 on `instincte40mm` and `instinct2` (the Instinct has no colour accent). Screenshots with Magenta selected (`docker/capture.sh`, part-way through the day): `fr965` Pro (454 px) and `fr255s` Free (218 px). The pale magenta reads against the grey track on the bars and the ring and is distinct from the white time; Free shows no temperature. Simulator only: daylight contrast on MIP is not checked.

## HeroSet link

66 of the 117 run Connect IQ 4.2+ and can read HeroSet's private complication
(HeroSet [ADR-044](../../HeroSet/docs/decisions.md#adr-044)). The rest — including HeroSet's own fēnix 6, MARQ Gen 1,
FR945 LTE, Enduro and Descent MK2 users, who cap at CIQ 3.4 — always show
everyday goals. Nothing breaks: the face never mentions a link it cannot make.

## Evidence per product

`everyStateFitsThisDisplay` renders the face's widest states with that device's
real fonts and fails on text outside the round display or overlapping rows. Run
so far, all passing (whole suite re-run **2026-09-22**, 15/15 each; after the 2026-09-24 review fixes, 16/16 on `fr965`, `fenix5s`, `venu`, `fr55`, `fenix9pro51mm`, `venu2s`): `fr55`
(208), `fenix5s` (218), `fenix5` (240), `vivoactive4` (260), `fenix7x` (280),
`fr265s` (360), `fr165` (390), `epix2` (416), `fr965` (454), `fenix9pro51mm`
(466) — one per screen size.

The fallback chain is checked the same way: on `fr245`, which has no
barometer, the slots resolve to steps / intensity minutes / **move bar**
instead of steps / intensity / floors, and the face runs with no empty bar.
`fenix5` and `fr245` also report no `Complications` and, on `fenix5`, no
`Weather`, so both fallbacks are exercised there.

**Only the FR965 has run it** (2026-09-20 onward: install, render, the HeroSet
link, reboot survival, a day of always-on wear; [`status.md`](status.md) §1). On every
other product the simulator proves geometry and fonts, not always-on
behaviour, daylight contrast on MIP or battery cost. The original Venu
(`venu`, `venud`, `d2air`) has a stricter burn-in rule than the FR965 — no
pixel lit for more than 3 minutes — and the sleep screen is unchecked against
it.

## Not supported, and why

| Group | Examples | What's missing |
|---|---|---|
| Semi-octagon | `instinctcrossover` | Analog hands over the display, no window in the simulator; left out as in HeroSet ADR-055. The other 7 semi-octagon products are supported (below) |
| Below Connect IQ 3.0 | fēnix 3, FR230/235/630, vívoactive Gen 1, FR45 | No `Application.Properties`, 48–64 KB, 4-bit colour: a second render path for 15 old watches |

## Instinct family (added 2026-10-03, ADR-002, accepted 2026-10-04, simulator only)

Seven semi-octagon products join both manifests (124 products): `instinct2`, `instinct2s` (163 x 156), `instinct2x`, `descentg1`, `instincte45mm`, `instinct3solar45mm` (176 x 176) and `instincte40mm` (166 x 166). Black and white (palette `000000`/`FFFFFF` only), **watch-face memory 65,536 B**, a round window top right (62 px; 52 px on the E 40 mm, 54 px on the 2S). CIQ 3.4 (the Instinct 2 family, no Complications: Everyday mode only) or CIQ 6.0 (E, 3 Solar: the HeroSet link can connect).

- **What shows.** The bezel hides the corners: the visible area is the square cut by a circle about 98 px in radius (96 to 100 px on all seven, from the alpha mask of the SDK's device images). `HeroFaceLayout` clips rows to a 96 px circle; the screen-fit test fails any text box whose corner leaves it (`collectCorners`) or that touches the window.
- **As built.** Time and date left of the window, the streak below it, the mission columns above the bottom corners; the ring is a gauge in the window. **No footer, no temperature, no seconds, no Accent setting.** See ADR-002.
- **Memory (normal run, `-r` like the store export, simulator):** 31.0 kB (Pro) and 29.8 kB (Free) used of the 59.8 kB the simulator reports, on `instinct2`; 26.8 kB and 25.8 kB on `instincte40mm` (the simulator window's status bar after the face drew, 2026-10-03). The limit is 65,536 B: about half is free. Seconds do not draw on an Instinct, so the partial-update path was not exercised there.
- **Tests, 2026-10-03, container simulator:** Pro 21/21 on `instinct2`, `instinct2s`, `instinct2x`, `descentg1`, `instincte40mm`, `instincte45mm`, `instinct3solar45mm`; Free 21/21 on `instinct2`, `instincte40mm`; round controls Pro 25/25 on `fr965`, `fr55` and Free 25/25 on `fr965`. Per-language screen fit (15 languages) on `instinct2`, `instinct2s`, `instincte40mm`: all 15 pass on all three (`tools/fit_languages.sh <product>`; mission labels and values are cut with a "." when a translation is longer than the 40 px column). Compile sweep, both jungles, every product: 124/124 pass on both jungles (`tools/compile_sweep.sh`, `-w --typecheck 3`). `tools/check_free_package.sh --build`: OK (207 part numbers; no Accent key on the 7 Instinct parts).
- **Not proven:** anything on a watch (real bezel margins, contrast, the HeroSet link on an Instinct E or 3 Solar, whether the on-watch Customize menu is offered).

## Rectangle family (added 2026-10-05, ADR-005, proposed, simulator only)

Five rectangular products join both manifests (129 products): `venusq`, `venusqm` (240 x 240 LCD, CIQ 3.3.6, watch-face memory 96 KB on `venusq`, 512 KB on `venusqm`), `venusq2`, `venusq2m` (320 x 360 AMOLED, CIQ 5.0, 128 KB) and `venux1` (448 x 486 AMOLED, CIQ 6.0.2, 128 KB, glass rounded about 68 px at the corners, measured off the SDK device skin on 2026-10-05; first recorded as about 53). Values from the SDK's `compiler.json` per device.

- **As built.** The ring is a frame: an open-bottom rounded rectangle along the screen's edges, filling clockwise from the lower left; rows fit inside it and inside its rounded corners; the top and bottom margins are half an inset. See ADR-005 and `DESIGN.md` "Rectangle".
- **Square design pass (2026-10-05, ADR-005 amendment, `HeroFaceFrame`).** The time is sized by its digits' ink: `venusq` `THAI_HOT` (39 px digits, was `HOT` 28), `venusq2` `HOT` (80, was `MILD` 41), `venux1` `THAI_HOT` (108, was `HOT` 86); with Pro's seconds on, `venusq2` `MEDIUM` (54) and `venux1` `HOT` (89), `venusq` unchanged. The spare height is shared by three gaps. The frame's centreline is a quarter inset in (`venux1` [11, 11, 437, 420, r 55], `venusq2` [8, 8, 312, 312, r 40], `venusq` [6, 6, 234, 204, r 30]). Measured on the `venux1` skin shot (3x, simulator): 8 px of black between glass and frame along the sides, about 7 px across the corner diagonal (was about 5 and 7). The straight run meets the corner arc without a step at native pixels.
- **Why the change was needed.** With the round code the ring sat on the inscribed circle and cut "MOVE" on `venusq2`, and the time's box (81 px at the smallest number font there) did not fit its 71 px band: `everyStateFitsThisDisplay` failed on `venusq2`. On `venux1` the wide band took a time that left Pro's seconds no room (the fit test caught a missing row), so on a rectangle the time font now keeps the seconds' width on both sides.
- **HeroSet mode:** `Complications` is true on `venusq2`, `venusq2m`, `venux1` (CIQ 5 and 6) and false on `venusq`, `venusqm` (CIQ 3.3: Everyday mode only).
- **Tests, 2026-10-05, container simulator:** the full suite, now with `rectangleRingStaysOnTheDisplay`, **Pro 26/26 and Free 26/26 PASSED on all five** (`venusq`, `venusqm`, `venusq2`, `venusq2m`, `venux1`). Regression, both jungles: `fr965`, `fr255s`, `fenix5s` 26/26 and `instincte40mm` 22/22. Compile sweep (`tools/compile_sweep.sh`, build container, `-w --typecheck 3`): **129 pass, 0 fail on each jungle** (launcher-icon notices only).
- **Square design pass, re-verified 2026-10-05/06 (container simulator, final tree):** full suites Pro and Free **26/26 PASSED** on `venusq`, `venusq2`, `venux1`, `fr965`, `fr255s`, `fenix5s`, **22/22** on `instincte40mm`; `tools/fit_languages.sh venusq venusq2 venux1`: **Pro 15 of 15 languages PASSED on each** (the Free runs were Pro runs: `docker/run.sh` forwards no `TIER`; the script now passes it in through `env` and prints `tier=`, but re-run 2026-10-06 after the MOVE ring fix, printing `tier=free`: **Free 15 of 15 languages PASSED on each**; Lithuanian on `venusq2` first failed, "ATSISP" with the done check sliding into "ATSIL" in the 90 px column; fixed on a rectangle by dropping the done check before cutting a label with ".": cutting first made push-ups and sit-ups both "ATS."); compile sweep **129 pass, 0 fail on each jungle**. Memory on `venusq` (96 KB class, `-r` build, face drawn, Seconds off, re-measured 2026-10-06 on the final tree): **Free 35.2 kB, Pro 36.4 kB of 91.8 kB** (38%, 40%).
- **Memory (`FLAGS="-r -w" docker/shot.sh`, the simulator window's status bar after the face drew, Seconds off):** `venusq` (96 KB class) Pro 34.5 kB and Free 33.3 kB used of 91.8 kB (38% and 36%).
- **Always-on and burn-in (Pro, `docker/capture.sh … edge_states.sh`):** on `venusq2`, `venux1` and also `venusq` the simulator puts the face in its burn-in composition (the dim drifting time only), which drifted between minutes. The 24-hour heat-map simulation on `venux1` (its heat-map window is 448 wide, so `sim_burnin_24h`, which looks for a 454-wide window, did not find it; the same steps were run by a scratch scenario): **"no screen burn-in detected, Peak Luminance Usage: 1.11%"** (Garmin's limit 10%).
- **Screenshots looked at (native, `bin/rect/` and `bin/edge/`, not kept in the repo):** Pro and Free everyday, every goal met, HeroSet mode (a canned HeroSet value, as in `tools/listing_shots.sh`; on `venusq` a look only, the watch cannot link), and Pro with Seconds, the temperature and Magenta, on all three sizes. The frame clears the X1's rounded glass and the Sq 2's corners, the fill runs up the left side and over the top, the seconds sit beside the time on all three, nothing is cut or overlapping. On `venux1` the time left a visible band above the temperature row; fixed by the square design pass (above), whose screenshots are in `device-test/rect-review/after/` (not in the repo).
- **Paid vs free reach.** Garmin's App Sales list (fetched 2026-10-05, https://developer.garmin.com/connect-iq/articles/monetization/App_Sales.html) has Venu Sq 2 and Sq 2 Music in the API 5.0 tier and Venu X1 in the 6.0 tier, and their part numbers (006-B4115, 006-B4116, 006-B4603) are in the live paid listings of Two Suns Pro and DayArc Pro (store API, same day). **Venu Sq and Sq Music are not on the list** (CIQ 3.3.6, below its lowest tier, API 3.4): as with the Instinct 2 family (ROADMAP 10.15), they stay in both manifests and only the Free twin reaches them. So Pro gains 3 products, Free 5. Listing text names no watch.
- **Not proven:** whether the real Venu Sq (LCD) reports `requiresBurnInProtection` (the simulator does; if the watch does not, it draws the full face in sleep, with Pro's seconds on partial updates); anything on a watch (real glass margins, the time's digit ink ratio (`DIGIT_HEIGHT_PERMILLE`, simulator-measured), AMOLED and LCD contrast, the frame against the real bezel, battery, the HeroSet link on a Venu Sq 2 or X1).

## Measured 2026-10-04 (simulator)

Container simulator, SDK 9.2.0, English strings; the face-drawn memory and the Free suite were re-run on the tree at `971a825` (the Instinct goal label), the power-budget runs on the tree just before it (`c0eead8`). **Simulator numbers, not device proof: nothing here ran on a wrist.** Memory is read off the simulator window's status bar ("used/limit kB", 1 kB = 1,024 B) of a `-r` build (the store export's flags) after the face drew (`FLAGS="-r -w" docker/shot.sh HeroFace monkey.free.jungle <device>`). A test run's memory is the harness's own 8 MB and is not used.

| Device | Tier | Check | Result | Limit | Share |
|---|---|---|---|---|---|
| `fenix5s` (218 px MIP, 96 KB class) | Free | face drawn | 29.7 kB used | 91.8 kB | 32% |
| `vivoactive3` (240 px MIP, 96 KB class) | Free | face drawn | 29.7 kB used | 91.8 kB | 32% |
| `fenix5s` | Pro | face drawn, Seconds off (default) | 30.7 kB used | 91.8 kB | 33% |
| `vivoactive3` | Pro | face drawn, Seconds off (default) | 30.7 kB used | 91.8 kB | 33% |
| `fenix5s` | Pro | Seconds on, Always-Active (low power), after about 2 minutes of partial updates | 30.9 kB used (tree before `971a825`; Seconds off read 30.5 kB then) | 91.8 kB | 34% |
| `fr955` (260 px MIP) | Pro | Seconds on, Always-Active, partial updates running | 26.7 kB used | 123.8 kB | 22% |

Screen fit and the full suite on the **Free** jungle (`tools/run_tests.sh <device> monkey.free.jungle`, includes `everyStateFitsThisDisplay`), 25/25 PASSED on each of the ten sizes plus the 96 KB product `vivoactive3`: `fr55` (208), `fenix5s` (218), `vivoactive3` (240), `fenix5` (240), `vivoactive4` (260), `fenix7x` (280), `fr265s` (360), `fr165` (390), `epix2` (416), `fr965` (454), `fenix9pro51mm` (466). This closes the "ten-size fit loop and the memory view not yet run" gap for Free (not repeated on Pro here). **Caveat unchanged:** the fit states always carry seconds and a temperature, so a Free run draws Pro-shaped frames; what Free really draws (date, time, three bars, battery and heart rate row, no seconds, no temperature) was looked at on the `fenix5s` and `vivoactive3` screenshots only, with the simulator's canned data (no streak, so the streak-alone row was not drawn).

Headroom on the 96 KB class is about 61 kB with Pro's seconds running; no limit risk. HeroFace has no on-watch Customize menu and no picker (no `getSettingsView`), so there is no menu peak to measure.

**Seconds power budget, as far as the simulator shows it (Pro, Seconds on, `fr955` and `fenix5s`, 2026-10-04).** Seconds are drawn by `onPartialUpdate`, which the simulator runs in Settings > Display Mode > Always-Active (low power); the seconds ticked (10:10:12 to 10:11:25 on the face) on both. File > View Watchface Diagnostics (Ctrl+W) was enabled on the MIP products tried (`fr955`, `fenix7`, `fenix5s`) and greyed on the AMOLED `fr965`, so no partial-update figure can be read for an AMOLED watch here. The dialog has four numbers and no units and no limit: `fr955` Total 5187, Execution 393, Graphics 426, Display 4368 (a second reading a minute later: 5594, 800, 426, 4368); `fenix5s` 6094, 843, 467, 4784 (the same on both readings). The numbers add up (Total = Execution + Graphics + Display); read as microseconds they are 5 to 6 ms per second of display time, 0.4 to 0.8 ms of it our code, but the unit is a guess. A private instrumented copy (an elapsed-time log inside `onPartialUpdate`, a log line in `onPowerBudgetExceeded`; the repo is untouched) measured 100 updates at 36 ms in total (`fenix5s`, longest 3 ms) and 453 ms in total (`fr955`, longest 19 ms; the container is an emulated x86 simulator on a shared machine, so the `fr955` figure is wall-clock noise). `onPowerBudgetExceeded` was **never called** in either run, so the simulator did not turn the seconds off. What this does not show: the real watch's limit (not in the dialog), the AMOLED watches, a day of battery. **A real overrun cannot be forced here, and the simulator's pass is not a device pass.**

**MIP look (screenshots read by eye, `fr955` 260 px, `fenix7x` 280 px, `fenix5s`, `vivoactive3`; Pro and Free).** The time and the bar counts (white) and the date, labels, temperature and battery line (MUTED `#AAAAAA`) are clearly readable on black. The ring and the bar tracks (TRACK `#555555`) are visible but dim: with every count at 0 the three bars are three dark-grey capsules, which is the lowest-contrast element on the screen. Free on `fr955` shows no temperature and no seconds, as designed. Daylight legibility on a reflective MIP screen cannot be judged from a simulator picture, so the MIP-contrast gate in `status.md` §1 stays open on the device side.

## Paid vs free reach (2026-10-04)

Garmin sells a paid app only on the products of its App Sales list. Measured on the live 1.0.1 listing, by store part number against the manifest: **69 of 117 products are listed; 48 are not = 37 off the paid list (the Free-only reach: Forerunner 55, 245, 645, 745, 935, 945 and 945 LTE, vívoactive 3 and 4 families, fēnix 5 family, fēnix 6S, Enduro, D2 Charlie/Delta, Descent Mk1, Approach S62 and others) + 11 on the list but sold to no paid app** (MARQ Gen 1 x8, Descent Mk2/Mk2i, Mk2 S, D2 Air X10; Garmin does not say why). The 7 Instinct products added in 1.1.0 split the same way: **Instinct E 40/45 mm and Instinct 3 Solar are on the paid list (3); Instinct 2, 2S, 2X and Descent G1 are not (4)**. So HeroFace Pro 1.1.0 can be sold on about 72 of 124 products, and only the Free twin reaches the other 52 (41 off the list + the 11 unsold). Both packages still carry all 124 products. Consequences: listing text never names watch models, in either listing; the store's device tab, taken from each build, is the claim (owner, 2026-10-04). Sources: [`../../reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md) section 3, `research_notes/Free and Pro ladder/garmin_rules.md` "Re-read 2026-10-04".

## Eight-colour Forerunner 55 (2026-10-04)

Garmin: the Forerunner 45 and 55 use an eight-colour palette (black, white, red, green, blue, cyan, magenta, yellow; SDK `fr55/compiler.json` agrees: 4 bits per pixel, those eight entries), and `Dc.setColor` "will always map the input color to the closest color available on the device" (SDK FAQ, "How Do I Optimize Bitmaps"; the metric is not stated). HeroFace draws 64-colour values with greys and pastels, none in that palette except black, white, green (`DONE` 0x00FF00), red (`ALERT`) and cyan (accent 2). **What is known:** the simulator `fr55` runs pass (suite 25/25, fit 25/25) and a Pro `fr55` screenshot was looked at 2026-10-04 (temperature row, bars and cyan ring read). **What is not known:** how a real FR55 renders the rest. If the watch maps to the nearest palette entry by RGB distance (our assumption, computed 2026-10-04, not observed): `TRACK` 0x555555 becomes black, so the bar and ring tracks would vanish against the black ground; `MUTED` 0xAAAAAA becomes white (same as the time); gold 0xFFAA00 becomes yellow; accent Blue 0x55AAFF becomes cyan (the same as the Cyan accent, so two of the three accents would look alike) and Magenta 0xFFAAFF becomes white. The simulator screenshots do not settle it: no `fr55` capture is kept in the repository and the one that was looked at was not compared to the eight colours, so whether the simulator maps colours the way the watch does is unknown. Only a wrist (or a build that draws the eight nearest colours) shows the truth. There is no FR55 owner or device test; FR55 is in the manifest only, and the Pro listing does not name it.

## Adding a product

1. Check `compiler.json` in the SDK's `Devices/` folder: display shape and
   size, watch-face memory, Connect IQ version.
2. Add it to `manifest.xml`.
3. Run `everyStateFitsThisDisplay` in its simulator; add its screen size to the
   evidence list above if it is a new one.

**Pro ten-size fit loop and what Free really draws (2026-10-04, container simulator, no wrist; ROADMAP 5.9).** Full suite incl. `everyStateFitsThisDisplay` on the **Pro** jungle, 25/25 PASSED on each of 12 products covering every screen size: `fr55` (208), `fenix5s` (218), `fr255s` (218), `fenix7s` (240), `vivoactive3` (240), `fenix7` (260), `fenix7x` (280), `fr265s` (360), `fr165` (390), `epix2` (416), `fr965` (454), `fenix9pro51mm` (466). Because the fit states always carry seconds and a temperature, the Free runs draw Pro-shaped frames, so Free's own frame was screenshotted on `fenix5s` and `vivoactive3` (`FLAGS="-r -w" docker/shot.sh HeroFace monkey.free.jungle fenix5s vivoactive3`) and looked at: date line, large time, three empty tracks with counts 0 and labels (STEP/INT/FLR on `fenix5s`, STEPS/INT/FLR on `vivoactive3`), battery and heart-rate row; all inside the ring, nothing cut or overlapping, no seconds and no temperature, a quiet empty band between the time and the bars (by design, nothing fills it). The simulator has no streak, so the streak-alone row was not drawn. One Pro screenshot (`fr55`, 8-colour) was also looked at: temperature row, bars and cyan ring read fine. No flaw found, nothing changed.
