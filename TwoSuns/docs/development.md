# Development

Connect IQ SDK 9.2.0, Monkey C. `monkeyc`/`monkeydo` live in the SDK's `bin/`
folder if they are not on `PATH`. The signing key is
`~/.garmin-connectiq/keys/developer_key`, outside every repo, shared with the
other Verden apps; losing it prevents store updates.

Two builds come from one source (ADR-020, Free + Pro ladder): **Pro** is `monkey.jungle` (the live app id, `manifest.xml`) and **Free** is
`monkey.free.jungle` (`manifest.free.xml`, its own app id). Every command below takes either jungle.

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

`dist/TwoSuns.iq` is the **pre-ladder** package, exported 2026-09-28: it holds the 1.0.1 glyph fix (`capRadius` is in its `debug.xml`), so it is the prepared 1.0.1, not the 1.0.0 that was submitted
(no 1.0.0 package was kept). `dist/TwoSuns-1.0.1-prepared.iq` is a copy made 2026-10-01 before the ladder work; the ladder never writes `dist/TwoSuns.iq` (`dist/` is git-ignored).
The Free package is `dist/TwoSunsFree.iq` and the Pro one `dist/TwoSunsPro.iq`.

Trust the printed `PASSED (…)` line, not an exit code. A run that prints nothing
means the simulator wedged; `tools/run_tests.sh` restarts it once. The simulator
is started with `"$(dirname "$(command -v monkeyc)")/connectiq"`. Output goes to
`bin/t-<device>.log` (git-ignored).

