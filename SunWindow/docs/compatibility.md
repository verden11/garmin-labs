# Sun Window — compatibility

Status 2026-10-10: **65 products** targeted (API 5.1+ watches in SDK 9.2.0). Compile sweep: all 65 build with zero warnings
(the 65 px placeholder launcher icon scales on 53 of them: a notice, not a failure). Unit suite and screen-fit run per product:
see "Fit sweep". **All simulator; no product except the FR965 (spike probe only) has been seen on a wrist.**

## Target tier

- **Floor: API 5.1.0**, because `Weather` `uvIndex` and `cloudCover` exist only from 5.1.0 (SDK doc). The elevation rule alone
  would run on 3.2+, but those watches are deferred (spec "Device reach").
- **In (65):** every API 5.1+ watch with a glance except the Instinct Crossover AMOLED: round AMOLED (360–466 px), the 448×486
  Venu X1, round MIP 8-bit (218–280 px), the two Instinct 3 AMOLED (round colour) and the three 1-bit Instincts
  (`instincte40mm`, `instincte45mm`, `instinct3solar45mm`; 32 KB glance memory) included, lean (ADR-012).
- **Out:** the 8 Edge units and `etrextouch` (not watches; eTrex Touch has no glance); `instinctcrossoveramoled` (its hands
  cover the middle of the screen, as HeroSet found; the picture would sit under them).
- Deferred: API 3.2 to 5.0 watches (Venu 2, FR945/745/245, fēnix 6), which have no `uvIndex` or `cloudCover`.
- Device table: `research_notes/Sun Window build plan/widget_platform_architecture.md` §7.

## Fit sweep

Per product, `tools/run_tests.sh <id>` (the whole suite, `everyStateFitsThisDisplay` and `glanceFitsEveryContentArea` included,
real fonts of that product, simulator only), run 2026-10-10 on the PR's code: **65 of 65 pass**. 62 products run 33 tests; the three 1-bit Instincts (instincte40mm, instincte45mm,
instinct3solar45mm) run 30, because the three colour-only accent tests are compiled out there. Three products gave no result when
twelve containers ran at once (d2mach2pro, fenix7spro, fenix9pro47mm) and passed when re-run alone. The per-product lines are in
`bin/fit-products*.txt` (git-ignored). The glance areas are the
simulator's `glance.contentArea` per product (`tools/gen_glance_areas.py`); a wrist has not confirmed any of them.

## Glance memory (release build, `--build-stats 0`)

2203 B data + 4858 to 4903 B code, about 7.1 KB, on the FR965 (64 KB limit) and the Instinct E (32 KB limit, 22 percent). The
same number with `GLANCE_READS_WEATHER` on or off (ADR-010). Foreground: 3827 B data and 9260 to 9645 B code; the package is
28.7 KB on the FR965 and 18.8 KB on the Instinct E.

## Known gaps

- The 1-bit Instinct glance: the simulator draws it under the round sub-window; the build keeps its words left of x 100 and drops
  the mark when the word does not fit beside it. A wrist must confirm where the glance really sits (HeroSet ADR-055 has the
  same open question).
- The store form's Compatible Devices list is authoritative; the export may report more part numbers than manifest products
  (TwoSuns `compatibility.md`).
- How the store files a `widget` built for API 5.1+ watches is seen only on the upload form (ADR-008, ROADMAP 18.2).
- Time zones: places at UTC+13 and +14 west of the date line (Apia, Kiritimati) are covered by generated tests; a daylight-saving
  change day shows the clock edge an hour off until the switch (the offset is read "now"). Maths and simulator only.
