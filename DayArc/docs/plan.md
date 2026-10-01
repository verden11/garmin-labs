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
`DayArcStack` (whole-stack vertical/width plan) + `DayArcDraw` (draws the plan), `DayArcGrid`, `DayArcArc`, `DayArcView`/`DayArcApp` (entry points; one Accent colour setting, Phase 3).

## Phase 3 — settings

Was skipped (ADR-011); **one setting added 2026-09-28** at the owner's explicit request after first
wear: Accent colour, both listings (ADR-014). Built: `resources/settings/{settings,properties}.xml`,
`DayArcSettings` (guarded read at draw time, clamp, Auto fallback), 18 hero-icon bitmaps
(`tools/gen_hero_icons.py`), the phone page (required) and the watch's own Customize list
(`DayArcApp.getSettingsView` + `DayArcAccentDelegate`, TwoSuns's list-menu pattern). **Not done, and
the actual risk:** neither surface has ever been used on a device — gate 5 in
`docs/publish-checklist.md` is the test.

## Phase 4 — always-on / AMOLED

Done: `onEnterSleep`/`onExitSleep` + `requiresBurnInProtection` branch, dim time-only idle frame,
9-position burn-in drift — TwoSuns's own proven pattern, reused. Exercised in the simulator
(`DayArcRenderTest.idleFrameRendersAtEveryDrift`); not yet confirmed on a real AMOLED night.

## Phase 5 — device/fit sweep

Compile sweep: both jungles, all 69 products — see `compatibility.md`. Render/fit exercised on 4
representative devices (fr965: default round AMOLED; approachs50: 390px, NOT the smallest round —
that is fr255s/fr255sm at 218px MIP, then fenix7s/spro at 240px; venusq2, venux1: the two
rectangular shapes), both densities, per device in the simulator — only 4 of the 69 products have
ever been rendered. **First to run when the simulator is free: fr255s and fenix7s, both jungles**
(`docs/compatibility.md` "Smallest screens").

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

**Built, simulator-only:** full render pipeline including ADR-013's icons/arc/divider/date, the
whole-stack planner and the accent setting, both densities, four windows, both build targets
compile clean (`-w --typecheck 3`, zero warnings past the expected launcher-icon-scaling notice).
Tests: `DayArcWindowTest` (`windowFor` boundaries; `progressFor` for the arc), `DayArcRenderTest`
(every-window render at three arc fractions incl. the 0.0 boundary `Dc.drawArc` would draw as a full
circle, a low gauge fill, every idle drift position, all 18 hero icons load at their size for every
window x accent choice, all 14 grid icons — Pro), `DayArcFormatTest`, `DayArcLayoutTest` (per-row
grid fit; the clock row's chord stays positive across four real resolutions — geometry only, see
below), `DayArcSettingsTest` (garbage/out-of-range values fall back to Auto; every choice maps to a
64-colour-safe hue; Auto is exactly the per-window hues) and `DayArcStackTest` (per-device fit,
below) — **20 tests (Simple) / 22 (Pro)** after the third-review fixes, all passing on fr965, approachs50, venusq2, venux1, fr255s and fenix7s,
both jungles. Full 69-product x 2-jungle **compile** sweep 69/69 both jungles
(`bin/compile-sweep-monkey.{simple,pro}.txt`) — compile-only, not a render/fit sweep for all 69.

**Third review (2026-09-29) fixes — compiled AND run (2026-10-01):** the plan cache now keys on date
presence and replans when a live string is wider than its plan (`DayArcPlanCache`,
`DayArcSizing.covers`, sizing now pixel-based); every live string in the draw path is null-guarded;
`DayArcText.truncated` never returns a bare stub; a plan that fits nowhere ends in TRIM rungs and
`prune()` (never draws across the bottom); a two-line sub is planned only when one line failed and
drawn on one line when the live string fits; named constants replace the key weights, ladder indices
and hue indices; the Customize delegate guards its write; the Auto entry has a hint. **Run result,
simulator only:** `tools/run_tests.sh` on fr255s, fenix7s, fr965, approachs50, venusq2 and venux1,
both jungles: **20 tests (Simple) / 22 (Pro), all pass** on all six. The first run caught one real
bug: `planThatFitsNowhereDrawsOnlyInsideTheLimit` (40x40 Dc) threw "Invalid Value" because
`DayArcArc.penWidth` rounded to 0 and `setPenWidth(0)` throws; floored at 1 (no real screen is that
small). Full 69-product x 2-jungle compile sweep re-run after the fix: 69/69 both jungles.

**After the owner's first wrist photo (FR965, evening, 2026-09-28) — vertical fit:** the photo showed
the sub line as "4...", the arc crowding the clock's top corners and a top-heavy stack. Root cause
confirmed from the REAL render path (not a model): on fr965 evening, "44 of 100", the old stack put
clock y=27 (maxW 196 < the 217px clock, so even the clock drew "22:..."), date 138, label 193, hero
248 (h152), sub y=429 h37 with maxW=-18 -> "4". (The owner's photo put the sub near y=423.) Every one
of the four devices had at least one broken row (approachs50 sub maxW=64 vs 92px; venusq2 hero
availW=-86; venux1 midday-empty sub y=454, maxW=-16). Now `DayArcStack` plans the whole stack and the
same row on fr965 is clock 63 (h81, FONT_NUMBER_MILD), date 148, label 189, hero 230 (h121, HOT),
gauge 355, sub 372 h37, bottom 409 of a usable 427. Arc clearance is the chord math: the clock's box
corners sit at distance 196.6 from centre on fr965 against a clear radius of 204 (arc stroke inner
edge 210 minus a 6px gap). **Departure from the request, and why:** the fit tests use the running
device's own `Dc` and are run once per device via `tools/run_tests.sh`, not synthetic buffered Dcs of
each resolution — a synthetic Dc changes only the SIZE; the fonts always come from the device
actually running the simulator, so a synthetic 320x360 Dc under fr965's fonts gives numbers that are
simply wrong (the earlier `clockRowNeverGoesNegativeAcrossDeviceShapes` therefore proves geometry
only, and its comment now says so). Worst-case strings per window (`100`, `-40°`, `100 of 100`, the
longest empty-state sentence, the longest morning sub `104/-40  100% rain  UV 11` built from the
simulator's real `HIGH_LOW_TEMPERATURE` shape `55/43`, the longest date) all fit, none truncated,
last row inside the usable area, clock corners inside the arc, on all four devices, both jungles.
Tier reached per device (rung 0 = largest; 1 gaps halved; 2 clock MILD; 3 date/label/sub XTINY;
4 hero MEDIUM; 5 hero MILD; 6 clock LARGE; 7 hero label dropped; 8 = + one reserved grid row, gaps
quartered — the last two are the fallbacks):

| Device | Simple: morning / midday data,empty / evening data,empty / night | Pro: morning / midday data,empty / evening data,empty (grid rows drawn) |
|---|---|---|
| fr965 454 | 3 / 2, 4 / 3, 4 / 0 | 5 / 6, 6 / 6, 6 (2 / 3, 2 / 2, 2) |
| approachs50 390 | 1 / 0, 3 / 1, 3 / 0 | 3 / 3, 4 / 4, 4 (2 each) |
| venusq2 320x360 | 4 / 2, 5 / 4, 4 / 0 | **8** / 7, **8** / **8**, **8** (1 / 2, 1 / 1, 2) |
| venux1 448x486 | 2 / 1, 3 / 2, 3 / 0 | 4 / 5, 6 / 6, 6 (2 each) |

Rectangular products (venusq2, venux1) first FAILED at every rung — the inscribed-circle model gave
Venu Sq 2 a 160px radius — so they now use full-width rows and the screen's own bottom edge
(ADR-001 amendment). **Only venusq2 Pro reaches the last fallback:** on a 320x360 screen Pro shows
one grid row (two fields) in morning, midday-empty and evening-data; that is the honest limit of
font-box heights on that screen, not something the planner can conjure space for. On fr965 Pro shows
2-3 grid rows, never the 4+ the mockup implied — the real number-font boxes are much taller than the
mockup's, and the grid competes with a hero that the owner's rule says not to shrink needlessly.
Font boxes are conservative (padding above the digits), so all of this may look smaller than
necessary on the wrist; that is the wrist check's job to tune, not a guess made here.

**Accent colour (ADR-014), both listings:** memory. Every one of the 69 products has the same
watch-face memory limit, 131,072 bytes (`Devices/*/compiler.json` `appTypes`), so there is no
"smaller" device; the render test logs `System.getSystemStats()` after rendering all four windows
and loading icons: Simple `used` 34.0 KB, Pro 39.2 KB on all four devices (a TEST build, larger than
a release build; the simulator's own `totalMemory` of 8.4 MB in test mode is not the watch's limit).
That is roughly 26% / 30% of 128 KB. Release `.prg` sizes: see the export line in the report.

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
- Real-device evidence is ONE photo (the defects above); none of the fixes, and none of ADR-014's
  setting (phone page or watch Customize list), has been seen on a wrist. Every "PASSED" above is the
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
