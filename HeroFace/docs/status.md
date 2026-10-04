# HeroFace — status

> **Open items live only in the root [`ROADMAP.md`](../../ROADMAP.md).** This file keeps where things stand, the evidence, the release gates and the upload steps. Listing text and metadata: [`../listing/paste.md`](../listing/paste.md) and [`../listing/meta.yaml`](../listing/meta.yaml). Claims: [`release-contract.md`](release-contract.md). Build history: [`archive/plan.md`](archive/plan.md).

**Where things stand, 2026-10-04.** Live: **1.0.1** (since 2026-09-24, 117 round products). Built, unreleased and simulator only: the Free + Pro pair (ADR-001) and the Instinct family (ADR-002), 124 products. Open work: ROADMAP M5, 9.x, 11.1.

Status: 2026-10-01 (the Free + Pro pair block added; the rest as of 2026-09-26). (open items moved to the root ROADMAP.md, 2026-10-04) History: [`../CHANGELOG.md`](../CHANGELOG.md), `git log`.

Live since 2026-09-22 (Garmin approval), **1.0.1 live since 2026-09-24**: https://apps.garmin.com/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116. Site pages `/heroface/`, `/heroface/support/`, `/heroface/privacy/` are live and the Get button links to the store. Anything that fails now is a code fix plus a listing update, not a withdrawal.

## Ready to upload (prepared 2026-10-04, NOT uploaded)

Free 1.0.0 (a new app id) and Pro 1.1.0 (the existing id, renamed inside the pending listing-repair submission, ROADMAP 5.6). Text: `../listing-free/paste.md` and `../listing/paste.md` (now the 1.1.0 text; sibling store URL placeholder); metadata `../listing*/meta.yaml`. Images re-rendered 2026-10-04 (`../listing/screenshots.md`).

| File (absolute path) | Products | Check |
|---|---|---|
| `/Users/mbp/dev/garmin/HeroFace/dist/HeroFaceFree-2026-10-04.iq` | 124 | `tools/check_free_package.sh`: OK (keys Mode and Accent only, no "Pro") |
| `/Users/mbp/dev/garmin/HeroFace/dist/HeroFacePro-2026-10-04.iq` | 124 | same script: OK (Slot1-3, Seconds, Weather, name "HeroFace Pro") |

built in the `verden-ciq-build` container (`docker/run.sh`), checked with the project's package script without `--build`; simulator and compile only, **nothing on a wrist**. The files are in the main checkout's git-ignored `dist/` under a dated name (the older exports and `dist/old/` are untouched); the same bytes are `dist/<name>.iq` in the build worktree. Product counts are `<iq:product>` lines in the manifest; the export holds more part numbers (device variants). The owner's decisions (names, prices, icons, uploads, translations) are still open: see ROADMAP.

## Checks to run (the procedures; the to-do items are in the root ROADMAP.md)

Order and the HeroSet half: [`../../HeroSet/docs/status.md`](../../HeroSet/docs/status.md), "Next session".

- 1. FR965, store install of 1.0.1: the face still links to HeroSet; installing HeroSet after the face makes the link appear within a minute; temperature in °F rounds; a stored mode 2 shows Auto.
- 2. The open device evidence in §1: seconds power budget, 96 KB memory headroom, MIP contrast.
- 3. Review W14: re-capture the site screenshots at 454 px plus the always-on screen; original-Venu heat map (simulator GUI). The always-on shot also goes into the listing (decided 2026-09-21 to ship without it); the watch's own System → Screenshot may capture the awake face rather than the sleep screen (inferred, untested).
- 4. Store device list: 69 of 117 products listed (2026-09-25). Missing: fēnix 5/5 Plus/5S/5X, fēnix 6S, fēnix Chronos, FR55, FR245/245M, FR645/645M, FR745, FR935, FR945/945 LTE, vívoactive 3/3M/3 LTE/4/4S, Venu, Venu D, D2 Air, D2 Air X10, D2 Charlie/Delta ×3, Descent MK1/MK2/MK2S, Enduro, Approach S62, MARQ Gen 1 ×8, Legacy Hero/Saga ×4. HeroSet misses the same families, so this looks store-side: same Garmin question as HeroSet A1.

