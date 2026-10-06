---
name: Days To Go
description: One number on black, a thin ring that drains toward the day, drawn with primitives and system fonts.
colors:
  ground: "#000000"
  text: "#FFFFFF"
  muted: "#AAAAAA"
  track: "#555555"
  sleep-text: "#555555"
  accent-mint: "#55FFAA"
  accent-amber: "#FFAA00"
  accent-sky: "#55AAFF"
  accent-pink: "#FF55AA"
  accent-violet: "#AA55FF"
  accent-white: "#FFFFFF"
typography:
  hero:
    fontFamily: "Graphics.FONT_NUMBER_THAI_HOT → FONT_NUMBER_HOT → FONT_NUMBER_MEDIUM → FONT_NUMBER_MILD"
    fontSize: "measured per device; takes the height the other rows leave"
    lineHeight: 1
  hero-word:
    fontFamily: "Graphics.FONT_LARGE → MEDIUM → SMALL → TINY → XTINY (number fonts have no letters)"
    fontSize: "measured per device"
  time:
    fontFamily: "Graphics.FONT_NUMBER_MEDIUM → FONT_NUMBER_MILD → FONT_MEDIUM … FONT_XTINY"
    fontSize: "largest under 13% of the shorter screen side"
  small:
    fontFamily: "Graphics.FONT_TINY → FONT_XTINY"
    fontSize: "largest under 8 to 9% of the shorter screen side"
spacing:
  d: "min(width,height)"
  ring-width: "d × 0.025"
  ring-gap: "d × 0.010"
  text-margin: "d × 0.020"
  row-gap: "d × 0.012"
  span: "0.8 of the content radius above and below the centre (round)"
  track-corner: "d × 0.150 (rectangle: the track's centreline corner radius)"
components:
  bezel-ring-track:
    textColor: "{colors.track}"
    height: "{spacing.ring-width}"
  bezel-ring-fill:
    textColor: "accent (setting)"
    height: "{spacing.ring-width}"
  rectangle-track:
    textColor: "{colors.track}, fill in the accent"
    height: "{spacing.ring-width}"
    rounded: "{spacing.track-corner}"
---

# Design

## Direction

**One number.** Black ground. The day count is the largest thing on the screen, white, in the largest system numeric font that fits the height left over. A thin ring around the bezel drains clockwise from the top as the date approaches (square root of the share of the next 365 days still to go, so the last days stay visible) and is full, in the accent, on the day. It stops at 95% (an 18 degree gap) until then, and more than a year out it is the grey track only, so a full accent ring can only mean the day itself. A Pro timed event's last 24 hours stay on the same scale (5% at 24 hours, a sliver at the end), so the ring never restarts (owner, 2026-10-05, ROADMAP 13.1). State is never colour alone: the words TODAY, HOURS, DAYS SINCE carry it.

## Timed events, to the minute (Pro, ADR-018)

A Pro event with a time (Time of day, Minute) and, optionally, an Event time zone changes no colour. The last 24 hours before the event's instant read as the hero `7h 51m` with no caption row (ADR-018 amendment, 2026-10-05, ROADMAP 13.2: `7:51` over HOURS read as a second clock): the digits in the hero's number font, the letters "h" and "m" in the largest letter font up to 45% of the digits' height, on the digits' baseline, two letter-spaces between the groups. Rounded up to the minute so it never says `0m` while time is left; `24h 00m` at most, the widest state in the screen-fit test, with the ring on the same square-root scale as the days (5% at 24 hours down to a sliver; ROADMAP 13.1). What the zone moves is only **when** that state starts and **when** TODAY arrives; the day count before it is whole local calendar days and flips at the watch's own midnight, so the same event shows the same number of days on any wrist. On an Instinct the hero is the same text in white on black, beside the window as before. There is no zone label on the face: the zone is a setting, never a row (one number, nothing more).

## Rows, top to bottom

time · event name (accent, optional) · **hero** · caption · date (words) · bottom line (optional, off by default).

