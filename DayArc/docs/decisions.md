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
| 007 | Price: Simple free, Pro $1.99, no flip | Active |
| 008 | Simple excludes calendar deliberately | Active |
| 009 | Pro accepts kitchen-sink density on purpose | Active |
| 010 | Night window (23:00-5:00) | Open — owner-reversible |
| 011 | No settings surface, either density | Active |
| 012 | Names, app ids and slugs | Open — store-collision checked, no trademark search |

## ADR-001: Device set / API floor

**Status:** Active.

**Context:** Every field this face uses (`Toybox.Complications`) needs API 4.2.0. TwoSuns already
ships and was submitted on this exact floor with the same 69-product set.

**Decision:** `minApiLevel="4.2.0"`, TwoSuns ADR-009's 69-product set (66 round, 3 rectangular
AMOLED: Venu Sq 2, Venu Sq 2 Music, Venu X1), for both the Simple and Pro manifest. The rectangular
products get the same round-centred content, shorter side sets the scale — TwoSuns's own layout
convention, reused (`DayArcLayout`).

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

**Decision:** Two separate store listings (DayArc, DayArc Pro), no in-app toggle, no settings
surface at all (ADR-011). One shared `source/`, split at build time via Monkey C's `excludeAnnotations`
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

## ADR-007: Price — Simple free, Pro $1.99, no flip-to-free

**Status:** Active.

**Decision:** Simple is free at launch and stays free (no flip rule, nothing to define). Pro is
$1.99 and never flips to free — a deliberate break from the DaysToGo/TwoSuns 45-day
flip-to-free-once rule.

**Why:** That rule exists to keep a reversible escape hatch on a single paid listing when there is
no free alternative. Here, Simple already covers free reach, so Pro can hold its price indefinitely
without needing its own escape hatch.

**Evidence:** Owner decision, 2026-09-27.

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

**Status:** Active.

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
this specific case shouldn't need one).

## ADR-012: Names, app ids and slugs

**Status:** Open — store-collision and general web checked; no registered-trademark search done.

**Decision:** **DayArc** (Simple), **DayArc Pro** (Pro). App ids: `56a7298c-dcbf-41ff-b013-9a073a59d2dd`
(Simple), `cc86c6b6-9a5c-4908-9056-165ff4b81982` (Pro) — never change once published. Site slugs
still open (see `docs/publish-checklist.md`).

**Evidence:** `apps.garmin.com` search for "DayArc" (985 fuzzy results) and "DayArc Pro" (996 fuzzy
results), no exact title match in either; general web scan found one unrelated company ("Day Arc
Environmental Systems," HVAC, different industry/class), no software product named DayArc.

**Reversed by:** A registered-trademark finding, if the owner runs a real USPTO/legal search before
submission.

## ADR-013: Icon system, per-window and per-icon colour, always-visible date, window-progress arc

**Status:** Built, 2026-09-28 (was "approved direction, not yet built" earlier the same day).
Simulator-tested on fr965/approachs50/venusq2/venux1, both jungles, plus the full 69-product compile
sweep — see `docs/plan.md`. No real-device evidence and no owner screenshot review of the built
version yet; `docs/publish-checklist.md` gate 4 stays open for that.

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
a house-rule function-length violation) — all fixed, see `docs/plan.md`. `watch-design-reviewer`
itself (the craft-focused agent, distinct from this fix-finding review) has still not run against
the built version.
