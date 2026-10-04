---
name: DayArc / DayArc Pro
description: One hero read per time window (weather / stress / Body Battery / time+date); Pro adds a measured secondary field grid under the same hero. A hue per window (or one the wearer picks), a fixed hue per icon type, no verdicts. Every window's stack is planned as a whole against the real display.
colors:
  ground: "#000000"
  text: "#FFFFFF"
  muted: "#AAAAAA"
  accent: the wearer's Accent colour (ADR-014). Auto (default) = the three per-window hues below, exactly as approved in ADR-013; or ONE fixed hue for the arc, hero value, gauge fill and hero icon in every non-night window — cyan #55FFFF, amber #FFAA00, rose #FF55AA, green #55FF55, blue #55AAFF, purple #AA55FF. A list, never a free picker; all 64-colour-safe
  accent_morning: "#FFAA00"   # Auto's hue for morning
  accent_midday: "#55FFFF"    # Auto's hue for midday
  accent_evening: "#FF55AA"   # Auto's hue for evening
  accent_night: none — night has no hero, no icon, stays muted-only whatever the setting
  grid_icon_colors: 14 fixed 64-colour-safe hues, one per icon TYPE, never per value (ADR-013) — see "Iconography" below for the table
type:
  clock: FONT_NUMBER_MEDIUM / FONT_NUMBER_MILD / FONT_LARGE (DayArcLayout.CLOCK_FONTS) — the tier is chosen by DayArcStack's whole-stack fit ("Layout"), not per row
  label: FONT_TINY / FONT_XTINY (LABEL_FONTS) — hero label and the date line (every window)
  hero: FONT_NUMBER_HOT / FONT_NUMBER_MEDIUM / FONT_NUMBER_MILD (HERO_FONTS) — the one number every window (but night) leads with; never smaller than the clock's tier
  sub: FONT_TINY / FONT_XTINY (the same tier as the label) — the neutral line under the hero; wraps to two lines rather than shrinking the hero
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
jungles (`docs/archive/plan.md` "Implementation status"); the full 69-product compile sweep runs alongside
this build. **Still no real-device evidence and no owner screenshot review of the actual build** —
`docs/status.md` gate 4 stays open for that specifically; a mockup or a simulator render
is not device proof, same rule as everywhere else in this studio.

**Status, after the owner's first wrist photo (FR965, evening, 2026-09-28) — the project's first
real-device evidence:** it showed three things no simulator test could: the sub line drawn as
"4...", the arc crowding the clock digits' top corners, and a top-heavy stack. Fixed in the layout
(see "Layout" and ADR-013's amendment): the whole stack is now planned by measured dry run
(`DayArcStack`), not stacked top-down by per-row width fits. That fix is verified only by
per-device simulator tests — **the wrist has not re-checked it.** The owner also asked for an
accent-colour setting (ADR-014, partly reversing ADR-011); built, likewise simulator-only.

**Superseded status, 2026-09-28, earlier the same day:** direction approved by the owner via an
iterated HTML/SVG mockup (screenshot-verified at each pass, not just read as markup), not yet built
in Monkey C. This section and "Iconography" below described that approved direction before it was
implemented.

## Layout

Vertical stack, centred on `DayArcLayout.centerX()` AND vertically centred in the usable display,
planned as a WHOLE by `DayArcStack` before anything is drawn (2026-09-28, after the owner's first
wrist photo showed the sub line as "4..." — rows had been stacked top-down with fonts picked per
row by width only, and nothing budgeted total height against the display). Every text row is
fitted against the chord at its own y: on a round product (66 of the 69) the inscribed circle's
chord (`DayArcLayout.rowMaxWidth`, TwoSuns's chord-inset math, `docs/decisions.md` ADR-001); on a
rectangular one (Venu Sq 2/Sq 2 Music, Venu X1) the full screen width and the screen's own bottom
edge — a rectangle has no round bezel, but **its display's corner radius is not known** (not
measured, not read from the SDK device definition), so rows reaching ~19px above the bottom edge
with Pro's grid icons near x=6 are unverified against rounded corners: an open item for a look on a
Venu Sq 2 / Venu X1 (ADR-001, amended — the earlier "same round-centred content on rectangles"
left Venu Sq 2 a 204px chord and no tier that fit).

**How the stack is fitted** (`DayArcStack`, `DayArcConfig.STACK_LEVELS`):
- A measured dry run of every row — clock, date, hero label, hero icon+value, gauge, sub line(s)
  and, in Pro, the divider plus a reserved grid block — for one font-tier combination; the largest
  combination that fits wins. The dry run and the real draw are the same computation
  (`DayArcDraw` draws the plan), so they cannot drift apart.
- Rows are sized against FIXED worst-case strings (`88:88`, `100`, `-40°`, `100 of 100`, the
  longest empty-state sentence, the longest morning sub, the longest date), or the live string if
  wider (measured in pixels at the largest font, not by character count) — never against the live
  values alone, so tiers do not flicker between readings. The plan is cached (`DayArcPlanCache`)
  and rebuilt when the window or the hero's optional rows change (including the date flipping
  null <-> present) or when a live string turns out wider than what the plan was sized for
  (`DayArcSizing.covers`). What this does NOT guarantee: that an unexpected live string can never be
  wider than its plan for a frame — so the draw path is safe regardless: every live string is
  null-guarded and truncated against its own row's chord, never throws.
