# Sun Window — compatibility

Status 2026-10-05: no build exists. Targeted: the 66 API 5.1+ watch
products in SDK 9.2.0 (SDK data). Verified by fit sweep: none. Compiled:
none. On a watch: none.

## Target tier

- **Floor: API 5.1.0**, because `Weather` `uvIndex` and `cloudCover` exist
  only from 5.1.0 (SDK doc). The elevation rule alone would run on 3.2+,
  but those watches are deferred (spec "Device reach").
- **In:** every API 5.1+ watch with a glance: round AMOLED (360–466 px), the
  448×486 Venu X1, round MIP 8-bit (218–280 px), and the three 1-bit
  Instincts (`instincte40mm`, `instincte45mm`, `instinct3solar45mm`; 32 KB
  glance memory) included, lean (ADR-012, Instinct included).
- **Out:** the 8 Edge units and `etrextouch` (not watches; eTrex Touch has
  no glance).
- Full device table: `research_notes/Sun Window build plan/widget_platform_architecture.md` §7.

## Fit sweep

Not run (no build). Plan tasks P5.6, P6.2.

## Glance memory

Not measured. Plan task P6.3 measures `--build-stats 0` on fr965 and
instincte40mm with `GLANCE_READS_WEATHER` on and off (ADR-010). The
Instinct ids stay in only if the glance is under half of 32 KB.

## Known gaps

- The store form's Compatible Devices list is authoritative; the export may
  report more part numbers than manifest products (TwoSuns
  `compatibility.md`).
- How the store labels a `watch-app` with a glance is seen only on the
  upload form (ADR-008).
