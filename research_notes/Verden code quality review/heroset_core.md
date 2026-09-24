# HeroSet core layers (app/, domain/, data/, sensor/, test/, build config): code quality and architecture review, working tree 2026-09-24

Scope: `/Users/mbp/dev/garmin/HeroSet`, the staged working tree (ADR-048/049 wave included). Read-only review. Sources are the files themselves (cited as path:line), the SDK 9.2.0 docs and `bin/resources.xsd`, and compiler runs whose outputs are in the scratchpad only:
- `monkeyc -d fr965 -f monkey.jungle`: BUILD SUCCESSFUL
- `-d fenix6 -f store.jungle`: BUILD SUCCESSFUL
- `-d venu441mm -f store.jungle`: BUILD SUCCESSFUL
- `-t -d fr965 -f store.jungle`: BUILD SUCCESSFUL
- `-l 3` (strict typecheck) dev fr965: 197 errors, most of them in UI

No simulator or monkeydo was run, so nothing here is device or runtime proof.

Severity key: **High** = likely user-visible failure. **Med** = real defect or rule violation with a plausible failure path. **Low** = hygiene or doc work.
Category key: (a) correctness/crash, (b) house-rule violation, (c) architecture/duplication/dead code, (d) test gap, (e) doc drift.

**Overall verdict:** I found no likely crash and no High-severity defect in the non-UI layers. The domain code (rules, calendar, detector, trace, learner) is clean, typed, short and well tested. The findings below are hardening against documented exceptions, layering leaks, untyped members that turn off type checking where it matters most (the store), and doc drift.

---

## 1. Does any layer reach upward or sideways? Does anything outside data/ touch Storage?

### Takeaway
Nothing outside `data/` touches `Toybox.Application.Storage`. Two real upward dependencies break the stated layer rule:
- `data/` returns a class that lives in `ui/`.
- `sensor/HeroSetActivitySync` loads UI strings through `HeroSetText`.

Separately, the save and learn orchestration lives in a View (presentation, which is allowed, but it violates G4 and splits one pipeline across three files).

### Cited Findings
- **Storage isolation holds.** `grep "Storage\.|Application.Storage|Properties\."` outside `data/` finds only comments and the test seam `HeroSetTestStorage`. Only [HeroSetPersistentStorage.mc:15,19](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetPersistentStorage.mc) calls `Storage.getValue/setValue`. (Good, keep.)
- **Med (c) Data → UI dependency.** [HeroSetStore.mc:135-147](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc) `getDashboardState()` constructs `HeroSetDashboardState`, which lives in [ui/dashboard/HeroSetDashboardState.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetDashboardState.mc). That class is a pure `Toybox.Lang` value object with 8 typed fields and no WatchUi. `app/HeroSetComplicationPublisher.valueFor` also takes it.
  - **Fix:** `git mv` the file to `source/data/` or `source/domain/`. Monkey C has no module paths, so no code changes. Update the architecture §2 tree.