## Free + Pro pair (proposed, UNRELEASED: ADR-001, the Free + Pro ladder)

Nothing in this block is done unless it says so; nothing is uploaded. Builds against `../../reports/Free and Pro ladder execution plan.md` (WP6). The plan gates WP6 on the HeroSet/HeroFace 30-day readout and G1; the owner has not signed off OD1 to OD4, so the live paid app and its price are unchanged and the gates above still govern.

| # | Gate (Free 1.0.0 and Pro 1.1.0, upload together: Free first as a new app, Pro the same day on the existing id) | State |
|---|---|---|
| F1 | Owner signs off OD1 (the ladder), OD2, OD3 (names), OD4 (Pro price). ADR-001 then becomes Active | **Open** (owner) |
| F2 | Store names and titles chosen and searched by eye (placeholders: "HeroFace" / "HeroFace Pro"). The name is also the on-watch AppName: change `resources-free/strings` and `resources-pro/strings` only | **Open** (owner) |
| F3 | Pro's headline: Pro is thin today (the metric per bar, seconds, the temperature). Decide whether to build more (accents, the alternate layout) first; Magenta's 2.84:1 track contrast needs a decision | **Open** (owner / watch-design-lead) |
| F4 | Launcher icon per tier (still the shared placeholder) | **Open** (owner) |
| F5 | Tests on both jungles: `tools/run_tests.sh <device> monkey.jungle` and `... monkey.free.jungle` on fr965, fr55, fenix5s and a 96 KB product; the ten-size fit run on both | **Partly done, simulator only:** 24 and 24 PASSED on fr965, fenix5s, fr55 (2026-10-01). **Open:** the ten-size fit loop on both jungles, the memory view on fenix5s and vivoactive3 |
| F6 | Packages exported and checked: `tools/check_free_package.sh --build` | see CHANGELOG evidence |
| F7 | Device check on the FR965: the Free app installs beside HeroSet and **links to HeroSet's private complication from its own app id** (same developer key); the phone shows only Missions and Accent; the Pro settings screen is unchanged; the on-watch names | **Open** (owner; never tried) |
| F8 | `../listing-free/paste.md` filled in the store form; screenshots taken from the Free build (none exist) | **Open** |
| F9 | Pro's `../listing/` repaired and renamed inside the pending listing-repair submission; What's New for 1.1.0; sibling Free URL on its first line | **Open** (owner) |
| F10 | Site (`../../site/src/apps/heroface/`): a Free or Pro section, per-tier wording. Do not change a published URL | **Open** (not in this folder) |
| F11 | The exposure-test day-0 and day-30 dates recorded so the ratio stays readable (plan WP6 "Done when") | **Open** |

Until F1, build any 1.0.x fix from the commit before the ladder work, not from the current working tree: this tree names the paid app "HeroFace Pro" on the watch and has restructured resources, neither of which the owner has approved for the live app.

## Where things stand

