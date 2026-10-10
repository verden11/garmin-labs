# Development

Connect IQ SDK 9.2.0, Monkey C. `monkeyc`/`monkeydo` in SDK `bin/` folder if not on `PATH`
(`~/Library/Application Support/Garmin/ConnectIQ/Sdks/<sdk>/bin/`). Signing
key at `~/.garmin-connectiq/keys/developer_key`, outside every repo, shared
with HeroSet; losing it prevents store updates.

Two builds, one source (ADR-001, the Free + Pro ladder): **Pro** = `monkey.jungle` (live app id, `manifest.xml`); **Free** = `monkey.free.jungle` (`manifest.free.xml`, own app id). Every command below takes either jungle.

```sh
KEY=~/.garmin-connectiq/keys/developer_key

monkeyc -d fr965 -f monkey.jungle      -o bin/HeroFace.prg     -y $KEY -w --typecheck 3   # Pro (strict; only launcher-icon size notices on non-65 px screens)
monkeyc -d fr965 -f monkey.free.jungle -o bin/HeroFaceFree.prg -y $KEY -w --typecheck 3   # Free
monkeydo bin/HeroFace.prg fr965              # simulator must be running

tools/run_tests.sh fr965 [jungle] [testName]   # unit tests; jungle defaults to monkey.jungle (Pro); the old <device> [testName] form still works
tools/run_tests.sh fr965 monkey.free.jungle    # the same suite on Free
tools/compile_sweep.sh [jungle]                # compile every manifest product, both jungles unless one is named, no simulator
monkeyc -t -d fr965 -f monkey.jungle -o bin/t-fr965.prg -y $KEY && monkeydo bin/t-fr965.prg fr965 -t   # what run_tests.sh does, by hand

monkeyc -e -r -f monkey.free.jungle -o dist/HeroFaceFree.iq -y $KEY   # Free store package
monkeyc -e -r -f monkey.jungle      -o dist/HeroFacePro.iq  -y $KEY   # Pro store package
tools/check_free_package.sh [--build]          # prove the packages' contents (below)
python3 tools/check_strings.py                 # translation parity and the AppName rules
```

`dist/` holds only packages to upload, named with tier and version (`HeroFaceFree-1.0.0.iq`, `HeroFacePro-1.1.0.iq`); older exports
deleted 2026-10-05 (rebuild from git if ever needed).
Both jungles set `base.sourcePath = source` on purpose: without it build also compiles anything under `docs/`.

Trust printed `PASSED (…)` line, not exit code. Run hangs = simulator wedged: quit, restart, rerun. Happens every few runs.

## The test kinds

Pro runs 24 tests, Free 24 (**PASSED in the simulator on both jungles on fr965, fenix5s and fr55, 2026-10-01**; ten-size fit loop (Free, 2026-10-04: 25/25 on all ten sizes plus `vivoactive3`) and memory view (2026-10-04, `compatibility.md` "Measured 2026-10-04") run later, Pro ten-size loop run 2026-10-04, 25/25 on 12 products; use `EXPECT=24` or 4th argument of `tools/run_tests.sh` to fail full run on count mismatch): 22 shared, `disabledSecondsDrawNoSecondsBox`
and `proSettingsReadTheirDefaults` Pro-only (`(:test, :pro)`), `freeReturnsDefaultsForProKeys` and `freeMissingPropertyKeyThrows` Free-only.

- **Logic** (`HeroFaceLogicTest`): streak arithmetic, HeroSet's contract, ring average, time wording. No device needed.
- **Accent table** (`HeroFaceAccentTest`): every channel in {00, 55, AA, FF}, at least 3:1 on black, Blue and Cyan keep their colours, Magenta is owner's 2026-10-04 recolour (ADR-003),
  out-of-range falls back to default, no accent is a reserved role colour, face's own rule (3:1 against TRACK):
  all three pass (`everyAccentClearsTheTrackRule`), Magenta's 4.42:1 pinned by `magentaWasRecolouredToClearTheTrackRule`.
- **Settings** (`HeroFaceSettingsTest`): Pro reads shipped defaults; Free reads none of five Pro keys (Auto slots, no seconds, no temperature), missing key throws `InvalidKeyException`.
- **Screen fit** (`everyStateFitsThisDisplay`): renders face's widest
  states with device's real fonts, fails on text leaving round
  display or overlapping another row. Run per screen size after any layout
  or string change:
  ```sh
  for d in fr55 fenix5s fenix5 vivoactive4 fenix7x fr265s fr165 epix2 fr965 fenix9pro51mm; do
    tools/run_tests.sh $d monkey.jungle everyStateFitsThisDisplay      # and monkey.free.jungle
  done
  ```
  Those ten cover every screen size 208 to 466 px.
  Fit states always carry seconds (`"59"`) and temperature (`"-20°"`), so on Free jungle they still draw Pro-shaped frames: passing Free fit run does not verify Free's own row under time (streak alone, centred).
- **Live language** (`everyLabelFitsThisLanguage`): renders labels of
  whichever language simulator is set to. Set language in
  simulator (Settings → System → Language), then run. Do for long
  ones after any label change: German, Dutch, Finnish, Lithuanian, Ukrainian.

