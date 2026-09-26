# Verden code quality review (2026-09-24): findings re-verified against the current repo (2026-09-25)

Scope: `reports/Verden code quality review.md` plus the four notes in `research_notes/Verden code quality review/` (heroset_core, heroset_ui, heroface, website), all read in full. Each finding was then checked against the code at HEAD `4791782` (branch `claude/upbeat-davinci-tshykh`, working tree clean; `main` = `3edda57`, both on origin). Read-only: greps, file reads, `git log`. Nothing built or run. All paths below are under `/Users/mbp/dev/garmin/`.

Status legend: FIXED (verified in code), PARTIAL, OPEN, DECIDED (owner call, no code change), STALE (premise no longer true), N/V (not verifiable offline, needs simulator or watch).

Commit map: review fixes landed in `d34286f` (HeroSet + HeroFace source, 2026-09-24), `634a15e` (site refactor, canonical/OG, silver), `bf9224f` (review report itself), `29c034d` (folder unify, doc corrections, staged site copy), `4791782` (site twitter/og:image/JSON-LD/HSTS, screenshot sizes). The report's "Outcome" section still says "nothing is committed": that is STALE, everything listed there is now in git.

## 1. Which findings are fixed, open, stale or disputed?

### Takeaway
Of 21 HeroSet, 12 HeroFace and 15 website findings in the fix list, all are fixed or decided except: HeroFace F1 and F6 (always-on rule on original Venu, needs the simulator GUI), F12 (half done), W12 (CSP still Report-Only), W14 (screenshots), and the HeroSet items that only a watch can close. The review's own top hazard, W1 (staged "80 watches"), is resolved in substance because HeroSet 1.1.1 went live on 2026-09-24, but a new variant of it is open: the site says 80 and the store lists 66.

### Cited Findings

**Rollup by severity (as originally rated by the review)**

| Severity | Item(s) | Status now |
|---|---|---|
| High | S1 uncaught complication throw | FIXED |
| High (unverified) | F1 original-Venu 3-minute pixel rule | OPEN, simulator GUI needed |
| High (timing) | W1 staged 80-watch copy | RESOLVED (hold worked, see W1 row); a different store-listing mismatch is open |
| Med (15) | S2-S7, F2-F5, W2-W6 | all FIXED in code; S2 and F4 still need a device check; F5 has small doc residue |
| Low-Med | S8 (decided ADR-050, fixed), UI-F1 hint clipping (closed by sweep) | closed |
| Low (about 40) | S9-S21, F6-F12, W7-W15 | all FIXED except: F6 OPEN, F11/F12 PARTIAL, W12 PARTIAL (CSP), W14 PARTIAL, S20 PARTIAL (one stale count) |
| Not in fix table (notes only) | ~20 small items | mostly OPEN Low, see "Lower-ranked" tables; 1 new blind-spot item below |

**HeroSet (S1-S21)**

