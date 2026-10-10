# Development

Connect IQ SDK 9.2.0, Monkey C. `monkeyc`/`monkeydo` in SDK `bin/` folder if not on `PATH`. Signing key `~/.garmin-connectiq/keys/developer_key`, outside every repo, shared with other Verden apps; losing it prevents store updates.

Two builds, one source (ADR-014, the Free + Pro ladder): **Pro** = `monkey.jungle` (live app id, `manifest.xml`); **Free** = `monkey.free.jungle` (`manifest.free.xml`, own app id). Every command below takes either jungle.

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
python3 tools/gen_settings.py [free|pro] [--ids]                                # settings resources (incl. resources-accent-<tier>/, the Accent list the Instinct products leave out, ADR-015)
pkill -f monkeydo; pkill -f "ConnectIQ.app/Contents/MacOS"                      # reset a wedged simulator
```

`dist/DaysToGo-1.0.1-submitted.iq` = paid 1.0.1 package as submitted 2026-09-26 (kept for reference; `dist/` git-ignored).
`dist/DaysToGoFree.iq` = **Free** package; `dist/DaysToGoPro.iq` = paid; old name `dist/DaysToGo.iq` no longer produced.

Trust printed `PASSED (…)` line, not exit code. Run printing nothing = simulator wedged; `tools/run_tests.sh` restarts it once. Simulator started with `"$(dirname "$(command -v monkeyc)")/connectiq"`.

Both jungles set `base.sourcePath = source` on purpose: without it build also compiles anything under `docs/`.

## The test kinds

- **Logic**: counting rule, calendar, settings validation, date text, state words.
- **Screen fit** (`everyStateFitsThisDisplay`): renders widest states with device's real fonts; fails on text outside round display or overlapping another row. `alwaysOnFrameFitsAtEveryDrift` same for always-on frame at nine drift positions. Run per screen size after any layout or string change:
  ```sh
  for d in fr55 fenix5s fenix5 vivoactive4 fenix7x fr265s fr165 epix2 fr965 fenix9pro51mm; do
    tools/run_tests.sh $d monkey.jungle everyStateFitsThisDisplay      # and monkey.free.jungle; tools/fit_all.sh [jungle] loops this
  done
  ```
- **Layout report** (`daysToGoLayoutReport`): prints every row's box; how layout is read here, because environment cannot capture simulator. Output in `bin/t-<device>.log`.
- Word tests assume simulator language English. `tools/fit_languages.sh [-l "deu fin"] <device>` runs suite once per language by overlaying that language's strings (word tests then error by design; two fit tests decide, printed).

## Settings

`tools/gen_settings.py [free|pro]` = source of `resources-<tier>/settings/settings.xml` and `properties.xml` (no argument writes both tiers) and of `resources/strings/generated.xml` (numbers only, not translated, copy in every language folder). **No settings file in shared `resources/`**: Free's lists omit Hour, Minute, EventZone, Footer; Pro's have all; generator refuses to run if `resources/settings` exists. Hand-written ids: `python3 tools/gen_settings.py [free] --ids`.
`PICKER_FIRST_YEAR/PICKER_LAST_YEAR` in `DaysToGoConfig` must match `FIRST_YEAR/LAST_YEAR` in script.

## Tier-only code and resources

- `(:pro)` / `(:free)` on function or constant compiles it into only that tier; `(:free)` twin returns default. `(:test, :pro)` and `(:test, :free)` same for tests.
  Pro-only so far: `Hour` and `Footer` reads in `DaysToGoSettings`, `DaysToGoReadings.footerText` and `stepsText`, `KEY_HOUR` and `KEY_FOOTER`.
- **AppName** defined only in `resources-pro/strings` and `resources-free/strings`. Language does not inherit default's strings, so each jungle appends its tier folder to every `base.lang.<l>` path; adding language -> add its line to **both** jungles (`make_beta.py` copies `monkey.jungle`); its folder must not define AppName (`python3 tools/check_strings.py` fails if it does).
- **`Application.Properties.getValue` of key missing from properties file**: SDK 9.2.0 reference says throws `Properties.InvalidKeyException`. Also observed in simulator, 2026-10-01: see test below.
  Free code never reads Hour, Minute, EventZone, Footer, so nothing relies on it; `DaysToGoSettings.read` catches it for Pro path. Test `freeMissingPropertyKeyThrows` passed on Free (fr965, fr55, venusq2): calls `getValue("Hour")` where properties file lacks Hour, catches only `Properties.InvalidKeyException`, asserts thrown; proves simulator throws that exception (not null, not default, not another type), nothing about real watch.
- `tools/fit_languages.sh` takes `TIER=free` (default `pro`).

## Checking a store package (what the compiler actually produced)

Second `settings.xml` in later resource folder not proven to replace first, so tiers never share one (ADR-014, the Free + Pro ladder). Proof is on the **compiled package**:
`.iq` = 7-zip archive (macOS `bsdtar -xf x.iq` opens it; so does `7z x`). Holds, per product part number: compiled `.prg`, `<part>-settings.json` (what phone renders: every setting key, list options, every string in every language), `manifest.xml`.

```sh
tools/check_free_package.sh --build     # export both packages (about 4 minutes), then check
tools/check_free_package.sh             # check the existing dist/DaysToGoFree.iq (Free) and dist/DaysToGoPro.iq (Pro)
```

Exits non-zero unless: Free settings keys exactly Event, Name, Month, Day, Year, Unit, DateStyle, Accent (ids 0 to 5) on every part number; Hour, Minute, EventZone, Footer appear in no Free `.prg`; word "Pro" appears nowhere in Free package (manifest, settings strings in every language, compiled `.prg`); `AppName` is "Days To Go" in every language of Free and "Days To Go Pro" in every language of Pro; app ids expected, different; no permissions.
**Positive controls**: every Pro `.prg` must contain names Hour, Minute, EventZone, Footer and string "Days To Go Pro"; Pro settings must carry both keys, so Free checks known able to see what they look for.
**Stale guard**: fails if any file under `source/`, `resources*/`, either jungle or either manifest newer than a package (rebuild with `--build`). **Product count**: manifest must list 120 product ids; packages' part numbers must all be ones SDK (`Devices/<id>/compiler.json`) assigns to those ids; packages hold 199 of SDK's 200 part numbers for them (`006-B2994-00` absent from both tiers, reported as note, not failed).
**Not proven**: that Hour and Footer display strings (`setting_hour`, `footer_*`, `h0` to `h23`) are absent. They live in shared strings, still ship unreferenced in Free (Minute and zone strings in Pro-only folders, do not); only settings keys, compiled property names, word "Pro" policed. Proves package contents, not behaviour on watch.
Last run 2026-10-01 after final edits: both packages OK (`--build`, compile only, simulator not used). Negative tests: Pro package passed as Free fails (app id, keys, AppName); package older than sources fails as STALE.

## Beta app

`tools/make_beta.py` copies `manifest.xml` to `manifest-beta.xml` with app id from `tools/beta-app-id.txt` (tracked, not secret) and writes `beta.jungle` (copy of `monkey.jungle` with beta manifest: **Pro** build with second app id).
Upload `dist/DaysToGo-beta.iq` at developer dashboard with "Beta App" checked, then install from Connect IQ app's uploaded apps to test phone's settings screen.

## Translations

English = `resources/strings/strings.xml`; each other language = `resources-<lang>/strings/strings.xml`, identical ids. Check parity: `python3 tools/check_strings.py`. New language also needs its `<iq:language>` line in **both** `manifest.xml` and `manifest.free.xml`, its path in both jungles, no AppName in its strings. Translations machine-drafted, **not read by native speaker** (`listing/NOTES.md`).

## Device testing

Simulator proves geometry, fonts, logic. Cannot prove always-on behaviour, battery cost, MIP daylight contrast, phone's settings delivery.
Owner's checklist in git-ignored `../device-test/checklists/DaysToGo-CHECKLIST.md`.

## Screenshots (Instinct and any layout change)

Unit suite measures numbers; cannot see bezel. Every layout change: photograph what simulator draws (face on device skin, real fonts, real bezel mask): `../docker/shot.sh DaysToGo monkey.jungle instinct2 instincte40mm` writes `bin/shot-<device>-face.png` (display, 3x). Instinct's visible area = circle ~98 px radius, which 176 x 176 square test misses: finished-day footer clipped in HeroSet that way (HeroSet ADR-055 (Instinct bezel clipping), amended 2026-10-03). `PREP='sed -i ... resources/properties.xml' ../docker/shot.sh ...` shows particular state without touching repo.