# Development

Connect IQ SDK 9.2.0, Monkey C. `monkeyc`/`monkeydo` live in the SDK's `bin/`
folder if they are not on `PATH`. The signing key is
`~/.garmin-connectiq/keys/developer_key`, outside every repo, shared with the
other Verden apps; losing it prevents store updates.

```sh
KEY=~/.garmin-connectiq/keys/developer_key
monkeyc -d fr965 -f monkey.jungle -o bin/TwoSuns.prg -y $KEY -w --typecheck 3   # build (strict; the only accepted notices are launcher-icon scaling on non-65 px screens until the real icon ships)
tools/run_tests.sh fr965 [testName]                                             # unit tests
monkeydo bin/TwoSuns.prg fr965                                                  # run the face (simulator running)
monkeyc -e -r -f monkey.jungle -o dist/TwoSuns.iq -y $KEY                       # store package (prints "89 OUT OF 89 DEVICES BUILT" for 69 products: see compatibility.md)
tools/fit_all.sh                                                                # screen fit, ten devices
tools/fit_products.sh [id ...]                                                  # the whole suite on every manifest product (slow)
python3 tools/gen_settings.py [--check|--ids]                                   # settings resources
python3 tools/gen_sun_tests.py                                                  # regenerate source/test/TwoSunsSunReferenceTest.mc
python3 tools/check_strings.py                                                  # translation parity and length
tools/fit_languages.sh [-l "deu fin"] <product>...                              # the suite once per language
```

Trust the printed `PASSED (…)` line, not an exit code. A run that prints nothing
means the simulator wedged; `tools/run_tests.sh` restarts it once. The simulator
is started with `"$(dirname "$(command -v monkeyc)")/connectiq"`. Output goes to
`bin/t-<device>.log` (git-ignored).

There is no beta-package tooling here (Days To Go's `make_beta.py` was not copied): settings are lists with defaults and there is no on-watch settings screen to test.

`monkey.jungle` sets `base.sourcePath = source` on purpose: without it the build
also compiles anything under `docs/`.

## Shared simulator: read before running anything

There is one simulator per machine. `tools/run_tests.sh` (and so `fit_all.sh` and `fit_products.sh`) runs `pkill -f monkeydo` after **every** run, so it ends whatever app or test another session has running in the simulator, and when a run prints no result it also `pkill`s the simulator itself and starts it again. `tools/fit_languages.sh` does the same only on a no-result retry. If another Claude session, the owner or a probe run is using the simulator, those scripts kill their work, and their output gets mixed with yours. Check that nobody is using it before a run, do not run two suites at once, and never `pkill` it by hand for someone else. Simulator wedges are common even when it is not shared. `tools/fit_products.sh` was **not run** during the build for exactly this reason.

## The test kinds

120 tests, 2026-09-26, the same count on every device.

- **Logic**: the sun calculation and 27 generated USNO reference tests (`TwoSunsSunReferenceTest`), calendar, exact local offset, Body Battery buckets, place rounding and hysteresis, sky states, readings (words), settings validation, date text, ring plan (angles, arcs, ticks, colours and their contrast), curve plan and band. None checks pixels.
- **Screen fit** (`everyStateFitsThisDisplay`): renders 31 states (10 sun states times 3 Body Battery states, plus one with the date off) at the device's real resolution and fonts. `alwaysOnFrameFitsAtEveryDrift` does the same for the always-on frame at the nine drift positions. Run per screen size after any layout or string change:
  ```sh
  tools/fit_all.sh          # fr255s fenix7s fenix7 fenix7x fr265s fr165 epix2 fr965 venusq2 fenix9pro51mm
  ```
- **Tiny-surface tests** (`frameDropsRowsInOrder`, `framesDropRowsInOrderWhenTheScreenIsTiny`, `bigScreensKeepEveryRow`) force the drop order (date, curve, sun line) and check big screens keep every row; `truncatedKeepsTheMarker` checks the "..." marker.
- **Layout report** (`twoSunsLayoutReport`): prints every row's box for the live state and one test state. This is how layout is read here, because the environment cannot capture the simulator (`Dc.getPixel` does not exist in SDK 9.2). Read `bin/t-<device>.log`.

### How the fit test reads

`TwoSunsDraw` logs, in test mode only, every text box and the glyph and curve boxes, and any problem. A failing run prints lines like `454px: <problem>` (`logger.debug`), and `tools/fit_all.sh` shows those containing `overlap` or `y=`:

- `cut: <sentence> y=<n>`: no font and no wording fitted the round chord at that row, so the sentence was cut with "...". Any `cut:` line fails the test. The fix is a shorter wording in `strings.xml` (and a `tools/check_strings.py` limit if it is a new sentence), a smaller cap in `TwoSunsLayout`, or a smaller font list.
- `<text> y=<n>`: a text box outside the display or the round chord.
- `glyph outside the content circle y=<n>` / `curve outside the content circle y=<n>`: the glyph or curve touches the ring.
- `state <n> overlap: '<a>' and '<b>'`: two boxes overlap.
- `state <n> drew <x> text rows, expected <y>`: a row the frame kept was silently not drawn.
- `state <n> stack is taller than the span even with rows dropped`.

A pass means none of these on the 31 states (and 31 by 9 always-on frames): layout and fit only, in English, not legibility, contrast or always-on behaviour.

## Settings

`tools/gen_settings.py` is the source of `resources/settings/settings.xml` and `properties.xml` (the words are hand-written in `resources*/strings/strings.xml`; `--ids` prints the ids they must define). `--check` exits 1 if the files differ from what the tables generate or a property id has no `KEY_*` constant in `TwoSunsConfig.mc`. **A Monkey C test cannot see a changed default in `properties.xml`**: the simulator keeps the last saved settings, so use `--check`. Keep the tables in step with `TwoSunsConfig` (`KEY_*`, `ACCENT_COUNT`, `ON`/`OFF`) and `TwoSunsPalette.ACCENTS` order.

## Sun reference tests

`tools/gen_sun_tests.py` writes `source/test/TwoSunsSunReferenceTest.mc` from `research_notes/Body Battery and sun face research/reference_sun_times.tsv` (27 rows, US Naval Observatory; `SUN_TSV=<path>` overrides). Tolerance 2 minutes. Do not edit the generated file by hand.

## Translations

English is `resources/strings/strings.xml`; each other language is `resources-<lang>/strings/strings.xml` with identical ids and placeholders; a new language also needs its `<iq:language>` line in `manifest.xml` (15 now: eng plus dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr). `python3 tools/check_strings.py` checks: same ids and placeholders as English; the manifest's languages equal the `resources-<lang>` folders; each file carries the machine-drafted note and `AppName` is "Two Suns"; sentences with no shorter wording (`sky_no_place`, `sky_no_data`, `sky_sun_up` and the two shortest polar sentences) at most 14 characters; every last-resort wording with a time at most 16 characters; each sentence's three wordings never get longer. Those are character counts, a proxy for the round chord.

`tools/fit_languages.sh [-l "deu fin"] <product>` (a product argument is required) runs the suite once per language by overlaying that language's strings in a throwaway jungle; the word tests assert English wording and error by design in another language, so only the two fit tests decide, and the script prints them. **Not run yet, in any language.** The test date line is fixed English, so the date line's width in translation is never measured. Translations are machine-drafted and **not read by a native speaker** (`listing/NOTES.md`).

## Compiler and SDK quirks

Found while building; each cost time.

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
