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
  grid_icon_colors: all muted #AAAAAA since 2026-10-05 (ADR-013 amendment; the 14 per-type hues before it are in "Iconography" for history)
type:
  clock: FONT_NUMBER_MEDIUM / FONT_NUMBER_MILD / FONT_LARGE (DayArcLayout.CLOCK_FONTS), plus FONT_MEDIUM on rectangles beside a MEDIUM or MILD hero or no hero (RECT_SMALL_CLOCK_FONT, ADR-019) — the tier is chosen by DayArcStack's whole-stack fit ("Layout"), not per row
  label: FONT_TINY / FONT_XTINY (LABEL_FONTS) — hero label and the date line (every window)
  hero: FONT_NUMBER_HOT / FONT_NUMBER_MEDIUM / FONT_NUMBER_MILD (HERO_FONTS) — the one number every window (but night) leads with; never smaller than the clock's tier
  sub: FONT_TINY / FONT_XTINY (the same tier as the label) — the neutral muted line under the hero; wraps to two lines rather than shrinking the hero. The no-weather morning's sentence stands alone (no hero) and is white
  cell: FONT_XTINY (Pro's grid, fixed — a grid row that itself picked a larger font per-cell would misalign the two columns)
icons:
  source: Tabler Icons (MIT license), github.com/tabler/tabler-icons — real paths adapted, not drawn from scratch (ADR-013)
  hero: one glyph per window (weather condition, stress wave, a Body Battery bolt since 2026-10-05 (was a battery shell; ROADMAP 13.19)), single-hue, tied to that window's own accent — colour still marks "the hero," nothing else
  grid (Pro only): 14 glyphs, all muted grey since 2026-10-05 (ADR-013 amendment), never coloured by the value shown
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
left Venu Sq 2 a 204px chord and no tier that fit). **Since ADR-019 (2026-10-05) a rectangle has its own square design**
(section "Rectangle"): rows fit a rounded inner box measured against the glass, not the full width.

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
  hero last; the hero font never drops below the clock's. **The hero label is never traded for a grid
  row (ADR-017, 2026-10-04):** Pro tries every rung that keeps the label with the grid (the last of
  them reserves ONE grid row and quarters the gaps), then the same rungs without the grid (drawn like
  Simple), and only then the rungs that drop the label. Fallbacks for a screen where nothing
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
  line is drawn on one ("Weather unavailable" is never split into two words on a colour screen; on the Instinct's narrow
  band it may need two lines, drawn below the window on one centre). Empty-state sentences
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
3. Hero label (**white**, small; the date, clock and sub line stay muted: reviewer pass seven, ADR-017 — the label names the number, so it is the brighter small line, and on a colour screen it is drawn down into the empty headroom above the hero's digits so it sits nearer its number than the date; not on the 1-bit Instinct, where every role is white and the boxes are tested tight against the bezel circle) — omitted when the read itself is the label (morning's temperature has
   none; midday/evening name the metric). **Since 2026-10-05 the morning has one too, "Feels like"** (owner, ROADMAP 13.28:
   an unlabelled feels-like 9° under "H 16 / L 13" read as wrong on the wrist). With no weather there is no label and no hero row (2026-10-06, reviewers: with no icon, a "--"
   floated alone in a row sized for digits): the morning reads clock, date and the sentence "Weather unavailable".
4. **Hero icon + hero value**, side by side as one centred group (ADR-013) — a single line-icon
   (Tabler Icons, recoloured) beside the number, both the same accent hue as the window. The value
   stays the largest single element on screen in Simple, and the largest and first-drawn element in
   Pro, ahead of the grid — the icon is a companion, it never gets its own competing line.
5. Gauge (stress/Body Battery only) — on colour screens its unfilled track is the arc's track grey (`ARC_TRACK`, the same faint hairline family; reviewer pass seven: the old #AAAAAA track outweighed a low fill). A single-hue, single-brightness horizontal fill, no
   threshold tier, no colour change, no threshold word (ADR-006). An earlier version dimmed above a
   threshold that, for stress, landed exactly on Garmin's own official band boundary — removed
   rather than defended.
