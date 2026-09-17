# Development

App: Watch App · Target: `fr965` · Min API: 4.2.0 · Monkey C.

## Setup

Install Connect IQ SDK + FR965 support + Java 11+. The command-line tools
(`monkeyc`, `monkeydo`, `era`) are in the SDK's `bin/` folder (on macOS under
`~/Library/Application Support/Garmin/ConnectIQ/Sdks/<sdk>/bin`); add it to
`PATH` or call them by full path. VS Code with the Monkey C
extension runs SDK commands. In VS Code: `Monkey C: Verify Installation`, then
`Monkey C: Generate a Developer Key` if needed. Open a `.mc` file under
`source/` and `Run > Run Without Debugging` with the FR965 simulator.

## Command-line build

```bash
mkdir -p bin
monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y /path/to/developer_key
monkeydo bin/HeroSet.prg fr965        # with simulator running
```

Release-menu build (no calibration entry, `resources-store` overlay):

```bash
monkeyc -d fr965 -f store.jungle -o bin/HeroSet-store.prg -y /path/to/developer_key
```

## Unit tests (74 tests)

```bash
monkeyc -t -d fr965 -f monkey.jungle -o bin/HeroSet-tests.prg -y /path/to/developer_key
monkeydo bin/HeroSet-tests.prg fr965 -t
```

Inspect the printed summary for PASSED/failed counts — the current SDK may
return non-zero shell status even on a passing test run.

If a test run hangs, quit and restart the simulator and run again. Tests that
draw to off-screen bitmaps should reuse a single
`Graphics.createBufferedBitmap`; creating one per case exhausted the
simulator's graphics memory and hung it.

## Physical-device crash logs

The simulator does not catch everything (ADR-022, ADR-023) — some `Storage`/
sensor-callback-dispatch quirks are only enforced/reproducible on real
firmware. After an "IQ(!)" crash on a watch, connect it via USB Mass Storage
and read `GARMIN/APPS/LOGS/CIQ_LOG.YAML` (`CIQ_LOG.TXT` on older devices) —
written automatically, no logging code needed. On this FR965 (firmware 29.05 /
ConnectIQ 6.0.2) the `Stack:` field has come back empty every time so far —
don't assume a trace will be there; it gives only the error type + a
one-line "Details" context (e.g. "Error in sensor data callback"). Or run
`era -a 372a11c8-fca3-4dd7-b35b-c83ed18d1b19` (the SDK's `bin/` folder) for
the same report as JSON.

**On-device live debug**: the Monkey C VS Code extension's `F5`/"Run App"
launch never offered the physical FR965 as a debug target here (no device
picker, silently falls back to the simulator) — seems unsupported for this
device via this extension, not a config issue. If the crash log's minimal
detail isn't enough, fall back to a persisted breadcrumb instead of
`System.println` (invisible standalone anyway, no cable): write checkpoint
strings through `HeroSetStore` at each step of the suspect path, display the
last one on the next dashboard load, sideload, reproduce, reopen the app,
read the screen. See ADR-023 for a worked example.

## Physical accuracy validation log

Dev build only, hidden from `store.jungle` (ADR-026): main menu → **Validation
Log** pages through recent workout sets' detected-vs-saved rep counts,
newest-first. Populates itself automatically on every real set — no separate
test mode. See `docs/validation-log.md` for the transcription template and
`docs/go-to-market.md` Phase 2 step 1 for the accuracy bar it's feeding.

The same log carries Connect Sync lines (ADR-030), stamped with the time of day
(`HH:MM SYNC ...`). Use them to check whether the day's recording survives
closing HeroSet:

1. Main menu → Connect Sync **On**.
2. Start a push-up set, count a few reps, START → save.
3. Start a second set without leaving HeroSet, then save it. The log must now
   show `SYNC NEW` then `SYNC KEPT m:ss`. If the second line is `SYNC LOST`,
   the timer reading doesn't work on this firmware, so stop: the next step
   can't be trusted.
4. Leave HeroSet (Back from the dashboard), reopen it, and do a third set.
5. Read the newest line: `SYNC KEPT m:ss` means the recording survived closing
   (one activity per day works). `SYNC LOST` means it didn't.
6. Optional: turn Connect Sync **Off**. `SYNC SAVED m:ss` should appear, and
   one HeroSet strength activity should reach Garmin Connect after the next
   phone sync.

## Signing key

Key signs the app and is required for future Store updates: keep it private,
backed up, never committed (repo ignores `developer_key`, `.der`, `.pem`). For
shared/public checkouts store it outside the repo (e.g.
`~/.garmin-connectiq/keys/developer_key.der`). Losing it prevents updates.