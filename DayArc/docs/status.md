# DayArc / DayArc Pro — status and release runbook

> **Open items live only in the root [`ROADMAP.md`](../../ROADMAP.md).** This file keeps where things stand, the evidence, the release gates and the upload steps. Listing text and metadata: [`../listing/paste.md`](../listing/paste.md) and [`../listing/meta.yaml`](../listing/meta.yaml). Claims: [`release-contract.md`](release-contract.md). Build history: [`archive/plan.md`](archive/plan.md).

**Where things stand, 2026-10-05.** Never submitted. Built and simulator tested for both densities, 72 products (69 plus the Instinct E and 3 Solar, ADR-015); the real-device evidence so far is the owner's FR965 photo of 2026-09-28 and a first look at the Pro build 2026-10-03. The final builds (after the 2026-10-05 review fixes) are on the owner's FR965 since 2026-10-05 for the all-day wear check (ROADMAP 1.1). Open work: ROADMAP 1.1, 1.5, 1.9, 1.10.

Owner's runbook, both listings. Status of the build itself: [`archive/plan.md`](archive/plan.md) "Implementation
status". What may be claimed: [`release-contract.md`](release-contract.md).

## Ready to upload (prepared 2026-10-04, NOT uploaded)

Both listings, same day: DayArc (free) first, DayArc Pro second. Text: `../listing/paste.md`, `../listing-pro/paste.md` (line 1's sibling store URL and the `owner_approvals` in `../listing*/meta.yaml` first); metadata `../listing*/meta.yaml`.

| File (absolute path) | Products | Check |
|---|---|---|
| `/Users/mbp/dev/garmin/DayArc/dist/DayArc-1.0.0.iq` | 72 | `tools/check_package.sh`: OK (Instinct parts have no settings file, 89 others have Accent) |
| `/Users/mbp/dev/garmin/DayArc/dist/DayArcPro-1.0.0.iq` | 72 | same script: OK |

**Re-exported again 2026-10-05 after the design critique (bolt hero icon, grey Pro grid icons, ROADMAP 13.19, 13.20; container, 93 OUT OF 93 DEVICES BUILT both, `tools/check_package.sh` OK). Note: the wear check (1.1) build sideloaded that morning predates this change.** Earlier: **re-exported 2026-10-05 from commit 4915c61 (the code is that of a64233e; later commits are tests, docs and listing images), after the seventh and ninth design-review passes changed the code (ADR-017: label, gauge track, corner-pill clearance, Pro grid planned against four digits, 1-bit clock one tier down); `dist/` holds only the packages to upload (older exports deleted 2026-10-05).** Built in the `verden-ciq-build` container (`docker/run.sh`: `monkeyc -e -r -w`, "93 OUT OF 93 DEVICES BUILT" for each), checked with `tools/check_package.sh dist/DayArc-1.0.0.iq dist/DayArcPro-1.0.0.iq`: OK, 93 part numbers each, 4 Instinct parts without a settings file, 89 with Accent. Simulator and compile only, **nothing on a wrist**: unit suites Simple 23/23 and Pro 26/26 on fr965, fr255s, epix2, instincte40mm, instinct3solar45mm; compile sweep 72/72 both jungles. The files are in the main checkout's git-ignored `dist/`. Product counts are `<iq:product>` lines in the manifest; the export holds more part numbers (device variants). The five listing screens of both listings and both heroes were re-taken from this build (the same day; a heart-rate stub was added to Pro's, `listing-pro/screenshots.md`).

## Never decide alone

The price wording (the tier itself is decided: $2.50, ADR-018); the visual identity and both launcher icons (the store names are confirmed, 2026-10-04); any
permission with a privacy cost; any upload to the Connect IQ store; any phone or watch test; a site
deploy; shipping unreviewed machine translations; changing the night-window default (ADR-010; the owner kept the
placeholder night window, 2026-10-04, ROADMAP 1.7).

## Ready to submit when ALL of these are true (both listings, unless noted)

