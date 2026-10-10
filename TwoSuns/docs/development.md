# Development

Connect IQ SDK 9.2.0, Monkey C. `monkeyc`/`monkeydo` in SDK `bin/` folder if not on `PATH`. Signing key `~/.garmin-connectiq/keys/developer_key`, outside every repo, shared with other Verden apps; losing it prevents store updates.

Two builds, one source (ADR-020, Free + Pro ladder): **Pro** = `monkey.jungle` (live app id, `manifest.xml`), **Free** = `monkey.free.jungle` (`manifest.free.xml`, own app id). Every command below takes either jungle.

```sh
KEY=~/.garmin-connectiq/keys/developer_key
monkeyc -d fr965 -f monkey.jungle      -o bin/TwoSuns.prg     -y $KEY -w --typecheck 3   # Pro build (strict; the only accepted notices are launcher-icon scaling on non-65 px screens until the real icon ships)
monkeyc -d fr965 -f monkey.free.jungle -o bin/TwoSunsFree.prg -y $KEY -w --typecheck 3   # Free build
tools/run_tests.sh fr965 [jungle] [testName]                                    # unit tests; jungle defaults to monkey.jungle (Pro); the old <device> [testName] form still works
tools/run_tests.sh fr965 monkey.free.jungle                                     # the same suite on Free
tools/compile_sweep.sh                                                          # compile every manifest product, both jungles, no simulator (about 15 min)
monkeydo bin/TwoSuns.prg fr965                                                  # run the face (simulator running)
monkeyc -e -r -f monkey.free.jungle -o dist/TwoSunsFree.iq -y $KEY              # Free store package
monkeyc -e -r -f monkey.jungle      -o dist/TwoSunsPro.iq  -y $KEY              # Pro store package (prints "89 OUT OF 89 DEVICES BUILT" for 69 products: see compatibility.md)
tools/check_free_package.sh [--build]                                           # prove the packages' contents (below)
tools/fit_all.sh [jungle]                                                       # screen fit, ten devices
tools/fit_products.sh [id ...]                                                  # the whole suite on every manifest product (slow); JUNGLE=monkey.free.jungle for Free
python3 tools/gen_settings.py [free|pro] [--check|--ids]                        # settings resources, one folder per tier
python3 tools/gen_sun_tests.py                                                  # regenerate source/test/TwoSunsSunReferenceTest.mc
python3 tools/check_strings.py                                                  # translation parity, length, AppName rules
[TIER=free] tools/fit_languages.sh [-l "deu fin"] <product>...                  # the suite once per language
```

`dist/TwoSuns.iq` = **pre-ladder** package, exported 2026-09-28: holds 1.0.1 glyph fix (`capRadius` in its `debug.xml`), so prepared 1.0.1, not submitted 1.0.0
(no 1.0.0 package kept). `dist/TwoSuns-1.0.1-prepared.iq` = copy made 2026-10-01 before ladder work; ladder never writes `dist/TwoSuns.iq` (`dist/` git-ignored).
Free package `dist/TwoSunsFree.iq`, Pro `dist/TwoSunsPro.iq`.

Trust printed `PASSED (…)` line, not exit code. Run printing nothing = simulator wedged; `tools/run_tests.sh` restarts it once. Simulator started with `"$(dirname "$(command -v monkeyc)")/connectiq"`. Output -> `bin/t-<device>.log` (git-ignored).

