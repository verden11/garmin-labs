# HeroSet Go-To-Market

Status: 2026-09-12. Not launch-ready — blockers are product proof and Store
compliance, not features.

## Positioning

Button-first daily bodyweight challenge: beta auto-counting, manual correction,
progress without a phone. Target: Forerunner owners wanting a repeatable short
workout ritual. Never promise: medical-grade calories, universal device support,
perfect auto-counting, Garmin Connect native calorie totals.

## Readiness

| Area | Status | Gap / action |
|---|---|---|
| FR965 build | Ready for beta | Normal + store jungle pass; export `.iq` after device QA |
| Tests | 60/60 | Add end-to-end device scenarios |
| Rep detection | Beta | Physical validation: 10 testers × 3 exercises × 3 speeds |
| Calibration | Dev beta | Decide: ship+validate in release, or drop calibrated positioning |
| UI | Not ready | Round-screen clipping; fresh screenshots for every screen/state |
| Device coverage | FR965 only | Add devices only after layout/sensor matrix tests |
| Privacy/support | Not ready | Public policy + support URL required before launch |
| Monetization | Plan-ready | Merchant onboarding pending |

## Launch gates (P0 — paid launch)

1. If calibration ships: 10-rep calibration succeeds per exercise on FR965.
2. Counting accuracy measured vs manual ground truth: median |error| ≤ 1 per
   10-rep set; ≤ 1 false positive per 60 s idle; calibration success ≥ 90%;
   no crash/listener leak in 30 min sessions.
3. Pause/resume/save/discard/Back flows tested on watch; no text clips.
4. Storage upgrade preserves counters, XP, streak, calibration.
5. Exported `.iq` has release menu, no calibration entry.
6. Privacy notice + support contact public; listing matches actual behavior.

P1 (post-launch week): guided first-run calibration, weak-calibration retry
state, FIT custom calories only after validation, rollback build ready.

## Listing

- Title: HeroSet — Bodyweight Counter
- Description: push-up/sit-up/squat tracking with daily goals, streaks, manual
  correction; auto-counting in beta on Forerunner 965.
- Screenshots: dashboard → calibration → live count → manual correction →
  completion. Real build only, no mockups.
- Disclosure: counting depends on watch placement/movement; calibration per
  exercise; not a medical device; calories are estimates.

## Order

Physical validation → layout fixes + evidence → privacy/support pages →
release `.iq` + menu gating check → calories decision → merchant onboarding →
private beta → paid launch at USD 2.00.