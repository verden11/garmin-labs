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
  span: "0.8 of the content radius above and below the centre"
components:
  bezel-ring-track:
    textColor: "{colors.track}"
    height: "{spacing.ring-width}"
  bezel-ring-fill:
    textColor: "accent (setting)"
    height: "{spacing.ring-width}"
---

# Design

## Direction

**One number.** Black ground. The day count is the largest thing on the screen, white, in the largest system numeric font that fits the height left over. A thin ring around the bezel drains clockwise from the top as the date approaches (square root of the share of the next 365 days still to go, so the last days stay visible) and is full, in the accent, on the day. More than a year out it is the grey track only, so a full accent ring can only mean the day itself. State is never colour alone: the words TODAY, HOURS, DAYS SINCE carry it.

## Rows, top to bottom

time · event name (accent, optional) · **hero** · caption · date (words) · bottom line (optional, off by default).

Each row takes the largest font up to a height cap; the hero takes the rest. On a small screen optional rows drop, footer first, then name, then date, until the hero has room for its smallest font (ADR-012). Every text is measured against the round chord at its row; a long name shrinks and then ends in "...".

## Always-on (AMOLED)

Hero and time only, `#555555`, the block stepping across a 3 × 3 grid (steps of 3.5% of the screen, about 16 px on 454, more than a digit stroke) once a minute; the hero is two sizes smaller than awake (starts at FONT_NUMBER_MEDIUM). No ring, name, date or caption. MIP watches keep the full face.

## Constraints

Primitives and system fonts only, no bitmaps. Every colour has channels 00, 55, AA or FF (the 64-colour palette), so MIP renders it exactly. The look is the spec's recommended direction; the owner may replace it with a design-tool mock-up (`docs/plan.md` phase 4 gate).
