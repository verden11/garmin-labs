# Opportunities — new watch faces, new apps, features, UX/design, performance, device support

Status: 2026-09-25, refined same day after a deeper pass (API research +
five build-ready product specs added to what was originally three
lightly-sketched concepts). Grounded in what's already documented
(`HeroSet/docs/`, `heroFace/docs/`, `heroFace/PRODUCT.md`,
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
`heroFace/source/` is 1,511 lines across 20 files (measured: `wc -l
heroFace/source/*.mc`) — the reference point every estimate below is sized
against.

Two things every concept below respects, because they're already decided:
- **One HeroSet complication, not several** (`heroFace/docs/plan.md`:
  "Deliberately not planned: a second complication for HeroSet"). Any new
  face that wants the HeroSet link reads the *same* private complication
  HeroFace already subscribes to — it doesn't ask HeroSet to publish a
  second one, unless a spec below says otherwise and flags it as a
  cross-folder contract change.
- **Phase 4 (rectangle, Instinct sub-window) is HeroFace's own planned
  extension**, not a new product (`heroFace/docs/plan.md` phase 4) — scoped
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
(`number()`/`flag()`/`read()` in `heroFace/source/HeroFaceSettings.mc`)
are the three pieces every concept below would otherwise re-copy by hand.

**Recommendation**: before or alongside building the first new face,
extract those three into a `VerdenFaceKit` Barrel (generalizing
`HeroFaceLayout`'s row-stacker so it isn't heroFace-specific), and have
heroFace itself depend on the Barrel too, so there's one copy, not two.
**Cost**: roughly half a day to a day, one-time, done against heroFace
(which is already built and tested, so the extraction has something
correct to extract from). **Payoff**: starts with the second new face and
compounds with the third — every estimate below assumes the Barrel exists;
without it, add ~1 day per face for hand-copying and re-adapting those
three files instead of importing them.

---

### A. Field Face — battery-first, MIP-native, outdoor contrast

**Positioning.** HeroFace's finish review treats "battery is the currency
on this platform" as an AMOLED/always-on problem
(`heroFace/docs/plan.md`, finish review item 5) and its visual system
(gold/blue/green on black, `heroFace/PRODUCT.md` "Brand Commitments") is an
AMOLED design carried onto MIP screens because it's one build for both.
Field Face flips the premium: built *for* the MIP/outdoor segment, where
always-on has **no burn-in cost at all** — MIP watches show the full face
all the time (`heroFace/docs/plan.md`: "MIP watches show the full face all
the time"), so this face needs **no AOD/sleep draw path at all** — a real
simplification versus HeroFace, not just a reskin.

**Target devices (v1, launch scope).** Reuse HeroFace's own MIP round
product list exactly — same shape, same evidence pattern, already
individually verified against `everyStateFitsThisDisplay`
(`heroFace/docs/compatibility.md`):
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
  no-barometer devices (`heroFace/source/HeroFaceMetrics.mc` is the
  pattern to fork).
- Barometric pressure trend via `Toybox.SensorHistory` (gated behind
  `Toybox has :SensorHistory` and a barometer check, same style as
  HeroFace's existing `has` guards) `(searched, not fetched)`.
- Sunrise/sunset via `Toybox.Weather.getSunrise(location, date)` /
  `getSunset(location, date)`, both returning `Time.Moment or Null`, taking
  a `Position.Location` and a `Time.Moment` — confirmed real signatures via
  search of the official `Toybox.Weather` docs `(searched, not fetched)`.
  HeroFace already has a `has :Weather` path (its weather setting), so the
  has-check pattern exists to fork from `heroFace/source/HeroFaceSettings.mc`
  and wherever HeroFace reads `Weather.getCurrentConditions()`.
- No HeroSet complication read in v1 — this face's whole positioning is
  device-native/outdoor, not HeroSet-dependent. Could add the same
  optional link HeroFace has as a v2 bonus, reusing `HeroFaceContract`/
  `HeroFaceLink` unchanged (same complication, no contract change).

**File/class plan** (forked from heroFace's pattern, or imported from the
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
phase 2, "partly done" per `heroFace/docs/plan.md`): listing copy,
per-screen-size screenshots from the simulator, `verden-site/src/apps/
field/` (landing/support/privacy), cross-linked from HeroFace's and
HeroSet's listings.

**Effort estimate.** ~350 new/forked lines with the Barrel in place
(vs. heroFace's 1,511 total) — smaller than heroFace itself because it
skips AOD, partial-update, and the complication-link/parsing code
entirely. **2–4 dev days** for a store-buildable v1 core, **+1–2 days**
for store listing and site pages, following heroFace's own timeline as
the closest reference point (`heroFace/docs/plan.md`'s dated decisions
show it went from spike to store-ready inside about a day of focused
work, and Field Face does strictly less than heroFace).

**Risk.** "Outdoor/battery-first watch face" is a crowded Connect IQ
Store category — differentiation has to be real (barometric trend +
sunrise/sunset are genuinely useful, not decorative) or it's a commodity
entry with a different color scheme.

**Day 1 checklist.**
1. Extract the `VerdenFaceKit` Barrel from heroFace first (see above) —
   everything below assumes it exists.
2. Scaffold a new Connect IQ project (`Monkey C: New Project` in the SDK's
   VS Code extension, or `monkeyc`'s project-new equivalent), type Watch
   Face, product `fr255` (smallest 260px target, catches layout problems
   earliest), min API matching HeroFace's own floor.
3. Add the `VerdenFaceKit` Barrel dependency to the new manifest + jungle.
4. Write `FieldFaceLayout.mc` first, off the Barrel's row-stacker, and get
   a static time-only screen building and rendering in the simulator
   before adding any data row — this is the same order HeroFace's own
   spike phase used (`heroFace/docs/plan.md` phase 0).
5. Add `ActivityMonitor.Info` steps/intensity/floors next (proven API, no
   risk), then `FieldFaceWeather.mc`'s sunrise/sunset/pressure (the
   `(searched, not fetched)` APIs) last, so any surprise there doesn't
   block a working v0.
6. First test to write: a screen-fit case per the 23-product list above,
   following `HeroFaceScreenFitTest.mc`'s exact pattern.

---

### B. Rank Face — a HeroSet-only companion face

**Positioning.** Where HeroFace is deliberately useful *without* HeroSet
(`heroFace/PRODUCT.md` principle 2: "every slot has a working default"),
this is the opposite bet: a face that assumes HeroSet is installed and
puts rank, streak and per-exercise progress front and center as the
primary display, not one of several fallback metrics.

**Data source — checked against the actual contract, not assumed.** The
private complication's value is `v|dayKey|push|sit|squat|rank|rankPct|
streak|lastDoneDay|goal` (`heroFace/PRODUCT.md`, confirmed against
`heroFace/source/HeroFaceContract.mc`). That gives Rank Face, with **zero
changes to HeroSet or the contract**: rank number, **percent** to next
rank (`rankPct`), today's push/sit/squat counts individually, streak, and
today's goal. **It does not give a raw XP-to-next-rank number** — only a
percentage. An earlier draft of this section described "XP-to-next-rank as
a literal number"; that's not available from today's contract and would
need an 11th field appended to the complication value, which is a
cross-folder contract change (`HeroSetComplicationPublisher` in HeroSet,
`HeroFaceContract.parse` in heroFace, and ADR-044 amended, **all in the
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
   `heroFace/docs/go-to-market.md`, so the hardest part is tested on known
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
   value format (the exact string from `heroFace/PRODUCT.md`), confirming
   rank/rankPct/streak/goal extraction before any drawing exists.

---

### C. Pace Face — a running-metrics face, filling HeroSet's stated gap

**Positioning.** HeroSet's own one-line description states "No GPS/
distance" — it's explicitly a reps/XP app, not a running app. Neither
existing product reads HR zones or recovery-style metrics. This is the
only concept here needing genuinely new domain logic, not a layout reskin
of existing data — the real differentiator, and the real risk (see below).

**Data sources — real APIs, checked, with what's confirmed vs. not:**
- `UserProfile.getHeartRateZones(sport as UserProfile.SportHrZone)` — an
  `Array` of zone threshold bpm values `(searched: official
  Toybox.UserProfile docs, forum confirmation)`. `getHeartRateZones2(sport
  as Activity.Sport) as Array<Number> or Null` also exists, added in SDK
  9.1.0 `(searched, not fetched — verify minApiLevel against the installed
  SDK before use)`.
- `ActivityMonitor.Info.stress` — current stress score, rolling 30s
  average `(searched: official Toybox.ActivityMonitor.Info docs)`.
- `ActivityMonitor.Info.recoveryTime` — hours since last activity's
  recovery need, **nullable** `(searched, same source)`.
- `ActivityMonitor.Info.vo2Max` — confirmed to exist as a field
  `(searched, same source)`, exact type/nullability not independently
  verified here — check before use.
- **Explicitly not to build against**: Garmin's proprietary "Training
  Status"/"Training Load" figures. Search turned up no confirmed Connect
  IQ SDK exposure of those specific derived metrics (as opposed to their
  raw inputs — stress, recovery time, HR history — which are confirmed).
  **Recommendation**: build the "readiness" read from `recoveryTime` +
  `stress` + a simple resting-HR trend from
  `ActivityMonitor.getHeartRateHistory()` (already used by HeroFace, so
  the API call pattern is proven in this codebase), not from a metric
  that may not be readable at all. Whoever builds this should re-check
  directly against the installed SDK's `Toybox.ActivityMonitor` docs
  before committing to the "readiness" feature's scope.

**Target devices (v1).** CIQ 4.2+ round AMOLED Forerunners only, so
`getHeartRateZones2`'s likely-higher `minApiLevel` isn't a blocker on
day one: `fr965`, `fr970`, `fr570`, `fr170`, `fr165`, `fr265`, `fr70` — 7
products, all already in HeroFace's own compatibility table so the round
AMOLED layout math is proven. Widen after v1 once the zone/readiness
logic is confirmed correct against real hardware.

**File/class plan:**
| File | Source | Est. lines |
|---|---|---|
| `PaceFaceApp.mc` / `Delegate.mc` | new, trivial | ~70 combined |
| `PaceFaceView.mc` | fork of `HeroFaceView.mc`'s structure | ~110 |
| `PaceFaceLayout.mc` | Barrel import + new rows | ~50 new |
| `PaceFaceDraw.mc` | Barrel import, unchanged | 0 new |
| `PaceFacePalette.mc` | new — zone-colored (a color per HR zone is the one place per-zone color, not just accent color, earns its keep) | ~30 |
| `PaceFaceZones.mc` | new: HR-zone math against `getHeartRateZones`/`2` | ~50 |
| `PaceFaceReadiness.mc` | new: `recoveryTime`/`stress`/HR-trend formatting, all behind `has` checks since these are newer fields not on every device | ~60 |
| `PaceFaceSettings.mc` | Barrel import + own keys | ~20 new |

**Effort estimate.** Largest of the three. **5–8 dev days** for v1 core
(the zone math and the readiness has-check fan-out are genuinely new, not
forked), **+1–2 days** store/site work.

**Risk.** Also the most crowded Connect IQ category — running-metric
faces are extremely common. Differentiation has to be sharp (HeroSet's
mission-bar visual language applied to training metrics is one candidate
hook, not evaluated further here) or it's a commodity entry in the
hardest-to-win category of the three.

**Day 1 checklist.**
1. **Before scaffolding anything**, open the installed SDK's own
   `Toybox.UserProfile` and `Toybox.ActivityMonitor` API docs and confirm
   `getHeartRateZones`/`getHeartRateZones2`'s exact `minApiLevel` and
   `ActivityMonitor.Info.stress`/`.recoveryTime`/`.vo2Max`'s nullability —
   every estimate and device list above assumed search-result accuracy,
   not a primary-source read. This is the one spec in this document where
   that check gates everything else.
2. Scaffold targeting `fr965` (already in the CIQ 4.2+ round AMOLED set).
3. Build `PaceFaceZones.mc` standalone first, unit-testable with fixture
   zone arrays and fixture HR values, no simulator needed — pure math,
   fastest thing to get right or wrong early.
4. Then `PaceFaceReadiness.mc`, each field behind its own `has` check,
   logging what's actually present on the test device/simulator (device
   support for `stress`/`recoveryTime`/`vo2Max` is uneven — expect gaps).
5. Layout/draw code last, once the data layer's shape is known for real.

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

**Why it's distinct, not a HeroSet reskin.** Different market entirely:
HeroSet sells to people who specifically want push-up/sit-up/squat
counting; Habits sells to anyone who wants a Duolingo-style streak on
*anything*, a much larger and more generic Connect IQ Store category (habit
trackers are a proven mobile-app category; a watch-native one with no
phone-required check-in is a real differentiator versus phone habit apps).

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

**Risk.** "Habit tracker" is a crowded category on phones; the pitch has
to be "fully on your watch, no phone check-in required, no subscription"
to stand out — differentiation is positioning, not technical.

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
recovery time (`ActivityMonitor.Info.recoveryTime`), and HR history
(`ActivityMonitor.getHeartRateHistory()`, already used by HeroFace). A
standalone app built around **just** those — not bolted onto a running
face — is a focused, single-purpose "should I train hard today or ease
off" tool: open it, see a plain-language readiness read and the numbers
behind it, no GPS, no activity recording, nothing else. Reuses the exact
research already done for Pace Face, so this costs no new investigation.

**Why it's distinct.** Different app type and different moment: Pace Face
is glanced at all day; Ready is opened deliberately, once a day, before a
workout decision — the same "open, check, close" daily-ritual shape
`HeroSet/PRODUCT.md` describes for HeroSet itself ("a user who comes back
every day because logging a set is faster than skipping it"), applied to a
different question, rather than a face's ambient all-day read.

**Data/domain.** Same fields as Pace Face's `PaceFaceReadiness.mc` design
(§1C) — `stress`, `recoveryTime`, resting-HR trend from
`getHeartRateHistory()` — **all behind `has` checks**, same caveat as §1C:
Garmin's proprietary Training Status/Load figures are **not** confirmed
readable via the Connect IQ SDK and this app should not depend on them
being available.

**File/class plan:** essentially `PaceFaceReadiness.mc` (§1C, ~60 lines)
promoted to a full app with its own `App`/`Delegate`/`View` (~120 lines) —
by far the smallest of the five concepts in this document, because the
hard part (confirming which readiness-adjacent fields are real) is
already done above.

**Effort estimate.** **1.5–2.5 dev days** for v1 core, **+1 day**
store/site (a one-screen app needs less listing content than a face or a
multi-view app). Cheapest build in this entire document.

**Risk.** Thin as a standalone product if the free Garmin Connect phone
app already surfaces the same numbers prominently — the pitch has to be
"on your wrist, no phone, one glance" or it's redundant. Worth checking
what the stock Garmin watch face/widget already shows before committing
to this one, since it's the one idea here that risks competing with
Garmin's own first-party surface rather than filling a gap.

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
   combinations that are actually possible (stress present + recoveryTime
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
or its one rejected item — day history) and `heroFace/docs/plan.md`'s "What's
next" (don't duplicate its device-run, permission-reprompt, listing, or
phase-4 items).

- **HeroFace: a settings-driven accent-color story tied across the family.**
  If concepts A/B/C above ship, a shared accent-color picker convention
  across all Verden faces (already how HeroFace works today, per
  `heroFace/PRODUCT.md` "Configured through Garmin Connect / Connect IQ app
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
- **heroFace: sunrise/sunset as an optional under-time readout, reusing
  Field Face's already-researched API.** heroFace already has a `has
  :Weather` path and a weather setting (temperature, per
  `heroFace/PRODUCT.md`'s "Turn seconds and the temperature on or off").
  `Toybox.Weather.getSunrise(location, date)`/`getSunset(...)` (§1A,
  `(searched, not fetched)`) is the same call Field Face would use — no new
  research cost to add it here too, as an alternative or additional item
  in the weather-adjacent row when the weather setting is on. **Effort**:
  small, one new data field in `HeroFaceReadings.mc`'s gathering pass and
  one row in `HeroFaceFooter.mc`/under-time drawing. **Risk**: row space is
  already tight and measured (`heroFace/docs/plan.md`'s finish review:
  "the top row is 209 px of usable chord on fr965... the date with a
  temperature needs 243 and would lose its month") — this needs the same
  measured-fit treatment (ADR-018-style), not eyeballing, before it ships.
- **heroFace: a locally-computed moon phase, no new permission.** Moon
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
  item 3 (heroFace's two uninstrumented `dc.drawText` calls) — no new
  perf findings this pass; a real profiling pass needs a device or simulator
  profiler this container doesn't have.

---

## 4. New watch / device support (compatibility expansion)

Pulled directly from the "Not yet supported, and why" tables already in
`HeroSet/docs/compatibility.md` and `heroFace/docs/compatibility.md` —
ranked by (device count reachable × blocker cost), not re-derived here.

| Opportunity | Blocks | Reachable now | Cost |
|---|---|---|---|
| HeroFace phase 4: rectangle (Venu Sq2 ×4, Venu X1) | New stacked (non-round) layout | 5 products | Medium — already scoped in `heroFace/docs/plan.md` phase 4, just not started |
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
