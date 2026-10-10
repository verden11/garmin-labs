# HeroFace — status

> **Open items live only in the root [`ROADMAP.md`](../../ROADMAP.md).** This file keeps where things stand, the evidence, the release gates and the upload steps. Listing text and metadata: [`../listing/paste.md`](../listing/paste.md) and [`../listing/meta.yaml`](../listing/meta.yaml). Claims: [`release-contract.md`](release-contract.md). Build history: [`archive/plan.md`](archive/plan.md).

**Free 1.1.0 and Pro 1.2.0 uploaded by owner 2026-10-08, in Garmin review** (129 products incl. five rectangles with square design; MOVE out of day ring; one always-on grey; `device-test/upload/HeroFace-*`). Simulator only.

**Where things stand, 2026-10-05.** Live: **1.0.1** (since 2026-09-24, 117 round products). **Uploaded by owner 2026-10-04, in Garmin review:** HeroFace Free 1.0.0 (new app) and HeroFace Pro 1.1.0 (paid app renamed, $2.50 tier), both with Instinct family (ADR-002), 124 products, simulator only. Open work: ROADMAP 5.1, 5.5, 7.12, 10.31. **Added 2026-10-05, not uploaded:** 5 rectangular Venu Sq / Sq 2 / X1 products (129 in both manifests; ring as frame, ADR-005, proposed; simulator only; look needs owner's approval before next upload; `compatibility.md` "Rectangle family").

Status: 2026-10-05 (upload state; Free + Pro block dated 2026-10-01 to 04; rest as of 2026-09-26). (open items moved to root ROADMAP.md, 2026-10-04) History: [`../CHANGELOG.md`](../CHANGELOG.md), `git log`.

Live since 2026-09-22 (Garmin approval), **1.0.1 live since 2026-09-24**: https://apps.garmin.com/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116. Site pages `/heroface/`, `/heroface/support/`, `/heroface/privacy/` live, Get button links to store. Anything failing now = code fix plus listing update, not withdrawal.

## Uploaded 2026-10-04 (HeroFace Free 1.0.0 new app, HeroFace Pro 1.1.0 update), in Garmin review: on approval record the dates, read both stores' device lists, set the site's Free store URL

Free 1.0.0 (new app id), Pro 1.1.0 (existing id, renamed, ROADMAP 5.6). Text as uploaded: `../listing-free/paste.md` and `../listing/paste.md` (sibling store URLs filled; check live Pro text, ROADMAP 10.31); metadata `../listing*/meta.yaml`. Images re-rendered 2026-10-04 (`../listing/screenshots.md`).

| File (absolute path) | Products | Check |
|---|---|---|
| `/Users/mbp/dev/garmin/HeroFace/dist/HeroFaceFree-1.0.0.iq` | 124 | `tools/check_free_package.sh`: OK (keys Mode and Accent only, no "Pro") |
| `/Users/mbp/dev/garmin/HeroFace/dist/HeroFacePro-1.1.0.iq` | 124 | same script: OK (Slot1-3, Seconds, Weather, name "HeroFace Pro") |

**Re-exported 2026-10-04 from commit 99f2dc0, after last code change; `dist/` holds only packages to upload (older exports deleted 2026-10-05).** Built in `verden-ciq-build` container (`docker/run.sh`), checked with project's package script without `--build`; simulator and compile only, **nothing on a wrist**. Files in main checkout's git-ignored `dist/`. Product counts = `<iq:product>` lines in manifest; export holds more part numbers (device variants).

## Checks to run (the procedures; the to-do items are in the root ROADMAP.md)

Order and HeroSet half: [`../../HeroSet/docs/status.md`](../../HeroSet/docs/status.md), "Next session".

- 1. FR965, store install of 1.0.1: face still links to HeroSet; installing HeroSet after face makes link appear within a minute; temperature in °F rounds; stored mode 2 shows Auto.
- 2. Open device evidence in §1: seconds power budget, 96 KB memory headroom, MIP contrast.
- 3. Review W14: re-capture site screenshots at 454 px plus always-on screen; original-Venu heat map (simulator GUI). Always-on shot also goes into listing (decided 2026-09-21 to ship without it); watch's own System → Screenshot may capture awake face rather than sleep screen (inferred, untested).
- 4. Store device list: 69 of 117 products listed (2026-09-25). Missing: fēnix 5/5 Plus/5S/5X, fēnix 6S, fēnix Chronos, FR55, FR245/245M, FR645/645M, FR745, FR935, FR945/945 LTE, vívoactive 3/3M/3 LTE/4/4S, Venu, Venu D, D2 Air, D2 Air X10, D2 Charlie/Delta ×3, Descent MK1/MK2/MK2S, Enduro, Approach S62, MARQ Gen 1 ×8, Legacy Hero/Saga ×4. HeroSet misses same families, so looks store-side: same Garmin question as HeroSet A1.

## Free + Pro pair (approved by the owner 2026-10-04, uploaded 2026-10-04: ADR-001, the Free + Pro ladder)

**Both uploaded 2026-10-04** (F2, F8, F9 done by that upload; names, title, images as in `../listing*/`). Rows marked Open below still open. Builds against `../../reports/Free and Pro ladder execution plan.md` (WP6). Plan gates WP6 on HeroSet/HeroFace 30-day readout and G1; owner approved ladder 2026-10-04 (OD1, OD2; day-45 price-flip rule retired), but names confirmed (2026-10-04), Pro price is $2.50 tier (ADR-004, price: the $2.50 tier for every paid app) and every upload still open, so live paid app and its price unchanged until they upload; new tier set in upload form with that upload.

| # | Gate (Free 1.0.0 and Pro 1.1.0, upload together: Free first as a new app, Pro the same day on the existing id) | State |
|---|---|---|
| F1 | Owner signs off OD1 (the ladder), OD2, OD3 (names), OD4 (Pro price). ADR-001 is Active | **Ladder, names, price tier done 2026-10-04** (price: the $2.50 tier, ADR-004); set in form at upload |
| F2 | Store names and titles: "HeroFace" / "HeroFace Pro" (on-watch AppName too) | **Done 2026-10-04** (names confirmed, uploaded) |
| F3 | Pro's headline: Pro thin today (metric per bar, seconds, temperature). Decide whether to build more (accents, alternate layout) first; Magenta's track contrast fixed 2026-10-04 (ADR-003, `#FFAAFF`, 4.42:1) | **Open** (owner / watch-design-lead) |
| F4 | Launcher icon per tier (still shared placeholder) | **Open** (owner) |
| F5 | Tests on both jungles: `tools/run_tests.sh <device> monkey.jungle` and `... monkey.free.jungle` on fr965, fr55, fenix5s and a 96 KB product; ten-size fit run on both | **Partly done, simulator only:** 24 and 24 PASSED on fr965, fenix5s, fr55 (2026-10-01). **Done 2026-10-04 (container simulator, not device proof):** Free 25/25 PASSED on all ten sizes plus `vivoactive3`, and Free uses 29.7 kB (Pro 30.7 kB) of 91.8 kB on `fenix5s` and `vivoactive3` after face drew (`-r` build, status bar); see `compatibility.md` "Measured 2026-10-04". **Done 2026-10-04:** ten-size fit loop on Pro jungle, 25/25 on 12 products (`compatibility.md`) |
| F6 | Packages exported and checked: `tools/check_free_package.sh --build` | see CHANGELOG evidence |
| F7 | Device check on FR965: Free app installs beside HeroSet and **links to HeroSet's private complication from its own app id** (same developer key); phone shows only Missions and Accent; Pro settings screen unchanged; on-watch names | **Open** (owner; never tried) |
| F8 | `../listing-free/paste.md` filled in store form; screenshots from Free build | **Done 2026-10-04** (uploaded) |
| F9 | Pro's `../listing/` renamed; What's New for 1.1.0; sibling Free URL on its first line | **Done 2026-10-04** (uploaded; check live sibling line, ROADMAP 10.31) |
| F10 | Site (`../../site/src/apps/heroface/`): Free or Pro section, per-tier wording. Do not change a published URL | **Open** (not in this folder) |
| F11 | Exposure-test day-0 and day-30 dates recorded so ratio stays readable (plan WP6 "Done when") | **Open** |

Fix for live 1.0.1 before Garmin approves 1.1.0 would be built from commit before ladder work; after approval, fixes go on current tree.

## Where things stand

| | State |
|---|---|
| Code | Complete for round watches: everyday mode, HeroSet mode, settings, always-on |
| Simulator evidence | Screen fit passes on all 10 screen sizes (208–466 px) on 11 products (2026-09-22: fr965 plus one per size and no-barometer `fr245`); 16/16 tests on six products after 1.0.1; 14 languages id/placeholder-clean; `.iq` builds for all 117 |
| Device evidence | FR965 only, from 2026-09-20: install, render, HeroSet link, reboot survival, full day of wear, always-on, midnight reset. Detail and what is open: §1 |
| Listing | Copy and images in `../listing/`: 5 screens, cover, hero, device icons. Always-on screenshot deferred (item 3) |
| HeroSet side | Publisher built and tested (HeroSet's suite, [`../../HeroSet/CLAUDE.md`](../../HeroSet/CLAUDE.md)); HeroSet 1.1.0+ carries it (§2) |

## 1. Device evidence (gate 1)

Simulator evidence not device evidence; say so when reporting.

- **Always-on burn-in — answered, one watch.** On-wrist and still, sleep screen draws dim time, nothing else, block steps every minute (confirmed with throwaway `BURN_IN_STEP_PX = 24` build, since 4 px below what eye can judge). Off-wrist fully dark, sleep mode blanks it too, so ghosting needed night with sleep mode off: night of 2026-09-21/22 (always-on and seconds on) showed no retention (user report). One night on one AMOLED watch is evidence, not proof, but backs listing's always-on claim. That night ran on old `#555555`; always-on grey is `#5C5C5C` since 2026-10-08 (ADR-006), simulator only, not yet re-checked on a wrist.
- **Partial-update power budget — open.** Seconds redraw through `onPartialUpdate`; on `onPowerBudgetExceeded` face switches seconds off instead of freezing number. Fallback path covered: `disabledSecondsDrawNoSecondsBox` (`source/test/HeroFaceScreenFitTest.mc`) draws, calls `disableSeconds()`, draws again; mutation-verified 2026-09-22. Real overrun cannot be forced, and only source of partial-update cost figure is simulator's watch-face power estimation GUI (`connectiq` and `monkeydo` expose no flag), so measurement needs someone at simulator. **Simulator reading taken 2026-10-04 (not device proof):** Pro with Seconds on in Always-Active mode on `fr955` and `fenix5s`: seconds kept ticking, Watchface Diagnostics dialog read Total 5187 to 6094 / Execution 393 to 843 (no units, no limit shown; microseconds is a guess), private instrumented copy timed 100 updates at 36 ms (`fenix5s`) and 453 ms (`fr955`, noisy emulation) in total, and `onPowerBudgetExceeded` never fired; AMOLED `fr965` has no diagnostics in simulator. Detail in `compatibility.md` "Measured 2026-10-04". Real limit and AMOLED case stay open. Device half: 2026-09-21/22 window ran seconds ON for 20h36m; confirm seconds still ticking at end before calling it evidence.
- **Battery — usable, not publishable.** FR965, seconds on, sleep mode off, always-on on: 66% (2026-09-21 23:24) → 60% (2026-09-22 20:00), 6% over 20h36m, about 0.29 %/h or ~7% a day. Whole-watch drain (any HeroSet use inside it) on one AMOLED watch, so **no battery number goes in listing**. Earlier window not attributable: sleep mode blanked display for 8 h. MIP unverifiable with no MIP watch.
- **MIP daylight contrast** for `MUTED` text and `TRACK` grey — open. Simulator screenshots looked at 2026-10-04 (`fr955`, `fenix7x`, `fenix5s`, `vivoactive3`): `MUTED` text reads clearly, `TRACK` ring and empty bars visible but dim; daylight not simulable.
- **Memory headroom on a 96 KB watch** (fēnix 5S, vívoactive 3) — **simulator reading taken 2026-10-04, device half open.** After face drew, `-r` build, simulator status bar, 2026-10-04: Free 29.7 and Pro 30.7 of 91.8 kB on both (Pro with seconds ticking in low power 30.9 kB), `compatibility.md` "Measured 2026-10-04". Simulator numbers, not device proof.
- **Settings round-trip through Connect — answered 2026-09-26 (user report, FR965, store 1.0.1): goal setting changed in Connect showed on face.** One setting on one watch. Sideloaded face gets no settings entry at all, so untestable before store; build wired (`properties.xml` declares all 7 properties, `settings.xml` binds them; both now in `resources-pro/settings/`). Shipped unverified; store install closed it. Bad-value fallback (`HeroFaceSettings` guards every read with `instanceof` plus catch on `InvalidKeyException`) has no unit test, can only be exercised in simulator's settings editor; `Seconds` power-budget test needs throwaway build with default flipped to `true`.
- **HeroSet link end to end — done** (2026-09-20 on FR965; midnight reset 2026-09-22): private complication found, save updates it within seconds, value survives reboot, hold opens HeroSet, goal field drives ring.

## 2. The HeroSet link (settled)

HeroSet 1.1.0 (live 2026-09-21) carries `HeroSetComplicationPublisher`, so buyer owning both and having updated HeroSet sees HeroSet mode; one still on 1.0.0 sees everyday mode until update, designed fallback. CIQ 4.2+ products only ([ADR-044](../../HeroSet/docs/decisions.md#adr-044)). Sideloading store build over existing install produced no permission prompt (FR965, 2026-09-20); store update not identical to sideload, so watch first update's reviews.

## Known gaps, not blockers

- Rectangle and Instinct-shaped watches unsupported (phase 4, [`archive/plan.md`](archive/plan.md)).
- 15 round watches below CIQ 3.0 out of scope permanently ([`archive/plan.md`](archive/plan.md) decision 1).
- No external beta tester (owner call 2026-09-20): MIP contrast and all-day battery on non-FR965 watch stay unverified, first report may arrive as public review.
- Face collects and transmits nothing, privacy page says exactly that. Any future data collection changes obligation.

Positioning and claims allowed and forbidden moved to [`release-contract.md`](release-contract.md) (2026-10-04).