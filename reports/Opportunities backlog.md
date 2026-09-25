# Opportunities — new watch faces, new apps, features, UX/design, performance, device support

Status: 2026-09-25, refined same day after a deeper pass (API research +
five build-ready product specs added to what was originally three
lightly-sketched concepts). Grounded in what's already documented
(`HeroSet/docs/`, `HeroFace/docs/`, `HeroFace/PRODUCT.md`,
`verden-site/CLAUDE.md`) so nothing here contradicts a settled decision or
re-proposes something already rejected. This is planning text plus code
structure/file plans — no visual mockups. Visual design for anything here
belongs in the design tool (uizze.com) once connected; keeping this doc
free of pixel-level decisions on purpose so that tool does the design work
once, not this session guessing at it first.

This sits alongside two existing backlogs, each with a different job:
- `HeroSet/docs/ideas.md` — HeroSet's own feature ideas, ranked, with a
  "considered and rejected" list. Don't re-propose from there.
- `IMPROVEMENTS.md` (root) — small, cheap, already-verified correctness/perf
  fixes for the existing three projects.

This file is the third kind: bigger swings — five new-product specs (three
watch faces, two standalone apps), not-yet-planned features, and
device-support expansion — sized for someone to pick up and start coding
from, not implemented or verified here (no `monkeyc`/simulator/device in
this container; everything below is a proposal with a file/class plan and
an effort estimate, not a measured finding — API claims are marked
`(searched, not fetched)` where this container's network policy blocked
fetching the primary source directly).

---

## 1. New, distinct watch faces — build-ready specs

Verden is explicitly set up for more than one app
(`verden-site/CLAUDE.md`: "HeroSet first app; more apps come later"), and
HeroFace already proved the pattern: shared drawing/layout engine
(`HeroFaceDraw`, measured-text-fit, proportional `HeroFaceLayout`), one
private complication for HeroSet integration (ADR-044), one build per shape.
`HeroFace/source/` is 1,511 lines across 20 files (measured: `wc -l
HeroFace/source/*.mc`) — the reference point every estimate below is sized
against.

Two things every concept below respects, because they're already decided:
- **One HeroSet complication, not several** (`HeroFace/docs/plan.md`:
  "Deliberately not planned: a second complication for HeroSet"). Any new
  face that wants the HeroSet link reads the *same* private complication
  HeroFace already subscribes to — it doesn't ask HeroSet to publish a
  second one, unless a spec below says otherwise and flags it as a
  cross-folder contract change.
- **Phase 4 (rectangle, Instinct sub-window) is HeroFace's own planned
  extension**, not a new product (`HeroFace/docs/plan.md` phase 4) — scoped
  under §4 "device support" instead, so it doesn't compete with that plan.

**API grounding.** This container's network policy blocks
`developer.garmin.com` directly (confirmed: `curl` to it returns a proxy
`403`), so every Connect IQ API claim below was checked via search-engine
results against the official docs and forum threads rather than fetched
from the primary source — flagged inline as `(searched, not fetched)`.
**Whoever picks this up should re-verify exact signatures and `minApiLevel`
against the installed SDK's own `Toybox` docs before writing code** — that
takes minutes locally and this container cannot do it.

### Shared-engine strategy: extract a Barrel before building face #2

Connect IQ supports **Barrels** — shared Monkey C library projects a
manifest can depend on and a jungle file links in, real code sharing across
separate apps, not copy-paste (searched: Garmin's own "Shareable Libraries"
Programmer's Guide chapter, and `garmin/connectiq-apps`' `barrels/`
example directory on GitHub). Right now `HeroFaceDraw` (measured-text
drawing), `HeroFaceLayout`'s proportional row-stacking math, and
`HeroFaceSettings`'s `Properties`-read-with-fallback pattern
(`number()`/`flag()`/`read()` in `HeroFace/source/HeroFaceSettings.mc`)
are the three pieces every concept below would otherwise re-copy by hand.

**Recommendation**: before or alongside building the first new face,
extract those three into a `VerdenFaceKit` Barrel (generalizing
`HeroFaceLayout`'s row-stacker so it isn't HeroFace-specific), and have
HeroFace itself depend on the Barrel too, so there's one copy, not two.
**Cost**: roughly half a day to a day, one-time, done against HeroFace
(which is already built and tested, so the extraction has something
correct to extract from). **Payoff**: starts with the second new face and
compounds with the third — every estimate below assumes the Barrel exists;
without it, add ~1 day per face for hand-copying and re-adapting those
three files instead of importing them.

