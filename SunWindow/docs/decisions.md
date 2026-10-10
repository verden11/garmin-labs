# Sun Window — decisions (ADRs)

One entry per durable decision. Table first for a quick scan, full body
below. Status is one of: Open, Proposed, Active, Superseded.

The full task plan and the decision log behind these entries:
[`reports/Sun Window build plan.md`](../../reports/Sun%20Window%20build%20plan.md)
(revision 2, verified 2026-10-05). "OD-n" numbers below refer to its
decision tables.

| # | Decision | Status |
|---|---|---|
| 001 | Name and slug: "Sun Window", `sun-window` | Active (trademark check before listing work) |
| 002 | v1 is widget-style: no watch face, no nudge | Active |
| 003 | v1 is Free only, no Pro | Active |
| 004 | Window rule: one 45 degree display constant; weather demotes on UV below 3 | Active (reversible default) |
| 005 | Wording rules; no "vitamin D" anywhere (option A) | Active |
| 006 | Clock times in the full view only; NONE TODAY is a sentence only | Active |
| 007 | Go to the device spike; build only if the watch yields a place | Active (spike passed 2026-10-05; build started 2026-10-10) |
| 008 | Manifest type `widget` (owner, 2026-10-10), with a glance | Active (reversible before the first upload) |
| 009 | Accent setting through `onMenu` + `Menu2`, not `getSettingsView` | Active (D11: which gesture opens it, open) |
| 010 | Glance recomputes each draw, reads weather, never writes Storage or calls Position | Active (glance 7.1 KB measured; FR965 spike read Storage and weather in a glance) |
| 011 | Design look approval: mockup rev 2 | Active (owner, 2026-10-05) |
| 012 | Instinct E 40/45 and Instinct 3 Solar 45: included, lean | Active (agent default; reversible) |
| 013 | Store and release answers | Active |

## ADR-001: Name and slug

**Status:** Active (owner, 2026-10-05), with one condition: a quick
trademark and domain check before listing work starts (plan task P9). If it
finds a clash, this ADR reopens.

**Context:** The store shows a Free app under its clean name. A live store
search found no Connect IQ listing named "Sun Window". No trademark or
domain check has been run yet.

**Decision:** Name "Sun Window", slug `sun-window`. The slug freezes once the
site URLs go into a listing. Ranked alternatives, kept in case the check
fails: Sun Gate, High Sun, Sunny Spell, Sun Hours, Sun Spell.

**Evidence:** Store API keyword search, 2026-10-04 (research notes,
`naming_and_wording.md`). Owner approval of the plan recommendations,
2026-10-05.

## ADR-002: v1 is widget-style: no watch face, no nudge

**Status:** Active. Widget-style means glance + full view; the manifest type
is set by ADR-008.

**Context:** The original idea was a nudge when the user has been inactive,
the window is open and the forecast worsens. On API 5.1+ watches the
compiler builds a widget as a watch-app (ADR-008), so `Notifications` and
`Background` would be available: there is no platform reason against the
nudge. The reason it is out is the owner's decision. Nothing about the
background chain has run on a watch.

**Decision:** Owner, 2026-10-04: v1 is widget-style only, and nothing is
done with watch faces yet. v1 declares no `Background` or `Notifications`
permission and has no background code. A nudge may be considered later in
an app or in TwoSuns or DayArc, as a new ADR.

**Evidence:** Owner instruction, 2026-10-04.

## ADR-003: v1 is Free only, no Pro

**Status:** Active.

**Context:** Studio direction is Free + Pro for every face, "apps where
possible". Without the nudge, a Pro would hold only an hourly "worse later"
line and an optional sun-height list.

**Decision:** Owner, 2026-10-04: v1 is free. No Pro build, no upgrade text, no
price. Accent colour stays in Free by studio rule. A Pro can be added later
as its own new app id; the price decision does not arise now.

**Evidence:** Owner instruction, 2026-10-04.

## ADR-004: Window rule: one 45 degree display constant

**Status:** Active (reversible default; owner may change).

**Context:** The science gives no single threshold. 45 degrees (shadow no
longer than the person) is the most conservative and easiest to explain; UV
index 3 is a sunburn line and is more generous for synthesis; a clear-sky UVI
3 falls at about 37 degrees at 300 DU ozone (computed, about 20 percent
model error).

