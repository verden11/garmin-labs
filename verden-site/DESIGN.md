---
name: Verden
description: One studio, one games-style identity program; every app is an event with its own color field and pictograms on a shared grid.
colors:
  paper: "#ffffff"
  ink: "#14161a"
  ink-secondary: "#4b515a"
  rule: "#dcdfe4"
  link: "#0f5fc7"
  studio-blue: "#62b0ea"
  on-studio: "#0b1824"
  studio-ink: "#1a5fb4"
  heroset-amber: "#ffaa00"
  on-heroset: "#15130f"
  paper-dark: "#0e1013"
  ink-dark: "#eceef1"
  ink-secondary-dark: "#a6adb7"
  rule-dark: "#2a2f36"
  link-dark: "#7db6ff"
  studio-ink-dark: "#62b0ea"
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

Verden is a studio site built like a Munich-72 identity program. Every app is an event in one program: it owns one flat spectral color field, its own set of geometric pictograms, and a mark; everything else (grid, type, ink, paper, rules, components) is shared studio infrastructure. HeroSet is event #1 in amber; the studio itself wears silver-blue. A visitor should be able to tell which event they are in from the color alone and still recognize the program from the grid and type.

The system is flat and typographic. Full-bleed color fields alternate with white paper bands; hierarchy comes from scale contrast alone: a huge, wide, heavy grotesque against small tracked caps labels, with big tabular numerals as the loudest element when a count is on screen. Depth is color, not shadow. Lines are thick and structural (3px ink rules, cut-bar pictograms), and a count is always a visible event, ticking in discrete steps rather than tweening.

The site refuses the indie-studio default of icon, headline, badge and screenshot row on white. No cards with shadows, no gradients.

**Key Characteristics:**
- One flat color field per app, supplied by the app, with a readable ink pair; the shared shell never hardcodes an app color.
- Archivo variable at wide stretch (112-125%) and heavy weight (800-850) for display; hierarchy by size, not by decoration.
- Pictograms on a 64-unit grid: thick butt-capped bars with gaps at the joints and a detached round head.
- Thick 3px ink rules as the structural line; 1px rules only as quiet dividers.
- Discrete-step motion only, and none under reduced motion.

## Colors

A white-paper, near-black-ink program where each app contributes one saturated field color and the studio contributes one silver-blue.

### Primary
- **Event Field** (per app): the app's own color, supplied via the registry (`color`) and bound to the field slot. It fills the app bar, the hero, the closing call, notes, the course stop dots and called rank ticks. For HeroSet this is **Signal Amber** (heroset-amber).
- **Event Ink** (per app): the app's readable ink on its field (`onColor`), for all text, pictograms and buttons on the field. For HeroSet, **Warm Carbon** (on-heroset).

### Secondary
- **Studio Silver-Blue** (studio-blue): the studio's own field. It fills the studio home intro, is the last bar of the studio mark, and is the default field when no app has claimed the page.
- **Studio Night Ink** (on-studio): readable ink on the studio field.
- **Studio Blue Ink** (studio-ink; studio-ink-dark in the dark scheme): the studio blue as foreground on paper, deepened for light paper (6.3:1) and returning to the field value on dark paper (8.1:1). Used for the 404 numeral.

### Neutral
- **Program Paper** (paper): page ground for every paper band and document.
- **Program Ink** (ink): headlines, 3px structural rules, key outlines, focus rings. Also the light-mode inverse ground of the honesty field.
- **Quiet Ink** (ink-secondary): ledes, step text, definitions, captions, footer.
- **Hairline** (rule): 1px dividers only (studio bar, footer, fact columns). Never text.
- **Link Blue** (link): inline links on paper. On fields, links take the field ink instead.
- Dark scheme swaps the neutrals (paper-dark, ink-dark, ink-secondary-dark, rule-dark, link-dark, studio-ink-dark) and leaves every field color untouched.

### Named Rules
**The One Field Rule.** A page belongs to exactly one event. Its field color and field ink come from the app registry; shared components read the field slot and never name an app color.

**The Field Ink Rule.** Text, pictograms, buttons, focus rings and selection on a field use that field's ink, never paper-white or link blue. A new app must supply an ink pair that reads at body size on its field (HeroSet amber/carbon is 9.7:1; studio blue/night is 7.6:1).

**The Field-Is-Ground Rule.** A field color is a ground, never a text color on paper. When a field hue must appear as text on paper, it gets its own ink token deepened for legibility (as studio-ink does for studio-blue). Field color as text is allowed only on the ink field, as in the honesty headline (9.5:1).

## Typography

**Display Font:** Archivo Variable (with Archivo, system-ui)
**Body Font:** Archivo Variable (same family)

**Character:** One grotesque doing every job, stretched wide and heavy for display and left at normal width for reading. The width axis is the display voice; wordmarks and the hero name run at 125%, section heads at 112%.

### Hierarchy
- **Display** (850, clamp(3.5rem, 9.5vw, 6rem), 0.9, wide 125%): the app name in the hero and the studio name on home (uppercase there). One per page.
- **Statement** (850, up to 4.5rem, wide 112%): the honesty headline, the closing call (to 3.6rem), document titles.
- **Headline** (800, clamp(2rem, 4.6vw, 3.4rem), wide 112%): paper-band titles, written as short full sentences with a period.
- **Numeral** (800, clamp(2.6rem, 6.4vw, 4.75rem), tabular): live counts; the denominator ("/100") drops to about a third of that size at 600.
- **Title** (750, 1.2rem): course steps, fact terms (1.3rem, 112%), document h3.
- **Body** (400, 1.0625rem, 1.6): running text; documents cap at 68ch, ledes at 55-60ch.
- **Label** (700, 0.8rem, 0.1em, uppercase): captions beneath an object (exercise under a counter, screen name under a slot, platform line under an app summary).

