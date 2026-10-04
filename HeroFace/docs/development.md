# Development

Connect IQ SDK 9.2.0, Monkey C. `monkeyc`/`monkeydo` live in the SDK's `bin/`
folder if they aren't on `PATH`
(`~/Library/Application Support/Garmin/ConnectIQ/Sdks/<sdk>/bin/`). The signing
key is at `~/.garmin-connectiq/keys/developer_key`, outside every repo, shared
with HeroSet; losing it prevents store updates.

Two builds come from one source (ADR-001, the Free + Pro ladder): **Pro** is `monkey.jungle` (the live app id, `manifest.xml`) and **Free** is
`monkey.free.jungle` (`manifest.free.xml`, its own app id). Every command below takes either jungle.

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

`dist/old/` holds the earlier packages (`HeroFace.iq`, `HeroFace-next.iq`); nothing was at `dist/HeroFace.iq` when the ladder work started, and the new names
are `dist/HeroFaceFree.iq` and `dist/HeroFacePro.iq`, so neither collides with the `../dist/HeroFace.iq` that `listing/paste.md` still names for 1.0.1.
Both jungles set `base.sourcePath = source` on purpose: without it the build also compiles anything under `docs/`.

Trust the printed `PASSED (…)` line, not the exit code. A run that hangs means
the simulator wedged: quit it, restart, run again. It does this every few runs.

## The test kinds

Pro runs 24 tests and Free 24 (**PASSED in the simulator on both jungles on fr965, fenix5s and fr55, 2026-10-01**; the ten-size fit loop (Free, 2026-10-04: 25/25 on all ten sizes plus `vivoactive3`) and the memory view (2026-10-04, `compatibility.md` "Measured 2026-10-04") were run later, the Pro ten-size loop is not yet run; use `EXPECT=24` or a 4th argument of `tools/run_tests.sh` to fail a full run on a count mismatch): 22 are shared, `disabledSecondsDrawNoSecondsBox`
and `proSettingsReadTheirDefaults` are Pro-only (`(:test, :pro)`), `freeReturnsDefaultsForProKeys` and `freeMissingPropertyKeyThrows` are Free-only.

- **Logic** (`HeroFaceLogicTest`): streak arithmetic, HeroSet's contract, the
  ring average, time wording. No device needed.
- **Accent table** (`HeroFaceAccentTest`): every channel in {00, 55, AA, FF}, at least 3:1 on black, Blue and Cyan keep their colours and Magenta is the owner's 2026-10-04 recolour (ADR-003),
  out-of-range falls back to the default, no accent is a reserved role colour, and the face's own rule (3:1 against TRACK):
  all three pass (`everyAccentClearsTheTrackRule`), and Magenta's 4.42:1 is pinned by `magentaWasRecolouredToClearTheTrackRule`.
- **Settings** (`HeroFaceSettingsTest`): Pro reads the shipped defaults; Free reads none of the five Pro keys (Auto slots, no seconds, no temperature) and a missing key throws `InvalidKeyException`.
- **Screen fit** (`everyStateFitsThisDisplay`): renders the face's widest
  states with the device's real fonts and fails on text leaving the round
  display or overlapping another row. Run it per screen size after any layout
  or string change:
  ```sh
  for d in fr55 fenix5s fenix5 vivoactive4 fenix7x fr265s fr165 epix2 fr965 fenix9pro51mm; do
    tools/run_tests.sh $d monkey.jungle everyStateFitsThisDisplay      # and monkey.free.jungle
  done
  ```
  Those ten cover every screen size from 208 to 466 px.
  The fit states always carry seconds (`"59"`) and a temperature (`"-20°"`), so on the Free jungle they still draw Pro-shaped frames: a passing Free fit run does not verify Free's own row under the time (the streak alone, centred).
- **Live language** (`everyLabelFitsThisLanguage`): renders the labels of
  whichever language the simulator is set to. Set the language in the
  simulator (Settings → System → Language), then run it. Do this for the long
  ones after any label change: German, Dutch, Finnish, Lithuanian, Ukrainian.

`heroFaceLayoutReport` prints every row's box, the resolved slot metrics and
the device's capability flags. It is how layout is checked here, because this
environment cannot capture the simulator.

## Translations

English lives in `resources/strings/strings.xml`; each other language is a
`resources-<lang>/strings/strings.xml` with the same ids. Every id and
placeholder must match English exactly — check with `python3 tools/check_strings.py`
(it also enforces the AppName rules below, and that no shared string says "Pro").

**AppName** is defined only in `resources-pro/strings` ("HeroFace Pro") and `resources-free/strings` ("HeroFace"), never in `resources/` or a `resources-<lang>/`: a language
folder that defined it would override the tier name on a non-English watch. A language does **not** inherit the default's strings (the compiler warns "String id 'AppName'
undefined for language ..."), so each jungle appends its tier folder to every `base.lang.<l>` path.

