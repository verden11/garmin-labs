# Verden


Studio monorepo: Garmin Connect IQ apps and watch faces, plus the one website
that serves all of their public pages.

| Folder | What | Status |
|---|---|---|
| [`HeroSet/`](HeroSet) | Watch app — daily push-ups, sit-ups, squats with automatic rep counting, XP, rank and streak. 80 products. | 1.1.0 live; 1.1.1 in review |
| [`HeroFace/`](HeroFace) | Watch face — time-first, in HeroSet's visual language. Works standalone; richer with HeroSet installed. 117 round products. | 1.0.0 live; 1.0.1 in review |
| [`verden-site/`](verden-site) | The public site: studio home plus landing, support and privacy pages per app. Live at **https://verden.watch/** | Live |

Each folder is built and released independently. They share this repo so
cross-cutting changes land in one commit.

## Layout

Both watch apps use the same shape, so the same file is in the same place:

```
HeroSet/ · HeroFace/
  README.md  CLAUDE.md  PRODUCT.md  CHANGELOG.md   one CHANGELOG entry per store publication
  docs/        engineering and product docs (go-to-market, decisions/plan, compatibility, development)
  listing/     the store listing: README.md (paste-ready form answers, description,
               What's New per version), screenshots.md, screens/, src/, images
  source/  resources*/  manifest*.xml  *.jungle
verden-site/   the public website (its own README, CLAUDE.md, DESIGN.md)
reports/       research and review reports; the notes behind each in research_notes/<report title>/
```

## The one coupling

HeroSet publishes today's progress as a **private complication** that HeroFace
reads (HeroSet `docs/decisions.md`, ADR-044). Its value is a fixed field order:

```
v | dayKey | push | sit | squat | rank | rankPct | streak | lastDoneDay | goal
```

Changing that order breaks the other project. A contract change touches both
folders and ADR-044 in the same commit.

## Build

Each project builds on its own; see its `README.md` for the full commands.

```sh
cd HeroSet     && monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y $KEY
cd HeroFace    && monkeyc -d fr965 -f monkey.jungle -o bin/HeroFace.prg -y $KEY
cd verden-site && npm install && npm run dev
```

The Connect IQ signing key lives outside this repo at
`~/.garmin-connectiq/keys/developer_key` and is never committed.

## Hosting

Firebase Hosting (project `verden-watch-87da4`) serves `verden-site/dist`; deploy with
`npm run deploy` inside `verden-site/`.
Details in [`verden-site/CLAUDE.md`](verden-site/CLAUDE.md).
