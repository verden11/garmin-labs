# HeroSet presentation layer (source/ui, source/layout, resources*): code quality and architecture review, working tree 2026-09-24

Scope: every file under `HeroSet/source/ui/` (all subfolders) and `source/layout/`, plus `resources*/` strings and menus, `resources-store/` and `resources-complications/`. Where UI crosses into `app/`, `HeroSetMenuDelegate.mc` and `HeroSetDelegate.mc` also read for navigation. All read from working tree, incl. today's staged changes. Checked `docs/architecture.md`, `input-and-ux.md`, `decisions.md` (ADR-017…049) against code.

How checked:
- Read every file in full.
- Ran Python script comparing ids and placeholders across all 15 `strings.xml` files (`scratchpad/l10n.py`).
- Compiled with `monkeyc -d fr965|venu441mm -f monkey.jungle` at type-check levels 0, 2, 3 (output in scratchpad only).
- Read SDK 9.2.0 WatchUi docs, simulator device definitions (`~/Library/Application Support/Garmin/ConnectIQ/Devices/*/simulator.json`).
- Did NOT run monkeydo or simulator. All below static or compiler evidence. **Simulator passing is not device proof, and none of this was run on a device.**

Legend: `U/` = `/Users/mbp/dev/garmin/HeroSet/source/ui/`. Links point at file, line number in link text.

---

## Q1. Is ADR-048's tap guard applied to every commit action? Can a stray tap or onSelect commit anything elsewhere?

### Takeaway
Yes. All three commit screens (workout Finish, manual-picker Save, goal-picker Save) return false from `onSelect`, commit only in `onKey` on `KEY_ENTER` via `HeroSetInput.isStart`. SDK dispatch order makes this correct: behavior first, then InputDelegate fallback. `onKey` fires once per press-and-release. No custom screen commits on tap. Only tap-selectable commits left: native Menu2 exit menus. ADR-048 scopes those out deliberately.

### Cited Findings
- Workout Finish: `onSelect` returns false. `onKey` returns false unless `isStart`, then pops workout, pushes seeded picker. — [U/workout/HeroSetWorkoutDelegate.mc:19-35](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutDelegate.mc)
- Manual picker Save: same pattern (`onSelect` false at :29-31; `onKey` at :33-45 calls `saveEntry` then one pop). — [U/manual/HeroSetManualPickerDelegate.mc:29-45](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerDelegate.mc)
- Goal picker Save: same pattern. — [U/settings/HeroSetGoalPickerDelegate.mc:26-38](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerDelegate.mc)
- `isStart` checks only `getKey() == KEY_ENTER`. — [U/HeroSetInput.mc:32-34](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetInput.mc)
- SDK, BehaviorDelegate: "If a BehaviorDelegate returns true for a function … then the InputDelegate function that corresponds to the behavior will not be called." Behavior (`onSelect`) runs first, `onKey` fallback. So `onSelect` returning **false** load-bearing: returning true would swallow START. — [SDK BehaviorDelegate.html](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/Toybox/WatchUi/BehaviorDelegate.html)
- SDK, `InputDelegate.onKey`: "A physical button has been pressed **and released**." Down/up separate callbacks (`onKeyPressed`/`onKeyReleased`). One START press -> one `onKey`; Finish press cannot leak second event into freshly pushed picker. — [SDK InputDelegate.html](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/Toybox/WatchUi/InputDelegate.html)
- Checked all 13 ADR-048 products' simulator definitions. Every one has `enter` key, so `KEY_ENTER` reaches `onKey`, commit path works on all. — [simulator.json per device](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Devices/)
  - 12 map `enter→onSelect`. venu441mm, venu445mm, vivoactive6 have only `enter`/`esc`. Other 9 add `menu→onMenu`. fr965 adds `up→previousPage`, `down→nextPage`.
  - **`d2airx10` maps `enter` with behavior `null`** (keys: `enter→None, menu→onMenu, esc→onBack`).
- Test pins load-bearing half: all three commit delegates' `onSelect()` return false. — [source/test/HeroSetInputTest.mc:10-18](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetInputTest.mc)
- Other screens:
  - Dashboard: tap = select opens menu (`HeroSetDelegate.onSelect → onMenu`). Harmless, documented in ADR-048. — [source/app/HeroSetDelegate.mc:17-19](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetDelegate.mc)
  - Validation log delegate: no `onSelect` override, tap does nothing. — [U/diagnostics/HeroSetValidationLogDelegate.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/diagnostics/HeroSetValidationLogDelegate.mc)
