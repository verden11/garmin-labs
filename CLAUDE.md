# HeroSet — CLAUDE.md

Gamified bodyweight workout app for Garmin Forerunner 965 (Connect IQ, Monkey C).
Daily mission: 100 push-ups/sit-ups/squats. Auto rep counting via accelerometer
+ per-exercise calibration; XP/rank/streak persist, daily counts reset on local
calendar day. No GPS/distance tracking (removed permanently).

**Read `docs/` before working — it is the source of truth, not this file.**
This file is only a fast-orientation index + house rules. Full detail:

- [`docs/architecture.md`](docs/architecture.md) — file structure, layering,
  module responsibilities, data flow, code style, ADRs
- [`docs/development.md`](docs/development.md) — build/test commands, signing key
- [`docs/input-and-ux.md`](docs/input-and-ux.md) — button-first nav contract
- [`docs/testing-plan.md`](docs/testing-plan.md) — test pyramid
- [`docs/release-contract.md`](docs/release-contract.md) — what current build
  can honestly claim (check before any marketing/UI copy)
- [`docs/compatibility.md`](docs/compatibility.md) — device support policy
- [`docs/store-release.md`](docs/store-release.md) · [`docs/go-to-market.md`](docs/go-to-market.md) — monetization/launch
- [`docs/calories-connect.md`](docs/calories-connect.md) — calorie/FIT plan (partially implemented)

## Fast facts

- Target: `fr965` only · Min API 4.2.0 · Language: Monkey C · one class per file.
- Builds: `monkey.jungle` (dev, calibration menu visible) vs `store.jungle`
  (release, `resources-store/` overlay, calibration hidden — ADR-008).
- Build: `monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y <developer_key>`
- Tests (60): `monkeyc -t -d fr965 -f monkey.jungle -o bin/HeroSet-tests.prg -y <developer_key>`
  then `monkeydo bin/HeroSet-tests.prg fr965 -t` — read the printed summary,
  shell exit code can be nonzero even on all-pass.
- Layers (strict import direction): Domain (`Lang` only, Calendar may use
  `Time.Gregorian`) → Data (+ Storage) / Sensor (+ `Toybox.Sensor`) →
  Presentation (anything, but never raw `Storage.*`).
- `HeroSetStore` is the *only* persistence caller. Schema-versioned (`SCHEMA_VERSION`,
  currently v3); XP awarded only on net positive stored delta (no farming — ADR-002).
- `developer_key` / `*.der` / `*.pem` are gitignored — never commit signing keys.
- `bin/`, `gen/`, `*.prg`, `*.mir`, `*.debug.xml` are build output, gitignored.

## House rules (from architecture.md §6, don't re-derive — just follow)

- Every function: typed params + `as` return type. No `as Any`. Cast only after
  `instanceof`/null guard.
- No magic numbers — tunables go in `HeroSetConfig`.
- Render only in `onUpdate`; logic in delegates/stores/domain.
- Functions ≲30 lines, files ≲250 lines (split by responsibility if exceeded).
- Catch only what can throw (e.g. `StorageFullException`); degrade + flag, never
  swallow silently.
- Comments explain *why*, never *what*.

## Maintaining this file

This file (and `docs/`) is living context, not a one-time snapshot — keep it in
sync as the project moves, so future sessions never have to re-explore from
scratch:

- When you land a change that shifts architecture, adds/removes a module,
  changes a build/test command, or resolves a doc's open question — update the
  relevant `docs/*.md` (and this file, if it's a "fast fact") in the same
  session, not later.
- New durable decisions get an ADR row in `architecture.md` §7, not a comment
  buried in code.
- Status-dated docs (`release-contract.md`, `go-to-market.md`,
  `calories-connect.md`) carry a `Status date:` line — bump it when you touch
  their content.
- Periodically re-read this file and `docs/` for drift (stale file sizes,
  renamed classes, finished TODOs) and recompress: cut anything now obvious
  from the code itself, keep only what saves a future session real exploration
  time.
- Prefer editing existing docs over adding new ones; if a new doc is genuinely
  needed, link it from both `README.md` and `docs/README.md`.