A new language also needs its `<iq:language>` line in **both** `manifest.xml` and `manifest.free.xml`, its `base.lang.<l>` line in **both** jungles, and no AppName in its strings.

Watch labels are uppercase and have a short form for narrow columns; the face
measures and picks the longest wording that fits, so a long translation
degrades instead of clipping. Weekday and month names come from the system, so
they are already translated.

## Tier-only code and resources

- `(:pro)` / `(:free)` on a function, field or constant compiles it into only that tier; a `(:free)` twin returns the default. `(:test, :pro)` and `(:test, :free)` do the same for tests.
  Pro-only: the Slot1-3, Seconds and Weather reads in `HeroFaceSettings`, `HeroFaceReadings.temperature` (the `Toybox.Weather` reads), `HeroFaceView.onPartialUpdate`, `disableSeconds` and the
  seconds-box field, `HeroFaceDelegate.onPowerBudgetExceeded`, and the `SETTING_SLOTS`, `SETTING_SECONDS`, `SETTING_WEATHER` constants.
- There is **no settings file in the shared `resources/`**: `resources-pro/settings/` has all seven properties and settings, `resources-free/settings/` has Mode and Accent. There is no generator
  (two short lists), so both are edited by hand; `tools/check_free_package.sh` fails if the compiled Free lists differ from Pro's.
- **`Application.Properties.getValue` of a key missing from the properties file** throws `Properties.InvalidKeyException` (SDK 9.2.0 reference, `Toybox/Application/Properties.html`:
  "Thrown if key does not exist in Application Settings"). Free never calls it for a Pro key, so nothing relies on it, and `HeroFaceSettings.read` catches it for the Pro path.
  `freeMissingPropertyKeyThrows` records what the simulator does and passed on the Free jungle (2026-10-01): it throws `InvalidKeyException` for a missing key.
- The strict compile (`-w --typecheck 3`) needed four type-only fixes in code that predates the split (a cast in `HeroFaceLink.open`, the `read` return type in `HeroFaceSettings`, a cast and local variables in `HeroFaceStreak`),
  plus casts in three test files; the project had only been built at the default level. No behaviour changed.

## Checking a store package (what the compiler actually produced)

A second `settings.xml` in a later resource folder is not proven to replace the first, so the tiers never share one (ADR-001, the Free + Pro ladder). The proof is on the **compiled package**:
a `.iq` is a 7-zip archive (macOS `bsdtar -xf x.iq` opens it; so does `7z x`). It holds, per product part number, the compiled `.prg`, a `<part>-settings.json` (what the phone renders:
every setting key, its list options, and every string in every language) and a `manifest.xml`.

```sh
tools/check_free_package.sh --build     # export both packages (several minutes), then check
tools/check_free_package.sh             # check the existing dist/HeroFaceFree.iq (Free) and dist/HeroFacePro.iq (Pro)
```

It exits non-zero unless: the Free settings keys are exactly Mode and Accent on every part number, with the same lists as Pro (Mode 0 to 1, Accent 0 to 2); none of Slot1, Slot2, Slot3, Seconds or Weather appears as a
standalone string in any Free `.prg`; the word "Pro" appears nowhere in the Free package (manifest, settings strings in every language, compiled `.prg`); `AppName` is "HeroFace" in every language of Free and
"HeroFace Pro" in every language of Pro; the Pro package carries the five keys in its settings and its compiled code (the positive control); the app ids are the expected, different ones; and both manifests ask
for exactly `ComplicationSubscriber`. The display strings of the Pro settings (`setting_slot1`, `metric_*`, `setting_seconds`, `setting_weather`) stay in the shared strings and ship to both tiers, unused in Free; only the word "Pro" and the settings keys are policed.
The check proves package contents; it does not prove behaviour on a watch.

## Device testing

The simulator proves geometry, fonts and logic. It cannot prove always-on
behaviour, battery cost, MIP daylight contrast, or the HeroSet link, which
needs two apps on real firmware. Builds and a tick list for that live in
`../../device-test/` (git-ignored, so one folder holds both apps).

## Screenshots (Instinct and any layout change)

The unit suite measures numbers; it cannot see the bezel. For every layout change, photograph what the simulator draws (the face on its device skin, with the real fonts and the real bezel mask): `../docker/shot.sh HeroFace monkey.jungle instinct2 instincte40mm` writes `bin/shot-<device>-face.png` (the display, 3x). The Instinct's visible area is a circle about 98 px in radius, which a 176 x 176 square test misses: a finished-day footer was clipped in HeroSet that way (HeroSet ADR-055, amended 2026-10-03). `PREP='sed -i ... resources/properties.xml' ../docker/shot.sh ...` shows a particular state without touching the repo.
