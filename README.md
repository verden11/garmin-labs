# Verden


Studio monorepo: Garmin Connect IQ apps, watch faces, plus one website serving all public pages.

| Folder | What | Status |
|---|---|---|
| [`HeroSet/`](HeroSet) | Watch app — daily push-ups, sit-ups, squats, automatic rep counting, XP, rank, streak. 87 products (80 live + Instinct family). | 1.3.0 live; 1.3.1 in Garmin review (uploaded 2026-10-04) |
| [`HeroFace/`](HeroFace) | Watch face — time-first, HeroSet visual language. Works standalone; richer with HeroSet installed. 117 round products live; 124 with Instinct family. | 1.0.1 live; Pro 1.1.0 and new Free in Garmin review (uploaded 2026-10-04) |
| [`DaysToGo/`](DaysToGo) | Watch face — days until date, one big number, whole calendar days. 117 round + 3 rectangular + 7 Instinct products (127). | Live (approved 2026-09-28); Pro 1.1.0 and new Free in Garmin review (uploaded 2026-10-04) |
| [`TwoSuns/`](TwoSuns) | Watch face — time, 24-hour sun ring, day's Body Battery as curve; "Two Suns". 72 products (66 round + 3 rectangular + 3 Instinct). | 1.0.0 live; Pro 1.1.0 and new Free in Garmin review (uploaded 2026-10-04) |
| [`DayArc/`](DayArc) | Watch face pair — content changes on fixed clock through day (weather/stress/Body Battery/night); "DayArc" (free) one reading per window, "DayArc Pro" (paid, $2.50 tier) denser field grid per window. One codebase, two listings. 72 products (66 round + 3 rectangular + Instinct E 40/45 mm and 3 Solar). | **Live since 2026-10-05** (both listings approved by Garmin); one setting (Accent colour); wrist check of final build open |
| [`site/`](site) | Public site: studio home + landing, support, privacy pages per app. Live at **https://verden.watch/** | Live |

Each folder built, released independently. Share repo so cross-cutting changes land in one commit.

## Layout

Every watch project same shape, same file same place. **One to-do list for everything: [`ROADMAP.md`](ROADMAP.md).**

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
               (`tools/store_poll.py`, ids in `tools/store_poll_ids.txt`; `--selftest` runs offline; downloadCount is a bucket, not revenue;
               the last two columns are the listing's mostPopular rank on Instinct 3 Solar 45 mm and, free listings only, Instinct 2)
reports/       research and review reports ([`reports/README.md`](reports/README.md)); the notes behind each in research_notes/<report title>/
```

## The one coupling

HeroSet publishes today's progress as **private complication** HeroFace reads (HeroSet `docs/decisions.md`, [ADR-044](HeroSet/docs/decisions.md#adr-044)). Value = fixed field order:

```
v | dayKey | push | sit | squat | rank | rankPct | streak | lastDoneDay | goal
```

Changing order breaks other project. Contract change touches both folders and [ADR-044](HeroSet/docs/decisions.md#adr-044) in same commit.

## Build

Each project builds on own; see its `README.md` for full commands.

```sh
cd HeroSet     && monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y $KEY
cd HeroFace    && monkeyc -d fr965 -f monkey.jungle -o bin/HeroFace.prg -y $KEY
cd DaysToGo    && monkeyc -d fr965 -f monkey.jungle -o bin/DaysToGo.prg -y $KEY
cd TwoSuns     && monkeyc -d fr965 -f monkey.jungle -o bin/TwoSuns.prg -y $KEY
cd DayArc      && monkeyc -d fr965 -f monkey.simple.jungle -o bin/DayArc.prg -y $KEY
cd DayArc      && monkeyc -d fr965 -f monkey.pro.jungle -o bin/DayArcPro.prg -y $KEY
cd site && npm install && npm run dev
```

Connect IQ signing key lives outside repo at
`~/.garmin-connectiq/keys/developer_key`, never committed.

**Tests run in containers by default** (own simulator per agent, reproducible on new machine): [`docker/README.md`](docker/README.md); simulator screenshots + what is tested automatically: [`docker/SIMULATOR.md`](docker/SIMULATOR.md). `CIQ_DOCKER=0` uses host simulator.

## Hosting

Firebase Hosting (project `verden-watch-87da4`) serves `site/dist`. Push to `main` touching `site/**` deploys it (GitHub Action); `npm run deploy` inside `site/` = manual fallback.
Details in [`site/CLAUDE.md`](site/CLAUDE.md).