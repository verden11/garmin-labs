# Compatibility

Status: 2026-09-24. 117 products, every round watch-face product at Connect IQ
3.0 or newer in SDK 9.2.0. A watch face needs no buttons, so touch-only watches
(Venu, vívoactive, Instinct AMOLED) are supported here. HeroSet added Venu 2/3/4,
vívoactive 5/6, Approach S50/S70 and D2 Air X10 in its ADR-048 (not yet in a
HeroSet store build); older Venu/vívoactive and Instinct are still HeroSet-less.

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
## HeroSet link

66 of the 117 run Connect IQ 4.2+ and can read HeroSet's private complication
(HeroSet ADR-044). The rest — including HeroSet's own fēnix 6, MARQ Gen 1,
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
link, reboot survival, a day of always-on wear; `go-to-market.md` §1). On every
other product the simulator proves geometry and fonts, not always-on
behaviour, daylight contrast on MIP or battery cost. The original Venu
(`venu`, `venud`, `d2air`) has a stricter burn-in rule than the FR965 — no
pixel lit for more than 3 minutes — and the sleep screen is unchecked against
it.

## Not supported, and why

| Group | Examples | What's missing |
|---|---|---|
| Rectangle | `venusq2`, `venux1` | The row stack assumes a round chord; a rectangle wants its own proportions (`docs/plan.md` phase 4) |
| Semi-octagon | Instinct 2/3 MIP, Instinct E, Descent G1 | Their sub-window covers part of the screen and the layout doesn't model it yet (phase 4) |
| Below Connect IQ 3.0 | fēnix 3, FR230/235/630, vívoactive Gen 1, FR45 | No `Application.Properties`, 48–64 KB, 4-bit colour: a second render path for 15 old watches |

## Adding a product

1. Check `compiler.json` in the SDK's `Devices/` folder: display shape and
   size, watch-face memory, Connect IQ version.
2. Add it to `manifest.xml`.
3. Run `everyStateFitsThisDisplay` in its simulator; add its screen size to the
   evidence list above if it is a new one.