6. Sub line(s) (muted, small) — the neutral second line ("$1$ of 100", "23% rain UV 4", or the
   empty-state sentence; the no-weather morning's "Weather unavailable" has no hero above it and is white, the read), wrapped to two lines when one line cannot hold it whole (morning's
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

**Amended 2026-10-04 (ADR-016), supersedes the label-share and three-digit rules in item 7 and the paragraph below where they differ:** a grid cell is shown whole or not at all. A label is drawn only if it fits whole beside the value's natural width, else it is dropped (the icon carries the cell); a value must fit whole (only a calendar title may end in "...", and then keeps room for a clock time). Recovery time reads in hours ("42h"; the SDK gives minutes). If no rung fits with the grid, Pro is planned again without it, at Simple's tiers (date, label and sub line kept, stack centred), before any trimming. The hero icon is centred on the digits' middle, not on the font box (a number font's digits fill 0.67 to 0.77 of its ascent). On the Instinct E and 3 Solar the hero icons are half size (30x24, 24x24, 36x24, white, `resources-instinct/`) so the digits, not the icon, are the largest thing in the row.

**Pro's grid follows the live values (ADR-017, 2026-10-05, ROADMAP 1.17):** the planner checks the grid rows against the cells the grid really gets (the corner fields beside the date leave it, `DayArcCorners.rest`), and, like every text row, the grid is planned against a worst case: each cell value at least four digits wide (`DayArcConfig.WORST_CELL_VALUE`), so the rows and the hero's tier do not move through the day; the plan is rebuilt only if a value outgrows that (a fifth digit, steps 10000), and on the smaller screens that rebuild can step down a rung for the rest of the window (ADR-017 has the per-device log; the FR965 does not move). Before, the plan was made on the values of that moment (zero steps) and the draw then dropped a row the plan had reserved room for, leaving a blank band under the grid. Cost, accepted: where four-digit steps need a lower rung, it is lower at zero steps too (the FR965 Pro morning shows the hero at the MEDIUM tier, Simple keeps HOT; steps are shown rather than left out); where no rung fits more than two rows (the FR255S morning: sunrise and sunset, then battery and heart rate), the rest is not shown and a blank band stays under the grid, the stack is not re-centred. Pro's corner pills clear the clock: the clock-to-date gap widens by up to a row gap into spare height, or, where none is left (FR965 morning), the date row moves down alone into the empty headroom above the hero's digits.

