# Launch checklist

Status: 2026-09-18. Short, do-in-order version of `go-to-market.md` status
checkpoint. Tick boxes as you go.

## A. Watch session (FR965, dev build)

**Before install**
- [x] Photo of current HeroSet dashboard (rank, XP, streak, today counts).
- [x] Build: `monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y developer_key`
- [x] Copy `bin/HeroSet.prg` to watch `GARMIN/APPS/` (Mac: OpenMTP). Replace
      file — **don't delete app on watch first** (wipes its data).

**Upgrade check**
- [x] Open HeroSet. XP, rank, streak, today counts match photo.
      Calibration reset = expected. All empty → tell Claude (maybe old app id).

**Counting trials**
- [x] Menu → Calibrate push-ups, sit-ups, squats (10 reps each). Note OK/failed.
- [x] 3 sets × 10 reps per exercise: slow, medium, fast. START → save count
      you **really did**.
- [x] Idle: 60 s still/normal wrist per exercise. Count phantom reps.
- [ ] Whole session ≥30 min in app. Note crash / freeze / counting stops.
- [ ] Heart rate looks like your pulse; calories climb smoothly.
- [ ] Battery % at start: ___ end: ___
- [ ] Menu → Validation Log: copy or photo every page (keeps last 30 only).

**Log it** → tables in [`validation-log.md`](validation-log.md), or send
photos to Claude.

**Pass bar:** median error ≤1 per 10-rep set · ≤1 phantom rep per 60 s idle ·
calibration ≥90% success · no crash. Fail → note how (early/late, doubles,
misses).

**Crash ("IQ!")** → read `GARMIN/APPS/LOGS/CIQ_LOG.YAML` from watch.

**Optional last step** (after copying Validation Log): install store build
(`-f store.jungle`), check menu has Calibrate, no Connect Sync, no Validation
Log; no activity appears in Garmin Connect.

## B. Before upload — don't forget

- [ ] **Screenshots** from simulator running store build: dashboard,
      calibration, live count, manual correction, completion + 500×500 cover.
- [ ] **Host `site/`** (support + privacy) — Netlify/Cloudflare Pages
      drag-and-drop. Say 66 of 67 watches simulator-verified.
- [ ] Rebuild store package: `monkeyc -e -r -f store.jungle -o bin/HeroSet-store.iq -y developer_key`
      Upload only this file (older `.iq` files in `bin/` are stale).
- [ ] Fill upload form from [`store-release.md`](store-release.md); paid
      USD 2.00, no trial, all 67 products (ADR-039).
