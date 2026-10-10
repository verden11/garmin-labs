# HeroSet glance support and memory budgets across the 80 supported products

Status date: 2026-09-26. SDK: Connect IQ 9.2.0 (`connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2`). Manifest: `/Users/mbp/dev/garmin/HeroSet/manifest.xml` (80 `<iq:product>` ids, `minApiLevel="3.4.0"`, app type `watch-app`). All local-file findings below from files on this Mac; paths given as `file://` links.

## Which of the 80 products support glances, and what are their glance / app memory budgets? (per-product table)

### Takeaway
All 80 products have `glance` entry in SDK device data (80/80, no missing device files). Glance memory 64 KB on 63 products (all CIQ 5.0+/6.0), 32 KB on 17 products (all CIQ 3.4, five-button MIP). But for 17 CIQ 3.4 products SDK Device Reference says glance must be "built as widget", HeroSet is `watch-app`, so "yes" in table = device-level capability, not confirmation watch-app glance shows up there (see CIQ <4 vs >=4 section).

### Cited Findings
- Per-device data in `~/Library/Application Support/Garmin/ConnectIQ/Devices/<id>/compiler.json` (`appTypes[].memoryLimit` per type: `glance`, `watchApp`, `widget`, `background`, `datafield`, `watchFace`, `audioContentProvider`; also `deviceGroup` "API level X.Y", `resolution`, `displayType` amoled/mip, `bitsPerPixel`, `partNumbers[].connectIQVersion`/`firmwareVersion`, `hardwarePartNumber`) and `simulator.json` (`glance` block with `contentArea`, `iconArea`, `liveUpdates`, `cacheUpdate`, `themes`; `display.isTouch`/`shape`; `keys[]` list of physical keys; `appStorageCapacity`). Example: [fr965/compiler.json](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Devices/fr965/compiler.json), [fr965/simulator.json](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Devices/fr965/simulator.json).
- SDK also ships Garmin's Device Reference as HTML, "Memory Limit / Notes" table (e.g. `Glance 65536 Build as Watch App or Widget`, `Glance 32768 Build as Widget`): [Device_Reference/fr965.html](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Device_Reference/fr965.html), [fenix6.html](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Device_Reference/fenix6.html). Glance limit in these pages equals `compiler.json` for all 70 products with a page (script check in table below); 10 products no page in this SDK's docs (all fēnix 9 / 9 Pro / 9 Pro Solar and FR170 / 170M / 70: `fenix943mm`, `fenix947mm`, `fenix9pro43mm`, `fenix9pro47mm`, `fenix9pro51mm`, `fenix9prosolar47mm`, `fenix9prosolar51mm`, `fr170`, `fr170m`, `fr70`). Their `compiler.json` data complete (glance 64 KB).
- Garmin's own text on limit: "it will be started in Glance mode with limited memory allocated (32KB for most devices)" — [Glances core topic, SDK copy](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Glances.html). SDK 9.2.0 data: now minority (17 of 80 here), every 4.x+ device 64 KB.
- Glance lifecycle categories, same doc: "Live UI Update" for devices "with ample resources" (glance kept alive, `requestUpdate()` works); "Background UI Update" for devices with less memory (app started only when system deems appropriate, `requestUpdate()` no effect, update on becoming visible and at least 30 s since last, then whole app lifecycle `onStart` -> `getGlanceView` -> `onLayout/onShow/onUpdate/onHide` -> `onStop` runs, rendered Dc cached to filesystem). Footnotes: "Music-capable wearables never skip leg day" / "Non-music wearables are on RAM keto". In `simulator.json` = `glance.liveUpdates`: false for exactly 11 products (`fenix6`, `fenix6s`, `enduro`, 8 MARQ Gen 1), true for other 69. [Glances.html](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Glances.html)
- HeroSet manifest declares `type="watch-app"` (line 8), lists no glance view; `AppBase.getGlanceView` not implemented anywhere in `/Users/mbp/dev/garmin/HeroSet/source` (grep). [manifest.xml](file:///Users/mbp/dev/garmin/HeroSet/manifest.xml), [docs/ideas.md idea 1](file:///Users/mbp/dev/garmin/HeroSet/docs/ideas.md) ("Glance support is per-device, not universal across the 80 products ... Glances have a tighter memory budget").

#### Summary groups (from the table)

| Group | Count | Products | Glance limit | Watch-app limit |
|---|---|---|---|---|
| **No glance at all** | 0 | none. All 80 have `glance` app type and `glance` simulator block | - | - |
| CIQ 3.4, glance only as widget type, **32 KB**, no live updates | 11 | `fenix6`, `fenix6s`, `enduro` (watch-app **128 KB**, widget 64 KB); 8 MARQ Gen 1 (`marqadventurer/athlete/aviator/captain/commander/driver/expedition/golfer`, watch-app 1280 KB, widget 1024 KB) | 32 KB | 128 KB (3) / 1280 KB (8) |
| CIQ 3.4, glance only as widget type, **32 KB**, live updates | 6 | `fenix6pro`, `fenix6spro`, `fenix6xpro`, `descentmk2`, `descentmk2s`, `fr945lte` | 32 KB | 1280 KB |
| CIQ 5.0-6.0, **64 KB**, MIP | 18 | fēnix 7 family (8), fēnix 8 Solar (2), fēnix 9 Pro Solar (2), `fr955`, `enduro3`, `fr255`, `fr255m`, `fr255s`, `fr255sm` | 64 KB | 768 KB (`fr255`, `fr255s`: 512 KB) |
| CIQ 5.0-6.0, **64 KB**, AMOLED, five-button + touch | 32 | wave 1 + wave 3 products | 64 KB | 768 KB |
| CIQ 5.0-6.0, **64 KB**, AMOLED, touch + 3-key or 2-key | 13 | wave 5 (Venu 2/2 Plus/2S, Venu 3/3S, Venu 4 41/45, vívoactive 5/6, D2 Air X10, Approach S50/S70 x2) | 64 KB | 768 KB |

Glance content area (simulator) ranges 151x63 px (`fenix6s`, `fenix7s`, `fenix7spro`, all MARQ Gen 1, `descentmk2s`) and 191x63 (`enduro`, `fenix7x*`, `descentmk2`, `fenix6xpro`) up to 359x130 (`fenix9pro51mm`); 63 px height = tightest layout target.

#### Full per-product table (generated by the script below, `simulator.json` + `compiler.json` + Device Reference, SDK 9.2.0)

"Glance" = device data has glance app type. "Live glance" = `simulator.json` `glance.liveUpdates`. "CIQ" = `connectIQVersion` values in `compiler.json` `partNumbers` (several firmware/part-number variants listed where differ). "Input" from `simulator.json` `keys[]` and `display.isTouch` (`5-btn` = enter/up/menu/down/esc, no touch). "Widget limit" `= watch-app` = `compiler.json` has no separate `widget` type (4.x+: widget is watch-app-type app, Device Ref says "Widget ... Requires 4.x SDK", same number as watch app).

| # | id | Product (SDK name, first alias) | Glance | Glance limit | Watch-app limit | Widget limit | CIQ (part-no. firmware) | Display | Input | Glance area (content px) | Live glance | Anomalies |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | `fr965` | Forerunner 965 | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 454x454 | 5-btn+touch | 299x148 | yes | - |
| 2 | `fr970` | Forerunner 970 | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | AMOLED 454x454 | 5-btn+touch | 299x130 | yes | - |
| 3 | `fr57047mm` | Forerunner 570 47mm | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | AMOLED 454x454 | 5-btn+touch | 299x130 | yes | - |
| 4 | `fr57042mm` | Forerunner 570 42mm | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | AMOLED 390x390 | 5-btn+touch | 257x113 | yes | - |
| 5 | `fr265` | Forerunner 265 | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 416x416 | 5-btn+touch | 275x120 | yes | - |
| 6 | `fr265s` | Forerunner 265s | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 360x360 | 5-btn+touch | 240x104 | yes | - |
| 7 | `fr165` | Forerunner 165 | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 390x390 | 5-btn+touch | 261x124 | yes | - |
| 8 | `fr165m` | Forerunner 165 Music | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 390x390 | 5-btn+touch | 261x124 | yes | - |
| 9 | `epix2pro51mm` | epix Pro (Gen 2) 51mm | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 454x454 | 5-btn+touch | 312x103 | yes | - |
| 10 | `epix2pro47mm` | epix Pro (Gen 2) 47mm | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 416x416 | 5-btn+touch | 274x103 | yes | - |
| 11 | `epix2pro42mm` | epix Pro (Gen 2) 42mm | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 390x390 | 5-btn+touch | 248x103 | yes | - |
| 12 | `epix2` | epix (Gen 2) | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 416x416 | 5-btn+touch | 274x103 | yes | - |
| 13 | `fenix847mm` | fēnix 8 47mm | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | AMOLED 454x454 | 5-btn+touch | 349x130 | yes | - |
| 14 | `fenix8pro47mm` | fēnix 8 Pro 47mm | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | AMOLED 454x454 | 5-btn+touch | 349x130 | yes | - |
| 15 | `fenix843mm` | fēnix 8 43mm | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | AMOLED 416x416 | 5-btn+touch | 325x122 | yes | - |
| 16 | `fenixe` | fēnix E | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | AMOLED 416x416 | 5-btn+touch | 325x122 | yes | - |
| 17 | `fenix7s` | fēnix 7S | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | MIP 240x240 | 5-btn+touch | 151x63 | yes | - |
| 18 | `fenix7spro` | fēnix 7S Pro | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | MIP 240x240 | 5-btn+touch | 151x63 | yes | - |
| 19 | `fenix7` | fēnix 7 | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | MIP 260x260 | 5-btn+touch | 171x63 | yes | - |
| 20 | `fenix7pro` | fēnix 7 Pro | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | MIP 260x260 | 5-btn+touch | 171x63 | yes | - |
| 21 | `fenix7pronowifi` | fēnix 7 Pro - Solar Edition (no Wi-Fi) | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | MIP 260x260 | 5-btn+touch | 171x63 | yes | - |
| 22 | `fenix7x` | fēnix 7X | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | MIP 280x280 | 5-btn+touch | 191x63 | yes | - |
| 23 | `fenix7xpro` | fēnix 7X Pro | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | MIP 280x280 | 5-btn+touch | 191x63 | yes | - |
| 24 | `fenix7xpronowifi` | fēnix 7X Pro - Solar Edition (no Wi-Fi | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | MIP 280x280 | 5-btn+touch | 191x63 | yes | - |
| 25 | `fenix8solar47mm` | fēnix 8 Solar 47mm | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | MIP 260x260 | 5-btn+touch | 198x81 | yes | - |
| 26 | `fenix8solar51mm` | fēnix 8 Solar 51mm | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | MIP 280x280 | 5-btn+touch | 217x88 | yes | - |
| 27 | `fenix9prosolar47mm` | fēnix 9 Pro Solar 47mm | yes | 64 KB | 768 KB | = watch-app | 6.0.3 | MIP 260x260 | 5-btn+touch | 199x81 | yes | no local Device_Reference page (product newer than SDK docs); glance build-type note inferred from CIQ>=4 |
| 28 | `fenix9prosolar51mm` | fēnix 9 Pro Solar 51mm | yes | 64 KB | 768 KB | = watch-app | 6.0.3 | MIP 280x280 | 5-btn+touch | 216x88 | yes | no local Device_Reference page (product newer than SDK docs); glance build-type note inferred from CIQ>=4 |
| 29 | `fr955` | Forerunner 955 | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | MIP 260x260 | 5-btn+touch | 176x93 | yes | - |
| 30 | `fr255` | Forerunner 255 | yes | 64 KB | 512 KB | = watch-app | 5.2.0 | MIP 260x260 | 5-btn | 176x93 | yes | watch-app 512 KB (others 768 KB) |
| 31 | `fr255m` | Forerunner 255 Music | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | MIP 260x260 | 5-btn | 176x93 | yes | - |
| 32 | `fr255s` | Forerunner 255s | yes | 64 KB | 512 KB | = watch-app | 5.2.0 | MIP 218x218 | 5-btn | 140x79 | yes | watch-app 512 KB (others 768 KB); smallest screen (218) |
| 33 | `fr255sm` | Forerunner 255s Music | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | MIP 218x218 | 5-btn | 140x79 | yes | smallest screen (218) |
| 34 | `enduro3` | Enduro 3 | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | MIP 280x280 | 5-btn+touch | 217x88 | yes | - |
| 35 | `fenix943mm` | fēnix 9 43mm | yes | 64 KB | 768 KB | = watch-app | 6.0.3 | AMOLED 416x416 | 5-btn+touch | 320x120 | yes | no local Device_Reference page (product newer than SDK docs); glance build-type note inferred from CIQ>=4 |
| 36 | `fenix947mm` | fēnix 9 47mm | yes | 64 KB | 768 KB | = watch-app | 6.0.3 | AMOLED 454x454 | 5-btn+touch | 349x130 | yes | no local Device_Reference page (product newer than SDK docs); glance build-type note inferred from CIQ>=4 |
| 37 | `fenix9pro43mm` | fēnix 9 Pro 43mm | yes | 64 KB | 768 KB | = watch-app | 6.0.3 | AMOLED 416x416 | 5-btn+touch | 320x130 | yes | no local Device_Reference page (product newer than SDK docs); glance build-type note inferred from CIQ>=4 |
| 38 | `fenix9pro47mm` | fēnix 9 Pro 47mm | yes | 64 KB | 768 KB | = watch-app | 6.0.3 | AMOLED 454x454 | 5-btn+touch | 349x130 | yes | no local Device_Reference page (product newer than SDK docs); glance build-type note inferred from CIQ>=4 |
| 39 | `fenix9pro51mm` | fēnix 9 Pro 51mm | yes | 64 KB | 768 KB | = watch-app | 6.0.3 | AMOLED 466x466 | 5-btn+touch | 359x130 | yes | no local Device_Reference page (product newer than SDK docs); glance build-type note inferred from CIQ>=4; largest screen (466) |
| 40 | `marq2` | MARQ (Gen 2) Athlete | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 390x390 | 5-btn+touch | 248x103 | yes | - |
| 41 | `marq2aviator` | MARQ (Gen 2) Aviator | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 390x390 | 5-btn+touch | 248x103 | yes | - |
| 42 | `d2mach1` | D2 Mach 1 | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 416x416 | 5-btn+touch | 274x103 | yes | - |
| 43 | `d2mach2` | D2 Mach 2 | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 454x454 | 5-btn+touch | 349x130 | yes | - |
| 44 | `d2mach2pro` | D2 Mach 2 Pro | yes | 64 KB | 768 KB | = watch-app | 6.0.0 | AMOLED 454x454 | 5-btn+touch | 349x130 | yes | - |
| 45 | `descentmk343mm` | Descent Mk3 43mm | yes | 64 KB | 768 KB | = watch-app | 5.1.0 | AMOLED 390x390 | 5-btn+touch | 248x103 | yes | - |
| 46 | `descentmk351mm` | Descent Mk3i 51mm | yes | 64 KB | 768 KB | = watch-app | 5.1.0 | AMOLED 454x454 | 5-btn+touch | 312x103 | yes | - |
| 47 | `descentg2` | Descent G2 | yes | 64 KB | 768 KB | = watch-app | 5.1.0 | AMOLED 390x390 | 5-btn+touch | 248x103 | yes | - |
| 48 | `fr170` | Forerunner 170 | yes | 64 KB | 768 KB | = watch-app | 6.0.0 | AMOLED 390x390 | 5-btn+touch | 257x125 | yes | no local Device_Reference page (product newer than SDK docs); glance build-type note inferred from CIQ>=4 |
| 49 | `fr170m` | Forerunner 170 Music | yes | 64 KB | 768 KB | = watch-app | 6.0.0 | AMOLED 390x390 | 5-btn+touch | 257x125 | yes | no local Device_Reference page (product newer than SDK docs); glance build-type note inferred from CIQ>=4 |
| 50 | `fr70` | Forerunner 70 | yes | 64 KB | 768 KB | = watch-app | 6.0.0 | AMOLED 390x390 | 5-btn+touch | 257x125 | yes | no local Device_Reference page (product newer than SDK docs); glance build-type note inferred from CIQ>=4 |
| 51 | `fenix6` | fēnix 6 | yes | 32 KB | 128 KB | 64 KB | 3.4.1/3.4.2/3.4.5 | MIP 260x260 | 5-btn | 176x93 | NO | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type; watch-app capped 128 KB; widget only 64 KB; no live glance updates (background/cached render) |
| 52 | `fenix6s` | fēnix 6S | yes | 32 KB | 128 KB | 64 KB | 3.4.1/3.4.2/3.4.5 | MIP 240x240 | 5-btn | 151x63 | NO | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type; watch-app capped 128 KB; widget only 64 KB; no live glance updates (background/cached render) |
| 53 | `fenix6pro` | fēnix 6 Pro | yes | 32 KB | 1280 KB | 1024 KB | 3.4.2/3.4.5 | MIP 260x260 | 5-btn | 176x93 | yes | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type |
| 54 | `fenix6spro` | fēnix 6S Pro | yes | 32 KB | 1280 KB | 1024 KB | 3.4.2/3.4.5 | MIP 240x240 | 5-btn | 151x63 | yes | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type |
| 55 | `fenix6xpro` | fēnix 6X Pro | yes | 32 KB | 1280 KB | 1024 KB | 3.4.2/3.4.5 | MIP 280x280 | 5-btn | 191x63 | yes | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type |
| 56 | `marqadventurer` | MARQ Adventurer | yes | 32 KB | 1280 KB | 1024 KB | 3.4.2/3.4.5 | MIP 240x240 | 5-btn | 151x63 | NO | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type; no live glance updates (background/cached render) |
| 57 | `marqathlete` | MARQ Athlete | yes | 32 KB | 1280 KB | 1024 KB | 3.4.2/3.4.5 | MIP 240x240 | 5-btn | 151x63 | NO | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type; no live glance updates (background/cached render) |
| 58 | `marqaviator` | MARQ Aviator | yes | 32 KB | 1280 KB | 1024 KB | 3.4.2/3.4.5 | MIP 240x240 | 5-btn | 151x63 | NO | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type; no live glance updates (background/cached render) |
| 59 | `marqcaptain` | MARQ Captain | yes | 32 KB | 1280 KB | 1024 KB | 3.4.2/3.4.5 | MIP 240x240 | 5-btn | 151x63 | NO | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type; no live glance updates (background/cached render) |
| 60 | `marqcommander` | MARQ Commander | yes | 32 KB | 1280 KB | 1024 KB | 3.4.2/3.4.5 | MIP 240x240 | 5-btn | 151x63 | NO | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type; no live glance updates (background/cached render) |
| 61 | `marqdriver` | MARQ Driver | yes | 32 KB | 1280 KB | 1024 KB | 3.4.2/3.4.5 | MIP 240x240 | 5-btn | 151x63 | NO | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type; no live glance updates (background/cached render) |
| 62 | `marqexpedition` | MARQ Expedition | yes | 32 KB | 1280 KB | 1024 KB | 3.4.2/3.4.5 | MIP 240x240 | 5-btn | 151x63 | NO | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type; no live glance updates (background/cached render) |
| 63 | `marqgolfer` | MARQ Golfer | yes | 32 KB | 1280 KB | 1024 KB | 3.4.2/3.4.5 | MIP 240x240 | 5-btn | 151x63 | NO | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type; no live glance updates (background/cached render) |
| 64 | `descentmk2` | Descent Mk2 | yes | 32 KB | 1280 KB | 1024 KB | 3.4.5 | MIP 280x280 | 5-btn | 191x63 | yes | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type |
| 65 | `descentmk2s` | Descent Mk2 S | yes | 32 KB | 1280 KB | 1024 KB | 3.4.5 | MIP 240x240 | 5-btn | 151x63 | yes | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type |
| 66 | `fr945lte` | Forerunner 945 LTE | yes | 32 KB | 1280 KB | 1024 KB | 3.4.3 | MIP 240x240 | 5-btn | 161x83 | yes | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type |
| 67 | `enduro` | Enduro | yes | 32 KB | 128 KB | 64 KB | 3.4.2 | MIP 280x280 | 5-btn | 191x63 | NO | 3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type; watch-app capped 128 KB; widget only 64 KB; no live glance updates (background/cached render) |
| 68 | `venu441mm` | Venu 4 41mm | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | AMOLED 390x390 | touch+2-key (START/BACK) | 274x128 | yes | - |
| 69 | `venu445mm` | Venu 4 45mm | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | AMOLED 454x454 | touch+2-key (START/BACK) | 318x150 | yes | - |
| 70 | `venu3` | Venu 3 | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 454x454 | touch+3-key (START/MENU/BACK) | 303x164 | yes | - |
| 71 | `venu3s` | Venu 3S | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 390x390 | touch+3-key (START/MENU/BACK) | 260x141 | yes | - |
| 72 | `venu2` | Venu 2 | yes | 64 KB | 768 KB | = watch-app | 5.0.0 | AMOLED 416x416 | touch+3-key (START/MENU/BACK) | 288x133 | yes | - |
| 73 | `venu2plus` | Venu 2 Plus | yes | 64 KB | 768 KB | = watch-app | 5.0.0 | AMOLED 416x416 | touch+3-key (START/MENU/BACK) | 288x133 | yes | - |
| 74 | `venu2s` | Venu 2S | yes | 64 KB | 768 KB | = watch-app | 5.0.0 | AMOLED 360x360 | touch+3-key (START/MENU/BACK) | 249x115 | yes | - |
| 75 | `vivoactive5` | vívoactive 5 | yes | 64 KB | 768 KB | = watch-app | 5.2.0 | AMOLED 390x390 | touch+3-key (START/MENU/BACK) | 260x141 | yes | - |
| 76 | `vivoactive6` | vívoactive 6 | yes | 64 KB | 768 KB | = watch-app | 6.0.2 | AMOLED 390x390 | touch+2-key (START/BACK) | 274x146 | yes | - |
| 77 | `d2airx10` | D2 Air X10 | yes | 64 KB | 768 KB | = watch-app | 5.0.0 | AMOLED 416x416 | touch+3-key (START/MENU/BACK) | 288x133 | yes | - |
| 78 | `approachs50` | Approach S50 | yes | 64 KB | 768 KB | = watch-app | 5.1.0 | AMOLED 390x390 | touch+3-key (START/MENU/BACK) | 260x141 | yes | - |
| 79 | `approachs7042mm` | Approach S70 42mm | yes | 64 KB | 768 KB | = watch-app | 5.1.0 | AMOLED 390x390 | touch+3-key (START/MENU/BACK) | 248x103 | yes | - |
| 80 | `approachs7047mm` | Approach S70 47mm | yes | 64 KB | 768 KB | = watch-app | 5.1.0 | AMOLED 454x454 | touch+3-key (START/MENU/BACK) | 274x103 | yes | - |
### Inferences
- 17 CIQ 3.4 products = structural problem, not 32 KB number: device-level 32 KB glance, but per SDK Device Reference ("Build as Widget") and developer thread, `watch-app` cannot supply glance there. Shipping HeroSet glance to them needs widget-type build.
- Products' data complete for all 80 (no field missing), so table = authoritative statement of what SDK 9.2.0 believes, not every firmware in field.

### Gaps
- Table `CIQ` column from SDK `partNumbers`; real installed firmware per user not knowable. `fenix6`, `fenix6s`, `fenix6*pro`, MARQ Gen 1, `enduro`, `descentmk2*`, `fr945lte` list 3.4.1-3.4.5.
- 10 products (fēnix 9 family, FR170/170M/70) no Device Reference HTML in this SDK, so "Build as ..." note inferred from being CIQ 6.0 (glance 64 KB in `compiler.json`, all other CIQ 5.x/6.x products say "Build as Watch App or Widget").
- Physical button set for wave-1 AMOLED products from simulator `keys[]` (5 keys) and HeroSet compatibility doc; not verified on hardware.

## Cross-check against Garmin's public pages: sample of 8 products

### Takeaway
API levels for all sampled products match Garmin's public Compatible Devices page. Public per-device Device Reference pages JavaScript-rendered, fetch returned only navigation; memory cross-check therefore used Device Reference HTML bundled with same SDK, matches `compiler.json` but not independent source. `fr245` not one of the 80 (CIQ 3.3, below `minApiLevel`), listed for completeness.

### Cited Findings
- Garmin Compatible Devices page lists API level: Forerunner 965 5.2; Venu 4 41mm 6.0; D2 Air X10 5.0; fēnix 6 3.4; Forerunner 245 3.3; Enduro 3.4; Approach S50 5.1; Venu 2S 5.0. Page columns: name, resolution, shape, screen technology, API level; no memory limits. — [Compatible Devices](https://developer.garmin.com/connect-iq/compatible-devices/)
- Local values for same 8: `fr965` 5.2.0 / glance 64 KB / watch-app 768 KB; `venu441mm` 6.0.2 / 64 KB / 768 KB; `d2airx10` 5.0.0 / 64 KB / 768 KB; `fenix6` 3.4.1-3.4.5 / **32 KB** / **128 KB**; `enduro` 3.4.2 / 32 KB / 128 KB; `approachs50` 5.1.0 / 64 KB / 768 KB; `venu2s` 5.0.0 / 64 KB / 768 KB; `fr245` 3.3.x / 32 KB / 128 KB (local `Devices/fr245/compiler.json`, `liveUpdates` false). — files under [Devices/](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Devices/)
- SDK-bundled Device Reference for the 8: 4.x+ products `Glance 65536 Build as Watch App or Widget`; `fenix6`, `enduro`, `fr245` `Glance 32768 Build as Widget`, `Watch App 131072`, `Widget 65536`. — e.g. [Device_Reference/venu441mm.html](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Device_Reference/venu441mm.html)
- Forum thread: memory limits found in "compiler.json or simulator.json", Garmin's device-reference pages, community repo https://github.com/flocsy/garmin-dev-tools; thread about data fields, no glance numbers. — [Device Memory Limits](https://forums.garmin.com/developer/connect-iq/f/discussion/418612/device-memory-limits)
- Garmin forum (2018-era) on fēnix 6: 32 KB glance limit breaks widget export; fix = `(:glance)` annotation and `scope='glance'` resources. — [Glance Views out of memory](https://forums.garmin.com/developer/connect-iq/f/discussion/210767/glance-views-out-of-memory)

### Inferences
- Local and public API levels agree on all 8, so SDK data trustworthy for CIQ split; memory values consistent between `compiler.json` and Garmin's shipped docs.

### Gaps
- No independent public source for per-device glance memory (online Device Reference did not render in fetch tool; GitHub aggregator repo not fetched).
- No on-device measurement of any glance limit.

## HeroSet's own memory use vs. device budgets

### Takeaway
HeroSet measured full-app footprint (store build, simulator) ~52 KB on dashboard, ~54 KB peak in workout. = 42% of tightest watch-app budget (128 KB: `fenix6`, `fenix6s`, `enduro`), under 10% elsewhere, but larger than any 32 KB glance budget and 81% of 64 KB one, so glance must load only small `(:glance)`-annotated subset. No glance-specific measurement exists.

### Cited Findings
- "`fenix6`, `fenix6s`, `enduro` give watch apps 128 KB. Store build measured with `System.getSystemStats()` in the simulator: ~52 KB on the dashboard, ~54 KB peak in a workout, ~73 KB free. The test runner gets 8 MB regardless of device, so a passing suite says nothing about memory." — [ADR-038 in decisions.md](file:///Users/mbp/dev/garmin/HeroSet/docs/decisions.md), same figures in [compatibility.md](file:///Users/mbp/dev/garmin/HeroSet/docs/compatibility.md) (Wave 4/5 section).
- compatibility.md: 218 px `fr255s` has 512 KB app memory vs 768 KB elsewhere in that wave, "not the memory floor: wave 4's fēnix 6 family and Enduro cap watch apps at 128 KB". Local data adds: `fr255` also 512 KB, 14 CIQ 3.4 products other than fēnix 6 / 6S / Enduro have 1280 KB. — [compatibility.md](file:///Users/mbp/dev/garmin/HeroSet/docs/compatibility.md)
- decisions.md line ~289 mentions "the 64 KB MIP products" for per-set state; per this SDK's data no supported product has 64 KB **watch-app** limit. 64 KB = glance limit for 4.x+ products and widget limit of `fenix6`, `fenix6s`, `enduro`. Wording likely loose. — [decisions.md](file:///Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
- Unverified per ADR: "session memory on the 128 KB watches (fēnix 6/6S, Enduro)" for dev-build FIT session. — [decisions.md](file:///Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
- `HeroSetApp.initialize()` builds `HeroSetStore` and `HeroSetSyncCoordinator`; `onStart()` runs `_store.ensureCurrentDay()` and `HeroSetComplicationPublisher.publish(_store)`; `getInitialView()` returns full dashboard view. No `(:glance)`/`(:background)` annotations in `source/`. — [source/app/HeroSetApp.mc](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetApp.mc)
- Compiler warns when entry point pulled into glance/background process ("adding the entry point to the glance or background process", SDK v4.2.3), since 9.2.0 handles `(:glance)` used without `getGlanceView`. — [SDK History](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Readme/History.html)
- Forum reports (dated ~2018): `AppBase` always loaded in every process, only `(:glance)`/`(:background)` annotated modules added; 32 KB limit nominal, ~4 KB used by VM (real ~28 KB for data-field case). — [Glance Views out of memory](https://forums.garmin.com/developer/connect-iq/f/discussion/210767/glance-views-out-of-memory), [Device Memory Limits](https://forums.garmin.com/developer/connect-iq/f/discussion/418612/device-memory-limits) ("28 KB" figure there = fēnix 5 data field, not glance)
- Battery doc: no background service, no GPS; workout screen dominates drain; nothing measured. Glance runs on system's schedule per ideas.md. — [battery.md](file:///Users/mbp/dev/garmin/HeroSet/docs/battery.md), [ideas.md](file:///Users/mbp/dev/garmin/HeroSet/docs/ideas.md)

#### Budget table (HeroSet full-app 52-54 KB, simulator, store build)

| Budget class | Products | Budget | Full app / budget |
|---|---|---|---|
| Glance, 32 KB (3.4) | 17 | 32 KB (about 28 KB usable if forum claim holds for glances) | 163-169%: full app cannot load; glance subset must be <~55% of dashboard footprint |
| Glance, 64 KB | 63 | 64 KB | 81-84% if whole app loaded; subset needed for margin |
| Watch-app 128 KB | `fenix6`, `fenix6s`, `enduro` | 128 KB | 42% peak (54 KB) |
| Widget 64 KB (if widget build were used) | same 3 | 64 KB | 84% peak: too tight |
| Watch-app 512 KB | `fr255`, `fr255s` | 512 KB | 10% |
| Watch-app 768 KB | 61 | 768 KB | 7% |
| Watch-app 1280 KB | 14 (CIQ 3.4) | 1280 KB | 4% |

### Inferences
- Tightest devices for glance: 11 no-live-update CIQ 3.4 products (32 KB, cached rendering, and for `fenix6`/`fenix6s`/`enduro` 128 KB app dropping to 64 KB widget). Full-app 52 KB figure not comparable to glance budget: glance loads only `AppBase` plus annotated code; real number needs `(:glance)` prototype run in simulator memory viewer.
- `HeroSetApp.initialize()` and `onStart()` would run in glance process unchanged (per Glances doc lifecycle for background-update devices: `onStart` called, forum says AppBase always loads). Store and sync coordinator then count against glance memory and `publish()` (complications, CIQ 4.2+) would run on every glance refresh, so both need guarding or lazy creation. Inference from code and docs, not measured result.
- Built `.prg` file size not memory figure: `bin/chk-fenix6.prg` 186 KB on disk yet app runs in 128 KB budget with ~54 KB used, so glance decisions must use `getSystemStats()`/simulator memory viewer, not PRG size.

### Gaps
- No glance prototype exists, glance memory use unmeasured. ~52-54 KB figures = simulator numbers on fēnix-6-class device, not hardware.
- No measurement of HeroSet peak memory on 512 KB or 1280 KB products (extrapolated only by budget).

## Does glance availability vary by firmware, user setting, or naming?

### Takeaway
By user setting: yes on CIQ 3.x, no evidence for 4.x+: fēnix 6 era had "widget glances" on/off toggle changing what user sees (glances vs full-screen widget loop); from CIQ 4.0 SDK treats glance mode as always on ("apps and widgets must implement a glance view to appear in the glance list"). No source found showing glance availability of the 80 products changes with firmware version.

### Cited Findings
- `DeviceSettings.isGlanceModeEnabled`: "Indicates if widget glances are enabled on the device. If glance mode is enabled, the system will pass up / down key events to a widget base page. Otherwise, the system will mask them out." API level 3.1.4. — [DeviceSettings API](https://developer.garmin.com/connect-iq/api-docs/Toybox/System/DeviceSettings.html)
- SDK release notes (v4.1.4): "Change Settings > Glance View to Settings > Glance Launch Mode. `DeviceSettings.isGlanceModeEnabled` will return true for 4.x devices. For 3.x devices, it will reflect menu state." — [SDK History](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Readme/History.html)
- Forum thread (2017-2018): if user disables glance mode widget skips glance view, launches straight into full view, `isGlanceModeEnabled` false; on device without glance support attribute does not exist, use `has` check. — [using isGlanceModeEnabled](https://forums.garmin.com/developer/connect-iq/f/discussion/206412/using-devicesettings-isglancemodeenabled-attribute)
- fēnix 6 owners' thread quotes Garmin support article: "you can enable / disable glances in widget settings"; when disabled full-screen widget loop shows on UP/DOWN. Exact menu path not in thread. — [Widget Glances: On or Off?](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/fenix-6-series/172247/widget-glances-on-or-off)
- Naming: SDK docs call feature "widget glances" (3.x, introduced with fēnix 6) and, for 4.x+, "glance list"; Forerunner 965 manual calls it "glances" / "glance loop", says "Some glances are not visible by default. You can add them to the glances list manually" and glances can be downloaded from Connect IQ Store. — [Glances core topic](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Glances.html), [FR965 manual: Glances](https://www8.garmin.com/manuals/webhelp/GUID-0221611A-992D-495E-8DED-1DD448F7A066/EN-US/GUID-97EA1540-A780-480F-BA4D-9A9E147FB225.html)
- On 4.x+, user's glance list customizable (FR965 manual), so installed glance can be hidden by user even when supported. Manual says nothing about limit on number of glances. — [FR965 manual: Glances](https://www8.garmin.com/manuals/webhelp/GUID-0221611A-992D-495E-8DED-1DD448F7A066/EN-US/GUID-97EA1540-A780-480F-BA4D-9A9E147FB225.html)
- SDK v3.1.9: "devices that support live glance updates ... can not support more than 4 widgets in the glance mode" (a fix note; current status of any count cap not found). — [SDK History](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Readme/History.html)

### Inferences
- On 17 CIQ 3.4 products user can turn glances off; glance feature there silently absent for such users. On 4.x+ products no evidence of global off switch (only list customization).
- Do not describe feature to users as "widget"; Garmin's current user-facing term = "glance" (glance loop).

### Gaps
- No firmware-version-specific availability data. One search hit ("fenix 6: sw 4.10 has issue with exit CIQ widgets/apps", Connect IQ bug reports) surfaced but not opened, not assessed.
- Exact on-device menu path for fēnix 6 glance toggle not found; whether MARQ Gen 1 / Descent Mk2 / FR945 LTE / Enduro expose same toggle unverified.

## CIQ below 4.x vs 4.x and above, and does it change glance behaviour?

### Takeaway
17 of 80 products CIQ 3.4 (fēnix 6 family, MARQ Gen 1 x8, Descent Mk2 / Mk2S, FR945 LTE, Enduro); 63 are 5.0+ (`5.0`: 4, `5.1`: 6, `5.2`: 29, `6.0`: 24; none exactly 4.x). Yes, changes glance behaviour materially: memory 32 KB vs 64 KB, glance type (widget-only vs watch-app or widget), whether glance optional.

### Cited Findings
- Glance support "Since API level 3.1.0" (`AppBase.getGlanceView()`, `WatchUi.GlanceView`). "In devices before API level 4.0.0 if a widget doesn't override [getGlanceView], default WatchUi.GlanceView will be used, which simply shows the name of the widget. In API level 4.0.0 and above, apps and widgets must implement a glance view to appear in the glance list." — [Glances core topic](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Glances.html)
- SDK v4.0.0 release notes: "Add support for glances in watch-app types", "Add `:launchedFromGlance` option to `AppBase.onStart()`", "Generate warning instead of error when app exceeds glance memory limit". — [SDK History](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Readme/History.html)
- Device Reference glance row: 3.4 products "Glance 32768 Build as Widget"; 4.x+ products "Glance 65536 Build as Watch App or Widget". — [Device_Reference/fenix6.html](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Device_Reference/fenix6.html), [fr965.html](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Device_Reference/fr965.html)
- Forum: on pre-4.0 devices (e.g. fēnix 6) cannot add glance from watch-app, need widget; widget-type app with glance view works on both pre-4.0 and 4.x devices; watch-app type needed for Complications feature (4.x only) and `ComplicationsPublisher` on widget failed to compile in (then beta) 4.2 SDK (thread 3+ years old, unresolved in-thread). Poster = community developer, not Garmin staff. — [Glance views from widget vs watch-app](https://forums.garmin.com/developer/connect-iq/f/discussion/319188/glance-views-from-widget-vs-watch-app)
- HeroSet publishes HeroFace complication only on CIQ 4.2+ products (compatibility.md: wave 5 "All CIQ 4.2+, so all publish the HeroFace complication"). — [compatibility.md](file:///Users/mbp/dev/garmin/HeroSet/docs/compatibility.md)
- Consequence for HeroSet today: on 4.x+ products no glance so, per Garmin's doc, not in glance list (only apps list). On 3.4 products watch-app never had glance list entry.

### Inferences
- Glance for watch-app = 4.0+ feature: single-manifest glance reaches 63 of 80 products (64 KB). Reaching 17 CIQ 3.4 products needs widget-type build (per-product manifest override in jungle possible but unverified here), changes launch model (widget loop, 64 KB widget limit on `fenix6`/`fenix6s`/`enduro` against ~54 KB measured peak use). Recommendation from data: treat 3.4 products as out of scope for glance.
- Complication (CIQ 4.2+) and glance (4.0+) both absent below 4.0, so 63-product glance scope matches complication contract set (all 5.0+).

### Gaps
- Whether 4.x+ watch-app glance shown to users by default or needs user to add to glance list not answered by sources; FR965 manual only says some glances not visible by default.
- No source found testing watch-app glance on hardware for these products.

## Method: extraction script and raw output

Script `/private/tmp/claude-501/-Users-mbp-dev-garmin/654433ae-5c12-478a-8ef0-9fd1aa89616a/scratchpad/extract.py` writes `out.json`; `table.py` renders markdown table above from it. Result: 80 ids parsed from manifest, 80 device folders read, 0 missing; glance memory 65536 x 63, 32768 x 17; Device Reference note found for 70 products (10 without page, listed above); Device Reference glance limit equalled `compiler.json` for all 70.

### extract.py
```python
#!/usr/bin/env python3
"""Extract per-device glance/memory/display data for every <iq:product> in HeroSet manifest.
Source: ~/Library/Application Support/Garmin/ConnectIQ/Devices/<id>/{compiler,simulator}.json (SDK 9.2.0)."""
import json, re, os, sys
DEV = os.path.expanduser('~/Library/Application Support/Garmin/ConnectIQ/Devices')
man = open('/Users/mbp/dev/garmin/HeroSet/manifest.xml').read()
ids = re.findall(r'<iq:product id="([^"]+)"', man)
import glob,html
REF=glob.glob(os.path.expanduser('~/Library/Application Support/Garmin/ConnectIQ/Sdks/*/doc/docs/Device_Reference'))[0]
def refnote(i):
    try: t=open(f'{REF}/{i}.html',errors='ignore').read()
    except Exception: return None
    t=re.sub(r'<script.*?</script>|<style.*?</style>','',t,flags=re.S)
    t=html.unescape(re.sub(r'\s+',' ',re.sub(r'<[^>]+>',' ',t)))
    m=re.search(r'Glance (\d+) (Build as [A-Za-z ]+?) (Watch App|Watch Face|Widget)',t)
    w=re.search(r'Widget (\d+)( Requires 4\.x SDK)?',t)
    return (int(m.group(1)) if m else None, m.group(2) if m else None, w.group(1) if w else None, bool(w and w.group(2)))
rows = []; missing = []
for i in ids:
    p = f'{DEV}/{i}'
    try:
        c = json.load(open(f'{p}/compiler.json')); s = json.load(open(f'{p}/simulator.json'))
    except Exception as e:
        missing.append((i, str(e))); continue
    at = {a['type']: a['memoryLimit'] for a in c.get('appTypes', [])}
    g = s.get('glance')
    pn = c.get('partNumbers', [])
    ciq = sorted({x['connectIQVersion'] for x in pn if 'connectIQVersion' in x}, key=lambda v: tuple(map(int, v.split('.'))))
    disp = s.get('display', {})
    keys = [k['id'] for k in s.get('keys', [])]
    rows.append(dict(id=i, name=c.get('displayName'), glance_mem=at.get('glance'),
        glance_sim_key=bool(g), glance_content=(g or {}).get('contentArea'), liveUpdates=(g or {}).get('liveUpdates'),
        watchApp=at.get('watchApp'), widget=at.get('widget'), background=at.get('background'),
        types=sorted(at), group=c.get('deviceGroup'), ciq=ciq, fw=[x.get('firmwareVersion') for x in pn],
        res=c.get('resolution'), family=c.get('deviceFamily'), dtype=c.get('displayType'), bpp=c.get('bitsPerPixel'),
        touch=disp.get('isTouch'), shape=disp.get('shape'), keys=keys, pn=c.get('hardwarePartNumber'), ref=refnote(i)))
json.dump(dict(rows=rows, missing=missing), open(sys.argv[1] if len(sys.argv)>1 else 'out.json','w'), indent=1)
print(len(ids), 'ids', len(rows), 'ok', missing)
```

### table.py
```python
import json,re,collections
d=json.load(open('out.json'))['rows']
man=open('/Users/mbp/dev/garmin/HeroSet/manifest.xml').read()
def ciq(r): return r['ciq'][-1]
def inp(r):
    k=''.join(x[0] for x in r['keys'])
    if r['touch']:
        return {'eumde':'5-btn+touch','eme':'touch+3-key (START/MENU/BACK)','ee':'touch+2-key (START/BACK)'}[k]
    return {'eumde':'5-btn'}[k]
def name(r): return re.sub(r'\s*/\s*.*','',r['name']).replace('®','').replace('™','')[:38]
out=['| # | id | Product (SDK name, first alias) | Glance | Glance limit | Watch-app limit | Widget limit | CIQ (part-no. firmware) | Display | Input | Glance area (content px) | Live glance | Anomalies |','|---|---|---|---|---|---|---|---|---|---|---|---|---|']
K=lambda v: f'{v//1024} KB' if v else 'n/a'
for n,r in enumerate(d,1):
    an=[]
    if r['ref'] is None: an.append('no local Device_Reference page (product newer than SDK docs); glance build-type note inferred from CIQ>=4')
    elif r['ref'][1]=='Build as Widget': an.append('3.x glance = widget-type only (Device Ref: "Build as Widget"); HeroSet is watch-app type')
    if r['glance_mem']==32768 and r['ref'] is None: an.append('!')
    if r['watchApp']==131072: an.append('watch-app capped 128 KB; widget only 64 KB')
    if r['watchApp']==524288: an.append('watch-app 512 KB (others 768 KB)')
    if not r['liveUpdates']: an.append('no live glance updates (background/cached render)')
    if r['res']['width']==466: an.append('largest screen (466)')
    if r['res']['width']==218: an.append('smallest screen (218)')
    if r['id'] in ('venu441mm','vivoactive6'): pass
    disp=f"{r['dtype']} {r['bpp']}bpp {r['shape']}"
    out.append(f"| {n} | `{r['id']}` | {name(r)} | yes | {K(r['glance_mem'])} | {K(r['watchApp'])} | {K(r['widget']) if r['widget'] else '= watch-app'} | {'/'.join(r['ciq'])} | {r['dtype'].upper()} {r['res']['width']}x{r['res']['height']} | {inp(r)} | {r['glance_content']['width']}x{r['glance_content']['height']} | {'yes' if r['liveUpdates'] else 'NO'} | {'; '.join(a for a in an if a!='!') or '-'} |")
open('table.md','w').write('\n'.join(out))
# summaries
c=collections.Counter
print(c((r['glance_mem'],ciq(r)[0]) for r in d))
print(c((r['watchApp']) for r in d))
print('noLive',[r['id'] for r in d if not r['liveUpdates']])
print('32K',[r['id'] for r in d if r['glance_mem']==32768])
print('no ref',[r['id'] for r in d if r['ref'] is None])
print(c(r['dtype'] for r in d), c(r['res']['width'] for r in d))
print('touch+5',sum(1 for r in d if r['touch'] and len(r['keys'])==5),'5 nontouch',[r['id'] for r in d if not r['touch']])
print('3key',[r['id'] for r in d if len(r['keys'])==3],'2key',[r['id'] for r in d if len(r['keys'])==2])
print('ciq<4',len([r for r in d if ciq(r)<'4']), 'wave',c(r['group'] for r in d))
print(c(r['widget'] for r in d))
gm=[r for r in d if r['glance_content']]; 
print(min(gm,key=lambda r:r['glance_content']['height'])['id'])
print(sorted(set(r['id'] for r in d if r['dtype']=='mip' and r['glance_mem']==65536)))
```
