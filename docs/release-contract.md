# HeroSet Current Release Contract

Status date: 2026-09-17. This is the short source of truth for what the current
checkout can honestly claim. `architecture.md` remains the target architecture;
this file describes current behavior.

| Capability | Current status | Evidence / limitation |
|---|---|---|
| Target device | FR965 only | `manifest.xml`; no other device is advertised |
| Automatic reps | Beta | Synthetic and simulator tests pass; physical validation in progress (2026-09-16) — first real-device trials after confirmed calibration show large errors (push-ups 4/10 detected, a second exercise ~19/10), both failing gate 2. Not yet diagnosed — see `go-to-market.md` Status checkpoint and `validation-log.md` |
| Calibration | Dev build available; paid release blocked | Normal build exposes it; `store.jungle` hides the menu entry until physical validation |
| Manual correction | Implemented | Post-set correction picker and manual logging, button-only (ADR-024/028/029) |
| Daily goals/streaks | Implemented | Local calendar and migration tests pass; a missed day shows streak 0 (ADR-031) |
| Persistence migration | Implemented | Legacy flat state migrates to grouped dictionaries; 74 unit tests pass (simulator) |
| Calories/HR per workout | Implemented | Live HR (`Sensor.getInfo`) + day-delta calories (`ActivityMonitor.getInfo`); by default no FIT session/Connect activity is created (ADR-021). No training-effect/status data without sync enabled — that requires a saved activity |
| Garmin Connect/Strava sync | Implemented, opt-in, off by default; **per-day behavior unverified** | Main-menu toggle. Designed as one combined FIT activity per calendar day, no GPS/distance (ADR-025). First on-watch test (2026-09-16) produced two activities in one day, so the design probably doesn't hold on FR965 (ADR-030, `go-to-market.md` status item 0) |
| Garmin Connect custom metrics | Not implemented | FIT developer-field plan only |
| Languages | English only | `manifest.xml` |
| Price target | Planned paid launch | Garmin USD 2.00 price point currently maps to US $1.99; merchant onboarding pending |
| Privacy/support | Launch blocker | Public policy and support URL not yet published |

## Allowed launch claim today

HeroSet is a Forerunner 965 button-first bodyweight progress app with automatic
counting in beta, manual correction, daily goals, streaks, and live
HR/calorie readouts during a set. By default no FIT activity or Garmin
Connect/Strava sync happens; an opt-in setting (off by default) saves workout
time and heart rate to Garmin Connect as a strength activity, with no
GPS/distance data. Automatic
counting depends on calibration/watch placement and still requires physical
validation. No GPS/distance tracking.

## Forbidden claims today

- Medical-grade or exact calorie measurement.
- Universal Garmin device support.
- Production calibration availability while using the current `store.jungle`.
- Guaranteed rep accuracy across users, exercises, wrist positions, or speeds.
- Native Garmin Connect calorie replacement.
- Any effect on Training Status, Training Readiness, or Acute Load with sync
  off (the default) — no recorded activity exists for those to act on. With
  sync on, a bodyweight-strength activity with no GPS/distance is a weak
  signal for those metrics at best; do not claim it drives them meaningfully.
- Garmin Connect/Strava sync as automatic or default — it's an explicit,
  off-by-default settings toggle (ADR-025).
- "One activity per day" for sync — unverified, and the first watch test
  contradicts it (ADR-030).
- Session calories as an exact/dedicated measurement — it's the delta of
  Garmin's whole-day cumulative total, not a purpose-built session calculation.
- GPS/distance tracking.

## Release decision

Do not submit a paid Store package until the calibration decision is explicit:
either include and validate calibration in the release artifact, or remove the
calibrated positioning and ship a manual-first beta. The current artifact is a
technical beta, not a final paid release.