**Grid cell fit and corner fields, 2026-10-01 (after the owner's FR965 simulator screenshot of Pro evening, simulator only, not a wrist):**
the screenshot showed a label cut to "Re..." beside "300", a value touching the next column's icon, and an
icon-only cell's value far from its icon. Fixed in `DayArcGrid`/`DayArcLayout`: a gutter between the two columns
(`GRID_COLUMN_GAP_PERMILLE`), the label gets whatever the value does not need (at least the 55% cap), an icon-only cell
draws its value right beside its icon, and grid labels are about four letters (Rec, Resp, Int, Next, Run, Bike, SpO2,
VO2, Rise, Set, Batt) because a cell on the FR965 is ~150 px wide and an XTINY letter ~16 px. Tests pass on fr965,
approachs50, venusq2 (Pro) and fr965 (Simple). 2026-10-02, first wrist photo of the new look (FR965, Pro morning): a short value was cut ("Batt 8...", 3 px short); the label now gives way before the value does and "Batt" became "Bat". Morning's Pro grid had no icons then (icons were midday and evening only, ADR-013); the owner could not find them, the emulator showed pills with dropped labels ("Ri… 03:14", "50%", "182"), and morning was given icon-only cells like the other windows (ADR-013 amendment 3). Then (owner-approved mock) and later "E1" (ADR-013 amendment 2): the gauge is a shallow smile in both tiers, grid fields sit in pills riding the same curve, the divider and Pro's "N of 100" line are gone, pulse ox is icon-only, and Body Battery's hero icon is Tabler's battery shell with a heartbeat line. Grid rows are centred pairs of compact cells, and the first two icon-only
fields sit in the upper corners beside the date (`DayArcCorners`; ADR-013 amendment), so an FR965 shows six fields. **Closed 2026-10-04 (ADR-016):** the "96 of 100" line
that repeated the hero number and the gauge is gone from Simple as well (Pro dropped it earlier).

Night: clock, then the date line, nothing else — no arc, no icon, no gauge, no grid, no hero, the
one window where Pro and Simple render identically. Deliberately unchanged by ADR-013: night already
had its date line and was already the studio's reference case for "the simplest window." **Decided
during implementation, 2026-09-28:** the AMOLED idle/always-on frame does NOT show the date either,
even though it's now shown in every *active* window — DESIGN.md didn't say either way when this was
approved as direction; the idle frame's own existing philosophy is "fewest lit pixels," not a dimmed
copy of the active frame, so a new always-on element was rejected rather than added by default. Flag
to the owner if this should be revisited.

**Superseded on the three rectangles by ADR-019 (2026-10-05), see "Rectangle" below; kept for the record.** **Decided 2026-09-28, replacing an earlier implementation-time decision:** on a rectangular product
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
scratch. **Amended 2026-10-04 (ADR-017):** two of the three hero icons are now drawn in
`tools/gen_hero_icons.py` instead (the weather glyph, which Tabler's filled cloud-sun made a blob, and the Body
Battery shell, already redrawn in pixel space by ADR-013 amendment 4); the stress wave and the 14 grid icons are still Tabler's
paths. Not every needed concept has a "filled" variant in Tabler's own set (stairs, shoe/steps,
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
- **Morning icon = the current condition (2026-10-05, owner, ROADMAP 13.29; `DayArcWeatherKind`):** Garmin's condition code
  folded onto five generated glyphs (clear; partly cloudy, the old window glyph; cloudy, also fog and haze; rain, also storms;
  snow, also sleet and hail), all in the same box, so the planner's measured size holds. **No icon** when there is no weather
  or the condition has no glyph (windy, unknown): the fixed sun-behind-cloud had shown on a rainy day and beside "Weather
  unavailable". Midday and evening keep their window glyph, which the paragraph below still describes.
- **Hero icon** (weather condition, stress wave, battery shell): single hue, tied to that window's
  own accent — or, if the wearer picked one (ADR-014), that one hue in every non-night window. Colour
  still marks "the hero," nothing else, and is constant whatever the reading. The icon always shows,
  even when the reading is unavailable (midday and evening; the morning has none without weather): it is the window's identity marker, not a data-presence
  indicator. Because a hero icon is pre-coloured (no runtime tint), there is one bitmap per icon per
  hue per size: 3 icons x 6 hues = 18 SVGs in each size set (a large and a small one per screen), generated by `tools/gen_hero_icons.py`
  (one fill/stroke colour each, no highlight; stress is Tabler's wave scaled to the set, weather and battery are
  drawn in the generator, ADR-017) and chosen at draw time; Auto maps each window onto its own hue's file. The set
  follows the screen (see "Hero icon size" below).
- **Pro grid icons, as built since 2026-10-05 (owner, design critique, ROADMAP 13.20; ADR-013 amendment): every grid icon is
  muted `#AAAAAA`**, so the hero is the only coloured read on the face; the rainbow of type hues below competed with it. The
  intensity icon is a pulse line, not a bolt (the bolt is the Body Battery hero, as in Two Suns). The table below is the
  superseded per-type palette, kept for history.
- **Pro grid icons (superseded 2026-10-05):** each of the 14 glyphs has its own **permanent** hue by icon type — a heart is
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
with plain `dc.drawBitmap`, sized at fixed pixels per icon (hero: a large and a small set per screen size, ADR-017, 18 files across 6
hues per ADR-014 in each; grid: 24×24 uniform) — no BMFont tooling, no runtime tint, no `drawBitmap2` at all, sidestepping the
FR165/165m tint bug by construction rather than by careful use. Hero icons live in
`resources/drawables/icons/` (the 60 px default, shared, both builds) and `resources-hero-<height>/` (the other sizes); grid icons in
`resources-pro/drawables/icons/` (Pro only). Licence notice:
`resources/drawables/icons/THIRD_PARTY_LICENSES.md`.

**A real, accepted trade-off from this choice:** plain `dc.drawBitmap` doesn't scale, so an icon is the same pixel size wherever it
is loaded. **The hero icons now follow the screen and the number tier (ADR-017, 2026-10-04):** the jungles load, per screen size, a
LARGE and a SMALL set whose heights are about the digits beside them (digits taken as 0.72 of the number font's box), so the icon is
not "too big on the FR255S" and not "small and thin on the FR965" (ROADMAP 1.12), and `everyHeroIconLoadsAtExpectedSize` asserts that
relation on every device it runs on. **The 24 px grid icons do not scale, accepted (ADR-017, reviewer pass seven):** a 24 px icon is proportionally larger on a 218 px
round product than on a 454 px one. Their pill is as tall as the icon or the cell font, whichever is taller. Whole-pixel icons (ADR-013
amendment 4) leave only integer scales of the 24-grid: 24 or 48 px, and a 48 px icon makes a pill taller than the cell font on every
screen in the set, so Pro would lose its second grid row and its corner pills; a 36 px (1.5x) icon puts strokes on half pixels, the
thing amendment 4 forbade. On the FR965 the pills (icon 24, the pill about 38 px high) read in the screenshots, so there is nothing to buy; if a
wrist says otherwise, a 48 px set chosen by the jungle per screen is the lever, and the grid planner would have to be rebuilt around it.

**Hero icon size (ADR-017).** Round and rectangular products (the Instinct has its own half-size set, below). The LARGE icon sits beside
the HOT number tier, the SMALL one beside MEDIUM and MILD (`DayArcStack` picks by the tier it planned), so a Pro screen that has fallen
to MILD digits does not keep a HOT-sized icon. Heights in px, with the digits they sit beside (HOT / MEDIUM / MILD):

| Screens | Large | Small | Digits |
|---|---|---|---|
| round 218 (FR255S) | 42 | 24 | 42 / 30 / 23 |
| round 240 (fenix 7S) | 48 | 30 | 48 / 35 / 29 |
| round 260, 280 | 54 | 36 | 52 / 38 / 32 and 56 / 41 / 34 |
| round 360, 390 (the default, `resources/`) | 72 | 54 | 70 / 55 / 48 and 75 / 62 / 50 |
| round 416 | 78 | 54 | 77 / 58 / 46 |
| rectangle 320 x 360 | 78 | 48 | 80 / 55 / 43 |
| round 454, 466, rectangle 448 x 486 | 90 | 66 | 87 / 73 / 58, 91 / 80 / 59, 89 / 79 / 58 |

Heights are the digits' height rounded to a multiple of 6. Stroke is 0.12 of the height, whole pixels (2 to 11 px: the digits' own
stroke is 0.13 (FR965) to 0.18 (the epix 2's bolder font) of their height, and 2 px beside an FR965's digits read as faint). All three icons are line icons of one weight
and one cap style: the stress wave (Tabler's wave-sine, scaled and cropped to its ink), the **weather glyph** (an outlined cloud in
front of a solid sun with three rays, a black gap between them: redrawn 2026-10-04 because the old one, a solid cloud touching a solid
sun in one hue, fused into a blob, reviewer pass five) and the Body Battery shell with its heartbeat line (7/8 of the others' height).
Drawn in pixel coordinates (viewBox = size) so the SDK never resamples, odd strokes centred on a half pixel.

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
- Weather unavailable → "Weather unavailable" alone under the date, in white (the label's role: it is the read), planned as
  itself (one line where it fits): no label, no "--", no icon, no hero row (2026-10-06; the sentence says it in words, and a
  bare dash with no icon read as a hole). Midday and evening keep label, icon, "--" and sentence.
- Stress null → "Stress unavailable right now" — deliberately generic: Garmin's own docs say stress
  isn't tracked during activity, but the SDK gives a watch face no way to confirm *that's* the
  cause of any given null, so the copy doesn't claim it.
- Body Battery null → "Body Battery unavailable" (no full stop, matching `strings.xml`).
- Calendar null (Pro) → "None" (was "No upcoming event", which the pill cut to "No up..." on the owner's FR965, 2026-10-05) — same reasoning: could mean no sync or no event, the
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

## Rectangle (Venu Sq 2, Venu Sq 2 Music, Venu X1; ADR-019, built 2026-10-05, simulator only)

A square watch gets a square design, not the round one dropped in (owner, 2026-10-05; the studio rule for rectangles). It
**supersedes, on these three products only, the "Decided 2026-09-28" paragraph above** (rows at the full screen width, the arc
on the inscribed circle). Every meaning and colour stays: the per-window hues (ADR-013 (icon system and per-window colour)), no
verdicts (ADR-006 (single-hue gauge)), the Accent setting (ADR-014 (one Accent colour list)). Round and Instinct products do not
change (every branch is `DayArcLayout.isRectangle()`).

- **The track follows the glass.** A rounded rectangle whose centreline is inset from the screen edge exactly as the round arc's
  is from the bezel (`DayArcRect.inset` = the bezel margin plus half the pen; 8 px on the Sq 2, 12 px on the X1), the same stroke
  (`DayArcArc.penWidth`, 5 / 8 px), corner radius 0.15 of the short side (48 / 67 px on the centreline): the studio's one corner
  proportion, 1.5 insets, as in HeroSet, HeroFace and Two Suns (owner, 2026-10-06; it was 0.12 until review pass five). The Venu
  X1's glass corner, measured off the SDK skin's alpha, is a superellipse that a 66 px circle fits from row 8 down; the 67 px
  track corner keeps about 13 px of black outside the stroke on the diagonal (`DayArcRectTest` asserts at least 2 px all along
  both top corners). The Sq 2 skin's glass corner is about 8 px, so its 48 px corner is the studio proportion, not a fit. HeroFace's rectangle frame was the precedent (idea copied,
  no code linked).
- **The window-progress arc is the upper part of that track**: from the left side, over both top corners, down the right side,
  the same share of the path's length as the round arc's 140 of 360 degrees (`DayArcRect.segments`: on the Sq 2 56 px down each
  side, the tips at y 112; on the X1 72 px, tips at y 151). Track in `ARC_TRACK` grey, filled clockwise from the left tip in the
  window's accent; a share of the window is the same share of the path. Night has none, as on round.
- **The hero gauge is a straight pill bar** (no curve on a square): the track grey bar with round ends, the accent fill from
  the left, the round gauge's width (`gaugeMaxWidth`) capped by the inner box. The row keeps the round gauge's height (the
  smile's depth included) and the bar sits in its middle: with only a row gap above it (the first build) the bar touched the
  digits' baseline, so the depth stays as air, half above the bar and half below. Pro's grid rows sit level (no lift onto a curve).
- **The content uses the square.** Every row (clock, date, label, hero, sub line, the corner pills beside the date, the grid
  pills) fits the **inner box**: the track's inner edge plus the arc's own clearance (`DayArcArc` 15 permille), with corners
  rounded concentrically with the track's (`DayArcRect.rowWidth`; 14 px in and a 42 px corner on the Sq 2, 22 px and 57 px on the
  X1), and another 15 permille off the straight sides (19 / 28 px in): Pro's corner pills sit beside the side runs, and a grey
  pill outline at the arc's clearance alone read as touching the grey track (first Venu X1 screenshot). The stack starts at the inner box's top and ends at its bottom, which buys the planner about 25 px of height over the
  old inscribed-circle margins; `DayArcStack`'s dry run then picks the tiers, as everywhere.
- **The clock stays clearly below the hero** in every active window (not at night, where the time is the read): one number tier
  below a HOT hero (NUMBER_MILD), and the small text font `FONT_MEDIUM` (`DayArcLayout.RECT_SMALL_CLOCK_FONT`) beside a MEDIUM or
  MILD hero. Reviewers, 2026-10-05 and 06: the square's extra height went to the clock first (Venu X1 Free, a grey "20:02" at
  0.9 of the hero's height), and on the Venu Sq 2 Pro both NUMBER_MILD and FONT_LARGE digits rendered about as tall (~45 px) as
  the MEDIUM hero's, so a tier rule on the font list alone did not separate them. The hero keeps its tier; the smaller clock
  also frees the height that gives the Sq 2 Pro its second grid row.
- **The morning sub line is planned for the watch's own data** (`DayArcSources.hasUvIndex`): `CurrentConditions.uvIndex` needs
  API 5.1, the Venu Sq 2 / Sq 2 Music are 5.0 (SDK device files, `compiler.json` `connectIQVersion`, SDK 9.2.0; the Venu X1 is
  6.0.2; real firmware may report a newer one: `hasUvIndex` asks the live conditions `has :uvIndex`, the same test the drawn line uses, and
  falls back to the API level only when there is no weather), so their worst case is "104/-40  100% rain" without "UV 11". Planning the UV
  segment there cost a second sub line the watch never draws, which left a ~45 px gap above Pro's lone grid row. Applies to any
  product below API 5.1 (round ones included): their morning can only gain room.
- **What it buys (worst-case strings, `DayArcStackTest` HEROINK/STACK log, simulator only).** Venu Sq 2 Pro: the hero is
  NUMBER_MEDIUM (ink box 76 px) with **two** grid rows in the morning, midday and evening, the morning's while the watch
  reports no `uvIndex` (the SDK's Sq 2 is API 5.0; a firmware that adds it plans the UV segment and may lose a row) (it was MILD with one row before
  ADR-019); the morning keeps "Feels like" **and** both grid rows (ROADMAP 13.30: the square gives room for both); with the
  hero's own empty sentence (two lines) midday and evening step down to MILD with one row. Venu Sq 2 Free: NUMBER_HOT at
  midday and evening, MEDIUM in the morning. Venu X1: HOT in every window of both tiers; Pro two grid rows. A morning
  without weather has no hero row, so Pro's grid takes that height: the captures show the five fields left after the two corner
  pills in three rows on both sizes (the STACK log now counts the same cells the frame draws, `DayArcCorners.rest`).
- **Free's empty band at the bottom, accepted (2026-10-06):** Free's stack is geometrically centred in the inner box (measured
  on the captures: Venu X1 midday 63 px above the clock, 52 px under the gauge; Venu Sq 2 morning 56 px above, 46 px under the
  sub line). The band under the content reads emptier only because the arc fills the corresponding band above. Kept, for two
  reasons: the header (arc, clock, date) reads as one unit when the clock sits close under the arc, and lowering the stack to
  balance the bottom would open the same gap under the arc instead; and nothing can take the room: midday and evening already
  draw the HOT hero on both sizes, and the Sq 2 morning's MEDIUM hero is where the planner lands after every HOT rung (0 to 3)
  failed the worst-case fit (`DayArcStackTest` STACK log, level 4); the live morning frame draws that same plan. The lever if a wrist disagrees: a downward centre bias on rectangles
  (`DayArcStack.attempt` already only slides a stack down, away from the arc), one constant and a screenshot.
- **The Sq 2 Free clock changes size with the hero's tier, accepted:** `FONT_MEDIUM` beside the MEDIUM morning hero (and beside
  an empty-state hero, and with no hero at all on a morning without weather), NUMBER_MILD beside the HOT midday and evening hero, so the time grows by about 30% at 9:30 and shrinks
  when stress data goes missing. The alternative, one fixed clock size, reopens the clock-equals-hero problem in one of the two
  cases. With weather, the Venu X1 Free (HOT everywhere) and the Sq 2 Pro (MEDIUM everywhere) do not move. **A morning without
  weather sets the clock to `FONT_MEDIUM` on every rectangle, both tiers:** the white sentence is the read there, and a larger
  grey clock would outrank it (reviewer pass six). So the Venu X1 clock (NUMBER_MILD in its data morning) also shrinks when
  weather drops out, accepted for the same reason.
- Screenshots of the rectangle (`../device-test/rect-review/after/`) show the simulator's **canned values**: sunrise 12:17,
  sunset 23:59 and the 00:00 calendar event are what the simulator returns, not a real place or date; steps (5310), floors (7)
  and intensity (18) are set with `sim_activity`; weather is the simulator's (66 °F, 77/63, 10% rain).
- Always-on: unchanged (the time only, drifting), fitted to the inner box. 24-hour burn-in simulation (simulator, Pro, from the
  midday window): no burn-in, peak luminance 1.94% (Venu Sq 2) and 2.27% (Venu X1), against a 10% limit that is unverified (quoted in
  `../docker/SIMULATOR.md` with no source; the simulator's own verdict box states no limit).

## Instinct E and Instinct 3 Solar (1-bit, a round window top right; ADR-015, accepted 2026-10-04, simulator only)

Black and white only: every colour role is white, the hero is told apart by its icon and label (never a hue), the Accent setting does not exist there. **The window-progress arc becomes a gauge in the round window** (a hairline circle, a thick fill from 12 o'clock clockwise, the same share of the current window; night has none). The clock and date share the band left of the window; the hero (icon and value), the gauge and the sub line sit below it; Pro's grid appears only when the stack has room and has no corner pills. What shows is the square cut by a circle about 98 px in radius, so rows are clipped to a 96 px circle. The mockup (`docs/archive/instinct-mockup.html`) is the approved look.

**Pro on the Instinct (ADR-017, 2026-10-04):** the hero label is kept and Pro's grid shrinks to ONE row of pills where that fits (before, Pro dropped the label to buy two rows, which Simple never did). The E 40 mm draws that row in the morning, midday and evening; the 3 Solar draws it in the evening only. **On the 3 Solar the Pro morning and midday are the same picture as Simple, by design, not by bug:** the morning's sub line wraps to two lines at the worst case, and clock + date + two sub lines + hero leave no room for a pill row inside the circle the bezel leaves; midday's first row is the calendar pair, which needs a wider chord than that row has at 176 px (a cell is whole or not drawn, ADR-016). The levers if the owner wants Pro to differ in every window there: reorder the grid so the first row is two icon-only cells, or let the grid share the date's row; both are product calls. The hero icons stay the half-size white set; the weather glyph is the same outlined cloud and sun (no rays at that size). **Owner, 2026-10-04 (ROADMAP 1.18): keep Pro on the Instinct as built** (the 3 Solar morning and midday match Simple, thin strokes, one-row Pro grid); those are not to be changed.

**Instinct craft, reviewer pass seven (ADR-017, 2026-10-05):** the clock starts one number-font tier down on a 1-bit watch (`DayArcStack.attempt`), so with no hue the hero's digits, not the clock's, are the largest. **Accepted, not changed:** the clock, date and label sit on different centre axes (each row beside the window is centred in its own band, which the bezel circle makes wider lower down, and in a Pro frame the hero row can also sit beside the window; the rows below the window centre on the screen). One shared axis needs every row beside the window to fit the narrowest band (the clock's row, the highest and so the most clipped by the bezel circle), which the worst-case date string ("Wed, Sep 30") does not, so the date and label would drop a font tier or slide below the window and cost the stack its height: that is what the layout buys, and the header block (clock, date) reading as one unit left of the window is the approved mockup's look. Night sits low (E 40 mm about 7 px, 3 Solar about 18 px) because the clock must clear the window for clock and date to share one centre. A near-zero gauge fill is a short blob at 1 px pen steps; not changed.
