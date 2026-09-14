# HeroSet Go-To-Market

Status: 2026-09-14. Not launch-ready — blockers are product proof and Store
compliance, not features. Bodyweight-only, no GPS (ADR-009); no FIT
activity/Garmin Connect sync at all — live HR/calorie readouts only (ADR-021
in `architecture.md`).

## Positioning

Button-first daily bodyweight challenge: beta auto-counting, manual correction,
progress without a phone, live HR/calorie readout during a set. Target:
Forerunner owners wanting a repeatable short workout ritual. Never promise:
medical-grade calories, universal device support, perfect auto-counting,
Garmin Connect native calorie totals, or any effect on Training
Status/Readiness/Acute Load (no activity is ever recorded, so there's nothing
for those to act on).

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
| Live HR/calorie readout | Implemented (ADR-021) | Verify HR/calorie values and battery impact on FR965 |

## Launch gates (P0 — paid launch)

1. If calibration ships: 10-rep calibration succeeds per exercise on FR965.
2. Counting accuracy measured vs manual ground truth: median |error| ≤ 1 per
   10-rep set; ≤ 1 false positive per 60 s idle; calibration success ≥ 90%;
   no crash/listener leak in 30 min sessions.
3. Finish→adjust→save/discard/Back flows tested on watch; no text clips.
4. Storage upgrade preserves counters, XP, streak, calibration.
5. Exported `.iq` has release menu, no calibration entry.
6. Privacy notice + support contact public; listing matches actual behavior.
7. Live HR/calorie readout checked for sane values on watch.

P1 (post-launch week): guided first-run calibration, weak-calibration retry
state, rollback build ready.

## Listing

- Title: HeroSet — Bodyweight Counter
- Description: push-up/sit-up/squat tracking with daily goals, streaks, manual
  correction, live HR/calorie readout; auto-counting in beta on Forerunner 965.
- Screenshots: dashboard → calibration → live count → manual correction →
  completion. Real build only, no mockups.
- Disclosure: counting depends on watch placement/movement; calibration per
  exercise; not a medical device; calories are estimates, not native
  session-level Garmin values. No activity is ever created or synced.

## Order

Physical validation → layout fixes + evidence → privacy/support pages →
release `.iq` + menu gating check → calories decision → merchant onboarding →
private beta → paid launch at USD 2.00.