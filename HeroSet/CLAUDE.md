# HeroSet — CLAUDE.md

Garmin watch app (Forerunner 965 first, 82 round AMOLED + MIP watches supported, 13 of them touch-first, plus 3 touch-first rectangles and 7 Instinct, [`docs/compatibility.md`](docs/compatibility.md)) (Connect IQ, Monkey C): daily 100 push-ups, sit-ups, squats, auto rep counting (beta), manual correction, persistent XP/rank/streak. No GPS/distance. Goal: paid Connect IQ Store launch.

**`docs/` = source of truth; this file only orientation + house rules.** Resume order:

1. [`docs/status.md`](docs/status.md): state, evidence, launch gates; open items in root [`ROADMAP.md`](../ROADMAP.md).
2. [`docs/architecture.md`](docs/architecture.md): structure, layers, navigation, known debt.
3. [`docs/decisions.md`](docs/decisions.md): ADRs (why). Read five flagged at top.
4. As needed: [`docs/input-and-ux.md`](docs/input-and-ux.md) (screens/buttons), [`docs/development.md`](docs/development.md) (commands, device debugging), [`docs/testing-plan.md`](docs/testing-plan.md), [`docs/release-contract.md`](docs/release-contract.md) (check before any user-facing claim).

## Fast facts

- Products: 92 in both manifests (87 live; Instinct 3 AMOLED 45/50 mm added 2026-10-05, unreleased, round colour, [ADR-055](docs/decisions.md#adr-055) amendment; Crossover AMOLED left out, hands cover middle): 82 round AMOLED + MIP (69 five-button ([ADR-034](docs/decisions.md#adr-034)/[035](docs/decisions.md#adr-035)/[037](docs/decisions.md#adr-037)/[038](docs/decisions.md#adr-038)) + 13 touch-first Venu/vívoactive/Approach/D2 Air, [ADR-048](docs/decisions.md#adr-048)) + 7 Instinct + 3 touch-first rectangles (Venu Sq 2/Sq 2 Music/X1, unreleased, [ADR-057](docs/decisions.md#adr-057): rows full width, dashboard XP ring rounded-rectangle track along edges, content in inner box); only `fr965` tested on real watch · min API 3.4.0 (no 4.x-only calls outside `has` checks; `monkeyc` won't catch them) · one class per file, `HeroSet` prefix.
- **Instinct family, live since 1.3.0 (uploaded 2026-10-03; [ADR-055](docs/decisions.md#adr-055), Proposed until wrist check):** seven Instinct products (`instinct2`, `instinct2s`, `instinct2x`, `descentg1`, `instincte40mm`, `instincte45mm`, `instinct3solar45mm`); store does not sell paid app on Instinct 2 family or Descent G1 (not on Garmin's paid-app list); `HeroSetLayout` knows subscreen window, `HeroSetPalette` has black-and-white twin chosen by `color`/`mono` annotations in jungles (`exclude` + `$(exclude);color` per Instinct product; `tools/fit-sweep.sh` copies those lines). Look approved 2026-10-03, simulator only. 1.3.1 (fixes) uploaded 2026-10-04, in review.
- Builds: `monkey.jungle` = dev (Connect Sync + validation log); `store.jungle` = release: `manifest-store.xml` (no `Fit`/`FitContributor`), `(:sync)` code excluded, `resources-store/` menu ([ADR-033](docs/decisions.md#adr-033)). Both manifests keep same app id.
- CLI tools in SDK `bin/` folder, may not be on `PATH` (`~/Library/Application Support/Garmin/ConnectIQ/Sdks/<sdk>/bin/`). Signing key = `~/.garmin-connectiq/keys/developer_key` (outside repo; never commit it).
- Build: `monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y ~/.garmin-connectiq/keys/developer_key`
- Tests (124; 111 in store build): `monkeyc -t -d fr965 -f monkey.jungle -o bin/HeroSet-tests.prg -y ~/.garmin-connectiq/keys/developer_key`, then `monkeydo bin/HeroSet-tests.prg fr965 -t`. Trust printed `PASSED (…)` line, not exit code. Hung run → restart simulator. Swap `fr965` for other product id to check its screens (`everyScreenFitsThisDisplay`).
- Glance ([ADR-051](docs/decisions.md#adr-051)): `HeroSetApp` loaded whole by glance process, so its `initialize`/`onStart`/`onStop` never build store; glance code is `(:glance)` and read-only (`HeroSetGlanceReader`, `ui/glance/`). After any change touching `(:glance)` code or `HeroSetApp`, run `tools/glance-scope-check.sh`: default build silent about glance code reaching foreground code, fails only on watch. CIQ 4.0+ products only (65 of 82 round, 71 of 92 in all).
- Layers point down only: Presentation (`app/`, `ui/`, `layout/`) → Sensor / Data → Domain. Only `data/` touches Storage.
- XP only for net stored progress ([ADR-002](docs/decisions.md#adr-002)). Rank derived, never stored ([ADR-031](docs/decisions.md#adr-031)). Persisted key spellings never change ([ADR-003](docs/decisions.md#adr-003)).
- Navigation: Workout/Picker always depth 1 on dashboard; fixed pop counts depend on it, over-popping exits app ([ADR-024](docs/decisions.md#adr-024)).
- Device-only failure modes exist ([ADR-022](docs/decisions.md#adr-022)/[023](docs/decisions.md#adr-023)). Passing simulator not proof; say so when reporting.
- Sibling watch face `../HeroFace` (HeroFace) reads today's progress through one private complication this app publishes ([ADR-044](docs/decisions.md#adr-044), `HeroSetComplicationPublisher`): CIQ 4.2+ products only, resource in `resources-complications/` added per product in both jungles. Value = fixed field order; changing it breaks that app.
- Public site (landing, support, privacy) in sibling dir `../site` (studio "Verden", shared with future apps; its `CLAUDE.md` explains hosting + linking). HeroSet pages: `src/apps/heroset/` there, live at `/heroset/`, `/heroset/support/`, `/heroset/privacy/` on https://verden.watch (Firebase Hosting, deploy with `npm run deploy` in `site/`). Store listing uses those URLs. User-facing claim or data-handling change here → update those pages same session.

## House rules

- Every function: typed params + `as` return type. No `as Any`. Cast only after `instanceof`/null guard.
- No magic numbers: tunables in `HeroSetConfig`, geometry in `HeroSetLayout`, colors in `HeroSetPalette`, text in `strings.xml`.
- Text fit measured, never guessed ([ADR-018](docs/decisions.md#adr-018)). Draw text via `HeroSetDraw.text`, never `dc.drawText` ([ADR-034](docs/decisions.md#adr-034)); only exception `ui/glance/`, measures own text because `HeroSetDraw` not glance code ([ADR-051](docs/decisions.md#adr-051)). `HeroSetDraw.fits`/`firstFitting`/`largestFont` take radius + margin to measure against ([ADR-036](docs/decisions.md#adr-036)).
- Render only in `onUpdate`; logic in delegates/stores/domain.
- Functions ≲30 lines, files ≲250 lines (current exceptions: architecture §8).
- Catch only what can throw; degrade + flag, never swallow silently.
- Comments explain *why*, never *what*.
- No long-press gestures; hints name bezel buttons (`START`, `UP/DOWN`) ([ADR-029](docs/decisions.md#adr-029)), `SWIPE` on touch-first products via `HeroSetInput`. Commits (Finish, Save) act on START key in `onKey`, never `onSelect`: tap also select ([ADR-048](docs/decisions.md#adr-048)).
- Git index often mixed staged/unstaged: don't stage, commit, stash or reset unless asked.

## Keeping docs in sync

- Behavior change → update doc describing it, same session.
- Durable decision → new ADR at end of [`docs/decisions.md`](docs/decisions.md) (mark older ones Superseded/Amended; don't delete).
- Refer to ADR as link, `[ADR-048](docs/decisions.md#adr-048)` (path relative to file), start each new ADR heading with `<a id="adr-NNN"></a>` so anchor survives title edits.
- Open items live only in root [`ROADMAP.md`](../ROADMAP.md); [`status.md`](docs/status.md) keeps state, evidence, gates. History lives in git + ADRs, not status sections.
- Status-dated docs ([`status.md`](docs/status.md), [`release-contract.md`](docs/release-contract.md), [`compatibility.md`](docs/compatibility.md), [`battery.md`](docs/battery.md), [`connect-sync-plan.md`](docs/archive/connect-sync-plan.md)): bump date when editing.
- Test count appears in this file, `README.md`, [`docs/development.md`](docs/development.md), [`docs/status.md`](docs/status.md), [`CHANGELOG.md`](CHANGELOG.md) (newest entry); update all five.
- Prefer editing existing docs; genuinely new doc gets linked from [`docs/README.md`](docs/README.md).