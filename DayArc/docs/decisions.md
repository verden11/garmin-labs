# DayArc — decisions (ADRs)

One entry per durable decision. Table first for a quick scan, full body below. Status is one of:
Open, Active, Superseded. Two listings, one set of ADRs — a decision that differs between Simple
and Pro says so in its own body.

| # | Decision | Status |
|---|---|---|
| 001 | Device set / API floor | Active |
| 002 | Data source: Complications, not SensorHistory/ActivityMonitor/Communications | Active |
| 003 | Two listings, one codebase, compile-time density flag | Active |
| 004 | Window trigger: fixed clock | Active |
| 005 | UV and pulse ox as bonus fields | Active |
| 006 | No-verdict wording extends to every metric | Active |
| 007 | Price: Simple free, Pro paid at Garmin's second price step, no flip | Active (amended 2026-10-01) |
| 008 | Simple excludes calendar deliberately | Active |
| 009 | Pro accepts kitchen-sink density on purpose | Active |
| 010 | Night window (23:00-5:00) | Open — owner-reversible |
| 011 | No settings surface, either density | Active — reversed for ONE setting (Accent colour) by ADR-014 |
| 012 | Names, app ids and slugs | Open — store-collision checked, no trademark search |
| 013 | Icon system, per-window/per-icon colour, always-visible date, window-progress arc | Active — built; amended after the first wrist photo (vertical stack planner) |
| 014 | One wearer setting: Accent colour | Active — built, simulator-only, never yet tried in the phone app or on a wrist |

## ADR-001: Device set / API floor

**Status:** Active.

**Context:** Every field this face uses (`Toybox.Complications`) needs API 4.2.0. TwoSuns already
ships and was submitted on this exact floor with the same 69-product set.

**Decision:** `minApiLevel="4.2.0"`, TwoSuns ADR-009's 69-product set (66 round, 3 rectangular
AMOLED: Venu Sq 2, Venu Sq 2 Music, Venu X1), for both the Simple and Pro manifest. Round products
are chord-fitted against the inscribed circle (TwoSuns's own layout convention, reused,
`DayArcLayout`). **Amended 2026-09-28 (ADR-013's vertical-fit review):** the three rectangular
products no longer get the same round-centred content — they have no bezel to clip against, so their
rows use the full screen width and the screen's own bottom edge; only the window-progress arc stays
on the inscribed circle. The all-circle shortcut left Venu Sq 2 (320x360) a 160px radius and no font
tier that fit (`DayArcStackTest`).

**Evidence:** Reused verbatim from TwoSuns `manifest.xml`'s product list (its own fit sweep passed
69/69, 2026-09-27, predating some later fixes there — see that project's own compatibility.md for
its current status). DayArc's own compile sweep: `docs/compatibility.md`.

**Reversed by:** A product failing DayArc's own fit sweep (drop or fix it).

## ADR-002: Data source is Complications, not SensorHistory/ActivityMonitor/Communications