| # | Sev | Status | Evidence at HEAD |
|---|---|---|---|
| S1 uncaught `updateComplication` | High | FIXED | `HeroSet/source/app/HeroSetComplicationPublisher.mc:29-31` `try ... catch (e instanceof Lang.OperationNotAllowedException)`; ADR-044 last bullet |
| S2 d2airx10 START dead on dashboard | Med | FIXED in code, N/V on device | `HeroSet/source/app/HeroSetDelegate.mc:33-34` `onKey` -> `isStart ? onMenu()`. Simulator key map only; device check B3 still unticked (`HeroSet/docs/go-to-market.md:31`) |
| S3 untyped store/app/sensor members | Med | FIXED | `HeroSetStore.mc:36,37,40`, `HeroSetApp.mc:7-8`, `HeroSetSensorManager.mc:6` all `as` typed |
| S4 storage seam `Lang.Object` | Med | FIXED | `HeroSetStorage.mc:12,16`, `HeroSetPersistentStorage.mc:14,18`, `HeroSetStore.mc:276` use `Storage.ValueType` |
| S5 write-failure flag cleared by later writes | Med | FIXED (catch still broad) | `HeroSetStore.mc:82,176` reset only at start of `add`/`setGoal`; `_set` (276-282) only sets true and `println`s; test `HeroSetStoreWriteTest.mc:28`; ADR-010 amended. Catch is deliberately still catch-all (documented) |
| S6 data->ui and sensor->ui upward deps | Med | FIXED | `HeroSetDashboardState.mc` now in `source/data/`; `HeroSetActivitySync.open(name, reps)` takes strings (`HeroSetActivitySync.mc:42`); no `HeroSetText` in `source/sensor/` |
| S7 architecture.md drift | Med | FIXED | `architecture.md:3,50-55,163,197`; layer sentence at :88 rewritten |
| S8 Back gate vs saved count | Low-Med | DECIDED + FIXED | ADR-050; `HeroSetWorkoutDelegate.mc:40-48` gates on `getCount()`; test `backLeavesWhenTheOnlyRepIsDropped` |
| S9 picker delegates ~90% identical | Low | FIXED | `source/ui/HeroSetPickerDelegate.mc`; test `pickersDispatchCommitToTheirView` |
| S10 untyped `_view` in delegates | Low | FIXED | all 7 delegate `_view`s typed (grep) |
| S11 goal save logic in view | Low | FIXED | `HeroSetSaveFeedback.saveGoal` (`HeroSetSaveFeedback.mc:64`), called `HeroSetGoalPickerView.mc:45` |
| S12 TODAY row fixed font | Low | FIXED | `HeroSetWorkoutView.mc:217-222` measured; ADR-049 bullet |
| S13 complication label key | Low | FIXED | `strings.xml:81` `translatable="false"` + comment; ADR-044 amended (10 fields, label is key, non-negative); HeroFace header `HeroFaceContract.mc:3-5` |
| S14 `savedDay` narrowing | Low | FIXED | `HeroSetStore.mc:57` `asNumberOrNull` |
| S15 sensor start failure silent | Low | FIXED | `workout_no_sensor` string, `HeroSetWorkoutView.mc:233`; `input-and-ux.md:23` |
| S16 two untyped params | Low | FIXED | `HeroSetRules.mc:96`, `HeroSetSensorManager.mc:11` |
| S17 goal exit test + log format | Low | FIXED | `HeroSetExitMenuTest.mc:25-29`; `HeroSetStore.mc:237` `format("%04d")` |
| S18 `prepare()` length, test file budget | Low | FIXED (trivial drift) | `HeroSetMenuDelegate.mc:18-46` split into `stampSync`/`stampProgress`; `architecture.md:188` says test file 377 lines, it is now 378 |
| S19 stale ADR/comment refs | Low | FIXED | ADR-010/044 read correct; no `ADR-029` in `HeroSetMissionBars`; publisher comment names `resources-complications/` |
| S20 test counts | Low | PARTIAL | `HeroSet/CLAUDE.md:18`, `README.md:21`, `docs/development.md:37`, `CHANGELOG.md:21` say 99/88, but `HeroSet/docs/go-to-market.md:9` still says 94/85 (open item D1, `go-to-market.md:39`). Static grep of `(:test` gives 104 including 5 helper annotations, consistent with 99 but not proof; only the runner's `PASSED` line counts |
| S21 fit-sweep tooling | Low | FIXED | `HeroSet/tools/fit-sweep.sh`; `docs/development.md:35` |
| UI-F1 hint clipping in translated SWIPE hints | Med (unverified) | STALE/closed | Review itself says the sweep showed every hint fits in 15 languages. `HeroSetDraw.hint` (`HeroSetDraw.mc:52-59`) still has no fallback wording by design; `fit-sweep.sh` is the gate |

Lower-ranked HeroSet items that were in the notes but not in the fix table:

| Item | Status | Evidence |
|---|---|---|
| Save pipeline split over View / SaveFeedback / app (proposed `HeroSetSaveFlow`) | OPEN, Low, "only if touched" | not created |
| `schema` written on every store construction | OPEN, Low | `HeroSetStore.mc:46` |
| `getLastCompletionDay()` not reused | OPEN, Low | inline reads at `HeroSetStore.mc:129,195` |
| Store section headers (empty "Garmin Connect sync" header, sync methods under "Daily goal", retired-key comment above `VALIDATION_LOG_KEY`) | OPEN, Low | `HeroSetStore.mc:24-34,159-180` |
| `lapReps` public static | OPEN, trivial | `HeroSetSyncCoordinator.mc:109` |
| Storage read volume per save (~55 getValue) | WATCH, unmeasured | ADR-046 watchdog history; no device profile |
| Non-atomic XP write | ACCEPTED | ADR-002 ordering must not change |
| `FIT_STEP_PX` shared constant (two `2` literals) | OPEN, Low | `HeroSetDraw.mc:70`, `HeroSetLayout.mc:165` |
| Font ladder `[SMALL,TINY,XTINY]` written 4 times | OPEN, Low | `HeroSetDraw.mc:67`, `HeroSetRankHeader.mc:17`, `HeroSetMissionBars.mc:69`, `HeroSetManualPickerView.mc:130` |
| Resource loads per frame (`dashboard_streak_none`, validation-log hint) | OPEN, Low | `ui/dashboard/HeroSetView.mc:75`, `ui/diagnostics/HeroSetValidationLogView.mc:54` |
| Other fixed-font rows (picker `DETECTED` XTINY, delta LARGE, `NO STREAK YET` single candidate) | OPEN, Low (English-only coverage in the test) | `HeroSetManualPickerView.mc:109,113`; `HeroSetView.mc:75` not re-inspected for `firstFitting` |
| `missionComplete` computed twice per frame in `onUpdate` | OPEN, cosmetic | `HeroSetView.mc:83,97` |
| Goal exit menu title reuses toast string | OPEN, cosmetic | `HeroSetGoalPickerDelegate.mc:29` |
| `previousPageStep()` direction never asserted per product | OPEN, Low | `HeroSetInputTest.mc` has only the onSelect and Back tests |
| Untyped `private var` members in views/layout | OPEN, Low-Med (F4 partial) | 38 untyped `private var _x;` remain: WorkoutView 15, ManualPickerView 9, GoalPickerView 6, HeroSetLayout 5, DayTracker 2, HeroSetView 1 (static grep). The `-l 3` count was never re-run |
| Portuguese `RANK $1$` = English loanword | OPEN, needs native speaker | `resources-por/strings/strings.xml:29,76`; pending item B4 lists only deu/lit/pol |
| ADR-048 `onKey` commit path has no automated test | ACCEPTED limitation | `KeyEvent` has no public constructor (SDK); needs FR965 on-wrist check B1 |
| Render-time Storage write at midnight (question handed from UI reviewer to data reviewer, never answered) | OPEN, Low, review blind spot | `HeroSetView.mc:25` `onUpdate` -> `getDashboardState()` (`HeroSetStore.mc:140-141`) -> `ensureCurrentDay()` -> on a day change `_set(DAY_KEY)` + `resetDailyState()` (`:56-70`, 7 writes). First frame after midnight writes Storage from `onUpdate` (breaks "render only in onUpdate"); a failed write there sets `_writeFailed` from a draw callback. Also in `ManualPickerView.drawToday` via `getCount` (`:77`). Not a defect today; fix is a read-only accessor or doing the roll-over in `HeroSetDayTracker` / `onStart` |
| Native exit-menu order (Save first in picker menu) | DECIDED | ADR-050: keep; revisit on mis-tap report |
| Swipe up = +1 direction | DECIDED | ADR-050: keep |

**HeroFace (F1-F12)**