There is no beta-package tooling here (Days To Go's `make_beta.py` was not copied): settings are lists with defaults. (The on-watch Customize screen exists since ADR-019 (on-watch Customize), and a Free build tested before upload would need a beta app id of its own; not built.)

Both jungles set `base.sourcePath = source` on purpose: without it the build
also compiles anything under `docs/`. A normal (non-`-t`) build also **type-checks every test file**, so a Pro-only symbol used by an unannotated test fails the Free build.

## Shared simulator: read before running anything

Scripts run in a container by default (own simulator, no `pkill`, parallel-safe: `../docker/README.md`); everything below applies only to the host simulator (`CIQ_DOCKER=0`, pre-release verification when the owner agrees). There is one host simulator per machine. `tools/run_tests.sh` (and so `fit_all.sh` and `fit_products.sh`) runs `pkill -f monkeydo` after **every** run, so it ends whatever app or test another session has running in the simulator, and when a run prints no result it also `pkill`s the simulator itself and starts it again. `tools/fit_languages.sh` does the same only on a no-result retry. If another Claude session, the owner or a probe run is using the simulator, those scripts kill their work, and their output gets mixed with yours. Check that nobody is using it before a run, do not run two suites at once, and never `pkill` it by hand for someone else. Simulator wedges are common even when it is not shared. `tools/fit_products.sh` was **not run** during the build for exactly this reason.

## The test kinds

**Pro 159 tests, Free 71** since 2026-10-05: the 154 and 67 below plus the rectangle track's five (`TwoSunsTrackTest`, ADR-028; four shared, `rectangleHidesACurveWithNoLine` Pro only), run 2026-10-06 in the container on venusq2, venux1, fr965, fr255s and instincte40mm (151 and 64 there). Before that: **Pro 154 tests, Free 67** (Pro 154 and Free 67 run 2026-10-03 in the container, devices in `compatibility.md`; simulator only). Counted from the `(:test ...)` annotations: 60 shared, 94 `(:test, :pro)`, 7 `(:test, :free)`. Pro's 154 are the 130 of ADR-020 plus 19 weather tests (`TwoSunsWeatherTest`, four in `TwoSunsScreenFitTest`; the daily-stamp test is in `TwoSunsWeatherTest`). Pro's 130 are the 124 that passed on 2026-09-27 (unchanged apart from annotations and one helper twin) plus 6 new accent-table tests (`TwoSunsAccentTest`); Free's 67 are the 60 shared plus 7 Free-only (`freeBatteryIsTheComplicationOnly`, `freeStateHasNoProState`, `freeReturnsDefaultsForProKeys`, `freeLoadReadsAccentOnly`, `freeMissingPropertyKeyThrows`, `skyFreeNeverSaysNoPlace`, `freeBigScreensKeepEveryRow`). Same count on every device within a jungle.

- **Logic**: the sun calculation and 27 generated USNO reference tests (`TwoSunsSunReferenceTest`), calendar, exact local offset, Body Battery buckets, place rounding and hysteresis, sky states, readings (words), settings validation, date text, ring plan (angles, arcs, ticks, colours and their contrast), curve plan and band. None checks pixels.
- **Screen fit** (`everyStateFitsThisDisplay`): renders 31 states in Pro (10 sun states times 3 Body Battery states, plus one with the date off) and 8 in Free (the 7 sun states Free can reach, with Garmin's number only, plus the duplicate date-off one) at the device's real resolution and fonts. `alwaysOnFrameFitsAtEveryDrift` does the same for the always-on frame at the nine drift positions. Run per screen size after any layout or string change:
  ```sh
  tools/fit_all.sh          # fr255s fenix7s fenix7 fenix7x fr265s fr165 epix2 fr965 venusq2 fenix9pro51mm
  ```
- **Tiny-surface tests** (`frameDropsRowsInOrder`, `framesDropRowsInOrderWhenTheScreenIsTiny`, `bigScreensKeepEveryRow`) force the drop order (date, curve, sun line) and check big screens keep every row; `truncatedKeepsTheMarker` checks the "..." marker.
- **Layout report** (`twoSunsLayoutReport`): prints every row's box for the live state and one test state. This is how layout is read here, because the environment cannot capture the simulator (`Dc.getPixel` does not exist in SDK 9.2). Read `bin/t-<device>.log`.

### Running both jungles (the matrix still to run)

One simulator, one device at a time (both jungles write `bin/t-<device>.*`, so never run two at once). On the devices the 1.0.1 notes name plus the smallest round screen and both rectangles:

```sh
for d in fr965 fenix7 venu3 fr255s venusq2 venux1; do
  tools/run_tests.sh $d monkey.jungle        # Pro:  expect PASSED (passed=159, failed=0, errors=0)
  tools/run_tests.sh $d monkey.free.jungle   # Free: expect PASSED (passed=71,  failed=0, errors=0)
done
tools/fit_all.sh monkey.jungle               # ten devices, Pro
tools/fit_all.sh monkey.free.jungle          # ten devices, Free
```

Pro's 154 are the 124 that passed on 2026-09-27, 6 accent tests (ADR-020) 19 weather tests (ADR-022) and 4 battery-row tests (ADR-023): any Pro failure outside those is a regression from the ladder or weather work (imports removed, `sunDays` refactored, `Frame` and `Layout` taking a weather row). `freeMissingPropertyKeyThrows` is a probe of the simulator, not of a shipped path.

### How the fit test reads

`TwoSunsDraw` logs, in test mode only, every text box and the glyph and curve boxes, and any problem. A failing run prints lines like `454px: <problem>` (`logger.debug`), and `tools/fit_all.sh` shows those containing `overlap` or `y=`:

- `cut: <sentence> y=<n>`: no font and no wording fitted the round chord at that row, so the sentence was cut with "...". Any `cut:` line fails the test. The fix is a shorter wording in `strings.xml` (and a `tools/check_strings.py` limit if it is a new sentence), a smaller cap in `TwoSunsLayout`, or a smaller font list.
- `<text> y=<n>`: a text box outside the display or the round chord.
- `glyph outside the content circle y=<n>` / `curve outside the content circle y=<n>`: the glyph or curve touches the ring.
- `state <n> overlap: '<a>' and '<b>'`: two boxes overlap.
- `state <n> drew <x> text rows, expected <y>`: a row the frame kept was silently not drawn.
- `state <n> stack is taller than the span even with rows dropped`.

A pass means none of these on the 31 states in Pro, 8 in Free (and as many by 9 always-on frames): layout and fit only, in English, not legibility, contrast or always-on behaviour.

## Settings

`tools/gen_settings.py [free|pro]` is the source of `resources-<tier>/settings/settings.xml` and `properties.xml` (no argument writes both tiers; the words are hand-written in `resources*/strings/strings.xml`; `--ids` prints the ids they must define). **There is no settings file in the shared `resources/`**: Free has `Accent` only, Pro has all five, and the generator refuses to write if `resources/settings` exists. `--check` exits 1 if either tier's files differ from what the tables generate, `resources/settings` exists, or a property id has no `KEY_*` constant in `TwoSunsConfig.mc`. **A Monkey C test cannot see a changed default in `properties.xml`**: the simulator keeps the last saved settings, so use `--check`. Keep the tables in step with `TwoSunsConfig` (`KEY_*`, `ACCENT_COUNT`, `ON`/`OFF`) and `TwoSunsPalette.ACCENTS` order.

## Tier-only code and resources

- `(:pro)` / `(:free)` on a function, constant, field or class compiles it into only that tier; a `(:free)` twin returns the default or does nothing. `(:test, :pro)` and `(:test, :free)` do the same for tests. An `import` **cannot** be annotated, which is why `TwoSunsSources` does not import `Position`, `SensorHistory`, `Weather` or `Activity` and names them in full inside its `(:pro)` functions.
  Pro-only so far: `TwoSunsSun`, `TwoSunsPlace`, `TwoSunsDateText`, `TwoSunsCurvePlan` (whole classes); `TwoSunsBattery.build`, `TwoSunsCurve.draw`; the history, location, place and date-line parts of `TwoSunsSources`; `KEY_ORIENTATION`, `KEY_GOLDEN`, `KEY_CURVE`, `KEY_DATE`, `KEY_PLACE`; the Pro items of the Customize menu; `TwoSunsView.drawCurve`. Free twins: `TwoSunsSky.noCalculationState` (no "No place yet"), `TwoSunsSettings.readPro`, `proKeys`.
- **The compiler is the permission check.** A call site that needs `SensorHistory` or `Positioning` fails the Free build with "Permission ... required"; that is how the first Free compile found every site. A new permissioned call outside `(:pro)` cannot reach Free.
- **AppName** is defined only in `resources-pro/strings` and `resources-free/strings`. A language does not inherit the default's strings, so each jungle appends its tier folder to every `base.lang.<l>` path; if you add a language, add its line to **both** jungles and its folder must not define AppName (`python3 tools/check_strings.py` fails if it does).
- **`Application.Properties.getValue` or `setValue` of a key missing from the properties file**: the SDK 9.2.0 reference (`Toybox/Application/Properties.html`) says both throw `Properties.InvalidKeyException`. Read from the docs, not observed. Free never touches a Pro key, so nothing relies on it, and `TwoSunsSettings.read` catches it for the Pro path. `freeMissingPropertyKeyThrows` records what the simulator does (written, not yet run).
- `tools/fit_languages.sh` takes `TIER=free` (default `pro`); its throwaway jungle excludes the other tier's annotation and searches the tier folder.
- **Test helpers** (top-level functions and constants in `source/test/` that are not tests) carry `(:debug)`, so a release export (`-e -r`, the store package) drops them; before that they compiled into the store `.prg` (found when the Free scan saw the Pro key `Curve` in a helper). `(:test)` cannot be used on a helper: the runner would call it as a test. Helpers inside the `(:test)` classes are dropped with the class. `tools/gen_sun_tests.py` emits `(:debug)` on its two helpers.
- `tools/gen_sun_tests.py` writes every reference test as `(:test, :pro)` (it tests `TwoSunsSun`, which Free does not compile). Do not hand-edit the generated file.

## Checking a store package (what the compiler actually produced)

A second `settings.xml` in a later resource folder is not proven to replace the first, so the tiers never share one (ADR-020, Free + Pro ladder). The proof is on the **compiled package**: a `.iq` is a 7-zip archive (macOS `bsdtar -xf x.iq` opens it; so does `7z x`). It holds, per part number, the compiled `.prg`, a `<part>-settings.json` (what the phone renders: every setting key, its list options, and every string in every language), a `debug.xml` (every function and source file the compiler kept) and one `manifest.xml` (with the permissions and the app id).

```sh
tools/check_free_package.sh --build     # export both packages (a few minutes each), then check
tools/check_free_package.sh             # check the existing dist/TwoSunsFree.iq and dist/TwoSunsPro.iq; fails as STALE if a source file is newer
```

It exits non-zero unless: the Free permission list is exactly `ComplicationSubscriber` and Pro's is `ComplicationSubscriber`, `Positioning`, `SensorHistory` (so Free is a subset); the Free settings keys are exactly `Accent` (ids 0 to 5) on every part number and Pro's are the five; no Free `.prg` contains the property names `Orientation`, `Golden` or `Curve` as standalone strings (a `.prg` stores `<length byte><text><NUL>`, so "Golden hour" and the French "Orientation de l'anneau" do not match; `Date` is not scanned because the shared setting title "Date" is that exact string, and is proved by the settings keys and the missing code); the word "Pro" appears nowhere in the Free package (manifest, settings strings in every language, `.prg`, `debug.xml`); no Free `debug.xml` names `positionLocation`, `readCurve`, `updatePlace`, `activityLocation`, `weatherLocation`, `fromStorage` or `drawDot`, the source files `TwoSunsSun.mc`, `TwoSunsPlace.mc`, `TwoSunsCurvePlan.mc` or `TwoSunsDateText.mc`, the modules `Position`, `SensorHistory`, `Weather`, `Activity` or `Storage`, or a `TwoSunsSources.initialize` (the only `Application.Storage` read; `updatePlace` is the write); Pro's `.prg` and `debug.xml` DO contain them (the modules `SensorHistory` and `Weather` and `TwoSunsSources.initialize` too; `Position`, `Activity` and `Storage` leave no module entry even in Pro, because Pro names them in full) (positive controls: they prove the Free checks can see what they look for); `AppName` is "Two Suns" in every language of Free and "Two Suns Pro" in every language of Pro; the app ids are the expected, different ones; and the part numbers equal the SDK's for the manifest's 69 product ids.
The Pro-setting display strings (`setting_golden`, `orientation_*`, ...) stay in the shared strings and ship, unreferenced, in Free; only the word "Pro", the keys and the code are policed. The check proves package contents; it does not prove behaviour on a watch.
Last run 2026-10-01 (compile only, simulator not used; re-run after the reviewer fixes): both packages OK on all 89 part numbers. Negative tests: feeding it the Pro package as the Free one fails on the app id, the permissions, the keys and AppName; feeding it the Free package as the Pro one fails likewise. The checks now also count one `.prg` and one `debug.xml` per product, scan the Free `.prg` for the Storage key `place` (Pro positive control), and fail rather than skip when a watched path is missing. The first run caught a real leak: the test helper `readingsState` named the Pro key `Curve` and unannotated helpers in test files compile into the store package (so it got a `(:free)` twin, `readingsSettings`).

## Sun reference tests

`tools/gen_sun_tests.py` writes `source/test/TwoSunsSunReferenceTest.mc` (Pro only, see above) from `research_notes/Body Battery and sun face research/reference_sun_times.tsv` (27 rows, US Naval Observatory; `SUN_TSV=<path>` overrides). Tolerance 2 minutes. Do not edit the generated file by hand.

## Translations

English is `resources/strings/strings.xml`; each other language is `resources-<lang>/strings/strings.xml` with identical ids and placeholders; a new language also needs its `<iq:language>` line in **both** `manifest.xml` and `manifest.free.xml`, its path line in **both** jungles, and no `AppName` in its strings (15 now: eng plus dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr). `python3 tools/check_strings.py` checks: same ids and placeholders as English; both manifests' languages equal the `resources-<lang>` folders and both jungles carry a `base.lang.<l>` line per language; each file carries the machine-drafted note and **none** defines `AppName` (it lives in the tier folders only: "Two Suns" and "Two Suns Pro"); no string the Free build ships contains the word "Pro"; sentences with no shorter wording (`sky_no_place`, `sky_no_data`, `sky_sun_up` and the two shortest polar sentences) at most 14 characters; every last-resort wording with a time at most 16 characters; each sentence's three wordings never get longer. Those are character counts, a proxy for the round chord.

`tools/fit_languages.sh [-l "deu fin"] <product>` (a product argument is required) runs the suite once per language by overlaying that language's strings in a throwaway jungle; the word tests assert English wording and error by design in another language, so only the two fit tests decide, and the script prints them. **Not run yet, in any language.** The test date line is fixed English, so the date line's width in translation is never measured. Translations are machine-drafted and **not read by a native speaker** (`listing/NOTES.md`).

## Compiler and SDK quirks

Found while building; each cost time.

- An `import` cannot carry `(:pro)`/`(:free)`; the compiler checks permissions at call sites only, so name a permissioned module in full inside the annotated function instead of importing it.
- A `private function` instance method called from a **static** method of the same class crashes `monkeyc` ("A critical error has occurred"). Keep such helpers non-private.
- `hidden` is a Monkey C keyword: do not name a variable that.
- `Toybox.Math` returns `Float` or `Double`: wrap results with `.toFloat()` (the `TwoSunsSun.f*` helpers).
- `Test.assertEqual` needs non-null arguments: use the `sunPresent` helper.
- Local variable types are inferred (no `var x as T`).
- `Activity.getActivityInfo()` is typed never-null: a null check is a compiler warning. The location code catches the exception instead.
- The test runner treats every `(:test)` function as a test case, which is why the shared test states are a class (`TwoSunsTestStates`).
- Monkey C floats are 32-bit: the sun maths runs on days since J2000, never a Julian date.
- `Position.getInfo()` without the Positioning permission ends the app and cannot be caught; it is isolated in `TwoSunsSources.positionLocation` ([ADR-005](decisions.md#adr-005-location-order-and-the-positioning-permission)).
- The simulator keeps the last saved settings (see Settings above).

## Device testing

The simulator proves geometry, fonts and logic. It cannot prove always-on behaviour, battery cost, MIP daylight contrast, real location or real Body Battery data. It has no GPS position, canned weather and Complication sun values (a sunset earlier than the sunrise), and a synthetic Body Battery history (480 samples a minute apart, oldest first, mostly dated in the future). The owner's tests are in the git-ignored `../device-test/`: `LocationProbe-P.prg` and `LocationProbe-N.prg` ran on the FR965 2026-09-27 (M1, M2 only; results in `LocationProbe-RESULTS.md`; M3/M4 left for later). `TwoSuns-CHECKLIST.md` (the phase 9 wear checklist, for the face itself) is not written yet. Follow the owner's habit: dev build only, all-day wear, no swaps.

## Screenshots (Instinct and any layout change)

The unit suite measures numbers; it cannot see the bezel. For every layout change, photograph what the simulator draws (the face on its device skin, with the real fonts and the real bezel mask): `../docker/shot.sh TwoSuns monkey.jungle instincte45mm` writes `bin/shot-<device>-face.png` (the display, 3x). The Instinct's visible area is a circle about 98 px in radius, which a 176 x 176 square test misses (HeroSet ADR-055, amended 2026-10-03). `FAKETIME="2026-10-04 10:09:00"` sets the simulator's clock.

**Weather Editor and Always-On in the simulator (2026-10-04).** `tools/weather_conditions.sh` (run through `../docker/capture.sh`) drives Settings > Set Weather and Settings > Display Mode by clicks. Result: the editor keeps the Condition, but the face's weather row did not follow it (canned partly cloudy, 77 degrees every time), and Always-On left the full face drawn. So icon shapes per condition (ROADMAP 9.5, B5 rain) stay unit-tested only, and the always-on frame is not seen in a picture; both need the wrist.
