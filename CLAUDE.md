# Verden — CLAUDE.md

Studio monorepo. Three independent projects, one git history.

**Each folder has its own `CLAUDE.md` and `docs/` — those are the source of
truth for that project. Read the one for the folder you are working in.** This
file only covers what spans folders.

| Folder | Project | Its CLAUDE.md |
|---|---|---|
| `HeroSet/` | Garmin watch app (Connect IQ, Monkey C) | [`HeroSet/CLAUDE.md`](HeroSet/CLAUDE.md) |
| `heroFace/` | Garmin watch face (Connect IQ, Monkey C) | [`heroFace/CLAUDE.md`](heroFace/CLAUDE.md) |
| `verden-site/` | Public website (Vite + React, prerendered) | [`verden-site/CLAUDE.md`](verden-site/CLAUDE.md) |

`device-test/` is git-ignored scratch for on-watch builds, shared by both
watch projects.

`reports/` holds market and sales research reports; the sourced notes behind each are in `research_notes/<report title>/`.

## Cross-folder rules

- **The complication contract binds `HeroSet/` and `heroFace/`.** Fixed field
  order, HeroSet ADR-044. A change to it touches both folders and ADR-044 in
  the same commit.
- **User-facing claims live in two places.** A behaviour or data-handling
  change in a watch project → update its pages under
  `verden-site/src/apps/<slug>/` the same session. Store listings link those
  URLs, so **never change or remove a published URL**.
- Relative paths between folders (`../heroFace`, `../verden-site`) still work
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
  What's New block: HeroSet `docs/store-release.md`, HeroFace
  `docs/listing/listing.md`.
