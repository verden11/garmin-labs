# DayArc / DayArc Pro — status and release runbook

> **Open items live only in the root [`ROADMAP.md`](../../ROADMAP.md).** This file keeps where things stand, the evidence, the release gates and the upload steps. Listing text and metadata: [`../listing/paste.md`](../listing/paste.md) and [`../listing/meta.yaml`](../listing/meta.yaml). Claims: [`release-contract.md`](release-contract.md). Build history: [`archive/plan.md`](archive/plan.md).

**1.1.0 (both listings) uploaded by owner 2026-10-08, in Garmin review** (square design on rectangles; no-weather morning; `#5C5C5C` always-on time; `device-test/upload/DayArc-*`). Simulator only.

**Where things stand, 2026-10-05: LIVE.** DayArc, DayArc Pro 1.0.0 uploaded, approved by Garmin 2026-10-05 (https://apps.garmin.com/apps/9e641dce-3838-4613-a129-55faeb761193, https://apps.garmin.com/apps/b6373747-2569-4a55-86ca-c42914c571fe). Before that: built, simulator tested both densities, 72 products (69 plus Instinct E, 3 Solar, ADR-015 (Instinct family)); real-device evidence so far: owner's FR965 photo 2026-09-28, first look at Pro build 2026-10-03. Final builds (after 2026-10-05 review fixes) on owner's FR965 since 2026-10-05 for all-day wear check (ROADMAP 1.1). Open work: ROADMAP 1.1, 1.5, 1.9, 1.10.

Owner's runbook, both listings. Build status: [`archive/plan.md`](archive/plan.md) "Implementation
status". Claimable: [`release-contract.md`](release-contract.md).

## Uploaded and approved 2026-10-05 (the steps below are kept for the next version)

**Tonight's steps (owner, 2026-10-05), in this order:**
1. Developer dashboard: create **DayArc** app (upload `dist/DayArc-1.0.0.iq`), fill all from `../listing/paste.md` except line 1 of description, save as draft. Copy store URL.
2. Create **DayArc Pro** (upload `dist/DayArcPro-1.0.0.iq`), fill from `../listing-pro/paste.md`, line 1 = DayArc's URL; Monetization: paid, **$2.50 tier**. Save. Copy URL.
3. Back in DayArc: line 1 = `Get DayArc Pro: <DayArc Pro URL>`. Submit DayArc, then DayArc Pro same evening.
4. Images for both: `cover-500.png`, `hero-1440x720.png`, `icon-64-128.png`, `icon-24-128.png`, five **`screens-framed/`** files listed in each `paste.md` (approved 2026-10-05).
5. Tell agent both store URLs: site's `storeUrl`s, "More from Verden" lines follow (ROADMAP 1.10).



Both listings, same day: DayArc (free) first, DayArc Pro second. Text: `../listing/paste.md`, `../listing-pro/paste.md` (line 1's sibling store URL and `owner_approvals` in `../listing*/meta.yaml` first); metadata `../listing*/meta.yaml`.

| File (absolute path) | Products | Check |
|---|---|---|
| `/Users/mbp/dev/garmin/DayArc/dist/DayArc-1.0.0.iq` | 72 | `tools/check_package.sh`: OK (Instinct parts no settings file, 89 others have Accent) |
| `/Users/mbp/dev/garmin/DayArc/dist/DayArcPro-1.0.0.iq` | 72 | same script: OK |

**Re-exported third time 2026-10-05 evening after wrist-photo fixes (12-hour hour without leading zero, calendar "None"; 93/93 both, `check_package.sh` OK); sideload builds in `device-test/` rebuilt with them.** Before that: **re-exported again 2026-10-05 after design critique (bolt hero icon, grey Pro grid icons, ROADMAP 13.19, 13.20; container, 93 OUT OF 93 DEVICES BUILT both, `tools/check_package.sh` OK). Note: wear check (1.1) build sideloaded that morning predates this change.** Earlier: **re-exported 2026-10-05 from commit 4915c61 (code is that of a64233e; later commits tests, docs, listing images), after seventh and ninth design-review passes changed code (ADR-017 (per-screen hero icon sizes): label, gauge track, corner-pill clearance, Pro grid planned against four digits, 1-bit clock one tier down); `dist/` holds only packages to upload (older exports deleted 2026-10-05).** Built in `verden-ciq-build` container (`docker/run.sh`: `monkeyc -e -r -w`, "93 OUT OF 93 DEVICES BUILT" each), checked with `tools/check_package.sh dist/DayArc-1.0.0.iq dist/DayArcPro-1.0.0.iq`: OK, 93 part numbers each, 4 Instinct parts no settings file, 89 with Accent. Simulator and compile only, **nothing on a wrist**: unit suites Simple 23/23, Pro 26/26 on fr965, fr255s, epix2, instincte40mm, instinct3solar45mm; compile sweep 72/72 both jungles. Files in main checkout's git-ignored `dist/`. Product counts = `<iq:product>` lines in manifest; export holds more part numbers (device variants). Five listing screens of both listings, both heroes re-taken from this build (same day; heart-rate stub added to Pro's, `listing-pro/screenshots.md`).

## Never decide alone

Price wording (tier decided: $2.50, ADR-018 (the $2.50 tier)); visual identity, both launcher icons (store names confirmed, 2026-10-04); any
permission with privacy cost; any upload to Connect IQ store; any phone or watch test; site
deploy; shipping unreviewed machine translations; changing night-window default (ADR-010 (night window placeholder); owner kept placeholder night window, 2026-10-04, ROADMAP 1.7).

## Ready to submit when ALL of these are true (both listings, unless noted)

| # | Gate | Passed looks like | Where it stands |
|---|---|---|---|
| 1 | Name cleared | Store search and trademark search found no conflict | **Done**: "DayArc" and "DayArc Pro" confirmed by owner 2026-10-04 (ROADMAP 1.4; store search ADR-012 (store name search)) |
| 2 | Permission confirmed | `ComplicationSubscriber` verified against Core Topics guide and permission table, not just module page | **Done** — ADR-002 (ComplicationSubscriber permission) |
| 3 | Platform claims verified | Any number shown compared against watch's own native equivalent, on-device | Open — device-only |
| 4 | Look approved | Owner has seen it in simulator on round and rectangular product, approves | **Direction approved 2026-09-28** (ADR-013 (visual design direction)) via iterated, screenshot-verified HTML mockup, **now built in Monkey C** (2026-09-28), tests/compile sweep green on fr965/approachs50/venusq2/venux1, both jungles. Still open: no screenshot of actual built render (sandboxed dev environment no attached display — `screencapture` fails with "could not create image from display"); owner has not seen it |
| 5 | UX checklist passed | Glance-time budget, non-touch/button navigation, empty/error states worded, the ONE setting (Accent colour, ADR-014 (accent setting)) saves and applies | Empty states written, checked by `DayArcStackTest`/`DayArcPlanTest` (never a stub) — tests partly written-but-unrun, see `docs/archive/plan.md`; glance-time and button-nav need real device. **Setting testable two ways only; sideloaded `.prg` gets only first:** (1) **watch Customize picker** (works on sideloaded dev build, `../device-test/*.prg`): pick face, Customize, choose colour — then also **select-then-exit**, because `DayArcAccentDelegate` pops ROOT settings view (closes Customize), unlike TwoSuns's list delegate which pops sub-list pushed over root menu; Days To Go's FR965 verification of Customize route does not cover that path; face must redraw in new colour without restart, choice must survive watch restart. (2) **Garmin Connect phone page**: sideloaded/dev-signed app gets NO phone-app settings (`watch-design-kit/knowledge/platform-facts.md` "Settings"; phone-app settings sync only for store-installed apps), so verifiable only AFTER store install. **Listing's "chosen in the Garmin Connect app" claim therefore ships unverified until then** (owner to decide softer wording or hold); until store install, do not claim it works, do not claim on-watch route either without check (1). |
| 6 | Always-on/burn-in checked | Heat map + real always-on night, if tier includes AMOLED always-on | Drift/dim implemented (TwoSuns's proven pattern), exercised in simulator (`DayArcRenderTest.idleFrameRendersAtEveryDrift`) at every grid position; real AMOLED night not done |
| 7 | Wear day | One full day on production build, this app only, both listings | Open — device-only |
| 8 | Full device/fit sweep | Fit sweep prints all-pass on commit being submitted | Compile sweep: `docs/compatibility.md`. Full render/fit sweep (all 69, both jungles) not run — only fr965, approachs50, venusq2, venux1 rendered so far |
| 9 | Export checked | Exported package's device count matches each manifest's product list | Exports built 2026-09-28 (`dist/DayArc.iq` 1.95 MB, `dist/DayArcPro.iq` 2.27 MB, both contain settings resources); each prints "89 OUT OF 89 DEVICES BUILT" for 69-product manifest — same over-report TwoSuns documented (`../TwoSuns/docs/compatibility.md` "The export and 89 devices": `.iq` is 7z archive keyed by internal part numbers). Not yet reconciled with owner; no watch count in listing. Release `.prg` (fr965): Simple 39,740 bytes, Pro 46,924 bytes, against 131,072-byte watch-face limit |
| 10 | Language decision | Which languages ship | English only, v1 (open owner decision — no other language drafted) |
| 11 | Real assets | Both launcher icons, both covers, both hero images, both screenshot sets — owner supplies | Placeholder icons only (`resources/drawables`, `resources-pro/drawables`); no covers/heroes/screenshots |
| 12 | Listing written and checked | `listing/paste.md` and `listing-pro/paste.md` checked against `release-contract.md` | Drafted, OWNER fields open — see `listing/NOTES.md`/`listing-pro/NOTES.md` |
| 13 | Site live | Landing/support/privacy pages deployed for both slugs, links open without login | Not started |
| 14 | Price confirmed | Tier and flip rule confirmed | **Done** — ADR-007 (no-flip rule), ADR-018 (the $2.50 tier, 2026-10-04) |
| 15 | Baseline recorded | Prior apps' download/review numbers recorded for comparison | Open |
| 16 | Tests green | All test targets pass, zero build warnings, on submitted commit | 20 tests Simple / 22 Pro RUN and passing on fr965, approachs50, venusq2, venux1, fr255s, fenix7s, both jungles, simulator only (`DayArcWindowTest`, `DayArcRenderTest`, `DayArcFormatTest`, `DayArcLayoutTest`, `DayArcSettingsTest`, `DayArcStackTest` — last run per real device, worst-case strings, tiers, row ys logged), incl. `DayArcPlanTest` (stub-proof truncation, stale/cached plan, plan cache rebuild, no-fit fallback, live strings through real draw path with no truncation, sub wrap), run 2026-10-01 (run caught and fixed `setPenWidth(0)` throw on 40px Dc) — zero warnings past expected launcher-icon-scaling notice; 69-product × 2-jungle compile sweep 69/69 |
| 17 | Design reviewed | `watch-design-reviewer` returned `disposition: ship`, or every `fix` finding resolved | **Four passes, across two builds.** Passes 1-3 (2026-09-28, pre-ADR-013 (visual design direction) build): see prior row history in `docs/archive/plan.md` "Implementation status" — all resolved. **Pass 4, 2026-09-28 (`watch-design-reviewer`, ADR-013 (visual design direction) build)**: `disposition: fix`, 8 findings — real geometry bug collapsing clock row on venusq2/venusq2m, Pro morning showing date twice, uncoordinated arc/clock overlap risk, inconsistent empty-state icon rule, wrong icon-highlight colour (`grid_bike.svg`), overstated test-coverage doc claim, two dead strings, two new house-rule violations (`renderActive` over line-length guideline, two new magic numbers) — all 8 fixed, re-verified (tests/compile sweep re-run clean). **Then owner's first wrist photo (2026-09-28, FR965 evening) found three defects reviews and simulator could not — sub line as "4...", arc crowding clock corners, top-heavy stack — fixed by `DayArcStack`/`DayArcArc`, re-tested per device; not re-checked on wrist.** No fifth `watch-design-reviewer` pass run to confirm `disposition: ship` on any fixes; two flagged items (icon-vs-text sizing, arc/clock clearance) still can't be visually confirmed — no display attached in this dev environment — open until real simulator or device screenshot exists |
| 18 | Night window confirmed | Owner has confirmed or overridden ADR-010's (night window placeholder) placeholder | Open |

## Wrist evidence, 2026-10-05 (owner's FR965 photos, the morning build `0a48061`, before the bolt and grey icons)

Nine photos, both builds, watch set to 12-hour time:
- **Morning window (08:21, 09:05), Simple and Pro:** draws as built. At 09:05 weather read `9°`, `H 16 / L 13  5% rain  UV 0`; Pro's sunrise/sunset pills and two grid rows (battery 72%, heart 53, steps 717, floors 2) fit. At 08:21 watch had no weather: `--` and "Weather unavailable", Pro grid still drawn: **empty state works on a watch.**
- **Midday window (13:02, 13:03), Simple and Pro:** stress Complication null: `--` and "Stress unavailable right now" (fits, two lines in Simple). Pro grid: calendar, intensity 0, steps 2329, calories 41.
- **Midday with a reading (16:39, Pro):** stress `23` with gauge, window arc about 95% through (09:30 to 17:00: as computed), heart 60, floors 4, steps 2818, calories 45; clock read `04:39` (12-hour bug below).
- **Evening (17:48, 17:49), Pro and Simple:** Body Battery `75` with gauge about 75%, window arc about 13% into 17:00 to 23:00 (as computed); Pro's header heart 53 and steps 3490, grid recovery `0h`, respiration `--` (no reading: empty value works), calories 54, pulse ox 94%. Morning build, so still battery-shell icon and `05:48` (both changed since).
- **Muted clock reads fine** in daylight and in a car (owner photos; no complaint).
- **Fixed from these photos (2026-10-05, simulator-tested):** (1) in 12-hour mode hour was zero-padded, so 13:02 read `01:02` and 18:54 sunset `06:54`, before 07:32 sunrise; now `1:02`, `6:54`, as Garmin's faces (`DayArcFormat.clockTime`). (2) With no calendar event Pro pill cut "No upcoming event" to "No up..."; now "None". Also settles simulator's `00:00`: on watch an empty calendar is null, not `00:00`.
- **Open questions for owner (ROADMAP 13.28, 13.29):** hero `9°` is feels-like value, unlabelled, so read below day's low of 13; morning icon is window's fixed sun-and-cloud, not current condition, so shows even with no weather.
- **Night window in simulator (2026-10-10, simulator only):** real-clock runs on fr965, Pro and Simple, store-like `-r` builds, High Power and Always-On alternating (`docker/soak.sh` with start clock): full Pro stack at 22:58, time and date only at 23:00, 23:03, 23:05; time and date at 04:58, morning window at 05:00, 05:03, 05:05 (Simple same with lighter stack); no errors.
- **Not yet seen on wrist:** night window (23:00 to 05:00, time and date only), tonight's build (bolt icon, grey pills, Feels like, condition icons, these fixes).

## What the owner must eyeball on the wrist next (first-photo fixes + the accent setting)

Sideload `../device-test/DayArc-fr965.prg` and `DayArcPro-fr965.prg` (dev builds, one at a time).
Nothing below seen on a wrist; simulator has no display in this environment.
1. **All four windows on BOTH builds** — owner only seen evening on Simple. Force each window
   (change watch clock, or wait), look at morning (weather + two-line sub), midday
   (stress data AND "Stress unavailable right now" state if reachable), evening, night.
2. **Sub text reads in full** ("44 of 100", empty-state sentences, morning high/low +
   rain + UV over two lines) — never "4...", never a stub.
3. **Arc clears clock** — no arc/digit contact at clock's top corners, every window.
4. **Stack vertically centred**, nothing crammed against bezel.
5. **Pro's grid** — how many rows show per window (2-3 expected on FR965), do they read.
6. **Icon size vs text beside it** — hero icons now come in large and small size per screen (ADR-017 (per-screen hero icon sizes), 2026-10-04: large
   beside HOT digits, small beside MEDIUM/MILD), grid icons still 24 px (DESIGN.md "Iconography"). Judge whether hero
   icon looks level with number on YOUR watch, each window and in Pro (where number falls to smaller tiers), and whether
   redrawn weather glyph (outlined cloud, solid sun, three rays) reads as weather, not blob.
7. **Accent colour, on the WATCH** (only route a sideloaded build has — no phone page for
   dev-signed app): pick face in watch-face list, Customize next to Apply, choose each of
   seven values (do arc, hero value, gauge fill, hero icon follow, does
   night stay grey, do Pro's grid icons keep own colours?). Then **select and exit**: delegate
   closes whole Customize screen on select — check it lands somewhere sensible and
   nothing hangs. Restart watch: choice must survive. Garmin Connect phone page cannot
   be tested from sideloaded build; waits for store install (gate 5).
8. **Icons after pixel-grid change (2026-10-03, ADR-013 (visual design direction) Amendment 4) and per-screen sizes (2026-10-04, ADR-017 (per-screen hero icon sizes))** — grid icons
   24×24 with 2 px strokes; hero icons line icons, stroke 0.12 of height (4 to 11 px, was 2 to 6), two sizes per screen
   (FR965: 90 px beside big digits, 66 px beside smaller; FR255S: 42 and 24). On wrist: (a) are 2 px grid strokes too
   thin or light against 64-colour AMOLED (stairs, steps, run, refresh, sunrise/sunset, thermometer, bars, breath); (b) are
   icon edges crisp, not soft; (c) do 24 px grid rows still fit on smallest round product you own, in Pro; (d) do hero strokes
   read heavy or just level with digits, is Body Battery's blocky shell still recognisable. Any "no" on strokes → change
   `stroke()` in `tools/gen_hero_icons.py`, regenerate (ADR-017 (per-screen hero icon sizes) "Reversed by").
9. Report anything smaller than needed — planner deliberately
   conservative (font boxes carry padding above digits), wrist tunes it.

## Open owner decisions from the 2026-09-28 third review (not resolved here)

(a) **Accent list vs studio roster:** `research_notes/Free and Pro ladder/accent_roster.md` says Sky/Mint/Amber/Pink/Violet/White; built is cyan/green/blue/rose/purple/amber. Ids append-only after first upload, so list must be decided BEFORE first upload. All six offered accents equal a Pro grid-icon category hue (cyan = respiration, amber = thermometer, rose = droplet, green = steps, blue = calendar, purple = stairs) — ADR-014 (accent setting) notes it, unresolved; DESIGN.md lists no reserved colours.
(b) **No written track-contrast rule:** arc fill on `ARC_TRACK` #555555 is 1.94:1 for purple, 2.53 for rose (Auto's own evening hue), 3.05 for blue; gauge fill on MUTED #AAAAAA track about 1.05 for blue — decide a rule, or drop blue/purple.
(c) **Pro hierarchy:** on fr965 Pro hero equals clock (both FONT_NUMBER_MILD, h81) at rung 5, Pro sits at rung 5-6 in every window, venusq2 Pro at rung 7-8 with 1px gaps and hero label dropped (**since 2026-10-04, ADR-017 (per-screen hero icon sizes): label kept, grid shrinks to one row there, and on the Instinct**), Pro's grid shows about 4-6 of 7-10 fields vs ADR-009's (Pro grid density) 8-12 — either change ladder order, or update ADR-009 (Pro grid density), DESIGN.md "Layout" and spec.md.
(d) **Rectangular corners:** rectangular products use full-width rows to ~19px above bottom edge with grid icons near x=6, while TwoSuns keeps round chord there; display corner radii unknown — needs look on Venu Sq 2 / Venu X1, or radius from SDK device definition.
(e) **Night clock jump:** night clock sits at y=148 in active frame but ~182 in AMOLED idle frame, so jumps on wrist-raise — look on wrist.

## Submit

1. Export each `.iq` from exact commit that passed gates above (`docs/development.md`
   "Export" — two separate exports, two separate uploads).
2. Upload at https://apps.garmin.com/developer/upload — attach package, paste each
   listing's fields in form order.
3. Same day: update `CHANGELOG.md` (version, upload date, user-facing changes, ADRs) for whichever
   listing published; check that listing's `README.md` has What's New block and version.
4. Never commit `.iq`/`.prg` build output or any key file.

## If the review rejects it

Fix named item, bump version if package changed, re-submit. Don't change price in
same step. Rejection on one listing doesn't block other.