# Testing plan

Many deterministic unit tests, simulator workflows, few physical-watch checks. Commands: [`development.md`](development.md). Simulator passes are not device proof (ADR-022/023).

## Unit tests (`source/test/*Test.mc`)

| File | Covers |
|---|---|
| `HeroSetRulesTest` | XP per rep, rank curve (ADR-031), active streak, picker clamp, goal crossing, mission completion |
| `HeroSetCalendarTest` | Day keys; consecutive days across DST, month, year, leap |
| `HeroSetStoreTest` | In-memory storage + controllable clock: XP ratchet (no farming, ADR-002), rollover + streaks, learning state round-trip and malformed-as-fresh, String keys only (ADR-022), diagnostics log cap, unknown exercise throws |
| `HeroSetRepCounterTest`, `HeroSetThresholdLearnerTest` | `HeroSetMotionFixture` traces: 10/10 per exercise at four tempos; still wrist, knock, drift never count; replay matches live; learner converges, drops getting-up rep, ignores one mistyped count, fits watchdog budget. Models, not wrists |
| `HeroSetSaveFeedbackTest`, `HeroSetExitMenuTest` | Toast tier order (ADR-041); exit menus save through their own view (ADR-036) |
| `HeroSetMenuTest` | `prepare` on real menu; run in both builds (store menu has no toggle, ADR-033) |
| `HeroSetSyncTest` (dev only) | Fake recording: one activity per visit, lap per set, resume adds no lap, 0-rep laps, negative corrections, empty visit discarded, off/refused records nothing, toggle-off discards. One test drives a real session in the simulator |
| `HeroSetScreenFitTest` | `everyScreenFitsThisDisplay`: every screen in widest state; fails on text outside the circle, overlap, or missing rows (ADR-034/035). Run per product and per language |
| `HeroSetLayoutTest` | Chord math, ring sweep never full circle, arc normalization |

Localization: every `resources-<lang>` file keeps the English ids and `$1$`… placeholders.

## Simulator workflows (manual)

Launch, menu entry points, each Finish → picker → save path, Back menus (Resume/Save/Discard never exit app, ADR-024/028), picker clamp and Back menu, focus on first unfinished exercise, toast tiers, relaunch restores state. Measuring layout: draw onto **one reused** buffered bitmap (one per case hangs the simulator).

## Physical FR965

Open checks live in `go-to-market.md` item 4; sync acceptance in `connect-sync-plan.md`. Crash logs: `development.md`.

## Not yet

Recorded-sensor replay from the watch (fixtures stand in) · beta testers on non-FR965 products.