**Decision:** One named constant, 45 degrees, described as a display rule
("the window opens when the sun is above 45 degrees"), never as a biological
fact. Weather only demotes OPEN, never promotes. Solar maths in `Double`
from days since 2000, full NOAA formulas. TwoSuns' `cosHourAngle`/`halfDay`
take a zenith, so the code names `ZENITH_WINDOW = 90 - ELEVATION_DEG`.

**Weather cut-offs (agent default, plan OD-18, 2026-10-05):** demote OPEN
when `Weather.getCurrentConditions().uvIndex < 3`. Any null means no
demotion. `cloudCover >= 90` is a fallback, switched on
(`USE_CLOUD_FALLBACK`) only if device check D2 shows `uvIndex` null or not
falling with cloud. Final values come from the wear data (plan P7.3). A
reading whose `observationTime` is older than 3 hours counts as no reading
(`WEATHER_MAX_AGE_SECONDS`). The reason line "Cloud cover" (owner-approved
wording, ADR-013) is the plain-words gloss for a low UV index: the code reads
the UV index, not the cloud percentage. The offset to UTC is read "now" and
used for the whole local day, so on a daylight-saving change day the clock
edge is an hour off until the switch (night only); accepted for v1.

**Evidence:** Sources in `science_of_the_window.md` (secondary for the 45
degree attribution); fixtures agree with JPL Horizons within 0.0061 degrees
(`solar_elevation_fixtures.md`). No device or Monkey C test yet.

## ADR-005: Wording rules; no "vitamin D" anywhere

**Status:** Active (owner chose option A, 2026-10-05).

**Context:** Garmin guideline 1c requires "informational purposes only"
unless regulator documents exist; 1b bars a "false sense of security". Four
live apps carry "Vitamin D" in the title, so approval is possible, but a
title reads as intended use.

**Decision:** The sun or sky is the grammatical subject. No state is called
good, bad, safe or enough. Data is attributed to the watch's own weather.
No colour is keyed to a reading. One line reads "For information only; not
medical advice or a sun-safety tool". The same words appear in the title,
description, screenshots, watch strings, translations and site. **"Vitamin
D" appears nowhere** (option A): not in the title, description, screenshots,
watch UI or site. It can be added to the description body later; adding it
would need a new ADR.

**Evidence:** `naming_and_wording.md`; Garmin App Review Guidelines as quoted
there. Owner approval, 2026-10-05.

## ADR-006: Clock times in the full view only; NONE TODAY is a sentence only

**Status:** Active (owner, 2026-10-05; the NONE TODAY content is an agent default the owner may override).

**Context:** The owner said "window open/closed only", with no minutes and
no dose. Today's opening and closing clock times are not a dose, but they
are numbers.

**Decision:** The full view shows today's opening and closing clock times;
the glance shows the state word only. NONE TODAY shows a sentence only: no
return date, no peak time and no other number (plan OD-5). The exact wording
is approved with the mockup (plan P2.5). The return date can be added if
reviews ask for it, as a new ADR, computed by bisection, never a daily loop.

**Evidence:** Owner approval, 2026-10-05; plan verification §6 (scope).

## ADR-007: Go to the device spike; build only if the watch yields a place

**Status:** Active (owner, 2026-10-05).

**Context:** SunIQ (paid) shipped a "best time to go outside" timeline plus a
reminder on 2026-10-02; Sun Tracker says "find the next good window". The
paid niche is a few hundred people. This app's difference is restraint: a
binary read, no numbers, no claims.

**Decision:** Go to the one-day FR965 spike (plan P1). Product code starts
(plan P3) only if device check D6 yields a place on the watch. If it does
not, the project is parked. The spec's other stop conditions still apply.

**Outcome (2026-10-05, FR965 only):** the watch gave a last-known place at
once from the app list and from the glance (D6), real UV and cloud values
(D2, at night so far), a glance that draws from a sideload (D7) and a
120 s idle timeout from the glance (D12). No stop condition fired. On
2026-10-10 the owner asked for the build to be completed, which is the go
(plan P1.5): the code is in `SunWindow/source/`.

**Evidence:** `market_and_rivals.md`, `naming_and_wording.md`; the
checklist results in `status.md`. Owner approval, 2026-10-05 and 2026-10-10.

