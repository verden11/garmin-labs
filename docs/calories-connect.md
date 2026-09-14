# Calories & Garmin Connect

Status: 2026-09-14. HeroSet creates no FIT activity and touches no Garmin
Connect/Strava sync (ADR-021 in `architecture.md`) — one recorded activity per
set cluttered the timeline. HeroSet must not claim to replace Garmin's native
calorie total, or any effect on Training Status/Readiness/Acute Load (those
need a saved activity, which HeroSet never creates).

## Decision

Read two session-free, Garmin-computed values live during a workout (no
FIT/`ActivityRecording`, no extra permission beyond `Sensor`):

1. **HR** — `Sensor.getInfo().heartRate`, on-demand.
2. **Calories** — `ActivityMonitor.getInfo().calories` (Garmin's whole-day
   cumulative total) sampled at workout start, delta against the current value
   = this set's attributable estimate.

Both implemented in `HeroSetWorkoutView`. Manual entry gets neither — no real
elapsed-time/HR signal to attach an estimate to.

## Metric contract

| Metric | Source | Label | Confidence |
|---|---|---|---|
| Live HR | `Sensor.getInfo().heartRate` | `HR` | Garmin sensor reading, real-time |
| Session calories | `ActivityMonitor.getInfo().calories` day-delta | `CAL` | Garmin-computed daily total, not a purpose-built session calculation |
| Completed reps | detector/manual | `REPS` | App-measured |

Never claim `CAL` is a native per-session value — it's a delta of a
whole-day figure.

## Non-goals / risks

No FIT file, no developer fields, no Garmin Connect/Strava activity, ever. No
accuracy claims without a study — day-delta calories are a rough estimate,
especially across a midnight rollover or with other recorded activity in the
same window.
