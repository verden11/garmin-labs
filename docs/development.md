# Development

App: Watch App · Products: 67, listed in `compatibility.md` · Min API: 3.4.0 · Monkey C.

## Setup

Install Connect IQ SDK + device support for supported products (at least FR965) + Java 11+. CLI tools (`monkeyc`, `monkeydo`, `era`) in SDK `bin/` folder (macOS: `~/Library/Application Support/Garmin/ConnectIQ/Sdks/<sdk>/bin`); add to `PATH` or call by full path. VS Code + Monkey C extension run SDK commands. In VS Code: `Monkey C: Verify Installation`, then `Monkey C: Generate a Developer Key` if needed. Open `.mc` file under `source/`, `Run > Run Without Debugging` with FR965 simulator.

## Command-line build

```bash
mkdir -p bin
monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y /path/to/developer_key
monkeydo bin/HeroSet.prg fr965        # with simulator running
```

Store build (ADR-033): `manifest-store.xml` (Sensor permission only), sync code excluded via `(:sync)`/`(:nosync)` annotations, `resources-store` menu (no Connect Sync or Validation Log):

```bash
monkeyc -d fr965 -f store.jungle -o bin/HeroSet-store.prg -y /path/to/developer_key
```

Store package for upload (`-e` packages every product in manifest, `-r` strips debug info):

```bash
monkeyc -e -r -f store.jungle -o bin/HeroSet-store.iq -y /path/to/developer_key
```

`manifest.xml` and `manifest-store.xml` must keep same app id and products; differ only in `Fit` permission. Check store menu: compile tests with `-f store.jungle` too — `mainMenuPrepareHandlesEitherBuildsMenu` then runs against store menu, which has no sync toggle (ADR-033).

### Localization

Launch language list identical in both manifests: `eng`, `deu`, `fre`, `spa`, `ita`, `por`, `dut`, `pol`, `swe`, `dan`, `nob`, `fin`, `tur`, `lit`, `ukr`. English in `resources/` is fallback; translations in language-qualified folders like `resources-deu/strings/strings.xml`. Russian intentionally unsupported.

After string change: compare every qualified file's IDs and placeholders with `resources/strings/strings.xml`, then run screen-fit suite with each language selected in Connect IQ simulator. Simulator evidence no replace real-device font and layout checks.

## Unit tests (79 tests)

```bash
monkeyc -t -d fr965 -f monkey.jungle -o bin/HeroSet-tests.prg -y /path/to/developer_key
monkeydo bin/HeroSet-tests.prg fr965 -t
```

Inspect printed summary for PASSED/failed counts — current SDK may return non-zero shell status even on passing run.

Test run hangs → quit, restart simulator, run again. Tests drawing to off-screen bitmaps must reuse single `Graphics.createBufferedBitmap`; one per case exhausted simulator graphics memory and hung it.

### Checking another product

Suite runs in whichever device simulator you name, with that device's screen size and fonts. `everyScreenFitsThisDisplay` renders every screen, fails on text outside display, overlapping text, or screen drawing fewer rows than it should (ADR-034/035). Run for every product after UI or string change:

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

Simulator no catch everything (ADR-022, ADR-023) — some `Storage`/sensor-callback-dispatch quirks only enforced/reproducible on real firmware. After "IQ(!)" crash on watch, connect via USB Mass Storage, read `GARMIN/APPS/LOGS/CIQ_LOG.YAML` (`CIQ_LOG.TXT` on older devices) — written automatically, no logging code needed. On this FR965 (firmware 29.05 / ConnectIQ 6.0.2) `Stack:` field come back empty every time so far — no assume trace there; gives only error type + one-line "Details" context (e.g. "Error in sensor data callback"). Or run `era -a 568d5c9b-eb10-4678-bf28-0080c3efbbc1` (SDK `bin/` folder) for same report as JSON.

**On-device live debug**: Monkey C VS Code extension `F5`/"Run App" launch never offered physical FR965 as debug target here (no device picker, silently falls back to simulator) — seems unsupported for this device via this extension, not config issue. Crash log detail not enough → fall back to persisted breadcrumb instead of `System.println` (invisible standalone anyway, no cable): write checkpoint strings through `HeroSetStore` at each step of suspect path, display last one on next dashboard load, sideload, reproduce, reopen app, read screen. See ADR-023 for worked example.

## Physical accuracy validation log

Dev build only, hidden from `store.jungle` (ADR-026): main menu → **Validation Log** pages through recent workout sets' detected-vs-saved rep counts, newest-first. Populates itself automatically on every real set — no separate test mode. See `docs/validation-log.md` for transcription template and `docs/go-to-market.md` Phase 2 step 1 for accuracy bar it feeds.

Dev build log also carries Connect Sync lines (ADR-030; sync dev-only, ADR-033), stamped with time of day (`HH:MM SYNC ...`). Use to check whether day's recording survives closing HeroSet:

1. Main menu → Connect Sync **On**.
2. Start push-up set, count few reps, START → save.
3. Start second set without leaving HeroSet, then save it. Log must now show `SYNC NEW` then `SYNC KEPT m:ss`. If second line is `SYNC LOST`, timer reading doesn't work on this firmware — stop: next step can't be trusted.
4. Leave HeroSet (Back from dashboard), reopen it, do third set.
5. Read newest line: `SYNC KEPT m:ss` means recording survived closing (one activity per day works). `SYNC LOST` means it didn't.
6. Optional: turn Connect Sync **Off**. `SYNC SAVED m:ss` should appear, and one HeroSet strength activity should reach Garmin Connect after next phone sync.

## Signing key

Key signs app, required for future Store updates: keep private, backed up, never committed (repo ignores `developer_key`, `.der`, `.pem`). For shared/public checkouts store outside repo (e.g. `~/.garmin-connectiq/keys/developer_key.der`). Losing it prevents updates.