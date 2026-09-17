# HeroSet — CLAUDE.md

Garmin Forerunner 965 watch app (Connect IQ, Monkey C): daily 100 push-ups,
sit-ups, squats with automatic rep counting (beta), manual correction, and
persistent XP/rank/streak. No GPS/distance tracking. Goal: paid Connect IQ Store
launch.

**`docs/` is the source of truth; this file is only orientation + house
rules.** When resuming, read in this order:

1. `docs/go-to-market.md` → **Status checkpoint**: what's open and blocked,
   including questions to ask the user before touching Connect Sync.
2. `docs/architecture.md`: structure, layers, navigation, known debt.
3. `docs/decisions.md`: ADRs (why). Read the five flagged at the top.
4. As needed: `docs/input-and-ux.md` (screens/buttons), `docs/development.md`
   (commands, device debugging), `docs/testing-plan.md`,
   `docs/release-contract.md` (check before any user-facing claim).

## Fast facts

- Target `fr965` only · min API 4.2.0 · one class per file, `HeroSet` prefix.
- Builds: `monkey.jungle` = dev (calibration + validation log visible);
  `store.jungle` = release (`resources-store/` overlay hides both, ADR-008).
- CLI tools live in the SDK `bin/` folder and may not be on `PATH`
  (`~/Library/Application Support/Garmin/ConnectIQ/Sdks/<sdk>/bin/`). The
  signing key is `developer_key` in the repo root: gitignored, never commit it.
- Build: `monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y developer_key`
- Tests (74): `monkeyc -t -d fr965 -f monkey.jungle -o bin/HeroSet-tests.prg -y developer_key`,
  then `monkeydo bin/HeroSet-tests.prg fr965 -t`. Trust the printed
  `PASSED (…)` line, not the exit code. A hung run means restart the simulator.
- Layers point down only: Presentation (`app/`, `ui/`, `layout/`) → Sensor /
  Data → Domain. Only `data/` touches Storage.
- XP only for net stored progress (ADR-002). Rank is derived, never stored
  (ADR-031). Persisted key spellings never change (ADR-003).
- Navigation: Workout/Picker always sit at depth 1 on the dashboard; fixed pop
  counts depend on it, and over-popping exits the app (ADR-024).
- Device-only failure modes exist (ADR-022/023). A passing simulator is not
  proof; say so when reporting.

## House rules

- Every function: typed params + `as` return type. No `as Any`. Cast only after
  `instanceof`/null guard.
- No magic numbers: tunables in `HeroSetConfig`, geometry in `HeroSetLayout`,
  colors in `HeroSetPalette`, text in `strings.xml`.
- Text fit is measured, never guessed (ADR-018).
- Render only in `onUpdate`; logic in delegates/stores/domain.
- Functions ≲30 lines, files ≲250 lines (current exceptions: architecture §9).
- Catch only what can throw; degrade + flag, never swallow silently.
- Comments explain *why*, never *what*.
- No long-press gestures; hints name bezel buttons (`START`, `UP/DOWN`) (ADR-029).
- The git index is often mixed staged/unstaged: don't stage, commit, stash or
  reset unless asked.

## Keeping docs in sync

- Behavior change → update the doc that describes it, in the same session.
- Durable decision → new ADR at the end of `docs/decisions.md` (mark older ones
  Superseded/Amended; don't delete).
- Open items and blockers live only in the go-to-market status checkpoint.
  History lives in git and ADRs, not in status sections.
- Status-dated docs (`go-to-market.md`, `release-contract.md`,
  `calories-connect.md`): bump the date when editing.
- The test count appears in this file, `README.md`, `docs/development.md` and
  `docs/release-contract.md`; update all four.
- Prefer editing existing docs; a genuinely new doc gets linked from
  `docs/README.md`.
