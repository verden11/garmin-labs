# Testing plan

Many deterministic unit tests, simulator workflows, few physical-watch checks. Commands: [`development.md`](development.md). Simulator passes not device proof ([ADR-022](decisions.md#adr-022)/[023](decisions.md#adr-023)).

## Unit tests (`source/test/*Test.mc`)

| File | Covers |
|---|---|
| `HeroSetRulesTest` | XP per rep, rank curve ([ADR-031](decisions.md#adr-031)), active streak, picker clamp, goal crossing, mission completion |
| `HeroSetCalendarTest` | Day keys; consecutive days across DST, month, year, leap |
| `HeroSetStoreTest` | In-memory storage + controllable clock: XP ratchet (no farming, [ADR-002](decisions.md#adr-002)), rollover + streaks, learning state round-trip, malformed-as-fresh, String keys only ([ADR-022](decisions.md#adr-022)), diagnostics log cap, unknown exercise throws |
| `HeroSetRepCounterTest`, `HeroSetThresholdLearnerTest` | `HeroSetMotionFixture` traces: 10/10 per exercise at four tempos; still wrist, knock, drift never count; replay matches live; learner converges, drops getting-up rep, ignores one mistyped count, fits watchdog budget. Models, not wrists |
| `HeroSetSaveFeedbackTest`, `HeroSetExitMenuTest` | Toast tier order ([ADR-041](decisions.md#adr-041)); exit menus save through own view ([ADR-036](decisions.md#adr-036)) |
| `HeroSetMenuTest` | `prepare` on real menu; run in both builds (store menu no toggle, [ADR-033](decisions.md#adr-033)) |
| `HeroSetSyncTest` (dev only) | Fake recording: one activity per visit, lap per set, resume adds no lap, 0-rep laps, negative corrections, empty visit discarded, off/refused records nothing, toggle-off discards. One test drives real session in simulator |
| `HeroSetScreenFitTest` | `everyScreenFitsThisDisplay`: every screen in widest state; fails on text outside circle, overlap, or missing rows ([ADR-034](decisions.md#adr-034)/[035](decisions.md#adr-035)). Run per product and per language |
| `HeroSetWorkoutDraftTest` | Recoverable workout draft ([ADR-052](decisions.md#adr-052)): read-back for same exercise+day, ignored for different exercise or earlier day, cleared, updates in place; both builds |
| `HeroSetGlanceReaderTest` | Glance read-only reader against real store on same storage (parity on same day, odd goals, missing/corrupt/Float values), zero writes, stale day reads 0 with streak alive one more day ([ADR-051](decisions.md#adr-051)); both builds |
| `HeroSetGlanceFitTest` | Glance layout at every glance content area of running screen width (32 areas over 63 products), status wording fits or drops, every state draws; run one product per screen width |
| `HeroSetLayoutTest` | Chord math, ring sweep never full circle, arc normalization |

Localization: every `resources-<lang>` file keeps English ids and `$1$`… placeholders.

## Simulator workflows (manual)

Launch, menu entry points, each Finish -> picker -> save path, Back menus (Resume/Save/Discard never exit app, [ADR-024](decisions.md#adr-024)/[028](decisions.md#adr-028)), picker clamp and Back menu, focus on first unfinished exercise, toast tiers, relaunch restores state. Measuring layout: draw onto **one reused** buffered bitmap (one per case hangs simulator).

## Physical FR965

Open checks in [`status.md`](status.md) "Next session" B, C and E (glance); sync acceptance in [`connect-sync-plan.md`](archive/connect-sync-plan.md). Crash logs: [`development.md`](development.md).

## Not yet

Recorded-sensor replay from watch (fixtures stand in) · beta testers on non-FR965 products.