- **Med (c) Sensor → UI dependency.** [HeroSetActivitySync.mc:41,43](file:///Users/mbp/dev/garmin/HeroSet/source/sensor/HeroSetActivitySync.mc) calls `HeroSetText.load(Rez.Strings.fit_unit_reps)` and `HeroSetText.load(Rez.Strings.AppName)`. This contradicts architecture §3: "Sensor classes take plain args, return plain values". The file's own header, line 10, says it "mirrors HeroSetSensorManager".
  - **Fix:** change it to `open(name as String, unit as String)`. `HeroSetSyncCoordinator.beginSet` (app layer, already uses `HeroSetText`) passes the two strings. The code is dev-only `(:sync)`, so there is no store-build risk.
- **Low (c) Save pipeline split across three presentation files.**
  - [HeroSetManualPickerView.mc](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerView.mc) `saveEntry` (about lines 70-96 of the file) runs, in order: `HeroSetSaveFeedback.save`, then `store.logValidationTrial`, then `getApp().getSync().setSaved`, then `learnFromSet`, which does `getLearningState`, `HeroSetThresholdLearner.updated` and `setLearningState`.
  - [HeroSetWorkoutView.mc:99-110](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc) `saveSet` repeats part of that sequence: save, then `sync.setSaved`.
  - [HeroSetSaveFeedback.mc:13-21](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetSaveFeedback.mc) does `store.add` plus `HeroSetComplicationPublisher.publish` plus the toast.
  - So a save is spread over a View, a UI helper and the app layer. That is legal under §3 (presentation = app/ + ui/), but it contradicts G4 ("logic in delegates/stores/domain"). It is also the path where the ADR-046 watchdog crash happened.
  - **Fix (only if touched anyway):** one `app/`-level `HeroSetSaveFlow.save(exercise, delta, detectedSeed?, trace?)`. Not urgent, since both paths are tested indirectly.
- **Domain stays clean.** `domain/` imports only `Toybox.Lang`, `Math`, `Time`, `Time.Gregorian`. The one sideways call is `HeroSetSwingTrace.apply → HeroSetThresholdLearner.thresholds()` ([HeroSetSwingTrace.mc:94](file:///Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetSwingTrace.mc)), which stays within the domain and is intentional (memoised grid, ADR-046). (Good, keep.)

### Inferences
- The two upward edges are cheap to remove: one file move and one signature change. Removing them would make architecture §3 literally true.
- Architecture §3 currently misdescribes the code on both points.

### Gaps
- UI-internal layering (ui ↔ layout) was not reviewed. That is another reviewer's scope.

---

## 2. House-rule violations: untyped functions and members, magic numbers, over-long functions/files, swallowed exceptions

### Takeaway
Every function in scope has typed parameters and return types except two. The bigger problem is untyped **members**:
- `HeroSetStore._storage` and `_clock`, `HeroSetApp._store` and `_sync`, `HeroSetSensorManager._enabled` are all untyped.
- That makes every call on the persistence API `Any`, so the compiler checks nothing on the path that guards user data.
- A typed storage seam would also let the compiler catch the ADR-022 Symbol-in-Storage crash class.

Only one function is over 30 lines. One unlisted file is over 250 lines. The catch-alls are broad but flagged.

### Cited Findings
- **Med (b)(a) Untyped members switch off type checking on the persistence path.**
  - [HeroSetStore.mc:34-36](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc): `private var _storage; private var _clock; private var _writeFailed = false;`
  - [HeroSetApp.mc:7-8](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetApp.mc): `_store`, `_sync`
  - [HeroSetSensorManager.mc:6](file:///Users/mbp/dev/garmin/HeroSet/source/sensor/HeroSetSensorManager.mc): `_enabled`
  - At `-l 3` these produce 33 errors in HeroSetStore and 8 in HeroSetApp: "Cannot determine type for method invocation" / "Passing 'Any'" at HeroSetStore.mc lines 52, 53, 55, 124, 125, 132, 162, 176, 188, 189, 194, 196.
  - **Fix:** `private var _storage as HeroSetStorage;` `private var _clock as HeroSetClock;` `private var _writeFailed as Lang.Boolean = false;` `private var _store as HeroSetStore;` `private var _sync as HeroSetSyncCoordinator;` `private var _enabled as Lang.Boolean = false;`
- **Med (a)(b) The storage seam accepts `Lang.Object`, so Symbol values compile.** [HeroSetStorage.mc:15](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStorage.mc) and [HeroSetPersistentStorage.mc:18-19](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetPersistentStorage.mc) type `value as Lang.Object`.
  - `-l 3` flags PersistentStorage:19 as "Passing Lang.Object as parameter 2 of poly type … Storage.ValueType".
  - ADR-022's device-only crash (`Storage.setValue` throws on Symbol keys/values) is exactly what a `ValueType`-typed seam would reject at compile time. Today the only guard is the runtime test `learningDictionaryUsesStringKeysNotSymbols` ([HeroSetStoreTest.mc:320](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetStoreTest.mc)).
  - **Fix:** type `getValue`/`setValue` (and `HeroSetStore._set`) with `Application.Storage.ValueType`. That is a compile-time typedef with no API-level cost, but confirm it resolves for 3.4 products by building fenix6.
- **Low (b) Untyped parameter** at [HeroSetRules.mc:96](file:///Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetRules.mc): `nextStreak(lastDay, …)`. `activeStreak` on line 112 already uses `lastDay as Lang.Number?`.
  - **Fix:** `lastDay as Lang.Number?`.
- **Low (b) Untyped callback parameter** at [HeroSetSensorManager.mc:11](file:///Users/mbp/dev/garmin/HeroSet/source/sensor/HeroSetSensorManager.mc): `start(callback, …)`.
  - **Fix:** `callback as Method(data as Sensor.SensorData) as Void`. This is a type annotation only and does not change the `method(:onSensorData)` binding ADR-023 requires. Re-verify on the FR965 anyway, since this is the device-only-failure path.
- **Low (b) Function over the ~30-line budget.** [HeroSetMenuDelegate.mc:18-52](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetMenuDelegate.mc) `prepare()` is 35 lines (counted by hand). No other function in app/, domain/, data/ or sensor/ exceeds 30.
  - **Fix:** extract `stampSync(menu, store)` / `stampGoal(menu, goal)` / `stampProgress(menu, store, goal)`.
- **Low (b) Files over 250 lines.** [HeroSetStore.mc](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc) is 330 lines, which is listed debt (architecture §8, ADR-020). [HeroSetStoreTest.mc](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetStoreTest.mc) is 377 lines and is **not** listed in §8.
  - **Fix:** split the test into goal/XP, streak/day and learning/log files, or list it in §8.
- **Low (b)(a) The catch-all in `_set` changes the meaning of the flag.** [HeroSetStore.mc:267-274](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc) has `catch (ex)` around every write, and on success it does `_writeFailed = false`.
  - The flag therefore means "the *last* write failed", not "something failed to save". Within one save the store writes the count, then credit, then XP, and the picker then writes the validation log and learning state ([ManualPickerView saveEntry](file:///Users/mbp/dev/garmin/HeroSet/source/ui/manual/HeroSetManualPickerView.mc)). One later successful write clears the `! COULD NOT SAVE` footer of ADR-010 even though the count write failed.
  - The catch-all also turns an ADR-022-class `UnexpectedTypeException` (a programming bug) into a silent "could not save".
  - ADR-010 says the catch is for `StorageFullException`.
  - **Fix:** make the flag sticky (only ever set to true; clear it at the next day reset or on the next fully successful `add`). Narrow the catch to `ex instanceof Storage.StorageFullException`, or keep the broad catch but at least `System.println` the error.
  - Practical impact: if flash is truly full, every write fails, so this bites mainly on partial failures. Uncertain how often.
- **Low (a) Non-atomic XP award.** [HeroSetStore.mc:105-106](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc) writes the credit ratchet *before* XP. If the XP write fails, the ratchet already says "paid", so that day's XP for those reps is lost for good.
  - Accepting this is defensible, because the reverse order would re-pay on retry (ADR-002). Note it in the `_set` comment and do not reorder.
- **Low (b) Sensor start failure is swallowed silently.**
  - [HeroSetSensorManager.mc:24-27](file:///Users/mbp/dev/garmin/HeroSet/source/sensor/HeroSetSensorManager.mc) catches everything, prints, and returns false.
  - The only caller, [HeroSetWorkoutView.mc:50](file:///Users/mbp/dev/garmin/HeroSet/source/ui/workout/HeroSetWorkoutView.mc), ignores the Boolean, so the user gets a workout screen that stays at 0 with no signal.
  - That violates "degrade + flag, never swallow silently".
  - **Fix:** keep the result in the view and show a one-line "NO SENSOR" hint (UI reviewer's area), or at least `logDiagnostic` it.
- **Low (b) Magic numbers in non-UI code.** These are unit conversions, which I judge acceptable:
  - `/ 1000` ms→s at [HeroSetRepCounter.mc:42](file:///Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetRepCounter.mc)
  - `* 100 / cost` percent at [HeroSetComplicationPublisher.mc:37](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetComplicationPublisher.mc)
  - `/ 100` in [HeroSetThresholdLearner.mc:64,67](file:///Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetThresholdLearner.mc)
  - `% 10000` at [HeroSetStore.mc:231](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)
  - The `EXERCISE_BYTES = 32` and FIT field ids in ActivitySync are named private consts.
  - No fix needed. Every tunable is in `HeroSetConfig`, and every `HeroSetConfig` constant has at least one user (I grepped all 28).
- **Low (b) Unchecked narrowing** at [HeroSetStore.mc:54](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc): `savedDay != today` compares a raw `Object` from Storage. Every other read narrows through `asNumberOrNull` (ADR-019). If the stored day ever came back as a Float or Long (it never does today, because it is written as a Number), the comparison could mismatch and wipe today's counts on every read.
  - **Fix:** `var savedDay = asNumberOrNull(_storage.getValue(DAY_KEY)); if (savedDay != today)`. Low probability, one-token fix.
- **Low (c) Code order and comment drift inside HeroSetStore.**
  - [HeroSetStore.mc:153-156](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc) is an empty "Garmin Connect sync" section header.
  - `isSyncEnabled/setSyncEnabled` (lines 175-181) sit under the "Daily goal" header.
  - The retired-`hero_sync_day` comment (lines 29-30) sits directly above `VALIDATION_LOG_KEY`, so it reads as if that key were retired.
  - **Fix:** move the sync methods under their header and give the retired-key note a blank line or a `// (retired, no const)` marker.
- **Low (a) Redundant work at startup.**
  - `HeroSetStore.initialize` ([HeroSetStore.mc:43-44](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)) rewrites `hero_schema` on every construction (one flash write per launch) and calls `ensureCurrentDay()`.
  - `HeroSetApp.onStart` ([HeroSetApp.mc:17](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetApp.mc)) calls `ensureCurrentDay()` again.
  - **Fix:** write the schema only if the stored value differs.
- **Low (a) Storage read volume per save** (static count; device cost unmeasured).
  - `getCount` calls `ensureCurrentDay()` every time ([HeroSetStore.mc:72-75](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)). `getDashboardState` does about 12 `getValue` calls.
  - `HeroSetSaveFeedback.save` calls `getCount` and `isDailyMissionComplete` (3 counts + goal) before and after `add`, and `getRank` 3 times. `add` itself runs `updateCompletion → isDailyMissionComplete`. Then `publish` calls `getDashboardState`.
  - Roughly 55-60 `Storage.getValue` calls and about 8 writes in one input callback, before learning.
  - This is the callback that tripped the watchdog in ADR-046. The replay was the measured cause (173 of 181 ms), so this is a watch item, not a defect.
  - **Fix if a device profile ever shows it:** one `ensureCurrentDay()` per public entry point, plus a snapshot passed to `tierFor`.
- **Low (a) The complication comment points to a file that doesn't exist.** [HeroSetComplicationPublisher.mc:13](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetComplicationPublisher.mc) says "resources/complications.xml". The real file is `resources-complications/complications.xml`.

### Inferences
- Typing the five members plus the storage seam is the highest-value item in this section: about 8 lines, no behaviour change. It moves the store from unchecked `Any` dispatch to compiler-checked calls. The project has repeatedly been bitten by type problems that only show on the device (ADR-019, ADR-022).
- The project builds at the default typecheck level. Going to `-l 2`/`-l 3` project-wide is not realistic now (197 errors, about 160 of them in UI). Typing the members listed above is the part that matters for the core layers.

### Gaps
- I did not measure `Storage.getValue` cost on the device. The SDK docs don't say whether reads are cached in RAM.

---

## 3. API calls newer than 3.4 without `has` guards; (:sync)/(:debug) leakage into the store build

### Takeaway
There are no unguarded calls above 3.4 in the core layers. The calls ADR-038's symbol audit could not have covered (they were added later) are all ≤ 3.4 in the SDK docs. The annotation split is sound: the store build and store test build compile, and only `:sync`/`:debug` code references the sync internals and test hooks.

### Cited Findings
- **Guarded:**
  - `Toybox has :Complications`: [HeroSetComplicationPublisher.mc:20](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetComplicationPublisher.mc). `updateComplication` is "Since: API Level 4.2.0" (SDK `doc/Toybox/Complications.html`).
  - `Toybox has :ActivityRecording`: [HeroSetSyncCoordinator.mc:44](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetSyncCoordinator.mc).
  - `Sensor has :registerSensorDataListener` / `:unregisterSensorDataListener`: [HeroSetSensorManager.mc:12,32](file:///Users/mbp/dev/garmin/HeroSet/source/sensor/HeroSetSensorManager.mc).
- **API levels of calls added since ADR-038, from the SDK 9.2.0 doc HTML:**

  | Call | Where | Since |
  |---|---|---|
  | `Math.round` | learner, ADR-046 | 1.0.0 |
  | `Float.abs` | SwingTrace | 1.0.0 |
  | `Array.slice` | SwingTrace, Store | 1.0.0 |
  | `Array.indexOf` | SyncCoordinator | 1.3.0 |
  | `Array.addAll` | SyncCoordinator log | 1.3.0 |
  | `KeyEvent.getKey` | HeroSetInput, ADR-048 | 1.0.0 |
  | `DeviceSettings.inputButtons` | HeroSetInput | 1.2.0 |
  | `System.BUTTON_INPUT_UP` | HeroSetInput | 1.0.0 |
  | `WatchUi.showToast` | save feedback, the reason min is 3.4 | 3.4.0 |

  Per ADR-038, a clean `monkeyc` build proves nothing per device. The evidence is these doc levels plus ADR-048's simulator runs (store tests on fr965 and venu441mm, and "fenix6 … touchFirst=false"). My own builds of `-d fenix6 -f store.jungle` and `-d venu441mm -f store.jungle` succeeded, but that is not evidence of runtime availability.
- **Annotation split is sound:**
  - [monkey.jungle:3](file:///Users/mbp/dev/garmin/HeroSet/monkey.jungle) `excludeAnnotations = nosync`.
  - [store.jungle](file:///Users/mbp/dev/garmin/HeroSet/store.jungle) `excludeAnnotations = sync;debug`, `manifest-store.xml`, `resources;resources-store`.
  - The manifests differ only by `Fit` and `FitContributor` (`diff manifest.xml manifest-store.xml` → lines 105-106), so the app id is the same.
  - `HeroSetActivitySync` is referenced only from `(:sync)` code: `HeroSetSyncCoordinator.mc`, and `HeroSetSyncTest.mc`, which is `(:test :sync …)`.
  - The `(:debug)` hooks `HeroSetApp.swapStoreForTest` ([HeroSetApp.mc:41](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetApp.mc)), `HeroSetSyncCoordinator.useActivityForTest` ([HeroSetSyncCoordinator.mc:33](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetSyncCoordinator.mc)) and `HeroSetWorkoutView.setCountsForTest` are referenced only by `(:test :debug)` tests.
  - `monkeyc -t -d fr965 -f store.jungle` → BUILD SUCCESSFUL.
- **The `(:nosync)` twin matches the interface.** [HeroSetSyncCoordinatorOff.mc](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetSyncCoordinatorOff.mc) has the same six public methods as the dev class except `useActivityForTest`, which is `(:debug)`-only and unused by the store build.
- **Known, intentional:** the validation log records in the store build (architecture §8). `store.logValidationTrial` is called unconditionally in `HeroSetManualPickerView.saveEntry`.

### Inferences
- The store build cannot leak Fit or sync code. The `:debug` exclusion in `store.jungle` also keeps test hooks out of a non-`-r` store export (ADR-034).

### Gaps
- `api.debug.xml` per-device symbol tables were not found under the Devices folder at the path I tried, so there was no per-device symbol check this time. The claims above rest on the doc "Since" levels and ADR-048's recorded simulator runs.

---

## 4. Is the complication contract (ADR-044, HeroSetComplicationPublisher) robust, and does it match what ../heroFace reads?

### Takeaway
The value format matches HeroFace's parser field for field, and both sides pin it with string-literal tests. The jungle complication resource paths are consistent for all 80 products against the SDK's CIQ versions.

Three risks remain:
1. `updateComplication` is called with no catch, although it has a documented throw. It runs on every launch.
2. HeroFace actually binds by `longLabel == "HeroSet"`, not by id 0. That makes a translatable string resource a hidden cross-app contract key, and ADR-044 describes the binding wrongly.
3. HeroFace rejects the *whole* value if any field is negative. That invariant is not documented on the HeroSet side.

### Cited Findings
- **Format matches.**
  - HeroSet emits `1|day|push|sit|squat|rank|pct|streak|lastDone|goal` ([HeroSetComplicationPublisher.mc:35-55](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetComplicationPublisher.mc)).
  - HeroFace requires 9 fields and reads an optional 10th as the goal, falling back to 100 when it is missing or 0 ([heroFace/source/HeroFaceContract.mc:19-39,53-70](file:///Users/mbp/dev/garmin/heroFace/source/HeroFaceContract.mc)).
  - Both sides use version 1 ([HeroFaceConfig.mc:36](file:///Users/mbp/dev/garmin/heroFace/source/HeroFaceConfig.mc)).
  - Tests: [HeroSetComplicationTest.mc](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetComplicationTest.mc) asserts `"1|20260920|37|52|100|4|0|12|20260919|100"`. [heroFace/source/test/HeroFaceLogicTest.mc:35-55](file:///Users/mbp/dev/garmin/heroFace/source/test/HeroFaceLogicTest.mc) parses the 9- and 10-field forms.
- **Med (a) Uncaught documented exception on every launch.**
  - SDK doc: `updateComplication` "Throws: (Lang.OperationNotAllowedException) — Thrown if the id of the complication is not associated with this application".
  - It is called with no catch from `HeroSetApp.onStart` ([HeroSetApp.mc:18](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetApp.mc)), every save ([HeroSetSaveFeedback.mc:19](file:///Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetSaveFeedback.mc)), goal save ([HeroSetGoalPickerView.mc:50](file:///Users/mbp/dev/garmin/HeroSet/source/ui/settings/HeroSetGoalPickerView.mc)) and midnight ([HeroSetDayTracker.mc:34](file:///Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetDayTracker.mc)).
  - The guard is `Toybox has :Complications`, which is a firmware capability, while the resource is per product in the jungles. If those ever disagree, HeroSet crashes at launch on that product. Examples: a 3.4-profile product whose real firmware exposes Complications, or a future product added to the manifest but not to the jungle lines.
  - Today they agree. I checked all 80 manifest products against `Devices/<id>/compiler.json` max `connectIQVersion`: every ≥4.2 product has the `resources-complications` line in both jungles, and every <4.2 product has it in neither ("80 consistent").
  - **Fix:** `try { … } catch (e instanceof Lang.OperationNotAllowedException) { }` with a why-comment. This is a documented throw, so it fits "catch only what can throw". Alternatively, add a jungle/manifest consistency test to the release checklist.
- **Low (e)(c) The real binding key is the label string, not id 0.**
  - HeroFace finds HeroSet's complication by iterating `Complications.getComplications()` and matching `HEROSET_COMPLICATION_LABEL.equals(complication.longLabel)` ([heroFace/source/HeroFaceLink.mc:82-92](file:///Users/mbp/dev/garmin/heroFace/source/HeroFaceLink.mc), [HeroFaceConfig.mc:38](file:///Users/mbp/dev/garmin/heroFace/source/HeroFaceConfig.mc) `"HeroSet"`). It keeps `complicationId` only in memory.
  - HeroSet's label is `longLabel="@Strings.complication_label"` ([resources-complications/complications.xml:9](file:///Users/mbp/dev/garmin/HeroSet/resources-complications/complications.xml)). That comes from `resources/strings/strings.xml:80` `<string id="complication_label">HeroSet</string>`, which has no `translatable` attribute.
  - It is not translated in any `resources-<lang>` today (grep), so it works. But a translator pass that adds it would silently unlink HeroFace in that language.
  - ADR-044 says "Complication id `0` is stored by subscribers and never changes", which does not describe HeroFace's code.
  - **Fix:** add `translatable="false"` (the attribute exists in SDK `bin/resources.xsd:52`) and a comment naming HeroFace. Amend ADR-044, which lives in HeroSet/docs/decisions.md, to say the contract key is `longLabel == "HeroSet"`. Per the cross-folder rule, touch both folders in the same commit.
- **Low (a) The non-negative invariant is implicit.** HeroFace's `numbers()` returns null (drops the whole value) if any field is `< 0` ([HeroFaceContract.mc:60](file:///Users/mbp/dev/garmin/heroFace/source/HeroFaceContract.mc)).
  - HeroSet's fields are non-negative today: counts are floored at 0 ([HeroSetStore.mc:82-84](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)), XP is clamped in `xpIntoRank`, rank ≥ 1, `lastCompletionDay` null→0, goal ≥ 10.
  - **Fix:** one line in the `valueFor` comment ("every field is a non-negative integer; HeroFace drops the value otherwise").
- **Low (a), uncertain. Duplicate "HeroSet" complications.** If a sideloaded build under the *old* app id is still installed (ADR-033: "Dev build sideloaded under old id is separate app on watch"), its complication carries the same label. HeroFace would bind to whichever `getComplications()` returns first.
  - The current `manifest.xml` and `manifest-store.xml` share one id, so a current dev sideload replaces the store app rather than duplicating it. This only matters for a leftover old-id install on the developer's own watch.
- **Publish coverage matches ADR-044:** app start, every save through `HeroSetSaveFeedback`, goal change (`HeroSetGoalPickerView.mc:47-50`) and the dashboard midnight timer. The midnight path is still unverified on the device (ADR-044).
- **Minor (a):** `valueFor` builds the dashboard state from the store's injected `_clock`, but `publish` passes `HeroSetCalendar.todayKey()` for the day field ([HeroSetComplicationPublisher.mc:24](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetComplicationPublisher.mc)). In production both are the real clock, so the only effect is test inconsistency. No fix needed unless `publish` itself gets tested.

### Inferences
- The contract is robust in format. What it lacks is the robustness to missing preconditions (the uncaught throw, an undocumented binding key), which is exactly the device-only class ADR-022 warns about.

### Gaps
- Whether any 3.4-profile product's current firmware exposes `Toybox.Complications` could not be checked without the devices.

---

## 5. Dead code, duplicated logic, single-user abstractions

### Takeaway
There is very little dead code. Every `HeroSetConfig` constant and every public method in scope has a caller. The seams (`HeroSetStorage`, `HeroSetClock`) have two implementations each (production and test), so they earn their keep. The duplication is four small exercise→string mappings and the parallel menu-id/exercise arrays. That is acceptable at three exercises. Do not abstract it.

### Cited Findings
- **Every `HeroSetConfig` constant has at least one user** (grepped all 28, e.g. `SENSOR_PERIOD_SECONDS` → `HeroSetSensorManager.mc:17`, `REP_VIBE_DUTY_CYCLE` → `HeroSetHaptics.mc`).
- **Public methods whose only non-test user is their own class:**
  - `HeroSetThresholdLearner.medianBin` ([HeroSetThresholdLearner.mc:100](file:///Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetThresholdLearner.mc)): used by `threshold()` and `HeroSetThresholdLearnerTest.mc:49`.
  - `thresholdAt`: used by the learner and `HeroSetRepCounterTest.mc:60`.
  - `HeroSetSyncCoordinator.lapReps` is `static` public but only used inside the class.
  - None of these is dead. `lapReps` could be `private`.
- **Low (c) Four hand-written exercise→X switches:**
  - `exerciseKeyString` ([HeroSetStore.mc:303-314](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc))
  - `validationLogLine` labels "PU/SU/SQ" (line 228; falls back to SQ for anything unknown, unlike `exerciseKeyString`, which throws)
  - `fitLabel` ([HeroSetSyncCoordinator.mc:113-121](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetSyncCoordinator.mc), falls back to squats)
  - `HeroSetText.exerciseLabel` (UI)
  - Menu ids are parallel to `HeroSetRules.EXERCISES` by index at [HeroSetMenuDelegate.mc:32-41](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetMenuDelegate.mc), and `onSelect` maps ids by hand (lines 63-74).
  - Recommendation: leave these alone until a fourth exercise exists. At that point an index into `EXERCISES` plus parallel const arrays is the cheapest fix.
- **Low (c) Doc/code duplication:** `HeroSetStore.getLastCompletionDay()` (line 131) and the inline reads at lines 124 and 189 all do `asNumberOrNull(_storage.getValue(LAST_COMPLETION_KEY))`. Reuse `getLastCompletionDay()` in `getStreak`/`updateCompletion`. That is a 2-line cleanup.
- **No over-engineering found in the core.** `HeroSetClock` is a 12-line seam used by 25+ store tests. `HeroSetStorage` is the base seam with two implementations. The `HeroSetThresholdLearner` grid is already marked `ponytail:` with its ceiling (line 18). ActivitySync/SyncCoordinator are deliberately kept (ADR-036 audit).

### Inferences
- A ponytail-style audit of these layers turns up almost nothing to delete. The churn risk is higher than the gain.

### Gaps
- None.

---

## 6. Which non-trivial logic lacks a test?

### Takeaway
The domain is very well covered: rules 23 tests, calendar 12, detector 8, learner 7 with timing bounds, store 24, sync 7, complication 3. The untested non-trivial paths:
- the ADR-010 write-failure flag
- the validation-log line format
- the complication publish guard

The test count in the docs has probably drifted by one.

### Cited Findings
- **Med (d) ADR-010 write failure is untested.** No test injects a throwing storage. grep for `WriteFailure|hasWriteFailure` in `source/test` finds none. The last-write-wins semantics in §2 would have shown up in such a test.
  - **Fix:** add a `HeroSetFailingStorage extends HeroSetStorage` whose `setValue` throws after N writes. Assert that `hasWriteFailure()` stays true through the rest of an `add`.
- **Low (d) Validation line format untested.** `diagnosticLinesShareTheCappedLogInOrder` ([HeroSetStoreTest.mc:365-377](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetStoreTest.mc)) writes one `logValidationTrial` and then pushes it out of the 30-entry ring. The `"mmdd PU det->saved +err"` format (`HeroSetStore.mc:227-233`), which `validation-log.md` transcription depends on, is never asserted.
  - **Fix:** assert `log[0] == "911 PU 10->12 +2"` before filling the ring. Note that `20260911 % 10000` = `911`, not `0911`, because the month has no zero padding. That is probably unintended ("mmdd"), so decide and pin it.
- **Low (d) `HeroSetComplicationPublisher.publish` itself is untested.** Only the pure `valueFor` is tested. It cannot be tested meaningfully in the simulator without the resource. The try/catch in §4 is the mitigation.
- **Low (d) `HeroSetSensorManager` has no test.** It is thin, and registration is device behaviour (ADR-023), so this is acceptable.
- **Covered well (good, keep):**
  - XP ratchet/farming (`farmLoopCannotInflateXp`, `xpStillCapsAtTheFixedRepCapWithAHighGoal`)
  - day rollover, DST and leap/month/year
  - schema read-back
  - Symbol-key guard (`learningDictionaryUsesStringKeysNotSymbols`)
  - learner timing bound (`longestLearnableSetFinishes`, ADR-046)
  - trace-vs-detector equivalence (`traceReplayCountsWhatTheDetectorCounted`, [HeroSetRepCounterTest.mc:53](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetRepCounterTest.mc))
  - sync lap/save/discard sequences against a fake recording
  - menu prepare for both builds (`HeroSetMenuTest`)
  - the ADR-048 onSelect guard (`HeroSetInputTest`)
- **Low (e), likely drift in the test count.**
  - My count of `(:test)`-annotated `function`s in HEAD is 94, which matches the docs. The working tree adds one (staged new file `HeroSetInputTest.mc`, `commitScreensIgnoreTheSelectBehavior`). `git diff --cached --stat` shows no test removed.
  - So the tree probably has **95 dev / 86 store** tests, while `CLAUDE.md` still says "Tests (94; 85 in store build)". ADR-048's evidence also says "94/94".
  - **Verify with the runner's `PASSED (…)` line before editing the four docs.** A grep count is not the runner's count.

### Inferences
- The missing write-failure test matters most, because that path protects the one user-visible storage error message.

### Gaps
- I could not run the suite (the simulator is in use), so all coverage statements are static.

---

## 7. Doc drift: architecture.md and the ADRs vs the code (and correctness of the risk items above)

### Takeaway
architecture.md has drifted from the code in five places since ADR-048/049:
- §2 file tree
- §3 layer claims
- §7 navigation
- §9 "out of scope"
- the ADR-010 wording

The ADRs have three stale references (ADR-020, ADR-022, ADR-044).

### Cited Findings
- **Med (e)** [architecture.md §9](file:///Users/mbp/dev/garmin/HeroSet/docs/architecture.md) lists "Touch-first interaction" as out of scope. §1/Target, ADR-048 and `HeroSetInput.mc` ship it.
  - **Fix:** delete the item.
- **Low (e) Architecture §2 file tree** omits `ui/HeroSetInput.mc` (ADR-048) and the whole `ui/settings/` folder (`HeroSetGoalPickerView`, `HeroSetGoalPickerDelegate`, ADR-045). It also places `HeroSetDashboardState` in `ui/dashboard/` (see §1 for the move).
- **Low (e) Architecture §7 navigation** lacks Main Menu → Daily Goal → goal picker (depth 1, `HeroSetMenuDelegate.mc:106-110`). It also still describes the picker only as "Up/Down" (touch: swipe, ADR-048).
- **Low (e) Architecture §3** says Sensor classes "take plain args, return plain values" and that Data sits below Presentation. Both are contradicted by the two upward edges in §1.
- **Low (e) ADR-010** says "wrapped in try/catch (`StorageFullException`)". The code catches everything ([HeroSetStore.mc:271](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)).
- **Low (e) ADR-022 item 1** names the guard test `calibrationDictionaryUsesStringKeysNotSymbols` and the "calibration dictionary". The test is now `learningDictionaryUsesStringKeysNotSymbols` ([HeroSetStoreTest.mc:320-321](file:///Users/mbp/dev/garmin/HeroSet/source/test/HeroSetStoreTest.mc)) and the dictionary is `hero_learning`.
- **Low (e) ADR-020** says "472 lines (2026-09-17) … Natural splits: schema migration, calibration profiles, diagnostics log". The file is now 330 lines (architecture §8 is correct). Migration and calibration are gone (ADR-036/040). The remaining natural splits are the **diagnostics log** (lines 199-233) and the **learning state** (lines 235-257), about 60 lines, which would bring the store under 280.
- **Low (e) ADR-044** "id 0 is stored by subscribers" vs HeroFace's label lookup (§4).
- **Low (e)** `HeroSetComplicationPublisher.mc:13` names the wrong resource path (§2).
- **No drift** in architecture §4 (store invariants, learner and trace descriptions), §5 data flow, or §8 debt rows (checked against the code).

### What is already good and should NOT be changed (do-not-churn list)
- **Storage isolation and seams:** only `HeroSetPersistentStorage` touches Storage. `HeroSetStorage`/`HeroSetClock` injection makes 24 store tests run the real code.
- **Flat, fixed key spellings, and Symbols kept out of Storage:** `exerciseKeyString` throws on unknown exercises ([HeroSetStore.mc:303-321](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)). `hero_learning` is keyed by strings with a `model` field, and malformed state reads as fresh ([HeroSetStore.mc:239-257](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)).
- **Numeric narrowing** through `asNumber`/`asNumberOrNull` (ADR-019), apart from the one `ensureCurrentDay` comparison.
- **XP ratchet capped at a fixed 100 reps**, not the goal ([HeroSetStore.mc:94-107](file:///Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)). Keep the credit-before-XP order.
- **Calendar-day keys with no epoch math** ([HeroSetCalendar.mc](file:///Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetCalendar.mc)), and the closed-form rank curve with bounded loops ([HeroSetRules.mc:18-62](file:///Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetRules.mc)).
- **Streamed swing trace** (ADR-046): O(bins) per turning point with early exit, O(bins) read, copy-on-read for the open point ([HeroSetSwingTrace.mc](file:///Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetSwingTrace.mc)). **Memoised integer threshold grid** ([HeroSetThresholdLearner.mc:36-49](file:///Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetThresholdLearner.mc)). Do not "simplify" either back to a replay.
- **The learner's log-weight belief with a mistake floor and forgetting**, and its `ponytail:` ceiling note.
- **Sync coordinator/twin design:** the `(:sync)`/`(:nosync)` same-name classes mean callers never branch. `stop()` always saves or discards. A refused save is discarded ([HeroSetActivitySync.mc:92-108](file:///Users/mbp/dev/garmin/HeroSet/source/sensor/HeroSetActivitySync.mc)).
- **Build config:** the jungle complication paths are consistent for 80/80 products against the SDK CIQ versions. `store.jungle` excludes `sync;debug`. The manifests differ only by the two Fit permissions and keep the same app id.
- **`method(:onSensorData)` on a public method** (ADR-023) and the untyped accelerometer arrays with `instanceof Array` guards (ADR-022), in `HeroSetWorkoutView.mc:160-187`.
- **The complication's version-1 append-only policy** (goal appended without a version bump, ADR-045).

### Inferences
- Priority order for a fixer:
  1. try/catch `OperationNotAllowedException` around `updateComplication` (§4)
  2. type the store/app/sensor members and the storage seam (§2)
  3. sticky write-failure flag plus its test (§2, §6)
  4. move `HeroSetDashboardState` out of `ui/` and de-UI `HeroSetActivitySync` (§1)
  5. `translatable="false"` on `complication_label` plus the ADR-044 amendment (§4)
  6. doc fixes (§7)
- Items 1-3 are each under about 15 lines.

### Gaps
- None of this was validated on a device or in the simulator. Per the house rule, simulator passing would not be device proof anyway.
