# Physical accuracy validation log

Raw FR965 trial data for launch gate 2 (`go-to-market.md`). Roll the summary (not rows) into `release-contract.md`.

**Gate:** median |error| ≤ 1 per 10-rep set · ≤ 1 phantom per 60 s still in exercise position · no crash in 30 min.

**Capture (ADR-026, dev build):** every workout set saved through the picker logs `detected -> saved`. Read via main menu → **Validation Log** (newest first, Up/Down pages). Capped at 30 entries, oldest drop silently: copy out before then. Idle phantoms and crashes aren't logged; record them below. Save what you really did — the learner trains on it (ADR-040).

**Reset 2026-09-21.** Rows cleared here; the FR965 was fresh-installed the same day, which cleared `hero_learning`, counts, XP, rank and streak on the watch. Everything recorded before the reset mixed three detector eras (ADR-004 magnitude, ADR-032 tilt/height + calibration, ADR-040 learning) and was collected on a learner trained by those same mixed sets — it could not be read as evidence about the shipping build. Pre-reset rows: `git show c3bfbc8:HeroSet/docs/validation-log.md` (the 2026-09-21 additions were never committed). The detector is **unchanged** by this reset; ADR-046 changed only how a finished set reaches the learner, and rounded the learner's candidate thresholds to integers (≤ 1.5% of a step), so what it converges to can differ slightly from the pre-reset build. What the old data said, in one line: push-ups over-count on 15–25 rep sets, squats collapsed to 3-for-10 twice, sit-ups were clean. Accuracy work is deferred to a 1.1.1 if buyers report it.

Detector eras: 2026-09-16 old magnitude detector (ADR-004) · 2026-09-18 tilt/height detector with calibration (ADR-032) · 2026-09-19 learning build (ADR-040) · 2026-09-20 learner fed as the set runs (ADR-046) — the current build, and the first one these rows describe.

## Sets

Device: FR965, firmware 29.05, Connect IQ 6.0.2. Fresh install 2026-09-21, dev build; learner starts empty.

| Date | Exercise | Speed | Target | Detected | Error | Notes |
|---|---|---|---|---|---|---|
| 2026-09-21 | pushups | ? | 35 | 31 | −4 | first set after the fresh install, learner empty; saved through the picker (a learning save). **No crash** — the ADR-046 gate-2 set |

## Idle phantoms (60 s)

| Date | Exercise | Condition | Phantoms |
|---|---|---|---|

Gate means still **in exercise position** (ADR-040, no position gating).

## Crash / listener leak (30 min)

| Date | Duration | Crash | Listener stopped | Notes |
|---|---|---|---|---|
| 2026-09-21 | one 35-rep set | N | — | ADR-046 on device: the save that tripped the watchdog on 2026-09-20 now returns to the dashboard. 30 min soak not run |

## Summary

- **2026-09-21, first set after the reset:** 35 push-ups saved through the picker, detected 31 (−4), **no `Watchdog Tripped`**. ADR-046 is proven on device, which is what 1.1.0 needed. The learner was empty, so this set teaches rather than tests accuracy.
- **What 1.1.0 needed from this log: done** (the row above). Accuracy stays waived (ADR-042) and the algorithm is unchanged, so the other rows are evidence-gathering, not a gate.
