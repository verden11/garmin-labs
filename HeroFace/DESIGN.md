---
name: HeroFace
description: HeroSet's dashboard turned into a clock, drawn with primitives on a black ground.
colors:
  ground: "#000000"
  text: "#FFFFFF"
  muted: "#AAAAAA"
  track: "#555555"
  gold: "#FFAA00"
  done: "#00FF00"
  alert: "#FF0000"
  accent-blue: "#55AAFF"
  accent-cyan: "#00FFFF"
  accent-magenta: "#FF55FF"
  accent-white: "#FFFFFF"
  sleep-text: "#555555"
typography:
  time:
    fontFamily: "Graphics.FONT_NUMBER_THAI_HOT → FONT_NUMBER_HOT → FONT_NUMBER_MEDIUM → FONT_NUMBER_MILD"
    fontSize: "measured: 128px @454, 36px @240"
    lineHeight: 1
  time-aod:
    fontFamily: "Graphics.FONT_NUMBER_MEDIUM"
    fontSize: "measured per device"
    lineHeight: 1
  face:
    fontFamily: "Graphics.FONT_XTINY"
    fontSize: "measured: 37px @454, 26px @240"
    lineHeight: 1
    letterSpacing: "system"
spacing:
  inset: "min(width,height)/10"
  text-margin: "{spacing.inset}/2"
  column-gap: "{spacing.inset}/5"
  ring-inset: "{spacing.inset}/5"
  ring-width: "{spacing.inset}/6"
  bar-height: "{spacing.inset}/3"
  stack-gap: "{spacing.inset}/9"
rounded:
  pill: "half the bar height"
  bubble: "one fifth of the icon size"
components:
  bezel-ring-track:
    textColor: "{colors.track}"
    height: "{spacing.ring-width}"
  bezel-ring-fill:
    textColor: "{colors.accent-blue}"
    height: "{spacing.ring-width}"
  mission-bar-track:
    backgroundColor: "{colors.track}"
    rounded: "{rounded.pill}"
    height: "{spacing.bar-height}"
  mission-bar-fill:
    backgroundColor: "{colors.accent-blue}"
    rounded: "{rounded.pill}"
    height: "{spacing.bar-height}"
  mission-bar-fill-done:
    backgroundColor: "{colors.done}"
    rounded: "{rounded.pill}"
    height: "{spacing.bar-height}"
  mission-value:
    textColor: "{colors.text}"
    typography: "{typography.face}"
  mission-value-alert:
    textColor: "{colors.alert}"
    typography: "{typography.face}"
  mission-label:
    textColor: "{colors.muted}"
    typography: "{typography.face}"
  mission-label-done:
    textColor: "{colors.done}"
    typography: "{typography.face}"
  streak-line-kept:
    textColor: "{colors.gold}"
    typography: "{typography.face}"
  streak-line-idle:
    textColor: "{colors.muted}"
    typography: "{typography.face}"
  date-line:
    textColor: "{colors.muted}"
    typography: "{typography.face}"
  time-block:
    textColor: "{colors.text}"
    typography: "{typography.time}"
  seconds:
    textColor: "{colors.muted}"
    typography: "{typography.face}"
  footer-item:
    textColor: "{colors.muted}"
    typography: "{typography.face}"
    size: "{spacing.stack-gap}"
  footer-item-low:
    textColor: "{colors.alert}"
    typography: "{typography.face}"
  aod-time:
    textColor: "{colors.sleep-text}"
    typography: "{typography.time-aod}"
---

# Design System: HeroFace

## Overview

**Creative North Star: "The Dashboard That Learned To Tell Time"**

HeroFace takes HeroSet's dashboard grammar — a bezel progress ring, a gold keep-line, three pill mission bars — and re-proportions it so the time owns the middle. Everything is drawn from primitives on a pure black ground: arcs, rounded rectangles, two-stroke check marks, a battery outline, a heart made of two circles and a triangle. There are no bitmaps and no icon fonts, because the smallest supported watch-face memory budget is 64 KB; that constraint is also the aesthetic. Every colour sits on Garmin's 64-colour palette (channels 00/55/AA/FF) so a MIP screen renders it exactly as written and an AMOLED does not have to dither.

Density is deliberately low. One ring, one gold line, one time, one date row, three columns, one footer strip: seven things, in a fixed bottom-up stack, on every one of the 117 round products from 208 to 466 px. Nothing is positioned in absolute pixels. A single proportion — a tenth of the short screen edge — generates the ring, the gap, the bar, the column and the margin, and the time then takes whatever vertical band is left between the streak row and the date. Text is measured against the round chord at its own row before it is drawn, and a string that would not fit is replaced by a shorter wording rather than clipped or shrunk.

