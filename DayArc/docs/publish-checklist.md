# When and how to publish DayArc / DayArc Pro

Owner's runbook, both listings. Status of the build itself: [`plan.md`](plan.md) "Implementation
status". What may be claimed: [`release-contract.md`](release-contract.md).

## Never decide alone

The store names; the price and its wording; the visual identity and both launcher icons; any
permission with a privacy cost; any upload to the Connect IQ store; any phone or watch test; a site
deploy; shipping unreviewed machine translations; the night-window default (ADR-010, currently a
placeholder pending owner confirmation).

## Ready to submit when ALL of these are true (both listings, unless noted)

| # | Gate | Passed looks like | Where it stands |
|---|---|---|---|
| 1 | Name cleared | Store search and a trademark search found no conflict | Store search done (ADR-012); trademark search open |
| 2 | Permission confirmed | `ComplicationSubscriber` verified against the Core Topics guide and the permission table, not just the module page | **Done** — ADR-002 |
| 3 | Platform claims verified | Any number shown compared against the watch's own native equivalent, on-device | Open — device-only |
| 4 | Look approved | Owner has seen it in the simulator on a round and a rectangular product, approves | **Direction approved 2026-09-28** (ADR-013) via an iterated, screenshot-verified HTML mockup, **and now built in Monkey C** (2026-09-28), tests/compile sweep green on fr965/approachs50/venusq2/venux1, both jungles. Still open: no screenshot exists of the actual built render (sandboxed dev environment has no attached display — `screencapture` fails with "could not create image from display") and the owner has not seen it |
| 5 | UX checklist passed | Glance-time budget, non-touch/button navigation, empty/error states worded, no settings to fail to save (there are none) | Empty states written (`resources/strings/strings.xml`); glance-time and button-nav need a real device |
| 6 | Always-on/burn-in checked | Heat map + a real always-on night, if the tier includes AMOLED always-on | Drift/dim implemented (TwoSuns's proven pattern), exercised in the simulator (`DayArcRenderTest.idleFrameRendersAtEveryDrift`) at every grid position; real AMOLED night not done |
| 7 | Wear day | One full day on the production build, this app only, both listings | Open — device-only |
| 8 | Full device/fit sweep | Fit sweep prints all-pass on the commit being submitted | Compile sweep: `docs/compatibility.md`. Full render/fit sweep (all 69, both jungles) not run — only fr965, approachs50, venusq2, venux1 rendered so far |
| 9 | Export checked | Exported package's device count matches each manifest's product list | Open |
| 10 | Language decision | Which languages ship | English only, v1 (open owner decision — no other language drafted) |
| 11 | Real assets | Both launcher icons, both covers, both hero images, both screenshot sets — owner supplies | Placeholder icons only (`resources/drawables`, `resources-pro/drawables`); no covers/heroes/screenshots |
| 12 | Listing written and checked | `listing/README.md` and `listing-pro/README.md` checked against `release-contract.md` | Drafted, OWNER fields open — see `listing/NOTES.md`/`listing-pro/NOTES.md` |
| 13 | Site live | Landing/support/privacy pages deployed for both slugs, links open without login | Not started |
| 14 | Price confirmed | Tier and flip rule confirmed | **Done** — ADR-007 |
| 15 | Baseline recorded | Prior apps' download/review numbers recorded for comparison | Open |
| 16 | Tests green | All test targets pass, zero build warnings, on the submitted commit | 11 tests Simple / 13 Pro (`DayArcWindowTest`, `DayArcRenderTest`, `DayArcFormatTest`, `DayArcLayoutTest`), both jungles, 4 spot-check devices — pass, zero warnings past the expected launcher-icon-scaling notice; 69-product × 2-jungle compile sweep 69/69 |
| 17 | Design reviewed | `watch-design-reviewer` returned `disposition: ship`, or every `fix` finding resolved | **Four passes now, across two builds.** Passes 1-3 (2026-09-28, pre-ADR-013 build): see prior row history in `docs/plan.md` "Implementation status" — all resolved. **Pass 4, 2026-09-28 (`watch-design-reviewer`, ADR-013 build)**: `disposition: fix`, 8 findings — a real geometry bug collapsing the clock row on venusq2/venusq2m, Pro morning showing the date twice, an uncoordinated arc/clock overlap risk, an inconsistent empty-state icon rule, a wrong icon-highlight colour (`grid_bike.svg`), an overstated test-coverage doc claim, two dead strings, and two new house-rule violations (`renderActive` over the line-length guideline, two new magic numbers) — all 8 fixed and re-verified (tests/compile sweep re-run clean). No fifth pass run to confirm `disposition: ship` on the fixes themselves; two flagged items (icon-vs-text sizing, arc/clock clearance) still can't be visually confirmed — no display attached in this dev environment — and remain open until a real simulator or device screenshot exists |
| 18 | Night window confirmed | Owner has confirmed or overridden ADR-010's placeholder | Open |

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
