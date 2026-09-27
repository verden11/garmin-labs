# HeroSet glance view: codebase fit and engineering impact

Status 2026-09-26. Repo state read: `main`, HeroSet 1.1.1 live. Scope: what adding `AppBase.getGlanceView()` plus a `(:glance)` view to `/Users/mbp/dev/garmin/HeroSet` touches. Nothing in the repo was modified. All prototype work is in the scratchpad (`/private/tmp/claude-501/-Users-mbp-dev-garmin/654433ae-5c12-478a-8ef0-9fd1aa89616a/scratchpad/`, dirs `proto` lean glance, `proto2` fit tests, `proto3` whole-app-as-glance, `proto4` locale-scope probe; scripts `build.sh`, `scope.sh`, `ablate.py`, `all80.sh`, `glancefit.sh`; outputs `all80.txt`, `glancefit.txt`).

Source convention in this file: repo `path:line` links and SDK doc paths under `~/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/` (abbreviated `SDK/`). "Measured" means I ran it in the SDK 9.2.0 compiler or simulator; those results are reproduced verbatim where the task asked.

## Premises in the brief that the repo contradicts (read first)

### Takeaway
Three premises are stale or wrong: "next upload is 1.1.1" (1.1.1 is already live), "glance on 80 products" (63), and "memory limit 32 KB" (64 KB on every product that gets a glance). Two more things were not in the brief and matter more than the code: an inactivity-timeout risk for an app launched from a glance, and a default build that silently hides glance-scope errors.

### Cited Findings
- 1.1.1 is live (released 2026-09-24 15:32 UTC); the store listing is at 1.1.1 and the listing file says "next upload is 1.2.0 (Connect sync)". ADR-050's "next upload is 1.1.1" is history. — [go-to-market.md:9](/Users/mbp/dev/garmin/HeroSet/docs/go-to-market.md), [listing/README.md:3](/Users/mbp/dev/garmin/HeroSet/listing/README.md), [CHANGELOG.md:7](/Users/mbp/dev/garmin/HeroSet/CHANGELOG.md), [decisions.md ADR-050](/Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
- `go-to-market.md` line 5 says "Feature work waits unless it unblocks a fix." A glance is a feature, so shipping it needs an explicit owner call. — [go-to-market.md:5](/Users/mbp/dev/garmin/HeroSet/docs/go-to-market.md)
- Watch-app glances need API level 4.0; on 3.1 products only widgets had glances. — `SDK/doc/docs/User_Experience_Guidelines/Entry_Points.html` ("On API level 3.1 products, widgets were the only app type to support glances. In API level 4.0, device apps were given the ability to support glances, as well."); `SDK/doc/docs/Readme/History.html` v4.0.0 "Add support for glances in watch-app types."
- Compiler output for the 17 CIQ 3.4.x products, verbatim (fenix6 build of the lean prototype): `WARNING: fenix6: source/app/HeroSetApp.mc:59: Glance applications are not supported for app type 'watch-app' on device 'fenix6' with minimum API Level 3.4.5. The (:glance) annotation will be ignored.` (one such warning per tagged declaration, 18 warnings per product, all still `BUILD SUCCESSFUL`). — measured, `proto`, `build.sh f6 store.jungle fenix6`
- Sweep of all 80 manifest products with the lean prototype, store jungle: 80/80 `BUILD SUCCESSFUL`; 63 report a glance section (`Glance` data 2419 + code 4437 bytes each); the 17 without are `fenix6 fenix6s fenix6pro fenix6spro fenix6xpro marqadventurer marqathlete marqaviator marqcaptain marqcommander marqdriver marqexpedition marqgolfer descentmk2 descentmk2s fr945lte enduro`. — measured, `scratchpad/all80.txt`
- Memory limit per glance, from each product's `compiler.json` `appTypes`: **65536 bytes on all 63 CIQ 4.0+ products, 32768 on the 17 CIQ 3.4 products** (where the glance is ignored). The SDK prose says "32KB for most devices"; the per-device files contradict that for every product that actually gets a glance. — `~/Library/Application Support/Garmin/ConnectIQ/Devices/<product>/compiler.json`; prose in `SDK/doc/docs/Core_Topics/Glances.html`
- All 63 supported products have `glance.liveUpdates: true` in `simulator.json`; the 11 with `false` (fenix6, fenix6s, 8 MARQ Gen 1, Enduro) are all in the unsupported 17. — `~/Library/Application Support/Garmin/ConnectIQ/Devices/<product>/simulator.json`
- Glance content areas across the 80 products range from 140x79 (fr255s, fr255sm) and 151x63 (fenix 7S/6S family) up to 359x130 (fenix9pro51mm) and 303x164 (venu3); the system draws the launcher icon separately (`iconArea`) and hands the app only `contentArea`. — `simulator.json` `glance.contentArea`/`iconArea`, tabulated by me across `manifest.xml` products
- Only the glance is scope-checked at `-l 2`/`-l 3`; the project's normal build (no `-l`) prints nothing about glance-scope violations (see "Build and lint" below).

### Inferences
- The realistic delivery is "glance on 63 of 80 products". Every claim in docs and listing has to say so; a blanket "glance" claim is a forbidden-claim risk.
- Because `getGlanceView` on the 17 legacy products is compiled but ignored, no product is broken, but their build output gains 18 warning lines each.

### Gaps
- Whether a CIQ 3.4 device firmware ignores `getGlanceView` for a watch-app (rather than mishandling it) is inferred from the compiler dropping the annotation; no such device is owned and the simulator does not distinguish.

---

## 1. What a glance needs, and how much of it is `(:glance)`-sized

### Takeaway
A glance needs only: three counts (gated on the stored day), the goal, the streak-alive value, `missionComplete`, palette, and text drawn through `HeroSetDraw.text`. All of it is tiny; the measured `(:glance)` closure is **6,856 bytes on FR965 (store build; 6,905 in the dev build)** of a 65,536 byte limit, but `HeroSetStore` itself cannot be tagged without dragging in the learner and writing Storage.

### Cited Findings
- Store surface for the glance's data: `getGoal` (pure read), `getStreak` (pure read), `getXp` (pure read), `getLastCompletionDay` (pure read), but `getCount`, `getDashboardState` and `isDailyMissionComplete` all call `ensureCurrentDay()` and therefore can write. — [HeroSetStore.mc:76-79](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc), [:118-138](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc), [:140-156](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc), [:166-171](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)
- Store key constants are *instance* consts (`const DAY_KEY = "hero_day"` etc.), not static, so a static reader cannot reference them without an instance. — [HeroSetStore.mc:12-33](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc); tests use them as `store.GOAL_KEY` — [HeroSetStoreTest.mc:74](/Users/mbp/dev/garmin/HeroSet/source/test/HeroSetStoreTest.mc)
- Rules the glance reuses: `missionComplete` (`HeroSetRules.mc:81-83`), `activeStreak` (`:112-120`), `clampGoal` (`:87-94`), which pull in `HeroSetCalendar.isConsecutiveDate` (`HeroSetCalendar.mc:24-43`) and `HeroSetConfig` (goal constants). `crossedGoal` (`:77-79`) is a feedback-on-save rule, not needed. — [HeroSetRules.mc](/Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetRules.mc), [HeroSetCalendar.mc](/Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetCalendar.mc), [HeroSetConfig.mc:5-9](/Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetConfig.mc)
- `HeroSetClock` (`data/HeroSetClock.mc:5-12`) is only a test seam over `HeroSetCalendar.todayKey()`; a static reader takes `today` as a parameter instead, so `HeroSetClock` need not be in the glance.
- Text must go through `HeroSetDraw.text` (ADR-034; [CLAUDE.md house rules](/Users/mbp/dev/garmin/HeroSet/CLAUDE.md)); its `layout` argument is only used inside the test-only `fitsDisplay` chord check. — [HeroSetDraw.mc:19-33](/Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc), [:42-47](/Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc)
- **Measured marginal glance cost per class** (lean prototype, FR965, store jungle, full closure = data 2464 + code 4437 = 6,901 B at that stage; "saves" = bytes removed when that one class loses `(:glance)`), from `ablate.py`:

  | Class | Glance bytes it costs |
  |---|---|
  | HeroSetDraw | 1,225 |
  | HeroSetLayout | 1,076 |
  | HeroSetRules (whole class; unused rank/XP functions ride along) | 813 |
  | HeroSetGlanceView | 619 |
  | HeroSetGlanceReader | 535 |
  | HeroSetCalendar | 400 |
  | HeroSetDashboardState | 191 |
  | HeroSetPersistentStorage | 126 |
  | HeroSetStorage | 69 |
  | HeroSetConfig | 44 |
  | HeroSetPalette | 44 |

  Verbatim script output: `full closure: data 2464 code 4437 total 6901` … `without HeroSetDraw data 2245 code 3431 total 5676 (saves 1225)`, `without HeroSetLayout data 2151 code 3674 total 5825 (saves 1076)`, `without HeroSetRules data 2277 code 3811 total 6088 (saves 813)`.
