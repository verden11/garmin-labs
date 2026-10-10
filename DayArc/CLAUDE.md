# DayArc / DayArc Pro — CLAUDE.md

Garmin watch face pair (Connect IQ, Monkey C), studio Verden. **Names "DayArc" and "DayArc Pro" confirmed by the owner, 2026-10-04 (ROADMAP 1.4)**
(store-collision + general web checked — `docs/decisions.md` ADR-012 — no registered-trademark
search). One codebase, two store listings: **DayArc** (free) shows one focal read per time window
(morning weather, midday stress, evening Body Battery, night time+date); **DayArc Pro** (paid, $2.50 tier, ADR-018, no
flip-to-free) shows same windows, denser field grid under each hero read. Split compile-time (`monkey.simple.jungle`/`monkey.pro.jungle`, `excludeAnnotations`), never runtime
toggle — deliberate, platform's #1 complaint is settings not saving (ADR-003, ADR-011). Only exception: single Accent colour list (ADR-014, owner-requested after first wear).

**Read first:** [`docs/spec.md`](docs/spec.md) (what it does, data sources, device reach),
[`docs/status.md`](docs/status.md) (state, gates; open items in root [`ROADMAP.md`](../ROADMAP.md)), [`docs/archive/plan.md`](docs/archive/plan.md) (implementation status, what's simulator-only),
[`docs/decisions.md`](docs/decisions.md) (20 ADRs, each with evidence and what reverses it),
[`docs/status.md`](docs/status.md) (gates before either store upload),
[`docs/release-contract.md`](docs/release-contract.md) (what may be claimed),
[`docs/compatibility.md`](docs/compatibility.md), [`docs/development.md`](docs/development.md).
Evidence: [`../reports/DayArc v1 scope and plan.md`](../reports/archive/DayArc%20v1%20scope%20and%20plan.md)
(supersedes original report's technical/scope claims) and
[`../reports/Time of day adaptive watch face.md`](../reports/archive/Time%20of%20day%20adaptive%20watch%20face.md)
(competitive/wording/craft research still stands).

## Fast facts

- Independent of every other project here: own app ids (`56a7298c-dcbf-41ff-b013-9a073a59d2dd`
  Simple, `cc86c6b6-9a5c-4908-9056-165ff4b81982` Pro, neither changes once published), no shared
  code — geometry/burn-in patterns *copied* from TwoSuns (credited in each file's header
  comment), not linked.
- **Every field `Toybox.Complications` except morning weather read** (`Toybox.Weather`, no
  permission). Manifest permission: `ComplicationSubscriber` only — confirmed required (not "zero
  permissions," correction caught before reaching spec/listing copy, ADR-002). No `Positioning`
  (DayArc reads no location, unlike TwoSuns), no `SensorHistory`, no network.
- ONE wearer setting, both listings: Accent colour, 7-value list, default Auto = per-window hues
  (ADR-014, partly reversing ADR-011). Read at draw time inside guard, clamped, bad values fall
  back to Auto. Density and every other choice stay build-time (ADR-003). Never add second
  setting without new ADR.
- No verdicts, ever: stress and Body Battery = number and single-brightness gauge, no
  threshold tier at all, never colour/mood judgement (ADR-006, extends TwoSuns ADR-008 — earlier dim-above-threshold version removed, not just documented as removed, see ADR-006).
- Build: `monkeyc -d fr965 -f monkey.simple.jungle -o bin/DayArc.prg -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3`
  (swap `monkey.pro.jungle` for Pro build).
- **Instinct E 40/45 mm and Instinct 3 Solar 45 mm (ADR-015, accepted 2026-10-04, simulator only; 72 products now):** 1-bit, round window top right, 65,536 B face memory. `DayArcPalette` two classes, `(:color)` and `(:mono)`, chosen by jungles (`base.excludeAnnotations = <density's>;mono`, and per Instinct product `<product>.excludeAnnotations = <density's>;color`; per-product line **replaces** base list, so restate density's own). Arc is a gauge in the window; Accent setting (own `resources-accent/` folder, left out of those products' `resourcePath`) and `getSettingsView` off there. Visible area is circle about 98 px radius (`DayArcLayout.VISIBLE_RADIUS_PX`), not whole square: **screenshot the simulator for every layout change** (`docs/development.md`). Instinct 2 family not included (CIQ 3.4 has no Complications).
- **Hero icons generated, two sizes per screen (ADR-017, 2026-10-04):** `python3 tools/gen_hero_icons.py` writes every hero SVG
  (`resources/` = default 72/54 px, `resources-hero-L<n>` / `-S<n>` = others), Instinct weather glyph and family lines
  between BEGIN/END markers of both jungles. Never hand-edit those SVGs or that block; new screen size = row in script's
  `FAMILIES` (measure its HOT/MEDIUM/MILD box with `tools/run_tests.sh <device>`, `HEROINK` log line). Large icon beside HOT
  number tier, small beside MEDIUM/MILD (`DayArcStack.smallIcon`).
- Package check: `tools/check_package.sh [--build]` (4 Instinct parts carry no settings file; every other part has Accent).
- Tests: `tools/run_tests.sh <device> [jungle] [testName]`. Compile-only sweep across all 72
  products, both jungles: `tools/compile_sweep.sh` (no simulator needed).
- **One real-device photo, nothing else** (owner's FR965, evening window, 2026-09-28: showed
  sub line as "4...", arc crowding clock corners, top-heavy stack — all fixed in
  `DayArcStack`/`DayArcArc`, ADR-013's amendment; final builds on owner's FR965 since 2026-10-05 for
  wear check, ROADMAP 1.1). Otherwise everything simulator-only: compile sweep 72/72 both
  densities, unit suites on 13 devices (2026-10-04) and Simple 23/23, Pro 26/26 on 5 devices after
  2026-10-05 review fixes. Simulator screenshots of
  every window: `../docker/capture.sh DayArc tools/window_shots.sh ...` writes them to untracked
  `bin/shots/` (cleared 2026-10-05; re-run to see them); none is device photo.

## Open owner decisions

**Live since 2026-10-05** (DayArc https://apps.garmin.com/apps/9e641dce-3838-4613-a129-55faeb761193, DayArc Pro https://apps.garmin.com/apps/b6373747-2569-4a55-86ca-c42914c571fe; icons, covers, heroes, listing text, screens approved by owner that day). Still owner's: translation reads, every future upload, whether to run real trademark search. Decided: names DayArc / DayArc Pro (2026-10-04), placeholder night window stays (time and date only, ADR-010, ROADMAP 1.7), Instinct Pro behaviour as built (ROADMAP 1.18), two-listing architecture (ADR-003), fixed-clock windows
(ADR-004), pricing (ADR-007; price part superseded by ADR-018), Simple's calendar exclusion (ADR-008), Pro's density target (ADR-009).
**Look owner-approved for direction, now built** (ADR-013, 2026-09-28: per-window/per-icon
colour, real icons, always-visible date, window-progress arc; amended 2026-10-05: bolt for Body Battery, grey grid icons). Simulator-tested, both jungles
(unit suites on 13 devices, five reviewed with screenshots: fr965, fr255s, epix2, instincte40mm, instinct3solar45mm; nine
design-review passes, recorded in ADR-017); no real-device evidence yet — mockup or simulator pass not device proof.

Price: Simple free forever (nothing to flip). Pro paid at $2.50 tier (ADR-018, price: the $2.50 tier for every paid app, which supersedes the price of ADR-007; set in upload form, no price number in listing or site text), never flips to free — no price
review date to set.

## House rules

Same as every project here ([`../TwoSuns/CLAUDE.md`](../TwoSuns/CLAUDE.md) etc.), which this
project mirrors:

- Every function: typed params and `as` return type. No `as Any`. Cast only after `instanceof` or null guard.
- No magic numbers: tunables in `DayArcConfig`, geometry in `DayArcLayout`, colours in
  `DayArcPalette`, words in `strings.xml`.
- Text fit measured, never guessed: `DayArcStack` plans every row's font and y by dry run of
  whole stack, `DayArcText`/`DayArcDraw` draw exactly that plan. Fit tests run per real device
  (`tools/run_tests.sh <device>`): synthetic buffered Dc changes size, never fonts.
- Render only in `onUpdate`; gather in `DayArcSources`/`DayArcFields`.
- One class per file, `DayArc` prefix. Functions ≲30 lines, files ≲250.
- Value watch does not have: hidden or said in words, never faked or blank ("--", plain
  sentence for hero read's own empty state).
- Forbidden here: any mood/emoji/colour verdict on stress or Body Battery (colour the WEARER
  chose is constant whatever the reading — ADR-014 — not a verdict); runtime density
  setting; any wearer setting other than Accent colour; network; `Background`, `Communications`, `UserProfile`, `Positioning`; claiming
  cause for null the SDK can't attribute (calendar's null, VO2max/pulse ox/weekly-
  distance nulls — see `docs/spec.md` "Data sources"); raw Garmin-authored string surfaced
  unfiltered when vocabulary not fully known (training status cut for exactly this).
- Do not invent evidence: no reviews, downloads, screenshots, device photos, in any doc or
  listing. Say "simulator only" wherever claim rests on simulator.

## Keeping things in sync

- Behaviour change → `docs/spec.md` (and `DESIGN.md` if visual) same session; durable decision →
  ADR in `docs/decisions.md`.
- New layout or string → run `tools/run_tests.sh` on at least fr965 + one small/rectangular device,
  both jungles.
- User-facing claims live in listing and `../site/src/apps/day-arc/` /
  `../site/src/apps/day-arc-pro/`; change both together, never change published URL. Check every
  claim against `docs/release-contract.md`.
- Every store publication gets `CHANGELOG.md` entry and What's New block in that listing's
  `README.md`.
- Edits outside `DayArc/` limited to root `CLAUDE.md` table row, root `README.md`, and
  `site/`. Ask before touching `HeroSet/`, `HeroFace/`, `DaysToGo/` or `TwoSuns/`.