- Tap-selectable commits remaining (native Menu2, in scope of ADR-048 "Scope of the guard"):
  - Save and Discard in `WorkoutEndMenu` (order Resume/Save/Discard, default focus safe Resume). — [resources/menus/workout_end_menu.xml](file:///Users/mbp/dev/garmin/HeroSet/resources/menus/workout_end_menu.xml)
  - `ManualExitMenu`, used by both pickers (order **Save**/Discard/Keep Editing, default focus Save). — [resources/menus/manual_exit_menu.xml](file:///Users/mbp/dev/garmin/HeroSet/resources/menus/manual_exit_menu.xml)
  - Dev-build sync toggle. — [resources/menus/menu.xml](file:///Users/mbp/dev/garmin/HeroSet/resources/menus/menu.xml)
  - ADR-048 accepts all. — [docs/decisions.md ADR-048](file:///Users/mbp/dev/garmin/HeroSet/docs/decisions.md)

### Inferences
- Guard complete for custom screens. Remaining exposure: tap on native menu:
  - Mis-tap on **Discard** in workout end menu loses set with only `DISCARDED` toast.
  - Touch-first watches: swipe-right-from-edge opens that menu mid-set (ADR-048 known gap), finger already on screen when it appears.
  - Low risk, not bug, ADR-048 accepts. If Venu owners report, cheap mitigation: reorder `ManualExitMenu` as Keep Editing/Save/Discard, focused item non-destructive as in `WorkoutEndMenu`.
- Design note, not bug: START twice on Finish (START → picker, START → Save) banks seeded count, teaches learner (ADR-040 (learner)). Documented accept path (input-and-ux: "START at Finish, then START to save"). Key bounce or impatient double press = "reviewed" save. Worth knowing when reading learner data; no change recommended without evidence.
- Optional hedge: `isStart` could also require `keyEvent.getType() == WatchUi.PRESS_TYPE_ACTION`. SDK text above suggests not needed.

- **Possible finding (Low-medium, unverified, simulator definition only): on `d2airx10`, START may not open menu from dashboard.**
  - `HeroSetDelegate` handles only `onMenu`/`onSelect`/page behaviors, no `onKey`. — [source/app/HeroSetDelegate.mc](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetDelegate.mc)
  - With `enter` unmapped to `onSelect` on that product, START press would fall through, while `dashboard_hint` says `START: MENU`.
  - Menu button (`onMenu`) and tap still open menu, app stays usable.
  - Fix, if reproduces in d2airx10 simulator: add `onKey` returning `onMenu()` for `KEY_ENTER` in `HeroSetDelegate`, reusing `HeroSetInput.isStart`.
  - Whether native Menu2 selects on START on that product also unchecked.

### Gaps
- d2airx10 finding rests only on simulator key map (`behavior: null`). Real watch may map button differently.
- Dispatch cannot be proven by unit test. `WatchUi.KeyEvent` documents no public constructor (only `getKey`/`getType`), so `onKey` commit path has no automated test. ADR-048 itself says FR965 START path after `onSelect`→`onKey` move still owed on-wrist check, tap/swipe on touch-first watch untested by hand.

---

## Q2. Ranked findings (correctness, house rules, fit), each with a fix

### Takeaway
No high-severity bug found. Navigation pop counts consistent with ADR-024 (navigation depth) everywhere, every save path idempotent, timers and sensors pair correctly in `onShow`/`onHide`. Remaining, by rank:
- One low-medium quick-save edge case.
- One unverified clipping risk in hints.
- A handful of fixed-font text rows that fit only because test covers them.
- Pervasive untyped members make strict type-checking fail.

### Cited Findings (ranked)

**F1 (Medium, unverified). `HeroSetDraw.hint` has no wording or font fallback, so long translated SWIPE hints can clip on 360 px.**
- What it does: measures width at `FONT_XTINY`, walks y up via `fitCenteredY` to `minY`. If nothing fits, returns `minY`, draws anyway. No shorter candidate, no smaller font. — [U/HeroSetDraw.mc:52-59](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc); [source/layout/HeroSetLayout.mc:155-168](file:///Users/mbp/dev/garmin/HeroSet/source/layout/HeroSetLayout.mc)
- Longest new hints: Ukrainian `ПРОВЕДІТЬ: НАЛАШТУВАТИ` (22 chars), Lithuanian `BRAUKITE: REGULIUOTI`. — [resources-ukr/strings/strings.xml](file:///Users/mbp/dev/garmin/HeroSet/resources-ukr/strings/strings.xml)
- ADR-048 evidence says translated SWIPE hints were "not fit-checked by hand in the widest language (Ukrainian) on the narrowest screen (venu2s, 360 px)". — [docs/decisions.md ADR-048](file:///Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
- Fix:
  - First, run ADR-049 (per-language fit sweep) per-language overlay sweep on `venu2s` and `venu441mm`.
  - If anything misfits, give `hint` candidate list (`firstFitting`) with short form per language (e.g. `picker_hint_adjust_touch_short` id), not smaller font.

**F2 (Low-medium). Workout Back → Save with lone rep learned as "getting up" banks nothing, silently, while menu says "0 reps".**
- Back gate uses live count (`getDetectedCount() <= 0`). Comment says lone dropped rep "is still movement the user may want to keep". — [U/workout/HeroSetWorkoutDelegate.mc:40-45](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutDelegate.mc)
- Menu title uses drop-adjusted `getCount()`, shows "0 reps" (:47).
- `saveSet` then returns early on `count <= 0`, no toast. — [U/workout/HeroSetWorkoutView.mc:99-110](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc)
- `leave()` still pops two, returns to dashboard. — [U/HeroSetExitMenuDelegate.mc:51-55](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetExitMenuDelegate.mc)
- Net: user picked Save, gets no feedback, nothing stored, contradicts gate's stated intent.
- Related: whenever `dropsLastRep` true, menu title reads N−1 right after screen showed N. Picker solved same mismatch with `DETECTED N (-1)` (ADR-041 (save feedback)), Back menu doesn't.
- Fix, owner to pick one:
  - (a) Gate Back on `getCount() > 0`, so lone dropped rep leaves directly (matches what Save does today). One line.
  - (b) Keep gate, have quick-save bank `getDetectedCount()` when `getCount()` is 0, titled with live count.
- Either way, add test.

**F3 (Low-medium, house rule ADR-018 (measured, never guessed) "measured, never guessed"). Several rows use fixed font with no runtime measurement.**
- Workout `TODAY N/goal` fixed `FONT_TINY`. — [U/workout/HeroSetWorkoutView.mc:216-219](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc)
- Picker draws same string with `largestFont(SMALL→TINY→XTINY)`. — [U/manual/HeroSetManualPickerView.mc:123-133](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerView.mc)
- Other fixed-font rows:
  - Picker `DETECTED …` fixed XTINY (:109).
  - Picker delta fixed `FONT_LARGE` (:113).
  - Dashboard `NO STREAK YET` single candidate, not `firstFitting`. — [U/dashboard/HeroSetView.mc:75,85](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetView.mc)
  - Validation-log lines fixed XTINY (dev only). — [U/diagnostics/HeroSetValidationLogView.mc:50](file:///Users/mbp/dev/garmin/HeroSet/source/ui/diagnostics/HeroSetValidationLogView.mc)
- All go through `HeroSetDraw.text`, so `everyScreenFitsThisDisplay` sees them, but only in English inside repo. — [source/test/HeroSetScreenFitTest.mc](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetScreenFitTest.mc)
- Fix: use `largestFont` for workout TODAY row, reusing picker's call. Leave numeric delta alone (digits same in every language). Everything else covered if per-language sweep becomes repeatable (see Q6).

**F4 (Low, hardening; house rule "typed params + `as` types" reads as covering functions, but members untyped). Strict type-check fails.**
- `monkeyc -d fr965 -f monkey.jungle`:
  - Levels 0, 1, 2: 0 errors.
  - `-l 3`: exit 105, **197 errors**. ui/ has ~121: WorkoutView 42, ManualPickerView 29, GoalPickerView 16, WorkoutDelegate 11, two picker delegates 7 each, DayTracker 3, HeroSetView 3, ValidationLogDelegate 3. layout/HeroSetLayout has 19.
  - Source: compiler run, log in scratchpad `l3.log`.
- Root cause: untyped `private var` members:
  - Every field of WorkoutView, ManualPickerView, GoalPickerView, DayTracker, HeroSetLayout's five fields.
  - `_view` in all four behavior delegates: [HeroSetWorkoutDelegate.mc:6](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutDelegate.mc), [HeroSetManualPickerDelegate.mc:11](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerDelegate.mc), [HeroSetGoalPickerDelegate.mc:8](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerDelegate.mc), [HeroSetValidationLogDelegate.mc:6](file:///Users/mbp/dev/garmin/HeroSet/source/ui/diagnostics/HeroSetValidationLogDelegate.mc)
- By contrast, newer files type members: HeroSetMissionBars, HeroSetWorkoutMetrics, HeroSetValidationLogView, most of HeroSetView.
- Some level-3 errors are strict-mode narrowing complaints on already-guarded code, e.g. accelerometer null check at WorkoutView:169-175. Not all 121 real defects.
- Fix: type four delegates' `_view` first. Each discards typed constructor parameter, concrete win, since calls like `_view.saveEntry()` then unchecked. Then type view fields (`as Lang.Number`, `as Timer.Timer?`, …). Don't chase all of level 3.

**F5 (Low, render-only-in-onUpdate / logic placement).**
- `HeroSetGoalPickerView.saveEntry` holds save logic and feedback in view: store write, complication publish, mission-complete detection, toast, haptics. Duplicates `HeroSetSaveFeedback`'s mission tier and publish. — [U/settings/HeroSetGoalPickerView.mc:40-60](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerView.mc); [U/HeroSetSaveFeedback.mc:13-21,44-46](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetSaveFeedback.mc)
- Fix: add `HeroSetSaveFeedback.saveGoal(store, goal)`, so every stored change, toasts, publish go through one class. ADR-041 (save feedback) "every save path goes through HeroSetSaveFeedback" spirit. Test like `tierFor`.
- Minor render-time work could be cached (no correctness impact):
  - `ValidationLogView.onUpdate` loads hint resource, calls `touchFirst()` every frame. Pickers cache theirs. — [U/diagnostics/HeroSetValidationLogView.mc:54](file:///Users/mbp/dev/garmin/HeroSet/source/ui/diagnostics/HeroSetValidationLogView.mc)
  - `HeroSetView.drawStreak` loads `dashboard_streak_none` every frame. — [U/dashboard/HeroSetView.mc:75](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetView.mc)
  - Fix: cache in `initialize`, add `HeroSetInput.pageHint()` next to `adjustHint()`.
- `HeroSetMissionBars.draw` mutates `_goal`/`_doneWords` during draw. Comment acknowledges as per-draw scratch, reset every draw, acceptable. — [U/dashboard/HeroSetMissionBars.mc:11-17,32-42](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetMissionBars.mc)

**F6 (Low, magic numbers).**
- `HeroSetDraw.title` steps `y += 2`. — [U/HeroSetDraw.mc:70](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc)
- `fitCenteredY` steps `y -= 2`. — [source/layout/HeroSetLayout.mc:165](file:///Users/mbp/dev/garmin/HeroSet/source/layout/HeroSetLayout.mc)
- Fix: one `HeroSetLayout.FIT_STEP_PX` used by both.
- /10, /5, /9, /3, /6 layout proportions live in HeroSetLayout, where rule puts geometry, each commented. Acceptable.
- `PAGE_SIZE = 3` named constant in dev-only view. — [U/diagnostics/HeroSetValidationLogView.mc:12](file:///Users/mbp/dev/garmin/HeroSet/source/ui/diagnostics/HeroSetValidationLogView.mc)

**F7 (Low, goal picker doc/behavior nuance).**
- START with unchanged goal saves nothing, no toast, because `saveEntry` returns early on `!isChanged()`. — [U/settings/HeroSetGoalPickerView.mc:41-43](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerView.mc)
- input-and-ux says "START save and return to dashboard (`GOAL N` toast)" without that caveat. — [docs/input-and-ux.md](file:///Users/mbp/dev/garmin/HeroSet/docs/input-and-ux.md)
- Fix: add one doc clause. Behavior fine.
- Also: goal exit menu reuses `Rez.Menus.ManualExitMenu`, titles it with toast string `toast_goal_saved`. Works but couples menu title to toast copy. — [U/settings/HeroSetGoalPickerDelegate.mc:46-47](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerDelegate.mc)

**Verified correct (no finding):**
- Navigation, every path consistent with ADR-024 (navigation depth) depth 1:
  - Menu pops itself before pushing Workout, Manual picker or Goal picker. — [source/app/HeroSetMenuDelegate.mc:89-110](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetMenuDelegate.mc)
  - Workout pops itself before pushing picker (WorkoutDelegate:32-33).
  - Picker START pops 1.
  - Exit menus: stay pops 1, leave pops 2.
  - Workout Back with 0 reps and picker Back with delta 0 fall through to default pop.
  - Validation log pushed over menu (depth 2), its Back pops 1 back to menu.
  - No path over-pops.
- Double-save: every save idempotent via `_saved` flag:
  - WorkoutView.saveSet:100-103
  - ManualPickerView.saveEntry:71-74
  - GoalPickerView.saveEntry:41-44
- Lifecycle:
  - Workout `onShow`/`onHide` pair refresh timer (idempotent start/stop), sensor listener, HR enable/disable, sync resume/pause. — [U/workout/HeroSetWorkoutView.mc:47-87](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc)
  - Metrics baseline set once, so Resume doesn't restart clock. — [U/workout/HeroSetWorkoutMetrics.mc:27-36](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutMetrics.mc)
  - Dashboard DayTracker timer starts in `onShow`, stops in `onHide`. — [U/dashboard/HeroSetView.mc:50-56](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetView.mc); [U/dashboard/HeroSetDayTracker.mc:15-28](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetDayTracker.mc)
- No `dc.drawText` outside `HeroSetDraw.text`, no `as Any`, no raw `Graphics.COLOR_*` in ui/ or layout/ (grep).
- Size budgets: all ui/ and layout/ files ≤ 234 lines (WorkoutView largest), no function exceeds 25 lines (brace-count script).

### Inferences
- Fixed-font rows = practical risk to ADR-018 (measured, never guessed) in F3. Per-device test catches them only for English; ADR-049 (per-language fit sweep) showed translations are where 360 px breaks.

### Gaps
- Does `getApp().getStore().getDashboardState()` or `getCount()` (called from `onUpdate` in HeroSetView:25 and ManualPickerView:124/128) run `ensureCurrentDay()` and write Storage at midnight? Would be render-time state change (G4). Out of scope; read of `data/HeroSetStore.mc` declined, goes to data/domain reviewer.
- Toast text fit (`WatchUi.showToast`, e.g. Ukrainian `…ГОТОВО!`) native, not measurable through `HeroSetDraw`. Unverified.
- Whether `onHide` runs on app termination, deciding whether sensor listener and HR stay enabled if app killed mid-set. Unverified. System likely releases them at exit.
- Picker left open across midnight clamps and saves against new day's count. Edge case, not traced into store.

---

## Q3. Are the exit-menu delegates and pickers duplicated beyond what's justified?

### Takeaway
Three exit-menu subclasses justified: ADR-036 (exit-menu inheritance) chose override dispatch over stored `Lang.Method` for device safety. Keep. Two **picker delegates** = one merge with real payoff. ~90% identical, identical part exactly the ADR-048-critical `onSelect`/`onKey` pair. Picker **views** stay separate, for reasons their own header gives.

### Cited Findings
- Exit menus: `HeroSetManualExitMenuDelegate`, `HeroSetGoalExitMenuDelegate`, `HeroSetWorkoutEndMenuDelegate` 18 lines each. Differ only in view type and the one method called. All navigation lives in base. — [U/manual/HeroSetManualExitMenuDelegate.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualExitMenuDelegate.mc); [U/settings/HeroSetGoalExitMenuDelegate.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalExitMenuDelegate.mc); [U/workout/HeroSetWorkoutEndMenuDelegate.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutEndMenuDelegate.mc); [U/HeroSetExitMenuDelegate.mc:10-15](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetExitMenuDelegate.mc)
- ADR-036 (exit-menu inheritance) rationale: "Inheritance rather than a stored `Lang.Method`, because indirect binding has failed silently on device before (ADR-023) and this is the save path." — [docs/decisions.md ADR-036](file:///Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
- Picker delegates: `onPreviousPage`, `onNextPage`, `onSelect`, `onKey` line-for-line same apart from comments. Only `onBack` differs (`delta == 0` vs `!isChanged()`, title, which exit delegate). — [U/manual/HeroSetManualPickerDelegate.mc:18-58](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerDelegate.mc); [U/settings/HeroSetGoalPickerDelegate.mc:15-50](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerDelegate.mc)
- Picker views: goal view's header explicitly rejects parameterising manual view (exercise, detected count, learner all absent for a setting). Shared code = last 3 lines of `onUpdate` (save and adjust hint stack). — [U/settings/HeroSetGoalPickerView.mc:5-8,73-75](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerView.mc); [U/manual/HeroSetManualPickerView.mc:117-119](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerView.mc)
- Font ladder `[FONT_SMALL, FONT_TINY, FONT_XTINY]` written out in 4 places:
  - HeroSetDraw.title:67
  - HeroSetRankHeader:17
  - HeroSetMissionBars.countFont:69
  - ManualPickerView.drawToday:130

### Inferences
- Recommended: `HeroSetPickerDelegate` base, same inheritance pattern as exit menus. Holds page handlers, `onSelect` returning false, `onKey` → `commit()` + one pop; subclasses override `commit()` and `onBack()`. Puts tap guard and depth-1 single pop in one place, saves ~25 lines.
- Optional, small: `HeroSetDraw.pickerHints(dc, layout, top, saveHint, adjustHint)` for shared 3 lines, one `HeroSetDraw.TEXT_FONTS` static for ladder.
- Alternative deleting three exit subclasses: shared base view with `save()` override, still direct virtual dispatch not Method. Possible, but touches three views for ~50 lines. Not recommended now.

### Gaps
- None.

---

## Q4. Are any views drawing text without HeroSetDraw.text, or with guessed sizes? Is logic in onUpdate that belongs elsewhere?

### Takeaway
No bypass of `HeroSetDraw.text`. Some sizes fixed not measured (F3). `onUpdate` bodies render-only apart from store reads and cheap derivations. Real logic-in-view item = goal save feedback, in delegate-called method, not `onUpdate` (F5).

### Cited Findings
- `dc.drawText` appears only inside `HeroSetDraw.text`. — [U/HeroSetDraw.mc:20](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc) (grep over ui/ and layout/)
- `onUpdate` derivations:
  - Dashboard calls `HeroSetRules.missionComplete` twice per frame (streak color, footer). — [U/dashboard/HeroSetView.mc:83,97](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetView.mc)
  - Picker computes resulting total, clamps at 0 in `drawToday`. Clamp dead in normal flow, because `clampDelta` already keeps delta ≥ −stored. — [U/manual/HeroSetManualPickerView.mc:124-127](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerView.mc)
  - Workout sums stored + detected. — [U/workout/HeroSetWorkoutView.mc:217](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc)
- Store reads inside `onUpdate`: `HeroSetView.onUpdate` calls `getStore().getDashboardState()` (:25), `ManualPickerView.drawToday` calls `getCount`/`getGoal` (:124,128).

### Inferences
- Optional: put `missionComplete` on `HeroSetDashboardState`, computed once where state built. Removes duplicate call, keeps `HeroSetView` pure painter.

### Gaps
- Whether those store reads write (see Q2 Gaps).

---

## Q5. Localization integrity (scripted)

### Takeaway
Clean. All 14 translations carry every base id except two deliberately untranslated. No `$n$` placeholder mismatches, no duplicate ids. Both ADR-048 ids present in every language.

### Cited Findings
- Base `resources/strings/strings.xml` has 67 ids. Every `resources-<lang>/strings/strings.xml` (dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr) has 65. Each missing only `complication_label` and `complication_short`.
- Base file comments those two as "Name of the private complication HeroFace reads; not translated". Missing ids fall back to English, intentional. — [resources/strings/strings.xml:78-81](file:///Users/mbp/dev/garmin/HeroSet/resources/strings/strings.xml); [resources-complications/complications.xml:9](file:///Users/mbp/dev/garmin/HeroSet/resources-complications/complications.xml)
- Script results (`scratchpad/l10n.py`), every language:
  - 0 extra ids
  - 0 duplicate ids
  - 0 `$n$` placeholder mismatches
  - 0 newline mismatches
  - 0 attribute mismatches
- `picker_hint_adjust_touch` and `validation_log_hint_touch` present and translated in all 14:
  - deu `WISCHEN: ANPASSEN`
  - fre `BALAYER: AJUSTER`
  - ukr `ПРОВЕДІТЬ: НАЛАШТУВАТИ`
  - …
  - Source: [resources-*/strings/strings.xml](file:///Users/mbp/dev/garmin/HeroSet/resources-deu/strings/strings.xml)
- Strings identical to English. Mostly button names, `AppName`, `Connect Sync`, metric formats `$1$  HR $2$  CAL $3$` in dut/pol. One stands out: **Portuguese `dashboard_rank`/`toast_rank_up` = `RANK $1$` / `RANK $1$!`**, while spa/ita use `RANGO`. — [resources-por/strings/strings.xml](file:///Users/mbp/dev/garmin/HeroSet/resources-por/strings/strings.xml)
- Every base id referenced from source or resources. Script's "unreferenced" hits (`fit_label_exercise`, `fit_label_reps`, `fit_unit_none`) used by `resources/fitcontributions/fitcontributions.xml`, complication ids by `complications.xml`. — [resources/fitcontributions/fitcontributions.xml](file:///Users/mbp/dev/garmin/HeroSet/resources/fitcontributions/fitcontributions.xml)
- `resources-store/menus/menu.xml` = base main menu minus `sync_toggle` and `validation_log`. Same string ids, adds no l10n surface. — [resources-store/menus/menu.xml](file:///Users/mbp/dev/garmin/HeroSet/resources-store/menus/menu.xml)

### Inferences
- Structural integrity fine. Open localization risk = fit (F1), not completeness.

### Gaps
- Whether Portuguese `RANK` intentional loanword or oversight. Needs native speaker.
- ADR-048: translated SWIPE hints not written by native speakers.

---

## Q6. Doc drift and test gaps

### Takeaway
architecture.md not caught up with ADR-045 (goal picker) or ADR-048 (touch-first). input-and-ux.md accurate apart from two small nuances. Test gaps: goal exit menu's save dispatch, quick-save zero-count path, goal-save feedback, per-language fit sweep not reproducible from repo.

### Cited Findings (doc drift)
- architecture.md §2 file tree has no `ui/settings/` (HeroSetGoalPickerView, GoalPickerDelegate, GoalExitMenuDelegate) and no `ui/HeroSetInput`. Grep for `settings/|GoalPicker|HeroSetInput` finds nothing. — [docs/architecture.md §2](file:///Users/mbp/dev/garmin/HeroSet/docs/architecture.md)
- architecture.md §7 navigation:
  - No `Daily Goal ──► Goal picker [depth 1]` branch or its Save/Discard/Keep Editing exit menu, although code pushes it at depth 1. — [source/app/HeroSetMenuDelegate.mc:106-110](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetMenuDelegate.mc)
  - Shows only `Up/Down`, not swipe, not dashboard tap.
- architecture.md §9 "Out of scope" still lists **"Touch-first interaction"**. Contradicts ADR-048 and line 3 of same file ("five-button and touch-first (ADR-048)"). — [docs/architecture.md:3,186](file:///Users/mbp/dev/garmin/HeroSet/docs/architecture.md)
- architecture.md §4 UI bullets: Dashboard, Workout, Picker only, no goal picker, no input seam.
- input-and-ux.md says Back → **Save** "bank detected count as-is". ADR-040 (learner) says "the picker seed and quick-save use the dropped count", code banks `getCount()` (drop-adjusted). Learning section in input-and-ux mentions only picker, not quick-save. — [docs/input-and-ux.md](file:///Users/mbp/dev/garmin/HeroSet/docs/input-and-ux.md); [U/workout/HeroSetWorkoutView.mc:104](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc)
- input-and-ux.md, Daily goal: unchanged-goal START case (F7).
- Code comment: `HeroSetMissionBars.column` cites **ADR-029 (button rules)** for column alignment. Belongs to ADR-031 or ADR-049 (per-language fit sweep). — [U/dashboard/HeroSetMissionBars.mc:51](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetMissionBars.mc)

### Cited Findings (test gaps)
- `exitMenusDispatchSaveToTheirView` covers workout and manual exit delegates but **not `HeroSetGoalExitMenuDelegate`**. ADR-036 (exit-menu inheritance) reason for test: no-op base `save()` silently discards, compiler can't tell. Applies to goal delegate equally. — [source/test/HeroSetExitMenuTest.mc:10-28](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetExitMenuTest.mc)
  - Fix: add third block constructing `HeroSetGoalPickerView`, adjust by one step, call `save()` through base type, assert `store.getGoal()`.
- `HeroSetInputTest` only asserts `onSelect()==false`. `onKey`/`isStart` path untestable because `KeyEvent` has no public constructor; `previousPageStep()` direction only logged in fit test, never asserted per product. — [source/test/HeroSetInputTest.mc](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetInputTest.mc); [source/test/HeroSetScreenFitTest.mc:61](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetScreenFitTest.mc)
  - Cheap addition: assert `previousPageStep() == (touchFirst() ? -1 : 1)` and `adjustHint()` non-empty.
- No test for F2 path: quick-save with `detected=1`, `dropsLastRep`.
- No test for goal-save feedback (mission-complete toast when goal lowered below today's counts), because logic sits in view (F5).
- Screen-fit test renders English only. ADR-049 (per-language fit sweep) per-language sweep done "by overlaying each language's strings on the base resources in a scratch jungle", not in repo, so can't repeat as gate after string changes. — [docs/decisions.md ADR-049](file:///Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
  - Fix: commit overlay jungle or script under `HeroSet/tools/`, reference from development.md.

### Inferences
- Update architecture §2/§4/§7/§9 in one edit. ~10 lines, removes all drift.

### Gaps
- architecture §8 says `HeroSetStore.mc` is 330 lines, ADR-020 says 472 (2026-09-17). Data scope; flagged for data reviewer.

---

## Q7. What is good and should NOT be changed

### Takeaway
UI layer disciplined. Central choke points and their tests are why other findings small. Keep as is.

### Cited Findings
- **`HeroSetDraw.text` as single draw path**, with inert `misfits`/`boxes` instrumentation. Enables per-device clipping and overlap test on 80 products (ADR-034 (per-device fit test)). — [U/HeroSetDraw.mc:15-33](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc)
- **`HeroSetExitMenuDelegate` owning all pop counts**, plus test asserting override dispatch used (ADR-036 (exit-menu inheritance)). — [U/HeroSetExitMenuDelegate.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetExitMenuDelegate.mc)
- **`onSelect` returning false on commit screens, test pinning it.** Per SDK, exactly the load-bearing half of ADR-048. — [source/test/HeroSetInputTest.mc](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetInputTest.mc)
- **`HeroSetInput`**: one runtime seam for touch-first detection, swipe direction, hints, START. Chosen at runtime, so every product's fit run measures its own hint. — [U/HeroSetInput.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetInput.mc)
- **`HeroSetSaveFeedback.save` + pure `tierFor`**: before/after snapshots in one place, unit-testable tier order, complication publish on every rep save. — [U/HeroSetSaveFeedback.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetSaveFeedback.mc)
- **`_saved` idempotency guards** on all three save methods.
- **Symmetric `onShow`/`onHide`** with idempotent timer start/stop, metrics baseline set once. — [U/workout/HeroSetWorkoutView.mc:47-87](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc); [U/workout/HeroSetWorkoutMetrics.mc:27-36](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutMetrics.mc)
- **ADR-049 (per-language fit sweep) fallbacks**, both local, only active when normal layout fails:
  - `countFont` returns null, then plain labels used. — [U/dashboard/HeroSetMissionBars.mc:36-45](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetMissionBars.mc)
  - `title` walks down. — [U/HeroSetDraw.mc:65-75](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc)
- **`drawState` / `HeroSetDashboardState` split**, so dashboard renders store-free for tests. Goal travels on state, not in static (ADR-045 (goal picker)). — [U/dashboard/HeroSetView.mc:28-48](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetView.mc)
- **`HeroSetPalette` roles.** No raw `Graphics.COLOR_*` in ui/, all channels MIP-safe. — [U/HeroSetPalette.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetPalette.mc)
- **Why-comments throughout.** E.g. ADR-023 (indirect binding failure) explanation on public `onSensorData`/`onRefreshTick`, reason workout reads goal once per set. — [U/workout/HeroSetWorkoutView.mc:35-38,89-93,160-167](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc)
- **Size discipline**: every file under 250 lines, no function over ~25 lines. Build clean at type-check levels 0, 1, 2.

### Inferences
- Recommended changes (picker delegate base, typed `_view`, one hint fallback, `saveGoal` in SaveFeedback, doc sweep) all fit these patterns, not replace them.

### Gaps
- None beyond device and simulator verification ADR-048/049 already list as owed.