# Days To Go: implementation plan

Written 2026-09-26 for an implementer agent that has none of this conversation's context. Follow it literally. Where it says
**[OWNER]**, stop, tell the owner exactly what you need, and wait: those steps need a person, a phone, a watch or a decision only
the owner can make. Where it says **[GATE]**, the next phase depends on the result.

The product is defined in [`spec.md`](spec.md); the evidence is in [`reports/Countdown face research.md`](../../reports/Countdown%20face%20research.md)
and `research_notes/Countdown face research/`. The verified first draft of the logic that phase 1 copied from has been superseded by [`../source/`](../source/) and [`../tools/`](../tools/); where this plan says `docs/reference/`, it means that draft. Read the spec, the report and the notes first.

## Implementation status (2026-09-26)

| Phase | State |
|---|---|
| 0 Owner decisions | Name, price, date style decided. Languages (English + 14), category (Utility) and the "one number" look: taken as recommended, **owner has not explicitly approved them** |
| 1 Skeleton | Done (folder renamed to `DaysToGo/`) |
| 2 Settings and plain face | Done, merged with phase 4; beta tooling done (`tools/make_beta.py`); memory measured: 28% (fēnix 6 Pro), 33% (FR55) |
| 3 Phone and watch round trip | **Not done. Owner-only, on the FR965. The riskiest assumption is still untested** |
| 4 Real face | Done in code; **owner has not looked at it in the simulator** (design gate open) |
| 5 Screen-fit tests | Done: ten sizes pass in the simulator (`tools/fit_all.sh`) |
| 6 Languages | Done, machine-drafted, unread by native speakers; not run in a non-English simulator |
| 7 Docs | Done |
| 8 Listing and site | Written; images missing; site built, **not deployed** |
| 9 Device evidence and submission | Submitted 2026-09-26 without the beta round trip (owner's decision); wear day and always-on night not yet reported |
| 10 After approval | Not started |

The text of phases 1 to 8 below is the original plan; where it says `docs/reference/` it means the first draft of the code, which is superseded by `source/` and `tools/` (and its folder is to be deleted). Nothing builds from it: `monkey.jungle` sets `base.sourcePath = source`.

## 0. Ground rules (they override anything below if in conflict)

1. **Do not stage, commit, stash or reset.** The git index is mixed staged/unstaged and belongs to the owner. Leave everything in the working tree and end each phase by listing the files you created or changed.
2. **The signing key** is `~/.garmin-connectiq/keys/developer_key`, outside the repo. Never copy it in, never commit any `.der` or `.pem`. The project `.gitignore` (phase 1) copies HeroFace's.
3. **Simulator passing is not device proof.** Every report says, per watch product, what was run in the simulator and what (only the owner's FR965, and only after phase 3) ran on a wrist. MIP contrast, battery, always-on ghosting and phone settings delivery stay "unverified" until the owner's tests say otherwise.
4. **Behaviour change → update the doc that describes it in the same session. A durable decision → an ADR** in `docs/decisions.md` (list in phase 7). User-facing claims live in two places: the listing and `site`; change both together and never change or remove a published URL.
5. **Code rules** (from `HeroFace/CLAUDE.md`, which this project mirrors): every function has typed parameters and an `as` return type; no `as Any`; cast only after `instanceof` or a null guard; no magic numbers (tunables and keys in `DaysToGoConfig`, geometry in `DaysToGoLayout`, colours in `DaysToGoPalette`, words in `strings.xml`); text fit is measured, never guessed; render only in `onUpdate`, gather data in `DaysToGoReadings`, draw from a `DaysToGoState`; one class per file with the `DaysToGo` prefix; functions of about 30 lines or fewer, files about 250 or fewer; comments explain why; property key spellings never change once shipped.
6. **Forbidden in this app** (each was found to hurt a rival or a wearer; the research notes say why): `type="date"` settings; `numeric` settings with min/max; `Time.Moment` arithmetic for day counts; `Application.Storage` (Properties only); any permission in the manifest; bitmaps or per-device resources; the network; notifications or heart-rate/weather/complication features; seconds.
7. **Build with warnings and strict typing on** and keep them at zero: `-w --typecheck 3`.
8. **Trust the printed `PASSED (…)` line, not an exit code.** The simulator wedges every few runs; `tools/run_tests.sh` restarts it once. A run that prints nothing means wedged, not failed.
9. **Do not invent evidence**: no reviews, downloads, screenshots, battery figures or accuracy claims in any doc or listing.
10. **Edits outside `DaysToGo/` are limited to**: the root `CLAUDE.md` project table (one row), the root `README.md` layout note if it lists projects, and `site/` (phase 8 only). Ask before touching `HeroSet/` or `HeroFace/`. Copy from `HeroFace/source/` at commit `d63d30d`; do not import from it.

**Never decide alone**: the store name, the price, the visual identity, the launcher icon, any upload to the Connect IQ store (beta or release), any phone or watch test, a site deploy, and shipping machine translations that no native speaker has read.

## 1. Where things are

```
Countdown/  (rename to DaysToGo/ once the name is confirmed; use `mv`, it is untracked)
  docs/spec.md  docs/plan.md  ...            docs (see docs/)
  source/*.mc  source/test/*.mc  source/settings/*.mc   the app (was docs/reference/ in the original plan)
  tools/gen_settings.py  tools/run_tests.sh  ...        generators and test runners
```

Reference for HeroFace patterns to copy (adapt names and geometry, do not depend on them): `HeroFaceLayout.mc` (proportional rows, circle chord insets, ring sweep), `HeroFaceDraw.mc` (measured text, `firstFitting`), `HeroFaceText.mc` (cached string loading), `HeroFaceSleep.mc` (always-on grid shift), `HeroFaceReadings.timeText` (12/24 h), `HeroFaceSettings.mc` (Properties read with fallback), `HeroFacePalette.mc`, `source/test/HeroFaceScreenFitTest.mc` (`everyStateFitsThisDisplay`), `docs/development.md` (commands, translation parity script), `listing/` (form fields, generators).

## 2. Phases

Effort figures are estimates, not measurements.

### Phase 0. Owner decisions [OWNER]

Ask these five things in one message and record the answers as ADRs (phase 7). Recommended answers are in bold; nothing in phases 1 to 3 depends on them except the folder name.

1. **Price**: **decided 2026-09-26: paid $1.99 first, one review 45 days after approval on whether to flip to free once, never back.** (The owner's idea of alternating free and paid weeks in secret was advised against: `spec.md` "Price".) Record it as ADR-002 with the flip rule and the funnel hypothesis. Nothing to ask. Confirm it once, showing the risk in `spec.md` "Price" (15 paid countdown faces, all at 10 downloads or fewer; free leaders at 10,000 to 100,000). Only phase 9 depends on it.
2. **Name**: **Days To Go**, confirmed by the owner on 2026-09-26 (the store search by eye and a trademark search are still the owner's to do). This fixes the folder, the code prefix and the site slug (`days-to-go`), and **the slug is permanent once published**.
3. **Languages**: **English + HeroFace's 14** (dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr); add Russian, Greek, Chinese?
4. **Category**: **Utility** (or Simple).
5. **Visual identity**: approve the "one number" direction and the accent set in `spec.md`, or provide a design (phase 4 gate).

If the name changes later, the rename is mechanical: folder, class prefix, `strings.xml` AppName, site slug. The app id never changes.

### Phase 1. Project skeleton and verified logic (≈ 0.5 day)

Create in the project folder:

- `CLAUDE.md` (fast facts, house rules as above, "Keeping things in sync"), `README.md`, `PRODUCT.md`, `CHANGELOG.md` (an `Unreleased` heading), `.gitignore` (copy `HeroFace/.gitignore`, which ignores `/bin/ /gen/ /mir/ *.prg *.iq` and key files).
- `monkey.jungle` containing `project.manifest = manifest.xml`.
- `manifest.xml`: copy the `<iq:product id="…"/>` lines from `HeroFace/manifest.xml` (117 round products; script it: `grep '<iq:product' HeroFace/manifest.xml`); `type="watchface"`, `entry="DaysToGoApp"`, `launcherIcon="@Drawables.LauncherIcon"`, `minApiLevel="3.0.0"`, **a new app id** (`uuidgen | tr A-Z a-z`; it never changes), `<iq:permissions/>` empty, the language list from the answer to question 3 in phase 0.
- `resources/drawables/drawables.xml` and `launcher_icon.svg` (copy HeroFace's as a placeholder; **[OWNER]** supplies the real icon before phase 9).
- `source/`, `source/test/`, `tools/`: copy from `docs/reference/` (`cp`, not `mv`); **not** `source/settings/` yet: those files use strings that only exist after phase 2, and every source file is compiled. If the name changed, rename the `DaysToGo` prefix in file names and code.
- A minimal `DaysToGoApp.mc` (extends `Application.AppBase`; `getInitialView` returns a `DaysToGoView`; `onSettingsChanged` calls `WatchUi.requestUpdate()`) and a `DaysToGoView.mc` that only clears the screen. Do not add `getSettingsView` yet.

Commands (from the project folder):

```sh
KEY=~/.garmin-connectiq/keys/developer_key
monkeyc -d fr965 -f monkey.jungle -o bin/DaysToGo.prg -y $KEY -w --typecheck 3
tools/run_tests.sh fr965
```

**Done when**: the build prints `BUILD SUCCESSFUL` with no warnings except the launcher-icon size notice, and `tools/run_tests.sh fr965` prints `PASSED (passed=15, failed=0, errors=0)`. Then run it for `fenix6pro` and `venu2s`. Add the project's row to the root `CLAUDE.md` table. If the folder was renamed from `Countdown/`, also fix every `DaysToGo/docs/...` link in `reports/Countdown face research.md`, `research_notes/Countdown face research/` and `docs/` (grep for `Countdown/`).

### Phase 2. Settings and a plain, working face (≈ 1 to 1.5 days)

Goal: a **correct but ugly** face that carries every setting, so the phone and watch round trip can be tested on a real watch before any design work. Do not polish anything here.

1. Add the **Date style** list setting to `tools/gen_settings.py` (property `DateStyle`, values 0 Automatic, 1 Day first, 2 Month first, default 0; entries `datestyle_auto|day|month`; add the ids to `hand_ids()`) and its constants to `DaysToGoConfig`, then generate resources: `python3 tools/gen_settings.py` writes `resources/settings/settings.xml`, `properties.xml`, `resources/strings/generated.xml`. Run `python3 tools/gen_settings.py --ids` and define every id it prints in `resources/strings/strings.xml` (English) plus `AppName`, `settings_title`, `menu_set_date`, and the Date style words `setting_datestyle`, `datestyle_auto`, `datestyle_day`, `datestyle_month`, and the face's own words: `cap_day`, `cap_days`, `cap_weeks`, `cap_hours`, `cap_since_day`, `cap_since_days`, `cap_today`, `cap_invalid`. Captions are **labels, not sentences**, so Polish, Lithuanian, Ukrainian and Finnish need no plural agreement; singular is used only for exactly 1.
2. `DaysToGoSettings.mc`: reads each property with a fallback (pattern of `HeroFaceSettings.number()/read()`, catching `InvalidKeyException`), and **validates**: month outside 1 to 12 → 1, day outside 1 to 31 → 1, year not 0 or a plausible calendar year → 0, raw hour setting outside 0 to 24 → 0 (all day; the setting stores 0 = all day, 1 to 24 = 00:00 to 23:00, never a negative, and `DaysToGoEvent.hourFromSetting` converts), unknown event → New Year, name truncated to 16 characters. Expose a static `fromValues(...)` so tests can feed bad values without Properties. Tests: bad, missing and wrong-typed values all yield the defaults.
3. `DaysToGoState.mc` and `DaysToGoReadings.mc` (the date line is built by a pure `DaysToGoDateText.lines(dayOfWeek, day, month, year, monthFirst, showYear)` with unit tests for both orders and for the year rule; **not in `reference/`**, write it with tests first; `monthFirst` comes from the Date style setting, Automatic = language English and `System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE`): `take(settings) as DaysToGoState` builds the event with `DaysToGoEvent.fromSettings` (pass the **raw** Hour property; it converts internally), calls `DaysToGoCountdown.resolve(event, DaysToGoLocalTime.now())`, and turns the result into words (hero string, caption, name, date line, time text). The date line formats a Moment from the target y/m/d with `Gregorian.utcInfo(moment, Time.FORMAT_MEDIUM)`; keep the reference test `targetDateFormatsWithoutShift`. Weeks mode: hero = `days / 7`, extra line `+ n DAYS` from `days % 7` (omit when 0). Hours state: `H:MM` from `seconds`. **An Invalid result never builds a Moment or a date line**: it shows only the SET A DATE words (the phone's Day list offers 31 for every month, so impossible dates are easy to save).
4. `DaysToGoView.mc`: draw the state as five plain centred text lines with system fonts (no layout work). It must never throw: a null or unexpected state draws "?".
5. Settings on the watch: copy `docs/reference/source/settings/*.mc` into `source/settings/` (their strings `settings_title`, `menu_set_date`, `year_every`, `month_1` to `month_12` exist after step 1), then `getSettingsView()` in `DaysToGoApp` returning `[new DaysToGoSettingsMenu(), new DaysToGoSettingsDelegate()]`. The picker's column order follows Date style (day-first: Day, Month, Year). The picker's year range comes from `DaysToGoConfig.PICKER_FIRST_YEAR/PICKER_LAST_YEAR` and must match `FIRST_YEAR/LAST_YEAR` in `tools/gen_settings.py`. Guard `getSettingsView` so an exception cannot crash the face.
6. **Do not cache settings across updates.** Read them (`DaysToGoSettings.load()`, about nine Properties reads) at the start of every `onUpdate`, which runs once a minute in low power, and call `WatchUi.requestUpdate()` from `onSettingsChanged` and from the picker delegate. Nothing found shows that `Properties.setValue` from the on-watch picker triggers `onSettingsChanged`, so re-reading in `onUpdate` is what makes a picked date appear at once.
7. **Beta build tooling**: `tools/make_beta.py` copies `manifest.xml` to `manifest-beta.xml` with the app id replaced by a fixed second UUID (create it once with `uuidgen`, store it in `tools/beta-app-id.txt`, keep that file tracked and not ignored so the owner's next commit picks it up; it is not a secret), and writes `beta.jungle` (`project.manifest = manifest-beta.xml`). Add both generated files to `.gitignore`. Export with `monkeyc -e -r -f beta.jungle -o dist/DaysToGo-beta.iq -y $KEY`. Confirm the beta and production manifests differ **only** in the id.

**Done when**: builds (strict, zero warnings) for `fr965`, `fenix7`, `fenix6pro`, `fr55`, `fr265s`, `venu2s`; all tests pass on `fr965` and `fenix6pro`; **memory read from a normal (non-test) run**: temporarily print `System.getSystemStats()` in `onUpdate`, run `monkeydo bin/DaysToGo.prg fenix6pro` (and `fr55`, the 96 KB class), record `usedMemory` against `totalMemory`, then remove the print. Target: used ≤ 30% of total at this stage. Update `docs/development.md` with what you ran. **This phase's output is the beta build.**

### Phase 3. Phone and watch round trip on a real watch [OWNER] [GATE] (≈ 1 day elapsed)

This is the riskiest assumption in the project and the cheapest to test now. Why: the rivals' worst failure was entering the date; the fix (lists, an on-watch picker) is designed but has never run on hardware.

Owner steps: export the beta (`dist/DaysToGo-beta.iq`), upload it at the developer dashboard with **Beta App** checked (SDK `Core_Topics/Beta_Apps`; the beta has its own store id and is visible only to the owner's account), install it on the FR965 from "uploaded apps" in the Connect IQ app, set it as the watch face. Record every result in `device-test/DaysToGo-CHECKLIST.md` (that folder is git-ignored and is the only record of a session; follow the owner's all-day-wear habit: this app is the only face worn that day).

| Test | Steps | Pass looks like |
|---|---|---|
| T1 Default | Install, set as face, change nothing | Shows a countdown to next New Year's Day, correct day count, no empty state |
| T2 Phone date | In Connect: Event = My own date; set Month, Day, Year (a date 10 days away) | Within about a minute the face counts the right days. **Close and reopen the settings screen: values are still what was chosen** (not blank, not January 1970) |
| T3 Phone unrelated change | Change only Accent (or Bottom line) | The date is unchanged afterwards |
| T4 On-watch picker | Watch: Customize → Set date → pick a different date | Face updates at once. **Then record**: does Connect show the new values? If you now change Accent in Connect, does the date revert to the old phone value? |
| T5 Reboot | Restart the watch | Date and event survive |
| T6 Name | Set Name to 16 wide letters, then Greek/Cyrillic/CJK text, then empty | Fits or truncates cleanly; unsupported glyphs noted; empty hides the row |
| T7 Timed event | Time of day = an hour later today | Shows `H:MM` hours left; "TODAY" once the hour passes |
| T8 Midnight | Event = tomorrow, wear through midnight | Flips from "1 DAY" to TODAY at 00:00 local |
| T9 Time zone | Change the phone's time zone by several hours | The count does not change except at local midnight |
| T10 Other route | If available: set the date with Garmin Express and, separately, Android | Same result as T2 |

**On-watch coverage**: the SDK lists `getSettingsView` support for 94 of HeroFace's 117 products by name match; the 23 not listed are older CIQ 3.x products (D2 Charlie/Delta family, Descent Mk1, vívoactive 3 family, FR645/935, fēnix Chronos, Approach S62) and the newest (fēnix 9 family, FR70, FR170). There the phone is the only route, so the listing and support page must say "set it in the app; on many watches also on the watch", never promise the watch route everywhere, and phase 3's T4 result on the FR965 says nothing about the others.

**Decision after T4 [GATE]**: if the on-watch picker and the phone never destroy each other's values, keep both and add "set it on the watch or in the app" to the support text. If the phone silently overwrites the watch's values, or the reverse, choose: (a) keep the on-watch picker and document "the last change wins", (b) drop the picker (delete `source/settings/` and `getSettingsView`), record the choice as ADR-005. If T2 fails (the phone lists lose values), the on-watch picker becomes the primary way: escalate to the owner before phase 4.

### Phase 4. The real face (≈ 2 to 3 days)

Precondition: phase 3 recorded, and the visual direction approved (phase 0 question 5). **[OWNER] design gate**: the owner may replace the direction in `spec.md` with a mock-up from the design tool; if so, follow the mock-up and update `spec.md` and `DESIGN.md`.

Build, adapting the named HeroFace files (rename, simplify, keep the ideas):

- `DaysToGoLayout.mc` (from `HeroFaceLayout`): proportional rows from the shorter screen side D, top to bottom: time, event name, hero, caption, date, optional bottom line; starting bands are in `spec.md`. Keep the circle **chord** maths (`leftInsetWithin`, `rightInsetWithin`) so every row is checked against the round screen.
- `DaysToGoDraw.mc` (from `HeroFaceDraw`): `text`, `fits`, `firstFitting` (measured with `dc.getTextWidthInPixels`).
- Hero fitting: try `FONT_NUMBER_THAI_HOT`, `HOT`, `MEDIUM`, `MILD` (then `FONT_LARGE`) and take the first whose width fits the chord at the hero band and whose height fits the band; a word hero (TODAY, SET A DATE) uses the same chain on its own width.
- Event name: accent colour, shrinks through fonts, then truncates with `…`; empty hides the row and gives the space to the hero.
- `DaysToGoRing.mc` (from `HeroFaceRing`): a bezel arc; sweep from the share of the next 365 days still to go (Upcoming), of 24 h (Hours), full (Today), track only (Past). Use HeroFaceLayout's `ringSweepFor`/`arcEndDegree` maths.
- `DaysToGoPalette.mc`: black ground, white, muted `#AAAAAA`, track `#555555`, sleep `#555555`, six accents (all channels 00/55/AA/FF, i.e. inside the 64-colour palette). State is never colour alone: the word (TODAY, HOURS, SINCE) carries it.
- `DaysToGoSleep.mc` (from `HeroFaceSleep`): always-on = hero + time only, dim, stepping across the 3×3 grid once a minute; check `System.getDeviceSettings().requiresBurnInProtection` only if you add anything static. `onEnterSleep`/`onExitSleep` request updates.
- Bottom line: battery (`System.getSystemStats().battery`) or steps (`ActivityMonitor.getInfo().steps`, hidden when null), off by default. **A value the watch does not have is hidden, never faked.**
- 12/24 h from `System.getDeviceSettings().is24Hour`; no seconds; no timers; `onUpdate` once a minute is enough.
- A `daysToGoLayoutReport` test that prints every row's box (how layout is read without a screenshot, as `heroFaceLayoutReport`).

**Done when**: builds strict/zero-warning for the six devices of phase 2; unit tests still pass; the layout report is sane on `fr55` (208), `fenix5s` (218), `fenix5` (240), `vivoactive4` (260), `fenix7x` (280), `fr265s` (360), `fr165` (390), `epix2` (416), `fr965` (454), `fenix9pro51mm` (466); **memory** from a normal run on `fr55`/`fenix5s`/`fenix6pro` ≤ 60% of total; and the owner has looked at the simulator on at least `fr965` and `fenix7x` and approved the look. **[OWNER]** also runs File > View Screen Heat Map on an AMOLED simulator for the always-on frame (this environment cannot capture the simulator).

### Phase 5. Screen-fit tests for every state (≈ 0.5 to 1 day)

Write `DaysToGoScreenFitTest.mc` and `DaysToGoTestStates.mc` following `HeroFaceScreenFitTest.mc`: `everyStateFitsThisDisplay` renders the widest states with the device's real fonts and **fails** on text outside the round display or overlapping a row. States to include: the widest date lines (`Wed 30 Sep 2026` and `Wed Sep 30 2026`, and the longest weekday and month words of each language); the 16-character name of 16 `W`; hero values 1, 9, 99, 999, 9,999, 12,775 (the largest possible: year list ends 2060), 99,999 (a long-past event); every phase (Upcoming, Hours `23:59`, Today, Past, Invalid); weeks mode with `+ 6 DAYS`; bottom line battery `100%` and steps `99.9K`; the always-on frame; and every state in the longest translation of each caption.

```sh
for d in fr55 fenix5s fenix5 vivoactive4 fenix7x fr265s fr165 epix2 fr965 fenix9pro51mm; do
  monkeyc -t -d $d -f monkey.jungle -o bin/t-$d.prg -y $KEY -w --typecheck 3
  tools/run_tests.sh $d everyStateFitsThisDisplay
done
```

**Done when** all ten pass. Update `docs/compatibility.md` with the evidence table (one row per screen size, "simulator only").

### Phase 6. Languages (≈ 0.5 to 1 day)

Add `resources-<lang>/strings/strings.xml` for each language answered in phase 0, ids and placeholders identical to English (use the parity script in `HeroFace/docs/development.md`). Month names, the ten captions, setting titles and list entries need translating; the numbers do not (`generated.xml` is the default resource and languages inherit it: **verify this inheritance in the simulator by switching the language on one device** before relying on it). Add an `everyLabelFitsThisLanguage` test as in HeroFace and run it for the longest languages (German, Dutch, Finnish, Lithuanian, Ukrainian). Machine-drafted translations are **not native-reviewed**: flag that in `listing/NOTES.md` and ask the owner whether to ship them or only English plus the ones a speaker has checked. Plural agreement (21 in Polish, Lithuanian, Ukrainian) is the known imperfection of label captions; say so.

### Phase 7. Documentation (≈ 1 day)

Create, mirroring HeroFace's shape: `PRODUCT.md`, `DESIGN.md` (frontmatter tokens as in `HeroFace/DESIGN.md`), `docs/decisions.md`, `docs/compatibility.md`, `docs/development.md`, `docs/release-contract.md` (the claims allowed and forbidden, from `spec.md`), `CHANGELOG.md`, `README.md` (test count, layout). ADRs to write (one paragraph each: decision, why, evidence path): **001** any event, countdown-first; **002** price; **003** list settings, never `date`/`numeric`; **004** calendar-day arithmetic, no Moment maths; **005** on-watch picker (result of phase 3); **006** device set (117 round, CIQ 3.0+); **007** always-on = hero + time on a shifting grid; **008** name and site slug; **009** 29 Feb every-year rule (28 Feb in common years); **010** no permissions, no `Storage`, nothing leaves the watch; **011** date style setting and words-only dates. Then delete `docs/reference/` (its files now live in `source/` and `tools/`) and say so in `docs/decisions.md`.

### Phase 8. Store listing and site (≈ 1 day)

- `listing/README.md` (paste-ready, fields in form order, exactly like `HeroFace/listing/README.md`): title (max 50), description (max 4000, plain text, first sentence carries the weight, last line the support URL), version, what's new, tags (only things the app does), category, the No answers, images, email `hello@verden.watch`. `listing/NOTES.md` holds the why. **Descriptions may only state what the release contract allows**; no watch count; no battery figure; no "works on X" for a watch that only the simulator has seen. Review guidelines: no brand names, no rating manipulation, disclose the refund position if paid.
- Screenshots: **[OWNER]** captures simulator or device screens; the agent adapts the generators in `HeroFace/listing/src/` and writes `listing/screenshots.md`. One device is enough.
- `site/src/apps/<slug>/`: copy `heroface/` (its landing, support and privacy pages, `facts.ts`, `app.ts`), add the line in `src/apps/index.ts`, check that `npm run build` writes `dist/days-to-go/index.html` (existing slugs are single words; `appUrl` in `src/urls.ts` accepts a hyphen), add a row to the app table in `site/CLAUDE.md`. Privacy page: no permissions, no data leaves the watch, no account. Support page: how to set the date on the phone **and on the watch**, Garmin Express as the fallback, what "Every year" means, the 29 Feb rule. The watch list may only name watches in a **live** store build; before approval the page carries no list and the store button falls back to "Coming soon". `npm run build` must pass. **Do not deploy**: [OWNER] runs `npm run deploy` (support and privacy must be live before the store submission, because reviewers and users open them).

### Phase 9. Device evidence and submission [OWNER] (≈ 1 day of wear + 72 h review)

1. **Wear day** on the FR965 with the production-id build (all-day style: no build swaps, this app only): battery window, always-on for a night with sleep mode off (ghosting), midnight flip, the day count against the calendar. Record in the checklist. No battery figure goes in the listing.
2. Export: `monkeyc -e -r -f monkey.jungle -o dist/DaysToGo.iq -y $KEY`.
3. Paste the listing fields from `listing/README.md` into https://apps.garmin.com/developer/upload. **Price**: as answered in phase 0 (default paid $1.99): choose the price point in the merchant flow (SDK `Monetization/App_Sales`, "Yes, through Garmin CIQ merchant account") and expect the offered watch list and countries to shrink to Garmin's lists. If the owner switched to free, no merchant step. Price is set at submission: re-pricing an approved app removes it for re-review.
4. Record the publication in `CHANGELOG.md` (version, upload date, user-facing changes, ADRs) and `listing/README.md`'s What's New (house rule for every publication).
5. Record the baseline for the price review: download buckets, reviews and ratings of HeroSet and HeroFace at the day of submission.
6. Review takes about 72 hours; a rejection names its reasons.

### Phase 10. After approval

**Price review reminder**: the day approval arrives, compute approval + 45 days and write "Price review due <date>" in `CLAUDE.md` and tell the owner to add it to the memory index; then follow `spec.md` "Price review" on that date. Verify the live listing page and that support and privacy URLs work; add the store URL and the (live) watch list to the site's `facts.ts`; note new-hardware watch launches (day-one support was the one ranking lever found in the research); on day 60 run the success test in `spec.md` (the price review at day 45 comes first).

## 3. Definition of done for the whole project

- All unit tests and the ten screen-fit runs pass, strict typing, zero warnings (bar the launcher-icon size notices).
- Phase 3 results recorded, and `spec.md` updated to match what the watch actually did.
- Memory gate met on the smallest products; always-on frame checked in the heat map.
- Docs, ADRs, listing, site pages written; the superseded `docs/reference/` draft deleted (owner's `rm -r`).
- Every report states: FR965 device evidence only; everything else simulator only.

## 4. Stop and ask the owner when

- Any **[OWNER]** step.
- A test fails twice after a fix, or the simulator wedges three times in a row.
- T2 or T4 in phase 3 fails or conflicts.
- A change would alter `spec.md` scope (a new setting, a new state, a new permission).
- You are tempted to add a feature from the non-goals list.

## 5. Command cheat sheet

```sh
KEY=~/.garmin-connectiq/keys/developer_key
monkeyc -d <device> -f monkey.jungle -o bin/DaysToGo.prg -y $KEY -w --typecheck 3     # build
tools/run_tests.sh <device> [testName]                                                # unit tests, restarts a wedged simulator
monkeydo bin/DaysToGo.prg <device>                                                    # run the face (simulator running)
monkeyc -e -r -f monkey.jungle -o dist/DaysToGo.iq -y $KEY                            # store package
monkeyc -e -r -f beta.jungle -o dist/DaysToGo-beta.iq -y $KEY                         # beta package (after tools/make_beta.py)
python3 tools/gen_settings.py [--ids]                                                 # settings resources
pkill -f monkeydo; pkill -f "ConnectIQ.app/Contents/MacOS"                            # reset a wedged simulator
```

The simulator app is started with `"$(dirname "$(command -v monkeyc)")/connectiq"`.