The face refuses the category default it was built against: a bezel of six tiny complications with glyph icons. It spends its whole budget on one number and three bars.

**Key Characteristics:**
- Black ground, no surfaces, no shadows, no gradients
- Every dimension is a ratio of `min(width, height)/10`
- Two type tiers: the time, and everything else
- Colour carries meaning and never carries it alone
- Primitives only; the icons are drawn, not glyphs
- Rows stack bottom-up; the time expands into the remainder

## Colors

A black field with a single white number, a muted grey voice for everything secondary, and three meaning-bearing colours that are never spent decoratively.

### Primary
- **Effort Blue** (`{colors.accent-blue}`): today's progress still under way — the mission-bar fill and the everyday ring fill. Default of four user-selectable accents.
- **Kept Gold** (`{colors.gold}`): reserved for what the user has *kept*, never for what they are doing. The streak line once the streak is non-zero, the rank line and the XP ring in HeroSet mode. Nothing else may be gold.
- **Finished Green** (`{colors.done}`): a goal that is complete. The bar fill, the column label, and the ring at full sweep.

### Secondary
- **Alert Red** (`{colors.alert}`): two uses only — a move-bar in the alert state, and battery at or below 15%. Never a progress colour.
- **Accent alternatives** (`{colors.accent-cyan}`, `{colors.accent-magenta}`, `{colors.accent-white}`): the three other settings-selectable accents. Each clears 3:1 against the track so a part-filled bar still reads, and none is gold or green.

### Neutral
- **Void Black** (`{colors.ground}`): the only background. It is never tinted, never layered, never lightened into a card.
- **Signal White** (`{colors.text}`): the time and mission values. Reserved for the two things read first.
- **Second Voice Grey** (`{colors.muted}`): date, labels, seconds, footer numbers and drawn icons, and an idle (zero) streak. Everything that supports the glance without competing for it.
- **Track Grey** (`{colors.track}`): the unfilled remainder of the ring and of every pill bar. Present so the *whole* of a goal is visible behind the part that is done.
- **Sleep Grey** (`{colors.sleep-text}`): always-on time on burn-in-protected screens. Same hex as the track, a distinct role: keep both keys.

### Named Rules

**The Never-Colour-Alone Rule.** No state is legible by hue alone, and this is auditable. Done: green label *plus* a drawn check *plus* a full bar. Streak kept: gold *plus* a day count in the words. Low battery: red *plus* the number *plus* a visibly empty icon fill. Move alert: red *plus* the word changing from OK to GO. Ring complete: green *plus* a closed sweep. Audit test: render the face in greyscale — every state must still be nameable.

**The Gold Reserve Rule.** Gold means a thing the user has accumulated and can lose. A zero streak is muted grey, not gold, because there is nothing kept yet.

**The Exact-Palette Rule.** Every colour is built from the channel values 00/55/AA/FF. A hex outside Garmin's 64-colour palette is dithered on MIP and is not permitted.

## Typography

**Time Font:** Garmin system number fonts, in a fit ladder: `FONT_NUMBER_THAI_HOT` → `FONT_NUMBER_HOT` → `FONT_NUMBER_MEDIUM`, with `FONT_NUMBER_MILD` as the floor.
**Everything-Else Font:** `FONT_XTINY`, uppercase.

**Character:** Two tiers and no middle. The time is set in the largest number face that provably fits its band and the ring's inner chord; every other word on the face is one small uppercase size. The distance between those two tiers *is* the hierarchy — there are no intermediate weights or sizes to negotiate.

### Hierarchy
- **Time** (number font, measured — 128px @454, 36px @240): the centre of the face, vertically centred in the band left between the streak row and the date row. Chosen at layout time by trying each font largest-first and accepting the first whose box fits the band *and* whose widest sample (`00:00`) fits the round chord at that height.
- **Face text** (`FONT_XTINY`, measured — 37px @454, 26px @240): streak/rank line, date, mission values, mission labels, seconds, footer numbers. One size for all of them.
- **Always-on time** (`FONT_NUMBER_MEDIUM`, fixed): the only element drawn in sleep on burn-in screens.

### Named Rules

**The Measure-Never-Guess Rule.** Every string is checked against the chord of the round display at its own row before it is drawn. Nothing is sized by assumption and nothing is clipped.

