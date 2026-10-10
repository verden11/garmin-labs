# Verden — CLAUDE.md

Studio monorepo. Six independent projects, one git history.

**Each folder has own `CLAUDE.md` and `docs/` — source of truth for that project. Read the one for folder you work in.** This file covers only what spans folders.

| Folder | Project | Its CLAUDE.md |
|---|---|---|
| `HeroSet/` | Garmin watch app (Connect IQ, Monkey C) | [`HeroSet/CLAUDE.md`](HeroSet/CLAUDE.md) |
| `HeroFace/` | Garmin watch face (Connect IQ, Monkey C) | [`HeroFace/CLAUDE.md`](HeroFace/CLAUDE.md) |
| `DaysToGo/` | Garmin countdown watch face (Connect IQ, Monkey C) | [`DaysToGo/CLAUDE.md`](DaysToGo/CLAUDE.md) |
| `TwoSuns/` | Garmin sun and Body Battery watch face, "Two Suns" (Connect IQ, Monkey C) — approved 2026-09-28; Pro 1.1.0 and new Free uploaded 2026-10-04, in Garmin review | [`TwoSuns/CLAUDE.md`](TwoSuns/CLAUDE.md) |
| `DayArc/` | Garmin time-of-day-adaptive watch face pair, "DayArc" (free) / "DayArc Pro" (paid, $2.50 tier, no flip) — one codebase, two build targets/listings (Connect IQ, Monkey C) — **live since 2026-10-05** (both listings approved by Garmin that day); wrist check of final build and night window still open (ROADMAP 1.1) | [`DayArc/CLAUDE.md`](DayArc/CLAUDE.md) |
| `site/` | Public website (Vite + React, prerendered) | [`site/CLAUDE.md`](site/CLAUDE.md) |

`device-test/` git-ignored scratch for on-watch builds, shared by both watch projects.

`reports/` holds research and review reports; sourced notes behind each in `research_notes/<report title>/`.

`ROADMAP.md` = single to-do list for every project: what needs owner's decision, what needs their hands (watch, store dashboard, people), what agent can do now, what waits on a date. Per-project `docs/status.md` keeps where things stand, evidence, release gates, upload steps, **never open checkboxes**; add items in ROADMAP.md only, move each done item to `ROADMAP-done.md`.

Every watch project shares one file layout — see root `README.md` "Layout" for exact tree, not restated here. Keep new files in that shape.

## Cross-folder rules

- **Complication contract binds `HeroSet/` and `HeroFace/`.** Fixed field order, HeroSet [ADR-044](HeroSet/docs/decisions.md#adr-044). Change touches both folders and [ADR-044](HeroSet/docs/decisions.md#adr-044) in same commit.
- **User-facing claims live in two places.** Behaviour or data-handling change in watch project → update its pages under `site/src/apps/<slug>/` same session. Store listings link those URLs, so **never change or remove a published URL**.
- Relative paths between folders (`../HeroFace`, `../site`) still work, used throughout docs. Keep them.

## Studio direction (owner, 2026-09-28)

Three directives from owner. Apply to every watch project and every `watch-pm` / `watch-design-lead` run:

- **Free + Pro for every face (apps where possible).**
- **Every face has customisable accent colour, in Free tier.** Lists only, append-only ids, colours checked against face's own reserved roles (`research_notes/Free and Pro ladder/accent_roster.md`).
- **Design more daringly**, without more fields: one decisive move per face, category-keyed bold colour, real icons, never colour keyed to a reading. Design Free build first. Mockup, browser screenshot, owner look-approval come before Monkey C. 96 KB faces (HeroFace, DaysToGo) have no bitmap budget.

**Agents: start at [`reports/Free and Pro ladder - START HERE.md`](reports/Free%20and%20Pro%20ladder%20-%20START%20HERE.md)** (status, rules, paste-ready prompt per work package).

**Approved by owner 2026-10-04 (OD1/OD2):** ladder mechanics in [`reports/Free and Pro ladder.md`](reports/Free%20and%20Pro%20ladder.md) and [`reports/Free and Pro ladder execution plan.md`](reports/Free%20and%20Pro%20ladder%20execution%20plan.md) (live paid id becomes Pro, Free is new app id, no flip-to-free). Ladder ADRs Active (HeroFace ADR-001 (ladder), DaysToGo ADR-014 (ladder), TwoSuns ADR-020 (ladder)); DaysToGo and TwoSuns ADR-002 (price and day-45 review) Superseded: **day-45 flip rule retired.** **Price (owner, 2026-10-04): every paid app takes $2.50 tier of Garmin's price points** (HeroSet ADR-056 (price tier), HeroFace ADR-004 (price tier), DaysToGo ADR-017 (price tier), TwoSuns ADR-026 (price tier), DayArc ADR-018 (price tier); US $2.49, eurozone 2,99 EUR); free apps stay free; **no price number in site or listing text** (prices vary per region); owner sets tier in upload form with each paid app's next version upload (ROADMAP 2.7). Names confirmed (Free = clean name, Pro = "<Name> Pro"); icons, translations, every upload stay owner decisions; HeroSet and DayArc follow own ADRs. **2026-10-04: Free variants of DaysToGo, TwoSuns, HeroFace (new app ids) and Pro updates uploaded by owner, in Garmin review (ROADMAP 7.12); icons, translations, site stay owner decisions. HeroSet Free not built (accuracy-proof gate). Owner decisions 2026-10-04: HeroFace Free has no temperature; Two Suns Free keeps `--` for missing Body Battery number; HeroFace Magenta recoloured to pass 3:1 track rule (HeroFace ADR-003 (Magenta recolour)).**

## House rules everywhere

- Signing key `~/.garmin-connectiq/keys/developer_key`, outside this repo. Never commit it, or any `.der` / `.pem`.
- Git index often mixed staged/unstaged: don't stage, commit, stash, reset unless asked.
- Simulator passing not device proof. Say so when reporting.
- **Simulator screenshots and list of automatic checks (and gaps): [`docker/SIMULATOR.md`](docker/SIMULATOR.md).** Layout change not done until you looked at screenshot (`docker/shot.sh`): unit suite misses what bezel clips.
- **Simulator runs go through container by default** (`<Project>/tools/run_tests.sh …`, `fit-sweep.sh`, `fit_languages.sh`; [`docker/README.md`](docker/README.md)). Each run gets own simulator, never `pkill`s one someone else uses, any number run parallel. **Host (macOS) simulator** (`CIQ_DOCKER=0`) only for final pre-release verification, when owner asks, or agrees to your suggestion. Do not switch on your own.
- **Who does what** (`.claude/agents/`): main session (Opus) drives, decides, looks at every screenshot. `coder` (Sonnet) implements bounded brief. `reviewer` (Opus, read-only) critiques before anything called done. `sim-runner` (Haiku) only runs test and capture scripts, one per device in parallel, reports exit codes and paths; never judges image.
- Behaviour change → update doc describing it, same session. Durable decision → ADR in that project's `docs/decisions.md`.
- **Every store publication** gets entry in that app's `CHANGELOG.md` (version, upload date, user-facing changes, ADRs) and paste-ready What's New block in that app's `listing/paste.md` (previous block moves to `listing/NOTES.md`, App Version field bumped).