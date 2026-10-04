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

## Timed events, to the minute (Pro, ADR-018)

A Pro event with a time (Time of day, Minute) and, optionally, an Event time zone changes **no row, font or colour**. The last 24 hours before the event's instant still read as the hero `H:MM` over the caption HOURS (for example `7:51`, rounded up to the minute so it never says `0:00` while time is left; `24:00` at most, which is the widest string and was already in the screen-fit states), with the ring as the share of those 24 hours. What the zone moves is only **when** that state starts and **when** TODAY arrives; the day count before it is whole local calendar days and flips at the watch's own midnight, so the same event shows the same number of days on any wrist. On an Instinct the hero is the same text in white on black, beside the window as before. There is no zone label on the face: the zone is a setting, never a row (one number, nothing more).

## Rows, top to bottom

time · event name (accent, optional) · **hero** · caption · date (words) · bottom line (optional, off by default).

Each row takes the largest font up to a height cap; the hero takes the rest. On a small screen optional rows first change shape and then drop: when the bottom line cannot have a row of its own it shares the date row ("Sat Dec 19 · 50%", ADR-016), then it drops, then the name, then the date, until the hero has room for its smallest font (ADR-012). A name steps down a font before it is cut short. Every text is measured against the round chord at its row; a long name shrinks and then ends in "...".

## Always-on (AMOLED)

Hero and time only, `#555555`, the block stepping across a 3 × 3 grid (steps of 3.5% of the screen, about 16 px on 454, more than a digit stroke) once a minute; the hero is two sizes smaller than awake (starts at FONT_NUMBER_MEDIUM). No ring, name, date or caption. MIP watches keep the full face.

## On-watch date picker (Customize, "Set date")

Three columns that share the screen width, so each label must fit a third of it. The month is the **short word in the watch's language** (the same "Oct" the date row uses, `DaysToGoDateText.monthWord`), never the full name. The label font steps down with the screen: `FONT_TINY` up to 176 px (the Instinct family), `FONT_SMALL` up to 280 px (the MIP watches), `FONT_MEDIUM` above (ADR-005, amended 2026-10-04). The year column's first entry ("Every year") is broken after its first word onto two lines. White text on a black ground: the picker clears to black first, as the SDK's own Picker sample does (the simulator ignores that clear on a colour MIP watch, so only a wrist can confirm it).

## Constraints

Primitives and system fonts only, no bitmaps. Every colour has channels 00, 55, AA or FF, the device-safe palette (why: see `watch-design-kit`'s `watch-design-lead` skill). The look is the spec's recommended direction; the owner may replace it with a design-tool mock-up (`docs/archive/plan.md` phase 4 gate).
