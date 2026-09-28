# DayArc / DayArc Pro

A watch face whose content changes with the time of day, not a toggle: weather to dress for in the
morning, a stress read at midday, Body Battery in the evening, time and date at night. Two
listings, one codebase — **DayArc** is one focal read per window, **DayArc Pro** is the same three
windows with a denser field grid under each hero read.

Status: unbuilt on any real device; simulator-tested (compile sweep both densities, all 69
products; render/test exercised on 4 representative devices). See
[`docs/plan.md`](docs/plan.md) "Implementation status" for exactly what that does and doesn't
cover.

## Layout

- `source/`, `resources/` (shared) — Monkey C source and resources.
- `resources-pro/` — Pro-only override (`AppName`, launcher icon).
- `manifest.simple.xml` / `manifest.pro.xml`, `monkey.simple.jungle` / `monkey.pro.jungle` — two
  build targets from one source tree (`docs/decisions.md` ADR-003).
- `docs/` — spec, plan, ADRs, compatibility, publish checklist.
- `listing/` (DayArc) and `listing-pro/` (DayArc Pro) — store form text and its rationale.
- `DESIGN.md` — visual system (colours, layout, motion), shared by both densities.
- `CHANGELOG.md` — one entry per store publication, either listing.

See [`docs/spec.md`](docs/spec.md) for what this app does,
[`docs/plan.md`](docs/plan.md) for implementation status,
[`docs/publish-checklist.md`](docs/publish-checklist.md) for what's left before either listing can
ship.