- The same closure in the final 63-product sweep: `glanceData=2419 glanceCode=4437` (total 6,856). Dev jungle, FR965: `Glance: 2446` data, `Glance: 4459` code (6,905). — measured
- **Naive alternative: tag the existing `HeroSetApp` → `HeroSetStore` path.** Required tagging `HeroSetApp`, `getApp`, `HeroSetStore`, `HeroSetStorage`, `HeroSetPersistentStorage`, `HeroSetClock`, `HeroSetCalendar`, `HeroSetRules`, `HeroSetConfig`, `HeroSetDashboardState`, `HeroSetPalette`, the `(:nosync)`/`(:sync)` `HeroSetSyncCoordinator` twin, then `HeroSetThresholdLearner` and `HeroSetSwingTrace` (because `HeroSetStore.getLearningState` references them, `HeroSetStore.mc:254`). Build stats: `Glance: 2658` data, `Glance: 5063` code (7,721 B) with a stub view, before any real drawing. — measured, `b0`…`b0c`
- **Second alternative: annotate nothing.** The compiler then says, verbatim: `WARNING: fr965: This is a 'watch-app' app type but no source code was annotated with (:glance). The entire application will be loaded as a glance process.` Stats: `Foreground: 8035` data + `Foreground: 21743` code = 29,778 B loaded into the glance process. It fits 64 KB statically but runs `HeroSetStore`'s constructor, `onStart`'s complication publish and `onStop` in the glance process (see §3). — measured, `proto3`
- Resulting foreground growth from the lean design (reader, view, lazy app, 3 glance-scoped strings): store fr965 `Foreground` data 7959→8297 and code 21605→22609 bytes (+1,342 B, about +4.5%) for the whole app; existing budget note "dashboard ~52 KB, workout ~54 KB used" is not threatened. — measured vs baseline `Build Stats` (`Foreground: 7959 bytes`, `Foreground: 21605 bytes`, `Total PRG Size: 206172 bytes`); [compatibility.md:77](/Users/mbp/dev/garmin/HeroSet/docs/compatibility.md)
- Class-level annotation is the unit: putting `(:glance)` on only `HeroSetText.load`/`format` did not stop the compiler treating the whole class as glance scope (the scope lint still flagged `exerciseLabel`'s `Rez.Strings.exercise_pushups` at `HeroSetText.mc:27`). Per-function `(:glance)` on a member of an unannotated class still pulls the class in. — measured, lint output below

### Inferences
- Recommended closure: `HeroSetApp` (+ `getApp`), `HeroSetGlanceReader` (new, `data/`), `HeroSetGlanceView` (new, `ui/glance/`), `HeroSetStorage`, `HeroSetPersistentStorage`, `HeroSetDashboardState` (or a smaller state class; 191 B), `HeroSetCalendar`, `HeroSetRules`, `HeroSetConfig`, `HeroSetPalette`, `HeroSetDraw`, `HeroSetLayout`, `HeroSetText`. Total about 6.9 KB, roughly 10% of the 64 KB budget.
- `HeroSetRules` (813 B) and `HeroSetLayout` (1,076 B) are the only tagged classes carrying substantial unused code; splitting them (glance-only rules into a tiny class, a `rectangular` layout) could save about 1.5 KB but is not needed at a 64 KB limit. Not recommended: extra classes for headroom nobody needs.
- `HeroSetStore` stays foreground-only. Its `initialize` writes (see §3) and it drags in the learner; tagging it costs 7.7 KB and introduces Storage writes from the glance process.

### Gaps
- Real peak heap in the 64 KB glance process is unmeasured (see §8): the numbers here are static code+data plus test-runner heap deltas.
- Whether the compiler dead-strips unreferenced functions inside a tagged class was not tested; the `HeroSetRules` ablation (813 B for a 121-line class whose glance-used functions are small) suggests it does not.

---

## 2. Data freshness and correctness: what the store does on read vs on write

### Takeaway
The glance can compute today's counts and streak-alive **read-only**, and I proved it in the simulator (differential test against `HeroSetStore` plus a zero-write assertion). The store's constructor and `ensureCurrentDay` **do write**, so the glance must not construct `HeroSetStore`.

### Cited Findings
- `HeroSetStore.initialize` unconditionally writes `hero_schema` and then calls `ensureCurrentDay()`. — [HeroSetStore.mc:42-49](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)
- `ensureCurrentDay` writes `hero_day` and, on a day change, `resetDailyState` writes six keys (three counts, three credit ratchets). — [HeroSetStore.mc:55-70](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)
- Day rollover is lazy: nothing resets at midnight; stored counts stay until the first `ensureCurrentDay`. So at 00:01 the stored `hero_pushups` still holds yesterday's number. A glance that read `hero_pushups` directly would show yesterday's count as today's. The same holds for HeroFace, which is why the complication carries day keys. — [HeroSetStore.mc:55-62](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc), [HeroSetComplicationPublisher.mc:36-42](/Users/mbp/dev/garmin/HeroSet/source/app/HeroSetComplicationPublisher.mc), [decisions.md ADR-044](/Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
- Streak expiry is already read-side: `getStreak` returns `HeroSetRules.activeStreak(lastDay, todayKey, storedStreak)`, 0 once a day is missed, even though the stored run is only overwritten at the next completion. — [HeroSetStore.mc:128-131](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc), [HeroSetRules.mc:109-120](/Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetRules.mc)
- Goal changes: `setGoal` writes `hero_goal` and calls `updateCompletion`, so a lowered goal completes today and moves the streak at once; `getGoal` is a pure read with a 0-as-unset fallback. A glance reads the same key and sees the change on its next draw. — [HeroSetStore.mc:166-179](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)
- Values can come back as Number or Float ("depending on how they were originally written"), so every store read narrows through `asNumberOrNull`. A reader must match it (ADR-019). My prototype reader tolerated Float for counts and goal but only `instanceof Number` for `hero_last_completion`, a mismatch to fix. — [HeroSetStore.mc:289-306](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc); prototype `proto/source/data/HeroSetGlanceReader.mc`
- Prototype reader, read-only: `HeroSetGlanceReader.read(storage as HeroSetStorage, today as Number) as HeroSetDashboardState`; a count counts only when `hero_day == today`, streak via `activeStreak`, goal via the same 0-or-clamp rule. Tests written against the in-memory storage seam, run in the simulator on `fr965`:
  - `glanceReaderMatchesTheStoreOnTheSameDay` PASS (reader equals `store.getDashboardState()` for counts, streak, goal, before and after `completeAll`)
  - `glanceReaderNeverWritesAndReadsStaleDaysAsZero` PASS (a subclass of the test storage counts `setValue` calls: zero writes; next-day reads 0/0/0 and streak 1; day+2 reads streak 0; then advancing the clock and calling the real store gives the same numbers)
  - `glanceReaderCopesWithMissingCorruptAndFloatValues` PASS (empty storage → goal 100, counts 0; `hero_goal` 0 → default; Float `42.0f` count → 42)
  - Full-suite output verbatim: `Ran 103 tests` / `PASSED (passed=103, failed=0, errors=0)` (99 existing + 3 reader tests + 1 throwaway heap probe; dev jungle, FR965). One whole-suite re-run and two single-test re-runs wedged the simulator and were repeated after a restart.
- Storage is written per key, synchronously: "Information is automatically saved on disk when Storage.setValue() is called." — `SDK/doc/docs/Core_Topics/Persisting_Data.html`. `HeroSetStore.add` writes the count, credit, XP, then streak and last-completion as separate `setValue` calls. — [HeroSetStore.mc:81-93](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc), [:189-203](/Users/mbp/dev/garmin/HeroSet/source/data/HeroSetStore.mc)
- `onStorageChanged` exists for background↔foreground concurrency, only documented for background processes ("if the background and foreground process are active at the same time"). HeroSet uses neither. — `SDK/doc/docs/Core_Topics/Persisting_Data.html`
- Glance lifecycle on live-update devices (all 63): the system "will start the Widget in Glance mode, and keep it alive … updated as needed by the system", and recommends update rate under 1 Hz. On low-memory devices the app is started per update and `onStart`, `getGlanceView`, `onLayout`, `onShow`, `onUpdate`, `onHide`, `onStop` all run. — `SDK/doc/docs/Core_Topics/Glances.html`

### Inferences
- **Read in `onUpdate`, not in `initialize`.** A live glance can outlive midnight (process kept alive), so the day key and streak must be recomputed on every draw; the prototype does that (`HeroSetGlanceReader.read(new HeroSetPersistentStorage(), HeroSetCalendar.todayKey())` inside `onUpdate`).
- Torn reads: the glance and the foreground app are, as far as the docs say, separate launch contexts (a glance is a list item; selecting it launches the app), so simultaneous writer and reader is not an expected state. If it did happen the worst case is one draw with a stale or mixed value (for example streak from before a completion whose `hero_last_completion` write had not landed yet), corrected on the next `onUpdate`. No lock or retry is warranted. This is inference; see Gaps.
- Key spellings (ADR-003) would live in two places if the reader keeps its own literals (`"hero_day"`, `"hero_goal"`, `"hero_last_completion"`, `"hero_streak"`, `"hero_pushups"`, `"hero_situps"`, `"hero_squats"`). Two ways to keep one source: (a) a tiny `(:glance)` class of static key constants used by both the store and the reader (edits `HeroSetStore.mc:12-33` and the test references `store.GOAL_KEY`); (b) leave literals in the reader and pin them with the differential test above, which fails if a spelling ever diverges. (b) touches no user-data class in a paid app; (a) is the durable fix. Recommendation: (b) for the first glance release, (a) added to ADR-020's split when that debt is paid.
- A base-class split (`HeroSetReadStore` holding reads, `HeroSetStore extends` it) would also give one source and shrink `HeroSetStore.mc` (339 lines vs a 250 budget, ADR-020), but ADR-020 flags "bad split corrupts installs"; not recommended in the same change as a feature.

### Gaps
- Whether the glance process and the foreground app can ever overlap in time, and whether a process restart re-reads Storage from disk every time, was not testable (the simulator GUI could not be scripted, see §8).
- Glance behaviour on rollover in a *kept-alive* live glance was not observed.

---

## 3. Does `HeroSetApp.initialize` run in the glance, and what must change

### Takeaway
Yes: the glance process instantiates the `AppBase` subclass and calls `initialize`, `onStart` and `onStop` too, so the current `HeroSetApp` would build `HeroSetStore` (writes) and `HeroSetSyncCoordinator`, and call the complication publisher, inside a 64 KB glance process. It needs a lazy-store rewrite; this is the only change to existing runtime behaviour, and it moves the ADR-044 "app start" publish point.

### Cited Findings
- Current app constructor eagerly builds the store and the sync coordinator; `onStart` calls `ensureCurrentDay()` and `HeroSetComplicationPublisher.publish(_store)`; `onStop` calls `_sync.stop()`. — [HeroSetApp.mc:7-23](/Users/mbp/dev/garmin/HeroSet/source/app/HeroSetApp.mc)
- Glance lifecycle: "The Application.AppBase functions AppBase.onStart(), AppBase.getGlanceView() will be called to start the app and retrieve the view … The AppBase.onStop() function will be called upon app termination." — `SDK/doc/docs/Core_Topics/Glances.html`
- The entry class must be in glance scope. With `(:glance)` on `HeroSetApp` and no other change the compiler is silent at default level but `-l 2`/`-l 3` list every foreground reference from it (see lint output below): `HeroSetStore` at `HeroSetApp.mc:13`, `HeroSetSyncCoordinator` `:14`, `ensureCurrentDay` `:18`, `HeroSetComplicationPublisher.publish` `:19`, `stop` `:23`, `HeroSetView`/`HeroSetDelegate` `:27`. — measured
- `getStore()` and `getSync()` are called from views and the workout code; a lazy getter keeps that API. The `(:debug)` `swapStoreForTest` returns `_store` directly — [HeroSetApp.mc:37-46](/Users/mbp/dev/garmin/HeroSet/source/app/HeroSetApp.mc) — so with a nullable field it must return `getStore()` (screen-fit test uses it: [HeroSetScreenFitTest.mc:26,55](/Users/mbp/dev/garmin/HeroSet/source/test/HeroSetScreenFitTest.mc)).
- `getApp()` (`HeroSetApp.mc:50-52`) is a global function and needs `(:glance)` too if the view calls it; the lean design's glance view does not.
- Prototype that compiled on 80/80 products and ran the 103-test suite: `initialize()` only calls `AppBase.initialize()`; `_store`/`_sync` are nullable and created by `getStore()`/`getSync()`; `onStart` is empty; `onStop` calls `sync.stop()` only when `_sync != null`; `getInitialView()` does `store.ensureCurrentDay()` then `HeroSetComplicationPublisher.publish(store)` then returns the view/delegate; `getGlanceView()` returns `[ new HeroSetGlanceView() ]`; foreground-only methods carry `(:typecheck(disableGlanceCheck))`. — `proto2/source/app/HeroSetApp.mc`
- `:typecheck(disableGlanceCheck)` is a documented annotation that suppresses the glance-scope check for a function. With it on `onStop`/`getInitialView`/`getStore`/`getSync`, the `-l 3` scope grep is clean except five `HeroSetText` label strings (see §7). — `SDK/doc/docs/Monkey_C/Monkey_Types.html` ("this check can be disabled for background or glance scopes using the annotations :typecheck(disableBackgroundCheck) or :typecheck(disableGlanceCheck)"); measured
- `(:sync)`/`(:nosync)` coordinator twins ([HeroSetSyncCoordinator.mc:18](/Users/mbp/dev/garmin/HeroSet/source/app/HeroSetSyncCoordinator.mc), [HeroSetSyncCoordinatorOff.mc:6](/Users/mbp/dev/garmin/HeroSet/source/app/HeroSetSyncCoordinatorOff.mc)) and the jungles' exclusions (`monkey.jungle:3` `base.excludeAnnotations = nosync`, `store.jungle:7` `sync;debug`) need no change: the coordinator is never tagged `(:glance)`; the app only holds a nullable typed field. Both jungles built with the glance in the prototype (store `Glance` 2419+4437, dev 2446+4459). No jungle or manifest edit was needed; `manifest.xml`/`manifest-store.xml` stay `type="watch-app" entry="HeroSetApp"`, permissions unchanged. — measured
- `AppBase.onStart` gets `:launchedFromGlance` when the app is launched from the glance list (v4.0.0), available if a launch-from-glance behaviour is ever wanted. — `SDK/doc/docs/Readme/History.html`

### Inferences
- Moving `ensureCurrentDay` and `publish` from `onStart` to `getInitialView` preserves the intended sequence for every foreground launch (the store constructor already runs `ensureCurrentDay` on first `getStore()`); the explicit call is redundant but keeps the line. The change is **required**, not stylistic: leaving `HeroSetComplicationPublisher.publish(_store)` in `onStart` runs it in the glance process, where the class is not loaded.
- The behaviour change to review: ADR-044 says "Published on every stored change: app start, every save …, midnight while the dashboard is open". "App start" becomes "first view request". For a normal launch or a launch from the glance the two are the same moment; it needs one on-watch check with HeroFace installed (FR965 has both).
- A glance-only guard in `onStart` is not possible: `onStart` gets no argument that says "I am the glance process" (`:launchedFromGlance` marks the foreground launch, not the glance itself), so the only safe design is an `onStart` that touches nothing foreground.

### Gaps
- Whether the glance process reuses an existing `HeroSetApp` instance across the glance-to-app transition (versus a fresh process) is not documented; the lazy design is safe either way.

---

## 4. Layering, file placement, size and style rules

### Takeaway
New code fits the layers: reader in `data/`, view in `ui/glance/`, both `(:glance)`. Only two rule collisions need decisions: glance geometry constants (no magic numbers) and rectangular layout for `HeroSetDraw.text`'s `layout` argument.

### Cited Findings
- Layers point down only; only `data/` touches Storage; Presentation may not touch raw Storage. — [CLAUDE.md](/Users/mbp/dev/garmin/HeroSet/CLAUDE.md), [architecture.md §3](/Users/mbp/dev/garmin/HeroSet/docs/architecture.md)
- One class per file, `HeroSet` prefix; functions ≲30 lines, files ≲250 lines. The prototype view is about 55 lines and `drawState` about 25; the reader about 35 lines. `HeroSetStore.mc` (339 lines) is untouched, so its ADR-020 debt does not grow. — [CLAUDE.md](/Users/mbp/dev/garmin/HeroSet/CLAUDE.md), [architecture.md §8](/Users/mbp/dev/garmin/HeroSet/docs/architecture.md)
- `HeroSetLayout` derives spacing from the dc's short side: `shortInset() = min(w,h)/10`, `stackGap() = shortInset()/9`, `barHeight() = shortInset()/3`. On a 63 px glance that is inset 6, gap 0, bar height 2 (integer division); on 148 px it is 14, 1, 4. Round-chord insets assume the whole display, wrong for a rectangular glance. — [HeroSetLayout.mc:25-31](/Users/mbp/dev/garmin/HeroSet/source/layout/HeroSetLayout.mc), [:51-53](/Users/mbp/dev/garmin/HeroSet/source/layout/HeroSetLayout.mc), [:70-76](/Users/mbp/dev/garmin/HeroSet/source/layout/HeroSetLayout.mc), [:125-147](/Users/mbp/dev/garmin/HeroSet/source/layout/HeroSetLayout.mc)
- `HeroSetLayout._round` comes from `System.getDeviceSettings().screenShape`, true on all 80 products, so `fitsDisplay` would apply round chord insets to a glance rectangle. Prototype fix: `HeroSetLayout.rectangular()` (3 lines) sets `_round = false`. — `proto2/source/layout/HeroSetLayout.mc`
- `HeroSetDraw.text` records boxes in `HeroSetDraw.boxes`/`misfits` only when tests enable them, so glances drawn through it are testable with the existing harness. — [HeroSetDraw.mc:15-33](/Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetDraw.mc), [HeroSetScreenFitHarness.mc:25-52](/Users/mbp/dev/garmin/HeroSet/source/test/HeroSetScreenFitHarness.mc)
- `HeroSetDraw.text` and `HeroSetLayout` add 1,225 + 1,076 B to the glance (§1); the price of following ADR-034 for a text-only glance.
- Render only in `onUpdate`; logic in stores/domain: satisfied, `onUpdate` calls the reader then `drawState`. — [CLAUDE.md](/Users/mbp/dev/garmin/HeroSet/CLAUDE.md), [HeroSetView.mc:24-48](/Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetView.mc) (same split pattern)

### Inferences
- Place: `source/data/HeroSetGlanceReader.mc`, `source/ui/glance/HeroSetGlanceView.mc`; `docs/architecture.md` §2 tree and §4 module list gain both.
- No magic numbers: the glance needs named tunables for bar height, gap and the small-area threshold (candidate `HeroSetConfig` or `HeroSetLayout` constants, or a `HeroSetGlanceLayout`), because the dashboard's short-side formulas give 2 px bars and 0 px gaps at 63 px.
- The dashboard's `HeroSetMissionBars` (bar-with-label rows, `HeroSetMissionBars.mc:31-49`) is not reusable at glance scale: it needs labels from foreground strings and a `HeroSetLayout`-driven pitch. The prototype draws its own three bars.

### Gaps
- Final glance visual design (three bars vs numbers vs "n/3 done") is a design call not made here; see the sibling `glance_design_and_ux.md`.

---

## 5. Text, resources and localization

### Takeaway
Text in the glance is loaded through `WatchUi.loadResource`, which only works for strings declared `scope="glance"`. Each glance string is a change in all 15 `strings.xml` files. The compiler check works, but whether the per-language files need the attribute is unverified.

### Cited Findings
- Default resource scope is foreground. Glance code can load only `glance`- or `background`-scoped resources; a `glance` string is also available to the foreground app. — `SDK/doc/docs/Core_Topics/Resources.html` ("Valid values for the scope attribute are background, glance, and foreground. If the attribute is not specified for a resource, it will be considered part of the foreground scope by default.")
- The scope lint sees resource references: with `AppName`, `dashboard_streak`, `dashboard_streak_none` unscoped the lint printed `ui/glance/HeroSetGlanceView.mc:21,8: Value 'AppName' not available in all function scopes.`, `…:30,8: Value 'dashboard_streak_none' …`; after `scope="glance"` on those three ids in `resources/strings/strings.xml` those lines disappeared. — measured
- Scoping only `resources-deu/strings/strings.xml` (default file unscoped) also silenced the lint, so it cannot tell whether each language file needs the attribute. Compiler build stats (`Glance:` bytes) do not change with resource scope at all (2419/4437 in all three probe states). — measured, `proto4`
- On the 17 unsupported products the resource compiler warns per scoped string, e.g. `WARNING: fenix6: resources/strings/strings.xml:2,4: String resource 'AppName' specifies the 'glance' resource scope, but app type 'watch-app' does not support glances on device 'fenix6'.` — measured
- `HeroSetText` is one class holding `load`/`format` plus `exerciseLabel`/`reps`, whose `Rez.Strings.exercise_*` and `menu_title_rep(s)` are foreground. Tagging the class leaves five scope violations (`HeroSetText.mc:27,30,32,42`). — [HeroSetText.mc:14-42](/Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetText.mc); measured lint
- 15 language files each carry the full string set (English 69 `<string>` lines, `deu` 67). The ids to scope for a glance that shows title + streak line: `AppName` (identical "HeroSet" in all 15), `dashboard_streak`, `dashboard_streak_short`, `dashboard_streak_none`, plus `dashboard_mission_complete`/exercise labels if used. — [resources/strings/strings.xml:2,25-38](/Users/mbp/dev/garmin/HeroSet/resources/strings/strings.xml), `resources-*/strings/strings.xml`
- `tools/fit-sweep.sh` overlays each language's strings in a throwaway jungle over the shared `source` path, so a glance fit test in the dev suite is automatically swept per language. — [tools/fit-sweep.sh](/Users/mbp/dev/garmin/HeroSet/tools/fit-sweep.sh)

### Inferences
- Simplest: put `scope="glance"` on the needed ids in **all 16 places** (default + 15 languages, mechanical). Fix `HeroSetText` by scoping its five extra strings too (about 38 B each in glance data by my measurement of three ids: +115 B) or by moving `load`/`format` into a glance-only helper class. Cheaper: scope the five.
- `dashboard_streak_short` must be glance-scoped too if the streak line uses `firstFitting` like the dashboard does (`HeroSetView.mc:74-86`); the prototype hit `9999 DAY STREAK` overflow on fr965 and fr165 (§7).
- No new visible copy is required for the minimal glance (title = existing `AppName`, streak = existing strings), so there is no new translation work; a new label would need 14 translations plus the fit sweep ([development.md Localization](/Users/mbp/dev/garmin/HeroSet/docs/development.md)).

### Gaps
- Not verified that language files without the attribute fail at runtime in the glance process, or fail loudly versus render blank. The glance was never rendered in a non-English language (simulator has no CLI language switch; `fit-sweep.sh` overlay approach was not run for the glance).

---

## 6. Build, lint and the silent-runtime-failure risk

### Takeaway
The default build gives no signal when a `(:glance)` path calls foreground code: it compiles, then fails in the glance process. The check exists only at `-l 2` (warnings) and `-l 3` (errors), and the codebase already fails `-l 3` for unrelated reasons, so the gate must be a targeted grep.

### Cited Findings
- Command used (any product): `monkeyc -d fr965 -f store.jungle -o out/x.prg -y <key> -w -l 3 2>&1 | grep "not available in all function scopes"`.
- With `(:glance)` only on `HeroSetApp` and `HeroSetGlanceView` and the original app body, default build (and `-l 1`) printed `BUILD SUCCESSFUL` and `Glance: 839` data / `Glance: 340` code. At `-l 2` the same source printed (verbatim, first lines): `WARNING: fr965: …/HeroSetApp.mc:13,8: Value 'HeroSetStore' not available in all function scopes.` `…:13,8: Value 'initialize' not available in all function scopes.` `…:14,8: Value 'HeroSetSyncCoordinator' not available in all function scopes.` `…:18,8: Value 'ensureCurrentDay' not available in all function scopes.` `…:19,8: Value 'HeroSetComplicationPublisher' not available in all function scopes.` `…:23,8: Value 'stop' not available in all function scopes.` `…:27,8: Value 'HeroSetView' not available in all function scopes.` `…:27,8: Value 'HeroSetDelegate' not available in all function scopes.`; at `-l 3` the same lines are `ERROR:`. — measured
- The existing code already fails `-l 3` independent of glances: `HeroSetStore.mc:182,8` (`eq` with invalid types, many lines), `HeroSetStore.mc:222,8`, `HeroSetStore.mc:227,8`, `HeroSetCalendar.mc:14,8`, `HeroSetMenuDelegate.mc:24,12` (`Cannot find symbol ':setSubLabel' on type 'Null'`), and untyped `HeroSetLayout` members `:19-23`. So `-l 3` cannot be a blanket build gate without unrelated fixes. — measured
- Lean prototype final lint (with `:typecheck(disableGlanceCheck)` on the four foreground-only app methods, three strings glance-scoped): only `ui/HeroSetText.mc:27,12 exercise_pushups`, `:30,12 exercise_situps`, `:32,8 exercise_squats`, `:42,8 menu_title_rep`, `:42,8 menu_title_reps` remain. — measured
- History: v9.2.0 "Improve code generation when the (:glance) annotation is used without implementing AppBase.getGlanceView"; v6.3.0 "Apply scope checking for the background and glance portions of an app when the entire app is loaded into these processes"; v4.0.0 "Generate warning instead of error when app exceeds glance memory limit." — `SDK/doc/docs/Readme/History.html`
- Memory over-limit is only a warning, not a build failure (v4.0.0 note above); none appeared here because the closure is 6.9 KB.
- Unrelated observation: `monkey.jungle` sets no `base.sourcePath`, and a stray `.mc` under the project root (I had left a copy in `out/`) was compiled in ("Redefinition of '$.HeroSetApp'"); `store.jungle` pins `base.sourcePath = source`. Keep scratch `.mc` files out of the HeroSet tree. — [monkey.jungle](/Users/mbp/dev/garmin/HeroSet/monkey.jungle), [store.jungle:4](/Users/mbp/dev/garmin/HeroSet/store.jungle)

### Inferences
- Add to `docs/development.md` a "glance scope check" line: `-l 2` build, grep `not available in all function scopes`, expect none. Add the same to the release checklist since it is the only pre-device guard.
- Annotating `HeroSetApp` foreground methods with `(:typecheck(disableGlanceCheck))` hides exactly the errors the check would raise for them, which is right (they never run in the glance), but keep `initialize`, `onStart`, `getGlanceView` un-annotated so the check keeps guarding what does run.

### Gaps
- The compiler does not tell which annotated code actually executes in the glance; reachability from `initialize`/`onStart`/`onStop`/`getGlanceView`/`onUpdate` is by review, so a code-review checklist item is needed.

---

## 7. Tests: what must be added, and can a glance be drawn in tests

### Takeaway
Yes, glances can be drawn in the existing harness (buffered bitmap of the glance's content-area size, `HeroSetDraw.misfits/boxes`), and it caught real overflows on the first run. What is missing is a per-product content-area table, because no runtime API reports the glance size.

### Cited Findings
- Existing harness: `everyScreenFitsThisDisplay` draws each view into one reused `BufferedBitmap` of the display size and asserts no clipping, no overlap and the expected row count; it is `(:test :debug)`, so it does not run in the store test build. — [HeroSetScreenFitTest.mc:15-67](/Users/mbp/dev/garmin/HeroSet/source/test/HeroSetScreenFitTest.mc), [HeroSetScreenFitHarness.mc](/Users/mbp/dev/garmin/HeroSet/source/test/HeroSetScreenFitHarness.mc)
- Prototype `(:test :debug) glanceFitsThisProductsArea` draws `HeroSetGlanceView.drawState` for two states (empty; goal 500 with counts 500 and streak 9999) into a bitmap the size of the product's glance content area, and additionally asserts each text box stays inside the bitmap. Results, run per product in that product's simulator (font heights measured):

  | Product (area) | `FONT_GLANCE` px | Result |
  |---|---|---|
  | fr965 (299x148) | 42 (`FONT_GLANCE_NUMBER` 53, `XTINY` 37) | FAIL: `'9999 DAY STREAK' right 311 > 299` |
  | fr165 (261x124) | 35 | FAIL: `'9999 DAY STREAK' right 262 > 261` |
  | fenix7 (171x63) | 22 | PASS |
  | fenix7x (191x63) | 22 | PASS |
  | fr255s (140x79) | 19 | PASS |
  | venu2s (249x115) | 37 | PASS |
  | fenix847mm (349x130) | 42 | PASS |
  | fenix7s (151x63) | 22 (from an earlier run) | final run produced no output (simulator wedged) |
  | fr265s (240x104) | not obtained | run wedged |

  Raw excerpts from `glancefit.txt`: `DEBUG (20:23): RESULT area 299x148 GLANCE font h=42 GLANCE_NUMBER h=53 XTINY h=37`, `DEBUG (20:23): RESULT problem '9999 DAY STREAK' right 311 > 299`, `DEBUG (20:24): RESULT area 261x124 GLANCE font h=35 …`, `DEBUG (20:24): RESULT problem '9999 DAY STREAK' right 262 > 261`, `glanceFitsThisProductsArea PASS` for fenix7/fr255s/venu2s/fenix847mm/fenix7x. The first version drawing at x=0 also failed on fr965 and fenix7s on the rectangular layout's left inset (`HeroSet y=0`), so the test also caught a layout-rule violation, not just widths.
- Glance area sizes are not readable at runtime; `System.getDeviceSettings()` has no glance dimensions. The only source is per-product `simulator.json` → a table of 63 rows in the test, or family minima (worst case 140x79 and 151x63). — `~/Library/Application Support/Garmin/ConnectIQ/Devices/<p>/simulator.json`
- Test counts today: 99 dev, 88 store (11 fewer in the store build: the sync tests and the `(:test :debug)` fit test). The count is written in [CLAUDE.md:18](/Users/mbp/dev/garmin/HeroSet/CLAUDE.md), [README.md:22](/Users/mbp/dev/garmin/HeroSet/README.md), [docs/development.md:37](/Users/mbp/dev/garmin/HeroSet/docs/development.md) and [docs/go-to-market.md:10](/Users/mbp/dev/garmin/HeroSet/docs/go-to-market.md). **`docs/release-contract.md` contains no test count** (only "Unit tests" in two rows), so the CLAUDE.md rule "appears in this file, README.md, development.md, release-contract.md" is stale by one: the fourth place is `go-to-market.md`. `CHANGELOG.md:21` ("99 dev / 88 store") is a dated history line and stays. — measured by grep
- Proposed additions and their effect on the counts: reader tests `(:test)` (matches-store, never-writes-and-stale-day, corrupt/float, plus a streak-boundary case) run in both builds; the fit test is `(:test :debug)` and runs in dev only. With three reader tests and the one dev-only fit test: **103 dev / 91 store**. (The prototype also ran 103 in the dev build, but there the fourth test was a throwaway heap probe, not the fit test; the fit test was run separately per product.) Derive the exact figure at implementation time from `Ran N tests` in each build.

### Inferences
- Reader tests belong next to `HeroSetStoreTest`'s fixtures (`HeroSetTestStorage`, `HeroSetTestClock`, `storeWith`, `completeAll` at `HeroSetStoreTest.mc:7-47`): reuse them as the prototype did, and keep the differential (real store as oracle) and the zero-write check; both catch the two things that go wrong quietly (key drift, accidental writes).
- The `9999 DAY STREAK` overflow is the real design constraint: the glance needs `HeroSetDraw.firstFitting` with `dashboard_streak_short` and a further fallback (number only). The dashboard's widest-state convention (`9999`-day streak, goal 500) applies.
- Per-product run: extend the existing "every product" loop in `development.md` to run the glance fit test, and `tools/fit-sweep.sh -l` on `venu2s fr265s` for languages (its jungle overlay compiles the glance automatically).

### Gaps
- Fit results for `fenix7s`, `fr265s` and the rest of the 63 products were not obtained; the simulator wedged repeatedly (killed and restarted twice) and I stopped. 5 of 7 obtained products passed after the layout inset fix; the 2 failures are reproducible string-width failures, not simulator noise.

---

## 8. Memory and what the simulator can and cannot show

### Takeaway
Static glance footprint is measured (6.9 KB); runtime heap in a 64 KB glance process is not, because the simulator's glance mode toggle is a GUI menu that could not be scripted here.

### Cited Findings
- Simulator glance controls are in the GUI ("Settings > Glance View"); `osascript` System Events was refused: `osascript is not allowed assistive access. (-25211)`. No CLI switch exists (`monkeydo` has only `-n`, `-a`, `-t`). — measured; `SDK/bin/monkeydo` usage text; `SDK/doc/docs/Readme/History.html` v3.2.1/v4.1.4 ("Settings > Glance Launch Mode")
- Heap probes ran in the *unit-test runner* (reports `total=8383936`, about 8 MB, not 64 KB): `RESULT read+persistent storage object delta=240` (bytes) for one `HeroSetGlanceReader.read` plus a `HeroSetPersistentStorage`, and `RESULT drawState transient heap delta=0` after `drawState` returned (freed objects; not a peak). — measured, `heap.txt`, `glancefit.txt`
- Compile-time budget only warns: v4.0.0 "Generate warning instead of error when app exceeds glance memory limit." — `SDK/doc/docs/Readme/History.html`
- Glances "can not support more than 4 widgets in the glance mode" on live-update devices was a 3.1.9 fix, not a current limit. — `SDK/doc/docs/Readme/History.html` v3.1.9 (context only)

### Inferences
- With a 6.9 KB static closure, a few hundred bytes of live objects and text layout, the glance should sit far under 64 KB; the risk is not the size but out-of-scope references (§6).

### Gaps
- Peak heap, resource-table cost, and font/dc memory inside the 64 KB process: unmeasured. Simulator manual step for the owner: Settings > Glance View on, then View > App Memory (or the Memory window) on `fr965` and one 218 px product.
- What the simulator cannot prove: real glance-process memory and kill behaviour, the system's glance refresh cadence, idle timeout after launching from a glance, foreground-vs-glance Storage timing, real fonts, MIP contrast, per-locale resource behaviour, whether a sideloaded watch-app appears in the glance list.

---

## 9. ADR-044 (complication) and HeroFace interaction

### Takeaway
No functional interaction. The complication payload, field order, label and id are untouched; the only ADR-044 touch is the publish call moving from `onStart` to `getInitialView`. HeroFace needs no change.

### Cited Findings
- Complication contract: `v|dayKey|push|sit|squat|rank|rankPct|streak|lastDoneDay|goal`, field order fixed, id 0, label `HeroSet`, private access. `valueFor` is pure and unit-tested. — [HeroSetComplicationPublisher.mc:36-63](/Users/mbp/dev/garmin/HeroSet/source/app/HeroSetComplicationPublisher.mc), [decisions.md ADR-044](/Users/mbp/dev/garmin/HeroSet/docs/decisions.md), [HeroSetComplicationTest.mc](/Users/mbp/dev/garmin/HeroSet/source/test/HeroSetComplicationTest.mc)
- The glance neither reads the complication nor publishes: it reads Storage directly. Only watch faces can subscribe to complications (ADR-044), so a glance could not read it anyway. — [decisions.md ADR-044](/Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
- HeroFace's only link to HeroSet is that complication; a grep of `HeroFace/`, `DaysToGo/`, `site/src` for "glance" finds only unrelated wording ("glanceable", "one glance") and no dependency. — grep, [HeroFace/docs/plan.md:124](/Users/mbp/dev/garmin/HeroFace/docs/plan.md)
- `HeroSetComplicationPublisher` is not `(:glance)`; the `Toybox has :Complications` guard and try/catch there (`HeroSetComplicationPublisher.mc:21-33`) are unaffected.
- `HeroSetDayTracker.onTimer` publishes at midnight while the dashboard is open (`HeroSetDayTracker.mc:30-37`); unchanged and foreground-only.

### Inferences
- Confirmed none. Do the one FR965 check: launch HeroSet from the glance with HeroFace installed, save a set, confirm the face updates (validates the moved publish point).

### Gaps
- The still-unverified midnight publish path noted in ADR-044 remains unverified; the glance does not change that.

---

## 10. Risks (ranked)

### Takeaway
Two risks are device-only and could hurt paying users: an inactivity timeout that kills an app launched from a glance, and a glance-scope mistake that compiles clean. Everything else is bounded.

### Cited Findings
- R1, **inactivity termination of an app launched from a glance.** "Selecting an item from the list launches into the experience. The user can exit by backing out of the base page, but after a period of inactivity, the system will terminate the launched app, as well." — `SDK/doc/docs/User_Experience_Guidelines/Entry_Points.html` ("Glance List (Device apps, Widgets)"). HeroSet has no in-app persistence of a running set and `battery.md` already lists the open question: "If the system times the app out instead, an unsaved set is **silently lost**". — [battery.md:27,34](/Users/mbp/dev/garmin/HeroSet/docs/battery.md). A user who launches from the glance, presses START and does 60+ seconds of reps without touching a button is the exact case. Not testable in the simulator.
- R2, glance-scope violation compiles clean, crashes at runtime in the glance process (§6).
- R3, `initialize`/`onStart`/`onStop` run in the glance; today they build the store (writes `hero_schema` every construction, resets on rollover) and call the complication publisher (§3).
- R4, coverage: 63 of 80 products; the 17 CIQ 3.4 products keep the compiled-in but ignored glance and get 18 warnings each (first section).
- R5, resource scope per language file unverified, 15 files (§5).
- R6, ADR-003 key spellings duplicated in the reader (§2); `hero_last_completion` Float tolerance mismatch (§2).
- R7, geometry and fit at glance size: 63 px tall areas on the fēnix 7 family (title + bars + streak at `FONT_GLANCE` 22 px), 42 px font on FR965 with the `9999 DAY STREAK` overflow (§7); the dashboard formulas give 2 px bars and 0 gap at 63 px (§4).
- R8, publish point moves from `onStart` to `getInitialView` (§3).
- R9, glance area is not readable at runtime, so tests need a per-product table (§7).
- R10, torn/stale reads and process overlap unverified; bounded to one draw (§2).
- R11, review and crash exposure: a glance crash is a new failure surface in a paid app whose 1.0.0 shipped with a device-only watchdog crash the simulator never showed (ADR-046/047: "Watchdog Tripped Error … on a real FR965"; "1.0.0 was exposed to buyers for roughly one day"). Manifest and permissions do not change, so this is not a new permission review, but Garmin's review of a new app-type behaviour is not documented anywhere in the repo. — [decisions.md ADR-046/047](/Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
- R12, glance-launched exits: with a glance, Back from the dashboard returns to the glance list, not the app list/watch face; ADR-024's "over-popping exits app" rule is unaffected but the exit destination changes. — [decisions.md ADR-024](/Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
- R13, sideloaded dev build may not surface in the glance list until the user enables it; unknown.
- R14, docs churn and stale rules (test-count fourth place; ideas.md #1 wording "80 products" implied) (§11).

### Inferences
- R1 needs an answer before any store upload; if a launched-from-glance app is killed after idle, a mid-set idle would lose the set. Possible mitigations exist only in-app (persist a running-set count) and are a separate ADR; `:launchedFromGlance` in `onStart` allows detecting the launch path if a mitigation must be conditional.
- R2 is controllable with the `-l 2` grep and a review of the four lifecycle entry points; R3 with the lazy store; R4/R5/R7 with the per-product sweep and language overlay.

### Gaps
- No documentation of how long the idle timeout is, whether sensor listeners or an active accelerometer stream reset it, or whether it applies to device apps as opposed to widgets. Only the guideline sentence above.

---

## 11. Concrete change list (file by file), and docs, site, listing

### Takeaway
Code: 2 new files, 1 rewritten runtime file, about 10 one-line annotations, 1 small layout helper, string attributes in 15 files, 3-4 new tests. Docs: about 14 files. No manifest, jungle, permission, storage-key or complication change.

### Cited Findings
**Source (all under `/Users/mbp/dev/garmin/HeroSet/`)**

| File | Change |
|---|---|
| `source/app/HeroSetApp.mc` | `(:glance)` on class (`:5`) and `getApp` (`:50`); nullable lazy `_store`/`_sync` (`:7-14`, `:29-35`); empty `onStart` (`:16-19`); null-guarded `onStop` (`:21-23`); `getInitialView` (`:25-27`) gains `ensureCurrentDay` + `publish`; add `getGlanceView`; `(:typecheck(disableGlanceCheck))` on `onStop`, `getInitialView`, `getStore`, `getSync`; `swapStoreForTest` (`:37-46`) returns `getStore()`. |
| `source/data/HeroSetGlanceReader.mc` (new) | `(:glance)` static `read(storage, today) as HeroSetDashboardState`; no writes; Number/Float narrowing as `HeroSetStore.asNumberOrNull`. |
| `source/ui/glance/HeroSetGlanceView.mc` (new) | `(:glance)` `extends WatchUi.GlanceView`; `onUpdate` → reader → `drawState`; draw via `HeroSetDraw.text`; named geometry constants; `firstFitting` streak text. |
| `source/data/HeroSetStorage.mc:7`, `HeroSetPersistentStorage.mc:8`, `HeroSetDashboardState.mc:3` | add `(:glance)`. |
| `source/domain/HeroSetCalendar.mc:9`, `HeroSetRules.mc:5`, `HeroSetConfig.mc:2` | add `(:glance)`. |
| `source/ui/HeroSetPalette.mc:7`, `HeroSetDraw.mc:7`, `HeroSetText.mc:6` | add `(:glance)`. |
| `source/layout/HeroSetLayout.mc:10` | add `(:glance)`; add `rectangular()` (or a glance layout constant set). |
| `resources/strings/strings.xml` and the 14 `resources-<lang>/strings/strings.xml` | `scope="glance"` on `AppName`, `dashboard_streak`, `dashboard_streak_short`, `dashboard_streak_none` (and the five `HeroSetText` strings if the class stays tagged whole). |
| `source/test/HeroSetGlanceReaderTest.mc` (new), `HeroSetGlanceFitTest.mc` (new, `(:test :debug)`) | tests above; fit test needs a per-product content-area table. |
| `monkey.jungle`, `store.jungle`, `manifest.xml`, `manifest-store.xml`, `resources-complications/`, `HeroSetStore.mc`, `HeroSetComplicationPublisher.mc`, HeroFace | **no change** (measured: both jungles build; nothing else referenced). |
| `docs/development.md` | add the `-l 2` scope grep and glance simulator steps; test count (`:37`). |

**Docs to update the same session** ([CLAUDE.md "Keeping docs in sync"](/Users/mbp/dev/garmin/HeroSet/CLAUDE.md), [root CLAUDE.md](/Users/mbp/dev/garmin/CLAUDE.md)):
- `docs/decisions.md`: add **ADR-051** (index row + `<a id="adr-051"></a>` heading; 051 is free, last is 050). Amend note on ADR-044 (publish point moved). Mention ADR-020 if the key-constant class is added.
- `docs/architecture.md`: §2 tree (`data/HeroSetGlanceReader`, `ui/glance/`), §3/§4 (glance-process rule: `(:glance)` closure, no Storage writes, no foreground refs), §5 data flow (glance read path), §8 debt (duplicated key spellings if option (b)).
- `docs/compatibility.md`: new "Glance" note — 63 of 80 products (CIQ 4.0+); the 17 CIQ 3.4 products excluded; bump the status date (`compatibility.md:3`).
- `docs/release-contract.md`: new row "Glance: 63 of 80 watches, simulator only until device check"; forbidden-claim lines (glance on every watch; live during a set; any accuracy claim); bump date.
- `docs/input-and-ux.md`: a "Glance" section (what it shows, launch, Back returns to the list).
- `docs/ideas.md`: #1 "Glance view" graduates — replace with "Graduated: ADR-051, see go-to-market", answer its Risks lines (per-device support = 63/80; `ensureCurrentDay` not assumed = read-only reader).
- `docs/go-to-market.md`: "Where things stand" test count and status line, new checklist items under "Next session" B/C (the on-watch checks in §12), and the version decision (§12); bump date. `docs/testing-plan.md`: rows for the reader and glance fit tests, simulator workflow, FR965 line.
- `CLAUDE.md:18` and `README.md:22` and `docs/development.md:37` test count; add to CLAUDE.md Fast facts one line: glance `(:glance)` closure and the scope grep.
- `CHANGELOG.md`: entry for the release (version, upload date, "Glance on 63 watches", ADR-051). `listing/README.md`: `App Version` (`:36-40` block) and a paste-ready **What's New** block (previous block moves to `listing/NOTES.md`), and optionally one Description bullet; status line `:3`. Repo root rule: every store publication does this ([root CLAUDE.md](/Users/mbp/dev/garmin/CLAUDE.md)).
- Repo root `TODO.md` (single to-do list per memory note): add the glance checks.
- Site (`/Users/mbp/dev/garmin/site/src/apps/heroset/`): `Support.tsx` (an FAQ line on the glance and on which watches have it), `Landing.tsx` (optional feature line), `facts.ts` only if a per-family glance list is shown (it mirrors `compatibility.md`); `Privacy.tsx` needs **no change**: no new data, permission or network use. — [Support.tsx](/Users/mbp/dev/garmin/site/src/apps/heroset/Support.tsx), [Privacy.tsx:24](/Users/mbp/dev/garmin/site/src/apps/heroset/Privacy.tsx). Never change a published URL ([root CLAUDE.md](/Users/mbp/dev/garmin/CLAUDE.md)).
- HeroFace: none.

**ADR-051 draft outline** (title: "App glance: read-only, `(:glance)`-scoped, 63 of 80 watches"):
1. Context: ideas #1, watch-app glance API 4.0, what a glance is.
2. Decision: glance view returns today's counts and streak from Storage read-only; never constructs `HeroSetStore`.
3. Process rules: `initialize`/`onStart`/`onStop`/`getGlanceView`/`onUpdate` run in the glance; they touch only `(:glance)` classes; store built lazily; `ensureCurrentDay` and complication publish live in `getInitialView`; scope check is `-l 2` grep.
4. Closure: the class list and measured 6.9 KB (limit 64 KB; 32 KB on the ignored 17).
5. Data: reader reads the flat keys (ADR-003); stale day = 0; streak via `activeStreak`; parity test with the store; key-duplication choice.
6. Resources: `scope="glance"` ids in all 15 languages.
7. Coverage: 63 of 80; compiler warnings on 17 accepted; claims limited accordingly.
8. Rejected: annotate nothing (whole 29.8 KB app in the glance, writes, publish in glance); tag `HeroSetStore` (7.7 KB, writes from the glance); read the complication (only watch faces subscribe); per-product exclusion of the 17 (extra jungle lines for no functional gain); background service.
9. Consequences: publish point change (ADR-044 amended); idle-timeout unknown (R1) and its device test; tests +3 both builds, +1 dev.
10. Status line: "simulator-verified only" until the FR965 checks pass.

### Inferences
- **Version recommendation: ship the glance as its own upload, 1.1.2, after the owner lifts "feature work waits" and after the FR965 checks pass.** Reasons: (1) 1.1.1 is already live, so bundling into 1.1.1 is not possible; (2) 1.2.0 is reserved for Connect sync in ADR-043/047/050 and go-to-market, and sync brings `Fit`/`FitContributor` permissions, privacy/support/listing copy changes and a ten-item device acceptance measured in weeks, so bundling would hold a small change hostage; (3) the glance needs no permission, storage-key, complication or manifest change, so it is the lowest-review-risk feature available; (4) ADR-046/047 (1.0.0 shipped with a device-only crash for about a day) argue for isolating a new process type in its own release so a problem is attributable and a rollback build is obvious ("Rollback build ready for the first week of a release", [go-to-market.md backlog](/Users/mbp/dev/garmin/HeroSet/docs/go-to-market.md)). The label 1.1.2 is a patch number for a feature; the alternative "1.2.0 = glance, sync becomes 1.3.0" is cleaner semver but rewrites ADR-043/047/050, `connect-sync-plan.md`, `ideas.md` and `go-to-market.md` references. Version lives only in the store form ([decisions.md ADR-047](/Users/mbp/dev/garmin/HeroSet/docs/decisions.md)); it is an owner call.
- Ship-blocking evidence for the upload, not the merge: R1 (idle after glance launch), one FR965 all-day dev-build wear with `CIQ_LOG.YAML` read afterwards ([development.md crash logs](/Users/mbp/dev/garmin/HeroSet/docs/development.md)), and the glance shown in two languages.

### Gaps
- Owner decisions not made here: whether to lift "feature work waits", version label, glance visual design, key-constant option (a) vs (b).

---

## 12. Test plan

### Takeaway
Pure logic in unit tests, layout in the per-product fit test, lifecycle and memory on FR965 with the dev build all-day per the owner's device-testing style.

### Cited Findings
- Owner device-testing style (memory note): all-day wear on the FR965, dev build only, no swaps. — `/Users/mbp/.claude/projects/-Users-mbp-dev-garmin/memory/MEMORY.md` (index entry "FR965 device testing style")
- FR965 checks already open in [go-to-market.md "Next session" B/C](/Users/mbp/dev/garmin/HeroSet/docs/go-to-market.md) and [TODO.md "Device checks"](/Users/mbp/dev/garmin/TODO.md) are the natural place to add glance rows.

### Inferences
**Unit tests (no watch):** reader vs store parity (same day), zero writes, stale day reads 0, streak alive today/yesterday and 0 the day after, month/year/leap boundary via `activeStreak`, goal default/clamp/0-as-unset, Float-stored values, missing keys; `HeroSetGlanceView.drawState` builds for widest state; existing `swapStoreForTest` still works with the lazy `getStore()`; a test that `HeroSetApp.getStore()` builds once.

**Simulator steps (per the SDK docs; GUI, owner):** Settings > Glance View on for `fr965`; check title, bars, streak line, colors at goal/no goal; check `fenix7` (63 px area) and `fr255s` (140 px); toggle to full app, confirm launch from glance shows the dashboard and Back returns to the glance; run the `-l 2` scope grep; run the fit test on the product loop and `tools/fit-sweep.sh` for languages; open the memory view in glance mode (`fr965` and one 218 px product).

**On FR965 (dev build, all-day wear):** (1) glance appears in the glance list after sideload (enable in glance settings if needed); (2) after saving a set, back at the list, the glance shows it; (3) at 00:01 the glance shows 0/0/0 without opening the app; (4) after a missed day the streak reads 0 in the glance and the dashboard; (5) select the glance: dashboard opens, Back returns to the list; (6) **R1**: launch from the glance, start a set, do reps for 60-120 s with no button press, see whether the app survives and the count is intact; (7) launch from the glance with HeroFace installed, save a set, confirm the complication still updates; (8) leave the glance list open; read `CIQ_LOG.YAML` after the day ([development.md](/Users/mbp/dev/garmin/HeroSet/docs/development.md)) for glance-process crashes; (9) battery unchanged versus a day without the glance ([battery.md](/Users/mbp/dev/garmin/HeroSet/docs/battery.md) method).

**What the simulator cannot prove:** §8 gaps (glance process memory and kill behaviour, idle timeout, refresh cadence, Storage timing between the two contexts, real fonts, MIP contrast, sideload visibility, per-language resource loading). Say so when reporting, per the repo rule "Simulator passing is not device proof". Also the 13 touch-first watches and the 17 legacy products are unverified.

### Gaps
- No glance was run on a device or in glance mode in the simulator (GUI only); no run beyond the plain unit-test runner and bitmap drawing.

---

## Appendix A: verbatim build outputs

Baseline store build, FR965 (`store.jungle`, unmodified source copy, `-w --build-stats 0`):
```
Build Stats:
  Device: fr965
  Data:
    Foreground: 7959 bytes
  Code:
    Foreground: 21605 bytes
  Extended Code:
    Page Size: 4096 bytes
    Number of Pages: 0
    Total Size: 0 bytes
  Total PRG Size: 206172 bytes
  Build Time: 2.763 seconds
BUILD SUCCESSFUL
```
`getGlanceView` added, nothing annotated:
```
WARNING: fr965: This is a 'watch-app' app type but no source code was annotated with (:glance). The entire application will be loaded as a glance process.
  Data:  Foreground: 8035 bytes
  Code:  Foreground: 21743 bytes
  Total PRG Size: 206732 bytes
```
Class-tagged prototype stages (store, FR965): `Glance: 839 / 340` (app + view only, foreground refs unresolved), `Glance: 2301 / 3383`, `2488 / 4391`, `2658 / 5063` (naive store path), final lean design `2419 / 4437` (63 products) and dev `2446 / 4459`.

Sample of the full-suite run (dev jungle, FR965, prototype):
```
Ran 103 tests

PASSED (passed=103, failed=0, errors=0)
```

Heap probe: `DEBUG (20:16): GLANCE read heap delta=240 used=78072 total=8383936 streak=1`.

## Appendix B: what was not done
- No glance-mode simulator run (GUI scripting refused), so no peak memory, no rendering check of the real system glance chrome (icon area, title).
- Fit sweep partial: 7 of 63 products drawn; fenix7s (final run) and fr265s wedged the simulator.
- Non-English rendering not run.
- I started the Connect IQ simulator for tests and shut it down at the end; no repo file was touched (`git status --porcelain HeroSet` lists only the staged pre-existing `listing/` images).
