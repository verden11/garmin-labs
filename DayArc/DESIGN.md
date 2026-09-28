---
name: DayArc / DayArc Pro
description: One hero read per time window (weather / stress / Body Battery / time+date); Pro adds a measured secondary field grid under the same hero. A hue per window, a fixed hue per icon type, no verdicts.
colors:
  ground: "#000000"
  text: "#FFFFFF"
  muted: "#AAAAAA"
  accent_morning: "#FFAA00"
  accent_midday: "#55FFFF"
  accent_evening: "#FF55AA"
  accent_night: none — night has no hero, no icon, stays muted-only
  grid_icon_colors: 14 fixed 64-colour-safe hues, one per icon TYPE, never per value (ADR-013) — see "Iconography" below for the table
type:
  clock: FONT_NUMBER_MEDIUM, falls back to FONT_NUMBER_MILD (DayArcLayout.CLOCK_FONTS) — width-fit against the round chord, not a fixed pick
  label: FONT_TINY / FONT_XTINY (LABEL_FONTS) — hero label, night's date line
  hero: FONT_NUMBER_HOT / FONT_NUMBER_MEDIUM / FONT_NUMBER_MILD (HERO_FONTS) — the one number every window (but night) leads with
  sub: FONT_TINY / FONT_XTINY (SUB_FONTS) — the neutral line under the hero
  cell: FONT_XTINY (Pro's grid, fixed — a grid row that itself picked a larger font per-cell would misalign the two columns)
icons:
  source: Tabler Icons (MIT license), github.com/tabler/tabler-icons — real paths adapted, not drawn from scratch (ADR-013)
  hero: one glyph per window (weather condition, stress wave, battery shell), single-hue, tied to that window's own accent — colour still marks "the hero," nothing else
  grid (Pro only): 14 glyphs, each a fixed hue by icon TYPE forever (heart always red, flame always orange...), never by the value shown — see ADR-013
  date: shown every window now, not just night (ADR-013)
---

Owned by `watch-design-lead`. Shared by both listings — Pro's grid is additive, it never changes
the hero's type, colour, or position.

**Status 2026-09-28, built:** ADR-013's redesign is now in `source/` (was mockup-only when this
section was first written; that status paragraph is superseded, kept below for the record of what
"approved" meant before it was built). Simulator-tested on fr965/approachs50/venusq2/venux1, both
jungles (`docs/plan.md` "Implementation status"); the full 69-product compile sweep runs alongside
this build. **Still no real-device evidence and no owner screenshot review of the actual build** —
`docs/publish-checklist.md` gate 4 stays open for that specifically; a mockup or a simulator render
is not device proof, same rule as everywhere else in this studio.

**Superseded status, 2026-09-28, earlier the same day:** direction approved by the owner via an
iterated HTML/SVG mockup (screenshot-verified at each pass, not just read as markup), not yet built
in Monkey C. This section and "Iconography" below described that approved direction before it was
implemented.

## Layout

Vertical stack, centred on `DayArcLayout.centerX()`, every band's height and every text row's fit
computed off the shorter screen side (`_d`), the exact chord-inset math TwoSuns's own layout
already validated across all 69 products (`leftInset`/`rightInset`, reused verbatim — see
`docs/decisions.md` ADR-001). Every centred row — clock, label, hero, sub, and the grid — is
measured against this chord (`DayArcLayout.rowMaxWidth`), not a flat margin; an earlier build only
applied it to the grid, caught by `watch-design-reviewer` 2026-09-28 and fixed. A rectangular AMOLED
product gets the same round-centred content, extra width becomes side margin — not a bug, TwoSuns's
own convention.

Top to bottom, every window but night:
0. **Window-progress arc** (ADR-013) — a thin arc across the top of the circle, in the window's own
   accent, showing progress through the *current window only* (e.g. how far through the 5:00–9:30
   morning block the clock is right now) — not TwoSuns's full 24h ring, a deliberately different
   shape so the two listings' own signature elements never get confused with each other. Morning/
   midday/evening only; night carries no arc, same restraint as everything else in that window.
1. Clock (small-medium, muted-white) — always present, every window, both densities.
2. **Date** (muted, small) — now shown in every window, not just night (ADR-013; was night-only).
   No setting to hide it — ADR-011 (no runtime settings surface) still holds; this is a content
   change, not a new toggle.
3. Hero label (muted, small) — omitted when the read itself is the label (morning's temperature has
   none; midday/evening name the metric).
4. **Hero icon + hero value**, side by side as one centred group (ADR-013) — a single line-icon
   (Tabler Icons, recoloured) beside the number, both the same accent hue as the window. The value
   stays the largest single element on screen in Simple, and the largest and first-drawn element in
   Pro, ahead of the grid — the icon is a companion, it never gets its own competing line.
