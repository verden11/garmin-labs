# HeroSet Go-To-Market

Status: 2026-09-14. Not launch-ready — blockers are product proof and Store
compliance, not features. Bodyweight-only, no GPS (ADR-009); per-workout FIT
recording for calories/HR/training effect (ADR-016 in `architecture.md`).

## Positioning

Button-first daily bodyweight challenge: beta auto-counting, manual correction,
progress without a phone, real Garmin-recorded calories/HR for auto-counted
sets. Target: Forerunner owners wanting a repeatable short workout ritual.
Never promise: medical-grade calories, universal device support, perfect
auto-counting, Garmin Connect native calorie totals, or any guaranteed effect
on Training Status/Readiness/Acute Load (Garmin-computed, not something this
app can assert).

## Readiness

| Area | Status | Gap / action |
|---|---|---|
| FR965 build | Ready for beta | Normal + store jungle pass; export `.iq` after device QA |
| Tests | 58/58 | Add end-to-end device scenarios |
| Rep detection | Beta | Physical validation: 10 testers × 3 exercises × 3 speeds |
| Calibration | Dev beta | Decide: ship+validate in release, or drop calibrated positioning |
| UI | Round-screen clipping fixed (simulator) | Needs physical-device confirmation; fresh screenshots for every screen/state |
| Device coverage | FR965 only | Add devices only after layout/sensor matrix tests |
| Privacy/support | Not ready | Public policy + support URL required before launch |
| Monetization | Plan-ready | Merchant onboarding pending |
| Per-workout FIT recording | Implemented (see ADR-016), re-test on watch pending | Verify calories/HR/training-effect values and battery impact; confirm Garmin Connect displays it correctly |

## Launch gates (P0 — paid launch)

1. If calibration ships: 10-rep calibration succeeds per exercise on FR965.
2. Counting accuracy measured vs manual ground truth: median |error| ≤ 1 per
   10-rep set; ≤ 1 false positive per 60 s idle; calibration success ≥ 90%;
   no crash/listener leak in 30 min sessions.
3. Pause/resume/save/discard/Back flows tested on watch; no text clips.
4. Storage upgrade preserves counters, XP, streak, calibration.
5. Exported `.iq` has release menu, no calibration entry.
6. Privacy notice + support contact public; listing matches actual behavior.
7. Per-workout FIT save/discard confirmed on watch (0-rep finish discards;
   backgrounding mid-set doesn't leave an orphaned recording); saved activity
   inspected in Garmin Connect for sane calories/HR/duration.

P1 (post-launch week): guided first-run calibration, weak-calibration retry
state, rollback build ready; FIT developer field for the manual-entry calorie
estimate (see `calories-connect.md` Phase 2).

## Listing

- Title: HeroSet — Bodyweight Counter
- Description: push-up/sit-up/squat tracking with daily goals, streaks, manual
  correction; auto-counting in beta on Forerunner 965; auto-counted sets are
  recorded as a Garmin activity with calories/HR.
- Screenshots: dashboard → calibration → live count → manual correction →
  completion. Real build only, no mockups.
- Disclosure: counting depends on watch placement/movement; calibration per
  exercise; not a medical device; calories are estimates for manual entry,
  Garmin-calculated for auto-counted sets; auto-counted sets create a Garmin
  activity that may sync to Strava if linked, same as any other activity.

## Order

Physical validation → layout fixes + evidence → privacy/support pages →
release `.iq` + menu gating check → calories decision → merchant onboarding →
private beta → paid launch at USD 2.00.