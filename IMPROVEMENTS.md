# Improvements backlog

Status: 2026-09-25. Incremental, implementable-cold findings from a read-only
+ measured audit of all three projects. This is not `HeroSet/docs/ideas.md`
(feature ideas) — this is small correctness/perf/quality gains, ranked by
gain/effort, meant to be picked up on a machine with the full Connect IQ
toolchain.

Each item states verification status. Anything under `HeroSet/`/`heroFace/`
was **not** compiled or run here (no `monkeyc`/simulator/device in this
container) — those are read-only findings, marked `unverified: needs local
monkeyc build + sim + device`. Simulator passing is not device proof either;
say so when reporting on those.

Ranked by gain/effort, strongest evidence first.

---

_(auditing in progress — sections fill in below as each project is passed)_
