# Calories & Garmin Connect

Status: 2026-09-17. Store build create no FIT activity, touch no Garmin Connect/Strava sync (ADR-021, ADR-033 in `decisions.md`) — one activity per set clutter timeline, per-day sync design misbehave on watch. Garmin Connect/Strava sync exist only in dev build, opt-in setting off by default (ADR-025): when on, design create one combined FIT activity per calendar day. HeroSet must not claim replace Garmin native calorie total, or any effect on Training Status/Readiness/Acute Load without sync on (those need saved activity — sync off, HeroSet never create one).

## Decision

Read two session-free, Garmin-computed values live during workout (no FIT/`ActivityRecording`, no extra permission beyond `Sensor`):

1. **HR** — `Sensor.getInfo().heartRate`, on-demand.
2. **Calories** — `ActivityMonitor.getInfo().calories` (Garmin whole-day cumulative total) sampled at workout start, delta against current value = this set attributable estimate.

Both live in `HeroSetWorkoutMetrics` (shown by `HeroSetWorkoutView`). Manual entry get neither — no real elapsed-time/HR signal to attach estimate to.

## Metric contract

| Metric | Source | Label | Confidence |
|---|---|---|---|
| Live HR | `Sensor.getInfo().heartRate` | `HR` | Garmin sensor reading, real-time |
| Session calories | `ActivityMonitor.getInfo().calories` day-delta | `CAL` | Garmin-computed daily total, not purpose-built session calculation |
| Completed reps | detector/manual | `REPS` | App-measured |

Never claim `CAL` native per-session value — it delta of whole-day figure.

## Non-goals / risks

No FIT file, no developer fields, no Garmin Connect/Strava activity in store build. Dev build only if sync explicitly on (ADR-025), and meant one combined per-day activity, never one per set. No accuracy claims without study — day-delta calories rough estimate, especially across midnight rollover or with other recorded activity in same window. Sync on: synced activity has no GPS/distance data, no rep counts (no FIT developer fields yet) — carry duration + HR into Connect/Strava, not GPS-tracked workout. Whether really one activity per day unverified on watch (ADR-030).