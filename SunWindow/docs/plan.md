# Sun Window — implementation plan

The plan is [`../../reports/Sun Window build plan.md`](../../reports/Sun%20Window%20build%20plan.md): 13 phases, 70 numbered tasks
(P0.1 to P12.5), each with files, inputs, done-criteria and owner/agent. Gates and evidence: [`status.md`](status.md). Open items:
root `ROADMAP.md` 18.x.

## Implementation status (2026-10-10)

| Phase | State |
|---|---|
| P0 docs, decisions | Done (2026-10-05); ROADMAP entries are in `ROADMAP.md` 18.x |
| P1 FR965 spike | Agent part done; the owner's wear day passed D6, D12 and part of D2 and D7 on 2026-10-05 (probe, FR965 only); results in `status.md`. Found on the way: `WatchUi.getSubscreen()` without a `has :getSubscreen` guard crashes the app on non-Instinct watches |
| P2 mockup and look | Done: mockup rev 2 approved 2026-10-05 (ADR-011); fonts measured on 7 devices (`research_notes/Sun Window build plan/fontprobe/results/`) |
| P3 skeleton and tooling | Done: manifest (`widget`, ADR-008), jungle, resources, `tools/` |
| P4 pure logic and tests | Done: Double sun maths, place, weather, state rule; generated reference tests (31 tests, simulator) |
| P5 views, location, menu | Done: glance, full view, sources, accent menu |
| P6 simulator verification | Done: tests on 7 screen shapes, compile sweep of 65 products, glance memory, screenshots looked at, design and code review (`status.md`); P6.7, the owner's look-check of the built screens, is open (ROADMAP 18.1) |
| P7 wear day | Open (owner, ROADMAP 18.4; steps in [`wear-day-checklist.md`](wear-day-checklist.md)) |
| P8 translations | Dormant: v1 is English only (ADR-013) |
| P9 store images and listing | Listing text drafted in `listing/paste.md`; images and the final launcher icon are the owner's look decision (ROADMAP 18.1, 18.6) |
| P10 site | Pages written, in a separate draft PR because a merge to `main` deploys the site |
| P11, P12 release, after approval | Open (owner) |

Move this file to `archive/` once v1 is built and released.
