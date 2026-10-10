---
name: Verden
description: One studio, one games-style identity program; every app is an event with its own color field and pictograms on a shared grid.
colors:
  paper: "#ffffff"
  ink: "#14161a"
  ink-secondary: "#4b515a"
  rule: "#dcdfe4"
  studio-silver: "#c3c9cf"
  on-studio: "#15181c"
  studio-ink: "#4b5663"
  heroset-amber: "#ffaa00"
  on-heroset: "#15130f"
  heroface-blue: "#55aaff"
  on-heroface: "#0a1420"
  daystogo-mint: "#55ffaa"
  on-daystogo: "#04140c"
  twosuns-coral: "#ff6f8f"
  on-twosuns: "#240a10"
  paper-dark: "#0e1013"
  ink-dark: "#eceef1"
  ink-secondary-dark: "#a6adb7"
  rule-dark: "#2a2f36"
  studio-ink-dark: "#c3c9cf"
typography:
  display:
    fontFamily: "'Archivo Variable', 'Archivo', system-ui, sans-serif"
    fontSize: "clamp(3.5rem, 9.5vw, 6rem)"
    fontWeight: 850
    lineHeight: 0.9
    letterSpacing: "-0.035em"
    fontVariation: "'wdth' 125"
  statement:
    fontFamily: "'Archivo Variable', 'Archivo', system-ui, sans-serif"
    fontSize: "clamp(2.4rem, 6vw, 4.5rem)"
    fontWeight: 850
    lineHeight: 1.08
    letterSpacing: "-0.035em"
    fontVariation: "'wdth' 112"
  headline:
    fontFamily: "'Archivo Variable', 'Archivo', system-ui, sans-serif"
    fontSize: "clamp(2rem, 4.6vw, 3.4rem)"
    fontWeight: 800
    lineHeight: 1.08
    letterSpacing: "-0.03em"
    fontVariation: "'wdth' 112"
  numeral:
    fontFamily: "'Archivo Variable', 'Archivo', system-ui, sans-serif"
    fontSize: "clamp(2.6rem, 6.4vw, 4.75rem)"
    fontWeight: 800
    lineHeight: 1
    letterSpacing: "-0.03em"
    fontFeature: "'tnum' 1"
    fontVariation: "'wdth' 112"
  title:
    fontFamily: "'Archivo Variable', 'Archivo', system-ui, sans-serif"
    fontSize: "1.2rem"
    fontWeight: 750
    lineHeight: 1.08
  lede:
    fontFamily: "'Archivo Variable', 'Archivo', system-ui, sans-serif"
    fontSize: "1.15rem"
    fontWeight: 400
    lineHeight: 1.6
  body:
    fontFamily: "'Archivo Variable', 'Archivo', system-ui, sans-serif"
    fontSize: "1.0625rem"
    fontWeight: 400
    lineHeight: 1.6
  label:
    fontFamily: "'Archivo Variable', 'Archivo', system-ui, sans-serif"
    fontSize: "0.8rem"
    fontWeight: 700
    letterSpacing: "0.1em"
  wordmark:
    fontFamily: "'Archivo Variable', 'Archivo', system-ui, sans-serif"
    fontSize: "0.95rem"
    fontWeight: 800
    letterSpacing: "0.02em"
    fontVariation: "'wdth' 125"
rounded:
  none: "0"
  pill: "999px"
  round: "50%"
  focus: "2px"
spacing:
  space-1: "0.5rem"
  space-2: "1rem"
  space-3: "1.5rem"
  space-4: "2.5rem"
  space-5: "clamp(3.5rem, 8vw, 6.5rem)"
  gutter: "clamp(16px, 4vw, 40px)"
  wrap: "76rem"