## ADR-008: Manifest type `widget` (owner, 2026-10-10), with a glance

**Status:** Active. Reversible before the first upload (one manifest line).
The first draft of this ADR proposed `watch-app`; the owner chose `widget`.

**Context:** On 2026-10-10 the owner said "I don't want this to be a watch
app at all" and asked for a widget only. Facts, all from the SDK and not yet
seen on a store form: in 74 of the 75 API 5.1+ device files in SDK 9.2.0,
`compiler.json` lists no `widget` app type (only the handheld `etrextouch`
does), and since SDK 4.0.0 the compiler "automatically switch[es] app type to
watch-app when compiling a widget and targetting a 4.x device" (SDK release
notes). So on every target watch a widget is built and run as an app with a
glance: it shows in the glance list and, per a forum report not confirmed by
Garmin, also in the app list. A `type="widget"` manifest compiles cleanly for
the FR965 with strict typing and runs in the simulator (glance, then the full
view). The `watch-app` permission map is a strict superset of `widget`
(`bin/projectInfo.xml`), so `Positioning` is allowed either way.

**Decision:** `type="widget"`, `minApiLevel="5.1.0"`, permission `Positioning`
only, entry class `SunWindowApp` with `getInitialView()` and `getGlanceView()`.
The full view must work when opened cold, because the watch may also list it
as an app. A widget-type probe is on the owner's FR965 build list
(`device-test/SunWindowWidgetProbe-fr965.prg`, step W1: is "SW Widget" in the
app list?).

**Trade-off recorded:** the passive income plan
(`reports/Passive income plan.md`, phase 1, step 3) had assumed `watch-app`
so the app would land on the store's watch-app shelf and not the "thinner
legacy widget shelf". Where the store files a `widget` built for API 5.1+
watches is visible only on the upload form (ROADMAP 18.2). If it lands on
the thin shelf and the owner minds, change the manifest line and the type in
this ADR before uploading; a released app's type is hard to change.

**Evidence:** [SDK data], [SDK doc], [compile probe] per
`research_notes/Sun Window build plan/widget_platform_architecture.md` §1;
the simulator run of the widget-type probe (2026-10-10, simulator only). Not
run on a watch as a widget.

## ADR-009: Accent setting through `onMenu` + `Menu2`, not `getSettingsView`

**Status:** Active (owner's go, 2026-10-10). D11 (which gesture opens the menu on a watch) is open.

**Context:** Garmin's AppBase reference says `getSettingsView()` "is only
applicable to watch faces and data fields". The Properties topic says
device apps "implement on-device settings in the app". Every studio
`getSettingsView` is on a watch face.

**Decision:** One `Application.Properties` key `Accent` (a number), editable in
Garmin Connect, plus a `Menu2` with one "Accent" list pushed from
`SunWindowDelegate.onMenu()`. Reuse DayArc's delegate logic (clamp,
`Properties.setValue`, `requestUpdate`, `popView`) from
`DayArc/source/DayArcAccentDelegate.mc`. On 1-bit Instinct, `onMenu` returns
`false` and the settings folder is left out of that product's
`resourcePath`. Device check D11 records which gesture opens the menu on
touch models. Kit follow-up: `platform-facts.md` "Settings" needs the
faces-and-data-fields-only gloss.

**Evidence:** [SDK doc] (AppBase, Properties and App Settings). Not run on a
watch.

## ADR-010: Glance recomputes each draw, reads weather, never writes Storage or calls Position

