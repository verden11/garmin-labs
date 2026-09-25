# Opportunities — new watch faces, features, UX/design, performance, device support

Status: 2026-09-25. Growth-oriented ideation, grounded in what's already
documented (`HeroSet/docs/`, `heroFace/docs/`, `heroFace/PRODUCT.md`,
`verden-site/CLAUDE.md`) so nothing here contradicts a settled decision or
re-proposes something already rejected. This is planning text only — no
mockups, no visual specs. Visual design for anything here belongs in the
design tool (uizze.com) once connected; keeping this doc concept-level on
purpose so that work isn't duplicated or wasted here first.

This sits alongside two existing backlogs, each with a different job:
- `HeroSet/docs/ideas.md` — HeroSet's own feature ideas, ranked, with a
  "considered and rejected" list. Don't re-propose from there.
- `IMPROVEMENTS.md` (root) — small, cheap, already-verified correctness/perf
  fixes for the existing three projects.

This file is the third kind: bigger swings — new products, not-yet-planned
features, and device-support expansion — sized for someone to pick up, not
implemented or verified here (no `monkeyc`/simulator/device in this
container; everything below is a proposal, not a measured finding).

---

## 1. New, distinct watch faces

Verden is explicitly set up for more than one app
(`verden-site/CLAUDE.md`: "HeroSet first app; more apps come later"), and
HeroFace already proved the pattern: shared drawing/layout engine
(`HeroFaceDraw`, measured-text-fit, proportional `HeroFaceLayout`), one
private complication for HeroSet integration (ADR-044), one build per shape.
Concepts below reuse that same engine and pattern rather than each starting
from zero — the cost of a new face is mostly design + content, not new
plumbing.

Two things every concept below respects, because they're already decided:
- **One HeroSet complication, not several** (`heroFace/docs/plan.md`:
  "Deliberately not planned: a second complication for HeroSet"). Any new
  face that wants the HeroSet link reads the *same* private complication
  HeroFace already subscribes to — it doesn't ask HeroSet to publish a
  second one.
- **Phase 4 (rectangle, Instinct sub-window) is HeroFace's own planned
  extension**, not a new product (`heroFace/docs/plan.md` phase 4). A
  rectangle- or Instinct-shaped face is scoped below under "device support,"
  not listed as a new distinct product, so it doesn't compete with that
  existing plan.

### A. Rank Face — a HeroSet-only companion face

**What.** Where HeroFace is deliberately useful *without* HeroSet
(`heroFace/PRODUCT.md` principle 2: "every slot has a working default"),
this is the opposite bet: a face that assumes HeroSet is installed and puts
XP, rank progress and streak front and center as the primary display — not
one of several fallback metrics. Steps/intensity/floors, if shown at all,
are the secondary row.

**Why it's distinct, not a HeroFace reskin.** HeroFace's whole design
constraint is "no watch draws an empty bar" — it has to hedge for the
90%+ who don't own HeroSet. A HeroSet-only face doesn't carry that
constraint, so it can spend its whole layout budget on rank/XP/streak
detail HeroFace can't justify (e.g., XP-to-next-rank as a literal number,
not just a ring fraction; per-exercise breakdown pulled from the same
complication value HeroFace already parses).

**Who buys it.** Existing HeroSet owners who already bought in for the
XP/rank/streak game loop and want it as their watch face, not just their
app. Natural cross-sell from inside HeroSet (a "get the face" mention on
its dashboard) and from HeroFace's own listing ("or get the rank-first
version if you own HeroSet").

**Cost.** Small-to-medium relative to HeroFace's own build: reuses
`HeroFaceContract.parse`, the private-complication subscribe flow, and the
whole `HeroFaceDraw`/measured-layout engine — none of that is rebuilt. New
work is mostly a new `HeroFaceLayout`-equivalent row stack and new draw
code for the XP/rank detail view, plus its own store listing and
`verden-site/src/apps/<slug>/` pages (studio pattern already documented).

**Risk.** Only sells to the existing HeroSet install base — the smallest
addressable market of the concepts here. Needs the complication contract to
hold steady (ADR-044) since it depends on it more heavily than HeroFace
does (no fallback path to fall back to).

### B. Field Face — battery-first, MIP-native, outdoor contrast

