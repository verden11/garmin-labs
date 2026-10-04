# DayArc / DayArc Pro — CLAUDE.md

Garmin watch face pair (Connect IQ, Monkey C) from studio Verden. **Names working, not confirmed**
(store-collision and general web checked — `docs/decisions.md` ADR-012 — no registered-trademark
search). One codebase, two store listings: **DayArc** (free) shows one focal read per time window
(morning weather, midday stress, evening Body Battery, night time+date); **DayArc Pro** (paid, Garmin's second price step, no
flip-to-free) shows the same windows with a denser field grid under each hero read. Split is
compile-time (`monkey.simple.jungle`/`monkey.pro.jungle`, `excludeAnnotations`), never a runtime
toggle — deliberate, this platform's #1 complaint is settings not saving (ADR-003, ADR-011). The one
exception is a single Accent colour list (ADR-014, owner-requested after first wear).

**Read first:** [`docs/spec.md`](docs/spec.md) (what it does, data sources, device reach),
[`docs/status.md`](docs/status.md) (state, gates; open items are in the root [`ROADMAP.md`](../ROADMAP.md)), [`docs/archive/plan.md`](docs/archive/plan.md) (implementation status, what's simulator-only),
[`docs/decisions.md`](docs/decisions.md) (14 ADRs, each with evidence and what reverses it),
[`docs/status.md`](docs/status.md) (gates before either store upload),
[`docs/release-contract.md`](docs/release-contract.md) (what may be claimed),
[`docs/compatibility.md`](docs/compatibility.md), [`docs/development.md`](docs/development.md).
The evidence is in [`../reports/DayArc v1 scope and plan.md`](../reports/archive/DayArc%20v1%20scope%20and%20plan.md)
(supersedes the original report's technical/scope claims) and
[`../reports/Time of day adaptive watch face.md`](../reports/archive/Time%20of%20day%20adaptive%20watch%20face.md)
(competitive/wording/craft research still stands).

## Fast facts

- Independent of every other project here: own app ids (`56a7298c-dcbf-41ff-b013-9a073a59d2dd`
  Simple, `cc86c6b6-9a5c-4908-9056-165ff4b81982` Pro, neither changes once published), no shared
  code — the geometry/burn-in patterns are *copied* from TwoSuns (credited in each file's header
  comment), not linked.
- **Every field is `Toybox.Complications` except the morning weather read** (`Toybox.Weather`, no
  permission). Manifest permission: `ComplicationSubscriber` only — confirmed required (not "zero
  permissions," a correction caught before it reached spec/listing copy, ADR-002). No `Positioning`
  (DayArc reads no location, unlike TwoSuns), no `SensorHistory`, no network.
- ONE wearer setting, both listings: Accent colour, a 7-value list, default Auto = the per-window hues
  (ADR-014, partly reversing ADR-011). Read at draw time inside a guard, clamped, bad values fall
  back to Auto. Density and every other choice stay build-time (ADR-003). Never add a second
  setting without a new ADR.
- No verdicts, ever: stress and Body Battery are a number and a single-brightness gauge, no
  threshold tier at all, never a colour/mood judgement (ADR-006, extends TwoSuns ADR-008 — an
  earlier dim-above-threshold version was removed, not just documented as removed, see ADR-006).
- Build: `monkeyc -d fr965 -f monkey.simple.jungle -o bin/DayArc.prg -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3`
  (swap `monkey.pro.jungle` for the Pro build).
- **Instinct E 40/45 mm and Instinct 3 Solar 45 mm (ADR-015, proposed, simulator only; 72 products now):** 1-bit, a round window top right, 65,536 B face memory. `DayArcPalette` is two classes, `(:color)` and `(:mono)`, chosen by the jungles (`base.excludeAnnotations = <density's>;mono`, and per Instinct product `<product>.excludeAnnotations = <density's>;color`; a per-product line **replaces** the base list, so restate the density's own). The arc is a gauge in the window; the Accent setting (its own `resources-accent/` folder, left out of those products' `resourcePath`) and `getSettingsView` are off there. The visible area is a circle about 98 px in radius (`DayArcLayout.VISIBLE_RADIUS_PX`), not the whole square: **screenshot the simulator for every layout change** (`docs/development.md`). The Instinct 2 family is not included (CIQ 3.4 has no Complications).
- Package check: `tools/check_package.sh [--build]` (the 4 Instinct parts carry no settings file; every other part has Accent).
- Tests: `tools/run_tests.sh <device> [jungle] [testName]`. Compile-only sweep across all 72
  products, both jungles: `tools/compile_sweep.sh` (no simulator needed).
- **One real-device photo, nothing else** (owner's FR965, evening window, 2026-09-28: it showed the
  sub line as "4...", the arc crowding the clock corners and a top-heavy stack — all fixed in
  `DayArcStack`/`DayArcArc`, ADR-013's amendment, and not yet re-checked on the wrist). Otherwise
  everything is simulator-only: compile sweep (69/69 both
  densities) plus render/test exercise on 4 spot-check devices (fr965, approachs50, venusq2,
  venux1). No screenshot of either build exists (no display in the dev sandbox).

## Open owner decisions

Not decided, and not to be decided alone: both launcher icons/covers/heroes (placeholders now), the
night-window default (ADR-010 — time+date only, a plan default, not confirmed), both listings'
OWNER listing fields, languages beyond English, the site pages, both store submissions, whether to
run a real trademark search. Decided: two-listing architecture (ADR-003), fixed-clock windows
(ADR-004), pricing (ADR-007), Simple's calendar exclusion (ADR-008), Pro's density target (ADR-009).
**The look is owner-approved for direction and now built** (ADR-013, 2026-09-28: per-window/per-icon
colour, real icons, always-visible date, window-progress arc). Simulator-tested,
fr965/approachs50/venusq2/venux1, both jungles; still not shown to the owner as an actual render, and
no real-device evidence — a mockup or a simulator pass is not device proof.

Price: Simple free forever (nothing to flip). Pro is paid at Garmin's second price step (ADR-007, amended 2026-10-01), never flips to free — no price
review date to set.

## House rules

Same as every project here ([`../TwoSuns/CLAUDE.md`](../TwoSuns/CLAUDE.md) etc.), which this
project mirrors:

- Every function: typed params and `as` return type. No `as Any`. Cast only after `instanceof` or a
  null guard.
- No magic numbers: tunables in `DayArcConfig`, geometry in `DayArcLayout`, colours in
  `DayArcPalette`, words in `strings.xml`.
- Text fit is measured, never guessed: `DayArcStack` plans every row's font and y by a dry run of the
  whole stack, `DayArcText`/`DayArcDraw` draw exactly that plan. Fit tests run per real device
  (`tools/run_tests.sh <device>`): a synthetic buffered Dc changes the size, never the fonts.
- Render only in `onUpdate`; gather in `DayArcSources`/`DayArcFields`.
- One class per file, `DayArc` prefix. Functions ≲30 lines, files ≲250.
- A value the watch does not have is hidden or said in words, never faked or blank ("--", a plain
  sentence for the hero read's own empty state).
- Forbidden here: any mood/emoji/colour verdict on stress or Body Battery (a colour the WEARER
  chose is constant whatever the reading — ADR-014 — that's not a verdict); a runtime density
  setting; any wearer setting other than Accent colour; the network; `Background`, `Communications`, `UserProfile`, `Positioning`; claiming a
  cause for a null the SDK can't actually attribute (calendar's null, VO2max/pulse ox/weekly-
  distance nulls — see `docs/spec.md` "Data sources"); a raw Garmin-authored string surfaced
  unfiltered when its vocabulary isn't fully known (training status was cut for exactly this).
- Do not invent evidence: no reviews, downloads, screenshots, or device photos, in any doc or
  listing. Say "simulator only" wherever a claim rests on the simulator.

## Keeping things in sync

- Behaviour change → `docs/spec.md` (and `DESIGN.md` if visual) same session; a durable decision →
  an ADR in `docs/decisions.md`.
- New layout or string → run `tools/run_tests.sh` on at least fr965 + one small/rectangular device,
  both jungles.
- User-facing claims live in the listing and `../site/src/apps/day-arc/` /
  `../site/src/apps/day-arc-pro/`; change both together, never change a published URL. Check every
  claim against `docs/release-contract.md`.
- Every store publication gets a `CHANGELOG.md` entry and a What's New block in that listing's
  `README.md`.
- Edits outside `DayArc/` are limited to the root `CLAUDE.md` table row, the root `README.md`, and
  `site/`. Ask before touching `HeroSet/`, `HeroFace/`, `DaysToGo/` or `TwoSuns/`.