| # | Sev | Status | Evidence at HEAD |
|---|---|---|---|
| F1 original-Venu 3-minute pixel rule | High, unverified | OPEN | `HeroFace/source/HeroFaceSleep.mc:14-19` unchanged: dx moves every minute, dy every 3 minutes, +-4 px (`HeroFaceConfig.mc:52-53`), `FONT_NUMBER_MEDIUM`. `HeroFace/docs/compatibility.md:53-55` now states the sleep screen is "unchecked" against the rule; `HeroFace/docs/go-to-market.md:14` item 6 lists the heat map. SDK FAQ quote and menu path re-verified (see below) |
| F2 nullable `complicationId` | Med | FIXED | `HeroFaceLink.mc:29-43` null guard plus `try`; `exitTo` also in `try` |
| F3 dead "HeroSet" mode | Med | FIXED | `settings.xml` lists only values 0 and 1; `MODE_HEROSET` removed; stored 2 reads as Auto (plan.md:80); Connect display for such a user unchecked (go-to-market item 4) |
| F4 link found only at start | Med | FIXED in code, N/V on device | `HeroFaceView.mc:75-76` calls `_link.start()` each minute while unlinked (inside the `onUpdate` path); battery/watchdog cost of `getComplications()` per minute unmeasured |
| F5 doc drift | Med | MOSTLY FIXED | `compatibility.md:50` now "Only the FR965 has run it"; plan.md status dated 2026-09-24, accents "three choices", mode list correct. Residual: `plan.md:31` "smallest 64 KB" (corrected at :143 but not at :31), `plan.md:89` still names `Dc has :setAntiAlias` (unused), `plan.md:164` "What's next #1 device run ... blocks everything else" already done, `go-to-market.md:52` header "Everything below is unknown until the face runs on the FR965" |
| F6 always-on chosen from one flag | Low | OPEN | `HeroFaceView.mc:35,61` unchanged |
| F7 rank wording never rendered / stale test state | Low | FIXED | `HeroFaceTestStates.mc:39` empty `streakLines` in `fresh()`, `:53` uses translated `rank_streak`/`rank_only` |
| F8 dead code, duplicate goal const | Low | FIXED | no `MINUTES_PER_HOUR`, `displayRadius`, `DEFAULT_GOAL` left; `getInitialView` returns delegate unconditionally |
| F9 settings keys literals | Low | FIXED | `HeroFaceConfig.mc:56-60` |
| F10 Fahrenheit truncation | Low | FIXED | `HeroFaceReadings.mc:63-71` `Math.round` |
| F11 seconds box, slot re-resolve | Low | PARTIAL by decision | `HeroFaceClock.mc:20-21` measures "88" and "00"; slots still resolve at start/settings change only (declared unnecessary) |
| F12 test gaps | Low | PARTIAL | negative-field test added (`HeroFaceLogicTest.mc:154`); settings-fallback test skipped (claim: Properties rejects wrong types); no tests for link uninstall, `dayKey`, sleep offsets, metric chains |

Other HeroFace notes items: sleep screen and `onPartialUpdate` bypass `HeroFaceDraw.text`, so fit tests never cover them (also `reports/Improvements backlog.md` item 1; OPEN). Header comment in `HeroFaceSleep.mc:5-7` says the block "steps across a 3 x 3 grid once a minute", which overstates: only x moves each minute (OPEN, wording). Peak memory on a 96 KB product and partial-update cost still unmeasured (go-to-market gate 4, OPEN). Lenient `String.toNumber` and uninstall-path behaviour on device: unverified (OPEN, low). HeroFace 1.0.1 (carries F2/F3/F4/F10) is recorded as uploaded 2026-09-24 but the store API still served 1.0.0 at the 2026-09-25 check (`HeroFace/docs/go-to-market.md:19,21`).

**Website (W1-W15)**

| # | Sev | Status | Evidence at HEAD |
|---|---|---|---|
| W1 staged "80 watches" before store build | High (timing) | RESOLVED; the hold worked. Separate mismatch OPEN | HeroSet 1.1.1 live 2026-09-24 15:32 UTC = 18:32 +0300 (`HeroSet/CHANGELOG.md:7`, go-to-market:14). The 80-count reached `main` in `29c034d` at 23:53 +0300, i.e. after the store build was live, exactly as the review prescribed. What is open is different: the store API lists 66 of the 80 uploaded products (`HeroSet/docs/go-to-market.md:46`, "store-side device policy") and 69 of HeroFace's 117 while the site says 117 (`HeroFace/docs/go-to-market.md:19`). Decision C1 ("what does the site's 80 mean") still open |
| W2 simulator overclaim (HeroFace) | Med | FIXED | `heroface/Landing.tsx:79`, `Support.tsx:66` say "every screen size passes". Wording is clumsy ("passes each screen check") but not an overclaim. HeroSet Landing:87 keeps "every other model passes" (true: per-product runs) |
| W3 "no tapping"/goal wording | Med | FIXED | `heroset/Landing.tsx:15,44,68` |
| W4 `.hero__reps` in band | Med | FIXED | `.band__figure` exists (`global.css:203`) |
| W5 course grid | Med | FIXED | `global.css:207-211` `grid-auto-flow: column` |
| W6 canonical/OG/sitemap | Med | FIXED | `entry-server.tsx` emits canonical, og:*, twitter:*, JSON-LD; `sitemap()`; `public/robots.txt`; `prerender.ts:13` writes sitemap |
| W7 `fill()` `$&` | Low | FIXED | `vite.config.ts:29-33` function replacers. `prerender.ts:3` still imports `fill` from `vite.config.ts` (coupling noted in review, not changed) |
| W8 duplicated sections | Low | FIXED | `components/AppSections.tsx`, `Doc.tsx:22 PrivacyTail` |
| W9 route strings | Low | FIXED | `src/urls.ts` `appUrl` used by Shell, AppPage, AppSections, entry-server |
| W10 focus ring on note/truth | Low | FIXED | `global.css:117-120` |
| W11 hover motion gating | Low | FIXED | `global.css:132-135` |
| W12 CSP / Permissions-Policy | Low | PARTIAL | `firebase.json`: Permissions-Policy on, HSTS explicit (no includeSubDomains), CSP is `Content-Security-Policy-Report-Only`; enforcement needs a deploy-preview console check (HeroSet go-to-market C2). Report-Only with no report endpoint only logs to the browser console |
| W13 titles | Low | FIXED | `app.ts` per-app `title`; support/privacy titles carry ` · Verden` |
| W14 HeroFace screenshots | Low | PARTIAL | `heroface/facts.ts:31-32` declare `size: 240` (honest dimensions, still soft at 454 px); "Always on" slot still `Screenshot pending` (`:34`) |
| W15 misc | Low | FIXED | ternary gone (`FacePreview.tsx:12`), `@types/node ^26.6.2`, README HeroFace section, favicon three bars, family list has Chronos and Legacy |

