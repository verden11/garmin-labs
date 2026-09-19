# HeroSet Current Release Contract

Status date: 2026-09-19. Short source of truth for what current checkout can honestly claim. `architecture.md` = target architecture; this file = current behavior. "Store build" means `store.jungle` (ADR-033); dev build adds Connect sync + Validation Log.

| Capability | Current status | Evidence / limitation |
|---|---|---|
| Target devices | 67 round five-button watches, AMOLED and MIP, Connect IQ 3.4+ (`compatibility.md`) | FR965 used on real watch. Other 66 compile + pass screen-fit render in simulators; full 80-test suite run on size/screen-type representatives and every wave 4 product (ADR-034/035/037/038) |
| Automatic reps | Beta; **gate 2 not measured, waived for launch** (ADR-042) | Detector rebuilt 2026-09-17 (ADR-032). FR965 trials 2026-09-18 (calibrated): 10-rep sets median error 0.5; arm movement outside exercise counted phantom reps (push-ups 14/60 s). Learning build (ADR-040) on FR965 2026-09-19: 4 medium 10-rep sets, errors +2/0/0/0 (push-ups +2 then 0); speeds, idle and long sets not measured. No accuracy numbers in listing |
| Calibration | **Removed** (ADR-040) | Replaced by learning: each set saved through the picker updates that exercise's threshold belief, incl. dropping a habitual getting-up rep. Simulator-verified on synthetic traces only |
| Manual correction | Implemented | Post-set correction picker + manual logging, button-only (ADR-024/028/029) |
| Daily goals/streaks | Implemented | Local calendar + migration tests pass; missed day shows streak 0 (ADR-031) |
| Persistence migration | Implemented | Flat `hero_*` keys, spellings unchanged since v1 (ADR-003/036); 79 unit tests pass (simulator); FR965 upgrade over previous build kept XP, rank, streak, today counts (2026-09-18, gate 4) |
| Calories/HR per workout | Implemented | Live HR (`Sensor.getInfo`) + day-delta calories (`ActivityMonitor.getInfo`); no FIT session/Connect activity created (ADR-021). No training-effect/status data |
| Garmin Connect/Strava sync | **Not in store build** | No toggle, no `Fit` permission in `store.jungle` (ADR-033). Dev build keeps opt-in toggle; its one-activity-per-day design unverified, first watch test contradicted it (ADR-030) |
| Data leaving watch | None (store build) | No network, no activity recording, no analytics. Only permission: `Sensor` |
| Garmin Connect custom metrics | Not implemented | FIT developer-field plan only |
| Languages | English, German, French, Spanish, Italian, Portuguese, Dutch, Polish, Swedish, Danish, Norwegian Bokmål, Finnish, Turkish, Lithuanian, and Ukrainian | Both manifests + language-qualified `resources-*` folders; English = fallback |
| Price target | Planned paid launch | Garmin USD 2.00 price point maps to US $1.99; merchant enrollment approved 2026-09-18; no trial (ADR-039) |
| Privacy/support | Live | https://verden.watch/heroset/support/, https://verden.watch/heroset/privacy/ (`../verden-site`, Netlify); support email `hello@verden.watch` |

## Allowed launch claim today

HeroSet = button-first bodyweight progress app for 67 Garmin watches with five buttons and round screen (Forerunner 70/165/170/255/265/570/945 LTE/955/965/970, epix Gen 2 and Pro, fēnix 6/7/8/9 and E, Enduro and Enduro 3, MARQ Gen 1 and Gen 2, D2 Mach, Descent MK2/MK3/G2) for daily push-ups, sit-ups, squats. Automatic rep counting that learns from the counts you save, count adjustment before save, daily goals, XP, rank, streaks, live HR/calorie readouts during set. Everything stays on watch: HeroSet records no activity, syncs nothing. Automatic counting depends on watch placement + movement, so count can be off; every set adjustable before save. Public copy (site, listing) doesn't say "beta" or lead with fixing (word: "adjust" the count, never "fix"/"correct"); keeps the "can be off" caveat. No GPS/distance tracking.

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

Calibration replaced by learning from saved counts (ADR-040). **Paid submission approved 2026-09-19 without full gate 2 measurement (ADR-042)**: listing keeps the "can be off" caveat and review before save, and states no accuracy numbers. Remaining gate 2 checks (3 speeds, idle, long set) run after launch; a failure is fixed in an update.