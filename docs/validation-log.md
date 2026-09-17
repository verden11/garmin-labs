# Physical Accuracy Validation Log

Raw trial data for go-to-market.md Phase 2 step 1 / launch gate 2. Fill during
on-device testing; roll the summary (not every row) into
`release-contract.md`'s evidence column once done.

**Gate to hit** (`go-to-market.md` gate 2): median |error| ≤ 1 per 10-rep set;
≤ 1 false positive per 60 s idle; calibration success ≥ 90%; no crash/listener
leak in 30 min sessions.

## Automatic capture (ADR-026)

Every real workout set already logs itself: Finish seeds the correction
picker with the detector's raw count, and whatever you actually save (after
adjusting, if needed) is logged on-device as `detected -> saved` with the
error. No separate "test mode" needed — just do sets normally and read the
log back afterward from the main menu's **Validation Log** entry (dev build
only, hidden from the store build like calibration). It pages newest-first,
3 entries/screen, Up/Down to page, Back to exit.

Transcribe what you read off-watch into the **Session log** table below (or
photograph each page) — the on-device log is capped at
`HeroSetConfig.VALIDATION_LOG_MAX_ENTRIES` (30) entries and oldest ones drop
silently, so copy them out before that many sets accumulate. It does not
capture idle false positives or calibration success/fail — record those
manually in the sections further down.

## Session log

Device/firmware: _(e.g. FR965, firmware 29.05, ConnectIQ 6.0.2)_

| Date | Exercise | Speed | Calibrated OK? (Y/N) | Target reps | Detected count | Error (detected − target) | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| | pushups | slow | | 10 | | | |
| 2026-09-16 | pushups | medium | Y | 10 | 4 | −6 | first device trial |
| | pushups | fast | | 10 | | | |
| | situps | slow | | 10 | | | |
| | situps | medium | | 10 | | | |
| | situps | fast | | 10 | | | |
| | squats | slow | | 10 | | | |
| 2026-09-16 | squats (unconfirmed) | medium | Y | 10 | 19 | +9 | exercise not confirmed; recheck |
| | squats | fast | | 10 | | | |

Add rows for repeat trials — more than one pass per exercise/speed cell is
encouraged, not just one each. Deliberately over- or under-correcting a set
at Finish defeats the point — save whatever you actually counted.

## Idle false-positive check

Wear the watch, stay still/normal wrist movement (not exercising) for 60 s
per exercise's calibration profile active; count any reps the detector logs.

| Date | Exercise (calibration active) | Idle duration | False positives counted |
| --- | --- | --- | --- |
| | pushups | 60s | |
| | situps | 60s | |
| | squats | 60s | |

## Crash / listener-leak check

30 min continuous session (mix of sets across exercises, app left open, no
force-quit). Note anything abnormal — freeze, crash, detector stops
responding, battery/heat spike.

| Date | Duration | Crash? | Listener stopped responding? | Notes |
|---|---|---|---|---|
| | | | | |

## Summary (fill once all rows above are done)

- Median absolute error per 10-rep set: **_(compute from Error column)_**
- False positives per 60s idle (per exercise): **_**
- Calibration success rate: **_% (successful / attempted)**
- Crash/listener leak in 30 min: **Y/N**
- **Gate 2 pass/fail: _**

Copy this summary block into `docs/release-contract.md`'s "Automatic reps"
evidence cell when done.
