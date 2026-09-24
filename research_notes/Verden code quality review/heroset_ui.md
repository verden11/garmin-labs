# HeroSet presentation layer (source/ui, source/layout, resources*): code quality and architecture review, working tree 2026-09-24

Scope: every file under `HeroSet/source/ui/` (all subfolders) and `source/layout/`, plus `resources*/` strings and menus, `resources-store/` and `resources-complications/`. Where the UI crosses into `app/`, `HeroSetMenuDelegate.mc` and `HeroSetDelegate.mc` were also read for navigation. Everything was read from the working tree, which includes today's staged changes. I checked `docs/architecture.md`, `input-and-ux.md` and `decisions.md` (ADR-017…049) against the code.

How it was checked:
- Read every file in full.
- Ran a Python script comparing ids and placeholders across all 15 `strings.xml` files (`scratchpad/l10n.py`).
- Compiled with `monkeyc -d fr965|venu441mm -f monkey.jungle` at type-check levels 0, 2 and 3 (output in scratchpad only).
- Read the SDK 9.2.0 WatchUi docs and the simulator device definitions (`~/Library/Application Support/Garmin/ConnectIQ/Devices/*/simulator.json`).
- Did NOT run monkeydo or the simulator. Everything below is static or compiler evidence. **Simulator passing is not device proof, and none of this was run on a device.**

Legend: `U/` = `/Users/mbp/dev/garmin/HeroSet/source/ui/`. Links point at the file, and the line number is in the link text.

---

## Q1. Is ADR-048's tap guard applied to every commit action? Can a stray tap or onSelect commit anything elsewhere?

### Takeaway
Yes. All three commit screens (workout Finish, manual-picker Save, goal-picker Save) return false from `onSelect` and commit only in `onKey` on `KEY_ENTER` through `HeroSetInput.isStart`. The SDK's dispatch order makes this correct: behavior first, then the InputDelegate fallback. `onKey` fires once per press-and-release. No custom screen commits on a tap. The only tap-selectable commits left are the native Menu2 exit menus. ADR-048 scopes those out deliberately.

### Cited Findings
- Workout Finish: `onSelect` returns false. `onKey` returns false unless `isStart`, then pops the workout and pushes the seeded picker. — [U/workout/HeroSetWorkoutDelegate.mc:19-35](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutDelegate.mc)
- Manual picker Save: same pattern (`onSelect` false at :29-31; `onKey` at :33-45 calls `saveEntry` then does one pop). — [U/manual/HeroSetManualPickerDelegate.mc:29-45](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerDelegate.mc)
- Goal picker Save: same pattern. — [U/settings/HeroSetGoalPickerDelegate.mc:26-38](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerDelegate.mc)
- `isStart` checks only `getKey() == KEY_ENTER`. — [U/HeroSetInput.mc:32-34](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetInput.mc)
- SDK, BehaviorDelegate: "If a BehaviorDelegate returns true for a function … then the InputDelegate function that corresponds to the behavior will not be called." Behavior (`onSelect`) runs first and `onKey` is the fallback. So `onSelect` returning **false** is load-bearing: returning true would swallow START. — [SDK BehaviorDelegate.html](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/Toybox/WatchUi/BehaviorDelegate.html)
- SDK, `InputDelegate.onKey`: "A physical button has been pressed **and released**." Down and up are separate callbacks (`onKeyPressed`/`onKeyReleased`). So one START press gives one `onKey`, and the Finish press cannot leak a second event into the freshly pushed picker. — [SDK InputDelegate.html](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/Toybox/WatchUi/InputDelegate.html)
- I checked all 13 ADR-048 products' simulator definitions. Every one has an `enter` key, so `KEY_ENTER` reaches `onKey` and the commit path works on all of them. — [simulator.json per device](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Devices/)
  - 12 map `enter→onSelect`. venu441mm, venu445mm and vivoactive6 have only `enter`/`esc`. The other 9 add `menu→onMenu`. fr965 adds `up→previousPage` and `down→nextPage`.
  - **`d2airx10` maps `enter` with behavior `null`** (keys: `enter→None, menu→onMenu, esc→onBack`).
- A test pins the load-bearing half: all three commit delegates' `onSelect()` return false. — [source/test/HeroSetInputTest.mc:10-18](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetInputTest.mc)
- Other screens:
  - Dashboard: tap = select opens the menu (`HeroSetDelegate.onSelect → onMenu`). Harmless, and documented in ADR-048. — [source/app/HeroSetDelegate.mc:17-19](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetDelegate.mc)
  - Validation log delegate: no `onSelect` override, so a tap does nothing. — [U/diagnostics/HeroSetValidationLogDelegate.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/diagnostics/HeroSetValidationLogDelegate.mc)
