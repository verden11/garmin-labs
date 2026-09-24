# HeroSet — CLAUDE.md

Garmin watch app (Forerunner 965 first, 80 round AMOLED + MIP watches supported, 13 of them touch-first, `docs/compatibility.md`) (Connect IQ, Monkey C): daily 100 push-ups, sit-ups, squats, auto rep counting (beta), manual correction, persistent XP/rank/streak. No GPS/distance. Goal: paid Connect IQ Store launch.

**`docs/` = source of truth; this file only orientation + house rules.** Resume order:

1. `docs/go-to-market.md`: status, open + blocked items.
2. `docs/architecture.md`: structure, layers, navigation, known debt.
3. `docs/decisions.md`: ADRs (why). Read five flagged at top.
4. As needed: `docs/input-and-ux.md` (screens/buttons), `docs/development.md` (commands, device debugging), `docs/testing-plan.md`, `docs/release-contract.md` (check before any user-facing claim).

## Fast facts

- Products: 80 in both manifests, round AMOLED + MIP: 67 five-button (ADR-034/035/037/038) + 13 touch-first Venu/vívoactive/Approach/D2 Air (ADR-048); only `fr965` tested on real watch · min API 3.4.0 (no 4.x-only calls outside `has` checks; `monkeyc` won't catch them) · one class per file, `HeroSet` prefix.
- Builds: `monkey.jungle` = dev (Connect Sync + validation log); `store.jungle` = release: `manifest-store.xml` (no `Fit`/`FitContributor`), `(:sync)` code excluded, `resources-store/` menu (ADR-033). Both manifests keep same app id.
- CLI tools in SDK `bin/` folder, may not be on `PATH` (`~/Library/Application Support/Garmin/ConnectIQ/Sdks/<sdk>/bin/`). Signing key = `~/.garmin-connectiq/keys/developer_key` (outside repo; never commit it).
- Build: `monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y ~/.garmin-connectiq/keys/developer_key`
- Tests (99; 88 in store build): `monkeyc -t -d fr965 -f monkey.jungle -o bin/HeroSet-tests.prg -y ~/.garmin-connectiq/keys/developer_key`, then `monkeydo bin/HeroSet-tests.prg fr965 -t`. Trust printed `PASSED (…)` line, not exit code. Hung run → restart simulator. Swap `fr965` for other product id to check its screens (`everyScreenFitsThisDisplay`).
- Layers point down only: Presentation (`app/`, `ui/`, `layout/`) → Sensor / Data → Domain. Only `data/` touches Storage.
- XP only for net stored progress (ADR-002). Rank derived, never stored (ADR-031). Persisted key spellings never change (ADR-003).
- Navigation: Workout/Picker always depth 1 on dashboard; fixed pop counts depend on it, over-popping exits app (ADR-024).
- Device-only failure modes exist (ADR-022/023). Passing simulator not proof; say so when reporting.
- Sibling watch face `../HeroFace` (HeroFace) reads today's progress through one private complication this app publishes (ADR-044, `HeroSetComplicationPublisher`): CIQ 4.2+ products only, resource in `resources-complications/` added per product in both jungles. Its value is a fixed field order; changing it breaks that app.
- Public site (landing, support, privacy) lives in sibling directory `../verden-site` (studio "Verden", shared with future apps; its `CLAUDE.md` explains hosting + linking). HeroSet pages: `src/apps/heroset/` there, live at `/heroset/`, `/heroset/support/`, `/heroset/privacy/` on https://verden.watch (Netlify, auto-deploys on push). Store listing uses those URLs. User-facing claim or data-handling change here → update those pages same session.

## House rules

- Every function: typed params + `as` return type. No `as Any`. Cast only after `instanceof`/null guard.
- No magic numbers: tunables in `HeroSetConfig`, geometry in `HeroSetLayout`, colors in `HeroSetPalette`, text in `strings.xml`.
- Text fit measured, never guessed (ADR-018). Draw text via `HeroSetDraw.text`, never `dc.drawText` (ADR-034). `HeroSetDraw.fits`/`firstFitting`/`largestFont` take the radius + margin to measure against (ADR-036).
- Render only in `onUpdate`; logic in delegates/stores/domain.
- Functions ≲30 lines, files ≲250 lines (current exceptions: architecture §8).
- Catch only what can throw; degrade + flag, never swallow silently.
- Comments explain *why*, never *what*.
- No long-press gestures; hints name bezel buttons (`START`, `UP/DOWN`) (ADR-029), `SWIPE` on touch-first products via `HeroSetInput`. Commits (Finish, Save) act on the START key in `onKey`, never `onSelect`: a tap is also select (ADR-048).
- Git index often mixed staged/unstaged: don't stage, commit, stash or reset unless asked.

## Keeping docs in sync

- Behavior change → update doc describing it, same session.
- Durable decision → new ADR at end of `docs/decisions.md` (mark older ones Superseded/Amended; don't delete).
- Open items + blockers live only in `go-to-market.md`. History lives in git + ADRs, not status sections.
- Status-dated docs (`go-to-market.md`, `release-contract.md`, `compatibility.md`, `battery.md`, `connect-sync-plan.md`): bump date when editing.
- Test count appears in this file, `README.md`, `docs/development.md`, `docs/release-contract.md`; update all four.
- Prefer editing existing docs; genuinely new doc gets linked from `docs/README.md`.