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
| 007 | Price: Simple free, Pro paid at Garmin's second price step, no flip | Active (amended 2026-10-01); the price part is superseded by ADR-018 (the $2.50 tier) |
| 008 | Simple excludes calendar deliberately | Active |
| 009 | Pro accepts kitchen-sink density on purpose | Active |
| 010 | Night window (23:00-5:00) | Open — owner-reversible |
| 011 | No settings surface, either density | Active — reversed for ONE setting (Accent colour) by ADR-014 |
| 012 | Names, app ids and slugs | Open — store-collision checked, no trademark search |
| 013 | Icon system, per-window/per-icon colour, always-visible date, window-progress arc | Active — built; amended after the first wrist photo (vertical stack planner) |
| 014 | One wearer setting: Accent colour | Active — built, simulator-only, never yet tried in the phone app or on a wrist |
| 015 | Instinct E and Instinct 3 Solar: window gauge, black and white, no accent | Accepted 2026-10-04 — simulator only |
| 016 | Grid cells whole or not at all, Pro without a grid before trimming, half-size Instinct hero icons, icon level with the digits | Accepted 2026-10-04 (owner's standing authorisation) — simulator only |
| 017 | Hero icons follow the screen (two sizes per screen), a line-icon weather glyph, the hero label before a grid row | Accepted 2026-10-04 (owner's standing authorisation) — simulator only |
| 019 | Rectangles get a square design: a track that follows the glass, a straight gauge | Accepted 2026-10-05 — simulator only, screenshots for the owner's approval |
| 020 | Always-on time in the studio's one always-on grey, `#5C5C5C` | Accepted 2026-10-08 (owner's standing authority) — simulator only |

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
Body Battery treatment at the time (TwoSuns removed its own dim on 2026-10-08, TwoSuns ADR-008 (no verdicts on Body Battery) amendment; TwoSuns's threshold was an arbitrary "low charge" cue with no tie to an
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

**Status:** Active; the price part (the second step) is superseded by ADR-018 (the $2.50 tier for every paid app, 2026-10-04); Simple is free and Pro never flips.

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

**Amendment 2026-10-05 (owner: "do your picks", design critique, ROADMAP 13.19 and 13.20; simulator only).** (1) The evening
hero icon is an outlined **bolt**, not the battery shell: beside Pro's watch-battery pill the shell read as a second battery,
the problem Two Suns fixed the same way (its ADR-023). Generated by `tools/gen_hero_icons.py` in every size and hue, and on
the Instinct; the ids stay `IconHeroBattery*`. (2) **Pro's grid icons are all muted `#AAAAAA`**: per-type hues made a rainbow
that competed with the one coloured hero read. The intensity grid icon is a pulse line (`grid_pulse.svg`), so the bolt means
Body Battery only. Reversed by the owner (restore the per-type hues from git history).

**Amendment 2026-10-05, from the owner's wrist photos (ROADMAP 13.28, 13.29; simulator only):** the morning hero is labelled
"Feels like", and its icon is the current condition (five glyphs from `tools/gen_hero_icons.py`, `DayArcWeatherKind`), not
the window's fixed sun-behind-cloud; no icon when there is no weather or no glyph for the condition. Midday and evening keep
the window glyph. Reversed by the owner.

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

**Status: Accepted 2026-10-04** (was Proposed; flipped by ROADMAP 2.4: the owner has since asked for the design work on these watches to continue, answered that the Instinct 2 family stays out for good, and DayArc ships all 15 languages). Written 2026-10-03; the owner approved the look (mockup `docs/archive/instinct-mockup.html`), chose to hide the Accent setting on these watches, and chose to ship only the three Connect IQ 6 Instinct products. Simulator only: nothing has run on a watch (the owner has none), and DayArc has never been submitted.

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

## ADR-017: Hero icons follow the screen (two sizes per screen), a line-icon weather glyph, the hero label before a grid row

**Status: Accepted by the owner's standing authorisation (chat 2026-10-04: redesign and improve DayArc's UI/UX without asking first).** Simulator only, no wrist. Closes ROADMAP 1.12, 1.13 and 1.14 (the open items of ADR-016's fifth-review list).

**Decisions.**
- **Per-screen hero icon sizes, two per screen.** A hero icon stays a fixed-pixel bitmap (ADR-013 amendment 4: whole-pixel strokes, no resampling), but the bitmap now comes from a size set the **jungle** chooses per screen (`<family>.resourcePath = $(base.resourcePath);resources-hero-L<n>;resources-hero-S<n>`, family lines such as `round-218x218`, written by `tools/gen_hero_icons.py` between markers in both jungles). **LARGE** (`IconHero<Icon><Hue>`, about the HOT number tier's digit height) and **SMALL** (`IconHeroSmall<Icon><Hue>`, about the MEDIUM and MILD digits'): the planner picks by the number tier it plans (`DayArcStack.smallIcon`, `DayArcIcons.heroFor` / `heroSmallFor`, the hero dict carries `:icon` and `:iconSmall`), so the icon stays level with the digits on a Pro screen that has fallen to MILD. A digit is 0.72 of the font box (`DIGIT_HEIGHT_PERMILLE`); sizes are that, rounded to a multiple of 6. Heights (large / small): 218 px round 42/24, 240 48/30, 260 and 280 54/36, 360 and 390 72/54 (the default in `resources/`), 416 78/54, rectangle 320x360 78/48, 454 and 466 and rectangle 448x486 90/66. The ids are the same in every build, so no code knows a pixel size (the planner reads the loaded bitmap's). Round and rectangular products only; the Instinct keeps its half-size white set (ADR-016), both slots pointing at the same three files.
  **Why not scale at draw time:** `drawScaledBitmap` resamples (the owner's pixel-grid rule, ADR-013 amendment 4) and `drawBitmap2` tinting is the FR165 bug; the sets are the "icon sets per screen size" ROADMAP 1.12 asked for. **Cost:** 216 generated SVGs (12 folders) instead of 18; a build contains only its own screen's two sets plus the default ids, and the exported packages are 3.0 MB (Simple) and 3.4 MB (Pro) for 93 part numbers (`tools/check_package.sh --build`, 2026-10-04; the older figures in `docs/compatibility.md` were for 69 products and are not comparable).
- **Line weight of 0.12 of the height** (2 px at 24, then 4 to 11 px; was 2 to 6 px at fixed sizes). The digits' stroke is 0.13 (FR965) to 0.18 (the bolder epix 2 font) of their height; a 2 px stroke beside an FR965's digits read as faint ("small and thin", the owner). The stress wave is cropped to its ink so its box is its glyph (it had a fifth of empty box above and below).
- **Weather glyph redrawn** (ROADMAP 1.13). The filled Tabler cloud-sun was one hue, one fill: cloud and sun fused into a blob. Now an outlined cloud (three lobes and a flat base, arcs computed in the generator) in front of a solid sun with three rays (N, NE, E; none below 36 px), a black gap (the face ground is always black, on the 1-bit Instinct too) between them. The same outline weight as the stress wave and the battery shell: one line-icon system. The Instinct weather glyph is generated too (no rays at that size). **Source note:** the weather glyph and the battery are drawn in the generator, not Tabler paths (the stress wave still is); `tools/hero_icon_templates/` is gone, `THIRD_PARTY_LICENSES.md` and DESIGN.md "Source" say so.
- **The hero label before a grid row** (ROADMAP 1.14, the review finding "Pro drops the hero label where Simple keeps it"). `DayArcStack.search` had Pro try every rung with the grid, including the two that drop the label to buy a second grid row, before it ever tried the same rungs without a grid; so the label (on a 1-bit watch the only name the number has besides the icon) was traded for grid room. Now: a new rung (clock, hero and text at the smallest tiers, label kept, quartered gaps, ONE grid row), and the passes are: rungs that keep the label with the grid, then without it, then the label-dropping rungs with and without it, then TRIM (`STACK_FIRST_DROP_LABEL`, `STACK_FIRST_TRIM`). Simple is unchanged except that its new rung, with quartered gaps, keeps the label one rung longer.
- **Pro on the Instinct, decided and documented, not "fixed" further:** the E 40 mm now draws a one-row grid with the label kept in morning, midday and evening (before: two rows, label dropped in midday and evening); the 3 Solar draws it in the evening only. **On the 3 Solar the Pro morning (and midday) is the same picture as Simple, on purpose:** the morning's sub line wraps to two lines at the worst case, and clock + date + two sub lines + hero leave no room for even one pill row inside the circle the bezel leaves; midday's first pill row is the calendar pair, whose whole-or-nothing fit (ADR-016) needs a chord the lower, narrower row of a 176 px screen does not have. Pro still wins there with the extra fields in the windows that fit them; nothing is shown cut. If the owner wants Pro to differ visibly on the Instinct in every window, the lever is the grid's order (a first row of icon-only cells fits where a calendar pill does not) or giving the grid the date's row, both product calls, not made here.
- **A relation test replaces the size table** (`everyHeroIconLoadsAtExpectedSize`): per device, the large icon is 700 to 1150 per mille of the HOT digits' height, the small one no taller than 1150 per mille of the MEDIUM digits and no shorter than 700 of the MILD ones. This is the test that would have caught 1.12; the Instinct keeps an exact-size check.

**Evidence (simulator only).** Container simulator, 2026-10-04: Simple 21/21 and Pro 24/24 on fr965, fr255s, epix2, instincte40mm and instinct3solar45mm (the count includes `stackFitsWorstCaseOnThisDevice` with its Instinct visible-circle check and the new relation test); compile sweep 72/72 on both jungles; `tools/check_package.sh --build` OK (93 parts, the 4 Instinct parts without a settings file). The jungle family lines take (all 11 screen families load their own sets, each passing the relation test on a device of that family). Per-device sizes and ladder rungs: `docs/compatibility.md` "Hero icon sizes and the label rule". Screenshots of every window on the five devices were looked at, then the reviewer (below).

**Reversed by:** the owner, or a wrist photo where the new strokes read heavy beside the digits (the weight is one constant, `stroke()` in the generator: revert it and regenerate), or where a Pro Instinct with a one-row grid and a label reads worse than two rows without one (revert the new rung and the pass order, `DayArcConfig.STACK_*`).
**Not done:** the 24 px Pro grid icons still do not follow the screen (the same set-per-screen mechanism would do it, if the FR965's grid reads small); the Instinct hero icons are a single half size.

**Sixth design review (watch-design-reviewer, 2026-10-04, on the built Simple and Pro, 40 simulator screenshots on fr965, fr255s, epix2, instincte40mm, instinct3solar45mm; disposition fix, no wrist):** weather glyph legible at every size, icon-to-digit proportion good, night clean. Closed or documented:
- *Stress icon touches the gauge on the FR255S* and *Body Battery shell does not match the generator*: both checked by measuring the PNGs and did not hold. The FR255S dot is about 11 px above the gauge fill; the FR965 shell is 112 x 78 px as generated (the digits' ink there is 95 px high, so 0.785 of the font box, not the 0.72 `DIGIT_HEIGHT_PERMILLE` estimates, which makes the large icons 0.8 to 0.9 of the real digits on the FR965; a bigger set is one row in `FAMILIES`).
- *Instinct weather sun read as a ball:* fixed, the 24 and 30 px weather glyphs now carry one short NE ray (an east ray touched the number beside it).
- *Documented, not changed (pre-existing layout, or craft the owner approved in the Instinct mockup):* on the Instinct the clock and date centre in the band beside the window and the label centres on the screen, so the three have different axes (ADR-015); the date and the hero label share one muted small style; the FR965 Pro morning's corner pills sit close under the large clock (`DayArcCorners`, ADR-013 amendment); on the Instinct Pro the pill row, with solid heart and calendar glyphs, outweighs the hero, which is the known cost of keeping the label and one grid row (a thinner 1-bit pill icon set is the lever, not built).

**Seventh design review and the fixes it led to (2026-10-05; ROADMAP 1.16, 1.17; owner's standing authorisation to improve DayArc's UI/UX; simulator only, no wrist).** Fresh native-pixel screenshots of Simple and Pro, fr965, fr255s, epix2, instincte40mm, instinct3solar45mm, 07:15, 13:15, 20:00, 23:40, 24-hour clock, plus Pro with steps/floors/calories set (`pro-activity`) on fr965 and fr255s. The reviewer's first pass returned `fix`. **Closed in code:**
- *Date and hero label shared one muted small style, and the label sat nearer the date than its number* (reviewer: date-to-label gap about 28 px, label-to-hero about 55 px on the FR965). The label is now white (`DayArcPalette.TEXT`), the date, clock and sub line stay muted, and on colour screens the label is drawn down by half the empty headroom above the hero's digits (`DayArcDraw.labelNudge`; the boxes are not changed, the nudge stays inside the hero row's empty top). Not done on the 1-bit Instinct, where every role is white and the boxes are tested tight against the circle.
- *FR965 Pro morning corner pills about 5 px under the large clock.* `DayArcStack.clearClock`: where the plan has spare height the clock-to-date gap widens by up to one row gap; where none is left (the FR965 morning) and no label row sits between date and hero, the date row alone moves down into the hero's empty headroom. Both are checked against every row's chord and the grid again, and undone if they do not fit. Round and rectangular Pro only (no corner pills beside the Instinct window).
- *Gauge track outweighed a low fill* (the #AAAAAA track against a thin accent fill): the track is now `ARC_TRACK`, the arc's own faint grey (the same documented sub-3:1 hairline family; pills use it too).
- *Instinct hierarchy: with no hue the clock digits read as large as the hero's.* On a 1-bit watch the clock starts one number-font tier down (`DayArcStack.attempt`), so the hero digits are the largest.
- *ROADMAP 1.17, Pro dropped a whole grid row when a four-digit value did not fit and left a gap (FR255S).* Two root causes, both in the plan, not the draw: the plan cache never looked at the grid's values (a plan made at zero steps was reused when steps reached 1000, and `DayArcGrid.draw` then dropped the row the plan had reserved), and `DayArcStackFit.gridFits` checked the grid rows against ALL cells while the draw gets the cells after the corner fields leave (`DayArcCorners.rest`), so a morning row with steps in it was never checked at all. Now the grid is planned like the text rows, against a worst case: `DayArcSizing.sizedCells` plans every (non-calendar) cell value at least four digits wide (`WORST_CELL_VALUE` "8888"), so the rows, and with them the hero's tier, are the same at zero steps and at 5310 and do not move through the day, **except past four digits (steps 10000), accepted:** the plan is rebuilt then, and on the smaller screens it can step down a rung (reviewer pass nine; `planAtFiveDigitsStillFits` logs it per device with EVERY cell at five digits, a harsher case than a real day where only steps gets there: FR965 no change; epix 2 midday and evening one rung lower; FR255S morning one rung lower and midday and evening one grid row instead of two; E 40 mm morning loses its grid; 3 Solar evening likewise). The 10,000 mark is crossed once a day and the plan then holds for the window (the simulator would not take 10,432 steps, it showed "--", so none of this is a screenshot); planning every cell at five digits instead would cost the FR255S its second grid row all day. (An earlier attempt planned on the live widths and replanned as they grew; that moved the FR965 morning hero between tiers mid-window at 1000 steps: reviewer pass eight, rejected.) `DayArcSizing.cellsCovered` replans only when a value outgrows that (a fifth digit, a wider time), one way. `gridFits` asks the corner logic (`DayArcCorners.rest`, with the live date) which cells the grid really gets. New test `planCacheReplansWhenAGridValueGetsWider`. **Cost, accepted:** the plan is sized for four-digit steps always, so on a screen where that needs a lower rung it is lower at zero steps too: the FR965 Pro morning shows the hero at the MEDIUM tier (Simple keeps HOT) with both grid rows and steps in them, in every reading; FR255S midday and evening show two rows (4-digit steps used to drop one); the FR255S morning has no rung that fits more than two rows (sunrise and sunset, then battery and heart rate; its corners do not fit at 218 px), so steps and what follows are not shown there and a blank band of about 25 px stays under the grid (the stack is not re-centred). Revert: `sizedCells` in `DayArcStack.initialize`, `cellsCovered` in `DayArcPlanCache`, the `rest` call in `gridFits`.

**Accepted and documented, not changed (with the reason):**
- *Instinct clock, date and label on different centre axes* (reviewer: worse on Pro, where the hero row can also sit beside the window). Each row beside the window is centred in its own band, which the bezel circle widens lower down; one shared axis needs every row beside the window to fit the clock's narrow band, which the worst-case date string does not, so the date and label would lose a font tier or slide below the window and cost the stack height. The header (clock and date) as one unit left of the window, and the body centred on the screen, is the look of the approved mockup. Pro's hero beside the window is the price of its grid on the Instinct, whose Pro behaviour the owner decided to keep as built (ROADMAP 1.18).
- *The 24 px Pro grid icons do not follow the screen.* Whole-pixel icons (ADR-013 amendment 4) leave 24 or 48 px; 48 would make every pill taller than the cell font and cost Pro its second row and corner pills, and 36 px puts strokes on half pixels. On the FR965 the pills read in the screenshots. DESIGN.md "Iconography" has the lever if a wrist disagrees.
- *Instinct near-zero gauge fill is a short blob; the night block sits low on the Instinct (clock must clear the window so clock and date share one centre); pairs of unequal pills look right-shifted (they are gutter-centred, ADR-013 amendment); the Instinct Pro pill row outweighs the hero (the owner's 1.18 decision); `DIGIT_HEIGHT_PERMILLE` is an estimate (ADR-016).*
- *Not captured:* a rendered empty/error state (the simulator's data cannot be forced to null; the strings are exercised by `liveStringsRenderWithoutTruncation`) and an AMOLED always-on frame (the simulator does not enter it). Both remain wrist/store-install checks. *(2026-10-05: the
simulator does enter always-on now, `docker/SIMULATOR.md` section 3; the rectangles' always-on frames and burn-in run are in
ADR-019.)*

## ADR-018: Price: the $2.50 tier for every paid app

**Status:** Accepted 2026-10-04 (owner, chat). **Supersedes the price part of ADR-007** (Pro at "the second step of Garmin's price tiers", $2.25 in the US store; the amended 2026-10-01 text). ADR-007's other parts stand: Simple is free forever, Pro never flips to free, no price number on the website or in listing text. (ADR-007 itself and the index row were left unedited when this was written, so that file had a single editor; read ADR-007's price as superseded by this entry.)

**Decision:** DayArc Pro moves to the **USD 2.50 tier** of Garmin's price points (the third step: US $2.49, eurozone 2,99 EUR; measured table in `../../research_notes/Free and Pro ladder/garmin_rules.md`, source https://developer.garmin.com/connect-iq/monetization/price-points/). Every paid app in the studio (HeroSet, HeroFace Pro, Days To Go Pro, Two Suns Pro, DayArc Pro) takes the same tier. DayArc (Simple) stays free. The owner sets the tier in the upload form; `listing-pro/paste.md` Monetization names it because it is the owner's form input.

**Why:** Room for later discounts or a rise: Garmin's tiers are $2.00, then every $0.25, so a Pro at the second step left less room to step down. The tier converts to a different number in each store, so no number is stated where a reader sees it.

**No price number on the site or in listing text.** The Pro Description ("with its own price: one purchase, no subscription"), What's New and the pages under `site/src/apps/day-arc/` and `day-arc-pro/` state no price.

**Open risk:** DayArc Pro is not yet submitted, so it is priced at its first upload and the re-review risk below does not apply to it today. If the price is ever changed after approval: Garmin documents that changing the price of an approved app can take it out of the store for re-review (SDK `Monetization/App_Sales`), and how it treats a repricing to a higher tier is not confirmed. The Garmin email on repricing was cancelled (owner, 2026-10-04, ROADMAP 2.1); the agent re-reads Garmin's published policies instead (`../../reports/Garmin policies and design guidelines.md`, running). Ship any later repricing together with a version upload, which is re-reviewed anyway.

**Reversed by:** The owner.

## ADR-019: Rectangles get a square design: a track that follows the glass, a straight gauge

**Status:** Look approved by the owner 2026-10-08 from the simulator screenshots (`device-test/rect-review/after/`). Accepted 2026-10-05 (owner: square watches use square designs; build first, then the owner approves the real
simulator screenshots before any upload). Simulator only. **Supersedes, on Venu Sq 2, Venu Sq 2 Music and Venu X1 only, the
rectangle part of ADR-001's 2026-09-28 amendment (device set: full-width rows, the arc on the inscribed circle) and the curve of
ADR-013 amendment 2 (icon system: the "E1" smile gauge and the lifted grid).** Round and Instinct products are unchanged.

**Context:** On the three rectangles the window-progress arc was a circular arc over the top and the gauge a smile at the
bottom: a round design dropped into a square (before: `../../device-test/rect-review/before/`). The studio's rule for
rectangles: a ring or arc follows the screen as a rounded-rectangle track, inset like the round one, the same stroke, a corner
that clears the glass; progress runs clockwise and a share is the same share of the path's length.

**Decision (DESIGN.md "Rectangle"):**
- `DayArcRect` (new, rectangle only): the track's centreline is inset by what the round arc's is (`DayArcArc.radius`), the same
  pen, corner radius 0.15 of the short side (the studio's 1.5 insets; 0.12 until review pass five), clear of the Venu X1's measured glass corner (a 66 px circle fits the skin's alpha).
  The window arc is its upper part, from the left side over the top to the right side, the round arc's share
  (`ARC_SPAN_DEGREES` of 360) of the path, filled clockwise from the left in the window's accent.
- Every row fits the inner box (track inner edge plus the arc's clearance, concentric rounded corners): `DayArcLayout.rowMaxWidth`,
  `topMargin` and `gridBottom` route there, so the planner (`DayArcStack`), the corner pills and the grid use it unchanged.
- The gauge is a straight pill bar centred in the round gauge's row height; grid rows have no lift.
- The clock stays clearly below the hero in every active window (not at night): one number tier below a HOT hero, the text
  font `FONT_MEDIUM` beside a MEDIUM or MILD one (reviewers: on the Venu X1 Free the clock had reached 0.9 of the hero's
  height; on the Venu Sq 2 Pro NUMBER_MILD and FONT_LARGE digits both rendered as tall as the MEDIUM hero's). Per-window colours
  (ADR-013 (icon system and per-window colour)), no verdicts (ADR-006 (single-hue gauge)) and the Accent (ADR-014 (one Accent
  colour list)) are unchanged.

**Evidence (simulator only):** `DayArcRectTest` (the track's outer edge stays 2 px inside the glass circle along both corners,
the window is the round arc's share of the path, every planned row and the gauge bar sit inside the inner box);
`DayArcStackTest` on venusq2 and venux1, both jungles; it now plans the morning with its "Feels like" label (it had planned
the morning unlabelled, stale since the label came in, ROADMAP 13.28). Screenshots of every window, both tiers, both sizes, the
track part-filled (05:20, 06:00, 08:30, 09:25) and always-on: `../../device-test/rect-review/after/` (untracked). The "before"
set there is in 12-hour time, the "after" set in 24-hour: compare clock widths with that in mind. 24-hour burn-in simulation
(Pro, from midday): no burn-in, peak luminance 1.94% (Venu Sq 2), 2.27% (Venu X1); the 10% limit often quoted beside
these numbers is unverified (no source found; the simulator's verdict box states none).

**Consequences:** On the Venu Sq 2 Pro the morning keeps "Feels like" and a grid row (ROADMAP 13.30's trade no longer happens
there). No wrist has seen this; the Venu Sq 2's skin shows a glass corner of about 8 px, so its 48 px track corner is a
proportion, not a measured fit.

**Reversed by:** The owner, on the screenshots or a wrist.

**Amendment, 2026-10-06 (second review on the merged build):** (1) the clock rule above replaced "one tier down", which left the
Sq 2 Pro clock and hero the same height. (2) The worst-case morning sub follows the watch: without `uvIndex` (API below 5.1,
the Venu Sq 2 family is 5.0) it is planned without "UV 11", so the Sq 2 no longer reserves a second sub line it never draws; on
any product below 5.1 the morning can only gain room (`DayArcSources.hasUvIndex`). With both, Venu Sq 2 Pro plans a MEDIUM hero
and two grid rows in every data window, the morning label included. (3) Free's empty band at the bottom is accepted (DESIGN.md
"Rectangle"): the stack is measured centred in the inner box; the band reads emptier because the arc fills the top; lowering the
stack would open the same gap under the arc and break the arc-clock header; the hero cannot take the room (HOT at midday and
evening; on the Sq 2 morning every HOT rung fails the worst-case fit). The no-weather morning drops its label and hero row and reads clock, date
and "Weather unavailable" (shared code, every product; still no icon, ROADMAP 13.29): with no icon a "--" floated alone in a row
sized for digits (reviewers, passes three and four). `hasUvIndex` uses the drawn line's own test (`has :uvIndex` on the live
conditions). The Sq 2 Pro "MEDIUM hero, two grid rows" morning is a simulator result that holds while the watch reports no
`uvIndex`; a firmware that adds it plans the UV segment again. The
Sq 2 Free clock changes size with the hero's tier (FONT_MEDIUM / NUMBER_MILD), accepted to keep the hierarchy. (4) The recaptured screenshots
show the simulator's canned values (sunrise 12:17, sunset 23:59, a 00:00 event; steps, floors and intensity set by
`sim_activity`) and are labelled so; empty states (no weather, no stress) and a blue Accent are captured with
`tools/variant_shots.sh`, which patches a private copy of the project.

**Amendment, 2026-10-06, review pass five:** the track corner is 0.15 of the short side (48 / 67 px), the studio's one corner
proportion (1.5 insets, owner, 2026-10-06; it was 0.12); the window's tips move to y 112 / 151. The no-weather sentence is planned
as itself, not against the morning's data worst case (which reserved a second line it never drew, under-filling the Venu X1 and
round mornings), and drawn white, the label's role (on a rectangle, with its small clock, it is the read; on round and Instinct the time
leads, as at night, and the sentence comes second). The STACK log counts the cells the frame draws (after the corner pills).
Tests (simulator, container): Free PASSED 25/25 and Pro PASSED 28/28 on venusq2, venux1, fr965, fr255s, instincte40mm; the
no-weather morning was screenshotted on fr965 and instincte40mm too (both tiers), since that change is shared.

**Amendment, review pass six:** with no weather the rectangle clock is `FONT_MEDIUM` (the Sq 2's data-morning size; the Venu X1's
data morning has NUMBER_MILD, so its clock shrinks when weather drops out; the first rung had let it grow, larger than the
sentence that is the read), and on the Instinct the no-weather morning sits
below the round window like night (`belowWindow`), so the clock, date and sentence share one centre (the Pro sentence had broken
into a two-axis staircase beside the window). Shared change: screenshotted on instincte40mm, instincte45mm and instinct3solar45mm,
both tiers.

**Amendment, review pass seven:** on the Instinct, a Pro no-weather morning moved its whole stack below the window and lost its
pill row (the E 40 mm Pro looked like Free, against ROADMAP 1.18's approved Pro). Now only the sentence and the grid go below the
window (`DayArcStack.place`, `_shift`); clock and date keep their band beside it, as on the data morning; Free and night still sit
wholly below the window. Simulator only: Free PASSED (passed=25, failed=0, errors=0) and Pro PASSED (passed=28, failed=0, errors=0)
on venusq2, venux1, fr965, fr255s, instincte40mm, instincte45mm, instinct3solar45mm; screenshots of the Instinct Pro no-weather
morning on all three show the sentence centred below the window and two pill rows.

**Amendment, review pass ten:** on a rectangle, Pro's morning without weather (no hero row) is centred in the inner box, keeping
room for one more grid row than reserved (`DayArcStack.attempt`); top-anchored it left about 150 px blank under the grid on the
Venu X1. Round and Instinct Pro stay top-anchored. Simulator only (Venu Sq 2 and X1 Pro recaptured).

## ADR-020: Always-on time in the studio's one always-on grey, `#5C5C5C`

**Status:** Accepted 2026-10-08 (agent, under the owner's standing authority to take the recommended option; ROADMAP 13.25,
one always-on grey for the studio). Simulator only.

**Context.** The AMOLED always-on frame (`DayArcDraw.renderIdle`: the time only, drifting on a 3 x 3 grid) drew the time in
`MUTED` `#AAAAAA`, 9.0:1 against black and 0.40 relative luminance, about 3.8 times the always-on grey the other faces use.
No ADR or DESIGN.md line gives a reason for `MUTED` there: "Motion / always-on" says the frame was TwoSuns's `TwoSunsSleep`
pattern reused, and Two Suns has since moved its always-on text to `#5C5C5C` (Two Suns ADR-027 (always-on text is a dim
grey)); the frame's own stated philosophy is "fewest lit pixels", which a dimmer grey serves. Checked before the change: no
1-bit path depends on it (the Instinct is not AMOLED and never enters `renderIdle`; its palette maps every role to white).

**Decision.** A new role, `DayArcPalette.SLEEP_TEXT`: `#5C5C5C` on the colour palette (3.14:1 against black, WCAG formula,
computed from the hex value; the 64-colour `#555555` would be 2.82:1, under the studio's 3:1 bar), white on the 1-bit palette
(defined so both palettes have the role; never drawn there). `renderIdle` draws the time in it; every awake role is unchanged
(`MUTED` stays the clock, date and sub-line grey of the active windows). `#5C5C5C` is not a 64-colour value: only the AMOLED
sleep frame draws it (`DayArcView` takes `renderIdle` only when the watch is asleep and `requiresBurnInProtection` is true),
and every DayArc product that does is a 16-bit AMOLED (SDK `compiler.json`), which stores it as about `#5A5D5A`, still about
3.1:1 (computed); MIP watches keep the full active window in sleep and never meet it.

**Evidence.** Test `alwaysOnGreyReadsOnBlack` (both densities, not annotated per product, run on fr965, venusq2 and instincte40mm; on the Instinct it checks white) pins the 3:1
bar; the mono palette test now also checks `SLEEP_TEXT` is white. Suites PASSED 2026-10-08 in the container on fr965, venusq2 and instincte40mm: Pro 29, Simple 26 on each. Always-on frames and the 24-hour heat map on `fr965` and
`venux1`, simulator only: DESIGN.md "Motion / always-on". Not measured: legibility outdoors on a wrist (the owner's FR965 has
run the final builds since 2026-10-05, in `#AAAAAA`; ROADMAP 1.1).

**Reversed by.** The always-on time unreadable at 3.1:1 on a wrist, in daylight (the likelier failure) or at night: one constant, `SLEEP_TEXT` (or point
`renderIdle` back at `MUTED`).

