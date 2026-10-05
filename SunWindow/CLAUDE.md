# Sun Window — CLAUDE.md

A Garmin app with a glance (widget-style; manifest type `watch-app`, ADR-008) that shows whether the sun is above a set height right now. (Connect IQ, Monkey C).

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

Still with the owner: the look of the mockup and the built screens (plan
OD-7), and the icon, cover, hero and store screens (OD-10). Every upload,
site deploy, commit and merge is also the owner's. ADR-008 to ADR-010 are
Proposed until plan task P1.5. The open items are tracked in ROADMAP.md
(16.x).

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
- Text fit is measured, never guessed: draw through `SunWindowDraw`, never
  the raw `dc.drawText`.
- Render only in `onUpdate` (and `onPartialUpdate` if used); gather data
  separately (a readings/store layer) and draw from a state object.
- Glance code is `(:glance)`; check scope with `tools/glance-scope-check.sh`
  (a default build is silent about scope leaks).
- One class per file, `SunWindow` prefix. Functions ≲30 lines, files ≲250.
- Comments explain *why*, never *what*.
- A value the watch does not have is hidden or said in words, never faked
  or blank.
