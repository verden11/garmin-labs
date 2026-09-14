# HeroSet Current Release Contract

Status date: 2026-09-14. This is the short source of truth for what the current
checkout can honestly claim. `architecture.md` remains the target architecture;
this file describes current behavior.

| Capability | Current status | Evidence / limitation |
|---|---|---|
| Target device | FR965 only | `manifest.xml`; no other device is advertised |
| Automatic reps | Beta | Synthetic and simulator tests pass; physical multi-user accuracy is unverified |
| Calibration | Dev build available; paid release blocked | Normal build exposes it; `store.jungle` hides the menu entry until physical validation |
| Manual correction | Implemented | Button-only workout/manual menus |
| Daily goals/streaks | Implemented | Local calendar and migration tests pass |
| Persistence migration | Implemented | Legacy flat state migrates to grouped dictionaries; 58 tests pass |
| Pro Run (GPS distance) | Removed 2026-09-13, permanently | `ui/run` deleted; `Positioning` permission dropped from `manifest.xml` |
| Calories/HR per workout | Implemented | Live HR (`Sensor.getInfo`) + day-delta calories (`ActivityMonitor.getInfo`), no FIT session, no Garmin Connect activity created (ADR-021). No training-effect/status data — that requires a saved activity |
| Garmin Connect custom metrics | Not implemented | FIT developer-field plan only |
| Languages | English only | `manifest.xml` |
| Price target | Planned paid launch | Garmin USD 2.00 price point currently maps to US $1.99; merchant onboarding pending |
| Privacy/support | Launch blocker | Public policy and support URL not yet published |

## Allowed launch claim today

HeroSet is a Forerunner 965 button-first bodyweight progress app with automatic
counting in beta, manual correction, daily goals, streaks, and live
HR/calorie readouts during a set (no FIT activity, no Garmin Connect/Strava
sync). Automatic counting depends on calibration/watch placement and still
requires physical validation; no GPS/distance tracking (Pro Run removed
permanently).

## Forbidden claims today

- Medical-grade or exact calorie measurement.
- Universal Garmin device support.
- Production calibration availability while using the current `store.jungle`.
- Guaranteed rep accuracy across users, exercises, wrist positions, or speeds.
- Native Garmin Connect calorie replacement.
- Any effect on Training Status, Training Readiness, or Acute Load — HeroSet
  creates no recorded activity at all, so there is nothing for those to act on.
- Session calories as an exact/dedicated measurement — it's the delta of
  Garmin's whole-day cumulative total, not a purpose-built session calculation.
- GPS/distance tracking (removed permanently with Pro Run).

## Release decision

Do not submit a paid Store package until the calibration decision is explicit:
either include and validate calibration in the release artifact, or remove the
calibrated positioning and ship a manual-first beta. The current artifact is a
technical beta, not a final paid release.