**Status:** Active. Corrects the original research report's premise (`reports/Time of day adaptive
watch face.md`), which assumed Body Battery needed `SensorHistory` history and stress needed API
5.0+; both wrong.

**Decision:** Every field in both densities reads through `Toybox.Complications`
(`DayArcSources.complicationValue`/`complicationNumber`/`complicationFloat`/`complicationString`),
except the morning weather read (feels-like temperature, precipitation chance, UV index), which is
`Toybox.Weather.getCurrentConditions()`. Manifest permission: **`ComplicationSubscriber`** only —
confirmed required (not the "no permission" claim this project's own plan doc first made; see
below), confirmed sufficient (Weather needs none; the official permission table lists Ant,
Background, BluetoothLowEnergy, Communications, ComplicationProvider, ComplicationSubscriber, Data
Field Alert, Fit, PersistedContent, Positioning, Sensor, SensorHistory, SensorLogging, UserProfile —
Weather is not on it). No `SensorHistory`, no `Positioning`, no `Communications`.

**Evidence:** Direct browser read (JS-rendered pages, not reachable via plain fetch) of three
primary sources, 2026-09-27/28: the `Toybox.Complications` module page (42-constant `Type` catalog,
confirmed against the SDK docs directly); the Core Topics "Complications" guide, which states
plainly "To subscribe to a complication you need to add the ComplicationSubscriber permission to
your manifest file" and documents `getComplication()` throwing `ComplicationNotFoundException`
(not returning null) when the complication itself is unsupported; the Core Topics "Manifest File
and Permissions" guide's permission table, confirmed Weather absent from it. Corroborated by three
independent Garmin forum threads reporting the exact same missing-permission error. TwoSuns's own
`manifest.xml` already declares `ComplicationSubscriber` for the same reason — this project's own
research just checked the wrong page on the first pass (the module overview has no permission
note; the Core Topics guide does).

**Correction, recorded plainly:** this plan's own first pass ("Checked since the last pass" in
`reports/DayArc v1 scope and plan.md`) claimed Complications needs zero permission. Wrong — see
above. Fixed in that report and here before it reached spec/listing copy.

**Reversed by:** A future SDK version moving a used field's floor above 4.2.0/`ComplicationSubscriber`'s
own 4.1.0, or adding a permission to `Toybox.Weather`.

## ADR-003: Two listings, one codebase, compile-time density flag

**Status:** Active.

**Context:** Settings-not-saving is this platform's single most-upvoted, best-documented failure
mode (8.4% of low-star reviews, this studio's own market research). A runtime density toggle would
put the mode switch on the platform's weakest spot.

**Decision:** Two separate store listings (DayArc, DayArc Pro), no in-app toggle, no density setting
(ADR-011 removed the settings surface entirely; ADR-014 later added back exactly one — Accent colour
— and density stays compile-time). One shared `source/`, split at build time via Monkey C's `excludeAnnotations`
jungle mechanism: `monkey.simple.jungle` (`base.excludeAnnotations = pro`) and `monkey.pro.jungle`
(`base.excludeAnnotations = simple`), each with its own `manifest.simple.xml`/`manifest.pro.xml`
(separate app ids, never changing once published) and its own `resources`/`resources-pro` override
for `AppName` and the launcher icon. `DayArcFields.forWindow`/`cellsFor`/the per-window cell
builders are the only annotated code; everything else compiles into both.

**Evidence:** Both jungles compile clean (`monkeyc -w --typecheck 3`, fr965, 2026-09-28) and both
pass the render-exercise tests in the simulator (`tools/run_tests.sh`), confirming the annotation
split actually takes effect for each target, not just that each jungle file parses.

**Reversed by:** The owner deciding a single-listing toggle is worth the settings-persistence risk
after all.

## ADR-004: Window trigger is a fixed clock, not sunrise/sunset-relative

**Status:** Active.

**Decision:** Morning 5:00–9:30, midday 9:30–17:00, evening 17:00–23:00, night 23:00–5:00
(ADR-010). Half-open intervals, same boundaries in both densities. Sun times are morning content
only (via the current-weather/UV read), never a window trigger.

**Why:** Routine (when someone actually checks the weather, checks stress, checks their battery
for the evening) tracks the clock, not the sun; a sun-relative trigger also reintroduces the
edge-case cost (polar day/night, TwoSuns's own sun-ring complexity) for no benefit here.

**Evidence:** Owner decision, 2026-09-27 (`reports/DayArc v1 scope and plan.md`). Pure function
`DayArcWindow.windowFor`, boundary-tested (`DayArcWindowTest.mc`, all 10 named boundary minutes,
passes in the simulator).

**Reversed by:** The owner.

## ADR-005: UV and pulse ox are bonus fields, never baseline

**Status:** Active.

**Decision:** `CurrentConditions.uvIndex` (needs API 5.1.0, confirmed above the 4.2.0 device floor)
and `Complications.COMPLICATION_TYPE_PULSE_OX` (no documented device-support list at all) are
graceful-hide bonus fields: shown when present (`has :uvIndex` / a non-null complication value),
silently absent otherwise, never a baseline read either density depends on.

**Evidence:** Direct read of `CurrentConditions`/`HourlyForecast` API docs (uvIndex gated at
5.1.0 on both — a correction against an earlier, wrong claim that it was within the 4.2.0 floor,
caught before it reached this plan). Pulse ox: the SDK reference's own `Type` catalog entry has no
device-support note either way — checked directly, not assumed.

**Reversed by:** A device probe showing either field behaves worse than "silently absent" (e.g. a
stale rather than null value) — would need its own guard, not just `has`.

## ADR-006: No-verdict wording extends to every metric this face shows

**Status:** Active. Extends TwoSuns ADR-008 beyond Body Battery.

**Decision:** No metric on this face — Body Battery, stress, or anything else — is ever shown with
a mood word, an emoji, a threshold word ("good", "low", "rest", "tired", "draining"), or a
red/amber/green colour scheme. Stress and Body Battery both draw as a number plus a neutral,
**single-brightness** gauge (`DayArcDraw.drawGauge`) — one hue, one fill level, no threshold tier at
all. `COMPLICATION_TYPE_TRAINING_STATUS` is dropped from Pro's field grid entirely (was included at
first pass, then cut) because it's a raw Garmin-authored string this app can't filter, and Garmin's
own training-status vocabulary includes words sharing this rule's own banned root ("draining").

**Corrected, 2026-09-28 (watch-design-reviewer, before this reached the owner):** the first-pass
version of this ADR claimed the gauge used a two-tier dim-above-threshold fill, described as "the
same brightness-only trick TwoSuns ADR-008's amendment already validated for Body Battery," and
claimed "Body Battery has no threshold split at all (TwoSuns ADR-008: brightness only, no band)."
Both wrong: (1) TwoSuns's Body Battery *does* dim below a threshold (`BATTERY_LOW_THRESHOLD = 30`,
tested by `TwoSunsReadingsTest.batteryAccentForDimsOnlyBelowTheThreshold`) — this doc misdescribed
its own cited precedent; (2) DayArc's stress threshold (25) was set to exactly Garmin's own official
"rest"/"draining" band boundary (`knowledge/health-science.md`), which re-encodes a documented
colour verdict as a brightness verdict — the opposite of what this ADR requires. Fixed by removing
the threshold tier entirely rather than trying to justify or re-tune it: both gauges are now a
single fill level, no dim tier, for either metric. This is a deliberate departure from TwoSuns's own
Body Battery treatment (TwoSuns's threshold is an arbitrary "low charge" cue with no tie to an
official verdict banding; DayArc's would have inherited one, so DayArc doesn't replicate it).

**Why:** Garmin's own Body Battery copy models a low day in explicitly neutral language; its stress
page repeatedly declines to say why a reading is high or low. Reviewers of mood-overlay faces
(Body Battery/sun-face research) asked, repeatedly, to turn the mood off.

**Evidence:** `knowledge/health-science.md` (Garmin's own official pages, direct browser read);
`TwoSuns/docs/decisions.md` ADR-008 and `TwoSuns/source/TwoSunsReadings.mc` (re-read directly to
correct the misstatement above, not taken from memory this time).

**Reversed by:** The owner, or a real-device screenshot showing the gauge reading as a verdict
despite the single-hue rule.

## ADR-007: Price — Simple free, Pro paid (Garmin's second price step), no flip-to-free

**Status:** Active.

**Decision:** Simple is free at launch and stays free (no flip rule, nothing to define). Pro is
$1.99 and never flips to free — a deliberate break from the DaysToGo/TwoSuns 45-day
flip-to-free-once rule.

**Why:** That rule exists to keep a reversible escape hatch on a single paid listing when there is
no free alternative. Here, Simple already covers free reach, so Pro can hold its price indefinitely
without needing its own escape hatch.

**Evidence:** Owner decision, 2026-09-27.

**Amended 2026-10-01 (owner):** the price is **the second step of Garmin's price tiers** (the first is $2.00, then every $0.25; so $2.25 in the US store, as Two Suns shows), not $1.99. **No price number appears on the website or in the store text**: Garmin converts each tier into other currencies on its own table (the $2.00 tier shows $1.99 in the US but 2,49 € in the euro store), and a fixed US figure beside a different local one is confusing. Set the tier in the Garmin dashboard; the site and listing say "paid" only.

**Reversed by:** The owner.

## ADR-008: Simple excludes calendar deliberately

**Status:** Active.

**Decision:** `COMPLICATION_TYPE_CALENDAR_EVENTS` is Pro-exclusive. Simple's midday window stays
stress-band-only.

**Why:** Simple's whole reason to exist is the one-reading-per-window discipline. Adding a second
native-and-free field back in just because it's cheap is the same "add it because it's available"
pattern this project already rejected for sleep score — recorded here so it isn't "rediscovered"
and re-added later the same way.

**Evidence:** Owner decision, 2026-09-27, confirming the studio's own recommended default
("stress band" over "next event" for Simple's midday precedence).

**Reversed by:** The owner.

## ADR-009: Pro accepts kitchen-sink density on purpose

**Status:** Active.

**Decision:** Pro targets 8–12 fields per window (hero + a capped secondary grid,
`DayArcGrid` measures how many rows actually fit per device, each on its own chord width, rather than
assuming a fixed count), a deliberate departure from this project's own "one focal read" market research (median 4
complications per face, kitchen-sink outliers at 16–17). `watch-design-lead` still holds a layout
hierarchy at this density: one hero read, first and largest, in every Pro window; the grid never
competes with it for the first glance.

**Why:** Pro's entire reason to exist is serving the segment that wants that density — matching
what the top-downloaded/top-starred designs on Watchface Builder for Garmin actually show,
corroborating this project's own 282-of-1,378-faces dashboard finding as a market-taste signal, not
a craft recommendation. Simple carries the craft-bar position instead.

**Evidence:** `reports/DayArc v1 scope and plan.md` ("What the market actually rewards..."), owner
decision 2026-09-27 ("go denser, closer to market norm").

**Reversed by:** The owner, or a device fit sweep showing the grid regularly collapses to under 4
cells on the smallest screens in the device set (at which point Pro's density claim in the listing
would need rewording).

## ADR-010: Night window (23:00–5:00)

**Status:** Open — owner-reversible.

**Context:** The owner's three locked windows (ADR-004) cover 18 of 24 hours. A watch face renders
all 24; the idle/low-power template is a display state, not a time window, so it doesn't fill the
gap on its own.

**Decision:** A fourth window, night (23:00–5:00), showing time and date only — no health field, no
hero read, in either density. Even Pro doesn't add a field here: a data-rich night view fights its
own purpose. Distinct from AMOLED always-on sleep (`DayArcDraw.renderIdle`, ADR from TwoSuns's own
burn-in pattern): night is a normal-brightness *active* window; sleep is the separate dim/drift
state layered on top of whichever window is current, night included.

**Why:** The most restrained available content for the one stretch of the day with no natural
"check this" reason, picked as a default rather than left undefined.

**Evidence:** None — a default, not a research finding. Flagged for the owner to confirm or
override.

**Reversed by:** The owner.

## ADR-011: No settings surface, either density

**Status:** Active — **reversed for ONE setting (Accent colour) by ADR-014, 2026-09-28.** Everything
below still holds for every other choice: window boundaries, field lists, density.

**Decision:** No `settings.xml`/`properties.xml`, no on-watch `getSettingsView()`/Customize menu,
for either listing, v1. Every remaining choice (window boundaries, field lists, colours) is a
build-time decision (ADR-003, ADR-004), not a runtime one.

**Why:** The original ask included "customizations." ADR-003 already removes the one customization
point most requested (density) by splitting it into two listings. Adding any further settings
surface back in for a lesser choice would reintroduce the exact failure class (settings not saving)
ADR-003 exists to avoid, only partially instead of not at all.

**Evidence:** `knowledge/platform-facts.md` "UX" (8.4% of low-star reviews, most-upvoted single
complaint in that corpus is a settings-persistence failure).

**Reversed by:** The owner, if a future version needs a real per-user choice (e.g. metric/statute
override — though `DayArcFormat` already reads the device's own system units automatically, so
this specific case shouldn't need one). **Partly reversed, 2026-09-28, by ADR-014** (the owner asked
for an accent colour after first wearing it): exactly one list setting, with the persistence
mitigations that decision records.

## ADR-012: Names, app ids and slugs

**Status:** Open — store-collision and general web checked; no registered-trademark search done.

**Decision:** **DayArc** (Simple), **DayArc Pro** (Pro). App ids: `56a7298c-dcbf-41ff-b013-9a073a59d2dd`
(Simple), `cc86c6b6-9a5c-4908-9056-165ff4b81982` (Pro) — never change once published. Site slugs
still open (see `docs/status.md`).

**Evidence:** `apps.garmin.com` search for "DayArc" (985 fuzzy results) and "DayArc Pro" (996 fuzzy
results), no exact title match in either; general web scan found one unrelated company ("Day Arc
Environmental Systems," HVAC, different industry/class), no software product named DayArc.

**Reversed by:** A registered-trademark finding, if the owner runs a real USPTO/legal search before
submission.

## ADR-013: Icon system, per-window and per-icon colour, always-visible date, window-progress arc

**Status:** Built, 2026-09-28 (was "approved direction, not yet built" earlier the same day).
Simulator-tested on fr965/approachs50/venusq2/venux1, both jungles, plus the full 69-product compile
sweep — see `docs/archive/plan.md`. No real-device evidence and no owner screenshot review of the built
version yet; `docs/status.md` gate 4 stays open for that.

**Decision:** Reverses the "none in v1" iconography stance and the single-accent-hue palette this
project shipped with. Full detail lives in `DESIGN.md` ("Iconography", "Layout"); summarized here:

1. **Accent hue per window**, not one hue for the whole face: morning `#FFAA00`, midday `#55FFFF`
   (unchanged), evening `#FF55AA`, night stays hueless. Still never per-*value* — ADR-006's no-verdict
   rule is unchanged, this only lets the identity colour change with context.