Design/owner decisions: WCAG 2.2.2 pause control resolved by making each hero counter run <5 s (starts 97/96/98, `heroset/Landing.tsx:34-36`); HeroFace blue vs studio blue resolved by re-keying studio to Munich silver and adding `heroface-*` tokens (`DESIGN.md:15,150`); favicon; exit-menu order. Other site notes: Cyrillic `Українська` falls back to a system font (no Cyrillic subset exists in `@fontsource-variable/archivo`; `reports/Improvements backlog.md` item 4 recommends documenting it as a deliberate choice, OPEN as a doc line); `noUncheckedIndexedAccess` off (optional); react/react-dom could be devDependencies (cosmetic); dev serves `/x/support` without redirect while prod 301s (harmless).

### Inferences
- Static fixes are essentially complete; the residue is (a) things needing the simulator GUI or a watch, (b) owner decisions about public claims, (c) low-value hygiene the review itself said to do "only if touched".
- The report's own limit stands: every "FIXED" above is verified from code and the recorded simulator evidence, not on a device. HeroSet 1.1.1 shipped with device checks deferred by owner call (`HeroSet/docs/go-to-market.md:51`, ADR-050), so S2, the ADR-048 `onKey` path and touch behaviour on 13 products are live but unverified on hardware.

### Gaps
- I did not rebuild or re-run `-l 3`, the sweeps or the tests; counts (99/88, 16/16) are from docs.
- Store device counts (66/80, 69/117) are quoted from the 2026-09-25 store-API check recorded in the go-to-market files, not re-fetched.
- `HeroSetView.mc` `NO STREAK YET` fit handling and the current `-l 3` error total were not re-inspected.

## 2. What is still worth doing, ordered by value and effort?

### Takeaway
Do the two zero-code checks first (Screen Heat Map on `venu`; site vs store device-count wording), then the owed device checks, then a small doc/hygiene batch. Typing view members and the save-flow refactor are optional.

### Cited Findings (ordered)