**Status:** Active (owner's go, 2026-10-10). The weather read is an agent default
(plan OD-6).

**Context:** A stored "last-known state" goes stale across midnight unless
it carries its own date; HeroSet notes "a live glance can outlive midnight".
All 66 target watches use live glances. The sun maths is a closed form. The
glance has no reason to write, because the full view owns the place.
HeroSet's `onStart` glance crash was a scope violation, not a Storage ban;
Garmin's Glances topic allows storage access in glance mode.

**Decision:** At every `onUpdate` the glance reads the stored place
(`[lat, lon]`, key `place`) and the clock, plus
`Weather.getCurrentConditions()` behind the `(:glance)` constant
`GLANCE_READS_WEATHER` (default `true`). From these it computes the state.
The glance and the full view use the same weather read, so they always
agree. The glance never writes Storage and never calls `Position`. With no
stored place it shows the "open once" sentence. **Measured (P6.3, release
build, 2026-10-10):** the glance takes 2203 B of data and 4858 to 4903 B of
code, about 7.1 KB, on the FR965 (64 KB limit) and on the Instinct E (32 KB
limit, 22 percent), and the figure is the same with `GLANCE_READS_WEATHER` on
or off (the weather class is reachable from the state rule either way). The
constant stays `true`.

v1 has no staleness rule: the place updates whenever the full view opens,
so after travel the glance may be wrong until then. The support page says
so.

**Evidence:** [SDK data], [studio code], [inference];
`plan_verification.md` E-H1, E-H2, E-M1. Not run on a watch.

## ADR-011: Design look approval

**Status:** Active (owner approved mockup rev 2, 2026-10-05).

**Context:** Studio rule: mockup, browser screenshot and owner look-approval
before any Monkey C. Fonts and glance areas were measured first in the
container simulator on 7 devices (plan P2.1).

**Decision:** The look in [`archive/mockup.html`](archive/mockup.html) rev 2,
specified in [`../DESIGN.md`](../DESIGN.md). Today's sun path runs over a
dashed 45-degree sill. The window segment is drawn thick in the accent. The
sun disc is filled when OPEN and an outline otherwise. Below come the state
word, one reason line and today's times. The glance shows a white mark (sill
bar plus disc) and the state word, and never uses the accent. The accent
marks nothing. The default stays Sky `#55AAFF` (ADR-013); the owner did not
switch to Amber. Shortened wording forced by fit is approved with the mockup:
"Sun stays low", "Open once". If the real fonts on a watch cannot match it,
the build says what moved and why (owner steering 2026-10-03).

**Evidence:** Screenshot
`research_notes/Sun Window build plan/mockup/mockup-2026-10-05-rev2.png`
(host headless Chrome; widths from the simulator font probe, not a watch).
Owner approval, 2026-10-05.

## ADR-012: Instinct E 40/45 and Instinct 3 Solar 45: included, lean

**Status:** Active (agent default, plan OD-9, 2026-10-05; reversible).

**Context:** These three ids have a 32 KB glance and a 1-bit screen. HeroSet's
glance measured about 5.6 KB of 32 KB on Instinct E. TwoSuns and HeroSet both
ship Instinct.

**Decision:** Included. The Instinct build is lean: text plus a shape, no
bitmap, and the accent menu hidden. They are dropped if P6.3 shows the
glance over half of 32 KB, or if the fit tests fail. Instinct evidence is
labelled "simulator only" in every report.

**Evidence:** [SDK data]; HeroSet ADR-051 (glance memory, compiler figure).

## ADR-013: Store and release answers

**Status:** Active (owner, 2026-10-05; OD-12 and OD-15 are agent defaults
the owner approved with the plan).

**Decision:**

| Item (plan OD) | Answer |
|---|---|
| Languages (OD-11) | English only for v1; plan phase P8 is dormant |
| Accent (OD-8) | The roster's Free six; default Sky `#55AAFF`. CLOSED reason line: "Opens 11:10" before the window, "Closed for today" after it, "Cloud cover" when the sky demotes. The look is approved with the mockup (ADR-011) |
| `Positioning` (OD-13) | Accepted. "Collect user data": **No** (the place stays on the watch) |
| Monetization (OD-14) | **No** (no ads, no payments), in the studio-wide wording |
| Store category (OD-12) | Utility; the owner confirms it on the upload form |
| Site JSON-LD (OD-15) | An optional per-app field; Sun Window uses `UtilitiesApplication` |
| Garmin Connect settings round trip (OD-16) | Checked after approval; no Beta App upload |
| Evidence at submission (OD-17) | FR965-only evidence accepted; MIP and Instinct labelled "simulator only" |
| Timing (OD-21) | Merge, deploy the site, and upload the same day |
| Translated store text (OD-22) | Not applicable while v1 is English only |

Still with the owner, no pick made: the look of the mockup and the built
screens (OD-7), and the icon, cover, hero and store screens (OD-10).

**Evidence:** Owner approval of the plan recommendations, 2026-10-05.
