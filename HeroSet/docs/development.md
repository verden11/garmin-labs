# Development

App: Watch App · Products: 80, listed in [`compatibility.md`](compatibility.md) · Min API: 3.4.0 · Monkey C.

## Setup

Install Connect IQ SDK + device support for supported products (at least FR965) + Java 11+. CLI tools (`monkeyc`, `monkeydo`, `era`) in SDK `bin/` folder (macOS: `~/Library/Application Support/Garmin/ConnectIQ/Sdks/<sdk>/bin`); add to `PATH` or call by full path. VS Code + Monkey C extension run SDK commands. In VS Code: `Monkey C: Verify Installation`, then `Monkey C: Generate a Developer Key` if needed. Open `.mc` file under `source/`, `Run > Run Without Debugging` with FR965 simulator.

## Command-line build

```bash
mkdir -p bin dist
monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y /path/to/developer_key
monkeydo bin/HeroSet.prg fr965        # with simulator running
```

Store build ([ADR-033](decisions.md#adr-033)): `manifest-store.xml` (Sensor permission only), sync code excluded via `(:sync)`/`(:nosync)` annotations, `resources-store` menu (no Connect Sync or Validation Log):

```bash
monkeyc -d fr965 -f store.jungle -o bin/HeroSet-store.prg -y /path/to/developer_key
```

Store package for upload (`-e` packages every product in manifest, `-r` strips debug info):

```bash
monkeyc -e -r -f store.jungle -o dist/HeroSet-store.iq -y /path/to/developer_key
```

`manifest.xml` and `manifest-store.xml` must keep same app id and products; differ only in `Fit` and `FitContributor` permissions (dev build only, [ADR-043](decisions.md#adr-043)). Check store menu: compile tests with `-f store.jungle` too — `mainMenuPrepareHandlesEitherBuildsMenu` then runs against store menu, which has no sync toggle ([ADR-033](decisions.md#adr-033)).

### Localization

Launch language list identical in both manifests: `eng`, `deu`, `fre`, `spa`, `ita`, `por`, `dut`, `pol`, `swe`, `dan`, `nob`, `fin`, `tur`, `lit`, `ukr`. English in `resources/` is fallback; translations in language-qualified folders like `resources-deu/strings/strings.xml`. Russian intentionally unsupported.

After string change: compare every qualified file's IDs and placeholders with `resources/strings/strings.xml`, then run the screen-fit suite in every language on the narrowest screens: `tools/fit-sweep.sh venu2s fr265s` (overlays each language's strings in a throwaway jungle, since the simulator has no CLI language switch; [ADR-049](decisions.md#adr-049)). `tools/fit-sweep.sh -l eng <product>…` checks products in English. `FIT_LINES=40` prints every problem line per run (default 3). Simulator evidence no replace real-device font and layout checks.

## Unit tests (116 tests; 103 in store build)

```bash
monkeyc -t -d fr965 -f monkey.jungle -o bin/HeroSet-tests.prg -y /path/to/developer_key
monkeydo bin/HeroSet-tests.prg fr965 -t
```

Inspect printed summary for PASSED/failed counts — current SDK may return non-zero shell status even on passing run.

Test run hangs → quit, restart simulator, run again. Tests drawing to off-screen bitmaps must reuse single `Graphics.createBufferedBitmap`; one per case exhausted simulator graphics memory and hung it.

### Glance scope check (after any change to `(:glance)` code or `HeroSetApp`)

```bash
tools/glance-scope-check.sh [product...]     # default fr965; prints nothing but "clean" when it passes
```

The glance process ([ADR-051](decisions.md#adr-051)) only has `(:glance)` code, and the default build (and `-l 2`) compiles without a word when glance code calls something that isn't. The script builds both jungles, app and tests, at `-l 3` and greps `not available in all function scopes`; `-l 3` also prints many unrelated type errors that predate the glance, which it ignores. To see the glance closure's size: `monkeyc -d fr965 -f store.jungle … --build-stats 0` (`Glance:` lines, limit 64 KB).

The glance itself has to be looked at in the simulator by hand: Settings → Glance Launch Mode (greyed out unless `getGlanceView` is overridden; a GUI setting with no CLI switch). Unit tests cover its layout at every glance content area of the running screen width, so run the suite on one product per width (`fr255s`, `fenix7s`, `fenix7`, `fenix7x`, `venu2s`, `venu441mm`, `fr265`, `venu3`, `fenix9pro51mm`, plus `fr965`).

The Instinct E 40/45 mm and 3 Solar glance (round window, [ADR-055](decisions.md#adr-055)) can be photographed without the GUI toggle: `../docker/shot.sh HeroSet store.jungle instincte40mm instincte45mm instinct3solar45mm` opens on the glance. To see a state other than the empty day, set `PREP` to a `perl -0pi` that replaces the `HeroSetGlanceReader.read(...)` call in `source/ui/glance/HeroSetGlanceView.mc` with a `new HeroSetDashboardState(...)` in the private copy (the repo is not touched). Simulator only.

### Checking another product

Suite runs in whichever device simulator you name, with that device's screen size and fonts. `everyScreenFitsThisDisplay` renders every screen, fails on text outside display, overlapping text, or screen drawing fewer rows than it should ([ADR-034](decisions.md#adr-034)/[035](decisions.md#adr-035)). Run for every product after UI or string change:

```bash
# product ids come from the manifest, so the list never drifts
for d in $(grep -o 'iq:product id="[^"]*"' manifest.xml | cut -d'"' -f2); do
  monkeyc -t -d $d -f monkey.jungle -o bin/t-$d.prg -y /path/to/developer_key
  monkeydo bin/t-$d.prg $d -t everyScreenFitsThisDisplay
done
```

Full runs on every product slow (~minute each, simulator occasionally wedges — restart, re-run). In practice: screen-fit test on all products, full suite on FR965 plus one product per screen size and screen type.

In zsh, space-separated string in variable no split into words — use array or command substitution as above, never `WAVE="a b c"; ... $WAVE`.

## Physical-device crash logs

Simulator no catch everything ([ADR-022](decisions.md#adr-022), [ADR-023](decisions.md#adr-023)) — some `Storage`/sensor-callback-dispatch quirks only enforced/reproducible on real firmware. After "IQ(!)" crash on watch, connect via USB Mass Storage, read `GARMIN/APPS/LOGS/CIQ_LOG.YAML` (`CIQ_LOG.TXT` on older devices) — written automatically, no logging code needed. On this FR965 (firmware 29.05 / ConnectIQ 6.0.2) `Stack:` field come back empty every time so far — no assume trace there; gives only error type + one-line "Details" context (e.g. "Error in sensor data callback"). Or run `era -a 568d5c9b-eb10-4678-bf28-0080c3efbbc1` (SDK `bin/` folder) for same report as JSON.

**On-device live debug**: Monkey C VS Code extension `F5`/"Run App" launch never offered physical FR965 as debug target here (no device picker, silently falls back to simulator) — seems unsupported for this device via this extension, not config issue. Crash log detail not enough → fall back to persisted breadcrumb instead of `System.println` (invisible standalone anyway, no cable): write checkpoint strings through `HeroSetStore` at each step of suspect path, display last one on next dashboard load, sideload, reproduce, reopen app, read screen. See [ADR-023](decisions.md#adr-023) for worked example.

## Validation Log (dev build)

Main menu → **Validation Log** ([ADR-026](decisions.md#adr-026)): newest-first `detected -> saved` per workout set, plus Connect Sync lines `HH:MM SYNC NEW/SAVED m:ss/EMPTY/OFF/FAIL` ([ADR-043](decisions.md#adr-043)). One 30-line ring buffer for both: copy trials off ([`validation-log.md`](validation-log.md)) before long sync testing.

Sync quick check: Connect Sync **On** → save a push-up set and a sit-up set → Back out of HeroSet → log shows `SYNC NEW`, `SYNC SAVED m:ss` → after phone sync, Connect has **one** HeroSet activity with 2 laps and totals. Full list: [`connect-sync-plan.md`](archive/connect-sync-plan.md) device acceptance.

## Signing key

Key signs app, required for future Store updates: keep private, backed up, never committed (repo ignores `developer_key`, `.der`, `.pem`). Store it outside repo (maintainer copy: `~/.garmin-connectiq/keys/developer_key`). Losing it prevents updates.
**Driving the simulator by hand-equivalent (2026-10-04).** `tools/drive_screens.sh` (run through `../docker/capture.sh HeroSet tools/drive_screens.sh <device> <btn|touch> ...`, header lists the arguments) walks glance, dashboard, menu, set, end-set menu, picker and save with xdotool and photographs each step on the device skin: bezel buttons are clicked on the skin, touch is a click or a quick drag. It is how ROADMAP 7.11 (B2, B3, E4) was checked. Simulator only, not a wrist.

**Seeding reps for screenshots, and the "crash from the glance" (ROADMAP 10.11, 2026-10-04): the test harness, not the app.** A `store.add(...)` patched into a private copy of `HeroSetApp` made the app crash when it was launched from the glance. Reproduced in the container simulator (`instincte40mm`, store jungle, `-r`): the crash is `Illegal Access (Out of Bounds) / Class not available to 'Glance'` and happens only when the seed sits in `initialize` or `onStart`, which the glance process also runs; `HeroSetStore` is not `(:glance)`, so it is a scope violation of the kind `tools/glance-scope-check.sh` exists to catch (checked: it fails on that patch with `Value 'add' not available in all function scopes`), not a glance bug. The seed `drive_screens.sh` applies, after `ensureCurrentDay()` in `getInitialView` (foreground only), does not crash: 40/20/10 on `instincte40mm`, `fr965` and (dev jungle) `instincte45mm`, and 100/100/100 on `instincte40mm` and `instincte45mm` (dashboard shows the seeded counts, streak 1 at 100/100/100). The real glance path, `HeroSetGlanceView.onUpdate` to `HeroSetGlanceReader.read`, only reads Storage and constructs no `HeroSetStore`; `getStore()` is reached only from `getInitialView`. Rule for any scenario script: patch seeds into `getInitialView`, never `initialize`/`onStart`. Simulator only; the glance process on a watch has not been observed beyond what the FR965 showed for 1.2.0.