2. **A hero icon per window**, one glyph beside the hero value, same hue as that window's accent.
3. **14 Pro-grid icons, each a fixed hue by icon type forever** (heart always red, flame always
   orange...) — an extension of ADR-006's category-not-value colour rule one level down, not a new
   exception to it.
4. **Date shown in every window**, not just night. Does not reopen ADR-011 (no settings surface) —
   there is no toggle, it's just always there.
5. **A thin window-progress arc** across the top of the circle in Simple/Pro's active windows,
   showing progress through the *current* window only — deliberately not TwoSuns's full 24h ring.
6. **A 1px divider on Pro** between the hero block and the grid, so a now-colourful grid still reads
   as secondary to a clearly primary clock/date/hero.
7. Icons sourced from **Tabler Icons** (MIT licence), real paths recoloured, not drawn from scratch;
   9 of 17 grid-field text labels dropped where the icon alone already reads (HR, floors, steps,
   calories, notifications, temperature — HR/steps/calories repeat across both windows, corrected
   2026-09-28 from an earlier miscount of 7 in `DESIGN.md`'s first pass). Icons and this drop-label
   treatment apply to **midday and evening only** — morning's Pro grid is unchanged, per the owner's
   own request naming those two windows specifically.

**Why:** Owner feedback across several rounds: the shipped look was "boring and far too plain,"
needed "proper svg icons, colors... be more daring," then later "great existing SVGs... rather than
creating from scratch." Each round's direction was mocked up (an HTML/SVG "Design" canvas artifact,
not source code) and screenshot-verified in a real browser before the next round — that verification
step is what caught a real bug (the Pro grid overflowing its own circle: last row clipped, side text
truncated by the round mask) that reading the markup alone had missed twice.

