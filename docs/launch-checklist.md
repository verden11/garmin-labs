# Launch checklist

Status: 2026-09-19. Short, do-in-order version of `go-to-market.md` status
checkpoint. Tick boxes as you go.

## A. Watch session 1 (2026-09-18, calibrated detector) — done

Upgrade check passed, calibration 3/3, counting median error 0.5, idle with
arm movement failed (14/2/5). Results: [`validation-log.md`](validation-log.md).
Led to ADR-040: learning from saved counts, calibration removed.

## A2. Watch session 2 (learning build)

**Install**
- [x] Build: `monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y developer_key`
- [x] Copy to watch `GARMIN/APPS/`, replace file (don't delete app first).
- [x] Open HeroSet: XP, rank, streak, today counts still there. Menu has
      no Calibrate.

**Teach it** (learning needs true counts)
- [x] ~5 normal sets per exercise, ~10 reps each, medium pace. Start **in position**.
      Cut short 2026-09-19 after 4 sets (3 already exact); Measure sets
      teach too, since every reviewed save learns.
      START at the end → picker → set count you **really did** → START
      (never BACK → Save: quick-save doesn't teach).
      Note detected vs real each set: it should get closer set by set.
- [x] Every save (incl. after a long set, e.g. 30+ reps) lands on dashboard
      with the save message: learning runs inside that button press.

**Measure**
- [ ] 3 sets × 10 per exercise: slow, medium, fast. Save real count.
- [ ] Idle: start set in position, hold still 60 s, per exercise. Count
      phantoms, then BACK → Discard.
- [ ] Heart rate looks like your pulse; calories climb smoothly.
- [ ] Battery % at start: ___ end: ___ · session ≥30 min: ___
- [ ] Every screen: no clipped text (gate 3).
- [ ] Menu → Validation Log: photo every page.

**Pass bar:** median error ≤1 per 10-rep set · ≤1 phantom per 60 s still in
position · no crash.

**Crash ("IQ!")** → read `GARMIN/APPS/LOGS/CIQ_LOG.YAML` from watch.

**Store build check** (gate 5, after copying Validation Log)
- [ ] Build: `monkeyc -d fr965 -f store.jungle -o bin/HeroSet-store.prg -y developer_key`
- [x] Copy `bin/HeroSet-store.prg` to `GARMIN/APPS/`. (2026-09-19: sideloaded the
      FR965 `.prg` extracted from `bin/HeroSet-store.iq`, i.e. the uploaded bytes.)
- [x] Menu has no Calibrate, Connect Sync or Validation Log.
- [ ] Do one set; after phone sync no activity appears in Garmin Connect.
- [ ] Copy dev build back if Validation Log still needed.

**After session**
- [ ] Transcribe results into `validation-log.md`, roll summary into
      `release-contract.md`. Gate fails → tune `HeroSetConfig`, repeat A2.

## B. Before upload — don't forget

- [x] **Screenshots** from simulator running store build: dashboard, live count, review, saved
      + 500×500 cover — repo `listing/`.
- [x] **Host Verden site** (`../verden-site`: landing, support, privacy) — live at https://verden.watch
      (Netlify, deploys on push). Says 66 of 67 watches simulator-verified.
- [ ] Rebuild store package: `monkeyc -e -r -f store.jungle -o bin/HeroSet-store.iq -y developer_key`
      Upload only this file (older `.iq` files in `bin/` are stale).
- [ ] Fill upload form from [`store-release.md`](store-release.md); paid
      USD 2.00, no trial, all 67 products (ADR-039).
- [ ] "Signature check failed" again → post on Garmin developer forum with package.

## C. After upload

- [ ] Private beta: small trusted group, multi-day use; watch for crashes,
      listener leaks.
- [ ] Listing live → set `storeUrl` in `../verden-site/src/apps/heroset/app.ts`.
- [ ] Paid launch.
