# Configurable daily goal — plan

Status: 2026-09-20. **Implemented** (ADR-045) in both builds and in HeroFace, simulator-verified only. What is left is the watch checks at the end of this file and the gate 5 re-check ([`go-to-market.md`](go-to-market.md)). Kept as the reasoning record; the decisions below are the ones the code follows.

## Problem

The daily goal is the constant `HeroSetConfig.MISSION_GOAL = 100`, used in 8 source files and hardcoded again in the sibling watch face (`../heroFace/source/HeroFaceConfig.mc: HEROSET_GOAL = 100`). 100 push-ups/sit-ups/squats a day is too much for beginners and too little for strong users, so the app fits one audience and the store listing promises exactly that audience.

## Decisions (made, do not re-open during implementation)

1. **Mechanism: on-watch only.** One new main-menu item opens a picker; the value lives in `HeroSetStore` (Storage). *Not* Connect IQ app settings (`Properties` + `settings.xml`): those need the phone app, and having both a phone-side and a watch-side source of truth is a sync problem we would be inventing. The app is standalone by design and must stay usable with no phone on all 67 products (min API 3.4.0).
2. **Free number, not modes.** A stepped picker seeded at the current goal beats easy/medium/hard because every representation persists as the same integer anyway, and mode labels would cost 15 locale files for no mechanical gain. Presets ("Easy 30 / Standard 100 / Hero 200") can be layered later as buttons that write the same integer; an auto-ramping "dynamic" goal is a separate future ADR, not this work.
3. **One goal for all three exercises in v1.** Storage key is named so a per-exercise split can be added later without respelling it (ADR-003 forbids changing persisted key spellings): key `hero_goal` holds the shared value; a later split adds `hero_goal_pushups` etc. and falls back to `hero_goal`.
4. **XP stays pinned to 100 reps per exercise per day, whatever the goal is.** The cap exists to stop sheer volume printing ranks (see the comment on `HeroSetStore.awardXpFor`). Once the user sets the goal, a cap tied to the goal is not a cap — set goal 500 and rank once a day. Secondary: every rank-timing claim in `CLAUDE.md`, `input-and-ux.md` and ADR-031 ("rank 10 ~3 weeks, rank 60 ~a year") assumes max 600 XP/day. So: new constant `HeroSetConfig.XP_DAILY_CAP_REPS = 100`, independent of the goal. The goal drives bars, done state, mission completion, streak and the complication — **never XP**. ADR-002 gets marked Amended.
   - **Visible consequence, intended, do not "fix":** above goal 100 the XP cap bites before the goal is met, so mission complete no longer coincides with the day's max XP; below it, reps past the goal keep earning XP up to 100. A beginner at goal 30 completes the mission daily, streak climbing, while rank moves at ~a third speed — correct (a third of the work), but it must be said in the UX and public copy (Step 6), not discovered.
   - **Closed doors** (don't reopen during implementation): cap = goal, or `max(100, goal)` — same hole. Scaling XP per rep so any goal yields 600/day makes rank measure consistency, which the streak already measures, and would make 30 reps/day worth the same as 300. The split stands: **XP measures effort, streak measures consistency.** If high goals should be rewarded later, the non-inflationary lever is a badge or a streak variant, never XP.

5. **Range: 10 … 500, step 10.** Below 10 the streak is meaningless; 500 is the widest text the layout must still fit. Both in `HeroSetConfig` (`MIN_MISSION_GOAL`, `MAX_MISSION_GOAL`, `MISSION_GOAL_STEP`).

## Implementation steps

### Step 1 — config + store own the value

- `source/domain/HeroSetConfig.mc`: rename `MISSION_GOAL` → `DEFAULT_MISSION_GOAL` (seed only, still 100); add `MIN_MISSION_GOAL = 10`, `MAX_MISSION_GOAL = 500`, `MISSION_GOAL_STEP = 10`, `XP_DAILY_CAP_REPS = 100`.
- `source/data/HeroSetStore.mc`: new key constant `GOAL_KEY = "hero_goal"`; `getGoal() as Lang.Number` (missing/0/out-of-range → `DEFAULT_MISSION_GOAL`, clamped to the range), `setGoal(goal as Lang.Number) as Void` (clamp + snap to step before writing). Changing the goal must re-run `updateCompletion()` so lowering the goal below today's counts completes the day immediately.
- Line 92 `awardXpFor`: cap on `HeroSetConfig.XP_DAILY_CAP_REPS`, not the goal. Line 158 `updateCompletion`: compare against `getGoal()`.

### Step 2 — goal flows down as a parameter, never as a mutable global

Domain must not read Storage (layer rule), and a mutable static would break the tests. Every consumer takes the goal as an argument, sourced from the store at the presentation edge.

- `source/domain/HeroSetRules.mc`: `crossedGoal(before, after, goal)` and `missionComplete(pushups, situps, squats, goal)` gain a trailing `goal as Lang.Number` param.
- `HeroSetDashboardState`: add a `goal` field (set in `HeroSetStore.getDashboardState()`), so every view that already receives the state gets the goal for free.
- Call sites to update (all current `MISSION_GOAL` uses):
  - `source/ui/HeroSetText.mc:52` (`today_progress`)
  - `source/ui/dashboard/HeroSetMissionBars.mc:75, 82, 97`
  - `source/ui/manual/HeroSetManualPickerView.mc:130`
  - `source/ui/workout/HeroSetWorkoutView.mc:212, 213`
  - `source/app/HeroSetMenuDelegate.mc:38, 50, 53` (focus + sublabels)
  - `source/data/HeroSetStore.mc:92, 158` (step 1)
  - `source/domain/HeroSetRules.mc:70, 74`
  - `source/test/HeroSetStoreTest.mc:53-55`

### Step 3 — the setting screen

- Menu item `daily_goal` in **both** `resources/menus/menu.xml` and `resources-store/menus/menu.xml`, placed after the manual-log items (dev build: before `sync_toggle`). Sublabel shows the current value (`100`).
- Reuse `HeroSetManualPickerView` rather than writing a second picker: it already does Up/Down ±1, START saves, Back-with-change menu. Either parameterise it (step size, min/max, title, no "today total" line) or copy the 40 lines if parameterising turns uglier than a copy — whichever is the smaller diff. Step is `MISSION_GOAL_STEP`, seeded at `getGoal()`, no hold-to-accelerate (ADR-029).
- **Navigation:** the goal picker opens from the main menu, so it is depth 1 on the dashboard, exactly like the workout and manual pickers (ADR-024). Save pops back to the dashboard with the same fixed pop count; do not add a confirmation screen.
- On save, the goal path calls both `updateCompletion()` and `HeroSetComplicationPublisher.publish(store)` — the publisher only runs while the app runs, so without this the watch face shows the old goal until the next workout save.
- Feedback on save: plain toast with the new goal, via `HeroSetSaveFeedback`. If the new goal completes today's mission, the normal completion feedback fires through `updateCompletion()`.
- Strings: new ids in `resources/strings/strings.xml` **and all 14 translated `resources-<lang>/strings/strings.xml`** (dan deu dut fin fre ita lit nob pol por spa swe tur ukr). `HeroSetDraw.fits`/`largestFont` decides the font, never a guess (ADR-018/036).

### Step 4 — complication contract (breaks HeroFace if done wrong)

`../heroFace/source/HeroFaceContract.mc` was read on 2026-09-20: `numbers()` reads the first 9 fields and **ignores anything beyond**, but `parse()` returns null if field 1 != `HeroFaceConfig.HEROSET_CONTRACT_VERSION`. So the dangerous combination is new HeroSet + old HeroFace (every existing face user, since HeroSet updates first), and it is a version-number problem, not a field-count problem.

- **Keep `HeroSetComplicationPublisher.VERSION = 1`.** Append `goal` as field 10 only (ADR-044: new fields go on the end). Old HeroFace then keeps working, ignoring field 10 and drawing bars against its own 100. Bumping the version would blank the missions on every not-yet-updated face.
- `../heroFace/source/HeroFaceContract.mc`: read field 10 when the value has it, default 100 when absent; return it alongside the existing six values. Do not raise `FIELDS`/the version check — parse the tail separately so a 9-field value stays valid.
- `../heroFace/source/HeroFaceConfig.mc`: `HEROSET_GOAL = 100` becomes the fallback only; `HeroFaceMissions` computes fill from the parsed goal.
- Update the data-contract section of `../heroFace/docs/plan.md` and add a HeroFace-side test for a 9-field (old) and a 10-field (new) value, same session.

### Step 5 — tests

- `HeroSetStoreTest`: goal default when unset · clamp + step snap on `setGoal` · XP still caps at 100 reps with goal 300 (rank curve unchanged) · lowering the goal below today's counts completes the mission and starts the streak.
- `HeroSetRulesTest`: `crossedGoal`/`missionComplete` at a non-100 goal.
- `HeroSetComplicationTest`: field 10 present, value order unchanged for fields 1-9.
- `HeroSetScreenFitTest`: widest states use **`MAX_MISSION_GOAL`**, not 100 — `TODAY 500/500`, `500/500` menu sublabels, dashboard bars at 500. Run per product as usual.
- Update the test count in `CLAUDE.md`, `README.md`, `docs/development.md`, `docs/release-contract.md` (all four).

### Step 6 — docs + public copy (same session as the code)

- New **ADR-045** at the end of `docs/decisions.md` (verify it is still the next free number): user-set daily goal, on-watch Storage not phone settings, XP pinned to 100 reps. Mark **ADR-002 Amended** (XP no longer follows the goal) and note ADR-044's field append.
- `docs/input-and-ux.md`: new menu item + picker screen, `TODAY N/<goal>` wording. Its line "XP: 2 per rep, counted up to each daily goal (max 600 a day, ADR-002)" goes false with a configurable goal — reword to *counted up to 100 per exercise per day whatever your goal*.
- `docs/architecture.md`: goal is store-owned, passed down; domain stays Storage-free.
- `PRODUCT.md` (line 13 and line 32, "daily goal 100 each (fixed, not user-configurable)"), `docs/release-contract.md` + `docs/store-release.md`: "100 a day" is a user-facing claim; it becomes "100 a day by default, any goal from 10 to 500". Also a claim, so it belongs in `release-contract.md` and on the support page: **rank reflects reps done, not goals hit**.
- `../verden-site/src/apps/heroset/` landing + support pages and the store listing description, same session.
- `go-to-market.md`: move this item out of backlog into open items when work starts; **gate 5 must be re-checked** — it verified "release menu: exercises + manual log only", and this adds a third kind of item.

## Watch checks (simulator is not proof)

- FR965: set goal 30 and 500, one set each, dashboard bars + menu sublabels + workout `TODAY` line legible; goal survives a restart.
- One MIP product and one small round product (208 px) for the picker at `500`.
- HeroFace on a CIQ 4.2+ product: face shows the custom goal, and still renders with an old HeroSet build installed.
