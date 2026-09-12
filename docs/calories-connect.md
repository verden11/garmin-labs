# Calories & Garmin Connect

Status: 2026-09-12. HeroSet must not claim to replace Garmin's native calorie
total — the APIs expose calories as read-only.

## Decision

1. Read/display `Activity.Info.calories` when a valid activity exists (native value, may be null).
2. Keep a separate, explicitly labeled `HeroSet Calories` estimate for bodyweight sessions when native calories are unavailable.
3. Record the estimate as a FIT developer field (`FitContributor`, `heroset_estimated_calories`) — Garmin Connect renders it as a custom chart/summary field.

Dashboard stays local-only; FIT recording is reserved for an explicit Pro Run.

## Metric contract

| Metric | Source | Label | Confidence |
|---|---|---|---|
| Native calories | `Activity.getActivityInfo().calories` | `GARMIN CAL` | Garmin-calculated; null possible |
| HR expenditure | `energyExpenditure` × elapsed minutes | `HR EST CAL` | Device estimate |
| HeroSet estimate | time + reps + optional HR | `HEROSET EST CAL` | Estimate, never native |
| Completed reps | detector/manual | `REPS` | App-measured |

Never merge into one ambiguous `CALORIES` number.

## Phases

1. **Read-only display** — `HeroSetCalories` pure domain class (`fromNativeCalories`,
   `estimateFromSession`; coefficients in `HeroSetConfig` as labeled assumptions),
   workout summary page (native first, estimate second). Test null/zero/manual-only cases.
2. **FIT field** — one numeric field, `displayInChart` + `displayInActivitySummary`,
   updated ≤ 1/s, final value at session end. Validate with Monkey Graph before submission.
3. **Device validation** — compare vs FR965 activity summary; verify mobile+web
   rendering; battery impact; never market estimates as exact.

## Non-goals / risks

No overwriting native calories, no modifying Garmin Connect UI, no health-data
server, no accuracy claims without a study. Calories from reps alone are
inherently approximate; emphasize progress, not precision. FIT field rendering
varies by GCC client — verify before Store claims.