**The Shorter-Wording Rule.** When a string does not fit, the face picks a shorter *wording*, never a smaller font: `12345` → `12.3K` → `12K`; `INTENSITY` → `INT`; `WED 12 MARCH` → `WED 12`; `RANK 7  STREAK 12` → `RANK 7  12D` → `RANK 7`. Candidate lists are ordered longest-first and the last entry is the guaranteed fallback.

**The Uppercase Voice Rule.** All face copy is uppercase and terse. Words come from string resources only, so a translation is a new resource folder and no code change.

## Layout

One proportion generates the whole face: `inset = min(width, height)/10`. Everything else divides it — ring inset `inset/5`, ring width `inset/6`, bar height `inset/3`, column gap `inset/5`, stack gap `inset/9`, text margin `inset/2`. No pixel value is ever written down; the two reference devices are worked examples, not tokens. At 454 px: inset 45, ring radius 218, ring width 7. At 240 px: inset 24, ring radius 116, ring width 4.

**Rows stack bottom-up.** The footer sits one inset above the bottom edge, inside the ring's gap. The mission block sits two stack-gaps above it. The date row sits one stack-gap and one line above the missions. The streak row is pinned to the top, just inside the ring. The time then takes the entire remaining band and is centred in it — which is why the time is always the largest thing on the face, at every screen size, without a table of per-device sizes.

**Horizontal extents follow the circle, not the rectangle.** Left and right insets for any row are computed as the chord half-width of the content circle at whichever edge of that row is farther from centre. Mission columns are laid out inside that chord: three equal columns of `(chord − 2 gaps)/3` (95 px @454, 54 px @240). On non-round screens the chord math is replaced by a constant safe inset of one `inset`.

Reference stack at 454 px: streak y=52, time y=91, date y=221, missions y=263, footer y=372. At 240 px: 28, 56, 94, 122, 190.

**Two power modes, two compositions.** Awake — and asleep on MIP, where the screen is always visible — the face draws in full. Asleep on a burn-in-protected AMOLED it draws only the time, dim, in `FONT_NUMBER_MEDIUM`, and the entire block walks a 3×3 grid at `inset/2` per step, one step per minute, so no pixel stays lit.

### Named Rules

**The One Proportion Rule.** Every dimension on the face is a division of `min(width, height)/10`. A hard-coded pixel value, or a per-device layout table, is a defect.

**The Time Takes The Remainder Rule.** The time is never assigned a size. It receives the band left over after the other rows are stacked, and picks the largest font that band and chord will hold.

**The Chord Rule.** On a round screen, usable width is the chord at the row's farthest edge from centre — never the full display width. Content fits against a circle inset from the ring by half the ring width plus half the text margin, so text never touches the ring.

## Elevation & Depth

There is no elevation system. No shadows, no gradients, no blur, no layered surfaces, no borders around containers. The ground is pure black and every element is drawn flat directly onto it. This is not a stylistic restraint to be relaxed later: MIP displays have no backlight-independent tonal range to layer into, and a 64 KB budget with no bitmaps has no way to render one.

Depth is expressed as *containment* instead. The track behind every progress element (the grey 260° arc, the grey pill under every bar) shows the whole of a goal, and the coloured fill sits in the same plane on top of it. The only "in front of" relationship on the face is fill-over-track.

### Named Rules

**The Flat-By-Construction Rule.** Nothing on this face casts, glows, or layers. If a surface needs to feel distinct, it is distinguished by position and colour role, never by depth.

**The Track-Behind-Fill Rule.** Every progress element draws its full-length track first in `{colors.track}`, then its fill. A progress indicator without a visible remainder is incomplete.

## Shapes

Two shapes and one stroke. **Pills:** every mission bar is a rounded rectangle with a radius of half its own height, track and fill alike; a fill shorter than the bar is tall drops its radius to half the fill width, so the rounded ends never cross each other into a lens. **Arcs:** the bezel ring is a single stroked arc, `inset/6` wide, running clockwise from 220° through the top to 320° — a 260° sweep that leaves a 100° gap at the bottom for the footer. Any non-zero progress shows at least one degree, and a fill never closes the circle.

Drawn marks are geometric and sized off the label font, not off the screen: the done check is two lines on the label baseline with a pen of one fifth of its size (minimum 2); the battery is an outlined rectangle with a solid nub and a proportional inner fill; the heart is two circles over a triangle; the notification bubble is a rounded rectangle (radius one fifth) with a triangular tail.