**Evidence:** Owner-directed iteration, 2026-09-28, this session. Research commissioned mid-session
(`research_notes/DayArc icon and time-of-day color redesign/icon_color_precedent.md`) found: Connect
IQ's community-converged icon technique is a tintable icon font (`dc.drawText` + `setColor`), not
`drawBitmap2`'s `:tintColor` (confirmed FR165/165m bug, real syntax trap); Meteocons/Material
Symbols/SF Symbols all ship a dedicated small-size line/outline variant separate from their
filled/illustrative one; time-of-day colour shifts on icons/backgrounds have real precedent (Apple
Solar Dial, a "Colors Scheduler" third-party Wear OS face) distinct from the banned value-verdict
pattern (a real example found: a Pixel Watch face mapping HR zones to a mood-ring gradient, liked by
its own creator — evidence the banned pattern is a real temptation, not a strawman).

**Implementation note, corrected during the build:** the direction-stage plan (above, superseded)
called for an icon font for the 3 hero icons and bitmaps for the 14 grid icons. Building it found
each window has exactly one hero (confirmed by reading `DayArcFields.heroFor`), so the hero icon's
hue is just as permanently fixed as a grid icon's and never needs runtime tinting either. All 17
icons are built the same way — pre-coloured, fixed-pixel SVG `<bitmap>` resources, drawn with plain
`dc.drawBitmap`, no `:tintColor`/`drawBitmap2` at all — which sidesteps the FR165/165m tint bug by
construction rather than by careful use of it. Trade-off: none of the 17 icons scale with screen
size (plain `dc.drawBitmap` doesn't scale); see `DESIGN.md` "Iconography" for the full note.

**Reversed by:** The owner, once shown the real build; or a review finding a craft violation. A
fresh-context review already ran once against the built version, 2026-09-28, and found 8 issues (a
real geometry bug on Venu Sq 2/X1, a duplicated date cell, an arc/clock overlap, an inconsistent
empty-state icon, a wrong icon highlight colour, a doc claim ahead of its test, two dead strings, and
a house-rule function-length violation) — all fixed, see `docs/archive/plan.md`. `watch-design-reviewer`
itself (the craft-focused agent, distinct from this fix-finding review) has still not run against
the built version.

**Amended 2026-09-28, after the owner's first on-wrist photo (FR965, evening window, 22:35, the
first real-device evidence this project has):** the simulator tests could not see three defects.
(1) The bottom sub line, which should read "44 of 100", drew as "4...": rows stacked top-down with
fonts picked per row by WIDTH only and nothing budgeted total HEIGHT against the display, so the sub
row landed at y=429 on fr965 (the simulator's own number; the owner's photo showed roughly y=423) with
a chord of -18px, and `DayArcText.truncated` collapsed it to one character and an ellipsis. (2) The
arc crowded the clock digits' top corners: the arc curves DOWN toward the sides, so the corners, not
the apex the first clearance derivation used, are where it collides. (3) The whole stack was
top-heavy. Fix, all in the layout, none of it a visual redesign: `DayArcStack` plans the WHOLE stack
by measured dry run — vertically centred, tighter gaps first, then the clock, the small text and the
hero last — and `DayArcDraw` draws exactly that plan; rows are fitted against fixed worst-case
strings so tiers never flicker between readings; the arc sits at a fixed radius near the bezel and
every row up in its band is fitted against the arc's inner edge (`DayArcArc.rowMaxWidth`), so
"fits its row" also means "clears the arc"; a sub line too long for its row wraps to two lines
(never cut to a stub) rather than shrinking the hero; rectangular products get full-width rows
(ADR-001 amendment). **Hardened after the third review, 2026-09-29:** the plan cache also keys on
the date and replans when a live string is wider than its plan; the draw path null-guards every live
string; a plan that fits nowhere falls to TRIM rungs and then drops any row that would cross the
bottom, so it is always safe to draw. Details and per-device numbers: `DESIGN.md` "Layout", `docs/archive/plan.md`.

