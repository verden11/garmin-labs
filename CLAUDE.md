# Verden — CLAUDE.md

Studio monorepo. Four independent projects, one git history.

**Each folder has its own `CLAUDE.md` and `docs/` — those are the source of
truth for that project. Read the one for the folder you are working in.** This
file only covers what spans folders.

| Folder | Project | Its CLAUDE.md |
|---|---|---|
| `HeroSet/` | Garmin watch app (Connect IQ, Monkey C) | [`HeroSet/CLAUDE.md`](HeroSet/CLAUDE.md) |
| `HeroFace/` | Garmin watch face (Connect IQ, Monkey C) | [`HeroFace/CLAUDE.md`](HeroFace/CLAUDE.md) |
| `DaysToGo/` | Garmin countdown watch face (Connect IQ, Monkey C) | [`DaysToGo/CLAUDE.md`](DaysToGo/CLAUDE.md) |
| `site/` | Public website (Vite + React, prerendered) | [`site/CLAUDE.md`](site/CLAUDE.md) |

`device-test/` is git-ignored scratch for on-watch builds, shared by both
watch projects.

`reports/` holds research and review reports; the sourced notes behind each are in `research_notes/<report title>/`.

Both watch apps share one layout (root `README.md`, "Layout"): `docs/` for
engineering and product docs, `listing/` for everything the store form takes
(`listing/README.md` is the paste-ready copy, form fields in form order; `listing/NOTES.md` holds the why), `CHANGELOG.md` at the app root.
Keep new files in that shape.

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

## House rules everywhere

- Signing key is `~/.garmin-connectiq/keys/developer_key`, outside this repo.
  Never commit it, or any `.der` / `.pem`.
- Git index is often mixed staged/unstaged: don't stage, commit, stash or
  reset unless asked.
- Simulator passing is not device proof. Say so when reporting.
- Behaviour change → update the doc describing it, same session. Durable
  decision → an ADR in that project's `docs/decisions.md`.
- **Every store publication** gets an entry in that app's `CHANGELOG.md`
  (version, upload date, user-facing changes, ADRs) and a paste-ready
  What's New block in that app's `listing/README.md` (the previous block moves
  to `listing/NOTES.md`, and the App Version field is bumped).
