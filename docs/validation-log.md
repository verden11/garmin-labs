# Physical accuracy validation log

Raw FR965 trial data for launch gate 2 (`go-to-market.md`). Roll the summary (not rows) into `release-contract.md`.

**Gate:** median |error| ≤ 1 per 10-rep set · ≤ 1 phantom per 60 s still in exercise position · no crash in 30 min.

**Capture (ADR-026, dev build):** every workout set saved through the picker logs `detected -> saved`. Read via main menu → **Validation Log** (newest first, Up/Down pages). Capped at 30 entries, oldest drop silently: copy out before then. Idle phantoms and crashes aren't logged; record them below. Save what you really did — the learner trains on it (ADR-040).

Detector eras: 2026-09-16 old magnitude detector (ADR-004, failure record only) · 2026-09-18 tilt/height detector with calibration (ADR-032; calibration 3/3 succeeded) · 2026-09-19+ learning build (ADR-040).

## Sets

Device: FR965, firmware 29.05, Connect IQ 6.0.2.

| Date | Exercise | Speed | Target | Detected | Error | Notes |
|---|---|---|---|---|---|---|
| 2026-09-16 | pushups | medium | 10 | 4 | −6 | old detector |
| 2026-09-16 | squats | medium | 10 | 19 | +9 | old detector; 2× reproduced in simulator |
| 2026-09-18 | pushups | slow | 10 | 12 | +2 | |
| 2026-09-18 | pushups | medium | 10 | 11 | +1 | extra rep getting up |
| 2026-09-18 | pushups | fast | 10 | 10 | 0 | |
| 2026-09-18 | situps | slow | 10 | 10 | 0 | |
| 2026-09-18 | situps | medium | 10 | 10 | 0 | |
| 2026-09-18 | situps | fast | 10 | 11 | +1 | |
| 2026-09-18 | squats | slow | 10 | 10 | 0 | |
| 2026-09-18 | squats | medium | 10 | 10 | 0 | |
| 2026-09-18 | squats | fast | 10 | 3 | −7 | |
| 2026-09-18 | squats | fast | 10 | 8 | −2 | 1.2 s/rep; wrist drops on the way up, arm travel cancels body travel |
| 2026-09-19 | pushups | medium | 10 | 12 | +2 | learning, set 1 |
| 2026-09-19 | squats | medium | 10 | 10 | 0 | learning, set 1; hands steady at chin |
| 2026-09-19 | pushups | medium | 10 | 10 | 0 | learning, set 2 |
| 2026-09-19 | situps | medium | 10 | 10 | 0 | learning, set 1 |

## Idle phantoms (60 s)

| Date | Exercise | Condition | Phantoms |
|---|---|---|---|
| 2026-09-18 | pushups | normal wrist movement | 14 |
| 2026-09-18 | pushups | wrist on table | 0 |
| 2026-09-18 | situps | normal wrist movement | 2 |
| 2026-09-18 | squats | normal wrist movement | 5 |

Learning build: gate means still **in exercise position** (ADR-040, no position gating). Not yet measured.

## Crash / listener leak (30 min)

| Date | Duration | Crash | Listener stopped | Notes |
|---|---|---|---|---|
| 2026-09-18 | not timed | N | N | battery looked OK |

## Summary

- **2026-09-18 (calibrated):** median error 0.5 over 10 sets; over-counts from getting up, fast-squat misses from arm travel. Idle with arm movement 14/2/5 → gate fail → led to ADR-040.
- **2026-09-19 (learning):** 4 medium sets +2/0/0/0. Speeds, idle-in-position, long set not run; gate 2 waived for launch (ADR-042).
