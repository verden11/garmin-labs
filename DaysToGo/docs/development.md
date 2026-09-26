# Development

Connect IQ SDK 9.2.0, Monkey C. `monkeyc`/`monkeydo` live in the SDK's `bin/`
folder if they are not on `PATH`. The signing key is
`~/.garmin-connectiq/keys/developer_key`, outside every repo, shared with the
other Verden apps; losing it prevents store updates.

```sh
KEY=~/.garmin-connectiq/keys/developer_key
monkeyc -d fr965 -f monkey.jungle -o bin/DaysToGo.prg -y $KEY -w --typecheck 3   # build (strict; the only warnings are the launcher-icon size notices on non-65 px screens until the real icon ships)
tools/run_tests.sh fr965 [testName]                                             # unit tests
monkeydo bin/DaysToGo.prg fr965                                                 # run the face (simulator running)
monkeyc -e -r -f monkey.jungle -o dist/DaysToGo.iq -y $KEY                      # store package
python3 tools/make_beta.py && monkeyc -e -r -f beta.jungle -o dist/DaysToGo-beta.iq -y $KEY   # beta package
python3 tools/gen_settings.py [--ids]                                           # settings resources
pkill -f monkeydo; pkill -f "ConnectIQ.app/Contents/MacOS"                      # reset a wedged simulator
```

Trust the printed `PASSED (…)` line, not an exit code. A run that prints nothing
means the simulator wedged; `tools/run_tests.sh` restarts it once. The simulator
is started with `"$(dirname "$(command -v monkeyc)")/connectiq"`.

`monkey.jungle` sets `base.sourcePath = source` on purpose: without it the build
also compiles anything under `docs/`.

## The test kinds

- **Logic**: the counting rule, calendar, settings validation, date text, state words.
- **Screen fit** (`everyStateFitsThisDisplay`): renders the widest states with the
  device's real fonts and fails on text outside the round display or overlapping
  another row. `alwaysOnFrameFitsAtEveryDrift` does the same for the always-on
  frame at the nine drift positions. Run per screen size after any layout or string change:
  ```sh
  for d in fr55 fenix5s fenix5 vivoactive4 fenix7x fr265s fr165 epix2 fr965 fenix9pro51mm; do
    tools/run_tests.sh $d everyStateFitsThisDisplay
  done
  ```
- **Layout report** (`daysToGoLayoutReport`): prints every row's box; this is how layout
  is read here, because the environment cannot capture the simulator. Output is in `bin/t-<device>.log`.
- Word tests assume the simulator language is English. `tools/fit_languages.sh [-l "deu fin"] <device>` runs the suite once per language by overlaying that language's strings (the word tests then error by design; the two fit tests decide and are printed).

## Settings

`tools/gen_settings.py` is the source of `resources/settings/settings.xml`,
`properties.xml` and `resources/strings/generated.xml` (numbers only, not
translated). Hand-written ids: `python3 tools/gen_settings.py --ids`.
`PICKER_FIRST_YEAR/PICKER_LAST_YEAR` in `DaysToGoConfig` must match `FIRST_YEAR/LAST_YEAR` in the script.

## Beta app

`tools/make_beta.py` copies `manifest.xml` to `manifest-beta.xml` with the app id
from `tools/beta-app-id.txt` (tracked, not secret) and writes `beta.jungle`.
Upload `dist/DaysToGo-beta.iq` at the developer dashboard with "Beta App" checked,
then install it from the Connect IQ app's uploaded apps to test the phone's settings screen.

## Translations

English is `resources/strings/strings.xml`; each other language is
`resources-<lang>/strings/strings.xml` with identical ids. Check parity with
`python3 tools/check_strings.py`. A new language also needs its `<iq:language>`
line in `manifest.xml`. Translations are machine-drafted and **not read by a
native speaker** (`listing/NOTES.md`).

## Device testing

The simulator proves geometry, fonts and logic. It cannot prove always-on
behaviour, battery cost, MIP daylight contrast or the phone's settings delivery.
The owner's checklist lives in the git-ignored `../device-test/DaysToGo-CHECKLIST.md`.