| | State |
|---|---|
| Code | Complete for round watches: everyday mode, HeroSet mode, settings, always-on |
| Simulator evidence | Screen fit passes on all 10 screen sizes (208–466 px) on 11 products (2026-09-22: fr965 plus one per size and the no-barometer `fr245`); 16/16 tests on six products after 1.0.1; 14 languages id/placeholder-clean; `.iq` builds for all 117 |
| Device evidence | FR965 only, from 2026-09-20: install, render, HeroSet link, reboot survival, a full day of wear, always-on, midnight reset. Detail and what is open: §1 |
| Listing | Copy and images in `../listing/`: 5 screens, cover, hero, device icons. Always-on screenshot deferred (item 3) |
| HeroSet side | Publisher built and tested (HeroSet's suite, [`../../HeroSet/CLAUDE.md`](../../HeroSet/CLAUDE.md)); HeroSet 1.1.0+ carries it (§2) |

## 1. Device evidence (gate 1)

Simulator evidence is not device evidence; say so when reporting.

- **Always-on burn-in — answered, one watch.** On-wrist and still, the sleep screen draws a dim time and nothing else and the block steps every minute (confirmed with a throwaway `BURN_IN_STEP_PX = 24` build, since 4 px is below what the eye can judge). Off-wrist it goes fully dark, and sleep mode blanks it too, so ghosting needed a night with sleep mode off: the night of 2026-09-21/22 (always-on and seconds on) showed no retention (user report). One night on one AMOLED watch is evidence, not proof, but it backs the listing's always-on claim.
- **Partial-update power budget — open.** Seconds redraw through `onPartialUpdate`; on `onPowerBudgetExceeded` the face switches seconds off instead of freezing the number. The fallback path is covered: `disabledSecondsDrawNoSecondsBox` (`source/test/HeroFaceScreenFitTest.mc`) draws, calls `disableSeconds()` and draws again; mutation-verified 2026-09-22. A real overrun cannot be forced, and the only source of a partial-update cost figure is the simulator's watch-face power estimation GUI (`connectiq` and `monkeydo` expose no flag), so the measurement needs someone at the simulator. Device half: the 2026-09-21/22 window ran seconds ON for 20h36m; confirm the seconds were still ticking at the end before calling it evidence.
- **Battery — usable, not publishable.** FR965, seconds on, sleep mode off, always-on on: 66% (2026-09-21 23:24) → 60% (2026-09-22 20:00), 6% over 20h36m, about 0.29 %/h or ~7% a day. It is whole-watch drain (any HeroSet use is inside it) on one AMOLED watch, so **no battery number goes in the listing**. An earlier window was not attributable: sleep mode blanked the display for 8 h. MIP is unverifiable with no MIP watch.
- **MIP daylight contrast** for `MUTED` text and the `TRACK` grey — open.
- **Memory headroom on a 96 KB watch** (fēnix 5S, vívoactive 3) — open. Read the simulator's memory view during a real run; the build compiling is not proof.
- **Settings round-trip through Connect — answered 2026-09-26 (user report, FR965, store 1.0.1): a goal setting changed in Connect showed on the face.** One setting on one watch. A sideloaded face gets no settings entry at all, so this was untestable before the store; the build is wired (`properties.xml` declares all 7 properties, `settings.xml` binds them; both now in `resources-pro/settings/`). It shipped unverified; the store install closed it. The bad-value fallback (`HeroFaceSettings` guards every read with `instanceof` plus a catch on `InvalidKeyException`) has no unit test and can only be exercised in the simulator's settings editor; the `Seconds` power-budget test needs a throwaway build with the default flipped to `true`.
- **HeroSet link end to end — done** (2026-09-20 on the FR965; the midnight reset 2026-09-22): the private complication is found, a save updates it within seconds, the value survives a reboot, a hold opens HeroSet, the goal field drives the ring.

## 2. The HeroSet link (settled)

HeroSet 1.1.0 (live 2026-09-21) carries `HeroSetComplicationPublisher`, so a buyer who owns both and has updated HeroSet sees HeroSet mode; one still on 1.0.0 sees everyday mode until they update, the designed fallback. CIQ 4.2+ products only ([ADR-044](../../HeroSet/docs/decisions.md#adr-044)). Sideloading the store build over an existing install produced no permission prompt (FR965, 2026-09-20); a store update is not identical to a sideload, so watch the first update's reviews.

## Known gaps, not blockers

- Rectangle and Instinct-shaped watches are unsupported (phase 4, [`archive/plan.md`](archive/plan.md)).
- The 15 round watches below CIQ 3.0 are out of scope permanently ([`archive/plan.md`](archive/plan.md) decision 1).
- No external beta tester (owner call 2026-09-20): MIP contrast and all-day battery on a non-FR965 watch stay unverified, and the first report may arrive as a public review.
- The face collects and transmits nothing, and the privacy page says exactly that. Any future data collection changes the obligation.

Positioning and the claims allowed and forbidden moved to [`release-contract.md`](release-contract.md) (2026-10-04).