| # | Gate | Passed looks like | Where it stands |
|---|---|---|---|
| 1 | Name cleared | Store search and a trademark search found no conflict | **Done**: "DayArc" and "DayArc Pro" confirmed by the owner 2026-10-04 (ROADMAP 1.4; store search ADR-012) |
| 2 | Permission confirmed | `ComplicationSubscriber` verified against the Core Topics guide and the permission table, not just the module page | **Done** — ADR-002 |
| 3 | Platform claims verified | Any number shown compared against the watch's own native equivalent, on-device | Open — device-only |
| 4 | Look approved | Owner has seen it in the simulator on a round and a rectangular product, approves | **Direction approved 2026-09-28** (ADR-013) via an iterated, screenshot-verified HTML mockup, **and now built in Monkey C** (2026-09-28), tests/compile sweep green on fr965/approachs50/venusq2/venux1, both jungles. Still open: no screenshot exists of the actual built render (sandboxed dev environment has no attached display — `screencapture` fails with "could not create image from display") and the owner has not seen it |
| 5 | UX checklist passed | Glance-time budget, non-touch/button navigation, empty/error states worded, the ONE setting (Accent colour, ADR-014) saves and applies | Empty states written and checked by `DayArcStackTest`/`DayArcPlanTest` (never a stub) — those tests are partly written-but-unrun, see `docs/archive/plan.md`; glance-time and button-nav need a real device. **The setting can only be tested in two different ways, and a sideloaded `.prg` gets only the first:** (1) **watch Customize picker** (works on a sideloaded dev build, `../device-test/*.prg`): pick the face, Customize, choose a colour — then also **select-then-exit**, because `DayArcAccentDelegate` pops the ROOT settings view (it closes Customize), unlike TwoSuns's list delegate which pops a sub-list pushed over its root menu; Days To Go's FR965 verification of the Customize route does not cover that path; the face must redraw in the new colour without a restart and the choice must survive a watch restart. (2) **Garmin Connect phone page**: a sideloaded/dev-signed app gets NO phone-app settings (`watch-design-kit/knowledge/platform-facts.md` "Settings"; phone-app settings sync only for store-installed apps), so this can be verified only AFTER a store install. **The listing's "chosen in the Garmin Connect app" claim therefore ships unverified until then** (owner to decide whether to word it more softly or hold it); until a store install, do not claim it works, and do not claim the on-watch route either without check (1). |
| 6 | Always-on/burn-in checked | Heat map + a real always-on night, if the tier includes AMOLED always-on | Drift/dim implemented (TwoSuns's proven pattern), exercised in the simulator (`DayArcRenderTest.idleFrameRendersAtEveryDrift`) at every grid position; real AMOLED night not done |
| 7 | Wear day | One full day on the production build, this app only, both listings | Open — device-only |
| 8 | Full device/fit sweep | Fit sweep prints all-pass on the commit being submitted | Compile sweep: `docs/compatibility.md`. Full render/fit sweep (all 69, both jungles) not run — only fr965, approachs50, venusq2, venux1 rendered so far |
| 9 | Export checked | Exported package's device count matches each manifest's product list | Exports built 2026-09-28 (`dist/DayArc.iq` 1.95 MB, `dist/DayArcPro.iq` 2.27 MB, both contain the settings resources); each prints "89 OUT OF 89 DEVICES BUILT" for a 69-product manifest — the same over-report TwoSuns documented (`../TwoSuns/docs/compatibility.md` "The export and 89 devices": the `.iq` is a 7z archive keyed by internal part numbers). Not yet reconciled with the owner; no watch count goes in the listing. Release `.prg` (fr965): Simple 39,740 bytes, Pro 46,924 bytes, against the 131,072-byte watch-face limit |
| 10 | Language decision | Which languages ship | English only, v1 (open owner decision — no other language drafted) |
| 11 | Real assets | Both launcher icons, both covers, both hero images, both screenshot sets — owner supplies | Placeholder icons only (`resources/drawables`, `resources-pro/drawables`); no covers/heroes/screenshots |
| 12 | Listing written and checked | `listing/paste.md` and `listing-pro/paste.md` checked against `release-contract.md` | Drafted, OWNER fields open — see `listing/NOTES.md`/`listing-pro/NOTES.md` |
| 13 | Site live | Landing/support/privacy pages deployed for both slugs, links open without login | Not started |
| 14 | Price confirmed | Tier and flip rule confirmed | **Done** — ADR-007 (no-flip rule), ADR-018 (the $2.50 tier, 2026-10-04) |
| 15 | Baseline recorded | Prior apps' download/review numbers recorded for comparison | Open |
| 16 | Tests green | All test targets pass, zero build warnings, on the submitted commit | 20 tests Simple / 22 Pro RUN and passing on fr965, approachs50, venusq2, venux1, fr255s, fenix7s, both jungles, simulator only (`DayArcWindowTest`, `DayArcRenderTest`, `DayArcFormatTest`, `DayArcLayoutTest`, `DayArcSettingsTest`, `DayArcStackTest` — the last run per real device, worst-case strings, tiers and row ys logged), incl. `DayArcPlanTest` (stub-proof truncation, stale/cached plan, plan cache rebuild, no-fit fallback, live strings through the real draw path with no truncation, sub wrap), run 2026-10-01 (that run caught and fixed a `setPenWidth(0)` throw on a 40px Dc) — zero warnings past the expected launcher-icon-scaling notice; 69-product × 2-jungle compile sweep 69/69 |
| 17 | Design reviewed | `watch-design-reviewer` returned `disposition: ship`, or every `fix` finding resolved | **Four passes now, across two builds.** Passes 1-3 (2026-09-28, pre-ADR-013 build): see prior row history in `docs/archive/plan.md` "Implementation status" — all resolved. **Pass 4, 2026-09-28 (`watch-design-reviewer`, ADR-013 build)**: `disposition: fix`, 8 findings — a real geometry bug collapsing the clock row on venusq2/venusq2m, Pro morning showing the date twice, an uncoordinated arc/clock overlap risk, an inconsistent empty-state icon rule, a wrong icon-highlight colour (`grid_bike.svg`), an overstated test-coverage doc claim, two dead strings, and two new house-rule violations (`renderActive` over the line-length guideline, two new magic numbers) — all 8 fixed and re-verified (tests/compile sweep re-run clean). **Then the owner's first wrist photo (2026-09-28, FR965 evening) found three defects the reviews and simulator could not — the sub line as "4...", the arc crowding the clock corners, a top-heavy stack — fixed by `DayArcStack`/`DayArcArc` and re-tested per device; not re-checked on the wrist.** No fifth `watch-design-reviewer` pass run to confirm `disposition: ship` on any of the fixes; two flagged items (icon-vs-text sizing, arc/clock clearance) still can't be visually confirmed — no display attached in this dev environment — and remain open until a real simulator or device screenshot exists |
| 18 | Night window confirmed | Owner has confirmed or overridden ADR-010's placeholder | Open |

## What the owner must eyeball on the wrist next (first-photo fixes + the accent setting)

Sideload `../device-test/DayArc-fr965.prg` and `DayArcPro-fr965.prg` (dev builds, one at a time).
Nothing below has been seen on a wrist; the simulator has no display in this environment.
1. **All four windows on BOTH builds** — the owner has only seen evening on Simple. Force each window
   (change the watch clock, or wait) and look at morning (weather + the two-line sub), midday
   (stress data AND the "Stress unavailable right now" state if reachable), evening, night.
2. **The sub text reads in full** ("44 of 100", the empty-state sentences, the morning high/low +
   rain + UV over two lines) — never "4...", never a stub.
3. **The arc clears the clock** — no arc/digit contact at the clock's top corners, in every window.
4. **The stack is vertically centred** and nothing sits crammed against the bezel.
5. **Pro's grid** — how many rows show per window (2-3 expected on FR965), and that they read.
6. **Icon size vs the text beside it** — the hero icons now come in a large and a small size per screen (ADR-017, 2026-10-04: the large
   beside the HOT digits, the small beside MEDIUM/MILD), the grid icons are still 24 px (DESIGN.md "Iconography"). Judge whether the hero
   icon looks level with the number on YOUR watch, in each window and in Pro (where the number falls to the smaller tiers), and whether the
   redrawn weather glyph (outlined cloud, solid sun, three rays) reads as weather and not a blob.
7. **Accent colour, on the WATCH** (the only route a sideloaded build has — there is no phone page for
   a dev-signed app): pick the face in the watch-face list, Customize next to Apply, choose each of
   the seven values (does the arc, the hero value, the gauge fill and the hero icon follow, does
   night stay grey, do Pro's grid icons keep their own colours?). Then **select and exit**: the
   delegate closes the whole Customize screen on select — check that lands somewhere sensible and
   nothing hangs. Restart the watch: the choice must survive. The Garmin Connect phone page cannot
   be tested from a sideloaded build; it waits for a store install (gate 5).
8. **Icons after the pixel-grid change (2026-10-03, ADR-013 Amendment 4) and the per-screen sizes (2026-10-04, ADR-017)** — grid icons are
   24×24 with 2 px strokes; hero icons are line icons with a stroke of 0.12 of their height (4 to 11 px, was 2 to 6), in two sizes per screen
   (FR965: 90 px beside the big digits, 66 px beside the smaller ones; FR255S: 42 and 24). On the wrist: (a) are the 2 px grid strokes too
   thin or too light against the 64-colour AMOLED (stairs, steps, run, refresh, sunrise/sunset, thermometer, bars, breath); (b) are the
   icon edges crisp, not soft; (c) do the 24 px grid rows still fit on the smallest round product you own, in Pro; (d) do the hero strokes
   read heavy or just level with the digits, and is Body Battery's blocky shell still recognisable. Any "no" on the strokes → change
   `stroke()` in `tools/gen_hero_icons.py`, regenerate (ADR-017 "Reversed by").
9. Report anything that looks smaller than it needs to be — the planner is deliberately
   conservative (font boxes carry padding above the digits) and the wrist is what tunes it.

## Open owner decisions from the 2026-09-28 third review (not resolved here)

(a) **Accent list vs the studio roster:** `research_notes/Free and Pro ladder/accent_roster.md` says Sky/Mint/Amber/Pink/Violet/White; built is cyan/green/blue/rose/purple/amber. Ids are append-only after the first upload, so the list must be decided BEFORE the first upload. All six offered accents equal a Pro grid-icon category hue (cyan = respiration, amber = thermometer, rose = droplet, green = steps, blue = calendar, purple = stairs) — ADR-014 notes it, unresolved; DESIGN.md lists no reserved colours.
(b) **No written track-contrast rule:** arc fill on `ARC_TRACK` #555555 is 1.94:1 for purple, 2.53 for rose (Auto's own evening hue), 3.05 for blue; the gauge fill on the MUTED #AAAAAA track is about 1.05 for blue — decide a rule, or drop blue/purple.
(c) **Pro hierarchy:** on fr965 Pro the hero equals the clock (both FONT_NUMBER_MILD, h81) at rung 5, Pro sits at rung 5-6 in every window, venusq2 Pro at rung 7-8 with 1px gaps and the hero label dropped (**since 2026-10-04, ADR-017: the label is kept and the grid shrinks to one row there, and on the Instinct**), and Pro's grid shows about 4-6 of 7-10 fields vs ADR-009's 8-12 — either change the ladder order, or update ADR-009, DESIGN.md "Layout" and spec.md.
(d) **Rectangular corners:** rectangular products use full-width rows to ~19px above the bottom edge with grid icons near x=6, while TwoSuns keeps the round chord there; the display corner radii are unknown — needs a look on a Venu Sq 2 / Venu X1, or the radius from the SDK device definition.
(e) **Night clock jump:** the night clock sits at y=148 in the active frame but ~182 in the AMOLED idle frame, so it jumps on wrist-raise — look on the wrist.

## Submit

1. Export each `.iq` from the exact commit that passed the gates above (`docs/development.md`
   "Export" — two separate exports, two separate uploads).
2. Upload at https://apps.garmin.com/developer/upload — attach the package, then paste each
   listing's fields in form order.
3. Same day: update `CHANGELOG.md` (version, upload date, user-facing changes, ADRs) for whichever
   listing published; check that listing's `README.md` has the What's New block and version.
4. Never commit `.iq`/`.prg` build output or any key file.

## If the review rejects it

Fix the named item, bump the version if the package changed, re-submit. Don't change the price in
the same step. A rejection on one listing doesn't block the other.