**Amendment, 2026-10-01 (owner, after a simulator screenshot of Pro evening on the FR965; simulator only, not a wrist):**
the grid is now **centred pairs of compact cells** (left cell ends at the gutter, right starts after it, a lone cell is
centred; a 4%-of-width gutter between columns; a cell's label gets what its value does not need; an icon-only cell's value sits
beside its icon), and **the first two icon-only fields move to the upper corners beside the date** (`DayArcCorners`), in room
the clock rows leave free — drawn only if they fit the arc-aware chord beside the date's own width, otherwise they stay in the
grid. On an FR965 that is six fields instead of four. Grid labels are shortened to about four letters (Rec, Resp, Int, Next,
Run, Bike, SpO2, VO2, Rise, Set, Batt): a cell is ~150 px wide and an XTINY letter ~16 px. Mock approved by the owner
("lets go for it - adjust if needed later"). Tests: `DayArcCornersTest` plus the existing suites, fr965, approachs50 and venusq2
(Pro) and fr965 (Simple), simulator only. Per-device corner counts in the test log: fr965 and approachs50 place two, venusq2
(rectangular) places none and keeps them in the grid. Not changed: the hero, gauge, sub line, arc and night.

**Amendment 2, 2026-10-01 (owner: "do E1", then "less rigid, some curved UI"; mock page reviewed in a browser, simulator-tested,
not on a wrist):** the look is **softer and curved, in both tiers**. (1) **The gauge is a shallow smile** (an arc of one circle
whose depth is 44 per mille of the width, round-capped with filled circles because `drawArc` ends are butt; it replaces the straight
bar in Simple too, since the hero block is shared). (2) **Pro's grid fields sit in rounded pills** (outline in the track grey,
`ARC_TRACK`, the documented sub-3:1 hairline) **riding the same curve**: a pill's centre lifts onto the smile, clamped to a
budget reserved once above the rows so the planner's height never depends on live cell widths; the corner fields get pills too and
are skipped when a pill is taller than the date row. (3) **The Pro divider is gone** (the pills separate the grid from the hero).
(4) **Pro drops the "N of 100" line under the Body Battery gauge** (the number and the gauge already say it, and the row is worth
more to the grid; the empty-state sentence stays; Simple keeps the line). Without that, the extra height forced the planner to
drop the "Body Battery" label on an FR965. (5) **Pulse ox becomes an icon-only field** (the label does not fit a pill on the bottom
row; the droplet icon carries it; ADR-013's count is now 10 of 17 icon-only). (6) **Body Battery's hero icon is replaced:** the
old shell with a fixed filled block read as a level (ADR-006 forbids implying one), the new one is Tabler's `battery` shell with
Tabler's `activity-heartbeat` line scaled into it, one hue, no level, no bolt (a bolt is already the Intensity-minutes grid icon).
Per-device plan levels before/after: fr965, approachs50 and venusq2 keep or improve their ladder rung in every window except
approachs50 midday-data (one rung smaller). Not done: curved text (`drawRadialText` needs vector fonts, which only some of the
69 products have; a later enhancement behind a capability check).

**Amendment 3, 2026-10-02 (owner, wrist photo and emulator screenshot of Pro morning):** morning's Pro grid gets **icon-only cells like midday and evening**. Why: it was the one window with text-label cells, the owner reported "no icons" in Pro, and in the pills the labels were cut or dropped in real conditions ("Ri… 03:14", then bare "50%" and "182"), because live plans have bigger fonts and a lower, narrower grid than the worst-case plan the tests measure. Three new Tabler icons (outline, 22 px, 64-colour hues): sunrise `#FFAA00`, sunset `#FF5500`, a battery shell `#AAFF55`; heart, steps, stairs and bell are reused. The first two icon-only cells (sunrise and sunset) now take the corners beside the date, like the other windows. The seven morning label strings are removed. Two hues repeat across windows, never within one (sunset `#FF5500` = flame, `#AAFF55` = VO2 bars): morning shows neither flame nor VO2. Also: a label now gives way before a short value is cut (the label gets what the value does not need, at least half the old share), and "Batt" is no more (icon). Tests: Pro fr965/approachs50/venusq2 and Simple fr965 pass in the simulator (one transient fr965 icon-size error on a run while another session used the same simulator, gone on rerun); plan levels same or better than before.

**Amendment 4, 2026-10-03 (owner: "SVGs MUST BE PIXEL PERFECT"):** every icon bitmap is now drawn at a whole-number scale with
whole-pixel strokes, so the SDK's SVG rasteriser has nothing to resample. **Grid icons:** 22×22 → **24×24** (the Tabler 24 grid
at 1:1; `GRID_ICON_SIZE` 22 → 24), every stroke 2.2–2.5 → **2** (an even width centred on an integer coordinate puts both edges
on whole pixels). **Hero icons:** weather 56×45 → **60×48** (2× its 30×24 box), stress 52×52 → **48×48** (2× the 24 grid; stroke 2,
dot r 2.5 at cy 20), Body Battery 68×48 → **60×42**, redrawn directly in pixel space (6 px outline, 4 px heartbeat line, 6×12 nub; the
old nub and the scaled-in line sat on fractional pixels). Cost: strokes are lighter than the 2.3 the owner approved, and the
Body Battery shape is blockier; icon heights are 48/48/42 instead of 45/52/48. `DayArcRenderTest` sizes updated; the full test
set passes on fr965, approachs50, venusq2, venux1, fr255s and fenix7s (Pro; Simple on fr965 and approachs50). Simulator only.
**Reversed by:** an on-wrist look (checklist "Icons after the pixel-grid change") judging the 2 px strokes too thin on the AMOLED —
revert `resources*/drawables/icons`, `tools/hero_icon_templates`, `GRID_ICON_SIZE` and the test sizes (one commit).

