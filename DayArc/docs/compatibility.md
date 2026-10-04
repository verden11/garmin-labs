# DayArc / DayArc Pro — compatibility

Status 2026-10-03: 72 products targeted: TwoSuns ADR-009's 69 plus the 3 Connect IQ 6 Instinct products (ADR-015, below), both densities. The 69 compile
clean for both jungles. 4 of the 69 also rendered and passed the test suite in the simulator, both
densities; the other 65 are compile-only.

## Target tier

`minApiLevel="4.2.0"` — `Toybox.Complications`'s own floor. 66 round products, 3 rectangular AMOLED
(Venu Sq 2, Venu Sq 2 Music, Venu X1). Round products are chord-fitted against the inscribed circle
(TwoSuns's convention); the three rectangular ones use full-width rows and the screen's own bottom
edge, with only the progress arc on the inscribed circle (ADR-001, amended 2026-09-28). Excluded, same as TwoSuns ADR-009: every product below API 4.2 (this includes the Instinct 2 family, CIQ 3.4: a no-Complications build would be a separate project). Instinct 3 Solar 45mm and Instinct E were excluded by ADR-001 and are now included (ADR-015).

## Instinct E and Instinct 3 Solar (added 2026-10-03, ADR-015, proposed, simulator only)

`instincte40mm` (166 x 166, window 52 px), `instincte45mm` and `instinct3solar45mm` (176 x 176, window 62 px) join both manifests (72 products). They are CIQ 6.0 (so `minApiLevel` 4.2.0 holds), black and white (palette `000000`/`FFFFFF` only), **watch-face memory 65,536 B** (the other 69 have 131,072 B). The Instinct 2 family and Descent G1 (CIQ 3.4, no Complications) are **not** included: that needs a build without Complications, a separate project. `instinctcrossover` is left out (analog hands, no window).

- **What shows.** The bezel hides the corners: the visible area is the square cut by a circle about 98 px in radius (96 to 100 px, from the alpha mask of the SDK's device images). `DayArcLayout` clips rows to a 96 px circle; `stackFitsWorstCaseOnThisDevice` fails any planned row that sits under the window or reaches outside it.
- **As built.** The window-progress arc is a gauge in the window; the clock and date share the band left of it, the hero (icon and value) is below it, then the gauge, the sub line and (Pro, when the stack has room) the grid. **No Accent setting** (so no settings at all: no "Customize"), no corner pills.
- **Memory (normal run, `-r` like the store export, simulator):** 31.2 kB (Pro) and 25.6 kB (Simple) used of the 59.8 kB the simulator reports, on `instincte40mm` and `instincte45mm` alike (the simulator window's status bar after the face drew, 2026-10-03; the evening window with Body Battery, which loads the largest hero icon). The limit is 65,536 B: about half is free. The other windows load other icon bitmaps and were not read separately.
- **Tests, 2026-10-03, container simulator:** Pro 23/23 on `instincte40mm`, `instincte45mm`, `instinct3solar45mm`, and (round and rectangular controls) `fr965`, `fr255s`, `approachs50`, `venusq2`; Simple 20/20 on the same three Instinct products and `fr965`. These include `stackFitsWorstCaseOnThisDevice` with its new window and visible-circle check. Compile sweep, both jungles, every product: 72/72 pass on both jungles (`tools/compile_sweep.sh`, `-w --typecheck 3`). `tools/check_package.sh --build`: OK (93 part numbers; exactly the 4 Instinct parts carry no settings file, the other 89 carry Accent).
- **Known rough edge:** in a narrow Pro pill a long value may truncate (the simulator's calendar cell shows "12:..." where a round watch shows "N... 12:00"); this is the existing "never fewer than three digits" rule meeting a bottom row about 100 px wide.
- **Not proven:** anything on a watch (real bezel margins, contrast, whether the pre-coloured icon bitmaps stay solid white on the real 1-bit panel). The simulator's clock is the container's, so the morning, midday and night windows were screenshot with a scratch patch of `DayArcWindow.windowFor` (data fields the simulator lacks show their empty states).

## Compile sweep

`tools/compile_sweep.sh`, 2026-09-28: **69/69 pass, 0 fail**, both `monkey.simple.jungle` and
`monkey.pro.jungle` (`bin/compile-sweep-monkey.simple.txt`, `bin/compile-sweep-monkey.pro.txt`).
Compile-only — proves every product builds, not that it renders correctly.

## Render/test spot check

6 devices (the 4 below plus fr255s and fenix7s, run 2026-10-01), both jungles, via `tools/run_tests.sh`, each run ON that device in the simulator (20 tests
Simple / 22 Pro, including `DayArcStackTest`'s per-device worst-case fit — font metrics come from the
device running the simulator, so this cannot be done with one device and synthetic sizes): **fr965** (default
round AMOLED — also the device the full dev-loop above ran against),
**approachs50** (390px — a small round AMOLED, but NOT the smallest round product: that is
fr255s/fr255sm at 218px MIP, then fenix7s/fenix7spro at 240px, `../TwoSuns/docs/compatibility.md`),
**venusq2**, **venux1** (the two rectangular shapes). All pass, both densities, zero warnings past
the expected launcher-icon-scaling notice (real icons not supplied yet, `docs/status.md`
gate 11).

**Not run:** the other 65 products' render/fit — compiled only. A full 69×2 render sweep would need
`tools/run_tests.sh` per product, which does need the simulator (unlike the compile sweep) and
takes roughly a minute per run; not done in this pass given the time cost, and simulator passing
would still not be device proof either way.

## Known gaps

None found in the export-count/product-list category yet (no export run — `docs/development.md`
"Export" is drafted, not executed). Same caveat as every other project here: **nothing here has run
on a wrist.**

## Export, memory and size (2026-09-28)

`monkeyc -e -r` for each jungle prints "89 OUT OF 89 DEVICES BUILT" against a 69-product manifest —
the same over-report TwoSuns documented (`../TwoSuns/docs/compatibility.md` "The export and 89
devices"); the exporter counts internal build units, not manifest products. Not reconciled beyond
that; no watch count goes in either listing. `dist/DayArc.iq` 1.95 MB, `dist/DayArcPro.iq` 2.27 MB
(git-ignored), each containing the Accent colour settings resources.

Memory: every one of the 69 products has the same watch-face memory limit, **131,072 bytes**
(`Devices/*/compiler.json`), so there is no smaller device to single out. Release `.prg` for fr965:
Simple 39,740 bytes, Pro 46,924 bytes. `DayArcRenderTest` logs `getSystemStats()` after rendering
all four windows and loading icons: Simple `used` ~34.0 KB, Pro ~39.2 KB, identical across fr965,
approachs50, venusq2 and venux1 (a TEST build, larger than release; the simulator's own
`totalMemory` in test mode, 8.4 MB, is not the watch's limit). Simulator numbers, not device ones.

## Smallest screens (218px fr255s/fr255sm, 240px fenix7s/fenix7spro) — compiled, NOT rendered

Only 4 of the 69 products have ever been rendered. fr255s and fenix7s compile clean (normal and
`monkeyc -t` test builds, both jungles, 2026-09-29); their fit tests are written and unrun.
Arithmetic from the code and each device's own `simulator.json` (font em sizes: fr255s xtiny 13,
tiny 15, large 20, number-mild 25, -medium 32, -hot 41; fenix7s 13/17/24, 28/35/46 — much smaller than
fr965's, box heights estimated at ~1.17x the em, so ~15-18px text rows and a 29/37/48px number box):
- **Fixed-size bitmaps are the binding constraint, not the fonts.** The hero icons are 60x48, 48x48
  and 60x42 px and the grid icons 24px, whatever the screen. On 218px the hero row is at least 48px
  (icon-dominated: a hot number box is ~48 too) = ~22% of the height, against ~12% on fr965.
- **Simple, evening (worst case):** clock ~29 + date ~18 + label ~18 + hero 48 + gauge 6 + sub ~18 =
  ~137px plus 5 gaps of ~3px = ~152px, against ~192px usable (13px top and bottom) — fits on the first
  rungs; hero width 60 + 4 + a 3-digit hot number (~75px) = ~147px against a ~190px chord. The clock
  (~95px wide) clears the arc's clear radius (~100px) from y~22. So Simple should fit at or near the
  top of the ladder.
- **Pro:** grid rows are max(text 15, icon 24) + gap = ~25px, reserve ~54px for two rows; hero block
  with label ~145px + 54 = ~199px against 192px — needs the small-text rung (or dropping the hero
  label), then fits with roughly 2 rows of icon+value cells (~78px columns near the bottom chord).
  Hero tiers do not help there because the 48px icon, not the number, sets the row height.
- These are estimates, not measurements. If either plan does not really fit, the fallback in
  `DayArcStack` (TRIM rungs, then `prune()`) keeps it safe to draw — it cannot draw a row across the
  bottom or throw — but it would then be showing less than intended, which only the run will tell.

