# Release contract

Status: 2026-09-24. What the **store build** (`store.jungle`, ADR-033) may honestly claim. Check before any user-facing copy (site, listing, What's New).

| Capability | Status | Evidence / limit |
|---|---|---|
| Devices | 80 round watches, AMOLED + MIP, CIQ 3.4+: 67 five-button, 13 touch-first Venu 2/3/4, vívoactive 5/6, Approach S50/S70, D2 Air X10 (`compatibility.md`, ADR-048). **Not in a store build yet**: the touch-first 13 ship with the next upload | Only FR965 on a wrist; the rest compile + pass screen fit in simulator (ADR-039). Touch input (swipe, tap guard) never exercised on a touch-first watch |
| Automatic reps | Beta, learns from saved counts (ADR-040); gate 2 accuracy waived for launch (ADR-042, amended 2026-09-21) | **No current device data**: log cleared and FR965 fresh-installed 2026-09-21 (`validation-log.md`). The detector is unchanged; ADR-046 rounded the learner's candidate thresholds to integers (≤ 1.5% of a step). Accuracy work is a 1.1.1 item. Pre-reset findings, not evidence for a claim: push-ups over-count on 15–25 rep sets, squats collapsed to 3-for-10 twice |
| Manual correction + logging | Implemented: buttons, or swipe on touch-first watches; a tap on the counting or adjust screen never finishes or saves (native menus still select by tap) | ADR-024/028/029/048 |
| Goals, XP, rank, streak | Implemented | Unit tests; missed day shows streak 0 (ADR-031) |
| Daily goal | 100 each by default, user-set on the watch, 10–500 in steps of 10 (ADR-045) | Unit tests; picker fits 218–466 px in simulator. **Gate 5 re-check open** (store menu gained the item) |
| XP vs the goal | XP stops at 100 reps per exercise per day whatever the goal is | `xpStillCapsAtTheFixedRepCapWithAHighGoal`. Claim: **rank reflects reps done, not goals hit** — never say a higher goal earns rank faster |
| Storage upgrade | Implemented | Flat `hero_*` keys unchanged (ADR-003/036); FR965 upgrade kept progress (2026-09-18) |
| Live HR | `Sensor.getInfo().heartRate` | Garmin sensor, real time |
| Live calories (`CAL`) | Change in `ActivityMonitor.getInfo().calories` (whole-day total) since set start | Estimate, **not** a session calculation (ADR-021). Manual entries get neither |
| Connect/Strava sync | **Not in store build** | No toggle, no `Fit` permission. Dev build: opt-in, unverified (ADR-043, `connect-sync-plan.md`) |
| Data leaving watch | None | No network, no recording, no analytics; permission `Sensor` only |
| Languages | 15: English (fallback), German, French, Spanish, Italian, Portuguese, Dutch, Polish, Swedish, Danish, Norwegian Bokmål, Finnish, Turkish, Lithuanian, Ukrainian | Simulator only |
| Price / support | USD 2.00, no trial (ADR-039); https://verden.watch/heroset/support/, `/privacy/`, `hello@verden.watch` | Merchant approved 2026-09-18 |

## Allowed claim

Button-first daily push-ups, sit-ups, squats app for 80 round Garmin watches, five-button and touch-first. Automatic rep counting that learns from the counts you save, count adjustable before save, a daily goal you set on the watch (100 by default, 10 to 500), XP, rank, streaks, live HR and calorie estimate. Rank reflects reps done, not goals hit: XP stops at 100 reps per exercise per day whatever the goal is. Everything stays on the watch: no activity recorded, nothing synced. Counting depends on placement and movement, so it can be off.

Public copy: no "beta", say "adjust" (never "fix"/"correct"), keep the "can be off" caveat.

## Forbidden claims

- Medical-grade or exact calories; `CAL` as a native or dedicated session value; replacing Garmin's calorie totals.
- Universal Garmin support; Instinct, square watches, Venu/vívoactive models below Connect IQ 3.4.
- That touch-first watches (Venu, vívoactive, Approach) are tested beyond the simulator.
- That every listed watch was tested on a wrist (only FR965).
- Any accuracy number or validated accuracy (10/10 results are simulator traces).
- Any Connect/Strava sync or activity, or effect on Training Status/Readiness/Load.
- GPS/distance.
- That a higher daily goal earns XP or rank faster (it does not, ADR-045).

When sync ships (v1.1 step 8), the sync, data-leaving and Training Status rows change the same session.