components:
  button-store:
    backgroundColor: "{colors.on-heroset}"
    textColor: "{colors.heroset-amber}"
    rounded: "{rounded.none}"
    padding: "0.75rem 1.4rem"
    height: "3rem"
  status-plate:
    textColor: "{colors.on-heroset}"
    rounded: "{rounded.none}"
    padding: "0.75rem 1.4rem"
    height: "3rem"
  app-bar:
    backgroundColor: "{colors.heroset-amber}"
    textColor: "{colors.on-heroset}"
    height: "4rem"
  key:
    textColor: "{colors.ink}"
    rounded: "{rounded.pill}"
    padding: "0.45rem 0.6rem"
  note:
    backgroundColor: "{colors.heroset-amber}"
    textColor: "{colors.on-heroset}"
    rounded: "{rounded.none}"
    padding: "1rem 1.5rem"
  truth-field:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.paper}"
---
# Design System: Verden

## Overview

**Creative North Star: "The Games Program"**

Verden = studio site built like Munich-72 identity program. Every app = event in one program: owns one flat spectral color field, own geometric pictograms, a mark; all else (grid, type, ink, paper, rules, components) = shared studio infrastructure. HeroSet event #1 amber, HeroFace event #2 blue; studio wears silver, the one neutral in program, never competes with event hue. Visitor tells which event from color alone, still recognizes program from grid and type.

System flat, typographic. Full-bleed color fields alternate with white paper bands; hierarchy from scale contrast alone: huge, wide, heavy grotesque vs small tracked caps labels, big tabular numerals loudest when count on screen. Depth = color, not shadow. Lines thick, structural (3px ink rules, cut-bar pictograms); count always visible event, ticking in discrete steps, not tweening.

Site refuses indie-studio default: icon, headline, badge, screenshot row on white. No cards with shadows, no gradients.

**Key Characteristics:**
- One flat color field per app, supplied by app, with readable ink pair; shared shell never hardcodes app color.
- Archivo variable, wide stretch (112-125%), heavy weight (800-850) for display; hierarchy by size, not decoration.
- Pictograms on 64-unit grid: thick butt-capped bars, gaps at joints, detached round head.
- Thick 3px ink rules = structural line; 1px rules only quiet dividers.
- Discrete-step motion only, none under reduced motion. One exception: page-to-page navigation uses browser default view-transition crossfade (`@view-transition`), so shared bars don't flash blank between pages.

## Colors

White-paper, near-black-ink program; each app contributes one saturated field color, studio contributes one silver.

### Primary
- **Event Field** (per app): app's own color, supplied via registry (`color`), bound to field slot. Fills app bar, hero, closing call, notes, course stop dots, called rank ticks. HeroSet: **Signal Amber** (heroset-amber).
- **Event Ink** (per app): app's readable ink on its field (`onColor`), for all text, pictograms, buttons on field; at least 4.5:1 on field (WCAG AA, enforced by build). DayArc Pro moved from white (3.14:1) to `#061a1d` on 2026-10-10. HeroSet: **Warm Carbon** (on-heroset).

### Secondary
- **HeroFace Blue** (heroface-blue) + **Deep Night** ink (on-heroface, 7.6:1): HeroFace event field, watch face's own accent.
- **Days To Go Mint** (daystogo-mint) + **Deep Green** ink (on-daystogo, above 12:1): Days To Go event field, face's default accent.
- **Two Suns Coral** (twosuns-coral) + **Deep Wine** ink (on-twosuns, 7.0:1): Two Suns event field. Not face's default accent (amber belongs to HeroSet); warm dusk hue clear of amber, blue, mint. Provisional with app's working name; owner may change it.
- **Studio Silver** (studio-silver): studio's own field, Munich-72 silver. Fills studio home intro, default field when no app claimed page. Neutral on purpose: every hue belongs to an event. Changed from silver-blue 2026-09-24, which read as same color as HeroFace blue (1.04:1).
- **Studio Night Ink** (on-studio): readable ink on studio field.
- **Studio Slate Ink** (studio-ink; studio-ink-dark in dark scheme): studio silver as foreground on paper, deepened to slate for light paper (7.5:1), returning to field value on dark paper (11.4:1). Used for 404 numeral, studio mark's own bar.