| Rank | Item | Effort | Why it ranks here |
|---|---|---|---|
| 1 | HeroFace F1/F6: run simulator File > View Screen Heat Map on `venu`, `venud`, `d2air` (menu enabled only on devices with screen protection) and one product per AMOLED size for `requiresBurnInProtection` | ~30 min GUI | Only unmitigated store-visible risk: system blanks the screen on the original Venu; the FR965 night proves nothing about that rule. If it trips: step both axes every minute over a larger grid, thinner font, or mask (F1 fix list) |
| 2 | Site device counts vs store listing (HeroSet C1, HeroFace item 7): "80 watches" and "117 watches" vs 66 and 69 listed | 15 min copy + owner decision | Not the W1 timing problem: the products were uploaded, the store omits some (store-side policy, Garmin question A4). Options in C1: say "manifest count" or "N in the store today, see Compatible Devices". Store listings link these pages |
| 3 | Enforce the CSP (rename header after deploy-preview console check, HeroSet C2) | 10 min | Makes the "no third-party scripts" privacy claim mechanical; one review item still half done |
| 4 | Owed device/simulator checks: FR965 START finishes/saves (B1), `d2airx10` dashboard START and Menu2 (B3), `venu441mm` by hand (B2), HeroFace 1.0.1 relink, stored-mode-2, F to C rounding (item 4), confirm 1.0.1 is actually live | wear time | Converts the FIXED-in-simulator items into evidence; includes battery/watchdog cost of per-minute `find()` |
| 5 | Doc drift batch: `HeroSet/docs/go-to-market.md:9` 94/85, `architecture.md:188` 377 lines, HeroFace `plan.md:31,89,164`, `go-to-market.md:52`, `HeroFaceSleep.mc:5-7` comment | 20 min | Cheap and the review's central theme; test counts live in five places and one always lags |
| 6 | W14: recapture HeroFace screenshots at 454 px plus the Always-on shot (also feeds the store listing) | simulator session | Visible on a live page ("Screenshot pending") |
| 7 | Native-speaker read of 1.1.1 touch hints (deu, lit, pol) plus Portuguese `RANK` | outside help | Strings shipped unreviewed (ADR-048/049) |
| 8 | HeroFace: route sleep and `onPartialUpdate` text through `HeroFaceDraw.text` AND add harness cases (`reports/Improvements backlog.md` item 1); settings-fallback and sleep-offset tests | small | Swapping the call alone adds no coverage, because the harness never runs those paths |
| 9 | Type the ~38 remaining view/layout members; re-run `-l 3` to record the new baseline | 1-2 h | Compiler coverage on the UI; many `-l 3` errors are false positives, so do not chase zero |
| 10 | Micro-hygiene: `FIT_STEP_PX`, one font-ladder constant, cache per-frame resource loads, `getLastCompletionDay` reuse, schema write only on change, `lapReps` private, `HeroSetMissionBars` divide-by-`goal` guard (backlog item 3), dead `layout` param in `HeroFaceFooter.iconSize` (backlog item 2) | each trivial | Do only when touching the file; review itself says the churn risk exceeds the gain |
| 11 | Document the Cyrillic fallback as a design choice in `DESIGN.md` | 1 line | Owner call, backlog item 4 |

### Inferences
- Items 1-3 are the only ones where a public or store-facing outcome could still go wrong; 4 is where "fixed" becomes "proven".

### Gaps
- No estimate exists for whether Garmin will explain the missing store devices; C1 cannot be closed by us.

## 3. Root causes and durable lessons, and where they are captured

### Takeaway
One dominant root cause (docs, contracts and public copy describing a state the code or store is not in), plus a recurring platform class (things that throw, return null or differ on device), untyped members, and text-fit measured only in English. Layering held once written down. Half of the lessons are in CLAUDE.md/ADRs; the process and typing ones are not.

### Cited Findings