No beta-package tooling here (Days To Go's `make_beta.py` not copied): settings are lists with defaults. (On-watch Customize screen exists since ADR-019 (on-watch Customize); Free build tested before upload would need own beta app id; not built.)

Both jungles set `base.sourcePath = source` on purpose: without it build also compiles anything under `docs/`. Normal (non-`-t`) build also **type-checks every test file**, so Pro-only symbol in unannotated test fails Free build.

## Shared simulator: read before running anything

Scripts run in container by default (own simulator, no `pkill`, parallel-safe: `../docker/README.md`); everything below applies only to host simulator (`CIQ_DOCKER=0`, pre-release verification when owner agrees). One host simulator per machine. `tools/run_tests.sh` (so `fit_all.sh`, `fit_products.sh`) runs `pkill -f monkeydo` after **every** run, ending whatever app or test another session has running in simulator; when run prints no result it also `pkill`s simulator itself and restarts. `tools/fit_languages.sh` does same only on no-result retry. If another Claude session, owner or probe run uses simulator, scripts kill their work, output mixes with yours. Check nobody uses it before run, never run two suites at once, never `pkill` by hand for someone else. Simulator wedges common even when not shared. `tools/fit_products.sh` **not run** during build for exactly this reason.

## The test kinds

**Pro 168 tests, Free 76** since 2026-10-10 (`weatherAfterSunsetHasNoHourCells`, `weatherForecastRowKeepsItsLow` and `weatherCellsThatFitSpreadOverThePlan` added, `weatherNextDayDropsTheLowWhenTheRowIsWide` removed, ADR-022 amendment 2026-10-10; Instinct 155 and 64). Before that **Pro 166, Free 76** since 2026-10-08 (`curveRoomKeepsThePlaces`, Pro only, ADR-028 amendment "the curve's room"; on Instinct 153 and 64 since 2026-10-10, when five tests naming `TwoSunsTrack` or `TwoSunsRectSpread` became `(:rect)`: `trackMapsATimeToTheRightPoint`, `trackStaysOnTheDisplay`, `sunMarkerStaysOnTheGlass`, `trackBoxFollowsItsCorners`, `rectangleSpreadGapsAreEven`; ADR-024 amendment; 158 and 69 before). Before that **Pro 165, Free 76** since 2026-10-07 (run 2026-10-08 on fr965, fr255s, venusq2, venux1, instincte40mm, after Body Battery colour and round changes): 154 and 67 below plus rectangle track's twelve (`TwoSunsTrackTest`, ADR-028; eight shared, incl. `rectangleSpreadGapsAreEven` and `rectangleRowsDoNotDependOnTheWording`, `aCurveWithNoLineIsHidden` (was `rectangleHidesACurveWithNoLine`; every shape since 2026-10-08), `rectangleGrowthKeepsTheWeatherRow` and `rectangleBatteryCostsTheTimeOnlyWhenDrawn` Pro only, `rectangleFreeNumberStaysSecond` Free only), run 2026-10-07 in container on venusq2, venux1, fr965, fr255s, instincte40mm (157 and 69 on Instinct). Before that: **Pro 154 tests, Free 67** (Pro 154 and Free 67 run 2026-10-03 in container, devices in `compatibility.md`; simulator only). Counted from `(:test ...)` annotations: 60 shared, 94 `(:test, :pro)`, 7 `(:test, :free)`. Pro's 154 = 130 of ADR-020 plus 19 weather tests (`TwoSunsWeatherTest`, four in `TwoSunsScreenFitTest`; daily-stamp test in `TwoSunsWeatherTest`). Pro's 130 = 124 that passed 2026-09-27 (unchanged apart from annotations and one helper twin) plus 6 new accent-table tests (`TwoSunsAccentTest`); Free's 67 = 60 shared plus 7 Free-only (`freeBatteryIsTheComplicationOnly`, `freeStateHasNoProState`, `freeReturnsDefaultsForProKeys`, `freeLoadReadsAccentOnly`, `freeMissingPropertyKeyThrows`, `skyFreeNeverSaysNoPlace`, `freeBigScreensKeepEveryRow`). Same count on every device within a jungle.

- **Logic**: sun calculation and 27 generated USNO reference tests (`TwoSunsSunReferenceTest`), calendar, exact local offset, Body Battery buckets, place rounding and hysteresis, sky states, readings (words), settings validation, date text, ring plan (angles, arcs, ticks, colours and contrast), curve plan and band. None checks pixels.
- **Screen fit** (`everyStateFitsThisDisplay`): renders 31 states in Pro (10 sun states times 3 Body Battery states, plus one with date off) and 8 in Free (7 sun states Free can reach, Garmin's number only, plus duplicate date-off one) at device's real resolution and fonts. `alwaysOnFrameFitsAtEveryDrift` same for always-on frame at nine drift positions. Run per screen size after any layout or string change:
  ```sh
  tools/fit_all.sh          # fr255s fenix7s fenix7 fenix7x fr265s fr165 epix2 fr965 venusq2 fenix9pro51mm
  ```
- **Tiny-surface tests** (`frameDropsRowsInOrder`, `framesDropRowsInOrderWhenTheScreenIsTiny`, `bigScreensKeepEveryRow`) force drop order (date, curve, sun line), check big screens keep every row; `truncatedKeepsTheMarker` checks "..." marker.
- **Layout report** (`twoSunsLayoutReport`): prints every row's box for live state and one test state. How layout is read here, because environment cannot capture simulator (`Dc.getPixel` does not exist in SDK 9.2). Read `bin/t-<device>.log`.

### Running both jungles (the matrix still to run)

One simulator, one device at a time (both jungles write `bin/t-<device>.*`, never run two at once). On devices the 1.0.1 notes name plus smallest round screen and both rectangles:

```sh
for d in fr965 fenix7 venu3 fr255s venusq2 venux1; do
  tools/run_tests.sh $d monkey.jungle        # Pro:  expect PASSED (passed=168, failed=0, errors=0)
  tools/run_tests.sh $d monkey.free.jungle   # Free: expect PASSED (passed=76,  failed=0, errors=0)
done
tools/fit_all.sh monkey.jungle               # ten devices, Pro
tools/fit_all.sh monkey.free.jungle          # ten devices, Free
```

Pro's 154 = 124 that passed 2026-09-27, 6 accent tests (ADR-020) 19 weather tests (ADR-022) and 4 battery-row tests (ADR-023): any Pro failure outside those = regression from ladder or weather work (imports removed, `sunDays` refactored, `Frame` and `Layout` taking weather row). `freeMissingPropertyKeyThrows` probes simulator, not shipped path.

### How the fit test reads

`TwoSunsDraw` logs, test mode only, every text box, glyph and curve boxes, any problem. Failing run prints lines like `454px: <problem>` (`logger.debug`); `tools/fit_all.sh` shows those containing `overlap` or `y=`:

- `cut: <sentence> y=<n>`: no font and no wording fitted round chord at that row, so sentence cut with "...". Any `cut:` line fails test. Fix: shorter wording in `strings.xml` (and `tools/check_strings.py` limit if new sentence), smaller cap in `TwoSunsLayout`, or smaller font list.
- `<text> y=<n>`: text box outside display or round chord.
- `glyph outside the content circle y=<n>` / `curve outside the content circle y=<n>`: glyph or curve touches ring.
- `state <n> overlap: '<a>' and '<b>'`: two boxes overlap.
- `state <n> drew <x> text rows, expected <y>`: row frame kept silently not drawn.
- `state <n> stack is taller than the span even with rows dropped`.

Pass = none of these on 31 states in Pro, 8 in Free (and as many by 9 always-on frames): layout and fit only, in English, not legibility, contrast or always-on behaviour.

## Settings

`tools/gen_settings.py [free|pro]` = source of `resources-<tier>/settings/settings.xml` and `properties.xml` (no argument writes both tiers; words hand-written in `resources*/strings/strings.xml`; `--ids` prints ids they must define). **No settings file in shared `resources/`**: Free has `Accent` only, Pro all five, generator refuses to write if `resources/settings` exists. `--check` exits 1 if either tier's files differ from tables, `resources/settings` exists, or property id has no `KEY_*` constant in `TwoSunsConfig.mc`. **Monkey C test cannot see changed default in `properties.xml`**: simulator keeps last saved settings, so use `--check`. Keep tables in step with `TwoSunsConfig` (`KEY_*`, `ACCENT_COUNT`, `ON`/`OFF`) and `TwoSunsPalette.ACCENTS` order.

## Tier-only code and resources

- `(:pro)` / `(:free)` on function, constant, field or class compiles it into only that tier; `(:free)` twin returns default or does nothing. `(:test, :pro)` and `(:test, :free)` same for tests. `import` **cannot** be annotated, so `TwoSunsSources` does not import `Position`, `SensorHistory`, `Weather` or `Activity`, names them in full inside `(:pro)` functions.
  Pro-only so far: `TwoSunsSun`, `TwoSunsPlace`, `TwoSunsDateText`, `TwoSunsCurvePlan` (whole classes); `TwoSunsBattery.build`, `TwoSunsCurve.draw`; history, location, place, date-line parts of `TwoSunsSources`; `KEY_ORIENTATION`, `KEY_GOLDEN`, `KEY_CURVE`, `KEY_DATE`, `KEY_PLACE`; Pro items of Customize menu; `TwoSunsView.drawCurve`. Free twins: `TwoSunsSky.noCalculationState` (no "No place yet"), `TwoSunsSettings.readPro`, `proKeys`.
- **Compiler is the permission check.** Call site needing `SensorHistory` or `Positioning` fails Free build with "Permission ... required"; how first Free compile found every site. New permissioned call outside `(:pro)` cannot reach Free.
- **AppName** defined only in `resources-pro/strings` and `resources-free/strings`. Language does not inherit default's strings, so each jungle appends its tier folder to every `base.lang.<l>` path; adding language: add its line to **both** jungles, its folder must not define AppName (`python3 tools/check_strings.py` fails if it does).
- **`Application.Properties.getValue` or `setValue` of key missing from properties file**: SDK 9.2.0 reference (`Toybox/Application/Properties.html`) says both throw `Properties.InvalidKeyException`. Read from docs, not observed. Free never touches Pro key, so nothing relies on it; `TwoSunsSettings.read` catches it for Pro path. `freeMissingPropertyKeyThrows` records what simulator does (written, not yet run).
- `tools/fit_languages.sh` takes `TIER=free` (default `pro`); throwaway jungle excludes other tier's annotation, searches tier folder.
- **Test helpers** (top-level functions and constants in `source/test/` that are not tests) carry `(:debug)`, so release export (`-e -r`, store package) drops them; before that they compiled into store `.prg` (found when Free scan saw Pro key `Curve` in helper). `(:test)` cannot be used on helper: runner would call it as test. Helpers inside `(:test)` classes dropped with class. `tools/gen_sun_tests.py` emits `(:debug)` on its two helpers.
- `tools/gen_sun_tests.py` writes every reference test as `(:test, :pro)` (tests `TwoSunsSun`, which Free does not compile). Do not hand-edit generated file.

## Checking a store package (what the compiler actually produced)

Second `settings.xml` in later resource folder not proven to replace first, so tiers never share one (ADR-020, Free + Pro ladder). Proof is on **compiled package**: `.iq` = 7-zip archive (macOS `bsdtar -xf x.iq` opens it; so does `7z x`). Holds, per part number, compiled `.prg`, `<part>-settings.json` (what phone renders: every setting key, list options, every string in every language), `debug.xml` (every function and source file compiler kept) and one `manifest.xml` (with permissions and app id).

```sh
tools/check_free_package.sh --build     # export both packages (a few minutes each), then check
tools/check_free_package.sh             # check the existing dist/TwoSunsFree.iq and dist/TwoSunsPro.iq; fails as STALE if a source file is newer
```

Exits non-zero unless: Free permission list exactly `ComplicationSubscriber`, Pro's `ComplicationSubscriber`, `Positioning`, `SensorHistory` (Free is subset); Free settings keys exactly `Accent` (ids 0 to 5) on every part number, Pro's the five; no Free `.prg` contains property names `Orientation`, `Golden` or `Curve` as standalone strings (`.prg` stores `<length byte><text><NUL>`, so "Golden hour" and French "Orientation de l'anneau" do not match; `Date` not scanned because shared setting title "Date" is that exact string, proved by settings keys and missing code); word "Pro" appears nowhere in Free package (manifest, settings strings in every language, `.prg`, `debug.xml`); no Free `debug.xml` names `positionLocation`, `readCurve`, `updatePlace`, `activityLocation`, `weatherLocation`, `fromStorage` or `drawDot`, source files `TwoSunsSun.mc`, `TwoSunsPlace.mc`, `TwoSunsCurvePlan.mc` or `TwoSunsDateText.mc`, modules `Position`, `SensorHistory`, `Weather`, `Activity` or `Storage`, or `TwoSunsSources.initialize` (only `Application.Storage` read; `updatePlace` is write); Pro's `.prg` and `debug.xml` DO contain them (modules `SensorHistory` and `Weather` and `TwoSunsSources.initialize` too; `Position`, `Activity`, `Storage` leave no module entry even in Pro, because Pro names them in full) (positive controls: prove Free checks can see what they look for); `AppName` "Two Suns" in every language of Free and "Two Suns Pro" in every language of Pro; app ids expected, different; part numbers equal SDK's for manifest's 69 product ids.
Pro-setting display strings (`setting_golden`, `orientation_*`, ...) stay in shared strings and ship, unreferenced, in Free; only word "Pro", keys and code policed. Check proves package contents; does not prove behaviour on watch.
Last run 2026-10-01 (compile only, simulator not used; re-run after reviewer fixes): both packages OK on all 89 part numbers. Negative tests: Pro package fed as Free fails on app id, permissions, keys, AppName; Free package fed as Pro fails likewise. Checks now also count one `.prg` and one `debug.xml` per product, scan Free `.prg` for Storage key `place` (Pro positive control), fail rather than skip when watched path missing. First run caught real leak: test helper `readingsState` named Pro key `Curve`, unannotated helpers in test files compile into store package (so got `(:free)` twin, `readingsSettings`).

## Sun reference tests

`tools/gen_sun_tests.py` writes `source/test/TwoSunsSunReferenceTest.mc` (Pro only, see above) from `research_notes/Body Battery and sun face research/reference_sun_times.tsv` (27 rows, US Naval Observatory; `SUN_TSV=<path>` overrides). Tolerance 2 minutes. Do not edit generated file by hand.

## Translations

English = `resources/strings/strings.xml`; each other language `resources-<lang>/strings/strings.xml` with identical ids and placeholders; new language also needs `<iq:language>` line in **both** `manifest.xml` and `manifest.free.xml`, path line in **both** jungles, no `AppName` in its strings (15 now: eng plus dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr). `python3 tools/check_strings.py` checks: same ids and placeholders as English; both manifests' languages equal `resources-<lang>` folders and both jungles carry `base.lang.<l>` line per language; each file carries machine-drafted note and **none** defines `AppName` (lives in tier folders only: "Two Suns" and "Two Suns Pro"); no string Free build ships contains word "Pro"; sentences with no shorter wording (`sky_no_place`, `sky_no_data`, `sky_sun_up` and two shortest polar sentences) at most 14 characters; every last-resort wording with time at most 16 characters; each sentence's three wordings never get longer. Character counts, proxy for round chord.

`tools/fit_languages.sh [-l "deu fin"] <product>` (product argument required) runs suite once per language by overlaying that language's strings in throwaway jungle; word tests assert English wording and error by design in other language, so only two fit tests decide, script prints them. **Not run yet, in any language.** Test date line fixed English, so date line's width in translation never measured. Translations machine-drafted, **not read by native speaker** (`listing/NOTES.md`).

## Compiler and SDK quirks

Found while building; each cost time.

- `import` cannot carry `(:pro)`/`(:free)`; compiler checks permissions at call sites only, so name permissioned module in full inside annotated function instead of importing.
- `private function` instance method called from **static** method of same class crashes `monkeyc` ("A critical error has occurred"). Keep such helpers non-private.
- `hidden` is Monkey C keyword: never name variable that.
- `Toybox.Math` returns `Float` or `Double`: wrap results with `.toFloat()` (`TwoSunsSun.f*` helpers).
- `Test.assertEqual` needs non-null arguments: use `sunPresent` helper.
- Local variable types inferred (no `var x as T`).
- `Activity.getActivityInfo()` typed never-null: null check = compiler warning. Location code catches exception instead.
- Test runner treats every `(:test)` function as test case, why shared test states are class (`TwoSunsTestStates`).
- Monkey C floats 32-bit: sun maths runs on days since J2000, never Julian date.
- `Position.getInfo()` without Positioning permission ends app, cannot be caught; isolated in `TwoSunsSources.positionLocation` ([ADR-005](decisions.md#adr-005-location-order-and-the-positioning-permission)).
- Simulator keeps last saved settings (see Settings above).

## Device testing

Simulator proves geometry, fonts, logic. Cannot prove always-on behaviour, battery cost, MIP daylight contrast, real location or real Body Battery data. Has no GPS position, canned weather and Complication sun values (sunset earlier than sunrise), synthetic Body Battery history (480 samples a minute apart, oldest first, first at clock, rest up to 8 hours in future: face keeps one sample, so one dot, no line; measured 2026-10-08 on fr965 in container). Owner's tests in git-ignored `../device-test/`: `LocationProbe-P.prg` and `LocationProbe-N.prg` ran on FR965 2026-09-27 (M1, M2 only; results in `LocationProbe-RESULTS.md`; M3/M4 left for later). `TwoSuns-CHECKLIST.md` (phase 9 wear checklist, for face itself) not written yet. Follow owner's habit: dev build only, all-day wear, no swaps.

## Screenshots (Instinct and any layout change)

Unit suite measures numbers; cannot see bezel. For every layout change, photograph what simulator draws (face on device skin, real fonts, real bezel mask): `../docker/shot.sh TwoSuns monkey.jungle instincte45mm` writes `bin/shot-<device>-face.png` (display, 3x). Instinct's visible area = circle about 98 px radius, which 176 x 176 square test misses (HeroSet ADR-055, amended 2026-10-03). `FAKETIME="2026-10-04 10:09:00"` sets simulator's clock.

**Weather Editor and Always-On in the simulator (2026-10-04).** `tools/weather_conditions.sh` (run through `../docker/capture.sh`) drives Settings > Set Weather and Settings > Display Mode by clicks. Result: editor keeps Condition, but face's weather row did not follow it (canned partly cloudy, 77 degrees every time), Always-On left full face drawn. So icon shapes per condition (ROADMAP 9.5, B5 rain) stay unit-tested only, always-on frame not seen in picture; both need wrist.