## ADR-014: One wearer setting — Accent colour (partly reverses ADR-011)

**Status:** Active. Built 2026-09-28; simulator-tested only — it has never been changed in the
Garmin Connect phone page or on a watch.

**Decision:** Add exactly one setting, "Accent colour", to BOTH listings (`resources/settings/` is
shared by both jungles). A list only — never a free hex or colour picker — of seven values, every
one 64-colour-safe:

| Value | Choice | Colour |
|---|---|---|
| 0 | Auto (default) | each window's own hue, exactly ADR-013's behaviour: morning amber `#FFAA00`, midday cyan `#55FFFF`, evening rose `#FF55AA` |
| 1 | Cyan | `#55FFFF` |
| 2 | Amber | `#FFAA00` |
| 3 | Rose | `#FF55AA` |
| 4 | Green | `#55FF55` |
| 5 | Blue | `#55AAFF` |
| 6 | Purple | `#AA55FF` |

A fixed choice colours the window-progress arc, the hero value, the gauge fill and the hero icon in
every non-night window. Night stays hueless. The 14 Pro grid icons keep their fixed per-type hues
(ADR-013) — categorical, unaffected. Two surfaces write the same `Application.Properties` key
(`Accent`), last change wins: the Garmin Connect phone page (`settings.xml`) and the watch's own
Customize screen (`getSettingsView`: one plain `Menu2` list plus a delegate). **Corrected 2026-09-29
(third review):** a sideloaded, dev-signed app gets NO phone-app settings — the phone page works only
for a store-installed app (`watch-design-kit/knowledge/platform-facts.md` "Settings") — so the
watch's Customize list is the only route a sideloaded build has, and the phone-page route can be
verified only after a store install; the listing's "chosen in the Garmin Connect app" claim ships
unverified until then. The Customize delegate copies TwoSuns's list-menu delegate but with one
difference that matters: DayArc's menu IS the root settings view, so `popView` on select leaves
Customize altogether (TwoSuns pops a sub-list pushed over its root menu); Days To Go ADR-005's FR965
verification of the Customize route therefore does NOT cover select-then-exit, which is untested. Density is still compile-time (ADR-003, ADR-011's
core stands): this is the ONLY runtime setting, and nothing else is to be added under it.

