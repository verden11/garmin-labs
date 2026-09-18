# Physical Accuracy Validation Log

Raw trial data for go-to-market.md Phase 2 step 1 / launch gate 2. Fill during
on-device testing; roll summary (not every row) into
`release-contract.md`'s evidence column when done.

**Detector changed 2026-09-17 (ADR-032).** Two rows dated 2026-09-16 below
used old magnitude detector — don't count toward gate; kept as failure record.
Recalibrate every exercise before new trials: old calibration profiles ignored.

**Gate to hit** (`go-to-market.md` gate 2): median |error| ≤ 1 per 10-rep set;
≤ 1 false positive per 60 s idle; calibration success ≥ 90%; no crash/listener
leak in 30 min sessions.

## Automatic capture (ADR-026)

Every real workout set logs itself: Finish seeds correction picker with
detector's raw count, and whatever you save (after adjusting, if needed) logs
on-device as `detected -> saved` with error. No separate "test mode" — do sets
normally, read log back after from main menu's **Validation Log** entry (dev
build only, ADR-033). Pages newest-first, 3 entries/screen, Up/Down to page,
Back to exit.

Transcribe what you read off-watch into **Session log** table below (or
photograph each page) — on-device log capped at
`HeroSetConfig.VALIDATION_LOG_MAX_ENTRIES` (30) entries, oldest drop
silently, so copy out before that many sets pile up. Does not capture idle
false positives or calibration success/fail — record those manually in
sections below.

## Session log

Device/firmware: _(e.g. FR965, firmware 29.05, ConnectIQ 6.0.2)_

| Date | Exercise | Speed | Calibrated OK? (Y/N) | Target reps | Detected count | Error (detected − target) | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-09-18 | pushups | slow | Y | 10 | 12 | +2 | new detector (ADR-032) |
| 2026-09-16 | pushups | medium | Y | 10 | 4 | −6 | old detector (ADR-004); superseded |
| 2026-09-18 | pushups | medium | Y | 10 | 11 | +1 | new detector (ADR-032); extra rep counted while getting up after set |
| 2026-09-18 | pushups | fast | Y | 10 | 10 | 0 | new detector (ADR-032) |
| 2026-09-18 | situps | slow | Y | 10 | 10 | 0 | new detector (ADR-032) |
| 2026-09-18 | situps | medium | Y | 10 | 10 | 0 | new detector (ADR-032) |
| 2026-09-18 | situps | fast | Y | 10 | 11 | +1 | new detector (ADR-032) |
| 2026-09-18 | squats | slow | Y | 10 | 10 | 0 | new detector (ADR-032) |
| 2026-09-16 | squats (unconfirmed) | medium | Y | 10 | 19 | +9 | old detector; 2× count reproduced in simulator (ADR-032) |
| 2026-09-18 | squats | medium | Y | 10 | 10 | 0 | new detector (ADR-032) |
| 2026-09-18 | squats | fast | Y | 10 | 3 | −7 | new detector (ADR-032); big undercount |
| 2026-09-18 | squats | fast | Y | 10 | 8 | −2 | repeat: ~12 s for 10 (1.2 s/rep), slightly shallower than slow, misses spread evenly; hands at chin but wrist drops on way up, returns to chin on way down — arm travel cancels body travel |

Add rows for repeat trials — more than one pass per exercise/speed cell
encouraged, not just one each. Deliberately over- or under-correcting a set at
Finish defeats point — save what you actually counted.

## Calibration attempts

| Date | Exercise | Result |
| --- | --- | --- |
| 2026-09-18 | pushups | saved |
| 2026-09-18 | situps | saved |
| 2026-09-18 | squats | saved |

## Idle false-positive check

Wear watch, stay still/normal wrist movement (not exercising) 60 s per
exercise's calibration profile active; count any reps detector logs.

| Date | Exercise (calibration active) | Idle duration | False positives counted |
| --- | --- | --- | --- |
| 2026-09-18 | pushups | 60s, normal wrist movement | 14 |
| 2026-09-18 | pushups | 60s, wrist resting on table | 0 |
| 2026-09-18 | situps | 60s, normal wrist movement | 2 |
| 2026-09-18 | squats | 60s, normal wrist movement | 5 |

## Crash / listener-leak check

30 min continuous session (mix of sets across exercises, app left open, no
force-quit). Note anything abnormal — freeze, crash, detector stops
responding, battery/heat spike.

| Date | Duration | Crash? | Listener stopped responding? | Notes |
|---|---|---|---|---|
| 2026-09-18 | full trial session (not timed) | N | N | Battery looked OK (no % noted) |

## Summary (2026-09-18, FR965, detector ADR-032)

- Median absolute error per 10-rep set: **0.5** (10 sets: push-ups +2/+1/0, sit-ups 0/0/+1, squats 0/0/−7/−2). Over-counts come from getting up after set; fast-squat misses from hands moving to/from chin (arm travel cancels body travel).
- False positives per 60s idle, normal wrist movement: **push-ups 14, sit-ups 2, squats 5**. Wrist resting on table: push-ups **0**.
- Calibration success rate: **100% (3/3)**
- Crash/listener leak: **N** (session not timed to 30 min)
- **Gate 2: fail — idle false positives.** Counting accuracy passes. Detector quiet at rest; phantoms come from arm movement outside exercise position → fix = only count in exercise position (e.g. wrist flat for push-ups), not higher thresholds.

Copy this summary block into `docs/release-contract.md`'s "Automatic reps"
evidence cell when done.