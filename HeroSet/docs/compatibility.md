# Compatibility

Status: 2026-09-24. Decision records: [ADR-034](decisions.md#adr-034)/[035](decisions.md#adr-035)/[037](decisions.md#adr-037)/[038](decisions.md#adr-038) (waves 1–4), [ADR-048](decisions.md#adr-048) (wave 5).

## Supported products

80 products in both manifests, five waves. Every one: round screen, Connect IQ 3.4+ (`minApiLevel`), accelerometer (app samples 25 Hz), optical HR. Waves 1–4 have the five-button layout (START, BACK, UP, DOWN, LIGHT); wave 5 is touch-first (START, BACK, touchscreen), where swipes replace UP/DOWN ([ADR-048](decisions.md#adr-048)). Layout proportional, every text row measured ([ADR-006](decisions.md#adr-006), [ADR-018](decisions.md#adr-018)) — no per-device resources exist.

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

`fenix6`, `fenix6s`, `enduro` cap watch apps at 128 KB — smallest supported memory. Measured in simulator (store build): dashboard ~52 KB, workout ~54 KB used, ~73 KB free.

**Evidence per product:** store build compiles, and `everyScreenFitsThisDisplay` passes in that device simulator: renders every screen in widest state with device real fonts, fails on text outside round display, overlapping text, or screen that drew fewer rows than it promises. Full suite run on FR965 plus size and screen-type representatives (`fr265s`, `fenix7`, `fenix7x`, `fr255s`, `fenix9prosolar51mm`, `fenix9pro51mm`) and on every wave 4 and wave 5 product.

**Only FR965 used on real watch.** Rep detection not device-dependent (accelerometer read in milli-g everywhere), but button feel, strap fit, MIP contrast in daylight, real rendering unconfirmed until beta testers run them.

## Not yet supported, and why

| Group | Examples | What's missing |
|---|---|---|
| Touch-first below Connect IQ 3.4 | `venu`, `venud`, `d2air`, `vivoactive4`, `vivoactive4s` | Below `minApiLevel` ([ADR-038](decisions.md#adr-038)) |
| Instinct (AMOLED and MIP) | `instinct3amoled45mm`, `instinct3solar45mm`, `instinctcrossoveramoled`, `instincte45mm` | Screen has sub-window cut-out that round-chord layout doesn't model. Instinct E also caps apps at 128 KB |
| Square / rectangle | `venusq2`, `venux1` | Layout square path untested, these touch-first too |
| Below Connect IQ 3.4 | fēnix 5 / 5 Plus, Forerunner 245/645/745/935/945, D2 Charlie/Delta, Descent MK1, vívoactive 3/4 | Below `minApiLevel`. `WatchUi.showToast` (save confirmation) is 3.4+, and fēnix 5 Plus fails screen fit (older, larger system fonts). FR945/745/245M pass the suite in simulator with a `has :showToast` guard — candidate wave, needs another save confirmation ([ADR-038](decisions.md#adr-038)) |
| Forerunner 55 | `fr55` | 208 px screen: dashboard rows overlap (fails `everyScreenFitsThisDisplay`) |

## Adding a product

1. Check its `compiler.json`/`simulator.json` in SDK `Devices/` folder: display shape and type, keys, Connect IQ version, `maxAccelRate`, memory.
2. Add to **both** manifests.
3. Compile store build for it, then run full unit suite in its simulator ([`development.md`](development.md)). `everyScreenFitsThisDisplay` must pass.
4. Add to table above, and to store listing device list.