**Why:** The owner asked for it, explicitly, after first wearing the face (2026-09-28) — the
per-window hues are the design's own choice, and a wearer may simply prefer one colour all day. The
risk is on the record: settings that don't save are this category's single most-upvoted complaint
(ADR-011's evidence, 8.4% of low-star reviews), which is why ADR-011 removed the whole surface. The
mitigations ARE part of the decision, not extras:
- **One setting, one list, seven values.** Nothing to mis-type, nothing that interacts with another.
- **The default is today's behaviour.** A setting that is lost, reset or never touched looks exactly
  like the face the owner already approved — the failure mode is "Auto," never "broken."
- **Read at draw time, never cached.** `DayArcSettings.accentChoice()` reads `Application.Properties`
  inside a `try/catch` on every gather, clamps to the valid range and falls back to Auto for a
  missing key, a wrong type from an old phone app, or a value nobody offers. `onSettingsChanged`
  requests a redraw, so a change applies without a restart.
- **No runtime tint.** Hero icons are pre-coloured bitmaps, one per hue (18 files, generated by
  `tools/gen_hero_icons.py` from the ADR-013 Tabler-derived icons), chosen at draw time — never
  `drawBitmap2`'s `:tintColor`, which is broken on FR165/FR165m.
- **Tested pure.** The clamp and the choice-to-hue mapping are pure functions with unit tests
  (garbage values, every index, 64-colour safety); the tests never write a real property.
- **Gate 5 now has something to test on a device** (`docs/status.md`): on a sideloaded
  build, the Customize picker only (choose, select-then-exit, restart the watch); the phone page only
  after a store install.

ADR-006 (no colour verdict) still holds: a chosen hue is constant whatever the reading, so stress
and Body Battery never change colour with their value — and a colour the wearer picked is not the
watch judging their number. It does mean a wearer can now pick green or amber for stress; that is
their choice, not a threshold. Note for the owner: Green, Blue and Purple are the same hues as the
Pro grid's steps, calendar and stairs icons (and Cyan, Amber, Rose already echoed the breath,
thermometer and droplet icons) — categorical, so no reading is ever implied, but a chosen accent can
match a grid icon.

**Evidence:** The owner's request (2026-09-28, chat). TwoSuns already ships an Accent list setting
plus on-watch list menu (`../TwoSuns/source/settings/`), and Days To Go ADR-005 records the
Customize route working on an FR965 — the pattern, not proof for DayArc (see the select-then-exit
difference above). `DayArcSettingsTest`
(clamp, mapping, 64-colour safety) and `DayArcRenderTest.everyHeroIconLoadsAtExpectedSize` (all 18
hero icons, every window x every choice) pass on fr965/approachs50/venusq2/venux1, both jungles.
No new manifest permission. Nothing about the phone page or the watch menu has been exercised on a
device.

**Reversed by:** The owner; or a device test (gate 5) showing the choice doesn't persist or apply —
in which case remove the setting and return to ADR-011 rather than ship a flaky one. Any request for
a SECOND setting is a new ADR, and this one's persistence evidence should be in hand first.

## ADR-015: Instinct E and Instinct 3 Solar: window gauge, black and white, no accent

**Status: Proposed.** Written 2026-10-03; the owner approved the look (mockup `docs/archive/instinct-mockup.html`), chose to hide the Accent setting on these watches, and chose to ship only the three Connect IQ 6 Instinct products. Simulator only: nothing has run on a watch (the owner has none), and DayArc has never been submitted.

**Context.** DayArc needs Connect IQ 4.2 (`Toybox.Complications`, `minApiLevel` 4.2.0), so of the Instinct family only `instincte40mm`, `instincte45mm` and `instinct3solar45mm` (CIQ 6.0) qualify; the Instinct 2 family (`instinct2`, `2s`, `2x`, `descentg1`, CIQ 3.4) would need a build without Complications, which is a separate project and is **not** done here. `instinctcrossover` is left out (analog hands over the display). The three are 1-bit (palette `000000`/`FFFFFF` only), **watch-face memory 65,536 B** (the other 69 products have 131,072 B), with a round window top right (62 px; 52 px on the E 40 mm). ADR-001 had excluded the E and the 3 Solar as "semi-octagon, 64KB, monochrome".

