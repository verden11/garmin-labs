# HeroSet Current Release Contract

Status date: 2026-09-18. Short source of truth for what current checkout can honestly claim. `architecture.md` = target architecture; this file = current behavior. "Store build" means `store.jungle` (ADR-033); dev build adds Connect sync + Validation Log.

| Capability | Current status | Evidence / limitation |
|---|---|---|
| Target devices | 67 round five-button watches, AMOLED and MIP, Connect IQ 3.4+ (`compatibility.md`) | FR965 used on real watch. Other 66 compile + pass screen-fit render in simulators; full 80-test suite run on size/screen-type representatives and every wave 4 product (ADR-034/035/037/038) |
| Automatic reps | Beta; **gate 2 not yet passed** | Detector rebuilt 2026-09-17 (ADR-032). FR965 trials 2026-09-18: 10-rep sets median error 0.5, but arm movement outside exercise counts phantom reps (push-ups 14/60 s) — position gating needed before paid launch. No accuracy numbers in listing until gate 2 passes |
| Calibration | In store build | Per-exercise, 10 reps, fitted thresholds (ADR-032). Old-detector profiles ignored |
| Manual correction | Implemented | Post-set correction picker + manual logging, button-only (ADR-024/028/029) |
| Daily goals/streaks | Implemented | Local calendar + migration tests pass; missed day shows streak 0 (ADR-031) |
| Persistence migration | Implemented | Flat `hero_*` keys, spellings unchanged since v1 (ADR-003/036); 80 unit tests pass (simulator); FR965 upgrade over previous build kept XP, rank, streak, today counts (2026-09-18, gate 4) |
| Calories/HR per workout | Implemented | Live HR (`Sensor.getInfo`) + day-delta calories (`ActivityMonitor.getInfo`); no FIT session/Connect activity created (ADR-021). No training-effect/status data |
| Garmin Connect/Strava sync | **Not in store build** | No toggle, no `Fit` permission in `store.jungle` (ADR-033). Dev build keeps opt-in toggle; its one-activity-per-day design unverified, first watch test contradicted it (ADR-030) |
| Data leaving watch | None (store build) | No network, no activity recording, no analytics. Only permission: `Sensor` |
| Garmin Connect custom metrics | Not implemented | FIT developer-field plan only |
| Languages | English, German, French, Spanish, Italian, Portuguese, Dutch, Polish, Swedish, Danish, Norwegian Bokmål, Finnish, Turkish, Lithuanian, and Ukrainian | Both manifests + language-qualified `resources-*` folders; English = fallback |
| Price target | Planned paid launch | Garmin USD 2.00 price point maps to US $1.99; merchant enrollment approved 2026-09-18; no trial (ADR-039) |
| Privacy/support | Pages written, **not yet public** | `site/privacy.html`, `site/index.html`; support email set (`verdenapp@gmail.com`), need hosting (`go-to-market.md` status checkpoint) |

## Allowed launch claim today

HeroSet = button-first bodyweight progress app for 67 Garmin watches with five buttons and round screen (Forerunner 70/165/170/255/265/570/945 LTE/955/965/970, epix Gen 2 and Pro, fēnix 6/7/8/9 and E, Enduro and Enduro 3, MARQ Gen 1 and Gen 2, D2 Mach, Descent MK2/MK3/G2) for daily push-ups, sit-ups, squats. Automatic rep counting in beta, per-exercise calibration, manual correction, daily goals, XP, rank, streaks, live HR/calorie readouts during set. Everything stays on watch: HeroSet records no activity, syncs nothing. Automatic counting depends on watch placement + movement, can miscount; every set correctable before save. No GPS/distance tracking.

## Forbidden claims today

- Medical-grade or exact calorie measurement.
- Universal Garmin device support, or support for touch-only (Venu, vivoactive), Instinct, square-screen watches.
- That every listed watch tested on real device: only FR965 was.
- Guaranteed or validated rep accuracy across users, exercises, wrist positions, speeds. Until gate 2 passes, no accuracy numbers: 10/10 results = simulator traces, not people.
- Native Garmin Connect calorie replacement.
- Any Garmin Connect or Strava sync, activity, or effect on Training Status, Training Readiness, Acute Load: store build records nothing.
- Session calories as exact/dedicated measurement — it delta of Garmin whole-day cumulative total, not purpose-built session calculation.
- GPS/distance tracking.

## Release decision

Calibration ships in store build (ADR-033, Phase 1 option A). Do not submit **paid** package until on-watch trials for ADR-032 detector meet gate 2, or listing rewritten as manual-first. Free or private beta upload of current store build fine.