**What.** Where HeroFace's finish review explicitly treats "battery is the
currency on this platform" as an AMOLED/always-on problem
(`heroFace/docs/plan.md`, finish review item 5), this face flips the
premium: built *for* the MIP/outdoor segment (fēnix, Enduro, Descent, MARQ —
already 30 of HeroFace's 117 supported products per
`heroFace/docs/compatibility.md`'s MIP rows) where always-on has no burn-in
cost at all. High-contrast, minimal color, large numerals, a look tuned for
direct sunlight rather than AMOLED's black background + accent-color
language.

**Why it's distinct.** HeroFace's whole visual system (gold/blue/green on
black, per `heroFace/PRODUCT.md` "Brand Commitments") is an AMOLED design
carried onto MIP screens because it's one build for both — it works, but it
isn't designed *for* MIP contrast the way this would be. Positioning this
as "the outdoor watch face" targets the buyer of a fēnix/MARQ/Descent
specifically, a segment neither HeroSet nor HeroFace markets to directly
today (HeroSet doesn't do GPS/distance at all, "no GPS/distance" per its own
one-line description).

**Cost.** Medium. Same drawing engine, but a genuinely different visual
system (new palette, new layout proportions optimized for MIP's lower
refresh/contrast), and its own device-compatibility pass — likely a subset
of HeroFace's MIP-capable products rather than all 117, at least at launch.

**Risk.** "Outdoor/battery-first face" is a crowded Connect IQ Store
category — differentiation has to be real (e.g., a genuinely useful
data field set: sunrise/sunset, current pressure trend from the barometer
already used for HeroFace's floors fallback) not just a color swap.

### C. Pace Face — a running-metrics face, filling HeroSet's stated gap

**What.** HeroSet's own one-line description says "No GPS/distance" — it's
explicitly a reps/XP app, not a running app. A running-focused face (pace
zones, HR zones, a simple "today's training load" read from
`ActivityMonitor`, no GPS-track drawing needed since a face isn't an
activity screen) fills a gap the existing two products don't touch, and
targets Forerunner buyers directly — a device family both existing apps
already support in numbers (`fr965`, `fr955`, `fr170`, `fr255`, `fr265`, …
across both compatibility tables).

**Why it's distinct.** Neither HeroSet nor HeroFace reads HR zones or
training-load style metrics today; this is new domain logic, not a
reskin — the actual differentiator versus A and B above.

**Cost.** Medium-to-high — this is the one concept here that needs new
sensor-reading logic (HR zone thresholds, `ActivityMonitor` training-adjacent
fields), not just new layout on top of the existing `HeroFaceContract`
parsing. Worth scoping precisely against what `Toybox.ActivityMonitor` and
`Toybox.SensorHistory` actually expose before committing — that's a design
question for whoever builds it, not answered here.

**Risk.** Biggest scope of the three; also the most crowded Connect IQ
category (running-metric faces are extremely common) — differentiation has
to be sharp (HeroSet's mission-bar visual language applied to training
metrics, is one candidate hook) or it's a commodity entry.

### Ranking

Build order by (addressable market × reuse of existing engine × novelty of
required code): **B (Field) > A (Rank) > C (Pace)** — B has the largest
untapped, already-supported device base and needs no new domain logic; A is
cheapest to build but smallest market; C has real differentiation potential
but is the only one requiring genuinely new sensor logic.

---

## 2. Features / UX / design / performance — beyond the existing backlogs

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
- **HeroSet: the glance view (`ideas.md` #1) and this file's Rank Face (1A)
  are complementary, not competing** — a glance answers "am I done today"
  without a launch, the face answers it without even a glance. Worth noting
  in whichever ships second that the other exists, so they're built with
  the pairing in mind (e.g., matching visual shorthand for streak).
- **Performance**: none identified beyond what's already in `IMPROVEMENTS.md`
  item 3 (heroFace's two uninstrumented `dc.drawText` calls) — no new
  perf findings this pass; a real profiling pass needs a device or simulator
  profiler this container doesn't have.

---

## 3. New watch / device support (compatibility expansion)

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

Once uizze.com is connected, concepts A/B/C in section 1 are the right size
to hand over for actual visual exploration (palette, layout, a first-screen
mock) — this doc deliberately stopped at positioning/cost/risk so that
tool does the design work once, instead of this session guessing at it
twice.
