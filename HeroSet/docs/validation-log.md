# Physical accuracy validation log

Raw FR965 trial data for launch gate 2 ([`status.md`](status.md)). Roll summary (not rows) into [`release-contract.md`](release-contract.md).

**Gate:** median |error| ≤ 1 per 10-rep set · ≤ 1 phantom per 60 s still in exercise position · no crash in 30 min.

**Capture ([ADR-026](decisions.md#adr-026), dev build):** every workout set saved through picker logs `detected -> saved`. Read via main menu → **Validation Log** (newest first, Up/Down pages). Capped at 30 entries, oldest drop silently: copy out before then. Idle phantoms, crashes not logged; record below. Save what you really did — learner trains on it ([ADR-040](decisions.md#adr-040)).

**Reset 2026-09-21.** Rows cleared here; FR965 fresh-installed same day, cleared `hero_learning`, counts, XP, rank, streak on watch. Everything recorded before reset mixed three detector eras ([ADR-004](decisions.md#adr-004) magnitude, [ADR-032](decisions.md#adr-032) tilt/height + calibration, [ADR-040](decisions.md#adr-040) learning), collected on learner trained by those same mixed sets — could not be read as evidence about shipping build. Pre-reset rows: `git show 7ee16bc:HeroSet/docs/validation-log.md` (2026-09-21 additions never committed). Detector **unchanged** by reset; [ADR-046](decisions.md#adr-046) changed only how finished set reaches learner, rounded learner's candidate thresholds to integers (≤ 1.5% of a step), so what it converges to can differ slightly from pre-reset build. Old data in one line: push-ups over-count on 15–25 rep sets, squats collapsed to 3-for-10 twice, sit-ups clean. Accuracy work deferred to 1.1.1 if buyers report it.

Detector eras: 2026-09-16 old magnitude detector ([ADR-004](decisions.md#adr-004)) · 2026-09-18 tilt/height detector with calibration ([ADR-032](decisions.md#adr-032)) · 2026-09-19 learning build ([ADR-040](decisions.md#adr-040)) · 2026-09-20 learner fed as set runs ([ADR-046](decisions.md#adr-046)) — current build, first one these rows describe.

## Sets

Device: FR965, firmware 29.05, Connect IQ 6.0.2. Fresh install 2026-09-21, dev build; learner starts empty.

| Date | Exercise | Speed | Target | Detected | Error | Notes |
|---|---|---|---|---|---|---|
| 2026-09-21 | pushups | ? | 35 | 31 | −4 | first set after fresh install, learner empty; saved through picker (a learning save). **No crash** — [ADR-046](decisions.md#adr-046) gate-2 set |

## Idle phantoms (60 s)

| Date | Exercise | Condition | Phantoms |
|---|---|---|---|

Gate means still **in exercise position** ([ADR-040](decisions.md#adr-040), no position gating).

## Crash / listener leak (30 min)

| Date | Duration | Crash | Listener stopped | Notes |
|---|---|---|---|---|
| 2026-09-21 | one 35-rep set | N | — | [ADR-046](decisions.md#adr-046) on device: save that tripped watchdog on 2026-09-20 now returns to dashboard. 30 min soak not run |

## Summary

- **2026-09-21, first set after reset:** 35 push-ups saved through picker, detected 31 (−4), **no `Watchdog Tripped`**. [ADR-046](decisions.md#adr-046) proven on device, what 1.1.0 needed. Learner empty, so set teaches rather than tests accuracy.
- **What 1.1.0 needed from this log: done** (row above). Accuracy stays waived ([ADR-042](decisions.md#adr-042)) and algorithm unchanged, so other rows evidence-gathering, not gate.