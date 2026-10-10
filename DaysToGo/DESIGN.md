---
name: Days To Go
description: One number on black, a thin ring that drains toward the day, drawn with primitives and system fonts.
colors:
  ground: "#000000"
  text: "#FFFFFF"
  muted: "#AAAAAA"
  track: "#555555"
  sleep-text: "#5C5C5C"
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

**One number.** Black ground. Day count largest thing on screen, white, largest system numeric font fitting leftover height. Thin ring around bezel drains clockwise from top as date nears (square root of share of next 365 days still to go, so last days stay visible); full, in accent, on the day. Stops at 95% (18 degree gap) until then; more than a year out = grey track only, so full accent ring can only mean the day itself. Pro timed event's last 24 hours stay on same scale (5% at 24 hours, sliver at end), so ring never restarts (owner, 2026-10-05, ROADMAP 13.1). State never colour alone: words TODAY, HOURS, DAYS SINCE carry it.

## Timed events, to the minute (Pro, ADR-018)

Pro event with time (Time of day, Minute) and optionally Event time zone changes no colour. Last 24 hours before event's instant read as hero `7h 51m`, no caption row (ADR-018 amendment, 2026-10-05, ROADMAP 13.2: `7:51` over HOURS read as second clock): digits in hero's number font, letters "h" and "m" in largest letter font up to 45% of digits' height, on digits' baseline, two letter-spaces between groups. Rounded up to minute, so never says `0m` while time left; `24h 00m` at most, widest state in screen-fit test, ring on same square-root scale as days (5% at 24 hours down to sliver; ROADMAP 13.1). Zone moves only **when** that state starts and **when** TODAY arrives; day count before it = whole local calendar days, flips at watch's own midnight, so same event shows same number of days on any wrist. On Instinct hero = same text white on black, beside window as before. No zone label on face: zone is setting, never a row (one number, nothing more).

## Rows, top to bottom

time · event name (accent, optional) · **hero** · caption · date (words) · bottom line (optional, off by default).

**Marks (2026-10-05, owner, ROADMAP 13.3 and 13.4; `DaysToGoMark`, primitives in row's colour, about 45% of its font's height):** date row = event's date, not today's, so while event ahead (days, weeks or Pro's last 24 hours) it starts with arrow (`→ Nov 18`); on the day and after none. Pro's bottom line starts with battery outline or pair of footprints, so `50%` and `6.4K` say what they are, no word to translate. Mark = row part like a word: measured into row's width, fit test checks its box.

Each row takes largest font up to height cap; hero takes rest. On small screen optional rows first change shape then drop: when bottom line cannot have own row it shares date row ("→ Sat Dec 19 · ▭ 50%", ADR-016 (rectangle spans, since retired by ADR-019); chord too narrow for that drops arrow first, then bottom line), then drops, then name, then date, until hero has room for smallest font (ADR-012 (hero font minimum)). Name steps down a font before cut short. Every text measured against round chord at its row (on rectangle, rounded box inside track); long name shrinks then ends in "...".

## Always-on (AMOLED)

Hero and time only, `#5C5C5C` (3.14:1 on black, computed; studio's one always-on grey, ADR-007 amendment 2026-10-08 (always-on grey); was `#555555`, 2.82:1, under 3:1 bar; not a 64-colour value: drawn only where watch reports burn-in protection, AMOLEDs and, in simulator, Venu Sq LCD; all 16-bit, so stored as about `#5A5D5A`, still about 3.1:1, computed; MIP watch keeps full face in sleep: Garmin's AMOLED FAQ ties burn-in protection to AMOLED products (DaysToGo ADR-007 (always-on), amended 2026-10-04); not checked per product), block stepping across 3 × 3 grid (steps of 3.5% of screen, about 16 px on 454, more than digit stroke) once a minute; hero two sizes smaller than awake (starts at FONT_NUMBER_MEDIUM). No ring, name, date or caption. Error frame ("?", when settings cannot be read) dims and drifts same way while asleep there (ADR-007 amendment 2026-10-08 (always-on grey); unit test only: simulator cannot force it, no heat map, nothing on a wrist). MIP watches keep full face. Simulator 24-hour heat map in `#5C5C5C` (2026-10-08, Pro): no burn-in detected, peak luminance 0.86% on `fr965` (0.84% in `#555555`, 2026-10-05) and 0.79% on `venux1`; frames in `../device-test/rect-review/aod-grey/DaysToGo/`. Simulator only, nothing on a wrist. Block uses 0.8 span on round products; rectangle uses box inside its track made smaller by drift step (ADR-019 (rectangles get a square design), which retired ADR-016's (rectangle spans) rectangle spans).

## Rectangle (Venu Sq, Sq 2, X1; ADR-019)

Square watch gets square face, not round one inscribed in it (owner, 2026-10-05). **Ring follows screen:** closed rounded-rectangle track along glass edge, inset as round ring is inset from bezel (gap `d × 0.010`, then same `d × 0.025` stroke), grey, accent fill on it. Starts at top centre, drains clockwise exactly like round ring: share of ring = same share of track's length (straight runs plus four quarter-circle corners), same square-root scale, same 95% cap with gap just left of 12 o'clock, grey only beyond a year, whole closed track in accent on the day. Corner radius of centreline `d × 0.150`, studio's 1.5-inset corner proportion (as in HeroFace's rectangle frame, `HeroFaceLayout.frameBox`) (67 px on Venu X1, 48 on Sq 2, 36 on Sq): X1's glass rounded about 60 to 68 px (measured off alpha mask of SDK's device image, depending on which edge row is read; HeroSet reads 60; Sq and Sq 2 skins show about 10 px), track's outer corner (72 px there) clears it at 45° diagonal with room. Straight runs = filled boxes, corners = arcs overlapping runs by a degree so no seam shows at joins.

