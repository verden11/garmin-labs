# Verden — CLAUDE.md

Studio monorepo. Six independent projects, one git history.

**Each folder has its own `CLAUDE.md` and `docs/` — those are the source of
truth for that project. Read the one for the folder you are working in.** This
file only covers what spans folders.

| Folder | Project | Its CLAUDE.md |
|---|---|---|
| `HeroSet/` | Garmin watch app (Connect IQ, Monkey C) | [`HeroSet/CLAUDE.md`](HeroSet/CLAUDE.md) |
| `HeroFace/` | Garmin watch face (Connect IQ, Monkey C) | [`HeroFace/CLAUDE.md`](HeroFace/CLAUDE.md) |
| `DaysToGo/` | Garmin countdown watch face (Connect IQ, Monkey C) | [`DaysToGo/CLAUDE.md`](DaysToGo/CLAUDE.md) |
| `TwoSuns/` | Garmin sun and Body Battery watch face, "Two Suns" (Connect IQ, Monkey C) — submitted 2026-09-27, approved 2026-09-28 | [`TwoSuns/CLAUDE.md`](TwoSuns/CLAUDE.md) |
| `DayArc/` | Garmin time-of-day-adaptive watch face pair, "DayArc" (free) / "DayArc Pro" (paid, Garmin's second price step, no flip) — one codebase, two build targets/listings (Connect IQ, Monkey C) — built and tested in the simulator; the only real-device evidence is one owner photo (bug evidence, fixes not re-checked on a wrist) | [`DayArc/CLAUDE.md`](DayArc/CLAUDE.md) |
| `site/` | Public website (Vite + React, prerendered) | [`site/CLAUDE.md`](site/CLAUDE.md) |

`device-test/` is git-ignored scratch for on-watch builds, shared by both
watch projects.

`reports/` holds research and review reports; the sourced notes behind each are in `research_notes/<report title>/`.

`TODO.md` is the single running to-do list, HeroSet/HeroFace only by convention (the newer watch
face projects track their own open items in `docs/publish-checklist.md` instead).

Every watch project shares one file layout — see root `README.md` "Layout" for the exact tree, not
restated here. Keep new files in that shape.

## Cross-folder rules

- **The complication contract binds `HeroSet/` and `HeroFace/`.** Fixed field
  order, HeroSet [ADR-044](HeroSet/docs/decisions.md#adr-044). A change to it touches both folders and [ADR-044](HeroSet/docs/decisions.md#adr-044) in
  the same commit.
- **User-facing claims live in two places.** A behaviour or data-handling
  change in a watch project → update its pages under
  `site/src/apps/<slug>/` the same session. Store listings link those
  URLs, so **never change or remove a published URL**.
- Relative paths between folders (`../HeroFace`, `../site`) still work
  and are used throughout the docs. Keep them.

## Studio direction (owner, 2026-09-28)

Three directives from the owner. They apply to every watch project and to every `watch-pm` / `watch-design-lead` run:

- **Free + Pro for every face (apps where possible).**
- **Every face has a customisable accent colour, and it is in the Free tier.** Lists only, append-only ids, colours checked against the
  face's own reserved roles (`research_notes/Free and Pro ladder/accent_roster.md`).
- **Design more daringly**, without more fields: one decisive move per face, category-keyed bold colour, real icons, never a colour
  keyed to a reading. Design the Free build first. Mockup, browser screenshot and owner look-approval come before Monkey C. 96 KB
  faces (HeroFace, DaysToGo) have no bitmap budget.

**Agents: start at [`reports/Free and Pro ladder - START HERE.md`](reports/Free%20and%20Pro%20ladder%20-%20START%20HERE.md)** (status, rules, paste-ready prompt per work package).

**Proposed, pending owner sign-off (OD1/OD2 in the plan):** the ladder mechanics in
[`reports/Free and Pro ladder.md`](reports/Free%20and%20Pro%20ladder.md) and
[`reports/Free and Pro ladder execution plan.md`](reports/Free%20and%20Pro%20ladder%20execution%20plan.md) (live paid id becomes the
Pro, the Free is a new app id, no flip-to-free, prices, names, pilots). **Until the owner signs off, each project's existing ADRs
govern** (for example DaysToGo and TwoSuns ADR-002, the price and day-45 review). **2026-10-01: the owner asked for the missing Free builds, so the Free variants of DaysToGo, TwoSuns and HeroFace exist in the working tree (UNRELEASED, new ADRs marked Proposed). Building is done; uploads, names, prices, icons, translations and the site stay owner decisions. HeroSet Free is not built (accuracy-proof gate).**

## House rules everywhere

- Signing key is `~/.garmin-connectiq/keys/developer_key`, outside this repo.
  Never commit it, or any `.der` / `.pem`.
- Git index is often mixed staged/unstaged: don't stage, commit, stash or
  reset unless asked.
- Simulator passing is not device proof. Say so when reporting.
- **Simulator runs go through the container by default** (`<Project>/tools/run_tests.sh …`, `fit-sweep.sh`, `fit_languages.sh`; [`docker/README.md`](docker/README.md)). Each run gets its own simulator, so it never `pkill`s one someone else is using and any number run in parallel. The **host (macOS) simulator** (`CIQ_DOCKER=0`) is for final pre-release verification only, when the owner asks, or agrees to your suggestion, to use it. Do not switch to it on your own.
- Behaviour change → update the doc describing it, same session. Durable
  decision → an ADR in that project's `docs/decisions.md`.
- **Every store publication** gets an entry in that app's `CHANGELOG.md`
  (version, upload date, user-facing changes, ADRs) and a paste-ready
  What's New block in that app's `listing/README.md` (the previous block moves
  to `listing/NOTES.md`, and the App Version field is bumped).
