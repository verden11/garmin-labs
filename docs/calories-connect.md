# Calories & Garmin Connect

Status: 2026-09-14. HeroSet must not claim to replace Garmin's native calorie
total — the APIs expose calories as read-only. HeroSet must not claim any
guaranteed effect on Training Status/Readiness/Acute Load either — those are
Garmin firmware/Firstbeat-computed from the saved activity, with no public API
to read back or assert a contribution (see `release-contract.md`).

Every counted (sensor-driven) workout is a real `ActivityRecording` session
(ADR-016 in `architecture.md`), so there is a live session to read from and a
FIT file to attach a developer field to. Manual entry still has no session
(no real elapsed-time/HR signal to attach one to) — it stays estimate-only,
local.

## Decision

1. Read/display `Activity.Info.calories` (and HR) live during a workout when a
   session exists — **done**: `HeroSetWorkoutView.liveMetricsText()`.
2. Keep a separate, explicitly labeled `HeroSet Calories` estimate for manual
   entries, which never get a native value.
3. Record the estimate as a FIT developer field (`FitContributor`,
   `heroset_estimated_calories`) — Garmin Connect renders it as a custom
   chart/summary field. Only meaningful for the auto-counted path, since
   that's the only one with a FIT file to attach a field to.

Dashboard stays local-only; auto-counted workouts now create a FIT activity
(disclosed in `input-and-ux.md`), manual entries never do.

## Metric contract

| Metric | Source | Label | Confidence |
|---|---|---|---|
| Native calories | `Activity.getActivityInfo().calories` | `GARMIN CAL` | Garmin-calculated; null possible |
| Training effect | `Activity.getActivityInfo().trainingEffect` | `TRAINING EFFECT` | Garmin-calculated; null possible; no confirmed link to Training Status/Load |
| HR expenditure | `energyExpenditure` × elapsed minutes | `HR EST CAL` | Device estimate |
| HeroSet estimate | reps × labeled per-rep assumption (manual entry only) | `HEROSET EST CAL` | Estimate, never native |
| Completed reps | detector/manual | `REPS` | App-measured |

Never merge into one ambiguous `CALORIES` number.

## Phases

1. **Read-only display** — **partially done**: live `GARMIN CAL`/HR shown
   in-workout (`HeroSetWorkoutView`). Still open: a post-workout summary
   screen (native first, estimate second for manual entries), and the
   `HeroSetCalories` pure domain class (`estimateFromReps`; coefficients in
   `HeroSetConfig` as labeled assumptions) for the manual-entry estimate. Test
   null/zero/manual-only cases.
2. **FIT field** — one numeric field, `displayInChart` + `displayInActivitySummary`,
   updated ≤ 1/s, final value at session end. Validate with Monkey Graph before submission.
3. **Device validation** — compare vs FR965 activity summary; verify mobile+web
   rendering; battery impact; check (don't assume) whether the saved sessions
   show up in Training Status/Load — never market this as guaranteed.

## Non-goals / risks

No overwriting native calories, no modifying Garmin Connect UI, no health-data
server, no accuracy claims without a study. Calories from reps alone are
inherently approximate; emphasize progress, not precision. FIT field rendering
varies by GCC client — verify before Store claims.