### Neutral
- **Program Paper** (paper): page ground for every paper band, document.
- **Program Ink** (ink): headlines, 3px structural rules, key outlines, focus rings. Also light-mode inverse ground of honesty field.
- **Quiet Ink** (ink-secondary): ledes, step text, definitions, captions, footer.
- **Hairline** (rule): 1px dividers only (studio bar, footer, fact columns). Never text.
- **Links** no color of own: Program Ink, 2px underline at 40% ink, firms to full ink, 3px on hover, weight 600 in prose (never browser blue; changed 2026-09-26). On fields take field ink.
- Dark scheme swaps neutrals (paper-dark, ink-dark, ink-secondary-dark, rule-dark, studio-ink-dark), leaves every field color untouched.

### Named Rules
**The One Field Rule.** Page belongs to exactly one event. Field color, field ink from app registry; shared components read field slot, never name app color.

**The Field Ink Rule.** Text, pictograms, buttons, focus rings, selection on field use that field's ink, never paper-white. New app must supply ink pair reading at body size on its field (HeroSet amber/carbon 9.7:1; studio silver/night 10.7:1).

**The Selection Rule.** Selected text always inverse of ground it sits on: on paper highlight = ink with paper text; on any block painted with field color (`.field`, `.note`, `.program__entry`, `.status`, app bar) highlight = field ink with field-color text; on button = field color with field ink. Highlight matching own ground invisible, reads as unselectable. Checked 2026-09-26 on all 11 routes in light and dark: every text element has at least 3:1 between highlight and ground, 4.5:1 between text and highlight.

