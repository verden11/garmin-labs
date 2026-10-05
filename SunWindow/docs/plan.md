# Sun Window — implementation plan

The plan is [`../../reports/Sun Window build plan.md`](../../reports/Sun%20Window%20build%20plan.md):
13 phases, 69 numbered tasks (P0.1 to P12.5), each with files, inputs,
done-criteria and owner/agent. Gates and evidence: [`status.md`](status.md).
Open items: root `ROADMAP.md` 16.x.

## Implementation status

- **P0 (docs, decisions):** done by the agent 2026-10-05, except P0.6 (ROADMAP entries drafted for the owner to apply) and P0.9 (the owner's commit).
- **P1.1, P1.2 (agent):** done 2026-10-05. Spike probe `research_notes/Sun Window build plan/probe/` (watch-app + glance) builds clean at `--typecheck 3` and `-l 3`, runs in the container simulator on fr965 and instincte40mm (glance and full view; simulator weather canned, no GPS). FR965 file and checklist in the worktree's git-ignored `device-test/`. **P1.3 (owner wear day) open.**
- **P2.1 to P2.4 (agent):** done 2026-10-05. Fonts and glance areas measured on 7 devices (`fontprobe/results/fonts-*.log`, simulator); mockup rev 2 `docs/archive/mockup.html`, screenshot `research_notes/Sun Window build plan/mockup/mockup-2026-10-05-rev2.png`. No impeccable critique or detector ran (judged from the screenshot by eye). **P2.5 approved by the owner 2026-10-05; P2.6 recorded (ADR-011, DESIGN.md).**
- Found on the way (simulator): `WatchUi.getSubscreen()` without a `has :getSubscreen` guard crashes the app on non-Instinct watches.
- **P3 onward:** not started.

Move this file to `archive/` once v1 is built.
