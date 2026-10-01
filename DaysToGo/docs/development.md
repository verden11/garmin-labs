# Development

Connect IQ SDK 9.2.0, Monkey C. `monkeyc`/`monkeydo` live in the SDK's `bin/`
folder if they are not on `PATH`. The signing key is
`~/.garmin-connectiq/keys/developer_key`, outside every repo, shared with the
other Verden apps; losing it prevents store updates.

Two builds come from one source (ADR-014, the Free + Pro ladder): **Pro** is `monkey.jungle` (the live app id, `manifest.xml`) and **Free** is
`monkey.free.jungle` (`manifest.free.xml`, its own app id). Every command below takes either jungle.

```sh
KEY=~/.garmin-connectiq/keys/developer_key
monkeyc -d fr965 -f monkey.jungle      -o bin/pro.prg  -y $KEY -w --typecheck 3   # Pro build (strict; the only warnings are the launcher-icon size notices on non-65 px screens until the real icon ships)
monkeyc -d fr965 -f monkey.free.jungle -o bin/free.prg -y $KEY -w --typecheck 3   # Free build
tools/run_tests.sh fr965 [jungle] [testName]                                    # unit tests; jungle defaults to monkey.jungle (Pro); the old <device> [testName] form still works
tools/run_tests.sh fr965 monkey.free.jungle                                     # the same suite on Free
tools/compile_sweep.sh                                                          # compile every manifest product, both jungles, no simulator (about 20 min)
monkeydo bin/pro.prg fr965                                                      # run the face (simulator running)
monkeyc -e -r -f monkey.free.jungle -o dist/DaysToGoFree.iq -y $KEY             # Free store package
monkeyc -e -r -f monkey.jungle      -o dist/DaysToGoPro.iq -y $KEY              # Pro store package
tools/check_free_package.sh [--build]                                           # prove the packages' contents (below)
python3 tools/make_beta.py && monkeyc -e -r -f beta.jungle -o dist/DaysToGo-beta.iq -y $KEY   # beta package (Pro build, own app id)
python3 tools/gen_settings.py [free|pro] [--ids]                                # settings resources
pkill -f monkeydo; pkill -f "ConnectIQ.app/Contents/MacOS"                      # reset a wedged simulator
```

`dist/DaysToGo-1.0.1-submitted.iq` is the paid 1.0.1 package as submitted on 2026-09-26 (kept for reference; `dist/` is git-ignored).
`dist/DaysToGoFree.iq` is the **Free** package and `dist/DaysToGoPro.iq` the paid one; the old name `dist/DaysToGo.iq` is no longer produced.

Trust the printed `PASSED (…)` line, not an exit code. A run that prints nothing
means the simulator wedged; `tools/run_tests.sh` restarts it once. The simulator
is started with `"$(dirname "$(command -v monkeyc)")/connectiq"`.

Both jungles set `base.sourcePath = source` on purpose: without it the build
also compiles anything under `docs/`.

## The test kinds

- **Logic**: the counting rule, calendar, settings validation, date text, state words.
- **Screen fit** (`everyStateFitsThisDisplay`): renders the widest states with the
  device's real fonts and fails on text outside the round display or overlapping
  another row. `alwaysOnFrameFitsAtEveryDrift` does the same for the always-on
  frame at the nine drift positions. Run per screen size after any layout or string change:
  ```sh
  for d in fr55 fenix5s fenix5 vivoactive4 fenix7x fr265s fr165 epix2 fr965 fenix9pro51mm; do
    tools/run_tests.sh $d monkey.jungle everyStateFitsThisDisplay      # and monkey.free.jungle; tools/fit_all.sh [jungle] loops this
  done
  ```
- **Layout report** (`daysToGoLayoutReport`): prints every row's box; this is how layout
  is read here, because the environment cannot capture the simulator. Output is in `bin/t-<device>.log`.
- Word tests assume the simulator language is English. `tools/fit_languages.sh [-l "deu fin"] <device>` runs the suite once per language by overlaying that language's strings (the word tests then error by design; the two fit tests decide and are printed).

## Settings

`tools/gen_settings.py [free|pro]` is the source of `resources-<tier>/settings/settings.xml`
and `properties.xml` (no argument writes both tiers) and of `resources/strings/generated.xml`
(numbers only, not translated, and a copy in every language folder). **There is no settings
file in the shared `resources/`**: Free's lists omit Hour and Footer, Pro's have them all, and
the generator refuses to run if `resources/settings` exists. Hand-written ids:
`python3 tools/gen_settings.py [free] --ids`.
`PICKER_FIRST_YEAR/PICKER_LAST_YEAR` in `DaysToGoConfig` must match `FIRST_YEAR/LAST_YEAR` in the script.

## Tier-only code and resources