`heroFaceLayoutReport` prints every row's box, resolved slot metrics, device's capability flags. Used to check layout here, because this
environment cannot capture simulator.

## Translations

English in `resources/strings/strings.xml`; each other language is `resources-<lang>/strings/strings.xml` with same ids. Every id and
placeholder must match English exactly — check with `python3 tools/check_strings.py`
(also enforces AppName rules below, and that no shared string says "Pro").

**AppName** defined only in `resources-pro/strings` ("HeroFace Pro") and `resources-free/strings` ("HeroFace"), never in `resources/` or `resources-<lang>/`: language
folder defining it would override tier name on non-English watch. Language does **not** inherit default's strings (compiler warns "String id 'AppName'
undefined for language ..."), so each jungle appends its tier folder to every `base.lang.<l>` path.

New language also needs its `<iq:language>` line in **both** `manifest.xml` and `manifest.free.xml`, its `base.lang.<l>` line in **both** jungles, no AppName in its strings.

Watch labels uppercase, have short form for narrow columns; face
measures, picks longest wording that fits, so long translation
degrades instead of clipping. Weekday and month names from system, so
already translated.

## Tier-only code and resources

- `(:pro)` / `(:free)` on function, field or constant compiles it into only that tier; `(:free)` twin returns default. `(:test, :pro)` and `(:test, :free)` same for tests.
  Pro-only: Slot1-3, Seconds, Weather reads in `HeroFaceSettings`, `HeroFaceReadings.temperature` (`Toybox.Weather` reads), `HeroFaceView.onPartialUpdate`, `disableSeconds` and
  seconds-box field, `HeroFaceDelegate.onPowerBudgetExceeded`, `SETTING_SLOTS`, `SETTING_SECONDS`, `SETTING_WEATHER` constants.
- **No settings file in shared `resources/`**: `resources-pro/settings/` has all seven properties and settings, `resources-free/settings/` has Mode and Accent. No generator
  (two short lists), so both edited by hand; `tools/check_free_package.sh` fails if compiled Free lists differ from Pro's.
- **`Application.Properties.getValue` of key missing from properties file** throws `Properties.InvalidKeyException` (SDK 9.2.0 reference, `Toybox/Application/Properties.html`:
  "Thrown if key does not exist in Application Settings"). Free never calls it for Pro key, so nothing relies on it, `HeroFaceSettings.read` catches it for Pro path.
  `freeMissingPropertyKeyThrows` records simulator behaviour, passed on Free jungle (2026-10-01): throws `InvalidKeyException` for missing key.
- Strict compile (`-w --typecheck 3`) needed four type-only fixes in code predating split (cast in `HeroFaceLink.open`, `read` return type in `HeroFaceSettings`, cast and local variables in `HeroFaceStreak`),
  plus casts in three test files; project only built at default level before. No behaviour changed.

## Checking a store package (what the compiler actually produced)

Second `settings.xml` in later resource folder not proven to replace first, so tiers never share one (ADR-001, the Free + Pro ladder). Proof is on **compiled package**:
`.iq` is 7-zip archive (macOS `bsdtar -xf x.iq` opens it; so does `7z x`). Holds, per product part number, compiled `.prg`, `<part>-settings.json` (what phone renders:
every setting key, list options, every string in every language) and `manifest.xml`.

```sh
tools/check_free_package.sh --build     # export both packages (several minutes), then check
tools/check_free_package.sh             # check the existing dist/HeroFaceFree.iq (Free) and dist/HeroFacePro.iq (Pro)
```

Exits non-zero unless: Free settings keys exactly Mode and Accent on every part number, same lists as Pro (Mode 0 to 1, Accent 0 to 2); none of Slot1, Slot2, Slot3, Seconds or Weather appears as
standalone string in any Free `.prg`; word "Pro" appears nowhere in Free package (manifest, settings strings in every language, compiled `.prg`); `AppName` is "HeroFace" in every language of Free and
"HeroFace Pro" in every language of Pro; Pro package carries five keys in settings and compiled code (positive control); app ids expected, different; both manifests ask
for exactly `ComplicationSubscriber`. Display strings of Pro settings (`setting_slot1`, `metric_*`, `setting_seconds`, `setting_weather`) stay in shared strings, ship to both tiers, unused in Free; only word "Pro" and settings keys policed.
Check proves package contents; does not prove behaviour on a watch.

## Device testing

Simulator proves geometry, fonts, logic. Cannot prove always-on
behaviour, battery cost, MIP daylight contrast, or HeroSet link, which
needs two apps on real firmware. Builds and tick list live in
`../../device-test/` (git-ignored, one folder holds both apps).

## Screenshots (Instinct and any layout change)

Unit suite measures numbers; cannot see bezel. For every layout change, photograph what simulator draws (face on device skin, real fonts, real bezel mask): `../docker/shot.sh HeroFace monkey.jungle instinct2 instincte40mm` writes `bin/shot-<device>-face.png` (display, 3x). Instinct's visible area is circle about 98 px radius, which 176 x 176 square test misses: finished-day footer clipped in HeroSet that way (HeroSet ADR-055, amended 2026-10-03). `PREP='sed -i ... resources/properties.xml' ../docker/shot.sh ...` shows particular state without touching repo.