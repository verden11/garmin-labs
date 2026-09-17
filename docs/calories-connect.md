# Calories & Garmin Connect

Status: 2026-09-17. By default HeroSet creates no FIT activity and touches no
Garmin Connect/Strava sync (ADR-021 in `decisions.md`) — one recorded
activity per set cluttered the timeline. Garmin Connect/Strava sync is
available as an opt-in setting, off by default (ADR-025): when enabled, one
combined FIT activity per calendar day is created, spanning every set logged
that day. HeroSet must not claim to replace Garmin's native calorie total, or
any effect on Training Status/Readiness/Acute Load without sync enabled
(those need a saved activity — with sync off, HeroSet never creates one).

## Decision

Read two session-free, Garmin-computed values live during a workout (no
FIT/`ActivityRecording`, no extra permission beyond `Sensor`):

1. **HR** — `Sensor.getInfo().heartRate`, on-demand.
2. **Calories** — `ActivityMonitor.getInfo().calories` (Garmin's whole-day
   cumulative total) sampled at workout start, delta against the current value
   = this set's attributable estimate.

Both implemented in `HeroSetWorkoutMetrics` (shown by `HeroSetWorkoutView`). Manual entry gets neither — no real
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

No FIT file, no developer fields, no Garmin Connect/Strava activity by
default — only if the user explicitly turns on sync (ADR-025), and it's one
combined per-day activity, never one per set. No accuracy claims without a
study — day-delta calories are a rough estimate, especially across a
midnight rollover or with other recorded activity in the same window. With
sync enabled, the synced activity has no GPS/distance data and no rep counts
(no FIT developer fields yet) — it carries duration and HR into
Connect/Strava, not a GPS-tracked workout. Whether it really is one activity
per day is unverified on the watch (ADR-030).
