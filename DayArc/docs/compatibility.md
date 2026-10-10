# DayArc / DayArc Pro — compatibility

Status 2026-10-03: 72 products targeted: TwoSuns ADR-009's 69 + 3 Connect IQ 6 Instinct products (ADR-015, below), both densities. 69 compile
clean both jungles. 4 of 69 also rendered, passed test suite in simulator, both
densities; other 65 compile-only.

## Target tier

`minApiLevel="4.2.0"` — `Toybox.Complications`'s own floor. 66 round products, 3 rectangular AMOLED
(Venu Sq 2, Venu Sq 2 Music, Venu X1). Round products chord-fitted against inscribed circle
(TwoSuns convention); 3 rectangular use full-width rows + screen's own bottom
edge, only progress arc on inscribed circle (ADR-001, amended 2026-09-28). Excluded, same as TwoSuns ADR-009: every product below API 4.2 (includes Instinct 2 family, CIQ 3.4: no-Complications build = separate project). Instinct 3 Solar 45mm and Instinct E excluded by ADR-001, now included (ADR-015).

## Instinct E and Instinct 3 Solar (added 2026-10-03, ADR-015, accepted 2026-10-04, simulator only)

`instincte40mm` (166 x 166, window 52 px), `instincte45mm` and `instinct3solar45mm` (176 x 176, window 62 px) join both manifests (72 products). CIQ 6.0 (so `minApiLevel` 4.2.0 holds), black and white (palette `000000`/`FFFFFF` only), **watch-face memory 65,536 B** (other 69 have 131,072 B). Instinct 2 family and Descent G1 (CIQ 3.4, no Complications) **not** included: needs build without Complications, separate project. `instinctcrossover` left out (analog hands, no window).