| Root cause | Concrete instances | Captured? |
|---|---|---|
| 1. Description drifts from reality (docs, ADRs, public copy, counts) | ADR-044 (9 fields, "id 0"), architecture.md tree/scope, HeroFace plan/compatibility/go-to-market, staged site "80 watches", test counts (94/85 vs 99/88), and ADR-044's own 2026-09-24 amendment still says "the 50 products at CIQ 4.2+; the 17 at 3.4-4.1" (`decisions.md:266`; after ADR-048 it is 63 + 17 = 80). Separate class, not a doc lag: site 80/117 vs store-listed 66/69 (store omits uploaded devices) | Partly. Root `CLAUDE.md` has "user-facing claims live in two places, update the same session" and "behaviour change -> doc same session". NOT captured: the review's key process fix, "tie public copy to the store upload it describes, not the code session" (absent from `site/CLAUDE.md:32-36` and root); it worked in practice for W1 this time by owner discipline, not by rule. NOT captured either: "device counts on the site are the store-listed count, or say manifest count", which the 66/80 gap needs. Test count lives in five places (HeroSet CLAUDE lists four; `go-to-market.md` is a fifth) and still lags |
| 2. Platform can throw or return null where the SDK says so | `updateComplication` throws `OperationNotAllowedException` (SDK Complications doc lists `OperationNotAllowedException` under Throws twice; only the `updateComplication` entry was matched to the review's claim), nullable `complicationId`, `Storage.setValue` Symbol crash (ADR-022), watchdog in an input callback (ADR-046), sensor listener binding (ADR-023) | Partly. House rule "Catch only what can throw; degrade + flag" and ADR-022/023/046. NOT captured as a checklist: "when adding an SDK call, read its Throws/nullable return; `has` guards firmware capability, not per-product resource wiring" |
| 3. Untyped members switch the compiler off where it matters | store `_storage`/`_clock`, app/sensor members, view fields; `-l 3` 197 errors; ADR-019/022 history | NOT captured. HeroSet/HeroFace house rule says "every function: typed params + `as` return type" but says nothing about members; 38 untyped members still exist. Suggest amending to "every `var` member too" |
| 4. Text fit is measured only in English, translations break on 360 px | ADR-049 (dashboard `DONE`, Dutch title, seven languages broken in live 1.1.0); hint clipping worry; HeroFace `rank_streak` never rendered | HeroSet: partly. Rule ADR-018/034/036 plus `tools/fit-sweep.sh`, referenced only in `docs/development.md:35` (not in CLAUDE.md house rules). HeroFace: NOT captured, no sweep tool; its `everyLabelFitsThisLanguage` renders only the simulator's current language (`HeroFace/docs/development.md:39`) |
| 5. Simulator is not device | ADR-046 watchdog, d2airx10 key map, `onKey` untestable (no `KeyEvent` constructor), original-Venu burn-in rule vs FR965 luminance rule (SDK FAQ), 1.1.1 shipped with device checks deferred | Yes as a principle (root and both project CLAUDE.md "say so when reporting"). NOT captured: "the first device night must cover the strictest rule per product family" (burn-in rule differs by generation); release policy for shipping with owed device checks is only an owner call (ADR-050) |
| 6. Cross-app contract by string label | HeroFace binds on `longLabel == "HeroSet"`; a translator pass could silently unlink | Captured after the fix: ADR-044 amended, `translatable="false"`, HeroFace `CLAUDE.md` contract paragraph, root cross-folder rule. Mirrored constants (palette, ring angles, `HEROSET_MAX_GOAL`) are documented by name but unenforced; still true |
| 7. Layering and single choke points | `HeroSetDraw.text`, `HeroSetSaveFeedback`, `HeroSetExitMenuDelegate`, storage/clock seams; upward deps data->ui, sensor->ui were the violations | Captured: "layers point down only, only `data/` touches Storage" (HeroSet CLAUDE.md), architecture §3. The save pipeline is still split across three presentation files (open, Low) |
| 8. Small structural bugs that build and type-check clean | CSS class reuse outside its container (W4), 4 rows in a 5-column grid (W5), specificity: `reports/Improvements backlog.md` records a live invisible store button that a static review would not catch | Not in any CLAUDE.md. Lesson: static review + build is not enough for UI; a real-browser pass caught it. Note: that bug was already fixed on `main` by `8a40cb6` (`.field a:not(.button)`, `global.css:125`); the backlog says `main`'s version wins |
| 9. Reports/outcome sections go stale immediately | Report "Outcome" says nothing committed; go-to-market "6 local commits" while origin/main is at `3edda57` | Not captured; keep one source (`go-to-market.md` "Next session") and let the report be a dated snapshot |

Durable architectural lessons worth keeping (all confirmed by the review as load-bearing, do not churn): storage and clock seams with injected fakes; flat string keys and no Symbols in Storage; `asNumber` narrowing; XP ratchet credit-before-XP; calendar-day keys; streamed swing trace and memoised threshold grid (ADR-046); `(:sync)`/`(:nosync)` twin classes; public-method `method(:onSensorData)` binding (ADR-023); `onSelect` returning false on commit screens (SDK: behavior runs first, `true` swallows the `onKey` fallback); override-dispatch exit menus (ADR-036); append-only, reject-don't-guess contract parser (ADR-045); per-minute cached face state and one minimal partial update; one build with newer APIs behind `has`; zero client JS on the site, registry-driven routes, byte-stable published URLs.

### Inferences
- The recurring mechanism is "a second place that has to be updated by hand" (docs, counts, mirrored constants, public copy). Each fix so far added a rule or a note rather than a check; a single test-count source or a claims checklist tied to store status would remove the class.
- Untyped members are the one engineering rule the house rules never stated; it explains why `-l 3` looked bad while `-l 2` was clean.

### Gaps
- Whether HeroFace needs its own ADR log: it has no `docs/decisions.md` (docs: README, compatibility, development, go-to-market, plan), although root `CLAUDE.md` says durable decisions go to "that project's docs/decisions.md". Decisions live in `plan.md` "Decisions".

## 4. Anything wrong or over-reaching on re-read?

### Takeaway
The review is accurate and conservative. A few severity or framing calls are soft, and two of its own recommendations produced follow-on cost.

### Cited Findings
- F1 (High, unverified) is well founded, not speculative. SDK FAQ (`.../doc/docs/Connect_IQ_FAQ/How_Do_I_Make_a_Watch_Face_for_AMOLED_Products.html`): on the original Venu "no pixel can be on longer than 3 mins", faces should shift "every minute", and `requiresBurnInProtection` identifies that generation; the FAQ names "File->View Screen Heat Map ... 'Screen Burn-in Simulation'" (the review's "Screen Heat Map" is correct) and says it is enabled only for devices that support screen protection. The review's stronger implicit point holds: with a thick `FONT_NUMBER_MEDIUM` stroke and only +-4 px moves, interior pixels stay lit through the whole 3-position cycle, so the concern is likely real. Still unmeasured, so "High, unverified" is the right label. The code comment in `HeroFaceSleep.mc:5-7` and go-to-market "steps every minute" both overstate (y moves every 3 minutes).
- F2 (HeroFace nullable id) was rated Med, but the review's own inference says a null id from a just-enumerated complication is unlikely; effectively a hardening item.
- S5 (write-failure flag) was Med; the review admits it bites mainly on partial failures, since a truly full flash fails every write. The fix landed but the catch is still catch-all (with logging), so the "hides programming bugs as could-not-save" half is only mitigated by the `println`.
- S3/S4 "41 of the `-l 3` errors": the notes concede many `-l 3` errors are false-positive narrowing; the count is a proxy for untyped code, not defects. Correctly caveated, but the headline "197 errors" should not be read as a to-do list.
- UI-F3 (fixed-font rows, rated Low-medium) had evidence of misfit only for the workout TODAY row (fixed in ADR-049). The picker `DETECTED ...` row and `NO STREAK YET` are translated strings and belong to the same ADR-049 risk class, so they stay OPEN Low until covered by `fit-sweep.sh`; the delta digits and dev-only validation log are not at risk.
- Blind spot: the UI reviewer asked whether `getDashboardState()`/`getCount()` write Storage at midnight from `onUpdate` and handed it to the data reviewer, who never addressed it. It does (chain in the HeroSet notes table above). Low, but it is a G4 (render-only) violation neither reviewer reported.
- W1's "hold the three files until the store build is live" was correct and was followed: the 80-count arrived in `29c034d` (23:53 +0300) after 1.1.1 went live (18:32 +0300), though it rode in a chore commit ("unify structure") rather than a labelled site push. The review could not foresee that the store would list only 66 of the 80 uploaded products; the follow-on 80-vs-66 mismatch is a store-policy issue, not a failure of the hold.
- Review claim "Only `HeroSetPersistentStorage` touches Storage" is true for HeroSet only; HeroFace uses `Application.Storage` directly (`HeroFaceLink.mc`, `HeroFaceStreak.mc`), which the HeroFace notes cover separately (`-l 3` flags `HeroFaceStreak.mc:36`). Not an error, just scope.
- W12 CSP suggestion: shipped as Report-Only with no `report-to` endpoint, so violations are visible only in a browser console; enforcement depends on a manual step, and `Improvements backlog.md` chose not to take the enforced `'unsafe-inline'` variant. Sound.
- F4 fix (retry `find()` per minute) was applied inside the render path (`HeroFaceView.frameFor`), against the house rule "render only in onUpdate; logic elsewhere", and repeats `registerComplicationChangeCallback` if `subscribeToUpdates` keeps throwing. Small, my own observation from re-reading, not in the review; cost unmeasured.
- The `reports/Improvements backlog.md` claims a "CRITICAL invisible store CTA on `main`". At review time the fix `8a40cb6` (2026-09-24 19:02) was already in the tree the reviewers read, so the review did not miss it; the backlog was written on a stale branch and says `main` wins.

### Inferences
- Nothing in the review looks fabricated. Its weakest spots are severity ordering of several Lows and the fragility of "hold the staged files" as a control.

### Gaps
- Whether original Venu firmware really trips on a +-4 px walk is unknown until the heat map is run; that is F1 itself.
- I did not check native Menu2 START behavior on `d2airx10`, or whether `onKey` and `onSelect` can both fire on any product.
