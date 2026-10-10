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
  accent-magenta: "#FFAAFF"
  sleep-text: "#5C5C5C"
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
  frame-inset: "{spacing.inset}/4"          # rectangle only (ADR-005): the frame's centreline from the glass
  frame-corner-centre: "{spacing.inset}*3/2" # rectangle only: each corner's centre from both edges
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

HeroFace takes HeroSet's dashboard grammar — bezel progress ring, gold keep-line, three pill mission bars — re-proportioned so time owns the middle. All drawn from primitives on pure black: arcs, rounded rectangles, two-stroke check marks, battery outline, heart from two circles and a triangle. No bitmaps, no icon fonts: smallest supported watch-face memory budget is 64 KB; constraint is also the aesthetic. Every colour but always-on Sleep Grey sits on Garmin's 64-colour palette (channels 00/55/AA/FF): MIP screen renders exactly as written, AMOLED does not dither. Sleep Grey drawn only on burn-in-protected screens (ADR-006 (always-on time is the studio's one always-on grey)).

Density deliberately low. One ring, one gold line, one time, one date row, three columns, one footer strip: seven things, fixed bottom-up stack, on every one of 117 round products from 208 to 466 px (and, ring as frame, the 5 rectangles). Nothing positioned in absolute pixels. Single proportion — a tenth of short screen edge — generates ring, gap, bar, column, margin; time takes whatever vertical band is left between streak row and date. Text measured against round chord at its own row before drawn; string that would not fit replaced by shorter wording, not clipped or shrunk.

Face refuses category default it was built against: bezel of six tiny complications with glyph icons. Spends whole budget on one number and three bars.

**Key Characteristics:**
- Black ground, no surfaces, no shadows, no gradients
- Every dimension is a ratio of `min(width, height)/10`
- Two type tiers: time, and everything else
- Colour carries meaning, never carries it alone
- Primitives only; icons drawn, not glyphs
- Rows stack bottom-up; time expands into remainder

## Colors

Black field, single white number, muted grey voice for everything secondary, three meaning-bearing colours never spent decoratively.

### Primary
- **Effort Blue** (`{colors.accent-blue}`): today's progress still under way — mission-bar fill, everyday ring fill. Default of three user-selectable accents.
- **Kept Gold** (`{colors.gold}`): reserved for what user has *kept*, never what they are doing. Streak line once streak non-zero, rank line and XP ring in HeroSet mode. Nothing else may be gold.
- **Finished Green** (`{colors.done}`): goal complete. Bar fill, column label, ring at full sweep.

### Secondary
- **Alert Red** (`{colors.alert}`): two uses only — move-bar in alert state, battery at or below 15%. Never a progress colour.
- **Accent alternatives** (`{colors.accent-cyan}`, `{colors.accent-magenta}`): two other settings-selectable accents. Rule is 3:1 against track so part-filled bar still reads; all three pass. Magenta was `#FF55FF` (2.84, a miss); owner had it recoloured to pale magenta `#FFAAFF` on 2026-10-04 (ADR-003), same id and name. None is gold or green.

| Accent (id) | Colour | On TRACK `#555555` (rule: 3:1) | On black | On white (the time) |
|---|---|---|---|---|
| Effort Blue (0) | `#55AAFF` | 3.05 | 8.58 | 2.45 |
| Cyan (1) | `#00FFFF` | 5.95 | 16.75 | 1.25 |
| Magenta (2) | `#FFAAFF` | 4.42 | 12.45 | 1.69 |
| Magenta before 2026-10-04 | `#FF55FF` | 2.84 (missed) | 8.00 | 2.63 |

**No Pro-only accents (2026-10-10, ROADMAP 8.3, watch-design-lead under the owner's 2026-10-10 delegation; reasoning corrected after a watch-design-reviewer pass).** The studio roster's other colours fail this face's roles: amber and yellow are gold ("kept"), mint and lime are done-green, orange and coral sit on alert red, white is the time, pink (2.53) and violet (1.94) miss 3:1 on the track. Of the 64-colour values that do pass 3:1 on `#555555`, Lilac `#AAAAFF` (about 3.5) is one channel step from the default Effort Blue `#55AAFF`; `#FFAAAA` (about 4.1) is one step from Magenta `#FFAAFF` and leans toward alert red; `#FFAA55`, `#AAAA55` and `#AAAA00` read as gold. A one-step neighbour does not read as a different choice on HeroFace's thin, part-filled bars with only three accents (Two Suns admits magenta beside pink and violet because its accent fills a whole ring arc, number and bolt). So Free and Pro keep the same three; colour is not a Pro difference on HeroFace.

**Accent ids and tiers (ADR-001, the Free + Pro ladder in `docs/decisions.md`).** Ids append-only; one shade change is Magenta's, by owner (ADR-003): 0 Effort Blue `#55AAFF` (default), 1 Cyan `#00FFFF`, 2 Magenta `#FFAAFF`. **Free** build and **Pro** build offer same three; HeroFace stays at shipped three (plan's WP6 list of ids 3 to 7 is DaysToGo's table pasted in, not used). Reserved, never admitted as accent: gold, green, alert red, white, two greys, so none of Amber, Yellow, Lime, Mint, Orange, Coral or White. New accent = new id appended at end, after owner's look-approval, must clear 3:1 against track.

### Neutral
- **Void Black** (`{colors.ground}`): only background. Never tinted, never layered, never lightened into card.
- **Signal White** (`{colors.text}`): time and mission values. Reserved for two things read first.
- **Second Voice Grey** (`{colors.muted}`): date, labels, seconds, footer numbers, drawn icons. Everything supporting glance without competing.
- **Track Grey** (`{colors.track}`): unfilled remainder of ring and every pill bar. Present so *whole* goal visible behind done part.
- **Sleep Grey** (`{colors.sleep-text}`, `#5C5C5C`, 3.14:1 on black): always-on time on burn-in-protected screens, studio's one always-on grey (ADR-006 (always-on time is the studio's one always-on grey)). Was `#555555`, track's hex, 2.82:1, under 3:1 bar. Not 64-colour value: drawn only where watch reports burn-in protection (AMOLEDs and, in simulator, Venu Sq LCD; all 16-bit, so stored about `#5A5D5A`, still about 3.1:1); MIP watch keeps full face in sleep: Garmin's AMOLED FAQ ties burn-in protection to AMOLED products (DaysToGo ADR-007, amended 2026-10-04); not checked per product.

### Named Rules

**The Never-Colour-Alone Rule.** No state legible by hue alone; auditable. Done: green label *plus* drawn check *plus* full bar. Streak kept: gold *plus* day count in words. Low battery: red *plus* number *plus* visibly empty icon fill. Move alert: red *plus* word changing from OK to GO. Ring complete: green *plus* closed sweep. Audit test: render face in greyscale — every state must still be nameable.

**The Gold Reserve Rule.** Gold = thing user has accumulated and can lose. Zero streak not drawn at all ("0-DAY STREAK" would be new owner's first read), nothing kept yet. Gold streak also outranks temperature beside it: row too wide drops temperature before streak (2026-10-06).

**The Exact-Palette Rule.** Every colour but always-on Sleep Grey (`#5C5C5C`, ADR-006 (always-on time is the studio's one always-on grey)) built from channel values 00/55/AA/FF (why: see `watch-design-kit`'s `watch-design-lead` skill).

## Typography

**Time Font:** Garmin system number fonts, fit ladder: `FONT_NUMBER_THAI_HOT` → `FONT_NUMBER_HOT` → `FONT_NUMBER_MEDIUM`, `FONT_NUMBER_MILD` as floor.
**Everything-Else Font:** `FONT_XTINY`, uppercase.

**Character:** Two tiers, no middle. Time set in largest number face provably fitting its band and ring's inner chord; every other word one small uppercase size. Distance between tiers *is* hierarchy — no intermediate weights or sizes to negotiate.

### Hierarchy
- **Time** (number font, measured — 128px @454, 36px @240): face centre, vertically centred in band left between streak row and date row. Chosen at layout time: try each font largest-first, accept first whose box fits band *and* whose widest sample (`00:00`) fits round chord at that height.
- **Face text** (`FONT_XTINY`, measured — 37px @454, 26px @240): streak/rank line, date, mission values, mission labels, seconds, footer numbers. One size for all.
- **Always-on time** (`FONT_NUMBER_MEDIUM`, fixed): only element drawn in sleep on burn-in screens.

### Named Rules

**The Measure-Never-Guess Rule.** Every string checked against chord of round display at its own row before drawn. Nothing sized by assumption, nothing clipped. One stated exception: on rectangle time's digit height is measured share of font's ascent (`HeroFaceFrame.DIGIT_HEIGHT_PERMILLE`, simulator-measured), because Dc has no glyph metrics to ask (see "Rectangle").

**The Shorter-Wording Rule.** String not fitting: face picks shorter *wording*, never smaller font: `12345` → `12.3K` → `12K`; `INTENSITY` → `INT`; `WED 12 MARCH` → `WED 12`; `RANK 7  STREAK 12` → `RANK 7` (HeroSet mode has these two wordings; rank-only used only when streak does not fit alone, never to keep temperature). Candidate lists ordered longest-first, last entry guaranteed fallback.

**The Uppercase Voice Rule.** All face copy uppercase, terse. Words from string resources only, so translation = new resource folder, no code change.

## Layout

One proportion generates whole face: `inset = min(width, height)/10`. Everything else divides it — ring inset `inset/5`, ring width `inset/6`, bar height `inset/3`, column gap `inset/5`, stack gap `inset/9`, text margin `inset/2`. No pixel value ever written down; two reference devices are worked examples, not tokens. At 454 px: inset 45, ring radius 218, ring width 7. At 240 px: inset 24, ring radius 116, ring width 4.

**Rows stack bottom-up.** Footer one inset above bottom edge, inside ring's gap. Mission block two stack-gaps above it. Date row one stack-gap and one line above missions. Streak row pinned top, just inside ring. Time takes entire remaining band, centred in it — why time is always largest thing on face, every screen size, without per-device size table.

**Horizontal extents follow circle, not rectangle.** Left and right insets for any row computed as chord half-width of content circle at whichever edge of row is farther from centre. Mission columns laid out inside chord: three equal columns of `(chord − 2 gaps)/3` (95 px @454, 54 px @240). On rectangle circle replaced by frame and its rounded corners (see "Rectangle" below); on Instinct by box clipped to its visible circle.

Reference stack at 454 px: streak y=52, time y=91, date y=221, missions y=263, footer y=372. At 240 px: 28, 56, 94, 122, 190.

**Two power modes, two compositions.** Awake — and asleep on MIP, screen always visible — face draws in full. Asleep where watch reports burn-in protection (AMOLEDs; in simulator also Venu Sq LCD) draws only time, dim, `FONT_NUMBER_MEDIUM`, entire block walks 3×3 grid at `inset/2` per step, one step per minute, so no pixel stays lit.

### Named Rules

**The One Proportion Rule.** Every dimension is division of `min(width, height)/10`. Hard-coded pixel value, or per-device layout table, is defect.

**The Time Takes The Remainder Rule.** Time never assigned size. Receives band left after other rows stacked, picks largest font band and chord will hold.

**The Chord Rule.** On round screen, usable width is chord at row's farthest edge from centre — never full display width. Content fits against circle inset from ring by half ring width plus half text margin, so text never touches ring.

## Elevation & Depth

No elevation system. No shadows, gradients, blur, layered surfaces, borders around containers. Ground pure black, every element drawn flat directly onto it. Not stylistic restraint to relax later: MIP displays have no backlight-independent tonal range to layer into, and 64 KB budget with no bitmaps cannot render one.

Depth expressed as *containment* instead. Track behind every progress element (grey 260° arc, grey pill under every bar) shows whole goal, coloured fill same plane on top. Only "in front of" relationship on face is fill-over-track.

### Named Rules

**The Flat-By-Construction Rule.** Nothing on face casts, glows, or layers. Surface needing to feel distinct is distinguished by position and colour role, never depth.

**The Track-Behind-Fill Rule.** Every progress element draws full-length track first in `{colors.track}`, then fill. Progress indicator without visible remainder is incomplete.

## Shapes

Two shapes, one stroke. **Pills:** every mission bar is rounded rectangle, radius half its own height, track and fill alike; fill shorter than bar is tall drops radius to half fill width, so rounded ends never cross into lens. **Arcs:** bezel ring is single stroked arc, `inset/6` wide, clockwise from 220° through top to 320° — 260° sweep leaving 100° gap at bottom for footer. Any non-zero progress shows at least one degree; fill never closes circle.

Drawn marks geometric, sized off label font, not screen: done check is two lines on label baseline, pen one fifth of its size (minimum 2); battery is outlined rectangle with solid nub and proportional inner fill; heart is two circles over triangle; notification bubble is rounded rectangle (radius one fifth) with triangular tail.

### Named Rules

**The Drawn-Not-Glyph Rule.** Every mark constructed from primitives. No bitmaps, no icon fonts, no glyph characters standing in for symbols — at 64 KB no budget, at 208 px no fidelity.

**The Open Ring Rule.** Bezel arc open at bottom, never completes circle. Gap is where footer lives; closing it would take footer's room and lose read of "how much is left".

## Components

### Bezel Ring
Day in one arc. Track first at `{colors.track}`, then fill from same 220° origin. Colour carries mode: accent while day in progress, `{colors.done}` at full, `{colors.gold}` in HeroSet mode where ring is XP into current rank. Width `{spacing.ring-width}`, radius `display radius − {spacing.ring-inset}`. Fill is average progress across goal-bearing missions, so only full when every one done. **MOVE is not one of them** (owner, 2026-10-06, ADR-005 amendment): its bar full while not idle, which made ring read a third done at zero activity and turn green beside MOVE bar never "done".

### Mission Column
Three equal columns: value on top (`{colors.text}`, or `{colors.alert}` in alert state), pill bar middle, label bottom. Done turns fill and label `{colors.done}`, prepends drawn check sized at three quarters of label ascent; check and label centred as one unit so column stays balanced. Value and label both pick longest wording fitting column width. Metric with no goal draws no bar, keeps value and label. **Icons for clipped words (2026-10-05, owner, ROADMAP 13.11):** steps, calories, intensity minutes, floors draw primitive icon (footprints, flame, pulse line, stairs; `HeroFaceIcon`; not a bolt, which means Body Battery across studio, label font's capital height, on its baseline) instead of `STEP`, `CAL`, `INT`, `FLR`; done keeps check and green; on Instinct reversed pill holds icon. Distance (KM/MI), MOVE and HeroSet's three exercises keep words. **On rectangle done label too wide for its column with check drops check** (green word and full bar still say done); only label too wide on its own is cut with "." as on Instinct (Lithuanian push-ups and sit-ups on Venu Sq 2, 2026-10-06). **MOVE has no value until it alerts** (ROADMAP 13.10): bar alone while quiet, red word GO on alert (red plus word, never colour alone); `OK` no longer drawn.

### Mission Bar
`{spacing.bar-height}` tall, full column width, pill-capped both ends. Track always drawn; fill is `width × permille/1000` in accent, or `{colors.done}` when complete. Zero progress draws track only.

### Streak / Rank Line
**As built (2026-10-05, ROADMAP 13.8):** row under time, one centred group: streak (gold, or muted at zero) then temperature (muted), column gap between. Too wide: streak's shorter wording, then temperature drops. Temperature therefore never jumps between row's centre and edge. Row empty (no streak yet and no temperature, which is Free's first days): time moves down half a row so no empty band sits under it (ROADMAP 13.9). Paragraph below is original plan.

Top row, just inside ring. `{colors.gold}` when something kept, `{colors.muted}` at zero, row omitted entirely when watch has no step goal to build streak from. Never wraps: wording shortens instead.

### Date Row
**As built:** date has narrow row inside ring's top, alone (temperature beside it does not fit there, `HeroFaceLayout.stackRows`); temperature in row under time (above). Original plan: one muted uppercase line under time: weekday, day, month, optionally temperature in whole degrees. Sourced from system so translated for free; drops month, then temperature, on narrow chords.

### Footer
Battery, heart rate, unread notifications in ring's bottom gap, drawn as primitive icons each followed by number in `{colors.muted}`, group centred as whole. Battery number carries no percent sign — icon already says "battery", saved width keeps three items inside gap on small screen. Items with nothing to say never drawn (no heart rate reading, no notifications); if group still overflows chord, drops items from right until fits. Battery at or below 15% turns red.

### Seconds
Optional, `{colors.muted}` at `FONT_XTINY`, tucked against right edge of time on digits' baseline, never allowed below date row. If they will not fit chord beside wide time, not drawn at all rather than crowding ring. Redraw alone in clipped box during low-power partial updates. **On rectangle** time keeps seconds' width free both sides by taking next number font down while seconds on (Venu X1 `THAI_HOT` to `HOT`, Venu Sq 2 `HOT` to `MEDIUM`; Venu Sq keeps `THAI_HOT`), grows back once if watch cuts seconds for power budget.

### Always-On Time
Entire sleep composition on burn-in screens: dim `{colors.sleep-text}` (`#5C5C5C`, 3.14:1, ADR-006 (always-on time is the studio's one always-on grey)) time in `FONT_NUMBER_MEDIUM`, centred, stepping across 3×3 grid at `{spacing.inset}`/2 per cell, one cell per minute. No ring, bars, date, footer. Simulator 24-hour heat map in `#5C5C5C` (2026-10-08, Pro): no burn-in detected, peak luminance 1.35% on `fr965` (1.23% in `#555555`, 2026-10-05) and 1.22% on `venux1`; frames in `../device-test/rect-review/aod-grey/`. Simulator only, nothing on a wrist.

## Do's and Don'ts

### Do:
- **Do** derive every new dimension from `min(width, height)/10`, as `barHeight` (/3), `ringWidth` (/6), `columnGap` (/5), `stackGap` (/9) already do.
- **Do** measure text against round chord at its own row before drawing, give every string shorter-wording fallback ordered longest-first.
- **Do** draw full-length `{colors.track}` remainder behind every progress element.
- **Do** pair any colour-carried state with second signal: word, mark, or bar length.
- **Do** keep every new colour inside Garmin's 64-colour palette (channels 00/55/AA/FF); always-on Sleep Grey is the one exception (ADR-006 (always-on time is the studio's one always-on grey)).
- **Do** build new marks from primitives — lines, arcs, circles, polygons, rounded rectangles.
- **Do** hide element with no honest value rather than drawing placeholder or zero.

### Don't:
- **Don't** spend gold on anything but thing user has kept and could lose.
- **Don't** use `{colors.alert}` as progress colour, or add red/green distinction as only difference between two states.
- **Don't** hard-code pixel value or add per-device layout table.
- **Don't** shrink font to make text fit; shorten wording instead. (One stated exception: rectangle's time steps down a size while Pro's seconds on, see Seconds.)
- **Don't** close bezel arc or fill bottom gap — footer lives there.
- **Don't** add shadows, gradients, tinted panels, card backgrounds; ground black, face flat.
- **Don't** ship bitmaps or icon-font glyphs.
- **Don't** put anything but dim time on burn-in-protected screen in sleep.
- **Don't** let anything on face compete with time for size.

## Instinct (1-bit, a round window top right; ADR-002, accepted 2026-10-04, simulator only)

Black and white only: every colour role white (gold, green, red, accent collapse; Never-Colour-Alone rule already had shape or word for each state: outlined track under solid fill, drawn check and full bar for done, number beside every icon). **Bezel ring becomes gauge in round window** (hairline circle, thick fill from 12 o'clock clockwise, closed when every goal done). Time and date share band left of window, streak just below it, three mission columns end above bottom corners. **No footer, temperature or seconds** (smallest font 23 px tall on 176 px screen). Visible: square cut by circle about 98 px radius, so rows clipped to 96 px circle. Mockup (`docs/archive/instinct-mockup.html`) is approved look, not built layout. **Finished goal there is reversed label** (black on white pill, no check, 2026-10-04, ADR-002 amendment): columns about 42 px, "check + STEP" cut label to "ST.".

## Rectangle (Venu Sq, Sq 2, X1; ADR-005, proposed 2026-10-05, amended 2026-10-05/06 with two owner decisions of 2026-10-06 (keep the edge frame; MOVE leaves the ring's score), simulator only, needs the owner's look-approval)

Square design, not round one in a box: ring becomes track along screen's edges, every row takes frame's full width.

**Bezel ring becomes frame along screen's edges**: open-bottom rounded rectangle whose centreline sits quarter inset in from glass (visible black band between frame and glass, about 8 px at 448), sixth of inset wide. Each corner quarter circle centred 1.5 insets in from both edges, so on Venu X1, glass corner about 68 px (1.55 insets), frame runs nearly concentric with glass, margin stays even round corner; Venu Sq and Sq 2 glass almost square, there round corner is design's own. Track first, then fill measured along path from lower end of left side, up, over top, down right side: clockwise from lower left, like round ring, open at bottom where footer lives (the Open Ring Rule). Share filled is share of path's length. Does not start at top centre like studio's closed rectangle tracks: open path started there would split fill across footer gap (ADR-005 amendment). Same colour roles: accent, green when every goal done, gold for XP in HeroSet mode.

**Time is hero, sized by its ink.** Number font's box about a third empty (headroom above digits, descent below), so on rectangle time chosen and placed by its digits: largest number font whose digits (0.72 of ascent; measured 0.68 to 0.69 on simulator screenshots, not on a watch: wrist check that time's ink clears date and row under it on Sq 2 and X1 is open) leave stack gap above and below in band between date and row under time, and whose widest time fits frame. Measured: `THAI_HOT` on Venu Sq (39 px digits) and X1 (108 px, width-bound: 364 of frame's 398), `HOT` on Sq 2 (80 px; `THAI_HOT` is 311 px wide, frame 284).

**Stack balanced, not top-heavy.** Rows keep round order (date, time, streak and temperature, missions, footer in open bottom) and One Proportion Rule, with half-inset top and bottom margins (no chord to clear). Height time's digits do not use shared evenly by gap above time, gap under it, gap above footer, so missions and row under time rise together, no hole opens under time. With nothing under time (Free's first days) time moves down half a row, as on round screens.

**Horizontal extents follow frame, not circle:** content fits half ring width plus half text margin inside its centreline and inside rounded corner at all four corners (X1's glass rounded at bottom too). **Pro's seconds** keep width free both sides of time (stays centred) only while drawn: with seconds on, Sq 2 time is `MEDIUM`, X1's `HOT`; Free, no seconds, never pays for them. Always-on unchanged: dim time on 3 x 3 drift wherever watch asks for burn-in protection (simulator does on all three sizes, Venu Sq's LCD included; whether real Venu Sq asks for it is unverified on a watch, and if not, full face draws in sleep as on round MIP watches; compatibility.md).