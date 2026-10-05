# Verden


Studio monorepo: Garmin Connect IQ apps and watch faces, plus the one website
that serves all of their public pages.

| Folder | What | Status |
|---|---|---|
| [`HeroSet/`](HeroSet) | Watch app — daily push-ups, sit-ups, squats with automatic rep counting, XP, rank and streak. 87 products (80 live + the Instinct family). | 1.3.0 live; 1.3.1 in Garmin review (uploaded 2026-10-04) |
| [`HeroFace/`](HeroFace) | Watch face — time-first, in HeroSet's visual language. Works standalone; richer with HeroSet installed. 117 round products live; 124 with the Instinct family. | 1.0.1 live; Pro 1.1.0 and the new Free in Garmin review (uploaded 2026-10-04) |
| [`DaysToGo/`](DaysToGo) | Watch face — days until a date, one big number, counted in whole calendar days. 117 round + 3 rectangular + 7 Instinct products (127). | Live (approved 2026-09-28); Pro 1.1.0 and the new Free in Garmin review (uploaded 2026-10-04) |
| [`TwoSuns/`](TwoSuns) | Watch face — the time, a 24-hour sun ring and the day's Body Battery as a curve; "Two Suns". 72 products (66 round + 3 rectangular + 3 Instinct). | 1.0.0 live; Pro 1.1.0 and the new Free in Garmin review (uploaded 2026-10-04) |
| [`DayArc/`](DayArc) | Watch face pair — content changes on a fixed clock through the day (weather/stress/Body Battery/night); "DayArc" (free) one reading per window, "DayArc Pro" (paid, the $2.50 tier) a denser field grid per window. One codebase, two listings. 72 products (66 round + 3 rectangular + Instinct E 40/45 mm and 3 Solar). | Built and simulator-checked; wrist check on the FR965 from 2026-10-05; one setting (Accent colour); not submitted |
| [`site/`](site) | The public site: studio home plus landing, support and privacy pages per app. Live at **https://verden.watch/** | Live |

Each folder is built and released independently. They share this repo so
cross-cutting changes land in one commit.

## Layout

Every watch project has the same shape, so the same file is in the same place. **One to-do list for everything: [`ROADMAP.md`](ROADMAP.md).**

```
HeroSet/ · HeroFace/ · DaysToGo/ · TwoSuns/ · DayArc/
  README.md  CLAUDE.md  CHANGELOG.md   one CHANGELOG entry per store publication
  PRODUCT.md  DESIGN.md                what it is, how it looks (HeroSet has no DESIGN.md)
  docs/
    README.md                          the index of this folder
    spec.md or PRODUCT/architecture    what the product is and its rules
    decisions.md                       ADRs (why); never deleted, only superseded
    compatibility.md                   products, API levels, memory, evidence per device
    release-contract.md                what may be claimed
    development.md                     commands, tests, how to debug
    status.md                          where things stand, evidence, release gates, upload steps (no open checkboxes: those are in ROADMAP.md)
    archive/                           finished plans, mockups, shelved plans
  listing/ (listing-free/ or listing-pro/ beside it)
    paste.md                           ONLY the copy-and-paste form blocks, in upload-form order
    meta.yaml                          status, version, package, price, limits, assets, open ids (for people and agents)
    NOTES.md                           why each answer is what it is; history
    screenshots.md  screens/  src/     how the images are made; the images
  source/  resources*/  manifest*.xml  *.jungle  tools/
DayArc/    two listings, one codebase: manifest.simple.xml/manifest.pro.xml, monkey.simple.jungle/monkey.pro.jungle,
           resources/ (shared) + resources-pro/ (override), listing/ (DayArc) + listing-pro/ (DayArc Pro)
site/          the public website (its own README, CLAUDE.md, DESIGN.md)
docker/        container images, test and screenshot tooling ([`docker/SIMULATOR.md`](docker/SIMULATOR.md))
tools/         `store_poll.py`: reads our public store listings (no login) and appends a row per listing per day to `research_notes/Free and Pro ladder/poll.csv`
               (`tools/store_poll.py`, ids in `tools/store_poll_ids.txt`; `--selftest` runs offline; downloadCount is a bucket, not revenue)
reports/       research and review reports ([`reports/README.md`](reports/README.md)); the notes behind each in research_notes/<report title>/
```

## The one coupling

HeroSet publishes today's progress as a **private complication** that HeroFace
reads (HeroSet `docs/decisions.md`, [ADR-044](HeroSet/docs/decisions.md#adr-044)). Its value is a fixed field order:

```
v | dayKey | push | sit | squat | rank | rankPct | streak | lastDoneDay | goal
```

Changing that order breaks the other project. A contract change touches both
folders and [ADR-044](HeroSet/docs/decisions.md#adr-044) in the same commit.

## Build

Each project builds on its own; see its `README.md` for the full commands.

```sh
cd HeroSet     && monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y $KEY
cd HeroFace    && monkeyc -d fr965 -f monkey.jungle -o bin/HeroFace.prg -y $KEY
cd DaysToGo    && monkeyc -d fr965 -f monkey.jungle -o bin/DaysToGo.prg -y $KEY
cd TwoSuns     && monkeyc -d fr965 -f monkey.jungle -o bin/TwoSuns.prg -y $KEY
cd DayArc      && monkeyc -d fr965 -f monkey.simple.jungle -o bin/DayArc.prg -y $KEY
cd DayArc      && monkeyc -d fr965 -f monkey.pro.jungle -o bin/DayArcPro.prg -y $KEY
cd site && npm install && npm run dev
```

The Connect IQ signing key lives outside this repo at
`~/.garmin-connectiq/keys/developer_key` and is never committed.

**Tests run in containers by default** (own simulator per agent, reproducible on a new machine): [`docker/README.md`](docker/README.md); how to take simulator screenshots and what is tested automatically: [`docker/SIMULATOR.md`](docker/SIMULATOR.md). `CIQ_DOCKER=0` uses the host simulator.

## Hosting

Firebase Hosting (project `verden-watch-87da4`) serves `site/dist`. A push to `main` that touches `site/**`
deploys it (GitHub Action); `npm run deploy` inside `site/` is the manual fallback.
Details in [`site/CLAUDE.md`](site/CLAUDE.md).