### Named Rules

**The Drawn-Not-Glyph Rule.** Every mark on the face is constructed from primitives. No bitmaps, no icon fonts, no glyph characters standing in for symbols — at 64 KB there is no budget for them and at 208 px there is no fidelity in them.

**The Open Ring Rule.** The bezel arc is open at the bottom and never completes a circle. The gap is where the footer lives; closing it would take the footer's room and lose the read of "how much is left".

## Components

### Bezel Ring
The day in one arc. Track first at `{colors.track}`, then the fill from the same 220° origin. Colour carries mode: the accent while the day is in progress, `{colors.done}` at full, `{colors.gold}` in HeroSet mode where the ring is XP into the current rank. Width `{spacing.ring-width}`, radius `display radius − {spacing.ring-inset}`. Fill is average progress across the goal-bearing missions, so it is only full when every one is done.

### Mission Column
Three equal columns: value on top (`{colors.text}`, or `{colors.alert}` in an alert state), pill bar in the middle, label at the bottom. Done turns the fill and the label `{colors.done}` and prepends a drawn check sized at three quarters of the label ascent; the check and label are centred as one unit so the column stays balanced. Both value and label pick the longest wording that fits the column width. A metric with no goal draws no bar and keeps its value and label.

### Mission Bar
`{spacing.bar-height}` tall, full column width, pill-capped at both ends. Track always drawn; fill is `width × permille/1000` in the accent, or `{colors.done}` when complete. Zero progress draws track only.

### Streak / Rank Line
The top row, just inside the ring. `{colors.gold}` when there is something kept, `{colors.muted}` at zero, and the row is omitted entirely when the watch has no step goal to build a streak from. Never wraps: the wording shortens instead.

### Date Row
One muted uppercase line under the time: weekday, day, month, and optionally the temperature in whole degrees. Sourced from the system so it is translated for free; drops the month, then the temperature, on narrow chords.

### Footer
Battery, heart rate and unread notifications in the ring's bottom gap, drawn as primitive icons each followed by its number in `{colors.muted}`, the group centred as a whole. The battery number carries no percent sign — the icon already says "battery", and the saved width is what keeps three items inside the gap on a small screen. Items with nothing to say are never drawn (no heart rate reading, no notifications), and if the group still overflows the chord it drops items from the right until it fits. Battery at or below 15% turns red.

### Seconds
Optional, in `{colors.muted}` at `FONT_XTINY`, tucked against the right edge of the time on the digits' baseline, never allowed below the date row. If they will not fit the chord beside a wide time, they are not drawn at all rather than crowding the ring. They redraw alone in a clipped box during low-power partial updates.

### Always-On Time
The entire sleep composition on burn-in screens: a dim `{colors.sleep-text}` time in `FONT_NUMBER_MEDIUM`, centred, stepping across a 3×3 grid at `{spacing.inset}`/2 per cell, one cell per minute. No ring, no bars, no date, no footer.

## Do's and Don'ts

### Do:
- **Do** derive every new dimension from `min(width, height)/10`, the way `barHeight` (/3), `ringWidth` (/6), `columnGap` (/5) and `stackGap` (/9) already do.
- **Do** measure text against the round chord at its own row before drawing it, and give every string a shorter-wording fallback ordered longest-first.
- **Do** draw a full-length `{colors.track}` remainder behind every progress element.
- **Do** pair any colour-carried state with a second signal: a word, a mark, or a bar length.
- **Do** keep every new colour inside Garmin's 64-colour palette (channels 00/55/AA/FF).
- **Do** build new marks from primitives — lines, arcs, circles, polygons, rounded rectangles.
- **Do** hide an element that has no honest value rather than drawing a placeholder or a zero.

### Don't:
- **Don't** spend gold on anything but a thing the user has kept and could lose.
- **Don't** use `{colors.alert}` as a progress colour, or add a red/green distinction as the only difference between two states.
- **Don't** hard-code a pixel value or add a per-device layout table.
- **Don't** shrink a font to make text fit; shorten the wording instead.
- **Don't** close the bezel arc or fill the bottom gap — the footer lives there.
- **Don't** add shadows, gradients, tinted panels or card backgrounds; the ground is black and the face is flat.
- **Don't** ship bitmaps or icon-font glyphs.
- **Don't** put anything but the dim time on a burn-in-protected screen in sleep.
- **Don't** let anything on the face compete with the time for size.