### Named Rules
**The Scale Contrast Rule.** Hierarchy comes from size, weight and width. Headlines are not colored, boxed or underlined to gain rank.

**The Caption-Below Rule.** Within a content block, tracked caps labels name the object they sit under. They never sit above a headline as a kicker or eyebrow. The shell wordmark is the only uppercase line above a heading.

## Layout

A 76rem centered wrap with a fluid gutter (16-40px). Page rhythm alternates full-bleed field sections with paper bands. Bands open with space-5 and stack their contents on space-3; fields pad with space-5.

The hero and the honesty field sit on a 12-column grid: copy spans columns 1-5, pictograms or text 7-12, with column 6 left as air. Definition lists (facts, watch families) use an auto-fit grid of 15rem minimum columns, each item topped by a hairline. The five-step course runs as five equal columns on one ink rule.

Below 60rem the 12-column grids collapse to one column, the course turns vertical along a left ink rule, and the screen slots drop from four to two. Below 34rem the app bar tabs take the full width and intermediate rank labels hide.

## Elevation & Depth

Flat. There are no shadows anywhere in the system. Depth comes from color: a field sits above paper, and the ink field (the honesty statement) is the deepest plane. In the dark scheme that ink field flips to the event field, so it stays the loudest plane on the page.

### Named Rules
**The Flat Program Rule.** No box-shadows, no gradients, no blur. If something must stand out, give it a field or a thicker rule.

## Shapes

Square by default: fields, buttons, notes and status plates have no radius. The only small radius is the focus ring (3px ink outline, 3px offset, 2px corners). Circles appear only where the world is literally round: pictogram heads, course stop dots, key caps drawn as pills to echo bezel buttons, and screen slots at watch-face proportion. Lines are thick and cut: 3px ink rules, 3px baselines under pictograms, 6.5-unit butt-capped bars in the figures.

### Named Rules
**The Round Means Watch Rule.** A circle or pill signals the watch or a body part (screen, bezel button, head, stop). No container, card or button gets rounded; the 2px focus-ring corner is the only other radius.

## Components

### Buttons
Blunt and inverted.
- **Shape:** square corners (0), min height 3rem.
- **Store action:** the field's ink as background with the field color as text, 700 weight, 0.75rem 1.4rem padding.
- **Hover:** lifts 2px over 180ms on the program ease-out; no color change.
- **Status plate:** when the store link is absent, the same box renders as a 2px dashed field-ink outline reading "Coming soon". It is a state, not a button, and it is not clickable.
- **Secondary action:** a plain underlined field-ink link beside it, 600 weight.

### Navigation
- **Studio bar:** paper, 1px hairline bottom, wordmark left (studio mark + uppercase wide name), app names right at 560 weight.
- **App bar:** full-bleed event field. App mark + name left; Overview / Support / Privacy tabs right. The current tab carries a 3px field-ink bottom bar; hover shows the same bar at 35% ink.

### Notes
Field-colored callout blocks inside documents (square, space-2 by space-3 padding, field ink). Used for the one-paragraph summary or warning a reader must not miss.

### Keys
Bezel-button names ("START", "UP", "DOWN") as pill outlines: 2px ink border, 700 0.78rem tracked text. Used wherever copy tells someone to press a button.

### Course
Numbered steps strung along one 3px ink rule, each stop marked by a 15px field-colored dot with a 3px ink ring, with its keys above the step title.

### Rep Counter (signature)
A pictogram figure over a 3px field-ink baseline, then a huge tabular count with a small "/100" and a caption label. Two poses swap in hard steps (no tweening) while the count ticks toward 100 one rep per swap; at 100 the label reads DONE. Under reduced motion it shows a static pose and starting count.

### Emblem
The app's pictograms side by side at rest pose on the studio home, each over the same baseline. An app with no pictograms falls back to its mark.

### Rank Scale
A data axis drawn from the real rule: ink baseline, short ink ticks, called ticks taller in field color with an ink outline and a bold rank label above.

## Do's and Don'ts

### Do:
- **Do** put every app color in the registry (`color` + `onColor`) and have components read the field slot.
- **Do** draw a new app's pictograms on the 64-unit grid: 6.5-unit butt-capped bars, gaps at joints, detached 5.5-radius head, 3px baseline.
- **Do** run display type in Archivo at 800-850 weight and 112-125% width, with tight negative tracking (-0.03 to -0.035em).
- **Do** use tabular numerals for any count, and make a changing count step, not tween.
- **Do** use 3px ink rules for structure and 1px hairlines only as dividers.
- **Do** name bezel buttons with the key pill.

### Don't:
- **Don't** add box-shadows, gradients or rounded cards.
- **Don't** use a field color as text on paper; give the hue its own deepened ink token instead.
- **Don't** set tracked caps labels above headlines as kickers or eyebrows.
- **Don't** hardcode an app's color in shared components or the shell.
- **Don't** animate outside `prefers-reduced-motion: no-preference`.