**Concrete mechanism, confirmed by a second research pass against real
code** (the first pass only had a search-summarized syntax sketch):
Garmin's own `garmin/connectiq-apps` repo ships four official example
barrels (`LogMonkey`, `Semicircles`, `BluetoothMeshBarrel`,
`GenericChannelHeartRateBarrel`) proving the mechanism is real and
Garmin-supported, not third-party-only. A better pattern for this
monorepo specifically, found in a live multi-project repo
(`finfinack/depth`, a widget + gauge app + two data fields all sharing one
barrel, sitting as siblings the same way Verden's projects would):
each consuming project's `monkey.jungle` needs just one line —
`base.barrelPath = ../DepthCore/monkey.jungle` — pointing directly at a
sibling barrel project's own jungle file. Applied here:
`base.barrelPath = ../VerdenFaceKit/monkey.jungle` in each new face's
jungle, `VerdenFaceKit/` sitting alongside `HeroSet/`, `HeroFace/`, and
each new project at the repo root. Cleaner than the manifest-declares/
jungle-links-a-built-`.barrel`-file version for a monorepo where
everything is already a sibling folder.

---

### A. Field Face — battery-first, MIP-native, outdoor contrast

**Positioning.** HeroFace's finish review treats "battery is the currency
on this platform" as an AMOLED/always-on problem
(`HeroFace/docs/plan.md`, finish review item 5) and its visual system
(gold/blue/green on black, `HeroFace/PRODUCT.md` "Brand Commitments") is an
AMOLED design carried onto MIP screens because it's one build for both.
Field Face flips the premium: built *for* the MIP/outdoor segment, where
always-on has **no burn-in cost at all** — MIP watches show the full face
all the time (`HeroFace/docs/plan.md`: "MIP watches show the full face all
the time"), so this face needs **no AOD/sleep draw path at all** — a real
simplification versus HeroFace, not just a reskin.

**Target devices (v1, launch scope).** Reuse HeroFace's own MIP round
product list exactly — same shape, same evidence pattern, already
individually verified against `everyStateFitsThisDisplay`
(`HeroFace/docs/compatibility.md`):
- 280px (9): `descentmk2`, `enduro`, `enduro3`, `fenix6xpro`, `fenix7x`,
  `fenix7xpro`, `fenix7xpronowifi`, `fenix8solar51mm`, `fenix9prosolar51mm`
- 260px (14): `approachs62`, `fenix6`, `fenix6pro`, `fenix7`, `fenix7pro`,
  `fenix7pronowifi`, `fenix8solar47mm`, `fenix9prosolar47mm`, `fr255`,
  `fr955`, `legacyherofirstavenger`, `legacysagadarthvader`, `vivoactive4`

23 products at launch. Extending to the 240/218px MIP rows (52 more
products) is a natural v2, deferred so the layout math is proven on the
larger-screen set first.

**Data sources.**
- Steps / intensity minutes / floors / distance / calories via
  `Toybox.ActivityMonitor.Info` — same module HeroFace already reads, same
  fallback-chain idea it already implements for floors on
  no-barometer devices (`HeroFace/source/HeroFaceMetrics.mc` is the
  pattern to fork).
- Barometric pressure trend via `Toybox.SensorHistory.getPressureHistory`
  (gated behind `(Toybox has :SensorHistory) && (Toybox.SensorHistory has
  :getPressureHistory)`, same style as HeroFace's existing `has` guards) —
  method name and has-check idiom confirmed by a second research pass
  against real shipped code (`warmsound/crystal-face`,
  `RyanDam/Infocal`, `ludw/Segment34mkII`, all using this exact pattern).
  **Real caveat the same pass surfaced**: `getPressureHistory` returns
  **ambient pressure**, which conflates altitude change with actual
  weather-front pressure trend — a hiker climbing sees "pressure dropping"
  that means "gained elevation," not "storm coming." A naive trend readout
  risks being actively misleading outdoors, which cuts against this
  face's own "genuinely useful, not decorative" bar unless the design
  compensates for altitude (e.g. via `Position`/altitude data) rather than
  reading raw pressure as a weather signal.
- Sunrise/sunset via `Toybox.Weather.getSunrise(location, date)` /
  `getSunset(location, date)`, both returning `Time.Moment or Null`, taking
  a `Position.Location` and a `Time.Moment` — confirmed real signatures via
  search of the official `Toybox.Weather` docs `(searched, not fetched)`.
  HeroFace already has a `has :Weather` path (its weather setting), so the
  has-check pattern exists to fork from `HeroFace/source/HeroFaceSettings.mc`
  and wherever HeroFace reads `Weather.getCurrentConditions()`.
- No HeroSet complication read in v1 — this face's whole positioning is
  device-native/outdoor, not HeroSet-dependent. Could add the same
  optional link HeroFace has as a v2 bonus, reusing `HeroFaceContract`/
  `HeroFaceLink` unchanged (same complication, no contract change).

**File/class plan** (forked from HeroFace's pattern, or imported from the
`VerdenFaceKit` Barrel where noted):
| File | Source | Est. lines |
|---|---|---|
| `FieldFaceApp.mc` | new, trivial | ~45 |
| `FieldFaceDelegate.mc` | new, trivial | ~25 |
| `FieldFaceView.mc` | fork of `HeroFaceView.mc`, **minus** the ring, AOD/`onPartialUpdate`, and complication-link code | ~90 |
| `FieldFaceLayout.mc` | Barrel import (or fork of `HeroFaceLayout.mc`), row heights retuned larger for daylight readability | ~40 new on top of the Barrel's base |
| `FieldFaceDraw.mc` | Barrel import, unchanged | 0 new |
| `FieldFacePalette.mc` | new — high-contrast, MIP-tuned; drop HeroSet's gold/streak role (no rank/streak concept here), keep one accent + an alert role | ~20 |
| `FieldFaceMetrics.mc` | fork of `HeroFaceMetrics.mc`'s slot-provider pattern | ~80 |
| `FieldFaceWeather.mc` | new: wraps `getSunrise`/`getSunset`/pressure trend behind `has` checks | ~45 |
| `FieldFaceSettings.mc` | Barrel import (`number()`/`flag()`/`read()`), plus this face's own setting keys | ~25 new on top of the Barrel's base |

**No `FieldFaceSleep.mc` equivalent** — the one file HeroFace has that
Field Face doesn't need, because MIP has no AOD mode to draw for.

**Store/site work** (not counted above, same pattern as HeroFace's own
phase 2, "partly done" per `HeroFace/docs/plan.md`): listing copy,
per-screen-size screenshots from the simulator, `verden-site/src/apps/
field/` (landing/support/privacy), cross-linked from HeroFace's and
HeroSet's listings.

**Effort estimate.** ~350 new/forked lines with the Barrel in place
(vs. HeroFace's 1,511 total) — smaller than HeroFace itself because it
skips AOD, partial-update, and the complication-link/parsing code
entirely. **2–4 dev days** for a store-buildable v1 core, **+1–2 days**
for store listing and site pages, following HeroFace's own timeline as
the closest reference point (`HeroFace/docs/plan.md`'s dated decisions
show it went from spike to store-ready inside about a day of focused
work, and Field Face does strictly less than HeroFace).

**Risk.** Confirmed crowded, more strongly than assumed — a second
research pass found named, live competitors: "Infocal" (also a real
open-source repo, `RyanDam/Infocal`, already reading pressure history and
a training-status complication — a mature, feature-rich competitor, not a
toy), "Crystal" (a 2019 Connect IQ Developer Award winner, open-source as
`warmsound/crystal-face`, also already reading pressure history), "Barometer
Watch Face", and "Steam Gauge" (a Garmin-featured 2019 face). **At least
two of these already implement the exact barometric-trend +
sunrise/sunset pattern this spec proposes as differentiation** — so
"genuinely useful, not decorative" is the right bar, but that specific
feature list alone clears it for existing competitors too, not just this
one. A real differentiator needs to be something neither does — the
HeroSet-family visual identity, or a genuinely different data
presentation, not the raw feature list, and possibly the altitude-aware
pressure handling noted above if those competitors don't already do it
(not independently checked here).

**Day 1 checklist.**
1. Extract the `VerdenFaceKit` Barrel from HeroFace first (see above) —
   everything below assumes it exists.
2. Scaffold a new Connect IQ project (`Monkey C: New Project` in the SDK's
   VS Code extension, or `monkeyc`'s project-new equivalent), type Watch
   Face, product `fr255` (smallest 260px target, catches layout problems
   earliest), min API matching HeroFace's own floor.
3. Add the `VerdenFaceKit` Barrel dependency to the new manifest + jungle.
4. Write `FieldFaceLayout.mc` first, off the Barrel's row-stacker, and get
   a static time-only screen building and rendering in the simulator
   before adding any data row — this is the same order HeroFace's own
   spike phase used (`HeroFace/docs/plan.md` phase 0).
5. Add `ActivityMonitor.Info` steps/intensity/floors next (proven API, no
   risk), then `FieldFaceWeather.mc`'s sunrise/sunset/pressure (the
   `(searched, not fetched)` APIs) last, so any surprise there doesn't
   block a working v0.
6. First test to write: a screen-fit case per the 23-product list above,
   following `HeroFaceScreenFitTest.mc`'s exact pattern.

---

### B. Rank Face — a HeroSet-only companion face

**Positioning.** Where HeroFace is deliberately useful *without* HeroSet
(`HeroFace/PRODUCT.md` principle 2: "every slot has a working default"),
this is the opposite bet: a face that assumes HeroSet is installed and
puts rank, streak and per-exercise progress front and center as the
primary display, not one of several fallback metrics.

**Data source — checked against the actual contract, not assumed.** The
private complication's value is `v|dayKey|push|sit|squat|rank|rankPct|
streak|lastDoneDay|goal` (`HeroFace/PRODUCT.md`, confirmed against
`HeroFace/source/HeroFaceContract.mc`). That gives Rank Face, with **zero
changes to HeroSet or the contract**: rank number, **percent** to next
rank (`rankPct`), today's push/sit/squat counts individually, streak, and
today's goal. **It does not give a raw XP-to-next-rank number** — only a
percentage. An earlier draft of this section described "XP-to-next-rank as
a literal number"; that's not available from today's contract and would
need an 11th field appended to the complication value, which is a
cross-folder contract change (`HeroSetComplicationPublisher` in HeroSet,
`HeroFaceContract.parse` in HeroFace, and ADR-044 amended, **all in the
same commit**, per both projects' CLAUDE.md rules — same pattern ADR-045
already used once to append `goal` as field 10). **v1 scope is the
percentage-based version; the raw-XP version is an explicitly flagged
stretch goal**, not silently assumed.

**Store-review consideration.** Garmin review requires a face to work
without crashing regardless of whether HeroSet is installed
(`HeroFaceLink.isLinked()` already returns `false` cleanly in that case).
Even though Rank Face's whole positioning is "for HeroSet owners," it
still needs **a real fallback screen** (e.g., time plus a one-line "Install
HeroSet to see your rank here" and a hold-to-open-store-listing action,
reusing `HeroFaceLink.open()`'s pattern), not a blank or broken screen —
this is a store-policy requirement, not a design nicety.

**File/class plan:**
| File | Source | Est. lines |
|---|---|---|
| `RankFaceApp.mc` / `Delegate.mc` | new, trivial | ~70 combined |
| `RankFaceView.mc` | fork of `HeroFaceView.mc`'s structure, new draw content | ~100 |
| `RankFaceLayout.mc` | Barrel import + new rows (rank badge, 3 per-exercise mini-bars, streak) | ~50 new |
| `RankFaceDraw.mc` | Barrel import, unchanged | 0 new |
| `RankFacePalette.mc` | fork of `HeroFacePalette.mc` **unchanged** — this face should keep HeroSet's gold/rank color language exactly, since visual continuity with the app *is* the product | ~0 new |
| `HeroFaceContract.mc` / `HeroFaceLink.mc` | Barrel import or direct copy, **unchanged** for v1 | 0 new |
| `RankFaceSettings.mc` | Barrel import, this face's own keys (accent, seconds) | ~20 new |
| `RankFaceFallback.mc` | new: the no-HeroSet screen required for store review | ~30 |

**Effort estimate.** Smallest of the three — reuses the most (entire
complication parsing/subscribe stack, unchanged). **1.5–3 dev days** for
v1 core, **+1–2 days** store/site work. The raw-XP stretch goal adds the
ADR-044 amendment process on top — cross-folder, needs sign-off, not
included in this estimate.

**Risk.** Smallest addressable market of the three concepts (existing
HeroSet owners only). Depends more heavily on the complication contract
holding steady than HeroFace does, since it has no fallback data path to
lean on besides the required-but-secondary "install HeroSet" screen.

**Day 1 checklist.**
1. Scaffold the project as a Watch Face targeting `fr965` first (not the
   smallest screen this time — start where HeroFace's own complication
   link is already verified on real hardware, per
   `HeroFace/docs/go-to-market.md`, so the hardest part is tested on known
   ground).
2. Copy `HeroFaceContract.mc` and `HeroFaceLink.mc` **unchanged** (via the
   Barrel or direct copy) — get the complication subscribe/parse working
   and printing raw values to the log before writing any draw code.
3. Build `RankFaceFallback.mc` (the no-HeroSet screen) **second**, not
   last — it's required for store review and it's the path you'll be
   looking at for most of early development anyway (this container, and
   most dev machines, won't have HeroSet actively publishing on every
   test run).
4. Then `RankFaceLayout.mc`/`View.mc` for the linked state.
5. First test to write: a parse test against `HeroFaceContract`'s known
   value format (the exact string from `HeroFace/PRODUCT.md`), confirming
   rank/rankPct/streak/goal extraction before any drawing exists.

---

### C. Pace Face — a running-metrics face, filling HeroSet's stated gap

**Positioning.** HeroSet's own one-line description states "No GPS/
distance" — it's explicitly a reps/XP app, not a running app. Neither
existing product reads HR zones or recovery-style metrics. This is the
only concept here needing genuinely new domain logic, not a layout reskin
of existing data — the real differentiator, and the real risk (see below).

**Data sources — corrected by a second research pass against real, shipped
Monkey C source (GitHub code search across `ludw/Segment34mkII`,
`ahuggel/SwissRailwayClock`, `fevieira27/MoveToBeActive`,
`krasimir/kago` and others), not just search-result summaries. Two of the
four field names in the first draft of this spec were wrong — corrected
below, with the wrong name kept struck through so a reader who saw the
old version isn't confused mid-build:**
- `UserProfile.getHeartRateZones(sport as UserProfile.SportHrZone)` — an
  `Array` of zone threshold bpm values. `getHeartRateZones2(sport as
  Activity.Sport) as Array<Number> or Null` also exists (confirmed as a
  distinct, real method — both have their own SDK method IDs in a
  GitHub-hosted SDK metadata dump), covers every sport not just
  run/bike/swim, reportedly added around SDK 9.1.0 `(still searched, not
  fetched — exact minApiLevel unconfirmed either pass)`. **Use a has-check
  with fallback**: `(UserProfile has :getHeartRateZones2) ?
  UserProfile.getHeartRateZones2(sport) : UserProfile.getHeartRateZones(
  legacySport)` — don't assume CIQ 4.2+ alone clears
  `getHeartRateZones2`'s real floor, since a method reportedly added
  around SDK 9.1 plausibly requires a newer API level than 4.2 lets in.
- `ActivityMonitor.Info.stress` — current stress score, rolling 30s
  average, nullable Number. Confirmed both passes.
- ~~`ActivityMonitor.Info.recoveryTime`~~ → **`ActivityMonitor.Info
  .timeToRecovery`** — the first draft had the wrong field name. Confirmed
  correct via five independent real, compiling, shipped repos all using
  `timeToRecovery` (hours since last activity's recovery need, nullable),
  none using `recoveryTime`. This would have been a compile error.
- ~~`ActivityMonitor.Info.vo2Max`~~ → **`UserProfile.getProfile()
  .vo2maxRunning` / `.vo2maxCycling`** — wrong module *and* wrong shape in
  the first draft: it's on `UserProfile.Profile` (via
  `UserProfile.getProfile()`), not `ActivityMonitor.Info`, and it's two
  sport-specific fields, not one generic one. Confirmed via four
  independent real repos, all branching on activity type. Code should
  pick the field matching what the face is actually showing (running vs.
  cycling), not assume one number covers both.
- **Training Status — reverse of the first draft's conclusion.**
  Garmin's proprietary Training Status **is** confirmed available, just
  not where the first search pass looked: it's a **system complication**,
  `Complications.COMPLICATION_TYPE_TRAINING_STATUS`, read via
  `Complications.getComplication(new Complications.Id(
  Complications.COMPLICATION_TYPE_TRAINING_STATUS))` behind `Toybox has
  :Complications` — the same subscribe mechanism HeroFace already uses
  for HeroSet's private complication, just a **system** complication type
  instead of a custom one (new integration work, not a drop-in reuse of
  `HeroFaceContract`/`HeroFaceLink`, which only know HeroSet's private
  one). Confirmed via five independent real, shipped faces reading and
  displaying Garmin's actual vocabulary (`PEAKING`, `PRODUCTIVE`,
  `MAINTAINING`, `RECOVERY`, `UNPRODUCTIVE`, `DETRAINING`, `UNDEFINED`,
  `PAUSED`). **This changes the recommendation below**: showing this
  string directly is likely a stronger, cheaper, more differentiated
  feature than reconstructing an approximate "readiness" read from raw
  stress+recovery+HR-trend. Numeric **Training Load** (as opposed to the
  Training Status label) remains unconfirmed by either research pass —
  treat those as two separate claims with different evidence, not one.
- `SensorHistory.getBodyBatteryHistory` — not in the first draft at all;
  surfaced by the second pass, confirmed real via the same has-check idiom
  as `getPressureHistory` (§1A). Body Battery is arguably the single most
  recognizable "should I train today" number in Garmin's own ecosystem —
  worth adding as a candidate input, or explicitly deciding not to and
  saying why, rather than leaving it unconsidered.

**Target devices (v1).** CIQ 4.2+ round AMOLED Forerunners as a starting
list — `fr965`, `fr970`, `fr570`, `fr170`, `fr165`, `fr265`, `fr70`, all
already in HeroFace's own compatibility table so the round AMOLED layout
math is proven — but **don't assume this floor clears
`getHeartRateZones2` or the system Training Status complication**
without checking; both may need a higher `minApiLevel` than 4.2, in which
case the has-check/fallback above is what keeps older-in-this-list devices
working rather than crashing. Widen after v1 once confirmed against real
hardware.

**File/class plan:**
| File | Source | Est. lines |
|---|---|---|
| `PaceFaceApp.mc` / `Delegate.mc` | new, trivial | ~70 combined |
| `PaceFaceView.mc` | fork of `HeroFaceView.mc`'s structure | ~110 |
| `PaceFaceLayout.mc` | Barrel import + new rows | ~50 new |
| `PaceFaceDraw.mc` | Barrel import, unchanged | 0 new |
| `PaceFacePalette.mc` | new — zone-colored (a color per HR zone is the one place per-zone color, not just accent color, earns its keep) | ~30 |
| `PaceFaceZones.mc` | new: HR-zone math against `getHeartRateZones`/`2`, has-checked | ~50 |
| `PaceFaceReadiness.mc` | new: `timeToRecovery`/`stress`/HR-trend formatting **plus the Training Status system complication read**, all behind `has` checks | ~75 |
| `PaceFaceSettings.mc` | Barrel import + own keys | ~20 new |

**Effort estimate.** Largest of the three. **5–8 dev days** for v1 core
(the zone math and the readiness has-check fan-out are genuinely new, not
forked; the Training Status complication read adds a day of new
integration work not in the original estimate, offset by it likely
replacing rather than adding to the from-scratch "readiness" derivation),
**+1–2 days** store/site work.

**Risk.** Confirmed, not just assumed, as the most crowded Connect IQ
category in this document: real named competitors with live store
listings include HR Zones Indicator, Visual HR Zones, ZoneFields HR, and
a whole shipped multi-face family (`ludw`'s Segment34/Segment7 line) that
already reads HR zones, VO2max, time-to-recovery, and the Training Status
complication across several products — i.e. most of this spec's proposed
feature set already exists, from one prolific developer. Differentiation
has to be sharp (HeroSet's mission-bar visual language applied to
training metrics is one candidate hook, not evaluated further here) or
it's a commodity entry in the hardest-to-win category of the three.

**Day 1 checklist.**
1. **Before scaffolding anything**, open the installed SDK's own
   `Toybox.UserProfile`, `Toybox.ActivityMonitor` and
   `Toybox.Complications` API docs and confirm: `getHeartRateZones`/
   `getHeartRateZones2`'s exact `minApiLevel`; `ActivityMonitor.Info
   .stress`/`.timeToRecovery`'s nullability; `UserProfile.getProfile()
   .vo2maxRunning`/`.vo2maxCycling`'s exact type; and
   `Complications.COMPLICATION_TYPE_TRAINING_STATUS`'s `minApiLevel`. Two
   rounds of search-based research (see the corrected field names above)
   already fixed two wrong names and one reversed availability claim —
   there may be more; this is the one spec in this document where a
   primary-source check gates everything else.
2. Scaffold targeting `fr965` (already in the CIQ 4.2+ round AMOLED set,
   and the one device with HeroFace's own complication link independently
   verified on real hardware — useful precedent if the Training Status
   system-complication integration hits similar snags).
3. Build `PaceFaceZones.mc` standalone first, unit-testable with fixture
   zone arrays and fixture HR values, no simulator needed — pure math,
   fastest thing to get right or wrong early.
4. Then the Training Status complication read in isolation (subscribe,
   log the raw string) before `PaceFaceReadiness.mc`'s other fields — it's
   the newest, least-precedented integration in this spec and the one
   most likely to need iteration.
5. Then `PaceFaceReadiness.mc`'s remaining fields, each behind its own
   `has` check, logging what's actually present on the test
   device/simulator (device support for `stress`/`timeToRecovery`/
   `vo2maxRunning` is uneven — expect gaps).
6. Layout/draw code last, once the data layer's shape is known for real.

---

### Ranking

Build order by (addressable market × reuse of existing engine × novelty of
required code), assuming the Barrel extraction happens first:
**A (Field) > B (Rank) > C (Pace)**. Field has the largest untapped,
already-proven device base and zero new domain logic (only new content on
top of APIs HeroFace already uses). Rank is cheapest in absolute effort but
smallest market. Pace has the sharpest differentiation potential but is the
only one needing genuinely new, only-partially-verified sensor logic —
build it last, after the Barrel and the pattern are both proven twice over.

---

## 2. New apps (not watch faces) — build-ready specs

Same rigor as §1, for the other Connect IQ app type Verden hasn't tried
yet: a standalone watch app (like HeroSet) rather than a face. Two
proposals, sized against HeroSet's own measured source (`HeroSet/source/`:
domain layer alone is 1,086 lines across `data/`+`domain/`, measured via
`wc -l`).

### D. Verden Habits — HeroSet's proven game loop, generalized past exercise

**Positioning.** HeroSet's domain layer is two things bolted together: a
**generic daily-goal/streak/XP engine** (`HeroSetRules.mc`, 121 lines —
`xpForReps`, `rankCost`, `rankThreshold`, `rankForXp`: pure functions, no
`Storage`, no exercise-specific logic beyond a 3-item `EXERCISES` symbol
array) and a **push-up-specific auto-rep-counter**
(`HeroSetRepCounter.mc` + `HeroSetSwingTrace.mc` +
`HeroSetThresholdLearner.mc`, 176+108+157 = 441 lines of accelerometer
signal processing — the genuinely hard, still-beta part of HeroSet).
Verden Habits keeps the first, **drops the second entirely**: a
general-purpose daily-habit tracker (up to 3 or 4 user-named habits — read
a book, stretch, drink water, whatever the user types on the phone app),
manually checked off with one button press per habit per day, same
streak/XP/rank loop HeroSet already proved works and already unit-tests
cleanly (pure functions, `HeroSet/CLAUDE.md`: "94 tests"). **This is a
simpler build than HeroSet, not a harder one** — it skips the one part of
HeroSet that's still "beta" and device-unverified for its hardest cases.

**Why it's distinct, not a HeroSet reskin — corrected after a second
research pass.** Different market entirely: HeroSet sells to people who
specifically want push-up/sit-up/squat counting; Habits sells to anyone
who wants a Duolingo-style streak on *anything*, a larger and more
generic Connect IQ Store category. **The original claim that "watch-native,
no phone check-in" is itself the differentiator does not hold** — a
second research pass found at least 7 existing watch-native Connect IQ
habit trackers with live store listings (Habit Tracker, GarminQ, Tracker
Pro 2, Habit Tree, Habbits, Loop Tracker, SHN Habits), one of which
("Habbits") already ships essentially the same loop this spec proposes:
one-tap daily check-off, current streak, longest streak, a percentage
habit score. **The real, narrower, still-defensible differentiator is the
*proven XP/rank/streak game engine* inherited wholesale from HeroSet
(pure, unit-tested, not a fresh implementation) plus visual/brand
continuity with the rest of the Verden family** — not phone-freeness
itself, which is already commodity in this category. Positioning copy
should lead with the game-engine/family angle, not "no phone required."

**Data/domain reuse.** `HeroSetRules`'s XP/rank math (`xpForReps`,
`rankCost`, `rankThreshold`, `rankForXp`) is pure and exercise-agnostic
already — copy as-is (or Barrel it alongside `VerdenFaceKit` as a second,
app-focused Barrel: `VerdenGameKit`, holding the rank/streak math so
*both* HeroSet and Habits import it instead of forking). Storage pattern
(`HeroSetStore.mc`, `HeroSetPersistentStorage.mc`) forks with new keys —
`hero_habit_1_name`, `_2_name`, `_3_name` (user-set strings, phone-side
`Application.Properties`, same pattern `HeroSetSettings`-equivalent apps
use) instead of fixed exercise symbols.

**File/class plan** (fork of HeroSet's UI/data pattern, domain layer
mostly reused via a new `VerdenGameKit` Barrel):
| File | Source | Est. lines |
|---|---|---|
| `HabitsApp.mc` | fork of `HeroSetApp`-equivalent, trivial | ~50 |
| `HabitsRules.mc` | `VerdenGameKit` Barrel import (HeroSet's rank/XP math, generalized) | 0 new |
| `HabitsStore.mc` | fork of `HeroSetStore.mc`, new keys, 3–4 habits instead of 3 fixed exercises | ~150 (smaller — no per-exercise auto-detect state to persist) |
| `HabitsDashboardView.mc` | fork of `HeroSetView`'s dashboard, mission-bars-per-habit | ~80 |
| `HabitsCheckoffView.mc` | new — one-tap "did it" per habit, replaces HeroSet's whole manual-picker + auto-detect UI | ~60 |
| `HabitsSettingsMenu.mc` | fork of HeroSet's settings menu pattern, add "name this habit" via phone `Application.Properties` | ~50 |

**No equivalent of** `HeroSetRepCounter`/`HeroSetSwingTrace`/
`HeroSetThresholdLearner`/`HeroSetSensor*` (accelerometer logic) —
441 lines of HeroSet's hardest, still-beta code that this app doesn't
need at all, since habits are self-reported.

**Effort estimate.** With the domain math Barrel-shared:
**3–5 dev days** for v1 core (dashboard, checkoff, settings, storage),
**+1–2 days** store/site. Smaller than either estimate might suggest
because it inherits a *proven, already-tested* game loop and skips
HeroSet's hardest subsystem outright.

**Risk.** "Habit tracker" is crowded on-watch too, not just on phones —
see the corrected positioning note above. Differentiation is the game
engine and brand family, not technical novelty or platform (watch vs.
phone) alone.

**Day 1 checklist.**
1. Extract `VerdenGameKit` from HeroSet's `HeroSetRules.mc` first (copy the
   four pure functions verbatim into a Barrel — they take no
   exercise-specific input already, so this is closer to a file move than
   a rewrite).
2. Scaffold a Watch App (not a Watch Face) targeting `fr965`, min API
   matching HeroSet's own 3.4.0 floor (nothing here needs anything newer).
3. Build `HabitsStore.mc` and a throwaway CLI-less test harness for it
   first, following `HeroSetStoreTest.mc`'s pattern — storage correctness
   is the one thing genuinely worth getting right before any UI exists.
4. `HabitsCheckoffView.mc` next (the entire interaction is simpler than
   HeroSet's — one button, no picker, no auto-detect state machine).
5. `HabitsSettingsMenu.mc` and the phone-side habit-naming `Properties`
   last — it's the one piece that needs a companion Connect IQ app
   settings page to test end-to-end, so it's the natural last step.

### E. Ready — a standalone readiness/recovery app

**Positioning.** Pace Face's research (§1C) already confirmed real,
usable Connect IQ APIs for stress (`ActivityMonitor.Info.stress`),
recovery time (`ActivityMonitor.Info.timeToRecovery` — corrected field
name, see §1C), and HR history (`ActivityMonitor.getHeartRateHistory()`,
already used by HeroFace). A standalone app built around those — not
bolted onto a running face — is a focused, single-purpose "should I train
hard today or ease off" tool: open it, see a plain-language readiness
read and the numbers behind it, no GPS, no activity recording, nothing
else. Reuses the research already done for Pace Face, so this costs no
new investigation.

**Why it's distinct.** Different app type and different moment: Pace Face
is glanced at all day; Ready is opened deliberately, once a day, before a
workout decision — the same "open, check, close" daily-ritual shape
`HeroSet/PRODUCT.md` describes for HeroSet itself ("a user who comes back
every day because logging a set is faster than skipping it"), applied to a
different question, rather than a face's ambient all-day read.

**Data/domain — corrected and expanded after a second research pass, same
findings as §1C.** `stress`, `timeToRecovery`, resting-HR trend from
`getHeartRateHistory()`, all behind `has` checks. **Garmin's Training
Status label (not the raw numeric Training Load) is confirmed available**
via the system complication `Complications
.COMPLICATION_TYPE_TRAINING_STATUS` (§1C has the full citation) — showing
that string directly (`PEAKING`/`PRODUCTIVE`/`RECOVERY`/etc., Garmin's own
vocabulary) is likely a stronger, cheaper core feature for an app whose
whole job is "should I train today" than reconstructing an approximate
read from raw inputs, and worth making the primary readout with
stress/recovery/HR-trend as supporting detail rather than the other way
around. Also newly surfaced: `SensorHistory.getBodyBatteryHistory`
(confirmed real, same has-check idiom as pressure history) — Body
Battery is arguably the most recognizable "should I train today" number
in Garmin's own ecosystem and isn't in the current design; add it as an
input or explicitly decide not to and say why.

**File/class plan:** essentially `PaceFaceReadiness.mc` (§1C, ~75 lines
with the Training Status read) promoted to a full app with its own
`App`/`Delegate`/`View` (~120 lines) — still by far the smallest of the
five concepts in this document, though the Training Status integration
adds a bit more than the original "confirming which fields are real"
framing implied.

**Effort estimate.** **2–3 dev days** for v1 core (nudged up slightly
from the original 1.5–2.5 to account for the Training Status system
complication being new integration work, not a field read), **+1 day**
store/site (a one-screen app needs less listing content than a face or a
multi-view app). Still the cheapest build in this entire document.

**Risk.** Two risks now, not one. (1) Thin as a standalone product if the
free Garmin Connect phone app already surfaces the same numbers
prominently — still the pitch has to be "on your wrist, no phone, one
glance" or it's redundant, per the original note. (2) **Confirmed by a
second research pass, not just a hypothetical**: real, live competitors
already exist and one is a close positioning match — "HRV and Recovery —
Readiness & Resting HR" (resting HRV plus a guided breathing session,
explicitly "no subscription, no accounts, no data collection" — nearly
the exact pitch this spec proposes, already shipped), plus "AI Coach"
(reads body battery/stress/recovery/resting HR for recommendations) and
"Health Dashboard." The Training Status angle above is the strongest
available differentiator against these, since none of the named
competitors were found reading it — not independently confirmed absent
from them, just not found reading it in this pass's research.

**Day 1 checklist.**
1. **Before writing any code**: check what the stock Garmin watch/Connect
   app already shows for stress/recovery/body battery on a real device —
   this spec's own risk note above. If it's already prominent and
   glanceable there, stop and reconsider positioning before building.
2. If proceeding: scaffold as a Watch App, single view, `fr965`.
3. Reuse `PaceFaceReadiness.mc`'s design (§1C) directly — same fields,
   same `has`-check structure, just promoted from a face row to a
   full-screen layout.
4. First and only real test: confirm the plain-language readiness read
   (e.g. "train hard" / "ease off") maps sensibly across the field
   combinations that are actually possible (stress present + timeToRecovery
   null, both present, both null/device-unsupported) — a small decision
   table, not sensor logic, is the actual product here.

### Ranking

**D (Habits) > E (Ready) > —**: Habits has the larger, proven-pattern
market and reuses the most (a fully tested domain engine); Ready is
cheap but the thinnest differentiation against Garmin's own first-party
data surfaces, so it's the one item in this whole document worth a
gut-check against what stock Garmin already shows before greenlighting.

---

## 3. Features / UX / design / performance — beyond the existing backlogs

Checked against `HeroSet/docs/ideas.md` (don't duplicate its 5 ranked ideas
or its one rejected item — day history) and `HeroFace/docs/plan.md`'s "What's
next" (don't duplicate its device-run, permission-reprompt, listing, or
phase-4 items).

- **HeroFace: a settings-driven accent-color story tied across the family.**
  If concepts A/B/C above ship, a shared accent-color picker convention
  across all Verden faces (already how HeroFace works today, per
  `HeroFace/PRODUCT.md` "Configured through Garmin Connect / Connect IQ app
  settings") becomes a brand asset, not just a per-app setting — worth a
  one-paragraph ADR the day a second face ships, so the pattern is
  deliberate rather than accidental.
- **verden-site: a studio-level "family" page once app #2 (HeroFace) and any
  future face ship**, so a buyer of one Verden app discovers the others —
  currently `src/apps/index.ts` lists apps but the home page's job as a
  cross-sell surface isn't described in `verden-site/CLAUDE.md` one way or
  the other; worth deciding explicitly rather than defaulting silently.
- **HeroSet: the glance view (`ideas.md` #1) and this file's Rank Face (§1B)
  are complementary, not competing** — a glance answers "am I done today"
  without a launch, the face answers it without even a glance. Worth noting
  in whichever ships second that the other exists, so they're built with
  the pairing in mind (e.g., matching visual shorthand for streak).
- **HeroSet: a distinct "approaching goal" haptic cue.** `HeroSetHaptics.mc`
  already tells four tiers apart purely by pulse count (1=rep, 2=exercise
  goal, 3=mission complete, 4=rank up — `pulses(count)`, built from one
  shared vibe-profile shape). A 90%-of-goal cue would need a **genuinely
  different feel** (e.g. one longer pulse via a different
  `VibeProfile` duration, not a 5th pulse-count tier — five short buzzes in
  a row stops being countable by feel, the whole point of the scheme) fired
  once per set from inside the counting loop, gated by a new
  `HeroSetConfig` threshold constant. Fits `HeroSet/PRODUCT.md`'s "used
  mid-exercise... glanceable at arm's length" positioning: the exact moment
  a sweaty user benefits from a felt cue instead of a look. **Effort**:
  small — one new config constant, one new `HeroSetHaptics` method, one
  call site in the counting loop. **Does not** touch Storage, the
  complication contract, or navigation depth (ADR-024), so it's low-risk
  relative to anything touching screens/menus.
- **HeroSet: a "best set today" note — flagged as adjacent to a rejected
  idea, not silently proposed.** `HeroSet/docs/ideas.md`'s "Considered and
  rejected" list has "Day history (last 30 days)," rejected 2026-09-21,
  "don't re-propose without new reasoning." A **single persisted
  all-time-best rep count per exercise** (one integer per exercise,
  updated on save, no list/log/browse UI — closer to a personal-record
  badge than a history view) is a materially different shape of feature,
  but it's adjacent territory and the owner should make that call
  explicitly rather than have it slide in via this document. **Not
  ranked or sized** — surfaced only so the distinction is on record; skip
  unless the owner confirms it's different enough from what was rejected.
- **HeroFace: sunrise/sunset as an optional under-time readout, reusing
  Field Face's already-researched API.** HeroFace already has a `has
  :Weather` path and a weather setting (temperature, per
  `HeroFace/PRODUCT.md`'s "Turn seconds and the temperature on or off").
  `Toybox.Weather.getSunrise(location, date)`/`getSunset(...)` (§1A,
  `(searched, not fetched)`) is the same call Field Face would use — no new
  research cost to add it here too, as an alternative or additional item
  in the weather-adjacent row when the weather setting is on. **Effort**:
  small, one new data field in `HeroFaceReadings.mc`'s gathering pass and
  one row in `HeroFaceFooter.mc`/under-time drawing. **Risk**: row space is
  already tight and measured (`HeroFace/docs/plan.md`'s finish review:
  "the top row is 209 px of usable chord on fr965... the date with a
  temperature needs 243 and would lose its month") — this needs the same
  measured-fit treatment (ADR-018-style), not eyeballing, before it ships.
- **HeroFace: a locally-computed moon phase, no new permission.** Moon
  phase is a pure date-math formula (no API call, no network, no new
  permission — fits "Nothing leaves the watch" and the no-bitmaps
  constraint if drawn as a text fraction or a simple primitive-drawn arc
  rather than an icon). A candidate for the same under-time row as
  sunrise/sunset above, competing for the same tight space — **these two
  ideas should be prioritized against each other, not both assumed to
  fit**, given the row-space constraint just cited. **Effort**: small (one
  pure function, one draw call); the space-budget conflict with
  sunrise/sunset is the real design question, not the math.
- **Performance**: none identified beyond what's already in `IMPROVEMENTS.md`
  item 1 (HeroFace's two uninstrumented `dc.drawText` calls) — no new
  perf findings this pass; a real profiling pass needs a device or simulator
  profiler this container doesn't have.

### HeroFace: 3 ideas from a background sub-agent's full source read, all reusing already-unused native data (no new research, no new permission)

All three read Toybox data `HeroFace/docs/plan.md`'s own "native data a
face can read" table already names as available at the 3.0/2.1 floor but
that nothing in `HeroFace/source` currently reads (confirmed by grep, zero
hits for each). None touch the complication contract, none add a settings
screen (auto-detected/always-on, same pattern as the existing notification
count), so none conflict with `plan.md`'s "Deliberately not planned" list.

- **Phone-disconnected icon in the footer.** `DeviceSettings.phoneConnected`
  is named available at the 3.0 floor (`HeroFace/docs/plan.md:44`) but
  unread. The footer already has a measured overflow mechanism — it drops
  items from the right when they don't fit (`HeroFaceFooter.mc:28-31`) —
  so a 4th icon kind slots into existing, already-measured logic rather
  than adding new layout code. **Honest tradeoff**: the footer already
  carries up to 3 items on some frames and is documented as tight; a 4th
  competes for the same shrinking space on 208–240px screens, where it may
  simply never show. Also: a disconnected phone is common and often
  unremarkable, so it risks being a chronically-lit, low-information icon
  rather than a rare alert worth a glance — worth validating against real
  usage before building. **Effort**: small (one footer `kind`, one drawn
  glyph, one boolean read).
- **Do-not-disturb icon, same footer.** `DeviceSettings.doNotDisturb`
  (API 2.1.0, named at `HeroFace/docs/plan.md:45`, unread in source) — same
  "honest glance" logic (a DND state the user set on purpose and might
  forget is silently swallowing notifications on a face checked "many
  times a day, mid-workout"). **Competes for the exact same footer space
  as the phone-disconnected icon above — these two should not both ship
  without re-checking the footer's total item budget**, the same
  don't-assume-both-fit caveat already applied to sunrise/sunset vs. moon
  phase above. **Effort**: small, same shape.
- **Battery footer: "days remaining" fallback near empty.** "84%" is
  today's number; "3D" (days left, via `System.Stats.batteryInDays`,
  "3.3+, behind `has`", named at `HeroFace/docs/plan.md:43`, unread in
  source) is closer to the decision a low-battery user actually wants.
  Fits the existing terse, iconless-number footer convention exactly
  (DESIGN.md: "the battery number carries no percent sign — the icon
  already says 'battery'"); a natural gate is the same
  `LOW_BATTERY_PERCENT` threshold the existing alert-red coloring already
  uses (`HeroFaceConfig.mc:40`), so it wouldn't invent a second threshold.
  **Honest risk**: `batteryInDays` is a device-computed estimate this
  container can't evaluate for plausibility — needs a real-device sanity
  check (does the number update sensibly) before shipping, same
  "simulator is not device proof" caveat as everything else in this repo.
  **Effort**: small (one `has`-gated read, one formatting branch, one
  string resource mirroring the existing `streak_short` "D" suffix shape).

### HeroSet: 3 ideas from a background sub-agent's full source read

None duplicate `ideas.md`'s 5 ranked ideas or its rejected day-history
item; none touch the complication contract or ADR-024's navigation-depth
invariant.

- **"Reset Detector Learning" menu item.** ADR-040 describes the learned
  rep threshold as a rolling belief where roughly the last 6-7 sets decide
  (`LEARN_MEMORY = 0.85`) with no way to force it back immediately if a
  user's form or wrist placement changes abruptly. `HeroSetStore
  .setLearningState` and `HeroSetThresholdLearner.initialState()` are
  already public — the reset itself is a one-line call per exercise.
  **Cost**: a new menu item id in both jungle's menu resource files, a
  handler, a confirmation toast (this is destructive to weeks of learned
  state, so confirm-before-reset matters), 15-language string keys, a
  screen-fit re-check. **Effort**: small. **Open design question,
  correctly left open rather than assumed**: reset one exercise or all
  three.
- **"Undo last save."** No mechanism today records what the last save
  added — correcting a mis-save means manually dialing in the negative,
  one press per rep (ADR-029: no hold-to-accelerate). A minimal version
  stashes `(exercise, delta, dayKey)` after every
  `HeroSetSaveFeedback.save` and reuses the *existing* manual picker
  pre-seeded with `-delta` — reusing the current Save/Discard/Keep-Editing
  flow rather than a new screen. **Real tradeoff, surfaced not hidden**:
  XP is credited against a high-water-mark ratchet
  (`HeroSetStore.awardXpFor`/`creditKeyFor`) that a negative `add()` does
  not lower by design (ADR-002's anti-farming rule) — so undo-then-redo
  the same day earns 0 XP the second time, a correct but surprising
  consequence that needs explicit confirmation copy, not silent discovery.
  Also needs a day-boundary guard (`ensureCurrentDay()` resets at
  midnight) so a stale undo can't fire against the wrong day. **Effort**:
  small-to-medium — mostly wiring, since it reuses the picker
  view/delegate/exit-menu machinery entirely. **Risk**: the XP-ratchet
  interaction is a real product decision, probably worth its own ADR
  before building, not a silent implementation detail.
- **Optional per-rep haptic mute.** `HeroSetWorkoutView.vibrateForRep`
  fires one pulse on every detected rep, unconditionally, for the whole
  set — 40-50 buzzes in a row for a big set. A mute toggle on just that
  tier (not the rarer goal/mission/rank-up tiers, which stay untouched)
  serves users with motion sensitivity or who simply trust the count.
  **Not a duplicate** of this document's own "approaching-goal" haptic
  idea above — that's a new, additive tier; this is a mute on an existing
  one, orthogonal to it. **Effort**: small (one storage key defaulting
  true, one `ToggleMenuItem` following the existing `sync_toggle`
  pattern, one gate in `vibrateForRep`). **Lowest-risk of the three** —
  no storage-key interactions, no navigation change, no ratchet
  interaction.

---

## 4. New watch / device support (compatibility expansion)

Pulled directly from the "Not yet supported, and why" tables already in
`HeroSet/docs/compatibility.md` and `HeroFace/docs/compatibility.md` —
ranked by (device count reachable × blocker cost), not re-derived here.

| Opportunity | Blocks | Reachable now | Cost |
|---|---|---|---|
| HeroFace phase 4: rectangle (Venu Sq2 ×4, Venu X1) | New stacked (non-round) layout | 5 products | Medium — already scoped in `HeroFace/docs/plan.md` phase 4, just not started |
| HeroFace phase 4: Instinct semi-octagon sub-window | Layout doesn't model the cut-out | 8 products | Medium — same doc, same phase |
| HeroSet: touch watches (Venu, Vivoactive, Approach) | No UP/DOWN keys; picker/workout are button-first per ADR-029 | `venu3`, `venu3s`, `venu441mm`, `vivoactive5`, `vivoactive6`, `approachs50`, `approachs7047mm` | High — needs a touch/swipe input path and new hint copy, a real UX redesign of the picker, not a manifest add |
| HeroSet: pre-3.4 Forerunners with `has :showToast` guard | Missing save-confirmation API | FR945/745/245M (candidate wave already named in the compatibility doc) | Low — the doc already identifies the guard needed; smallest lift on this list |
| HeroSet: Forerunner 55 (208px) | Dashboard rows overlap `everyScreenFitsThisDisplay` | 1 product | Medium — needs a genuinely smaller layout variant, not a tweak |
| Both apps: Instinct MIP / semi-octagon family beyond HeroFace's phase 4 list | Same sub-window modeling problem, plus HeroSet's own gap | Instinct 2/3 MIP, Instinct E, Descent G1 | High — blocked on the same layout-modeling work as the HeroFace phase-4 item, so sequence it after that lands |

The one **not** listed here on purpose: watches below Connect IQ 3.0/3.4 —
both compatibility docs already give a clear, considered "no" (old API
surface, 4-bit color, `Application.Properties` missing), and neither
document leaves it open as a "maybe."

---

## Next step

Once uizze.com is connected, the five build-ready concepts in §1 (Field,
Rank, Pace) and §2 (Habits, Ready) are the right size to hand over for
actual visual exploration (palette, layout, a first-screen mock) — this
doc deliberately stopped at positioning/cost/risk/file-plan so that tool
does the design work once, instead of this session guessing at it twice.
Suggested order to design in: whichever wins the build-order ranking at
the end of each section (Field, then Habits) first, since those are also
the cheapest to build — a design that's already validated against a cheap
build is worth more than one sitting on the most expensive idea.
