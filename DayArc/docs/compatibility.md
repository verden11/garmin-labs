# DayArc / DayArc Pro — compatibility

Status 2026-09-28: 69 products targeted (TwoSuns ADR-009's set), both densities. All 69 compile
clean for both jungles. 4 of the 69 also rendered and passed the test suite in the simulator, both
densities; the other 65 are compile-only.

## Target tier

`minApiLevel="4.2.0"` — `Toybox.Complications`'s own floor. 66 round products, 3 rectangular AMOLED
(Venu Sq 2, Venu Sq 2 Music, Venu X1) — same round-centred-content convention as TwoSuns
(`DayArcLayout`, shorter-side scaling). Excluded, same as TwoSuns ADR-009: Instinct 3 Solar 45mm and
Instinct E (semi-octagon, 64KB, monochrome), and every product below API 4.2.

## Compile sweep

`tools/compile_sweep.sh`, 2026-09-28: **69/69 pass, 0 fail**, both `monkey.simple.jungle` and
`monkey.pro.jungle` (`bin/compile-sweep-monkey.simple.txt`, `bin/compile-sweep-monkey.pro.txt`).
Compile-only — proves every product builds, not that it renders correctly.

## Render/test spot check

4 devices, both jungles, via `tools/run_tests.sh` (all 9 tests — `DayArcWindowTest`,
`DayArcRenderTest`, `DayArcFormatTest`, `DayArcLayoutTest` — in the simulator): **fr965** (default
round AMOLED — also the device the full dev-loop above ran against),
**approachs50** (smallest round product in the set — the "does the grid fit at all" case),
**venusq2**, **venux1** (the two rectangular shapes). All pass, both densities, zero warnings past
the expected launcher-icon-scaling notice (real icons not supplied yet, `docs/publish-checklist.md`
gate 11).

**Not run:** the other 65 products' render/fit — compiled only. A full 69×2 render sweep would need
`tools/run_tests.sh` per product, which does need the simulator (unlike the compile sweep) and
takes roughly a minute per run; not done in this pass given the time cost, and simulator passing
would still not be device proof either way.

## Known gaps

None found in the export-count/product-list category yet (no export run — `docs/development.md`
"Export" is drafted, not executed). Same caveat as every other project here: **nothing here has run
on a wrist.**