- `(:pro)` / `(:free)` on a function or constant compiles it into only that tier; a `(:free)` twin returns the default. `(:test, :pro)` and `(:test, :free)` do the same for tests.
  Pro-only so far: the `Hour` and `Footer` reads in `DaysToGoSettings`, `DaysToGoReadings.footerText` and `stepsText`, `KEY_HOUR` and `KEY_FOOTER`.
- **AppName** is defined only in `resources-pro/strings` and `resources-free/strings`. A language does not inherit the default's strings, so each jungle appends its tier folder to every
  `base.lang.<l>` path; if you add a language, add its line to **both** jungles (`make_beta.py` copies `monkey.jungle`) and its folder must not define AppName (`python3 tools/check_strings.py` fails if it does).
- **`Application.Properties.getValue` of a key missing from the properties file**: SDK 9.2.0's reference says it throws `Properties.InvalidKeyException`. Observed too, in the simulator, 2026-10-01: see the test below.
  The Free code never reads Hour or Footer, so nothing relies on it, and `DaysToGoSettings.read` catches it for the Pro path. The test `freeMissingPropertyKeyThrows` passed on Free (fr965, fr55, venusq2): it calls `getValue("Hour")` where the properties file lacks Hour, catches only `Properties.InvalidKeyException` and asserts it was thrown, so it proves the simulator throws that exception (not null, not a default, not another type) and nothing about a real watch.
- `tools/fit_languages.sh` takes `TIER=free` (default `pro`).

## Checking a store package (what the compiler actually produced)

A second `settings.xml` in a later resource folder is not proven to replace the first, so the tiers never share one (ADR-014, the Free + Pro ladder). The proof is on the **compiled package**:
a `.iq` is a 7-zip archive (macOS `bsdtar -xf x.iq` opens it; so does `7z x`). It holds, per product part number, the compiled `.prg`, a `<part>-settings.json` (what the phone renders:
every setting key, its list options, and every string in every language) and a `manifest.xml`.

```sh
tools/check_free_package.sh --build     # export both packages (about 4 minutes), then check
tools/check_free_package.sh             # check the existing dist/DaysToGoFree.iq (Free) and dist/DaysToGoPro.iq (Pro)
```

It exits non-zero unless: the Free settings keys are exactly Event, Name, Month, Day, Year, Unit, DateStyle, Accent (ids 0 to 5) on every part number; Hour and Footer appear in no Free `.prg`;
the word "Pro" appears nowhere in the Free package (manifest, settings strings in every language, compiled `.prg`); `AppName` is "Days To Go" in every language of Free and "Days To Go Pro" in every language of Pro; the app ids are the expected, different ones; no permissions.
**Positive controls**: every Pro `.prg` must contain the names Hour and Footer and the string "Days To Go Pro", and the Pro settings must carry both keys, so the Free checks are known to be able to see what they look for.
**Stale guard**: it fails if any file under `source/`, `resources*/`, either jungle or either manifest is newer than a package (rebuild with `--build`). **Product count**: the manifest must list 120 product ids, and the packages' part numbers must all be ones the SDK
(`Devices/<id>/compiler.json`) assigns to those ids; the packages hold 199 of the SDK's 200 part numbers for them (`006-B2994-00` is absent from both tiers, reported as a note, not failed).
**Not proven**: that the Hour and Footer display strings (`setting_hour`, `footer_*`, `h0` to `h23`) are absent. They live in the shared strings and still ship, unreferenced, in Free; only the settings keys, the compiled property names and the word "Pro" are policed. It proves package contents, not behaviour on a watch.
Last run 2026-10-01 after the final edits: both packages OK (`--build`, compile only, simulator not used). Negative tests: the Pro package passed as the Free one fails (app id, keys, AppName); a package older than the sources fails as STALE.

## Beta app

`tools/make_beta.py` copies `manifest.xml` to `manifest-beta.xml` with the app id
from `tools/beta-app-id.txt` (tracked, not secret) and writes `beta.jungle` (a copy of `monkey.jungle` with the beta manifest: it is the **Pro** build with a second app id).
Upload `dist/DaysToGo-beta.iq` at the developer dashboard with "Beta App" checked,
then install it from the Connect IQ app's uploaded apps to test the phone's settings screen.

## Translations

English is `resources/strings/strings.xml`; each other language is
`resources-<lang>/strings/strings.xml` with identical ids. Check parity with
`python3 tools/check_strings.py`. A new language also needs its `<iq:language>`
line in **both** `manifest.xml` and `manifest.free.xml`, its path in both jungles, and no AppName in its strings. Translations are machine-drafted and **not read by a
native speaker** (`listing/NOTES.md`).

## Device testing

The simulator proves geometry, fonts and logic. It cannot prove always-on
behaviour, battery cost, MIP daylight contrast or the phone's settings delivery.
The owner's checklist lives in the git-ignored `../device-test/DaysToGo-CHECKLIST.md`.