5. Gauge (stress/Body Battery only) — a single-hue, single-brightness horizontal fill, no
   threshold tier, no colour change, no threshold word (ADR-006). An earlier version dimmed above a
   threshold that, for stress, landed exactly on Garmin's own official band boundary — removed
   rather than defended.
6. Sub line (muted, small) — the neutral second line ("$1$ of 100", "23% rain UV 4", or the
   empty-state sentence). Omitted where the source data has none to add (midday's sub is `null`
   whenever stress itself is valid — the gauge already carries that row's information).
7. **Pro only:** a faint 1px divider (ADR-013) marking where "glance here first" (clock, date, hero)
   ends and "look after" (the grid) begins, then a 2-column grid of icon/label/value cells below it,
   sized per row by `DayArcGrid` — each row takes its OWN chord width (`DayArcLayout.gridRowColumnWidth`,
   wider near the vertical centre, narrower near the bezel) and is drawn only if both its cells leave
   the value at least three digits of room (cloud review, 2026-09-28: the earlier single "narrowest
   row" column width starved every row to fit the last, and its capacity floor ignored the
   icon + label + value cell shape); rows drop from the end, never the middle, never an assumed number. On the smallest round screen in the set this will show fewer than Pro's 8-12
   target; that's the layout working as designed, not a bug (ADR-009 already anticipates this).
   Each cell reserves a measured share for its label (capped at 55% of the column, e.g. a calendar
   event title) and gives the value what's left, rather than truncating both independently against
   the whole column — the earlier version of this could collide, worst case on the midday calendar
   cell. **Icons and the drop-label treatment below apply to midday and evening only** — morning's
   Pro grid (sunrise, sunset, date, battery %, HR, steps, floors, notifications) is unchanged by
   ADR-013 and stays plain text; the owner's own request that triggered this redesign named midday
   and evening specifically, and ADR-013's icon table only ever covered those two windows' 17 fields.
   Each of those 17 grid cells carries a small icon in its own fixed hue (ADR-013) — **9 of the 17**
   drop the text label entirely where the icon alone already reads (HR ×2, floors, steps ×2,
   calories ×2, notifications, temperature — corrected 2026-09-28 from an earlier miscount of 7 in
   this doc's own first pass; HR/steps/calories each appear in both windows' grids), keeping the
   label only where the icon can't carry the meaning alone (next event, intensity minutes, run/wk,
   bike/wk, recovery, respiration, pulse ox, VO2max — 8 fields, once each).

Night: clock, then the date line, nothing else — no arc, no icon, no gauge, no grid, no hero, the
one window where Pro and Simple render identically. Deliberately unchanged by ADR-013: night already
had its date line and was already the studio's reference case for "the simplest window." **Decided
during implementation, 2026-09-28:** the AMOLED idle/always-on frame does NOT show the date either,
even though it's now shown in every *active* window — DESIGN.md didn't say either way when this was
approved as direction; the idle frame's own existing philosophy is "fewest lit pixels," not a dimmed
copy of the active frame, so a new always-on element was rejected rather than added by default. Flag
to the owner if this should be revisited.

**Decided during implementation, 2026-09-28:** on a rectangular AMOLED product (Venu Sq 2, Venu X1)
the window-progress arc is drawn against the same inscribed circle every other centred element in
this layout already uses (the shorter screen side sets the radius, per this section's own
rectangular-product paragraph above) — not a special-cased shape for square screens. Verified in the
simulator on both rectangular products; no clipping.