**The Field-Is-Ground Rule.** Field color = ground, never text color on paper. When field hue must appear as text on paper, gets own ink token deepened for legibility (as studio-ink does for studio-silver; studio mark's own bar drawn in studio-ink same reason). Field color as text allowed only on ink field, as in honesty headline (9.5:1).

## Typography

**Display Font:** Archivo Variable (with Archivo, system-ui)
**Body Font:** Archivo Variable (same family)

**Character:** One grotesque, every job, stretched wide and heavy for display, normal width for reading. Width axis = display voice; wordmarks, hero name at 125%, section heads 112%.

### Hierarchy
- **Display** (850, clamp(3.5rem, 9.5vw, 6rem), 0.9, wide 125%): app name in hero, studio name on home (uppercase there). One per page.
- **Statement** (850, up to 4.5rem, wide 112%): honesty headline, closing call (to 3.6rem), document titles.
- **Headline** (800, clamp(2rem, 4.6vw, 3.4rem), wide 112%): paper-band titles, short full sentences with period.
- **Numeral** (800, clamp(2.6rem, 6.4vw, 4.75rem), tabular): live counts; denominator ("/100") drops to about a third of that size at 600.
- **Title** (750, 1.2rem): course steps, fact terms (1.3rem, 112%), document h3.
- **Body** (400, 1.0625rem, 1.6): running text; documents cap 68ch, ledes 55-60ch.
- **Label** (700, 0.8rem, 0.1em, uppercase): captions beneath object (exercise under counter, screen name under slot, platform line under app summary).

### Named Rules
**The Scale Contrast Rule.** Hierarchy from size, weight, width. Headlines not colored, boxed, underlined to gain rank.

**The Caption-Below Rule.** Within content block, tracked caps labels name object they sit under. Never above headline as kicker or eyebrow. Shell wordmark = only uppercase line above heading.

## Layout

76rem centered wrap, fluid gutter (16-40px). Page rhythm alternates full-bleed field sections with paper bands. Bands open with space-5, stack contents on space-3; fields pad with space-5.

Hero, honesty field on 12-column grid: copy spans columns 1-5, pictograms or text 7-12, column 6 left as air. Definition lists (facts, watch families) use auto-fit grid, 15rem minimum columns, each item topped by hairline. Five-step course = five equal columns on one ink rule.

Below 60rem 12-column grids collapse to one column, course turns vertical along left ink rule, screen slots drop four to two. Below 34rem app bar tabs take full width, intermediate rank labels hide.

## Elevation & Depth

Flat. No shadows anywhere. Depth from color: field above paper, ink field (honesty statement) deepest plane. In dark scheme ink field flips to event field, stays loudest plane on page.

### Named Rules
**The Flat Program Rule.** No box-shadows, gradients, blur. To stand out, give field or thicker rule.

## Shapes

Square by default: fields, buttons, notes, status plates no radius. Only small radius = focus ring (3px ink outline, 3px offset, 2px corners). Circles only where world literally round: pictogram heads, course stop dots, key caps drawn as pills echoing bezel buttons, screen slots at watch-face proportion. Lines thick, cut: 3px ink rules, 3px baselines under pictograms, 6.5-unit butt-capped bars in figures.

### Named Rules
**The Round Means Watch Rule.** Circle or pill signals watch or body part (screen, bezel button, head, stop). No container, card, button rounded; 2px focus-ring corner only other radius.

## Components

### Buttons
Blunt, inverted.
- **Shape:** square corners (0), min height 3rem.
- **Store action:** field's ink as background, field color as text, 700 weight, 0.75rem 1.4rem padding.
- **Hover:** lifts 2px over 180ms on program ease-out; no color change.
- **Two tiers:** app with free twin (`freeStoreUrl`) shows two store buttons, "Get <Name>, free" then "Get <Name> Pro", landing page has "Free or Pro." band (what free face has, what Pro adds, store link each). Never "upgrade", "unlock", "try free first".
- **Status plate:** when store link absent, same box renders as 2px dashed field-ink outline reading "Coming soon". State, not button, not clickable.
- **Secondary action:** plain underlined field-ink link beside it, 600 weight.

### Program rows (studio home)
Each app row on home leads with store action (field-ink button, or dashed "Coming soon" plate when no store link), Support and Privacy under it as quiet 44px-tall links. App name links to overview; no separate Overview link. Columns fixed so every app name starts at same x.

### Navigation
- **Studio bar:** paper, 1px hairline bottom, wordmark left (studio mark + uppercase wide name), app names right at 560 weight.
- **App bar:** full-bleed event field. App mark + name left; Overview / Support / Privacy tabs right. Current tab carries 3px field-ink bottom bar; hover shows same bar at 35% ink.

### Notes
Field-colored callout blocks inside documents (square, space-2 by space-3 padding, field ink). For one-paragraph summary or warning reader must not miss.

### Keys
Bezel-button names ("START", "UP", "DOWN") as pill outlines: 2px ink border, 700 0.78rem tracked text. Used wherever copy tells someone to press button.

### Course
Numbered steps strung along one 3px ink rule, each stop marked by 15px field-colored dot with 3px ink ring, keys above step title.

### Rep Counter (signature)
Pictogram figure over 3px field-ink baseline, then huge tabular count with small "/100" and caption label. Two poses swap in hard steps (no tweening) while count ticks toward 100 one rep per swap; at 100 label reads DONE. Every run ends within 5 s of load, delay included (WCAG 2.2.2 needs no pause control then), so hero shows last few reps and finish; three counters use different tempos, finish apart. Under reduced motion shows static pose, starting count.

### Emblem
App's pictograms side by side at rest pose on studio home, each over same baseline. App with no pictograms falls back to its mark.

### Rank Scale
Data axis drawn from real rule: ink baseline, short ink ticks, called ticks taller in field color with ink outline, bold rank label above.

## Do's and Don'ts

### Do:
- **Do** put every app color in registry (`color` + `onColor`), components read field slot.
- **Do** draw new app's pictograms on 64-unit grid: 6.5-unit butt-capped bars, gaps at joints, detached 5.5-radius head, 3px baseline.
- **Do** run display type in Archivo at 800-850 weight, 112-125% width, tight negative tracking (-0.03 to -0.035em).
- **Do** use tabular numerals for any count, make changing count step, not tween.
- **Do** use 3px ink rules for structure, 1px hairlines only as dividers.
- **Do** name bezel buttons with key pill.

### Don't:
- **Don't** add box-shadows, gradients, rounded cards.
- **Don't** use field color as text on paper; give hue own deepened ink token instead.
- **Don't** set tracked caps labels above headlines as kickers or eyebrows.
- **Don't** hardcode app's color in shared components or shell.
- **Don't** animate outside `prefers-reduced-motion: no-preference`.