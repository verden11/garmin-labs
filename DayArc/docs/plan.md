# DayArc — implementation plan

## Phase 0 — owner decisions

Decided: two listings not a toggle (ADR-003), fixed-clock windows (ADR-004), pricing (ADR-007),
Simple's calendar exclusion (ADR-008), Pro's density target (ADR-009). Open: night window default
(ADR-010, placeholder pending confirmation), both launcher icons/covers/heroes, both listings' OWNER
fields, languages beyond English, a real trademark search.

## Phase 1 — data and permissions

Done. `DayArcSources` wraps `Complications`/`Weather`; manifest declares `ComplicationSubscriber`
only (ADR-002). No location probe needed — DayArc reads no location at all, unlike TwoSuns.

## Phase 2 — core render

Done for both densities. `DayArcWindow` (pure, tested), `DayArcFields` (compile-time
`:simple`/`:pro` split), `DayArcLayout` (chord-math geometry, reused from TwoSuns's proven pattern),
`DayArcDraw` (hero + gauge + capped grid), `DayArcView`/`DayArcApp` (entry points, no settings).

## Phase 3 — settings

Skipped, deliberately (ADR-011).

## Phase 4 — always-on / AMOLED

Done: `onEnterSleep`/`onExitSleep` + `requiresBurnInProtection` branch, dim time-only idle frame,
9-position burn-in drift — TwoSuns's own proven pattern, reused. Exercised in the simulator
(`DayArcRenderTest.idleFrameRendersAtEveryDrift`); not yet confirmed on a real AMOLED night.

## Phase 5 — device/fit sweep

Compile sweep: both jungles, all 69 products — see `compatibility.md`. Render/fit exercised on 4
representative devices (fr965: default round AMOLED; approachs50: smallest round in the set;
venusq2, venux1: the two rectangular shapes), both densities, via
`DayArcRenderTest.everyWindowRendersWithoutError` in the simulator — not a full 69×2 render sweep.

## Phase 6 — listing and submission

Handed to `watch-pm`. Drafts exist (`listing/`, `listing-pro/`); OWNER fields open.

## Implementation status

**Built, 2026-09-28: ADR-013's icon/colour redesign.** Per-window accent hue, a hero icon beside
each hero value, 14 fixed-hue Pro grid icons (midday/evening only — morning's grid is unchanged) all
sourced from Tabler Icons as pre-coloured bitmap resources, an always-visible date, a window-progress
arc, a hero/grid divider on Pro. Simulator-tested on fr965/approachs50/venusq2/venux1, both jungles,
zero new compiler warnings; the full 69-product compile sweep ran alongside this build (see the
"Built, simulator-only" paragraph below, which now describes the current source, not the pre-ADR-013
build it originally documented). See `DESIGN.md` ("Iconography", "Layout") for the built spec —
including two corrections made during implementation (the icon-font plan replaced by bitmap-only for
all 17 icons; a "7 of 17" label-drop miscount corrected to 9) — and `docs/decisions.md` ADR-013.
**Still open:** real-device evidence, an owner screenshot review of the actual build (mockup
approval ≠ device proof), and a `watch-design-reviewer` re-run against the built version.

**Built, simulator-only:** full render pipeline including ADR-013's icons/arc/divider/date, both
densities, four windows, both build targets compile clean (`-w --typecheck 3`, zero warnings past
the expected launcher-icon-scaling notice). `DayArcWindowTest` (2 tests: `windowFor`'s 10 boundary
cases, `progressFor`'s own boundary/midpoint cases for the arc), `DayArcRenderTest` (6 tests:
every-window render at three arc-progress fractions including the 0.0 boundary that `Dc.drawArc`
would otherwise draw as a full circle, a deliberately low-nonzero gauge value for the corner-radius
edge case, every-drift-position idle render, hero-icon resource-dimension checks, all 14 grid-icon
resource-dimension checks), `DayArcFormatTest` (4 tests), and `DayArcLayoutTest` (2 tests: the
a per-row grid-fit check (`DayArcGrid.cellFits`, rows never widen toward the bezel), plus a synthetic-resolution check that the clock
row's `rowMaxWidth` stays positive across fr965/approachs50/venusq2/venux1's real resolutions
regardless of which device is actually running the test) — 11 tests (Simple) / 13 (Pro,
+`gridIconResourcesLoadAtExpectedSize`), pass on fr965, both jungles. Spot-checked on approachs50
(smallest round), venusq2, venux1 (rectangular) — same test suite, both jungles, all pass. Full
69-product × 2-jungle **compile** sweep: 69/69 pass, both jungles, zero failures
(`bin/compile-sweep-monkey.{simple,pro}.txt`) — compile-only, not a render/fit sweep for all 69.

**A fresh-context review of the ADR-013 build, 2026-09-28, found 8 issues, all fixed:** the clock
row's `rowMaxWidth` went negative on Venu Sq 2/X1 (320x360, 448x486) because `topMargin`/`gridBottom`
measured from the screen's own top/bottom rather than the inscribed circle's actual top/bottom edge
— on a device where height exceeds the shorter side, that let an in-bounds row start above the
circle entirely, and `DayArcText.truncated` doesn't throw on a negative max width, it just renders
one truncated character with no ellipsis (`everyWindowRendersWithoutError` can't catch this class of
bug at all — a new synthetic-resolution test now can, see above); Pro's morning grid duplicated the
date (the new always-visible header line plus the old grid cell) — the grid cell removed; the
window-progress arc's radius/pen-width/top-margin were three independently-picked constants that
overlapped the clock on fr965 (arc at y=36-44, clock spanning y=27-155) — `arcRadius()` is now
*derived* from the clock's own start margin plus an explicit gap, not an independent inset; the
weather-unavailable hero dropped its icon while midday/evening's null branches kept theirs —
unified on "the icon is the window's identity marker, always shown" per midday/evening's existing
behaviour; `grid_bike.svg`'s highlight didn't match the one-step-up-per-channel derivation (was
`#AAAAFF`, should be `#FF55FF`) — fixed, other 5 highlighted icons spot-checked and already correct;
`docs/plan.md` (this file) claimed `DayArcWindowTest` covered `progressFor` before that test existed
— a real test added rather than just correcting the claim; two dead strings (`label_calories`,
`label_temperature`) plus `label_date` (dead once the morning grid cell above was removed) deleted
from `strings.xml`; `renderActive` had grown to ~55 lines against this project's own ≲30-line rule —
split into `drawHeader`/`drawHeroBlock`, and two remaining bare literals (`drawGridCell`'s pixel gap,
the grid label's 55% cap) moved to named `DayArcLayout` constants (`GRID_VALUE_GAP_PERMILLE`,
`GRID_LABEL_MAX_PERMILLE`). Re-verified: full test suite + 69-product compile sweep, both jungles,
all pass (counts above already reflect this). **Not independently re-verified:** the arc/clock
non-overlap fix and hero-icon-vs-text sizing were checked mathematically (the derived formula,
worked through for fr965 and Venu Sq 2's actual numbers) and via the existing render tests, not by
eye — `screencapture` was tried fresh this session and fails with "could not create image from
display" (no display attached in this sandbox, confirmed, not a stale assumption); an owner/device
screenshot review remains open regardless.

**Reviewed and fixed, 2026-09-28** (fresh-context design review + fresh-context code review, both
before any of this reached the owner): temperature/UV rounding truncated toward zero instead of
rounding to nearest (`DayArcFormat`, `.toNumber()` on a `Float`); the stress/Body Battery gauge's
dim-above-threshold tier re-encoded Garmin's own official stress colour-band boundary as a
brightness verdict — removed, both gauges are now single-brightness with no threshold, and the
gauge fill is clamped to `[0, max]`; `DESIGN.md`'s "width-fit against the round chord" claim was
false for every row but the grid — fixed, every centred row now uses the real chord math
(`DayArcLayout.rowMaxWidth`); the grid's label and value were independently truncated against the
whole column width rather than a reserved share each, risking overlap (worst case: the midday
calendar-event cell); `gridCapacity` checked row height only, so it could report cells fitting
while the column width was near zero on some device shape — fixed then, and replaced 2026-09-28 by
per-row chord widths in `DayArcGrid` (cloud review: one narrowest-row width starved every row); `training status`
dropped from Pro's field grid (see `spec.md`); the clock now draws muted rather than full white, so
it no longer competes with the hero read for the first glance. Full findings and independent
verification: this session's transcript, not restated in full here — see `docs/decisions.md`
ADR-006 for the specific factual correction (TwoSuns's Body Battery precedent was misdescribed in
this doc's own first pass).

**A second, independent `/code-review` pass, same day, found 6 more DayArc issues, all fixed:** the
gauge's rounded-corner radius never shrank for a near-zero fill, the exact defect class TwoSuns hit
at low Body Battery readings (`DayArcDraw.drawGauge`, now clamped to half the fill width); the gauge
bar's own width still used a flat margin the chord-math fix never reached (now `rowMaxWidth`,
capped by the original padding); Pro's sunrise/sunset grid cells always printed 24-hour time
regardless of the device's 12/24-hour setting, disagreeing with the main clock on the same screen
(both now share one `DayArcFormat.clockTime`); `DayArcPalette.dim()` was dead code with zero
callers, carrying the same MUTED-collision risk TwoSuns had to guard against — deleted rather than
guarded, since nothing uses it; `DayArcLayout`'s minimum grid-column width was a permille value
recycled from an unrelated, already-dead constant, not measured — now derived from real
`getTextWidthInPixels` metrics of a representative label/value pair; `DayArc/CLAUDE.md` and
`resources/strings/strings.xml` still described the gauge as "two-tier"/"dimmer above a threshold"
after that behaviour was removed — corrected. Also deleted three genuinely dead layout constants
(`LABEL_MAX_PERMILLE`, `HERO_MAX_PERMILLE`, `SUB_MAX_PERMILLE`) found in the same pass.

**Not done, and not to be claimed:**
- No real-device evidence at all — nothing here has run on a wrist. Every "PASSED" above is the
  simulator's own fabricated Complications/Weather data exercising the code path, not device truth.
- Full 69-product ×2-jungle render/fit sweep not run — only compiled, not rendered, for products
  outside the 4 spot-checked devices.
- Real launcher icons, covers, heroes, screenshots — placeholders only.
- Owner has not seen the face render (no screenshot capture tool available in this environment for
  the native simulator; only compile/test-log evidence exists).
- Night window content (ADR-010) is this plan's own default, not an owner decision yet.
- Whether pulse ox/VO2max/weekly distance populate on any real device — the SDK reference has no
  device-support notes for them either way (checked directly); only real hardware
  settles it.