**Marks (2026-10-05, owner, ROADMAP 13.3 and 13.4; `DaysToGoMark`, primitives in the row's colour, about 45% of its font's height):** the date row is the event's date, not today's, so while the event is ahead (days, weeks or Pro's last 24 hours) it starts with an arrow (`→ Nov 18`); on the day and after there is none. Pro's bottom line starts with a battery outline or a pair of footprints, so `50%` and `6.4K` say what they are with no word to translate. A mark is a row part like a word: it is measured into the row's width, and the fit test checks its box.

Each row takes the largest font up to a height cap; the hero takes the rest. On a small screen optional rows first change shape and then drop: when the bottom line cannot have a row of its own it shares the date row ("→ Sat Dec 19 · ▭ 50%", ADR-016; a chord too narrow for that drops the arrow first, then the bottom line), then it drops, then the name, then the date, until the hero has room for its smallest font (ADR-012). A name steps down a font before it is cut short. Every text is measured against the round chord at its row; a long name shrinks and then ends in "...".

## Always-on (AMOLED)

Hero and time only, `#555555`, the block stepping across a 3 × 3 grid (steps of 3.5% of the screen, about 16 px on 454, more than a digit stroke) once a minute; the hero is two sizes smaller than awake (starts at FONT_NUMBER_MEDIUM). No ring, name, date or caption. MIP watches keep the full face. The block uses the 0.8 span on every product, rectangles too (awake, a rectangle uses 0.9; asleep that cut the time, ADR-016 (bottom line and name step-down), amendment 5, 2026-10-05).

## Rectangle (Venu Sq, Sq 2, X1; ADR-019)

A square watch gets a square face, not the round one inscribed in it (owner, 2026-10-05). **The ring follows the screen:** a closed rounded-rectangle track along the glass edge, inset from it as the round ring is inset from the bezel (gap `d × 0.010`, then the same `d × 0.025` stroke), grey, the accent fill on it. It starts at top centre and drains clockwise exactly like the round ring: a share of the ring is the same share of the track's length (straight runs plus four quarter-circle corners), the same square-root scale, the same 95% cap with its gap just left of 12 o'clock, grey only beyond a year, and the whole closed track in the accent on the day. Corner radius of the centreline `d × 0.150` (67 px on the Venu X1, 48 on Sq 2, 36 on Sq): the X1's glass is rounded about 64 px (measured off the alpha mask of the SDK's device image; Sq and Sq 2 skins show about 10 px), and the track's outer corner (72 px there) clears it at the 45° diagonal with room. Straight runs are filled boxes, corners arcs that overlap the runs by a degree so no seam shows at the joins.

**The content uses the square:** the rows run the full height of the box inside the track's inner edge (less the text margin), top to bottom, not a span of a circle, and every row is measured against that box including its rounded corners (the corners share the track's centres). The hero takes the largest system number font the height left allows; it keeps a band of that font's height plus half the spare height, so the caption stays under the number as its unit, and the rows below rise by the other half, which also keeps the date out of the bottom corners' curve. With a 16-character name, the date and Pro's bottom line on its own row, nothing is dropped on any of the three sizes (simulator). Always-on: the same box made smaller by the drift step, so the drifting time and hero stay inside it; a rectangle drifts at least 16 px (the 3.5 % step is 8 px on the 240 px Venu Sq, under the hero's strokes, and the simulator's heat map shut the screen off for pixels lit three minutes).

**Simulator only.** The glass radii come from the SDK's device images, not a watch: a real Venu Sq 2's glass may be rounder, and a wrist settles it. The Venu Sq is LCD; the simulator draws the always-on frame there (it reports burn-in protection), what the watch draws asleep is unknown until a wrist shows it.

## On-watch date picker (Customize, "Set date")

Three columns that share the screen width, so each label must fit a third of it. The month is the **short word in the watch's language** (the same "Oct" the date row uses, `DaysToGoDateText.monthWord`), never the full name. The label font steps down with the screen: `FONT_TINY` up to 176 px (the Instinct family), `FONT_SMALL` up to 280 px (the MIP watches), `FONT_MEDIUM` above (ADR-005, amended 2026-10-04). The year column's first entry ("Every year") is broken after its first word onto two lines. White text on a black ground: the picker clears to black first, as the SDK's own Picker sample does (the simulator ignores that clear on a colour MIP watch, so only a wrist can confirm it).

## Constraints

Primitives and system fonts only, no bitmaps. Every colour has channels 00, 55, AA or FF, the device-safe palette (why: see `watch-design-kit`'s `watch-design-lead` skill). The look is the spec's recommended direction; the owner may replace it with a design-tool mock-up (`docs/archive/plan.md` phase 4 gate).