- Owner's standing rule: do NOT shrink unless necessary. So the order of giving way is: vertical
  centring and tighter gaps first, then the clock, then the small text (date/label/sub), then the
  hero last; the hero font never drops below the clock's. Fallbacks for a screen where nothing
  else fits: drop the hero label; then (Pro) reserve one grid row instead of two and quarter the
  gaps; then TRIM — drop every optional row (date, label, grid, the second sub line), then all but
  clock + hero + gauge. If even that cannot fit, `DayArcStack.prune()` removes any row whose bottom
  would cross the usable bottom, so a plan is always safe to draw (`plan.fits` says whether it is a
  real fit or a last resort). Number-font rows (clock, hero value) are given ascent-only height — digits have no
  descender — but font boxes are still conservative (they carry padding above the digits), so a
  plan can look a touch smaller than strictly necessary; the wrist decides whether to tune that.
- Rows up in the arc's band are fitted against the arc's INNER edge (`DayArcArc.rowMaxWidth`), not
  the full circle — see item 0 — so "fits its row" also means "clears the arc", for the clock's top
  corners and any other row that high, not just its centre.
- A sub line too long for its row **wraps to two lines** (split at the space that balances the two
  halves, preferring the morning sub's double-space between segments) rather than shrinking the
  hero, and the second line is part of the planned height. A second line is planned only when one
  line failed because the sub text itself did not fit, and at draw time a live string that fits one
  line is drawn on one ("Weather unavailable" is never split into two words). Empty-state sentences
  ("Stress unavailable right now", "Weather unavailable", "Body Battery unavailable") are not
  meant to be cut; `DayArcText.truncated` is the backstop, and it returns the whole string, or at
  least one character plus "...", or nothing — never a bare one-character stub.
- Simple and night are vertically centred in the usable area. Pro is top-anchored with an elastic
  grid: the hero block plus the reserved grid rows form the plan, and the grid takes whatever
  vertical space remains. Night plans identically in both densities.

Top to bottom, every window but night:
0. **Window-progress arc** (ADR-013) — a thin arc across the top of the circle, in the window's own
   accent (or the wearer's chosen one, ADR-014), hugging the bezel at a FIXED radius
   (`DayArcArc`) — everything else clears IT, not the other way round: rows in its band are
   chord-fitted against its inner edge minus a visible gap. Showing progress through the *current window only* (e.g. how far through the 5:00–9:30
   morning block the clock is right now) — not TwoSuns's full 24h ring, a deliberately different
   shape so the two listings' own signature elements never get confused with each other. Morning/
   midday/evening only; night carries no arc, same restraint as everything else in that window.
1. Clock (small-medium, muted-white) — always present, every window, both densities.
2. **Date** (muted, small) — now shown in every window, not just night (ADR-013; was night-only).
   No setting to hide it — ADR-014's one setting is a colour only; this is a content change, not a
   new toggle. Pro's morning grid has no separate date cell (it would show the date twice).
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
6. Sub line(s) (muted, small) — the neutral second line ("$1$ of 100", "23% rain UV 4", or the
   empty-state sentence), wrapped to two lines when one line cannot hold it whole (morning's
   high/low + rain + UV is the longest real string). Omitted where the source data has none to add
   (midday's sub is `null` whenever stress itself is valid — the gauge already carries that row's
   information).
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

**Grid cell fit and corner fields, 2026-10-01 (after the owner's FR965 simulator screenshot of Pro evening, simulator only, not a wrist):**
the screenshot showed a label cut to "Re..." beside "300", a value touching the next column's icon, and an
icon-only cell's value far from its icon. Fixed in `DayArcGrid`/`DayArcLayout`: a gutter between the two columns
(`GRID_COLUMN_GAP_PERMILLE`), the label gets whatever the value does not need (at least the 55% cap), an icon-only cell
draws its value right beside its icon, and grid labels are about four letters (Rec, Resp, Int, Next, Run, Bike, SpO2,
VO2, Rise, Set, Batt) because a cell on the FR965 is ~150 px wide and an XTINY letter ~16 px. Tests pass on fr965,
approachs50, venusq2 (Pro) and fr965 (Simple). 2026-10-02, first wrist photo of the new look (FR965, Pro morning): a short value was cut ("Batt 8...", 3 px short); the label now gives way before the value does and "Batt" became "Bat". Morning's Pro grid had no icons then (icons were midday and evening only, ADR-013); the owner could not find them, the emulator showed pills with dropped labels ("Ri… 03:14", "50%", "182"), and morning was given icon-only cells like the other windows (ADR-013 amendment 3). Then (owner-approved mock) and later "E1" (ADR-013 amendment 2): the gauge is a shallow smile in both tiers, grid fields sit in pills riding the same curve, the divider and Pro's "N of 100" line are gone, pulse ox is icon-only, and Body Battery's hero icon is Tabler's battery shell with a heartbeat line. Grid rows are centred pairs of compact cells, and the first two icon-only
fields sit in the upper corners beside the date (`DayArcCorners`; ADR-013 amendment), so an FR965 shows six fields. **Open:** "96 of 100"
repeats the hero number and the gauge; dropping it would buy a third grid row (not done, owner's call).

Night: clock, then the date line, nothing else — no arc, no icon, no gauge, no grid, no hero, the
one window where Pro and Simple render identically. Deliberately unchanged by ADR-013: night already
had its date line and was already the studio's reference case for "the simplest window." **Decided
during implementation, 2026-09-28:** the AMOLED idle/always-on frame does NOT show the date either,
even though it's now shown in every *active* window — DESIGN.md didn't say either way when this was
approved as direction; the idle frame's own existing philosophy is "fewest lit pixels," not a dimmed
copy of the active frame, so a new always-on element was rejected rather than added by default. Flag
to the owner if this should be revisited.

**Decided 2026-09-28, replacing an earlier implementation-time decision:** on a rectangular product
(Venu Sq 2, Venu Sq 2 Music, Venu X1) rows use the full screen width and the screen's own bottom
edge, while the window-progress arc stays on the inscribed circle (the arc is a circle arc; the
stack simply starts below it, `DayArcLayout.topMargin`). The first build drew rectangles as the
inscribed circle too — verified only by "nothing throws" — and `DayArcStackTest` on venusq2 then
showed that no font tier fit a 160px-radius circle on a 320x360 screen. Night is centred in both
densities.

**A conscious exception, not an oversight:** `DayArcPalette.ARC_TRACK` (`#555555`, used for the
arc's dim background track and the Pro divider) measures ~2.8:1 against true black, just under the
watch-design-lead handbook's 3:1 bar for a persistent element. It's deliberately faint by design —
"a faint hairline," not a readable row — so this is named as a known, accepted exception rather than
silently under the bar.

## Typography

Fonts are chosen by measured fit — each row's tier by `DayArcStack`'s whole-stack dry run
(`DayArcText.fittingFont`/`truncated` remain for the idle frame and as a draw-time backstop) — never
a fixed pick per role — the studio's own platform note that a documented font pixel size can be wrong versus what
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
  own accent — or, if the wearer picked one (ADR-014), that one hue in every non-night window. Colour
  still marks "the hero," nothing else, and is constant whatever the reading. The icon always shows,
  even when the reading is unavailable: it is the window's identity marker, not a data-presence
  indicator. Because a hero icon is pre-coloured (no runtime tint), there is one bitmap per icon per
  hue: 3 icons x 6 hues = 18 SVGs, generated by `tools/gen_hero_icons.py` from the three approved
  Tabler-derived templates (`tools/hero_icon_templates/`, one fill/stroke colour each, no highlight)
  and chosen at draw time; Auto maps each window onto its own hue's file.
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
  | Sunrise | Sunrise time (morning) | `#FFAA00` |
  | Sunset | Sunset time (morning) | `#FF5500` |
  | Battery shell | Watch battery % (morning) | `#AAFF55` |

**Implementation note, built 2026-09-28 — corrected from the direction-stage plan above:** the
original plan called for an icon font for the 3 hero icons (tintable, one hue via `setColor`) and
pre-coloured bitmaps for the 14 grid icons. Building it surfaced that the hero icon's hue is just as
permanently fixed as a grid icon's — each window has exactly one hero (morning=weather,
midday=stress, evening=battery; confirmed by reading `DayArcFields.heroFor`, no window ever shows a
different hero), so it never needs runtime tinting either. All 17 icons (3 hero + 14 grid) are
built the same way: pre-coloured, flattened SVG → `<bitmap>` resource (`dithering="none"`), drawn
with plain `dc.drawBitmap`, sized at fixed pixels per icon (hero: 60×48 / 48×48 / 60×42, 18 files across 6 hues per ADR-014; grid:
24×24 uniform) — no BMFont tooling, no runtime tint, no `drawBitmap2` at all, sidestepping the
FR165/165m tint bug by construction rather than by careful use. Hero icons live in
`resources/drawables/icons/` (shared, both builds); grid icons in
`resources-pro/drawables/icons/` (Pro only). Licence notice:
`resources/drawables/icons/THIRD_PARTY_LICENSES.md`.

**A real, accepted trade-off from this choice:** plain `dc.drawBitmap` doesn't scale — every icon
renders at the same fixed pixel size on every device regardless of screen diameter (unlike every
text row here, which is measured per-device). A 24px grid icon is proportionally larger on a small
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
- Body Battery null → "Body Battery unavailable" (no full stop, matching `strings.xml`).
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
rejected anyway), any second data type, any setting but Accent colour (ADR-014). **Amended, ADR-013:** the hero icon is not a
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
(see `docs/decisions.md` ADR-006, `docs/archive/plan.md` "Implementation status"); re-review not yet re-run
to confirm `disposition: ship`. Still open: the grid's fixed-cell-font trade-off (above) wasn't
flagged as wrong, just noted as a deliberate trade — stands as documented.

**Owner look-approval (`docs/status.md` gate 4), 2026-09-28:** the icon/colour direction
in ADR-013 was approved by the owner across several iterations of an HTML/SVG mockup (Claude
Artifact "Design" canvas), each round screenshot-verified in a real browser rather than just read as
markup — that verification step is what caught the Pro grid overflowing its own circle (last row
clipped, side text truncated by the round mask) before it ever reached Monkey C. This satisfies gate
4 for the *direction*; it is not a simulator or device screenshot of the real build, and the gate
stays open until one exists — a mockup is not device proof, same rule as everywhere else here.
`watch-design-reviewer` has not yet re-run against the built version of this direction; do that
before calling it `disposition: ship`.

## Instinct E and Instinct 3 Solar (1-bit, a round window top right; ADR-015, proposed, simulator only)

Black and white only: every colour role is white, the hero is told apart by its icon and label (never a hue), the Accent setting does not exist there. **The window-progress arc becomes a gauge in the round window** (a hairline circle, a thick fill from 12 o'clock clockwise, the same share of the current window; night has none). The clock and date share the band left of the window; the hero (icon and value), the gauge and the sub line sit below it; Pro's grid appears only when the stack has room and has no corner pills. What shows is the square cut by a circle about 98 px in radius, so rows are clipped to a 96 px circle. The mockup (`docs/archive/instinct-mockup.html`) is the approved look.
