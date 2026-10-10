# Sun Window — CLAUDE.md

A Garmin widget with a glance (manifest type `widget`, ADR-008; on API 5.1+ watches the compiler builds it as an app with a glance) that shows whether the sun is above a set height right now. (Connect IQ, Monkey C). **Built and simulator-tested 2026-10-10; not on a wrist, not uploaded.**

Name: Sun Window, slug `sun-window` (ADR-001, name and slug; trademark check before listing work).

**Start here:** the task plan is [`reports/Sun Window build plan.md`](../reports/Sun%20Window%20build%20plan.md)
(70 numbered tasks P0.1 to P12.5, each with files, inputs, done-criteria and
owner/agent). Where things stand: [`docs/status.md`](docs/status.md).

## Layout

`docs/` for engineering and product docs (index: `docs/README.md`),
`listing/` for everything the store form takes (`listing/paste.md`
paste-ready, form field order; `listing/meta.yaml` status and owner
approvals; `listing/NOTES.md` the why), `DESIGN.md` for the visual system,
`CHANGELOG.md` at the root — one entry per store publication.

## Owner decisions

Decided: widget-style only, no watch face, no nudge ([ADR-002](docs/decisions.md#adr-002-v1-is-widget-style-no-watch-face-no-nudge), owner 2026-10-04); Free only ([ADR-003](docs/decisions.md#adr-003-v1-is-free-only-no-pro), owner 2026-10-04). On 2026-10-05 the owner approved all of the plan's recommendations: name and slug ([ADR-001](docs/decisions.md#adr-001-name-and-slug)), no "vitamin D" anywhere ([ADR-005](docs/decisions.md#adr-005-wording-rules-no-vitamin-d-anywhere)), clock times in the full view only ([ADR-006](docs/decisions.md#adr-006-clock-times-in-the-full-view-only-none-today-is-a-sentence-only)), conditional go ([ADR-007](docs/decisions.md#adr-007-go-to-the-device-spike-build-only-if-the-watch-yields-a-place)), and the store and release answers ([ADR-013](docs/decisions.md#adr-013-store-and-release-answers)).

Decided 2026-10-10: the manifest type is `widget` ([ADR-008](docs/decisions.md#adr-008-manifest-type-widget-owner-2026-10-10-with-a-glance), owner), and ADR-009, ADR-010 are Active with the build.

Still with the owner: the look of the built screens (plan P6.7) and the
launcher icon, cover, hero and store screens (OD-10), the trademark check,
the wear day, every upload, site deploy and merge. Open items are tracked in
ROADMAP.md (18.x); where things stand is [`docs/status.md`](docs/status.md).

## Fast facts

- Code: `source/` (one class per file, `SunWindow` prefix), tests in `source/test/` (`tools/run_tests.sh <device>`, 31 tests, 28 on the 1-bit Instinct), `tools/` (compile sweep, fit, glance scope check, generators). The glance code is `(:glance)`; after any change near it run `tools/glance-scope-check.sh` (a default build is silent about scope leaks).
- The state rule is one pure function, `SunWindowReader.build`; the glance and the full view both call it at every draw, so they agree and nothing is stored between draws. Only `SunWindowSources` writes Storage (the place, `[lat, lon]`, key `place`) and only the foreground calls `Position`.
- The sun maths is a Double port of NOAA's formulas (`SunWindowSun`); `tools/gen_sun_tests.py` writes `source/test/SunWindowSunReferenceTest.mc` from `research_notes/Vitamin D window/solar_elevation_fixtures.py` (window edges within 1 minute, elevation within 0.02 degrees); `tools/gen_glance_areas.py` writes the glance-area table. Re-run a generator when its input changes.
- Palette: `SunWindowPalette` is two classes, `(:glance, :color)` and `(:glance, :mono)`, chosen by `monkey.jungle` (`base.excludeAnnotations = mono`; each 1-bit Instinct product excludes `color` and leaves `resources-accent` out). Property key `Accent` and Storage key `place` never change once shipped; accent ids are append-only.
- Simulator screenshots: `../docker/capture.sh SunWindow tools/shots.sh <device> <tag> "<clock>" [seed|noseed] [lowuv] [accent]` (`docs/development.md`). All simulator evidence is simulator only.

## House rules

- Signing key stays outside this repo. Never commit it, or any `.der`/`.pem`.
- Simulator passing is not device proof. Say so when reporting status.
- Behaviour change → update the doc describing it, same session. Durable
  decision → an ADR in `docs/decisions.md`.
- Every store publication gets a `CHANGELOG.md` entry (version, upload
  date, user-facing changes, ADRs) and a paste-ready What's New block in
  `listing/paste.md` (the previous block moves to `listing/NOTES.md`, App
  Version bumped).
- No "vitamin D", no "no location", no health or safety claim anywhere
  (ADR-005, `docs/release-contract.md`).

### Code conventions

- Every function: typed params and `as` return type. No `as Any`. Cast only
  after an `instanceof` or null guard.
- No magic numbers: tunables and keys in `SunWindowConfig`, geometry in
  `SunWindowLayout`, colours in `SunWindowPalette`, text in `strings.xml`.
- Text fit is measured, never guessed: a row's font comes from
  `SunWindowRows.plan` (full view) or `SunWindowGlanceView.plan` (glance),
  which measure with the product's own fonts; `dc.drawText` is called only with
  a planned font and position. A new row goes through the plan and into
  `SunWindowTestStates`, so `everyStateFitsThisDisplay` sees it.
- Render only in `onUpdate` (and `onPartialUpdate` if used); gather data
  separately (`SunWindowSources`, `SunWindowReader`) and draw from a state object.
- Glance code is `(:glance)`; check scope with `tools/glance-scope-check.sh`
  (a default build is silent about scope leaks).
- One class per file, `SunWindow` prefix. Functions ≲30 lines, files ≲250. Exceptions:
  `SunWindowPalette.mc` holds the `(:color)` and `(:mono)` twins of one class (the jungle
  picks one), and generated files (`source/test/SunWindowSunReferenceTest.mc`,
  `SunWindowGlanceAreas.mc`) are not hand-edited, so their length does not count.
- Comments explain *why*, never *what*.
- A value the watch does not have is hidden or said in words, never faked
  or blank.
