# Go to market — HeroFace

Status: 2026-09-26. **Only home for open items and blockers.** History: [`../CHANGELOG.md`](../CHANGELOG.md), `git log`.

Live since 2026-09-22 (Garmin approval), **1.0.1 live since 2026-09-24**: https://apps.garmin.com/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116. Site pages `/heroface/`, `/heroface/support/`, `/heroface/privacy/` are live and the Get button links to the store. Anything that fails now is a code fix plus a listing update, not a withdrawal.

## Next session

Order and the HeroSet half: [`../../HeroSet/docs/go-to-market.md`](../../HeroSet/docs/go-to-market.md), "Next session".

- [ ] 1. FR965, store install of 1.0.1: the face still links to HeroSet; installing HeroSet after the face makes the link appear within a minute; temperature in °F rounds; a stored mode 2 shows Auto.
- [ ] 2. The open device evidence in §1: seconds power budget, 96 KB memory headroom, MIP contrast.
- [ ] 3. Review W14: re-capture the site screenshots at 454 px plus the always-on screen; original-Venu heat map (simulator GUI). The always-on shot also goes into the listing (decided 2026-09-21 to ship without it); the watch's own System → Screenshot may capture the awake face rather than the sleep screen (inferred, untested).
- [ ] 4. Store device list: 69 of 117 products listed (2026-09-25). Missing: fēnix 5/5 Plus/5S/5X, fēnix 6S, fēnix Chronos, FR55, FR245/245M, FR645/645M, FR745, FR935, FR945/945 LTE, vívoactive 3/3M/3 LTE/4/4S, Venu, Venu D, D2 Air, D2 Air X10, D2 Charlie/Delta ×3, Descent MK1/MK2/MK2S, Enduro, Approach S62, MARQ Gen 1 ×8, Legacy Hero/Saga ×4. HeroSet misses the same families, so this looks store-side: same Garmin question as HeroSet A1.

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
- **Settings round-trip through Connect — answered 2026-09-26 (user report, FR965, store 1.0.1): a goal setting changed in Connect showed on the face.** One setting on one watch. A sideloaded face gets no settings entry at all, so this was untestable before the store; the build is wired (`resources/settings/properties.xml` declares all 7 properties, `settings.xml` binds them). It shipped unverified; the store install closed it. The bad-value fallback (`HeroFaceSettings` guards every read with `instanceof` plus a catch on `InvalidKeyException`) has no unit test and can only be exercised in the simulator's settings editor; the `Seconds` power-budget test needs a throwaway build with the default flipped to `true`.
- **HeroSet link end to end — done** (2026-09-20 on the FR965; the midnight reset 2026-09-22): the private complication is found, a save updates it within seconds, the value survives a reboot, a hold opens HeroSet, the goal field drives the ring.

## 2. The HeroSet link (settled)

HeroSet 1.1.0 (live 2026-09-21) carries `HeroSetComplicationPublisher`, so a buyer who owns both and has updated HeroSet sees HeroSet mode; one still on 1.0.0 sees everyday mode until they update, the designed fallback. CIQ 4.2+ products only ([ADR-044](../../HeroSet/docs/decisions.md#adr-044)). Sideloading the store build over an existing install produced no permission prompt (FR965, 2026-09-20); a store update is not identical to a sideload, so watch the first update's reviews.

## Known gaps, not blockers

- Rectangle and Instinct-shaped watches are unsupported (phase 4, [`plan.md`](plan.md)).
- The 15 round watches below CIQ 3.0 are out of scope permanently ([`plan.md`](plan.md) decision 1).
- No external beta tester (owner call 2026-09-20): MIP contrast and all-day battery on a non-FR965 watch stay unverified, and the first report may arrive as a public review.
- The face collects and transmits nothing, and the privacy page says exactly that. Any future data collection changes the obligation.

## Positioning

The listing sells a practical everyday face: time first, three daily goals as bars, a goal streak, battery and heart rate, and settings that let each bar show what the wearer cares about. HeroSet gets one line, "shows your HeroSet reps, rank and streak if you have it", because most buyers will not own it. Price USD 2.00 ($1.99 US), the HeroSet tier; Garmin's 48-hour return window is the only trial and the listing says so.

## Claims allowed and forbidden

Allowed: the metric list, the 117 supported watches, "nothing leaves your watch", the HeroSet link on Connect IQ 4.2+ watches, the settings.

Forbidden until measured on a watch: any battery-life number, any always-on claim beyond what the FR965 night of 2026-09-21/22 backs (§1: the face works always-on without burn-in retention on that watch), "works with every Garmin", accuracy claims of any kind, and any review, rating or user count — none exist.
