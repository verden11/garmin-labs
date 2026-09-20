---
version: 1
slug: "source-herofaceview-mc"
primary_target: "source/HeroFaceView.mc"
related_targets: []
---

# Surface: HeroFace watch face (round)

Scope: the whole watch face, awake and always-on. Mode: Operate (one-glance read, no input). World: inherited from HeroSet (brief-pinned); no new visual identity.

Audience/job: any Garmin wearer checking time and "am I on track today"; HeroSet owners also check reps.
Constraints: CIQ 3.0 floor, 64 KB, primitives only, 218–466 px round, MIP + AMOLED, measured text fit.

## Direction contract

THESIS: HeroSet's dashboard turned into a clock. The time owns the centre; today's goals sit as three HeroSet mission bars under it, and the bezel ring shows the day's main goal. It refuses the category default of a ring of six tiny data complications with icons.

OWN-WORLD: black ground; white numerals; MUTED 0xAAAAAA secondary text; TRACK 0x555555 tracks; blue EFFORT 0x55AAFF for today's progress; green DONE 0x00FF00 plus a drawn check for finished goals; gold 0xFFAA00 only for kept things (streak, rank, XP ring in HeroSet mode). Pill bars, a 260° bezel arc open at the bottom, uppercase XTINY labels.

STORY: glance → time; second glance → three bars show how far today's goals are; gold streak says what you keep by finishing them.

FIRST VIEWPORT: ring hugging the bezel from 7:30 clockwise to 4:30. The gold streak (or rank) line takes the narrow row inside the ring's top; the time is the largest font that fits, centred under it; the date (+weather) sits in a muted row below the time; three equal mission columns (value, pill bar, label) below that; battery, heart rate and unread notifications sit in the ring's bottom gap. No primary action; in HeroSet mode, a hold opens HeroSet.

Revisions to this block, from measurement and from wearing the face:
- **Date on top, streak and temperature under the time** (the original order, restored 2026-09-20 after the user disliked the swap). The measurement that drove the earlier swap was the date *with* its temperature: on fr965 the top row is 208 px of usable chord, `WED 30 SEP  -20°` needs 243 and would lose its month, but `WED 30 SEP` alone needs only 172 (105 of 112 on fenix5). So the date keeps the top row and the temperature moves to the wide row under the time, where it sits opposite the streak: two short items pushed to the chord's edges, either one centred when the other is absent. The top row is now always filled, and the gold streak sits with the day's data rather than above the clock.
- **Notifications are a third footer item.** A watch face that hides unread messages is less practical as a daily face, which is this surface's whole purpose. The footer drops items from the right when the ring's gap is too narrow, so it never crowds: battery and heart rate always survive.

FORM: HeroSet dashboard grammar (ring + rank line + mission bars), re-proportioned for time-first; established-world surface, brief-pinned, no concept roll (seed key: none, world pinned by the user and PRODUCT.md).

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
