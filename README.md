# Verden

[![Netlify Status](https://api.netlify.com/api/v1/badges/d26d0261-d940-4cf3-bf49-d3a10d635897/deploy-status)](https://app.netlify.com/projects/verden-watch/deploys)

Studio monorepo: Garmin Connect IQ apps and watch faces, plus the one website
that serves all of their public pages.

| Folder | What | Status |
|---|---|---|
| [`HeroSet/`](HeroSet) | Watch app — daily 100 push-ups, sit-ups, squats with automatic rep counting, XP, rank and streak. 67 products. | In Garmin store review |
| [`heroFace/`](heroFace) | Watch face — time-first, in HeroSet's visual language. Works standalone; richer with HeroSet installed. 117 round products. | Pre-submission |
| [`verden-site/`](verden-site) | The public site: studio home plus landing, support and privacy pages per app. Live at **https://verden.watch/** | Live |

Each folder has its own `README.md`, `CLAUDE.md` and `docs/`, and is built and
released independently. They share this repo so cross-cutting changes land in
one commit.

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
cd heroFace    && monkeyc -d fr965 -f monkey.jungle -o bin/HeroFace.prg -y $KEY
cd verden-site && npm install && npm run dev
```

The Connect IQ signing key lives outside this repo at
`~/.garmin-connectiq/keys/developer_key` and is never committed.

## Hosting

Netlify builds `verden-site/` on every push to `main`. Its **base directory**
must stay `verden-site`, which is how `verden-site/netlify.toml` is found.
Details in [`verden-site/CLAUDE.md`](verden-site/CLAUDE.md).
