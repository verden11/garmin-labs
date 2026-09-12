# Development

App: Watch App · Target: `fr965` · Min API: 4.2.0 · Monkey C.

## Setup

Install Connect IQ SDK + FR965 support + Java 11+. VS Code with the Monkey C
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

## Unit tests (60 tests)

```bash
monkeyc -t -d fr965 -f monkey.jungle -o bin/HeroSet-tests.prg -y /path/to/developer_key
monkeydo bin/HeroSet-tests.prg fr965 -t
```

Inspect the printed summary for PASSED/failed counts — the current SDK may
return non-zero shell status even on a passing test run.

## Signing key

Key signs the app and is required for future Store updates: keep it private,
backed up, never committed (repo ignores `developer_key`, `.der`, `.pem`). For
shared/public checkouts store it outside the repo (e.g.
`~/.garmin-connectiq/keys/developer_key.der`). Losing it prevents updates.