**A conscious exception, not an oversight:** `DayArcPalette.ARC_TRACK` (`#555555`, used for the
arc's dim background track and the Pro divider) measures ~2.8:1 against true black, just under the
watch-design-lead handbook's 3:1 bar for a persistent element. It's deliberately faint by design —
"a faint hairline," not a readable row — so this is named as a known, accepted exception rather than
silently under the bar.

## Typography

Fonts are chosen by measured fit (`DayArcText.fittingFont`/`truncated`), never a fixed pick per
role — the studio's own platform note that a documented font pixel size can be wrong versus what
actually renders (`knowledge/platform-facts.md` "Typography") is exactly why. The grid's cell font
is the one exception: fixed at `FONT_XTINY` rather than measured-per-cell, because two columns that
each independently picked their own font size would misalign — a deliberate trade of "measured" for
"aligned," worth flagging to `watch-design-reviewer`.

## Iconography

**Reversed by ADR-013, 2026-09-28** (owner: "looks boring and far too plain... proper svg icons,
colors... be more daring") — the "none in v1" position below no longer holds. Superseded, not
deleted, so the reasoning for the old position stays visible: adding an icon "for coverage," with no
one asking for it, was and still is the wrong reason. This time the owner explicitly asked, and every
icon added either replaces a text label (9 of 17 grid fields, see Layout above) or sits beside the
one hero read it belongs to — none compete with the hero for the first glance.

**Source:** [Tabler Icons](https://github.com/tabler/tabler-icons) (MIT licence — free for
commercial use; keep the licence file/attribution in project notes, not required on-device). Real
paths only, recoloured and given a small highlight or dynamic fill — nothing hand-drawn from
scratch. Not every needed concept has a "filled" variant in Tabler's own set (stairs, shoe/steps,
thermometer, run, chart-bar, wave-sine, refresh all only exist as "outline") — those use Tabler's
outline style at a slightly heavier stroke (2.2–2.5px) instead, a real gap in the source set, not a
style inconsistency.

**Highlights, corrected during implementation:** the mockup's two-tone highlights used
semi-transparent white (e.g. `fill="#fff" opacity="0.3"`), which doesn't survive MIP's indexed
64-colour palette reliably. Built version replaces every opacity-based highlight with a solid,
64-colour-safe "lightened" tone (each RGB channel promoted one step up the safe ladder
0x00→0x55→0xAA→0xFF from the icon's own base hue) — same two-tone intent, no alpha blending. Icons
with a stroke-only outline (stairs, steps, thermometer, run, refresh, breath, bars) have no
highlight in the mockup either and keep none built.

**Two different colour rules, on purpose (ADR-013):**
- **Hero icon** (weather condition, stress wave, battery shell): single hue, tied to that window's
  own accent. Colour still marks "the hero," nothing else — unchanged from the pre-ADR-013 rule for
  the hero value itself.
- **Pro grid icons:** each of the 14 glyphs has its own **permanent** hue by icon type — a heart is
  always `#FF5555` whether HR reads 60 or 160. This is *not* a second verdict system: colour is keyed
  to icon **type**, never to the **value** shown, exactly the same distinction ADR-006 already draws
  for the gauges. All 14 are 64-colour-safe (each channel 0x00/0x55/0xAA/0xFF):

  | Icon | Field(s) | Colour |
  |---|---|---|
  | Calendar | Next event | `#55AAFF` |
  | Heart | HR (both windows) | `#FF5555` |
  | Bolt | Intensity minutes | `#FFFF55` |
  | Stairs | Floors | `#AA55FF` |
  | Shoe | Steps (both windows) | `#55FF55` |
  | Flame | Calories (both windows) | `#FF5500` |
  | Bell | Notifications | `#5555FF` |
  | Thermometer | Temperature | `#FFAA00` (echoes morning/weather) |
  | Run | Run/wk | `#55FFAA` |
  | Bike | Bike/wk | `#AA00FF` |
  | Refresh | Recovery | `#FFAA55` |
  | Wave (breath) | Respiration | `#55FFFF` (echoes midday/stress) |
  | Droplet | Pulse Ox | `#FF55AA` (echoes evening/Body Battery) |
  | Bar chart | VO2max | `#AAFF55` |

**Implementation note, built 2026-09-28 — corrected from the direction-stage plan above:** the
original plan called for an icon font for the 3 hero icons (tintable, one hue via `setColor`) and
pre-coloured bitmaps for the 14 grid icons. Building it surfaced that the hero icon's hue is just as
permanently fixed as a grid icon's — each window has exactly one hero (morning=weather,
midday=stress, evening=battery; confirmed by reading `DayArcFields.heroFor`, no window ever shows a
different hero), so it never needs runtime tinting either. All 17 icons (3 hero + 14 grid) are
built the same way: pre-coloured, flattened SVG → `<bitmap>` resource (`dithering="none"`), drawn
with plain `dc.drawBitmap`, sized at fixed pixels per icon (hero: 56×45 / 52×52 / 68×48; grid:
22×22 uniform) — no BMFont tooling, no runtime tint, no `drawBitmap2` at all, sidestepping the
FR165/165m tint bug by construction rather than by careful use. Hero icons live in
`resources/drawables/icons/` (shared, both builds); grid icons in
`resources-pro/drawables/icons/` (Pro only). Licence notice:
`resources/drawables/icons/THIRD_PARTY_LICENSES.md`.

**A real, accepted trade-off from this choice:** plain `dc.drawBitmap` doesn't scale — every icon
renders at the same fixed pixel size on every device regardless of screen diameter (unlike every
text row here, which is measured per-device). A 22px grid icon is proportionally larger on a small
round product than on fr965. This matches how the existing launcher icon already behaves (also a
fixed-size SVG bitmap) and wasn't considered a design defect during implementation, but it's a
first for a *repeated, layout-critical* element (the grid icons interact with `DayArcGrid`'s real
per-row measurement everywhere else) — worth `watch-design-reviewer` weighing in on explicitly,
not just noting.

## Motion / always-on

AMOLED (`requiresBurnInProtection`) sleep: time only, `MUTED` colour, stepping across a 3×3 grid
every minute (TwoSuns's proven `TwoSunsSleep` pattern, reused — `DayArcConfig.BURN_IN_GRID`,
`DayArcLayout.driftStep`). No hero, no gauge, no grid while asleep on AMOLED — the fewest lit
pixels, not a reduced version of the active frame. MIP screens never enter this state; they keep
showing the full active window while "asleep" (no burn-in risk, matches TwoSuns's own
`_sleeping && _burnIn` branch exactly).

No other motion. No idle animation on the active face — nothing here marks a real state change
that would justify it; the window switch itself (at 5:00/9:30/17:00/23:00) is a hard cut, not an
animated transition, since it happens while the wearer isn't looking at the wrist.

## UX

**Glance-time budget.** One number, one colour, in every window but night: readable well inside 2-5
seconds even before the sub line or (Pro) the grid. Pro's grid is explicitly secondary — the hero
alone answers the glance; the grid rewards a longer look, it doesn't compete for the first one.

**Non-touch/button navigation.** N/A — a watch face has no navigation, nothing here is
touch-dependent.

**Empty/error states**, one plain sentence or "--" per field, never blank:
- Weather unavailable → "Weather unavailable" (hero's sub line).
- Stress null → "Stress unavailable right now" — deliberately generic: Garmin's own docs say stress
  isn't tracked during activity, but the SDK gives a watch face no way to confirm *that's* the
  cause of any given null, so the copy doesn't claim it.
- Body Battery null → "Body Battery unavailable."
- Calendar null (Pro) → "No upcoming event" — same reasoning: could mean no sync or no event, the
  copy claims neither.
- Every Pro grid cell: label plus "--" — a labelled "--" is itself the plain-English statement
  ("Steps --"), no separate sentence needed for a secondary cell (only the hero read gets a full
  sentence, matching its higher design weight).

**Permission framing.** `ComplicationSubscriber` has no user-facing prompt to frame (it's a build-
time manifest declaration, not a runtime consent dialog on this platform) — nothing to design here.

## Craft

**Simple's one focal read**, per window: feels-like temperature (morning), stress (midday), Body
Battery (evening), time (night). Cut to keep it single: calendar (ADR-008 — available, cheap,
rejected anyway), any second data type, any settings. **Amended, ADR-013:** the hero icon is not a
second data type — it's a companion glyph for the one existing read, same accent, same position,
never its own line. Still cut for Simple: any *second* icon, any icon that isn't directly beside the
hero it belongs to.

**Pro's craft bar is different on purpose** (ADR-009): the hero read still leads every window, but
the grid beneath it is allowed to be dense — 8-12 fields where they fit, fewer where the screen is
small, never more than what's actually measured to fit. The craft discipline here isn't "fewer
fields," it's "the hero never loses its position to the grid, and the grid never claims more room
than it can prove it has."

**Run past `watch-design-reviewer`, 2026-09-28:** returned `disposition: fix`, 8 findings — the
gauge's dim-above-threshold tier re-encoding Garmin's own stress band as a brightness verdict, the
chord-math gap (grid only, not the rest of the frame), the grid's unreserved label/value widths, the
grid-capacity/column-width inconsistency, a raw Garmin string (training status) that could smuggle
in a banned word, and the clock competing with the hero at full brightness. All 8 fixed in source
(see `docs/decisions.md` ADR-006, `docs/plan.md` "Implementation status"); re-review not yet re-run
to confirm `disposition: ship`. Still open: the grid's fixed-cell-font trade-off (above) wasn't
flagged as wrong, just noted as a deliberate trade — stands as documented.

**Owner look-approval (`docs/publish-checklist.md` gate 4), 2026-09-28:** the icon/colour direction
in ADR-013 was approved by the owner across several iterations of an HTML/SVG mockup (Claude
Artifact "Design" canvas), each round screenshot-verified in a real browser rather than just read as
markup — that verification step is what caught the Pro grid overflowing its own circle (last row
clipped, side text truncated by the round mask) before it ever reached Monkey C. This satisfies gate
4 for the *direction*; it is not a simulator or device screenshot of the real build, and the gate
stays open until one exists — a mockup is not device proof, same rule as everywhere else here.
`watch-design-reviewer` has not yet re-run against the built version of this direction; do that
before calling it `disposition: ship`.
