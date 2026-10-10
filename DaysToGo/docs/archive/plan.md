# Days To Go: implementation plan

Written 2026-09-26 for implementer agent with none of this conversation's context. Follow literally. **[OWNER]** = stop, tell owner exactly what needed, wait: needs person, phone, watch or decision only owner can make. **[GATE]** = next phase depends on result.

Product defined in [`spec.md`](../spec.md); evidence in [`reports/Countdown face research.md`](../../../reports/Countdown%20face%20research.md) and `research_notes/Countdown face research/`. Verified first-draft logic phase 1 copied from superseded by [`../source/`](../../source) and [`../tools/`](../../tools); where plan says `docs/reference/`, means that draft. Read spec, report, notes first.

## Implementation status (2026-09-26)

| Phase | State |
|---|---|
| 0 Owner decisions | Name, price, date style decided. Languages (English + 14), category (Utility), "one number" look: taken as recommended, **owner has not explicitly approved them** |
| 1 Skeleton | Done (folder renamed to `DaysToGo/`) |
| 2 Settings and plain face | Done, merged with phase 4; beta tooling done (`tools/make_beta.py`); memory measured: 28% (fēnix 6 Pro), 33% (FR55) |
| 3 Phone and watch round trip | **Not done. Owner-only, on FR965. Riskiest assumption still untested** |
| 4 Real face | Done in code; **owner has not looked at it in simulator** (design gate open) |
| 5 Screen-fit tests | Done: ten sizes pass in simulator (`tools/fit_all.sh`) |
| 6 Languages | Done, machine-drafted, unread by native speakers; not run in non-English simulator |
| 7 Docs | Done |
| 8 Listing and site | Written; images missing; site built, **not deployed** |
| 9 Device evidence and submission | Submitted 2026-09-26 without beta round trip (owner's decision); wear day and always-on night not yet reported |
| 10 After approval | Not started |

| 11 Free + Pro ladder (WP4 of `../../reports/Free and Pro ladder execution plan.md`) | **Built 2026-10-01, UNRELEASED, simulator only, proposed.** Free twin and Pro 1.1.0 compile for both jungles; **simulator tests run 2026-10-01: Pro 50 and Free 51 PASSED on fr965, fr55, venusq2; `fit_all.sh` passes on both jungles**; packages built, contents checked. Open: owner decisions (names, prices, Pro headline, icon, translations, uploads), device check. See section "Phase 11" below |

Phases 1 to 8 text below = original plan; where it says `docs/reference/` means first draft of code, superseded by `source/` and `tools/` (folder since removed). Nothing builds from it: `monkey.jungle` sets `base.sourcePath = source`.

## 0. Ground rules (they override anything below if in conflict)

1. **Do not stage, commit, stash or reset.** Git index mixed staged/unstaged, belongs to owner. Leave everything in working tree; end each phase by listing files created or changed.
2. **Signing key** is `~/.garmin-connectiq/keys/developer_key`, outside repo. Never copy in, never commit any `.der` or `.pem`. Project `.gitignore` (phase 1) copies HeroFace's.
3. **Simulator passing is not device proof.** Every report says, per watch product, what ran in simulator and what (only owner's FR965, only after phase 3) ran on wrist. MIP contrast, battery, always-on ghosting, phone settings delivery stay "unverified" until owner's tests say otherwise.
4. **Behaviour change → update doc describing it same session. Durable decision → ADR** in `docs/decisions.md` (list in phase 7). User-facing claims live in two places: listing and `site`; change both together, never change or remove published URL.
5. **Code rules** (from `HeroFace/CLAUDE.md`, mirrored): every function has typed parameters and `as` return type; no `as Any`; cast only after `instanceof` or null guard; no magic numbers (tunables and keys in `DaysToGoConfig`, geometry in `DaysToGoLayout`, colours in `DaysToGoPalette`, words in `strings.xml`); text fit measured, never guessed; render only in `onUpdate`, gather data in `DaysToGoReadings`, draw from `DaysToGoState`; one class per file with `DaysToGo` prefix; functions ≤ about 30 lines, files ≤ about 250; comments explain why; property key spellings never change once shipped.
6. **Forbidden in this app** (each hurt a rival or wearer; research notes say why): `type="date"` settings; `numeric` settings with min/max; `Time.Moment` arithmetic for day counts; `Application.Storage` (Properties only); any manifest permission; bitmaps or per-device resources; network; notifications or heart-rate/weather/complication features; seconds.
7. **Build with warnings and strict typing on**, keep at zero: `-w --typecheck 3`.
8. **Trust printed `PASSED (…)` line, not exit code.** Simulator wedges every few runs; `tools/run_tests.sh` restarts once. Run printing nothing = wedged, not failed.
9. **Do not invent evidence**: no reviews, downloads, screenshots, battery figures or accuracy claims in any doc or listing.
10. **Edits outside `DaysToGo/` limited to**: root `CLAUDE.md` project table (one row), root `README.md` layout note if it lists projects, `site/` (phase 8 only). Ask before touching `HeroSet/` or `HeroFace/`. Copy from `HeroFace/source/` at commit `df7619f`; do not import from it.

**Never decide alone**: store name, price, visual identity, launcher icon, any Connect IQ store upload (beta or release), any phone or watch test, site deploy, shipping machine translations no native speaker has read.

## 1. Where things are

```
Countdown/  (rename to DaysToGo/ once the name is confirmed; use `mv`, it is untracked)
  docs/spec.md  docs/archive/plan.md  ...            docs (see docs/)
  source/*.mc  source/test/*.mc  source/settings/*.mc   the app (was docs/reference/ in the original plan)
  tools/gen_settings.py  tools/run_tests.sh  ...        generators and test runners
```

Reference for HeroFace patterns to copy (adapt names and geometry, do not depend on them): `HeroFaceLayout.mc` (proportional rows, circle chord insets, ring sweep), `HeroFaceDraw.mc` (measured text, `firstFitting`), `HeroFaceText.mc` (cached string loading), `HeroFaceSleep.mc` (always-on grid shift), `HeroFaceReadings.timeText` (12/24 h), `HeroFaceSettings.mc` (Properties read with fallback), `HeroFacePalette.mc`, `source/test/HeroFaceScreenFitTest.mc` (`everyStateFitsThisDisplay`), `docs/development.md` (commands, translation parity script), `listing/` (form fields, generators).

## 2. Phases

Effort figures = estimates, not measurements.

### Phase 0. Owner decisions [OWNER]

Ask five things in one message; record answers as ADRs (phase 7). Recommended answers bold; nothing in phases 1 to 3 depends on them except folder name.

1. **Price**: **decided 2026-09-26: paid $1.99 first, one review 45 days after approval on whether to flip to free once, never back.** (Owner's idea of alternating free and paid weeks in secret advised against: `spec.md` "Price".) Record as ADR-002 with flip rule and funnel hypothesis. Nothing to ask. Confirm once, showing risk in `spec.md` "Price" (15 paid countdown faces, all at 10 downloads or fewer; free leaders at 10,000 to 100,000). Only phase 9 depends on it.
2. **Name**: **Days To Go**, confirmed by owner 2026-09-26 (store search by eye and trademark search still owner's). Fixes folder, code prefix, site slug (`days-to-go`); **slug permanent once published**.
3. **Languages**: **English + HeroFace's 14** (dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr); add Russian, Greek, Chinese?
4. **Category**: **Utility** (or Simple).
5. **Visual identity**: approve "one number" direction and accent set in `spec.md`, or provide design (phase 4 gate).

If name changes later, rename mechanical: folder, class prefix, `strings.xml` AppName, site slug. App id never changes.

### Phase 1. Project skeleton and verified logic (≈ 0.5 day)

Create in project folder:

- `CLAUDE.md` (fast facts, house rules above, "Keeping things in sync"), `README.md`, `PRODUCT.md`, `CHANGELOG.md` (`Unreleased` heading), `.gitignore` (copy `HeroFace/.gitignore`, ignores `/bin/ /gen/ /mir/ *.prg *.iq` and key files).
- `monkey.jungle` containing `project.manifest = manifest.xml`.
- `manifest.xml`: copy `<iq:product id="…"/>` lines from `HeroFace/manifest.xml` (117 round products; script it: `grep '<iq:product' HeroFace/manifest.xml`); `type="watchface"`, `entry="DaysToGoApp"`, `launcherIcon="@Drawables.LauncherIcon"`, `minApiLevel="3.0.0"`, **new app id** (`uuidgen | tr A-Z a-z`; never changes), `<iq:permissions/>` empty, language list from phase 0 question 3 answer.
- `resources/drawables/drawables.xml` and `launcher_icon.svg` (copy HeroFace's as placeholder; **[OWNER]** supplies real icon before phase 9).
- `source/`, `source/test/`, `tools/`: copy from `docs/reference/` (`cp`, not `mv`); **not** `source/settings/` yet: those files use strings existing only after phase 2, every source file compiled. If name changed, rename `DaysToGo` prefix in file names and code.
- Minimal `DaysToGoApp.mc` (extends `Application.AppBase`; `getInitialView` returns `DaysToGoView`; `onSettingsChanged` calls `WatchUi.requestUpdate()`) and `DaysToGoView.mc` that only clears screen. No `getSettingsView` yet.

Commands (from project folder):

```sh
KEY=~/.garmin-connectiq/keys/developer_key
monkeyc -d fr965 -f monkey.jungle -o bin/DaysToGo.prg -y $KEY -w --typecheck 3
tools/run_tests.sh fr965
```

**Done when**: build prints `BUILD SUCCESSFUL` with no warnings except launcher-icon size notice, and `tools/run_tests.sh fr965` prints `PASSED (passed=15, failed=0, errors=0)`. Then run for `fenix6pro` and `venu2s`. Add project row to root `CLAUDE.md` table. If folder renamed from `Countdown/`, also fix every `DaysToGo/docs/...` link in `reports/Countdown face research.md`, `research_notes/Countdown face research/` and `docs/` (grep `Countdown/`).

### Phase 2. Settings and a plain, working face (≈ 1 to 1.5 days)

Goal: **correct but ugly** face carrying every setting, so phone and watch round trip testable on real watch before design work. Do not polish.

1. Add **Date style** list setting to `tools/gen_settings.py` (property `DateStyle`, values 0 Automatic, 1 Day first, 2 Month first, default 0; entries `datestyle_auto|day|month`; add ids to `hand_ids()`) and constants to `DaysToGoConfig`, then generate resources: `python3 tools/gen_settings.py` writes `resources/settings/settings.xml`, `properties.xml`, `resources/strings/generated.xml`. Run `python3 tools/gen_settings.py --ids`, define every printed id in `resources/strings/strings.xml` (English) plus `AppName`, `settings_title`, `menu_set_date`, Date style words `setting_datestyle`, `datestyle_auto`, `datestyle_day`, `datestyle_month`, and face's own words: `cap_day`, `cap_days`, `cap_weeks`, `cap_hours`, `cap_since_day`, `cap_since_days`, `cap_today`, `cap_invalid`. Captions = **labels, not sentences**, so Polish, Lithuanian, Ukrainian, Finnish need no plural agreement; singular only for exactly 1.
2. `DaysToGoSettings.mc`: reads each property with fallback (pattern of `HeroFaceSettings.number()/read()`, catching `InvalidKeyException`), **validates**: month outside 1 to 12 → 1, day outside 1 to 31 → 1, year not 0 or plausible calendar year → 0, raw hour setting outside 0 to 24 → 0 (all day; setting stores 0 = all day, 1 to 24 = 00:00 to 23:00, never negative, `DaysToGoEvent.hourFromSetting` converts), unknown event → New Year, name truncated to 16 characters. Expose static `fromValues(...)` so tests feed bad values without Properties. Tests: bad, missing, wrong-typed values all yield defaults.
3. `DaysToGoState.mc` and `DaysToGoReadings.mc` (date line built by pure `DaysToGoDateText.lines(dayOfWeek, day, month, year, monthFirst, showYear)` with unit tests for both orders and year rule; **not in `reference/`**, write with tests first; `monthFirst` comes from Date style setting, Automatic = language English and `System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE`): `take(settings) as DaysToGoState` builds event with `DaysToGoEvent.fromSettings` (pass **raw** Hour property; converts internally), calls `DaysToGoCountdown.resolve(event, DaysToGoLocalTime.now())`, turns result into words (hero string, caption, name, date line, time text). Date line formats a Moment from target y/m/d with `Gregorian.utcInfo(moment, Time.FORMAT_MEDIUM)`; keep reference test `targetDateFormatsWithoutShift`. Weeks mode: hero = `days / 7`, extra line `+ n DAYS` from `days % 7` (omit when 0). Hours state: `H:MM` from `seconds`. **Invalid result never builds Moment or date line**: shows only SET A DATE words (phone's Day list offers 31 for every month, impossible dates easy to save).
4. `DaysToGoView.mc`: draw state as five plain centred text lines with system fonts (no layout work). Must never throw: null or unexpected state draws "?".
5. Settings on watch: copy `docs/reference/source/settings/*.mc` into `source/settings/` (strings `settings_title`, `menu_set_date`, `year_every`, `month_1` to `month_12` exist after step 1), then `getSettingsView()` in `DaysToGoApp` returning `[new DaysToGoSettingsMenu(), new DaysToGoSettingsDelegate()]`. Picker column order follows Date style (day-first: Day, Month, Year). Picker year range from `DaysToGoConfig.PICKER_FIRST_YEAR/PICKER_LAST_YEAR`, must match `FIRST_YEAR/LAST_YEAR` in `tools/gen_settings.py`. Guard `getSettingsView` so exception cannot crash face.
6. **Do not cache settings across updates.** Read them (`DaysToGoSettings.load()`, about nine Properties reads) at start of every `onUpdate`, runs once a minute in low power; call `WatchUi.requestUpdate()` from `onSettingsChanged` and picker delegate. Nothing found shows `Properties.setValue` from on-watch picker triggers `onSettingsChanged`, so re-reading in `onUpdate` makes picked date appear at once.
7. **Beta build tooling**: `tools/make_beta.py` copies `manifest.xml` to `manifest-beta.xml` with app id replaced by fixed second UUID (create once with `uuidgen`, store in `tools/beta-app-id.txt`, keep tracked and not ignored so owner's next commit picks it up; not a secret), writes `beta.jungle` (`project.manifest = manifest-beta.xml`). Add both generated files to `.gitignore`. Export with `monkeyc -e -r -f beta.jungle -o dist/DaysToGo-beta.iq -y $KEY`. Confirm beta and production manifests differ **only** in id.

**Done when**: builds (strict, zero warnings) for `fr965`, `fenix7`, `fenix6pro`, `fr55`, `fr265s`, `venu2s`; all tests pass on `fr965` and `fenix6pro`; **memory read from normal (non-test) run**: temporarily print `System.getSystemStats()` in `onUpdate`, run `monkeydo bin/DaysToGo.prg fenix6pro` (and `fr55`, 96 KB class), record `usedMemory` against `totalMemory`, remove print. Target: used ≤ 30% of total at this stage. Update `docs/development.md` with what ran. **Output of this phase = beta build.**

### Phase 3. Phone and watch round trip on a real watch [OWNER] [GATE] (≈ 1 day elapsed)

Riskiest assumption in project, cheapest to test now. Why: rivals' worst failure was entering date; fix (lists, on-watch picker) designed but never run on hardware.

Owner steps: export beta (`dist/DaysToGo-beta.iq`), upload at developer dashboard with **Beta App** checked (SDK `Core_Topics/Beta_Apps`; beta has own store id, visible only to owner's account), install on FR965 from "uploaded apps" in Connect IQ app, set as watch face. Record every result in `device-test/DaysToGo-CHECKLIST.md` (folder git-ignored, only record of session; follow owner's all-day-wear habit: this app only face worn that day).

| Test | Steps | Pass looks like |
|---|---|---|
| T1 Default | Install, set as face, change nothing | Shows countdown to next New Year's Day, correct day count, no empty state |
| T2 Phone date | In Connect: Event = My own date; set Month, Day, Year (date 10 days away) | Within about a minute face counts right days. **Close and reopen settings screen: values still what was chosen** (not blank, not January 1970) |
| T3 Phone unrelated change | Change only Accent (or Bottom line) | Date unchanged afterwards |
| T4 On-watch picker | Watch: Customize → Set date → pick different date | Face updates at once. **Then record**: does Connect show new values? If you now change Accent in Connect, does date revert to old phone value? |
| T5 Reboot | Restart watch | Date and event survive |
| T6 Name | Set Name to 16 wide letters, then Greek/Cyrillic/CJK text, then empty | Fits or truncates cleanly; unsupported glyphs noted; empty hides row |
| T7 Timed event | Time of day = hour later today | Shows `H:MM` hours left; "TODAY" once hour passes |
| T8 Midnight | Event = tomorrow, wear through midnight | Flips from "1 DAY" to TODAY at 00:00 local |
| T9 Time zone | Change phone's time zone by several hours | Count does not change except at local midnight |
| T10 Other route | If available: set date with Garmin Express and, separately, Android | Same result as T2 |

**On-watch coverage**: SDK lists `getSettingsView` support for 94 of HeroFace's 117 products by name match; 23 not listed = older CIQ 3.x products (D2 Charlie/Delta family, Descent Mk1, vívoactive 3 family, FR645/935, fēnix Chronos, Approach S62) and newest (fēnix 9 family, FR70, FR170). There phone only route, so listing and support page must say "set it in the app; on many watches also on the watch", never promise watch route everywhere; phase 3's T4 result on FR965 says nothing about others.

**Decision after T4 [GATE]**: if on-watch picker and phone never destroy each other's values, keep both, add "set it on the watch or in the app" to support text. If phone silently overwrites watch's values, or reverse, choose: (a) keep on-watch picker, document "the last change wins", (b) drop picker (delete `source/settings/` and `getSettingsView`), record as ADR-005 (on-watch picker). If T2 fails (phone lists lose values), on-watch picker becomes primary way: escalate to owner before phase 4.

### Phase 4. The real face (≈ 2 to 3 days)

Precondition: phase 3 recorded, visual direction approved (phase 0 question 5). **[OWNER] design gate**: owner may replace direction in `spec.md` with mock-up from design tool; if so, follow mock-up, update `spec.md` and `DESIGN.md`.

Build, adapting named HeroFace files (rename, simplify, keep ideas):

- `DaysToGoLayout.mc` (from `HeroFaceLayout`): proportional rows from shorter screen side D, top to bottom: time, event name, hero, caption, date, optional bottom line; starting bands in `spec.md`. Keep circle **chord** maths (`leftInsetWithin`, `rightInsetWithin`) so every row checked against round screen.
- `DaysToGoDraw.mc` (from `HeroFaceDraw`): `text`, `fits`, `firstFitting` (measured with `dc.getTextWidthInPixels`).
- Hero fitting: try `FONT_NUMBER_THAI_HOT`, `HOT`, `MEDIUM`, `MILD` (then `FONT_LARGE`), take first whose width fits chord at hero band and height fits band; word hero (TODAY, SET A DATE) uses same chain on own width.
- Event name: accent colour, shrinks through fonts, then truncates with `…`; empty hides row, gives space to hero.
- `DaysToGoRing.mc` (from `HeroFaceRing`): bezel arc; sweep from share of next 365 days still to go (Upcoming), of 24 h (Hours), full (Today), track only (Past). Use HeroFaceLayout's `ringSweepFor`/`arcEndDegree` maths.
- `DaysToGoPalette.mc`: black ground, white, muted `#AAAAAA`, track `#555555`, sleep `#555555`, six accents (all channels 00/55/AA/FF, i.e. inside 64-colour palette). State never colour alone: word (TODAY, HOURS, SINCE) carries it.
- `DaysToGoSleep.mc` (from `HeroFaceSleep`): always-on = hero + time only, dim, stepping across 3×3 grid once a minute; check `System.getDeviceSettings().requiresBurnInProtection` only if adding anything static. `onEnterSleep`/`onExitSleep` request updates.
- Bottom line: battery (`System.getSystemStats().battery`) or steps (`ActivityMonitor.getInfo().steps`, hidden when null), off by default. **Value watch does not have is hidden, never faked.**
- 12/24 h from `System.getDeviceSettings().is24Hour`; no seconds; no timers; `onUpdate` once a minute enough.
- `daysToGoLayoutReport` test printing every row's box (how layout read without screenshot, as `heroFaceLayoutReport`).

**Done when**: builds strict/zero-warning for six devices of phase 2; unit tests still pass; layout report sane on `fr55` (208), `fenix5s` (218), `fenix5` (240), `vivoactive4` (260), `fenix7x` (280), `fr265s` (360), `fr165` (390), `epix2` (416), `fr965` (454), `fenix9pro51mm` (466); **memory** from normal run on `fr55`/`fenix5s`/`fenix6pro` ≤ 60% of total; owner has looked at simulator on at least `fr965` and `fenix7x` and approved look. **[OWNER]** also runs File > View Screen Heat Map on AMOLED simulator for always-on frame (environment cannot capture simulator).

### Phase 5. Screen-fit tests for every state (≈ 0.5 to 1 day)

Write `DaysToGoScreenFitTest.mc` and `DaysToGoTestStates.mc` following `HeroFaceScreenFitTest.mc`: `everyStateFitsThisDisplay` renders widest states with device's real fonts, **fails** on text outside round display or overlapping a row. States: widest date lines (`Wed 30 Sep 2026` and `Wed Sep 30 2026`, longest weekday and month words of each language); 16-character name of 16 `W`; hero values 1, 9, 99, 999, 9,999, 12,775 (largest possible: year list ends 2060), 99,999 (long-past event); every phase (Upcoming, Hours `23:59`, Today, Past, Invalid); weeks mode with `+ 6 DAYS`; bottom line battery `100%` and steps `99.9K`; always-on frame; every state in longest translation of each caption.

```sh
for d in fr55 fenix5s fenix5 vivoactive4 fenix7x fr265s fr165 epix2 fr965 fenix9pro51mm; do
  monkeyc -t -d $d -f monkey.jungle -o bin/t-$d.prg -y $KEY -w --typecheck 3
  tools/run_tests.sh $d everyStateFitsThisDisplay
done
```

**Done when** all ten pass. Update `docs/compatibility.md` with evidence table (one row per screen size, "simulator only").

### Phase 6. Languages (≈ 0.5 to 1 day)

Add `resources-<lang>/strings/strings.xml` per language answered in phase 0, ids and placeholders identical to English (use parity script in `HeroFace/docs/development.md`). Month names, ten captions, setting titles, list entries need translating; numbers do not (`generated.xml` is default resource, languages inherit: **verify inheritance in simulator by switching language on one device** before relying on it). Add `everyLabelFitsThisLanguage` test as in HeroFace, run for longest languages (German, Dutch, Finnish, Lithuanian, Ukrainian). Machine-drafted translations **not native-reviewed**: flag in `listing/NOTES.md`, ask owner whether to ship them or only English plus ones a speaker has checked. Plural agreement (21 in Polish, Lithuanian, Ukrainian) = known imperfection of label captions; say so.

### Phase 7. Documentation (≈ 1 day)

Create, mirroring HeroFace's shape: `PRODUCT.md`, `DESIGN.md` (frontmatter tokens as in `HeroFace/DESIGN.md`), `docs/decisions.md`, `docs/compatibility.md`, `docs/development.md`, `docs/release-contract.md` (claims allowed and forbidden, from `spec.md`), `CHANGELOG.md`, `README.md` (test count, layout). ADRs to write (one paragraph each: decision, why, evidence path): **001** any event, countdown-first; **002** price; **003** list settings, never `date`/`numeric`; **004** calendar-day arithmetic, no Moment maths; **005** on-watch picker (phase 3 result); **006** device set (117 round, CIQ 3.0+); **007** always-on = hero + time on shifting grid; **008** name and site slug; **009** 29 Feb every-year rule (28 Feb in common years); **010** no permissions, no `Storage`, nothing leaves watch; **011** date style setting and words-only dates. `docs/reference/` since removed; files now in `source/` and `tools/` ([`docs/decisions.md`](../decisions.md) "Reference code").

### Phase 8. Store listing and site (≈ 1 day)

- `listing/paste.md` (paste-ready, fields in form order, exactly like `HeroFace/listing/paste.md`): title (max 50), description (max 4000, plain text, first sentence carries weight, last line support URL), version, what's new, tags (only things app does), category, No answers, images, email `hello@verden.watch`. `listing/NOTES.md` holds why. **Descriptions may only state what release contract allows**; no watch count; no battery figure; no "works on X" for watch only simulator has seen. Review guidelines: no brand names, no rating manipulation, disclose refund position if paid.
- Screenshots: **[OWNER]** captures simulator or device screens; agent adapts generators in `HeroFace/listing/src/`, writes `listing/screenshots.md`. One device enough.
- `site/src/apps/<slug>/`: copy `heroface/` (landing, support, privacy pages, `facts.ts`, `app.ts`), add line in `src/apps/index.ts`, check `npm run build` writes `dist/days-to-go/index.html` (existing slugs single words; `appUrl` in `src/urls.ts` accepts hyphen), add row to app table in `site/CLAUDE.md`. Privacy page: no permissions, no data leaves watch, no account. Support page: how to set date on phone **and on watch**, Garmin Express as fallback, what "Every year" means, 29 Feb rule. Watch list may only name watches in **live** store build; before approval page carries no list, store button falls back to "Coming soon". `npm run build` must pass. **Do not deploy**: [OWNER] runs `npm run deploy` (support and privacy must be live before store submission, reviewers and users open them).

### Phase 9. Device evidence and submission [OWNER] (≈ 1 day of wear + 72 h review)

1. **Wear day** on FR965 with production-id build (all-day style: no build swaps, this app only): battery window, always-on for a night with sleep mode off (ghosting), midnight flip, day count against calendar. Record in checklist. No battery figure in listing.
2. Export: `monkeyc -e -r -f monkey.jungle -o dist/DaysToGoPro.iq -y $KEY` (as originally written was `dist/DaysToGo.iq`; Free package now `dist/DaysToGoFree.iq`, ADR-014 (Free + Pro ladder)).
3. Paste listing fields from `listing/paste.md` into https://apps.garmin.com/developer/upload. **Price**: as answered in phase 0 (default paid $1.99): choose price point in merchant flow (SDK `Monetization/App_Sales`, "Yes, through Garmin CIQ merchant account"), expect offered watch list and countries to shrink to Garmin's lists. If owner switched to free, no merchant step. Price set at submission: re-pricing approved app removes it for re-review.
4. Record publication in `CHANGELOG.md` (version, upload date, user-facing changes, ADRs) and `listing/paste.md`'s What's New (house rule for every publication).
5. Record baseline for price review: download buckets, reviews, ratings of HeroSet and HeroFace on day of submission.
6. Review takes about 72 hours; rejection names reasons.

### Phase 10. After approval

**Price review reminder**: day approval arrives, compute approval + 45 days, write "Price review due <date>" in `CLAUDE.md`, tell owner to add to memory index; then follow `spec.md` "Price review" on that date. Verify live listing page and that support and privacy URLs work; add store URL and (live) watch list to site's `facts.ts`; note new-hardware watch launches (day-one support was the one ranking lever found in research); on day 60 run success test in `spec.md` (price review at day 45 comes first).

### Phase 11. Free + Pro ladder (proposed, UNRELEASED)

Decision record: ADR-014 (Free + Pro ladder) in [`decisions.md`](../decisions.md); table of what each tier has in [`spec.md`](../spec.md) "Free and Pro". Builds against plan; owner has not signed off OD1 and OD2, so ADR-002 (price, day-45 review) still governs.

| Step | State, 2026-10-01 |
|---|---|
| Free manifest, jungle, tier-only resources and settings (`manifest.free.xml`, `monkey.free.jungle`, `resources-free/`, `resources-pro/`), generator with tier argument | Done |
| Pro-only code marked `(:pro)` with `(:free)` twins; Pro behaviour unchanged | Done (compiled; Pro `resources-pro/settings` byte-identical to old shared one) |
| Tests: 48 shared, 2 Pro-only, 3 Free-only (accent table, Unit unset, Free defaults for Pro keys, missing-key probe) | **Run in simulator 2026-10-01: Pro 50 / Free 51 PASSED on fr965, fr55, venusq2; `fit_all.sh` (fr55 fenix5s fenix5 vivoactive4 fenix7x fr265s fr165 epix2 fr965 fenix9pro51mm) passes on both jungles.** Free memory not measured separately; nothing on a wrist |
| Compile sweep, both jungles, every manifest product | **Run 2026-10-01, compile only: 120 of 120 products pass on each jungle** (`tools/compile_sweep.sh`, `bin/compile-sweep-*.txt`); 108 per jungle carry only known launcher-icon size notice, other 12 warning-free. Normal builds only (test builds compiled on fr965, fr55, venusq2, venux1) |
| Packages `dist/DaysToGoFree.iq` (Free), `dist/DaysToGoPro.iq` (Pro) and contents check (`tools/check_free_package.sh`) | Done, both OK; compile only |
| `listing-free/` (README, NOTES, screenshots), CHANGELOG entries, publish-checklist block | Drafted; no screenshots exist (none invented) |
| **Owner:** OD1 to OD4, names and store titles, Pro price, Free icon, translations of any new string, Pro headline (no research run), look approval (WP2 mockups not part of this build: no visual change made), uploads (Free 1.0.0 new, Pro 1.1.0 on existing id, together), site (WP8) | Open |
| **Tests to run (main thread):** see `development.md`; Pro on device matrix, Free on same, then `fit_all.sh monkey.free.jungle` | Open |

## 3. Definition of done for the whole project

- All unit tests and ten screen-fit runs pass, strict typing, zero warnings (bar launcher-icon size notices).
- Phase 3 results recorded, `spec.md` updated to match what watch actually did.
- Memory gate met on smallest products; always-on frame checked in heat map.
- Docs, ADRs, listing, site pages written; superseded `docs/reference/` draft deleted.
- Every report states: FR965 device evidence only; everything else simulator only.

## 4. Stop and ask the owner when

- Any **[OWNER]** step.
- Test fails twice after fix, or simulator wedges three times in a row.
- T2 or T4 in phase 3 fails or conflicts.
- Change would alter `spec.md` scope (new setting, new state, new permission).
- Tempted to add feature from non-goals list.

## 5. Command cheat sheet

```sh
KEY=~/.garmin-connectiq/keys/developer_key
monkeyc -d <device> -f monkey.jungle -o bin/DaysToGo.prg -y $KEY -w --typecheck 3     # build Pro (monkey.free.jungle = Free)
tools/run_tests.sh <device> [jungle] [testName]                                       # unit tests, restarts a wedged simulator; jungle defaults to monkey.jungle (Pro)
tools/compile_sweep.sh                                                                # compile every product, both jungles (no simulator)
monkeydo bin/DaysToGo.prg <device>                                                    # run the face (simulator running)
monkeyc -e -r -f monkey.free.jungle -o dist/DaysToGoFree.iq -y $KEY                   # Free store package
monkeyc -e -r -f monkey.jungle -o dist/DaysToGoPro.iq -y $KEY                         # Pro store package (the live app id)
tools/check_free_package.sh                                                           # prove both packages' contents
monkeyc -e -r -f beta.jungle -o dist/DaysToGo-beta.iq -y $KEY                         # beta package (after tools/make_beta.py; Pro build)
python3 tools/gen_settings.py [free|pro] [--ids]                                      # settings resources
pkill -f monkeydo; pkill -f "ConnectIQ.app/Contents/MacOS"                            # reset a wedged simulator
```

Simulator app started with `"$(dirname "$(command -v monkeyc)")/connectiq"`.