- **What shows.** Bezel hides corners: visible area = square cut by circle ~98 px radius (96 to 100 px, from alpha mask of SDK's device images). `DayArcLayout` clips rows to 96 px circle; `stackFitsWorstCaseOnThisDevice` fails any planned row under window or reaching outside it.
- **As built.** Window-progress arc = gauge in window; clock and date share band left of it, hero (icon and value) below it, then gauge, sub line, (Pro, when stack has room) grid. **No Accent setting** (so no settings at all: no "Customize"), no corner pills.
- **Memory (normal run, `-r` like store export, simulator):** 31.2 kB (Pro), 25.6 kB (Simple) used of 59.8 kB simulator reports, on `instincte40mm` and `instincte45mm` alike (simulator window's status bar after face drew, 2026-10-03; evening window with Body Battery, loads largest hero icon). Limit 65,536 B: about half free. Other windows load other icon bitmaps, not read separately.
- **Tests, 2026-10-03, container simulator:** Pro 23/23 (24/24 and Simple 21/21 on 2026-10-04 after ADR-016) on `instincte40mm`, `instincte45mm`, `instinct3solar45mm`, and (round and rectangular controls) `fr965`, `fr255s`, `approachs50`, `venusq2`; Simple 20/20 on same three Instinct products and `fr965`. Include `stackFitsWorstCaseOnThisDevice` with new window and visible-circle check. Compile sweep, both jungles, every product: 72/72 pass both jungles (`tools/compile_sweep.sh`, `-w --typecheck 3`). `tools/check_package.sh --build`: OK (93 part numbers; exactly 4 Instinct parts carry no settings file, other 89 carry Accent).
- **Fixed 2026-10-04 (ADR-016):** Pro grid cell shown whole or not at all (label not fitting whole dropped; only calendar title may end in "..." and keeps room for clock time), so "12:..." and "R... 10" pills gone; Pro window whose grid cannot fit drawn like Simple (date, label, sub line kept) instead of trimmed; hero icons half size on these watches (`resources-instinct/`).
- **Not proven:** anything on a watch (real bezel margins, contrast, whether pre-coloured icon bitmaps stay solid white on real 1-bit panel). Simulator's clock = container's, so morning, midday, night windows screenshot with scratch patch of `DayArcWindow.windowFor` (data fields simulator lacks show empty states).

## Hero icon sizes and the label rule (ADR-017, 2026-10-04)

Hero icons no longer one fixed size: `monkey.*.jungle` family lines (`round-218x218`, `round-454x454`, `rectangle-320x360`, ...) give each screen size large and small set from `resources-hero-L<n>` / `-S<n>` (default in `resources/` serves round 360 and 390), written by `tools/gen_hero_icons.py`. Measured by `DayArcStackTest` (`HEROINK`) and `everyHeroIconLoadsAtExpectedSize` (`HEROICON`), simulator only. Digits = 0.72 of number font's box; table in `DESIGN.md` "Hero icon size".

| Screen (device run) | HOT / MEDIUM / MILD digits (px) | Large / small icon (px high) | Large vs HOT digits | Small vs MEDIUM / MILD digits |
|---|---|---|---|---|
| round 218 (fr255s) | 42 / 30 / 23 | 42 / 24 | 1.02 | 0.77 / 1.00 |
| round 240 (fenix7s) | 48 / 35 / 28 | 48 / 30 | 0.98 | 0.89 / 1.11 |
| round 260 (fenix7) | 52 / 38 / 31 | 54 / 36 | 1.06 | 0.92 / 1.13 |
| round 280 (fenix7x) | 56 / 41 / 33 | 54 / 36 | 0.98 | 0.85 / 1.06 |
| rectangle 320 x 360 (venusq2) | 80 / 54 / 43 | 78 / 48 | 0.98 | 0.87 / 1.09 |
| round 360 (fr265s, default set) | 69 / 55 / 48 | 72 / 54 | 1.04 | 1.00 / 1.15 |
| round 390 (fr165, default set) | 74 / 61 / 50 | 72 / 54 | 0.97 | 0.90 / 1.10 |
| round 416 (epix2) | 77 / 57 / 46 | 78 / 54 | 1.01 | 0.96 / 1.20 |
| rectangle 448 x 486 (venux1) | 89 / 79 / 58 | 90 / 66 | 1.01 | 0.84 / 1.14 |
| round 454 (fr965) | 87 / 73 / 58 | 90 / 66 | 1.03 | 0.90 / 1.14 |
| round 466 (fenix9pro51mm) | 90 / 79 / 59 | 90 / 66 | 1.00 | 0.84 / 1.12 |

(Stress icon's ratios, from `HEROICON` log lines of unit run on that device, 2026-10-04, container simulator. Weather glyph same height, battery shell 7/8 of it, so its ratios 0.86 to 0.9 of these. Test accepts large icon at 0.70 to 1.15 of HOT digits, small one at no more than 1.15 of MEDIUM digits and at least 0.70 of MILD ones. All 11 screen families passed, Simple, 21/21 each.)

Before: same icons 60x48 / 48x48 / 60x42 px everywhere: up to 1.14 times FR255S's HOT digits (digits fell to 23 px at MILD) and only 0.48 to 0.55 of FR965's.

Where ladder lands (`STACK` log lines at worst-case strings, container simulator, 2026-10-04; rung numbers = `DayArcConfig.STACK_LEVELS` after new rung 7): **hero label kept in every window that has one, every device tried.** Pro keeps two grid rows with label on FR255S (rungs 4 to 6), fenix 7S (4 to 6), FR165 (4 to 6, three rows in evening-empty state), FR965 (4, 6), epix 2 (2, 3), Venu X1 (3, 5); Venu Sq 2 (rectangle 320 x 360) on new rung 7 (label kept, ONE grid row, used to drop label for two rows) except midday-empty state, which has no grid; Instinct E 40 mm on rung 7 (label kept, ONE grid row) in morning, midday-data, evening-data, evening-empty states, none in midday-empty; 3 Solar draws one-row grid with label in evening-data state only, its morning and midday same picture as Simple (see `DESIGN.md` "Pro on the Instinct"). Simple on same devices at rungs 0 to 5, never needs new rung.

## Compile sweep

**2026-10-04, after ADR-017 (hero icon sets, new ladder rung):** `tools/compile_sweep.sh` **72/72 pass, 0 fail both jungles**; `tools/check_package.sh --build` OK (93 part numbers each, exactly 4 Instinct parts without settings file; `dist/DayArcSimple.iq` 3.0 MB, `dist/DayArcPro.iq` 3.4 MB, git-ignored). Unit suite + screen fit, container simulator: Simple 21/21 on 13 devices (every screen family of table above, plus two Instinct products), Pro 24/24 on fr965, fr255s, epix2, instincte40mm, instinct3solar45mm, venusq2, venux1, fenix7s, fr165. Simulator only, not device proof.

`tools/compile_sweep.sh`, 2026-09-28: **69/69 pass, 0 fail**, both `monkey.simple.jungle` and
`monkey.pro.jungle` (`bin/compile-sweep-monkey.simple.txt`, `bin/compile-sweep-monkey.pro.txt`).
Compile-only — proves every product builds, not that it renders correctly.

## Render/test spot check

6 devices (4 below plus fr255s and fenix7s, run 2026-10-01), both jungles, via `tools/run_tests.sh`, each run ON that device in simulator (20 tests
Simple / 22 Pro, including `DayArcStackTest`'s per-device worst-case fit — font metrics come from
device running simulator, so cannot be done with one device and synthetic sizes): **fr965** (default
round AMOLED — also device full dev-loop above ran against),
**approachs50** (390px — small round AMOLED, but NOT smallest round product: that is
fr255s/fr255sm at 218px MIP, then fenix7s/fenix7spro at 240px, `../TwoSuns/docs/compatibility.md`),
**venusq2**, **venux1** (two rectangular shapes). All pass, both densities, zero warnings past
expected launcher-icon-scaling notice (real icons not supplied yet, `docs/status.md`
gate 11).

**Not run:** other 65 products' render/fit — compiled only. Full 69×2 render sweep needs
`tools/run_tests.sh` per product, which does need simulator (unlike compile sweep) and
takes roughly a minute per run; not done this pass given time cost, and simulator passing
would still not be device proof either way.

## Known gaps

None found in export-count/product-list category yet (no export run — `docs/development.md`
"Export" drafted, not executed). Same caveat as every other project here: **nothing here has run
on a wrist.**

## Export, memory and size (2026-09-28)

`monkeyc -e -r` for each jungle prints "89 OUT OF 89 DEVICES BUILT" against 69-product manifest —
same over-report TwoSuns documented (`../TwoSuns/docs/compatibility.md` "The export and 89
devices"); exporter counts internal build units, not manifest products. Not reconciled beyond
that; no watch count goes in either listing. `dist/DayArc.iq` 1.95 MB, `dist/DayArcPro.iq` 2.27 MB
(git-ignored), each containing Accent colour settings resources.

Memory: every one of 69 products has same watch-face memory limit, **131,072 bytes**
(`Devices/*/compiler.json`), so no smaller device to single out. Release `.prg` for fr965:
Simple 39,740 bytes, Pro 46,924 bytes. `DayArcRenderTest` logs `getSystemStats()` after rendering
all four windows and loading icons: Simple `used` ~34.0 KB, Pro ~39.2 KB, identical across fr965,
approachs50, venusq2, venux1 (TEST build, larger than release; simulator's own
`totalMemory` in test mode, 8.4 MB, not watch's limit). Simulator numbers, not device ones.

## Smallest screens (218px fr255s/fr255sm, 240px fenix7s/fenix7spro) — compiled, NOT rendered

*Historical (2026-09-29): fr255s and fenix7s since rendered and tested (fr255s again 2026-10-04), and hero icons no longer 60x48 / 48x48 / 60x42 on these screens (ADR-017: 42 and 24 px on 218 px screen). Arithmetic below predates both.*

Only 4 of 69 products ever rendered. fr255s and fenix7s compile clean (normal and
`monkeyc -t` test builds, both jungles, 2026-09-29); fit tests written, unrun.
Arithmetic from code and each device's own `simulator.json` (font em sizes: fr255s xtiny 13,
tiny 15, large 20, number-mild 25, -medium 32, -hot 41; fenix7s 13/17/24, 28/35/46 — much smaller than
fr965's, box heights estimated ~1.17x em, so ~15-18px text rows and 29/37/48px number box):
- **Fixed-size bitmaps = binding constraint, not fonts.** Hero icons 60x48, 48x48
  and 60x42 px, grid icons 24px, whatever the screen. On 218px hero row at least 48px
  (icon-dominated: hot number box ~48 too) = ~22% of height, against ~12% on fr965.
- **Simple, evening (worst case):** clock ~29 + date ~18 + label ~18 + hero 48 + gauge 6 + sub ~18 =
  ~137px plus 5 gaps of ~3px = ~152px, against ~192px usable (13px top and bottom) — fits on first
  rungs; hero width 60 + 4 + 3-digit hot number (~75px) = ~147px against ~190px chord. Clock
  (~95px wide) clears arc's clear radius (~100px) from y~22. So Simple should fit at or near
  top of ladder.
- **Pro:** grid rows max(text 15, icon 24) + gap = ~25px, reserve ~54px for two rows; hero block
  with label ~145px + 54 = ~199px against 192px — needs small-text rung (or dropping hero
  label), then fits with roughly 2 rows of icon+value cells (~78px columns near bottom chord).
  Hero tiers do not help there because 48px icon, not number, sets row height.
- Estimates, not measurements. If either plan does not really fit, fallback in
  `DayArcStack` (TRIM rungs, then `prune()`) keeps it safe to draw — cannot draw row across
  bottom or throw — but would then show less than intended, which only the run will tell.