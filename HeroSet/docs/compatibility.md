# Compatibility

Status: 2026-10-06. Decision records: [ADR-034](decisions.md#adr-034)/[035](decisions.md#adr-035)/[037](decisions.md#adr-037)/[038](decisions.md#adr-038) (waves 1–4), [ADR-048](decisions.md#adr-048) (wave 5).

## Supported products

92 products in both manifests: 82 round, seven Instinct products in wave 6 (live since 1.3.0), and three rectangles (wave 7b, unreleased). The round ones are 80 in five waves (live) and the two Instinct 3 AMOLED of wave 7 (added 2026-10-05, unreleased; the live package has 87). Every round one: round screen, Connect IQ 3.4+ (`minApiLevel`), accelerometer (app samples 25 Hz), optical HR. Waves 1–4 have the five-button layout (START, BACK, UP, DOWN, LIGHT); wave 5 is touch-first (START, BACK, touchscreen), where swipes replace UP/DOWN ([ADR-048](decisions.md#adr-048)). Layout proportional, every text row measured ([ADR-006](decisions.md#adr-006), [ADR-018](decisions.md#adr-018)) — no per-device resources exist.

### Wave 1 — round AMOLED ([ADR-034](decisions.md#adr-034))

Same hardware shape as FR965.

| Family | Products (`manifest` id) | Screen |
|---|---|---|
| Forerunner 965 / 970 | `fr965`, `fr970` | 454 px |
| Forerunner 570 | `fr57047mm`, `fr57042mm` | 454 / 390 px |
| Forerunner 265 | `fr265`, `fr265s` | 416 / 360 px |
| Forerunner 165 | `fr165`, `fr165m` | 390 px |
| epix Pro (Gen 2) | `epix2pro51mm`, `epix2pro47mm`, `epix2pro42mm` | 454 / 416 / 390 px |
| epix (Gen 2) | `epix2` | 416 px |
| fēnix 8 AMOLED | `fenix847mm`, `fenix8pro47mm`, `fenix843mm` | 454 / 416 px |
| fēnix E | `fenixe` | 416 px |

### Wave 2 — round MIP ([ADR-035](decisions.md#adr-035))

Memory-in-pixel screens, 218–280 px, 8 bits per pixel. Needed no code change: `HeroSetPalette` colors already Garmin 64-color palette (every channel 00, 55, AA or FF), and layout shrinks its fonts.

| Family | Products (`manifest` id) | Screen |
|---|---|---|
| fēnix 7 / 7 Pro | `fenix7s`, `fenix7spro`, `fenix7`, `fenix7pro`, `fenix7pronowifi`, `fenix7x`, `fenix7xpro`, `fenix7xpronowifi` | 240 / 260 / 280 px |
| fēnix 8 Solar | `fenix8solar47mm`, `fenix8solar51mm` | 260 / 280 px |
| fēnix 9 Pro Solar | `fenix9prosolar47mm`, `fenix9prosolar51mm` | 260 / 280 px |
| Forerunner 955 / Enduro 3 | `fr955`, `enduro3` | 260 / 280 px |
| Forerunner 255 | `fr255`, `fr255m`, `fr255s`, `fr255sm` | 260 / 218 px |

218 px `fr255s` = smallest supported screen, and 512 KB of app memory against 768 KB elsewhere in this wave. It is not the memory floor: wave 4's fēnix 6 family and Enduro cap watch apps at 128 KB (below).

### Wave 3 — more round AMOLED ([ADR-037](decisions.md#adr-037))

Same input model as FR965 (`enter, up, menu, down, esc`), Connect IQ 5.1+, 768 KB. No code change, manifest entry plus verification only.

| Family | Products (`manifest` id) | Screen |
|---|---|---|
| fēnix 9 / 9 Pro AMOLED | `fenix943mm`, `fenix947mm`, `fenix9pro43mm`, `fenix9pro47mm`, `fenix9pro51mm` | 416 / 454 / 466 px |
| MARQ (Gen 2) | `marq2`, `marq2aviator` | 390 px |
| D2 Mach | `d2mach1`, `d2mach2`, `d2mach2pro` | 416 / 454 px |
| Descent MK3 / G2 | `descentmk343mm`, `descentmk351mm`, `descentg2` | 390 / 454 px |
| Forerunner 170 / 70 | `fr170`, `fr170m`, `fr70` | 390 px |

466 px `fenix9pro51mm` = largest supported screen, and the first `round-466x466` device family here.

### Wave 4 — Connect IQ 3.4 MIP ([ADR-038](decisions.md#adr-038))

Older five-button MIP watches, reached by lowering `minApiLevel` 4.2.0 → 3.4.0. Every Toybox symbol the app uses exists at 3.4; no app code changed.

| Family | Products (`manifest` id) | Screen |
|---|---|---|
| fēnix 6 / 6 Pro | `fenix6s`, `fenix6spro`, `fenix6`, `fenix6pro`, `fenix6xpro` | 240 / 260 / 280 px |
| MARQ (Gen 1) | `marqadventurer`, `marqathlete`, `marqaviator`, `marqcaptain`, `marqcommander`, `marqdriver`, `marqexpedition`, `marqgolfer` | 240 px |
| Descent MK2 / MK2S | `descentmk2`, `descentmk2s` | 280 / 240 px |
| Forerunner 945 LTE | `fr945lte` | 240 px |
| Enduro (Gen 1) | `enduro` | 280 px |

### Wave 5 — touch-first round AMOLED ([ADR-048](decisions.md#adr-048))

No UP/DOWN keys: swipe up/down adjusts, `SWIPE:` hints, START (physical) finishes and saves; taps never commit. All CIQ 4.2+, so all publish the HeroFace complication.

| Family | Products (`manifest` id) | Screen |
|---|---|---|
| Venu 4 | `venu441mm`, `venu445mm` | 390 / 454 px |
| Venu 3 | `venu3`, `venu3s` | 454 / 390 px |
| Venu 2 | `venu2`, `venu2plus`, `venu2s` | 416 / 416 / 360 px |
| vívoactive 5 / 6 | `vivoactive5`, `vivoactive6` | 390 px |
| D2 Air X10 | `d2airx10` | 416 px |
| Approach S50 / S70 | `approachs50`, `approachs7042mm`, `approachs7047mm` | 390 / 390 / 454 px |

### Wave 6 (merged to main 2026-10-03, live as 1.3.0) — Instinct 2 family, 1-bit semi-octagon ([ADR-055](decisions.md#adr-055))

**Uploaded as 1.3.0 by the owner 2026-10-03 (1.3.1, uploaded 2026-10-04 and in review, carries the bezel-corner and glance fixes); look approved by the owner 2026-10-03, simulator evidence only (no watch available).** In both manifests on `main` (merged 2026-10-03). Black-and-white display, round subscreen window top right (the layout keeps out of it and uses it as the XP gauge), five buttons, Connect IQ 3.4 (no glance; the CIQ 6 products Instinct E and Instinct 3 Solar do get one: glance closure 2,112 B data + 3,241 B code, against their 32 KB limit, and their glance areas 164x61 / 154x61 are in `HeroSetGlanceFitTest`; the simulator draws that glance under the round window, so 1.3.1 lays it out left of the window with `getSubscreen()`, blind: ADR-055 amended 2026-10-04), 98,304 B of watch-app memory: measured peak 53,216 B in the simulator (store build, `-r`).

| Family | Products (`manifest` id) | Screen | Window |
|---|---|---|---|
| Instinct 2 / Solar / Dual Power / dēzl, Instinct 2X Solar | `instinct2`, `instinct2x` | 176 x 176 | 62 px |
| Instinct 2S | `instinct2s` | 163 x 156 | 54 px |
| Descent G1 / G1 Solar | `descentg1` | 176 x 176 | 62 px |
| Instinct 3 Solar 45 mm, Instinct E 45 mm | `instinct3solar45mm`, `instincte45mm` | 176 x 176 | 62 px |
| Instinct E 40 mm | `instincte40mm` | 166 x 166 | 52 px |

**Paid vs free reach (2026-10-04):** Garmin's paid-app product list does not include Instinct 2, 2S, 2X or Descent G1, so the paid HeroSet is not sold on those four although the package contains them; the store's device list for the live 1.3.0 lacks them (69 of 87 manifest products listed: 7 off the list, 11 on the list but unsold, see [`release-contract.md`](release-contract.md)). Instinct E 40/45 mm and Instinct 3 Solar 45 mm are on the list. Listing text never names watch models; the store's device tab, taken from the build, is the claim. A Free twin would be the only way to reach the other four.

Evidence is in ADR-055 (simulator only). `instinct2`, `instinct2s` and `instinct2x` list part numbers at CIQ 3.2.7 as well: units still on that firmware will not get the app.

### Wave 7 (unreleased, added 2026-10-05) — Instinct 3 AMOLED, round colour ([ADR-055](decisions.md#adr-055), amended 2026-10-05)

Plain round AMOLED products to the app: five buttons (`enter, up, menu, down, esc`, as on FR965), Connect IQ 6.0, 768 KB, 64 KB glance, colour palette (no `mono` line in the jungles). `HeroSetLayout` and the glance ask `getSubscreen()` only on semi-octagon screens, so the 98 px subscreen these two report is ignored by design. No app code changed: manifest and jungle lines, plus their glance areas in `HeroSetGlanceFitTest`. Both are on Garmin's paid-app list (below).

| Family | Products (`manifest` id) | Screen | Glance area |
|---|---|---|---|
| Instinct 3 AMOLED 45 mm | `instinct3amoled45mm` | 390 px | 320 x 99 |
| Instinct 3 AMOLED 50 mm | `instinct3amoled50mm` | 416 px | 346 x 106 |

**Evidence (2026-10-05, container simulator only; nothing on a wrist):** dev suite 116/116 and store suite 103/103 on both (they include `everyScreenFitsThisDisplay` and the glance fit tests); per-language fit sweep (`tools/fit-sweep.sh`) on `instinct3amoled45mm` for eng, ita, por, ukr, dut, lit, all PASSED. Screens looked at (store build, `docker/capture.sh HeroSet tools/drive_screens.sh <device> btn store.jungle 60,45,30 23 glance all`): glance, dashboard, menu, set, review, saved on both sizes; nothing clipped by the bezel. In the simulator's glance list the system draws the launcher icon in the round window and the glance's rows below it, clear of the ring, so no window layout is needed here. Real subscreen behaviour on a watch is unknown. Look approval of these screens is the owner's.

**Paid list (2026-10-05, closes ROADMAP 10.21 for HeroSet):** Garmin's App Sales article lists "Instinct® 3 AMOLED 45mm, Instinct® 3 AMOLED 50mm, … Instinct® Crossover AMOLED" in its API Level 6.0 row ([App_Sales.html](https://developer.garmin.com/connect-iq/articles/monetization/App_Sales.html), fetched 2026-10-05; the `/connect-iq/monetization/app-sales/` page is a script shell whose text is that article). All three are sold paid. An earlier research note placed Instinct 3 AMOLED under API Level 5.1; the current page says 6.0. Listing text names no watch model, so nothing there changes; the store's device tab grows with the next upload.

**Instinct Crossover AMOLED is left out (2026-10-05), not for store reasons.** Its simulator draws the analog hands parked at 9:15, a horizontal bar across the middle of the display, over the app: it covers the SIT-UPS row on the dashboard and the big rep number on the set and review screens (`bin/drive-instinctcrossoveramoled-1-dashboard-window.png`, `-3-counting-window.png`, `-5-review-window.png`, taken with the product added; the dev and store suites passed on it, 116/103, because they do not model the hands). Whether a real Crossover parks its hands there while an app runs is unverified. Adding it needs a hands-aware layout and the owner's look approval (ADR-055 amendment 2026-10-05).

### Wave 7b (unreleased, added 2026-10-05) — touch-first rectangles ([ADR-057](decisions.md#adr-057))

AMOLED, touch-first like wave 5 (START, BACK, touchscreen; the Sq 2 also has a MENU key), CIQ 5.0 / 6.0.2, 768 KB, glance (64 KB) and the HeroFace complication. No bezel: rows take the full width less half the safe inset; the dashboard's XP ring is a closed rounded-rectangle track along the screen's edges (corner radius 1.5 insets, clearing the X1's ~60 px glass corner as measured on the simulator skin) and the dashboard content fills its inner box (square design, ADR-057 amendment 2026-10-06). All three are on Garmin's paid-app list (the paid Two Suns 1.0.0 listing is offered on them). Simulator only: suites in both jungles, the 15-language fit sweep on `venusq2` and `venux1`, and screenshots of every screen on `venusq2` and `venux1` (2026-10-06, square design); look not yet approved by the owner.

| Family | Products (`manifest` id) | Screen | Glance area |
|---|---|---|---|
| Venu Sq 2 / Sq 2 Music | `venusq2`, `venusq2m` | 320 x 360 | 254 x 114 |
| Venu X1 | `venux1` | 448 x 486 | 314 x 150 |

`fenix6`, `fenix6s`, `enduro` cap watch apps at 128 KB — smallest supported memory. Measured in simulator (store build): dashboard ~52 KB, workout ~54 KB used, ~73 KB free.

**Evidence per product:** store build compiles, and `everyScreenFitsThisDisplay` passes in that device simulator: renders every screen in widest state with device real fonts, fails on text outside round display, overlapping text, or screen that drew fewer rows than it promises. Full suite run on FR965 plus size and screen-type representatives (`fr265s`, `fenix7`, `fenix7x`, `fr255s`, `fenix9prosolar51mm`, `fenix9pro51mm`) and on every wave 4 and wave 5 product.

**Only FR965 used on real watch.** Rep detection not device-dependent (accelerometer read in milli-g everywhere), but button feel, strap fit, MIP contrast in daylight, real rendering unconfirmed until beta testers run them.

## App glance ([ADR-051](decisions.md#adr-051))

A watch-app glance needs Connect IQ 4.0, so the glance list entry exists on **63 of the 80 live round products** (65 of 82 with wave 7's two Instinct 3 AMOLED, 320x99 and 346x106; 68 of 89 counting the Instinct E and 3 Solar; 71 of 92 with wave 7b's rectangles, 254x114 and 314x150): every product at CIQ 5.0 or newer, all with a 64 KB glance limit and live updates (device data, SDK 9.2.0). The other **17 get no glance** (the build is unchanged; the compiler, with `-w`, prints "The (:glance) annotation will be ignored"): fēnix 6 / 6S / 6 Pro / 6S Pro / 6X Pro, MARQ Gen 1 (8 products), Descent Mk2 / Mk2S, Forerunner 945 LTE, Enduro Gen 1 (Enduro 3 has it). Glance content areas run from 140×79 (`fr255s`) and 151×63 (fēnix 7S) to 359×130 (fēnix 9 Pro 51 mm); `HeroSetGlanceFitTest` carries all 34 distinct round areas (plus the two Instinct and two rectangle ones). Simulator only: no glance has run on a watch, the FR965's included. Never claim a glance on all 80 watches.

## Not yet supported, and why

| Group | Examples | What's missing |
|---|---|---|
| Touch-first below Connect IQ 3.4 | `venu`, `venud`, `d2air`, `vivoactive4`, `vivoactive4s` | Below `minApiLevel` ([ADR-038](decisions.md#adr-038)) |
| Instinct Crossover | `instinctcrossover` (MIP), `instinctcrossoveramoled` (round AMOLED, on the paid list) | Analog hands over the display: in the Crossover AMOLED simulator they cover the middle row and the rep number (wave 7 above); needs a hands-aware layout. See [ADR-055](decisions.md#adr-055) |
| Below Connect IQ 3.4 | fēnix 5 / 5 Plus, Forerunner 245/645/745/935/945, D2 Charlie/Delta, Descent MK1, vívoactive 3/4 | Below `minApiLevel`. `WatchUi.showToast` (save confirmation) is 3.4+, and fēnix 5 Plus fails screen fit (older, larger system fonts). FR945/745/245M pass the suite in simulator with a `has :showToast` guard — candidate wave, needs another save confirmation ([ADR-038](decisions.md#adr-038)) |
| Forerunner 55 | `fr55` | 208 px screen: dashboard rows overlap (fails `everyScreenFitsThisDisplay`) |

## Adding a product

1. Check its `compiler.json`/`simulator.json` in SDK `Devices/` folder: display shape and type, keys, Connect IQ version, `maxAccelRate`, memory.
2. Add to **both** manifests.
3. Compile store build for it, then run full unit suite in its simulator ([`development.md`](development.md)). `everyScreenFitsThisDisplay` must pass.
4. Add to table above, and to store listing device list.