**Content uses the square:** rows run full height of box inside track's inner edge (less text margin), top to bottom, not span of a circle, every row measured against that box including rounded corners (corners share track's centres). Hero takes largest system number font whose digits (its ascent; digits have no descent) fit height left, caption a row gap under digits' baseline as its unit, in font's empty padding; spare height split so gap above digits' ink and gap below last row match where band allows (on Sq 2 with a name too little spare: number sits right under name and gap above reads about 18 px larger) (ascent's empty padding over digits taken off top share; digits' ink ≈ 68 % of ascent, measured on X1), bottom rows rise off corners' curve. TODAY gets exactly a number face's lift (its band less caption row it lacks), so date does not move on the day; SET A DATE, nothing under it, stays centred under time. With caption tucked under digits, every size and tier keeps full date wording (`→ Sun Mar 14 2027`, simulator). With 16-character name, date and Pro's bottom line on own row, nothing dropped on any of three sizes (simulator); on Sq 2 that busiest Pro state takes next number font down, as round watch does when bottom line takes a row. Always-on: same box made smaller by drift step, so drifting time and hero stay inside; rectangle drifts at least 24 px. On 240 px Venu Sq 3.5 % step is 8 px, and simulator's 24-hour heat map shut screen off after 3 minutes (pixels lit three minutes running, with build before ADR-019 too); 16 px lasted 7 minutes; 24 px passes (simulator).

**Simulator only.** Glass radii come from SDK's device images, not a watch: track clears rounded glass corner of up to about 46 px on Sq, 62 on Sq 2 and 84 on X1, so only rounder real glass would clip it. Venu Sq is LCD; simulator draws always-on frame there (it reports burn-in protection), what watch draws asleep unknown until a wrist shows it.

## On-watch date picker (Customize, "Set date")

Three columns sharing screen width, so each label must fit a third of it. Month = **short word in watch's language** (same "Oct" date row uses, `DaysToGoDateText.monthWord`), never full name. Label font steps down with screen: `FONT_TINY` up to 176 px (Instinct family), `FONT_SMALL` up to 280 px (MIP watches), `FONT_MEDIUM` above (ADR-005 (picker label fonts), amended 2026-10-04). Year column's first entry ("Every year") broken after first word onto two lines. White text on black ground: picker clears to black first, as SDK's own Picker sample does (simulator ignores that clear on colour MIP watch, so only a wrist can confirm it).

How many columns show at once is system's, per device (its picker slots): one at a time on rounds and Venu X1, carousel of three (focused in middle) on Venu Sq. Venu Sq 2 and Sq 2 Music get no picker at all: focused slot 30 px wide, so no label fits (ADR-020 (no on-watch picker on the Sq 2)).

## Constraints

Primitives and system fonts only, no bitmaps. Every colour but always-on grey (`sleep-text`, `#5C5C5C`, drawn only where watch reports burn-in protection, ADR-007 amendment 2026-10-08 (always-on grey), pinned by `alwaysOnGreyReadsOnBlack`) has channels 00, 55, AA or FF, device-safe palette (why: see `watch-design-kit`'s `watch-design-lead` skill). Look = spec's recommended direction; owner may replace it with design-tool mock-up (`docs/archive/plan.md` phase 4 gate).