**Decision.**
- **Products.** The 3 join both manifests (72 products in each).
- **Layout.** `DayArcLayout` asks `WatchUi.getSubscreen()` on `SCREEN_SHAPE_SEMI_OCTAGON` products only, so no round or rectangular product's geometry depends on it. Rows are boxes, not chords: a side margin each side, clipped to the circle the bezel leaves visible (below), and a row that starts above the window's lower edge plus a ring clearance ends left of it and is centred in that band (`rowCenterX`, used by every drawn row). `DayArcStack` is unchanged in kind: its rungs, its widths (`rowMaxWidth`, now window-aware) and its sliding step decide the plan; on an Instinct the slide also continues until the hero row (icon and value) clears the narrow band beside the window (`DayArcStackFit.topRowsFit`). **The window-progress arc becomes a gauge in the window**: a hairline circle with a thick fill (a quarter of the window radius) from 12 o'clock clockwise, the same share of the current window; night has no gauge (as on the round faces).
- **The visible area is a circle (found by simulator screenshot, 2026-10-03).** The bezel hides the corners: what shows is the square cut by a circle about 98 px in radius (96 to 100 px, from the alpha mask of the SDK's device images). `DayArcLayout` clips every row to a 96 px circle (`VISIBLE_RADIUS_PX`); `stackFitsWorstCaseOnThisDevice` fails any planned row that sits under the window or reaches outside it (`dayArcInstinctProblems`; boxes include font padding, so it is stricter than the ink).
- **Black and white by annotation.** `DayArcPalette` is two classes with the same name, `(:color)` and `(:mono)`; the jungles exclude `mono` for every product and `color` for the 3 Instinct products. All roles are white; the track is an outline under a solid fill; the hero is told apart by its icon and label, never a hue. The hero and grid icon bitmaps are pre-coloured per hue and a 1-bit display rounds colour in an unspecified way, so `hueIndex` always returns the cyan set (the brightest) and the simulator screenshots show them solid white. **A per-product `excludeAnnotations` line replaces the base list**, so the density's own exclude is restated (`pro;mono`/`simple;mono` for the rest, `<density's exclude>;color` per Instinct product).
- **Accent hidden on Instinct (owner).** DayArc's one setting is Accent (ADR-014); with it gone these watches have **no settings at all**. The setting is its own file in `resources-accent/` and the Instinct `resourcePath` leaves that folder out; `getSettingsView` returns null when the palette is mono, so the watch shows no "Customize". The property stays in `properties.xml` (a shipped key never changes).
- **No corner pills.** Pro's corner fields (the first icon-only grid cells beside the date) are not drawn beside the window (`DayArcCorners`): the date row there is a narrow band. The Pro grid is the planner's call and is dropped on the rungs that cannot fit it.

**Consequences.** On an Instinct the face has less room than the mockup assumed (the real smallest font is 23 px tall on a 176 px screen), so Pro's grid appears only in some windows; the mockup shows the look that was approved, not the built layout. No round or rectangular product's drawing changed: `rowCenterX` returns the centre, `rowMaxWidth`'s round and rectangular branches are untouched.

**Verification.** See `docs/compatibility.md` "Instinct E and Instinct 3 Solar". Simulator only.

## ADR-016: Grid cells whole or not at all, Pro without a grid before trimming, half-size Instinct hero icons, icon level with the digits

**Status: Accepted by the owner's standing authorisation (chat 2026-10-04: redesign and improve UI/UX of DayArc without asking first).** Simulator only, no wrist. Found by looking at fresh `docker/shot.sh` screenshots (fr965, fr255s, epix2, Instinct E 40 mm, 3 Solar) after the owner's FR965 photo (2026-10-03: "R... 2501").

**Decisions.**
- **A Pro grid cell is shown whole or not at all** (`DayArcGrid.cellFits`/`shownLabel`). A label is drawn only if it fits whole beside the value's natural width, otherwise it is dropped (the icon says what the cell is); a value must then fit whole. Only a calendar title (`:flex`) may end in "..." and keeps room for a clock time ("00:00a"). A cell that cannot fit does not draw, and the planner steps down a rung as before. This replaces the old "label gets at least half of 55% of the column, value keeps three digits" rule, which produced "R... 2501", "N... 12:00", "R...10" and "12:...". The label/value gap has a 3 px floor (`Rec5h` on a 166 px screen).
- **Recovery time is minutes, not hours.** The SDK value is "a Number of minutes remaining" (`COMPLICATION_TYPE_RECOVERY_TIME`, api.mir 9.2.0); the wrist photo's `2501` was 41.7 h. The cell now reads `42h` (`DayArcFormat.hoursFromMinutes`, rounded).
- **Pro without a grid before any trimming** (`DayArcStack.search`, `STACK_FIRST_TRIM`). Passes: every non-trim rung with the grid; then, Pro only, the same rungs without it (a stack with no grid block is centred like Simple's); then the TRIM rungs. Before, a Pro Instinct morning fell to a TRIM rung and lost its date and sub line while Simple kept them, and ended smaller than Simple.
- **Half-size hero icons on the Instinct** (`resources-instinct/`, on the Instinct `resourcePath` of both jungles, replacing all 18 shared ids with three white files: 30x24, 24x24, 36x24). The 60x48 / 48x48 / 60x42 icons were twice the height of the digits beside them on a 166 to 176 px screen and took the width the digits needed, so the focal number was the smallest thing in the row. The planner reads the loaded bitmap's size, so the hero row shrinks and the digits can grow with no code change. Round and rectangular products are unchanged.
- **Four Pro grid icons redrawn white on the Instinct** (`resources-instinct-pro/`, Pro jungle only): sunset (#FF5500), flame (#FF5500), bell (#5555FF) and bike (#AA00FF) round to black on a 1-bit display, so their pill showed an empty slot (screenshot, E 40 mm morning).
- **Fifth design review (watch-design-reviewer, 2026-10-04, disposition fix), closed items:** on the 1-bit Instinct the gauge's track is a hairline under the full-pen fill (both were solid white, so the share could not be read); pill side padding has a 4 px floor ("12:00a" touched the outline); Simple's Body Battery no longer shows "N of 100" under the gauge (the open item in DESIGN.md; the number and the gauge say it, Pro already dropped it). **Open from that review, not done:** hero icon scale per round screen size (too big on the FR255S, thin and small on the FR965) and a redrawn weather glyph (both need new icon art); Pro on the Instinct drops the hero label where Simple keeps it; Pro on the 3 Solar morning is identical to Simple.
- **The hero icon is centred on the digits, not on the font box** (`DayArcDraw.drawHeroGroup`, `DIGIT_HEIGHT_PERMILLE` = 720). A number font's digits fill about 0.67 (epix 2) to 0.77 (FR965) of its ascent; the rest is empty headroom above them, so a box-centred icon sat visibly high. Row heights are unchanged (no planner change); the Dc has no glyph metrics, so the share is an estimate that the wrist or a screenshot tunes.

**Reversed by:** the owner; or a wrist photo showing that a dropped label (an icon with only a number) reads worse than a cut one.
**Not done (open):** the hero icon is still a fixed-pixel bitmap on round watches, small beside an FR965's HOT digits; scaling it needs larger sources or `drawScaledBitmap` (API 4.0), both unproven for crispness.