- Tap-selectable commits that remain (native Menu2, in scope of ADR-048 "Scope of the guard"):
  - Save and Discard in `WorkoutEndMenu` (order Resume/Save/Discard, so default focus is the safe Resume). — [resources/menus/workout_end_menu.xml](file:///Users/mbp/dev/garmin/HeroSet/resources/menus/workout_end_menu.xml)
  - `ManualExitMenu`, used by both pickers (order **Save**/Discard/Keep Editing, so default focus is Save). — [resources/menus/manual_exit_menu.xml](file:///Users/mbp/dev/garmin/HeroSet/resources/menus/manual_exit_menu.xml)
  - Dev-build sync toggle. — [resources/menus/menu.xml](file:///Users/mbp/dev/garmin/HeroSet/resources/menus/menu.xml)
  - ADR-048 accepts all of these. — [docs/decisions.md ADR-048](file:///Users/mbp/dev/garmin/HeroSet/docs/decisions.md)

### Inferences
- The guard is complete for the custom screens. The remaining exposure is a tap on a native menu:
  - A mis-tap on **Discard** in the workout end menu loses the set with only a `DISCARDED` toast.
  - On touch-first watches, swipe-right-from-edge opens that menu mid-set (ADR-048 known gap), so a finger is already on the screen when it appears.
  - Low risk, not a bug, and ADR-048 accepts it. If Venu owners report it, the cheap mitigation is to reorder `ManualExitMenu` as Keep Editing/Save/Discard, so its focused item is the non-destructive one as in `WorkoutEndMenu`.
- Design note, not a bug: pressing START twice on Finish (START → picker, START → Save) banks the seeded count and teaches the learner (ADR-040). That is the documented accept path (input-and-ux: "START at Finish, then START to save"). A key bounce or impatient double press is therefore a "reviewed" save. It is worth knowing when reading learner data, but no change is recommended without evidence.
- Optional hedge: `isStart` could also require `keyEvent.getType() == WatchUi.PRESS_TYPE_ACTION`. The SDK text above suggests it isn't needed.

- **Possible finding (Low-medium, unverified, simulator definition only): on `d2airx10`, START may not open the menu from the dashboard.**
  - `HeroSetDelegate` handles only `onMenu`/`onSelect`/page behaviors and has no `onKey`. — [source/app/HeroSetDelegate.mc](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetDelegate.mc)
  - With `enter` unmapped to `onSelect` on that product, the START press would fall through, while `dashboard_hint` says `START: MENU`.
  - The menu button (`onMenu`) and a tap still open the menu, so the app stays usable.
  - Fix, if it reproduces in the d2airx10 simulator: add `onKey` returning `onMenu()` for `KEY_ENTER` in `HeroSetDelegate`, reusing `HeroSetInput.isStart`.
  - Whether native Menu2 selects on START on that product is also unchecked.

### Gaps
- The d2airx10 finding above rests only on the simulator key map (`behavior: null`). The real watch may map its button differently.
- The dispatch cannot be proven by unit test. `WatchUi.KeyEvent` documents no public constructor (only `getKey`/`getType`), so the `onKey` commit path has no automated test. ADR-048 itself says the FR965 START path after the `onSelect`→`onKey` move is still owed an on-wrist check, and tap/swipe on a touch-first watch is untested by hand.

---

## Q2. Ranked findings (correctness, house rules, fit), each with a fix

### Takeaway
No high-severity bug was found. Navigation pop counts are consistent with ADR-024 everywhere, every save path is idempotent, and timers and sensors pair correctly in `onShow`/`onHide`. What remains, by rank:
- One low-medium quick-save edge case.
- One unverified clipping risk in hints.
- A handful of fixed-font text rows that fit only because the test covers them.
- Pervasive untyped members that make strict type-checking fail.

### Cited Findings (ranked)

**F1 (Medium, unverified). `HeroSetDraw.hint` has no wording or font fallback, so long translated SWIPE hints can clip on 360 px.**
- What it does: it measures width at `FONT_XTINY` and walks y up via `fitCenteredY` to `minY`. If nothing fits, it returns `minY` and draws anyway. There is no shorter candidate and no smaller font. — [U/HeroSetDraw.mc:52-59](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc); [source/layout/HeroSetLayout.mc:155-168](file:///Users/mbp/dev/garmin/HeroSet/source/layout/HeroSetLayout.mc)
- Longest new hints: Ukrainian `ПРОВЕДІТЬ: НАЛАШТУВАТИ` (22 chars), Lithuanian `BRAUKITE: REGULIUOTI`. — [resources-ukr/strings/strings.xml](file:///Users/mbp/dev/garmin/HeroSet/resources-ukr/strings/strings.xml)
- ADR-048 evidence says the translated SWIPE hints were "not fit-checked by hand in the widest language (Ukrainian) on the narrowest screen (venu2s, 360 px)". — [docs/decisions.md ADR-048](file:///Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
- Fix:
  - First, run the ADR-049 per-language overlay sweep on `venu2s` and `venu441mm`.
  - If anything misfits, give `hint` a candidate list (`firstFitting`) with a short form per language (e.g. a `picker_hint_adjust_touch_short` id), not a smaller font.

**F2 (Low-medium). Workout Back → Save with a lone rep learned as "getting up" banks nothing, silently, while the menu says "0 reps".**
- The Back gate uses the live count (`getDetectedCount() <= 0`). The comment says a lone dropped rep "is still movement the user may want to keep". — [U/workout/HeroSetWorkoutDelegate.mc:40-45](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutDelegate.mc)
- The menu title uses the drop-adjusted `getCount()`, so it shows "0 reps" (:47).
- `saveSet` then returns early on `count <= 0`, with no toast. — [U/workout/HeroSetWorkoutView.mc:99-110](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc)
- `leave()` still pops two and returns to the dashboard. — [U/HeroSetExitMenuDelegate.mc:51-55](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetExitMenuDelegate.mc)
- Net effect: the user picked Save and gets no feedback and nothing stored, which contradicts the gate's stated intent.
- Related: whenever `dropsLastRep` is true, the menu title reads N−1 right after the screen showed N. The picker solved the same mismatch with `DETECTED N (-1)` (ADR-041), but the Back menu doesn't.
- Fix, owner to pick one:
  - (a) Gate Back on `getCount() > 0`, so a lone dropped rep leaves directly (matches what Save does today). One line.
  - (b) Keep the gate and have quick-save bank `getDetectedCount()` when `getCount()` is 0, titled with the live count.
- Either way, add a test for it.

**F3 (Low-medium, house rule ADR-018 "measured, never guessed"). Several rows use a fixed font with no runtime measurement.**
- Workout `TODAY N/goal` is fixed `FONT_TINY`. — [U/workout/HeroSetWorkoutView.mc:216-219](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc)
- The picker draws the same string with `largestFont(SMALL→TINY→XTINY)`. — [U/manual/HeroSetManualPickerView.mc:123-133](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerView.mc)
- Other fixed-font rows:
  - Picker `DETECTED …` at fixed XTINY (:109).
  - Picker delta at fixed `FONT_LARGE` (:113).
  - Dashboard `NO STREAK YET` is a single candidate, not `firstFitting`. — [U/dashboard/HeroSetView.mc:75,85](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetView.mc)
  - Validation-log lines at fixed XTINY (dev only). — [U/diagnostics/HeroSetValidationLogView.mc:50](file:///Users/mbp/dev/garmin/HeroSet/source/ui/diagnostics/HeroSetValidationLogView.mc)
- All of these go through `HeroSetDraw.text`, so `everyScreenFitsThisDisplay` sees them, but only in English inside the repo. — [source/test/HeroSetScreenFitTest.mc](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetScreenFitTest.mc)
- Fix: use `largestFont` for the workout TODAY row, reusing the picker's call. Leave the numeric delta alone (digits are the same in every language). Everything else is covered if the per-language sweep becomes repeatable (see Q6).

**F4 (Low, hardening; house rule "typed params + `as` types" reads as covering functions, but members are untyped). Strict type-check fails.**
- `monkeyc -d fr965 -f monkey.jungle`:
  - Levels 0, 1 and 2: 0 errors.
  - `-l 3`: exit 105, **197 errors**. ui/ has ~121: WorkoutView 42, ManualPickerView 29, GoalPickerView 16, WorkoutDelegate 11, the two picker delegates 7 each, DayTracker 3, HeroSetView 3, ValidationLogDelegate 3. layout/HeroSetLayout has 19.
  - Source: compiler run, log in scratchpad `l3.log`.
- Root cause: untyped `private var` members:
  - Every field of WorkoutView, ManualPickerView, GoalPickerView, DayTracker, and HeroSetLayout's five fields.
  - `_view` in all four behavior delegates: [HeroSetWorkoutDelegate.mc:6](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutDelegate.mc), [HeroSetManualPickerDelegate.mc:11](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerDelegate.mc), [HeroSetGoalPickerDelegate.mc:8](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerDelegate.mc), [HeroSetValidationLogDelegate.mc:6](file:///Users/mbp/dev/garmin/HeroSet/source/ui/diagnostics/HeroSetValidationLogDelegate.mc)
- By contrast, newer files type their members: HeroSetMissionBars, HeroSetWorkoutMetrics, HeroSetValidationLogView, most of HeroSetView.
- Some level-3 errors are strict-mode narrowing complaints on code that is already guarded, e.g. the accelerometer null check at WorkoutView:169-175. Not all 121 are real defects.
- Fix: type the four delegates' `_view` first. Each discards a typed constructor parameter, which is the concrete win, since calls like `_view.saveEntry()` are then unchecked. Then type view fields (`as Lang.Number`, `as Timer.Timer?`, …). Don't chase all of level 3.

**F5 (Low, render-only-in-onUpdate / logic placement).**
- `HeroSetGoalPickerView.saveEntry` holds save logic and feedback in the view: store write, complication publish, mission-complete detection, toast, haptics. It duplicates `HeroSetSaveFeedback`'s mission tier and publish. — [U/settings/HeroSetGoalPickerView.mc:40-60](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerView.mc); [U/HeroSetSaveFeedback.mc:13-21,44-46](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetSaveFeedback.mc)
- Fix: add `HeroSetSaveFeedback.saveGoal(store, goal)`, so every stored change and its toasts and publish go through one class. That is the ADR-041 "every save path goes through HeroSetSaveFeedback" spirit. Test it like `tierFor`.
- Minor render-time work that could be cached (no correctness impact):
  - `ValidationLogView.onUpdate` loads the hint resource and calls `touchFirst()` every frame. The pickers cache theirs. — [U/diagnostics/HeroSetValidationLogView.mc:54](file:///Users/mbp/dev/garmin/HeroSet/source/ui/diagnostics/HeroSetValidationLogView.mc)
  - `HeroSetView.drawStreak` loads `dashboard_streak_none` every frame. — [U/dashboard/HeroSetView.mc:75](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetView.mc)
  - Fix: cache in `initialize`, and add `HeroSetInput.pageHint()` next to `adjustHint()`.
- `HeroSetMissionBars.draw` mutates `_goal`/`_doneWords` during draw. The comment acknowledges it as per-draw scratch, it is reset every draw, and it is acceptable. — [U/dashboard/HeroSetMissionBars.mc:11-17,32-42](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetMissionBars.mc)

**F6 (Low, magic numbers).**
- `HeroSetDraw.title` steps `y += 2`. — [U/HeroSetDraw.mc:70](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc)
- `fitCenteredY` steps `y -= 2`. — [source/layout/HeroSetLayout.mc:165](file:///Users/mbp/dev/garmin/HeroSet/source/layout/HeroSetLayout.mc)
- Fix: one `HeroSetLayout.FIT_STEP_PX` used by both.
- The /10, /5, /9, /3, /6 layout proportions live in HeroSetLayout, which is where the rule puts geometry, and each is commented. Acceptable.
- `PAGE_SIZE = 3` is a named constant in a dev-only view. — [U/diagnostics/HeroSetValidationLogView.mc:12](file:///Users/mbp/dev/garmin/HeroSet/source/ui/diagnostics/HeroSetValidationLogView.mc)

**F7 (Low, goal picker doc/behavior nuance).**
- START with an unchanged goal saves nothing and shows no toast, because `saveEntry` returns early on `!isChanged()`. — [U/settings/HeroSetGoalPickerView.mc:41-43](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerView.mc)
- input-and-ux says "START save and return to dashboard (`GOAL N` toast)" without that caveat. — [docs/input-and-ux.md](file:///Users/mbp/dev/garmin/HeroSet/docs/input-and-ux.md)
- Fix: add one doc clause. The behavior is fine.
- Also: the goal exit menu reuses `Rez.Menus.ManualExitMenu` and titles it with the toast string `toast_goal_saved`. That works but couples a menu title to toast copy. — [U/settings/HeroSetGoalPickerDelegate.mc:46-47](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerDelegate.mc)

**Verified correct (no finding):**
- Navigation, every path consistent with ADR-024 depth 1:
  - Menu pops itself before pushing Workout, Manual picker or Goal picker. — [source/app/HeroSetMenuDelegate.mc:89-110](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetMenuDelegate.mc)
  - Workout pops itself before pushing the picker (WorkoutDelegate:32-33).
  - Picker START pops 1.
  - Exit menus: stay pops 1, leave pops 2.
  - Workout Back with 0 reps and picker Back with delta 0 fall through to the default pop.
  - The validation log is pushed over the menu (depth 2), and its Back pops 1 back to the menu.
  - No path over-pops.
- Double-save: every save is idempotent through a `_saved` flag:
  - WorkoutView.saveSet:100-103
  - ManualPickerView.saveEntry:71-74
  - GoalPickerView.saveEntry:41-44
- Lifecycle:
  - Workout `onShow`/`onHide` pair the refresh timer (idempotent start/stop), the sensor listener, HR enable/disable and sync resume/pause. — [U/workout/HeroSetWorkoutView.mc:47-87](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc)
  - The metrics baseline is set once, so Resume doesn't restart the clock. — [U/workout/HeroSetWorkoutMetrics.mc:27-36](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutMetrics.mc)
  - The dashboard DayTracker timer starts in `onShow` and stops in `onHide`. — [U/dashboard/HeroSetView.mc:50-56](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetView.mc); [U/dashboard/HeroSetDayTracker.mc:15-28](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetDayTracker.mc)
- No `dc.drawText` outside `HeroSetDraw.text`, no `as Any`, and no raw `Graphics.COLOR_*` in ui/ or layout/ (grep).
- Size budgets: all ui/ and layout/ files ≤ 234 lines (WorkoutView is largest), and no function exceeds 25 lines (brace-count script).

### Inferences
- The fixed-font rows are the practical risk to ADR-018 in F3. The per-device test catches them only for English, and ADR-049 showed that translations are where 360 px breaks.

### Gaps
- Does `getApp().getStore().getDashboardState()` or `getCount()` (called from `onUpdate` in HeroSetView:25 and ManualPickerView:124/128) run `ensureCurrentDay()` and write Storage at midnight? That would be a render-time state change (G4). It is out of scope for this review, and the read of `data/HeroSetStore.mc` was declined, so it goes to the data/domain reviewer.
- Toast text fit (`WatchUi.showToast`, e.g. Ukrainian `…ГОТОВО!`) is native and not measurable through `HeroSetDraw`. Unverified.
- Whether `onHide` runs on app termination, which would decide whether the sensor listener and HR stay enabled if the app is killed mid-set. Unverified. The system likely releases them at exit.
- A Picker left open across midnight clamps and saves against the new day's count. Edge case, not traced into the store.

---

## Q3. Are the exit-menu delegates and pickers duplicated beyond what's justified?

### Takeaway
The three exit-menu subclasses are justified: ADR-036 chose override dispatch over a stored `Lang.Method` for device safety. Keep them. The two **picker delegates** are the one merge with a real payoff. They are about 90% identical, and the identical part is exactly the ADR-048-critical `onSelect`/`onKey` pair. The picker **views** should stay separate, for the reasons their own header gives.

### Cited Findings
- Exit menus: `HeroSetManualExitMenuDelegate`, `HeroSetGoalExitMenuDelegate` and `HeroSetWorkoutEndMenuDelegate` are 18 lines each. They differ only in the view type and the one method called. All navigation lives in the base. — [U/manual/HeroSetManualExitMenuDelegate.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualExitMenuDelegate.mc); [U/settings/HeroSetGoalExitMenuDelegate.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalExitMenuDelegate.mc); [U/workout/HeroSetWorkoutEndMenuDelegate.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutEndMenuDelegate.mc); [U/HeroSetExitMenuDelegate.mc:10-15](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetExitMenuDelegate.mc)
- ADR-036 rationale: "Inheritance rather than a stored `Lang.Method`, because indirect binding has failed silently on device before (ADR-023) and this is the save path." — [docs/decisions.md ADR-036](file:///Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
- Picker delegates: `onPreviousPage`, `onNextPage`, `onSelect` and `onKey` are line-for-line the same apart from comments. Only `onBack` differs (`delta == 0` vs `!isChanged()`, the title, and which exit delegate). — [U/manual/HeroSetManualPickerDelegate.mc:18-58](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerDelegate.mc); [U/settings/HeroSetGoalPickerDelegate.mc:15-50](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerDelegate.mc)
- Picker views: the goal view's header explicitly rejects parameterising the manual view (exercise, detected count and learner are all absent for a setting). Their shared code is the last 3 lines of `onUpdate` (the save and adjust hint stack). — [U/settings/HeroSetGoalPickerView.mc:5-8,73-75](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerView.mc); [U/manual/HeroSetManualPickerView.mc:117-119](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerView.mc)
- The font ladder `[FONT_SMALL, FONT_TINY, FONT_XTINY]` is written out in 4 places:
  - HeroSetDraw.title:67
  - HeroSetRankHeader:17
  - HeroSetMissionBars.countFont:69
  - ManualPickerView.drawToday:130

### Inferences
- Recommended: a `HeroSetPickerDelegate` base, the same inheritance pattern as the exit menus. It would hold the page handlers, `onSelect` returning false and `onKey` → `commit()` + one pop, and subclasses would override `commit()` and `onBack()`. That puts the tap guard and the depth-1 single pop in one place and saves about 25 lines.
- Optional, small: `HeroSetDraw.pickerHints(dc, layout, top, saveHint, adjustHint)` for the shared 3 lines, and one `HeroSetDraw.TEXT_FONTS` static for the ladder.
- An alternative that deletes the three exit subclasses: a shared base view with a `save()` override, still direct virtual dispatch rather than a Method. It is possible, but it touches three views for about 50 lines. Not recommended now.

### Gaps
- None.

---

## Q4. Are any views drawing text without HeroSetDraw.text, or with guessed sizes? Is logic in onUpdate that belongs elsewhere?

### Takeaway
There is no bypass of `HeroSetDraw.text`. Some sizes are fixed rather than measured (F3). `onUpdate` bodies are render-only apart from store reads and cheap derivations. The real logic-in-view item is the goal save feedback, which is in a delegate-called method, not in `onUpdate` (F5).

### Cited Findings
- `dc.drawText` appears only inside `HeroSetDraw.text`. — [U/HeroSetDraw.mc:20](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc) (grep over ui/ and layout/)
- `onUpdate` derivations:
  - Dashboard calls `HeroSetRules.missionComplete` twice per frame (streak color and footer). — [U/dashboard/HeroSetView.mc:83,97](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetView.mc)
  - The picker computes the resulting total and clamps it at 0 in `drawToday`. The clamp is dead in normal flow, because `clampDelta` already keeps delta ≥ −stored. — [U/manual/HeroSetManualPickerView.mc:124-127](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerView.mc)
  - Workout sums stored + detected. — [U/workout/HeroSetWorkoutView.mc:217](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc)
- Store reads inside `onUpdate`: `HeroSetView.onUpdate` calls `getStore().getDashboardState()` (:25), and `ManualPickerView.drawToday` calls `getCount`/`getGoal` (:124,128).

### Inferences
- Optional: put `missionComplete` on `HeroSetDashboardState`, computed once where the state is built. That would remove the duplicate call and keep `HeroSetView` a pure painter.

### Gaps
- Whether those store reads write (see Q2 Gaps).

---

## Q5. Localization integrity (scripted)

### Takeaway
It is clean. All 14 translations carry every base id except two that are deliberately untranslated. No `$n$` placeholder mismatches and no duplicate ids. Both ADR-048 ids are present in every language.

### Cited Findings
- Base `resources/strings/strings.xml` has 67 ids. Every `resources-<lang>/strings/strings.xml` (dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr) has 65. Each is missing only `complication_label` and `complication_short`.
- The base file comments those two as "Name of the private complication HeroFace reads; not translated". Missing ids fall back to English, which is intentional. — [resources/strings/strings.xml:78-81](file:///Users/mbp/dev/garmin/HeroSet/resources/strings/strings.xml); [resources-complications/complications.xml:9](file:///Users/mbp/dev/garmin/HeroSet/resources-complications/complications.xml)
- Script results (`scratchpad/l10n.py`), for every language:
  - 0 extra ids
  - 0 duplicate ids
  - 0 `$n$` placeholder mismatches
  - 0 newline mismatches
  - 0 attribute mismatches
- `picker_hint_adjust_touch` and `validation_log_hint_touch` are present and translated in all 14:
  - deu `WISCHEN: ANPASSEN`
  - fre `BALAYER: AJUSTER`
  - ukr `ПРОВЕДІТЬ: НАЛАШТУВАТИ`
  - …
  - Source: [resources-*/strings/strings.xml](file:///Users/mbp/dev/garmin/HeroSet/resources-deu/strings/strings.xml)
- Strings identical to English. Mostly button names, `AppName`, `Connect Sync`, and the metric formats `$1$  HR $2$  CAL $3$` in dut/pol. One stands out: **Portuguese `dashboard_rank`/`toast_rank_up` = `RANK $1$` / `RANK $1$!`**, while spa/ita use `RANGO`. — [resources-por/strings/strings.xml](file:///Users/mbp/dev/garmin/HeroSet/resources-por/strings/strings.xml)
- Every base id is referenced from source or resources. The script's "unreferenced" hits (`fit_label_exercise`, `fit_label_reps`, `fit_unit_none`) are used by `resources/fitcontributions/fitcontributions.xml`, and the complication ids by `complications.xml`. — [resources/fitcontributions/fitcontributions.xml](file:///Users/mbp/dev/garmin/HeroSet/resources/fitcontributions/fitcontributions.xml)
- `resources-store/menus/menu.xml` is the base main menu minus `sync_toggle` and `validation_log`. It uses the same string ids, so it adds no l10n surface. — [resources-store/menus/menu.xml](file:///Users/mbp/dev/garmin/HeroSet/resources-store/menus/menu.xml)

### Inferences
- Structural integrity is fine. The open localization risk is fit (F1), not completeness.

### Gaps
- Whether Portuguese `RANK` is an intentional loanword or an oversight. It needs a native speaker.
- ADR-048: the translated SWIPE hints were not written by native speakers.

---

## Q6. Doc drift and test gaps

### Takeaway
architecture.md has not caught up with ADR-045 (goal picker) or ADR-048 (touch-first). input-and-ux.md is accurate apart from two small nuances. Test gaps: the goal exit menu's save dispatch, the quick-save zero-count path, goal-save feedback, and a per-language fit sweep that isn't reproducible from the repo.

### Cited Findings (doc drift)
- architecture.md §2's file tree has no `ui/settings/` (HeroSetGoalPickerView, GoalPickerDelegate, GoalExitMenuDelegate) and no `ui/HeroSetInput`. A grep for `settings/|GoalPicker|HeroSetInput` finds nothing. — [docs/architecture.md §2](file:///Users/mbp/dev/garmin/HeroSet/docs/architecture.md)
- architecture.md §7 navigation:
  - It has no `Daily Goal ──► Goal picker [depth 1]` branch or its Save/Discard/Keep Editing exit menu, although the code pushes it at depth 1. — [source/app/HeroSetMenuDelegate.mc:106-110](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetMenuDelegate.mc)
  - It shows only `Up/Down`, not swipe, and not the dashboard tap.
- architecture.md §9 "Out of scope" still lists **"Touch-first interaction"**. That contradicts ADR-048 and line 3 of the same file ("five-button and touch-first (ADR-048)"). — [docs/architecture.md:3,186](file:///Users/mbp/dev/garmin/HeroSet/docs/architecture.md)
- architecture.md §4 UI bullets: Dashboard, Workout and Picker only, with no goal picker and no input seam.
- input-and-ux.md says Back → **Save** "bank detected count as-is". ADR-040 says "the picker seed and quick-save use the dropped count", and the code banks `getCount()` (drop-adjusted). The Learning section in input-and-ux mentions only the picker, not quick-save. — [docs/input-and-ux.md](file:///Users/mbp/dev/garmin/HeroSet/docs/input-and-ux.md); [U/workout/HeroSetWorkoutView.mc:104](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc)
- input-and-ux.md, Daily goal: the unchanged-goal START case (F7).
- Code comment: `HeroSetMissionBars.column` cites **ADR-029** (button rules) for column alignment. That belongs to ADR-031 or ADR-049. — [U/dashboard/HeroSetMissionBars.mc:51](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetMissionBars.mc)

### Cited Findings (test gaps)
- `exitMenusDispatchSaveToTheirView` covers the workout and manual exit delegates but **not `HeroSetGoalExitMenuDelegate`**. ADR-036's reason for the test is that a no-op base `save()` silently discards and the compiler can't tell. That applies to the goal delegate equally. — [source/test/HeroSetExitMenuTest.mc:10-28](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetExitMenuTest.mc)
  - Fix: add a third block that constructs `HeroSetGoalPickerView`, adjusts by one step, calls `save()` through the base type, and asserts `store.getGoal()`.
- `HeroSetInputTest` only asserts `onSelect()==false`. The `onKey`/`isStart` path is untestable because `KeyEvent` has no public constructor, and `previousPageStep()`'s direction is only logged in the fit test, never asserted per product. — [source/test/HeroSetInputTest.mc](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetInputTest.mc); [source/test/HeroSetScreenFitTest.mc:61](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetScreenFitTest.mc)
  - Cheap addition: assert `previousPageStep() == (touchFirst() ? -1 : 1)` and `adjustHint()` non-empty.
- No test for the F2 path: quick-save with `detected=1`, `dropsLastRep`.
- No test for goal-save feedback (mission-complete toast when the goal is lowered below today's counts), because the logic sits in the view (F5).
- The screen-fit test renders English only. ADR-049's per-language sweep was done "by overlaying each language's strings on the base resources in a scratch jungle", which isn't in the repo, so it can't be repeated as a gate after string changes. — [docs/decisions.md ADR-049](file:///Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
  - Fix: commit the overlay jungle or script under `HeroSet/tools/` and reference it from development.md.

### Inferences
- Update architecture §2/§4/§7/§9 in one edit. It's about 10 lines and would remove all of the drift.

### Gaps
- architecture §8 says `HeroSetStore.mc` is 330 lines, and ADR-020 says 472 (2026-09-17). Data scope; flagged for the data reviewer.

---

## Q7. What is good and should NOT be changed

### Takeaway
The UI layer is disciplined. The central choke points and their tests are the reason the other findings are small. Keep them as they are.

### Cited Findings
- **`HeroSetDraw.text` as the single draw path**, with inert `misfits`/`boxes` instrumentation. This enables the per-device clipping and overlap test on 80 products (ADR-034). — [U/HeroSetDraw.mc:15-33](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc)
- **`HeroSetExitMenuDelegate` owning all pop counts**, plus a test asserting that override dispatch is used (ADR-036). — [U/HeroSetExitMenuDelegate.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetExitMenuDelegate.mc)
- **`onSelect` returning false on commit screens, with a test pinning it.** Per the SDK, this is exactly the load-bearing half of ADR-048. — [source/test/HeroSetInputTest.mc](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetInputTest.mc)
- **`HeroSetInput`**: one runtime seam for touch-first detection, swipe direction, hints and START. It is chosen at runtime, so every product's fit run measures its own hint. — [U/HeroSetInput.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetInput.mc)
- **`HeroSetSaveFeedback.save` + pure `tierFor`**: before and after snapshots in one place, a unit-testable tier order, and a complication publish on every rep save. — [U/HeroSetSaveFeedback.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetSaveFeedback.mc)
- **`_saved` idempotency guards** on all three save methods.
- **Symmetric `onShow`/`onHide`** with idempotent timer start/stop, and a metrics baseline set once. — [U/workout/HeroSetWorkoutView.mc:47-87](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc); [U/workout/HeroSetWorkoutMetrics.mc:27-36](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutMetrics.mc)
- **ADR-049 fallbacks**, both local, and only active when the normal layout fails:
  - `countFont` returns null, then the plain labels are used. — [U/dashboard/HeroSetMissionBars.mc:36-45](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetMissionBars.mc)
  - `title` walks down. — [U/HeroSetDraw.mc:65-75](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc)
- **The `drawState` / `HeroSetDashboardState` split**, so the dashboard renders store-free for tests. The goal travels on the state, not in a static (ADR-045). — [U/dashboard/HeroSetView.mc:28-48](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetView.mc)
- **`HeroSetPalette` roles.** No raw `Graphics.COLOR_*` in ui/, and all channels are MIP-safe. — [U/HeroSetPalette.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetPalette.mc)
- **Why-comments throughout.** For example, the ADR-023 explanation on the public `onSensorData`/`onRefreshTick`, and the reason the workout reads the goal once per set. — [U/workout/HeroSetWorkoutView.mc:35-38,89-93,160-167](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc)
- **Size discipline**: every file under 250 lines and no function over about 25 lines. The build is clean at type-check levels 0, 1 and 2.

### Inferences
- The recommended changes (a picker delegate base, typed `_view`, one hint fallback, `saveGoal` in SaveFeedback, the doc sweep) all fit these patterns rather than replacing them.

### Gaps
- None beyond the device and simulator verification that ADR-048/049 already list as owed.
