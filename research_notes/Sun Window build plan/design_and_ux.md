# Sun Window: design and UX workflow and constraints

As of 2026-10-04. Research only; no mockup was drawn. Path shorthand: **R** = `/Users/mbp/dev/garmin/.claude/worktrees/vitamin-d-window-intake`, **KIT** = `/Users/mbp/dev/watch-design-kit`, **SDK** = `/Users/mbp/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs`, **DEV** = `/Users/mbp/Library/Application Support/Garmin/ConnectIQ/Devices`. Device tables below were computed by me from DEV `*/compiler.json` and `*/simulator.json` (SDK device data, not device evidence). Nothing in this file has run on a watch.

---

## 1. The watch-design-lead process, step by step (inputs, artefacts, gates)

### Takeaway
The studio process is: read owner steering → measure real fonts → HTML/SVG mockup at real pixel sizes → screenshot it in a real browser → (optional impeccable critique) → owner look-approval of the screenshot → design ADR + `DESIGN.md` → only then Monkey C → simulator screenshots of every screen (`docker/shot.sh`) → fresh-context `watch-design-reviewer` → fix → (store images later). For Sun Window the mockup set is **glance + full view** (not Free + Pro), across four display classes, plus the empty/first-run states.

### Cited Findings
**Inputs and scope**
- Before starting, read `owner-steering.md`; don't re-ask what it answers; append a dated line whenever the owner steers a design. — [KIT/skills/watch-design-lead/SKILL.md](KIT/skills/watch-design-lead/SKILL.md) "Before you start"
- Design-lead owns `DESIGN.md` (colour tokens, layout, motion, type, icons), the UX checklist and design ADRs in `docs/decisions.md`; never writes source files; name/price/listing belong to `watch-pm`. — [KIT/skills/watch-design-lead/SKILL.md](KIT/skills/watch-design-lead/SKILL.md) "Scope", "Handoff"
- Binding brief for every design-lead run (studio): accent in Free (lists, append-only ids, roster subset that doesn't collide with the face's roles), "design more daringly" (one signature move, saturated category-keyed colour on true black, real icons in a fixed hue per type, bold type contrast; "A colour is allowed to be bold only if it would be the same whatever the number is"), Free first, HTML/SVG mockup screenshot-verified in a real browser before any Monkey C, design ADR, fresh-context reviewer after build, "say plainly when no detector ran". — [R/reports/Free and Pro ladder execution plan.md](R/reports/Free%20and%20Pro%20ladder%20execution%20plan.md) §5a; root rules in [R/CLAUDE.md](R/CLAUDE.md) "Studio direction"
- WP2 per-face steps: read brief + DESIGN.md; produce mockups "in a real browser (round div, real font sizes, real row widths)", screenshot-verify at 454 px **and the smallest supported size**, add the rectangular case where the project has one; "Reading the markup is not verification"; owner picks the direction → design ADR; update DESIGN.md incl. the accent application rule ("does colour mark state, category, or nothing? pick one"); after the build, reviewer pass. — same file, WP2

**Font measurement first**
- Real fonts are bigger than mockups assume (176 px Instinct: `FONT_XTINY`/`FONT_TINY` both 23 px, `FONT_NUMBER_HOT` 44, `FONT_NUMBER_THAI_HOT` 56); take metrics from a scratch simulator test logging `getFontHeight`/`getTextWidthInPixels`, or the `fonts` list in `simulator.json`, **before drawing a mockup**; "one drawn at 15 px type promised a footer that does not fit". — [KIT/knowledge/instinct-and-1bit-displays.md](KIT/knowledge/instinct-and-1bit-displays.md) "The visible area is a circle"
- Documented per-device font sizes can be wrong (FONT_NUMBER_HOT documented 54 px, measured 36 px on one device). — [KIT/knowledge/platform-facts.md](KIT/knowledge/platform-facts.md) "Typography" `[verified]`
- Mockup must use "a real circle, real font sizes from `getFontHeight()`, real row widths; for Instinct, the real visible circle"; reading the CSS twice missed a clipped Pro grid row, one screenshot showed it. — [KIT/skills/watch-design-lead/SKILL.md](KIT/skills/watch-design-lead/SKILL.md) "Mockup before Monkey C"

**Mockup artefact (what earlier projects did)**
- Mockups are single self-contained HTML files with inline SVG on a black round `<svg>` (`border-radius:50%`), a title with revision number, a note stating approval date, sample data, and that row heights are the real simulator layout numbers for named devices (fr965, fr255s). — [R/TwoSuns/docs/archive/weather-mockup.html](R/TwoSuns/docs/archive/weather-mockup.html) ("Two Suns Pro — weather row (mockup, rev 4)… Approved by the owner 2026-10-03; rev 4 follows the design review")
- Where they are saved: after approval under `<Project>/docs/archive/` (`TwoSuns/docs/archive/{weather,battery,temperature}-mockup.html`; `DayArc|DaysToGo|HeroFace|HeroSet/docs/archive/instinct-mockup.html`); a browser screenshot was kept at `research_notes/Two Suns temperature research/mockup-screenshot-2026-10-03.jpg`. — file listing of R (fd), 2026-10-04
- Instinct method: "Mockup (HTML/SVG at 3x with a keep-out rectangle) for owner look-approval before any Monkey C." — [KIT/knowledge/instinct-and-1bit-displays.md](KIT/knowledge/instinct-and-1bit-displays.md) "Method that worked" 1
- DayArc: "direction approved by the owner via an iterated HTML/SVG mockup (screenshot-verified at each pass, not just read as markup)". — [R/DayArc/DESIGN.md](R/DayArc/DESIGN.md) status paragraph

**Screenshot method**
- Mockup → PNG: the studio's existing route is host headless Chrome: `Google Chrome --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=8000 --window-size=W,H --screenshot=out.png file://…html`. — [R/DayArc/tools/render_listing_images.sh](R/DayArc/tools/render_listing_images.sh) (used for store images; same mechanism fits mockups)
- Built screens → PNG: `docker/shot.sh <project> <jungle> <device>...` writes `<project>/bin/shot-<device>-face.png` (3x, device skin and bezel mask) and the full window (status bar shows memory used/total); `FAKETIME=` sets the clock; `PREP` edits a private copy to force a state; `FLAGS="-r -w"` for a store-like build to read memory. "A layout change is not done until you have looked at a screenshot." — [R/docker/SIMULATOR.md](R/docker/SIMULATOR.md) §1; [R/CLAUDE.md](R/CLAUDE.md) House rules
- "Devices with a glance (Instinct E, 3 Solar) open on the glance in the simulator"; the HeroSet glance was photographed with `docker/shot.sh HeroSet store.jungle instincte40mm …`, other states via a `PREP` patch of the glance reader. — [R/docker/SIMULATOR.md](R/docker/SIMULATOR.md); [R/HeroSet/docs/development.md](R/HeroSet/docs/development.md) line 58
- Simulator data (weather, sun times) is canned; "Never crop a screenshot into a claim about real readings"; scripted capture proves the capture ran, not that the screen looks right: check each picture by eye. — [R/docker/SIMULATOR.md](R/docker/SIMULATOR.md) "What the simulator's data is"
- Simulator clock is the container's; `TZ` does not reach it; use `faketime`/`PREP`. — [KIT/knowledge/instinct-and-1bit-displays.md](KIT/knowledge/instinct-and-1bit-displays.md) "More that cost time"

**Critique and review**
- Compose `impeccable` for a judgement pass (`Skill(skill: "impeccable:impeccable", args: "critique <mockup path>")`, also `typeset`, `colorize`), then hold the result against the craft bar; `audit`/`detect` are web-only and don't transfer: say "no detector ran". — [KIT/skills/watch-design-lead/SKILL.md](KIT/skills/watch-design-lead/SKILL.md) "Composing impeccable"
- `watch-design-reviewer`: fresh-context, read-only (Read/Glob/Grep), inputs `DESIGN.md`, `docs/decisions.md`, `spec.md`, screenshots labelled simulator or device; checks in order: evidence tags, hardware, UX checklist, handbook conformance, claims honesty, craft; returns `disposition: fix|ship` + up to eight ordered fixes; "compliant but mediocre" is `fix`. Never review in the context that designed it. — [KIT/agents/watch-design-reviewer.md](KIT/agents/watch-design-reviewer.md); [KIT/skills/watch-design-lead/SKILL.md](KIT/skills/watch-design-lead/SKILL.md) "Handoff"

**What "owner look-approval" means in practice**
- "The owner reviews mockups, not code, for look." "Mockup, browser screenshot and owner look-approval come before Monkey C." When real fonts later can't match the approved mockup, "say what moved and why". — [KIT/knowledge/owner-steering.md](KIT/knowledge/owner-steering.md) (2026-10-03 and Standing lines)
- Approval is recorded as a dated statement in the design ADR's status line and in DESIGN.md, naming the mockup file and revision, e.g. TwoSuns ADR-022 "owner… approved the mockup's look the same day (`docs/archive/weather-mockup.html`)"; DayArc ADR-013 "Built… No… owner screenshot review of the built version yet; `docs/status.md` gate 4 stays open". Approving a mockup and approving the built screens are separate gates. — [R/TwoSuns/docs/decisions.md](R/TwoSuns/docs/decisions.md) ADR-022 status; [R/DayArc/docs/decisions.md](R/DayArc/docs/decisions.md) ADR-013
- Visual identity, icons, looks are on the "Never decide alone" list. — [R/ROADMAP.md](R/ROADMAP.md) line 14; [R/reports/Free and Pro ladder - START HERE.md](R/reports/Free%20and%20Pro%20ladder%20-%20START%20HERE.md) §3
- Owner accepted simulator-only evidence for Instinct "on the condition that every report says it is simulator-only". — [KIT/knowledge/owner-steering.md](KIT/knowledge/owner-steering.md) 2026-10-03

**What goes into DESIGN.md and design ADRs**
- Template frontmatter: `colors` (ground/text/muted + tokens, each 64-colour-safe), `type` (role → FONT_ enum, verified against `getFontHeight()` + screenshot), `icons` (size, source, safe-zone note); sections Layout, Typography, Iconography, Motion/always-on, UX (glance-time budget, button path, every empty/error state), Craft (one sentence naming the focal read and what was cut). Every fact tagged against the handbook's `[verified]/[unverified]`. — [R/SunWindow/DESIGN.md](R/SunWindow/DESIGN.md) (unfilled template, identical to [KIT/templates/watch-app/DESIGN.md](KIT/templates/watch-app/DESIGN.md))
- Shipped examples: TwoSuns DESIGN.md has a palette table with contrast-on-black computed from hex ("computed… not measured on a screen"), accent id table with append-only rule and named unit tests, failure-display words, always-on rules, Instinct section. — [R/TwoSuns/DESIGN.md](R/TwoSuns/DESIGN.md). DaysToGo DESIGN.md: "Direction: One number… State is never colour alone: the words TODAY, HOURS, DAYS SINCE carry it." — [R/DaysToGo/DESIGN.md](R/DaysToGo/DESIGN.md). DayArc DESIGN.md: status block that separates "approved mockup", "built", "device photo". — [R/DayArc/DESIGN.md](R/DayArc/DESIGN.md)
- Sun Window ADRs already open that the design phase touches: ADR-001 name, ADR-005 wording/"vitamin D", ADR-006 window times on screen, ADR-007 go/no-go; "look and icon, screenshots… translations" listed as open owner decisions. — [R/SunWindow/docs/decisions.md](R/SunWindow/docs/decisions.md); [R/SunWindow/CLAUDE.md](R/SunWindow/CLAUDE.md)

### Inferences
- Proposed design-phase step list for the planner (gates in bold):
  1. Read owner-steering, spec, ADR-002..007, wording notes, accent roster. **Gate: ADR-007 go/no-go and ADR-001 name** are owner calls that ideally precede store art but not mockups (working name is fine in a mockup).
  2. Font/area probe: a throwaway stub (scratchpad, not repo) with a `(:glance)` GlanceView + full view, run per representative device (fr965, venu3, fr255s, fenix7s, instincte40mm, instincte45mm, venux1), logging glance dc size, `FONT_GLANCE*`, `FONT_*` heights, and widths of every state word in all shipped languages. HeroSet's glance probe did exactly this ([R/research_notes/HeroSet glance view research/glance_design_and_ux.md](R/research_notes/HeroSet%20glance%20view%20research/glance_design_and_ux.md) "Method notes").
  3. Mockup HTML (`SunWindow/docs/mockup.html` while iterating, moved to `docs/archive/` on approval): glance on its themed card rectangle and full view on round/rect/Instinct, every state (section 4 below), one accent per frame plus an accent strip.
  4. Headless-Chrome screenshot; look at it; optional impeccable critique; iterate.
  5. **Owner look-approval** of the screenshot (record date + revision in a new design ADR, append to owner-steering).
  6. Fill DESIGN.md + accent id table; then Monkey C.
  7. `docker/shot.sh` every screen/state on the device matrix; fit tests + 15-language sweep.
  8. Fresh `watch-design-reviewer`; fix; **owner look-check of the built screens** (separate gate, as DayArc gate 4).
  9. Store images (section 5).
- The WP2 "Free and Pro" pair does not apply (ADR-003 Free only); replace it with "glance and full view".

### Gaps
- No studio project has mocked a **glance** in HTML before (HeroSet's glance was designed from research and built, then screenshotted); there is no precedent file for how a glance card is drawn in a mockup.
- How the owner was shown mockups (local file, artifact link, chat image) is not recorded in the files read.

---

## 2. Glance design constraints

### Takeaway
Garmin publishes almost no glance visual rules; the binding constraints are platform data: content areas as small as 151×63 (MIP) and 154×61 (Instinct, 1-bit, 32 KB), transparent background over a system themed card, system glance fonts (number font is digits-only), live updates under 1 Hz, and the app launches its full view when selected. Sun Window's glance (state word only, per spec) suits this well; the risks are translated word widths, the Instinct sub-window, and accent contrast on the themed card.

### Cited Findings
**Platform model (widget vs app)**
- On API 4.0+ "apps and widgets must implement a glance view to appear in the glance list"; glance = "a small canvas to present an executive summary"; glance mode has limited memory; live devices keep the glance alive and honour `requestUpdate()` ("update rate should be kept under 1HZ"); non-live devices cache whatever was drawn; "There is no guarantee that a widget will always start in glance mode". — [SDK/Core_Topics/Glances.html](SDK/Core_Topics/Glances.html)
- "When designing a widget, make sure to design both a launch from widget (full screen) and launch from glance (list item to full screen)… after a period of inactivity, the system will terminate the launched app." — [SDK/User_Experience_Guidelines/Entry_Points.html](SDK/User_Experience_Guidelines/Entry_Points.html)
- **No API 5.1+ watch lists a `widget` app type** in `compiler.json` (`appTypes` = audioContentProvider, background, datafield, glance, watchApp, watchFace on fr965/fenix7/venux1; Instinct E has no audio). — my read of [DEV/fr965/compiler.json](DEV/fr965/compiler.json), DEV/fenix7, DEV/instincte45mm, DEV/venux1, DEV/fr255s
- Forum (not Garmin docs): "Any app with a type of widget in manifest.xml is actually compiled as 'watch-app' (device app) instead" on CIQ 4+; launched from a glance it "will time out and exit after a period of user inactivity"; "There's no way to implement an app available as a glance but not from the app/activity launcher." — [Garmin forum 427253](https://forums.garmin.com/developer/connect-iq/f/discussion/427253/glance-without-widget) (poster's role not confirmed); also [forum 245387 "Super apps and widgets in CIQ 4.0"](https://forums.garmin.com/developer/connect-iq/f/discussion/245387/super-apps-and-widgets-in-ciq-4-0)
- The intake report recommended type `watch-app` with `getGlanceView`; the spec says "widget". — [R/reports/Vitamin D window.md](R/reports/Vitamin%20D%20window.md) line 74; [R/SunWindow/docs/spec.md](R/SunWindow/docs/spec.md)

**Size, memory, fonts**
- Glance memory (device data): 65,536 B on 63 of the 66 API 5.1+ watch ids, 32,768 B on `instinct3solar45mm`, `instincte40mm`, `instincte45mm`; `liveUpdates: true` on all 66. — [R/research_notes/Vitamin D window/platform_and_permissions.md](R/research_notes/Vitamin%20D%20window/platform_and_permissions.md) lines 166-176; confirmed by my DEV scan
- Glance content area (`simulator.json` `glance.contentArea`, w×h px) for the 66 API 5.1+ watches (my scan of DEV):

| Class | Products | Content area |
|---|---|---|
| 218 MIP round | fr255s, fr255sm | 140×79 |
| 240 MIP round | fenix7s, fenix7spro | **151×63** |
| 260 MIP round | fenix7/pro/pronowifi | 171×63 |
| 260 MIP round | fr255, fr255m, fr955 | 176×93 |
| 260 MIP round | fenix8solar47mm, fenix9prosolar47mm | 198-199×81 |
| 280 MIP round | fenix7x/xpro/xpronowifi | 191×63 |
| 280 MIP round | enduro3, fenix8solar51mm, fenix9prosolar51mm | 216-217×88 |
| 360 AMOLED | fr265s | 240×104 |
| 390 AMOLED | approachs50, venu3s, vivoactive5 260×141; approachs7042mm, descentg2, descentmk343mm, epix2pro42mm, marq2, marq2aviator 248×103; fr165/m 261×124; fr170/m, fr70 257×125; fr57042mm 257×113; venu441mm 274×128; vivoactive6 274×146; instinct3amoled45mm 320×99; instinctcrossoveramoled 340×92 | 248-340 × 92-146 |
| 416 AMOLED | d2mach1, epix2, epix2pro47mm 274×103; fr265 275×120; fenix843mm, fenixe 325×122; fenix943mm 320×120; fenix9pro43mm 320×130; instinct3amoled50mm 346×106 | |
| 454 AMOLED | fr965 299×148; fr970, fr57047mm 299×130; venu3 303×164; venu445mm 318×150; d2mach2/pro, fenix847mm, fenix8pro47mm, fenix947mm, fenix9pro47mm 349×130; descentmk351mm, epix2pro51mm 312×103; approachs7047mm 274×103 | |
| 466 AMOLED | fenix9pro51mm | 359×130 |
| 448×486 AMOLED rect | venux1 | 314×150 |
| 1-bit Instinct | instincte40mm 154×61; instincte45mm, instinct3solar45mm 164×61 | 32 KB |

- Measured glance fonts (simulator probe, not device): fr255s `FONT_GLANCE` 19 px / `FONT_GLANCE_NUMBER` 23; fenix7 22/37; fr70 35/45; fr965 and fenix847mm 42/53; venu3 45/45. `FONT_GLANCE_NUMBER` behaves as a digit font (missing-glyph boxes for letters reported). — [R/research_notes/HeroSet glance view research/glance_design_and_ux.md](R/research_notes/HeroSet%20glance%20view%20research/glance_design_and_ux.md) Q1
- Translated two-word strings in `FONT_GLANCE` on fenix7 ran 109-146 px against 171 px (Polish "MISJA ZAKOŃCZONA" 146); English "MISSION COMPLETE" 135 px of fr255s's 140. — same file, Q1
- Round-edge clipping happens inside glance rows (fēnix 8 title "lost the left of its 'T'"). — [trainbud TrainBudGlanceView.mc](https://github.com/Zsadigzade/trainbud/blob/cf22892f67b81529b07b71302dd8e6316e4e24c4/ciq/source/TrainBudGlanceView.mc) (one developer's comment), via the HeroSet note

**Colour / theme**
- Do not paint the glance background opaque: `super.onUpdate()`/clear to black loses the device's themed gradient card (FR965, vívoactive 5; also FR70/265, Venu 3, fēnix 8 in one developer's code); draw with `COLOR_TRANSPARENT`. — [forum 368041](https://forums.garmin.com/developer/connect-iq/f/discussion/368041/glance-background-gradient); [trainbud](https://github.com/Zsadigzade/trainbud/blob/cf22892f67b81529b07b71302dd8e6316e4e24c4/ciq/source/TrainBudGlanceView.mc), via the HeroSet note
- `AppBase.getGlanceTheme()` (API 4.0+) picks a card theme: DEFAULT, BLUE, GOLD, GREEN, LIGHT_BLUE, RED, WHITE, PURPLE. The White theme card samples `#525252` → `#2D2D2D` → `#161616` → `#000000` left to right (fenix843mm theme art); HeroSet's `#555555` track nearly vanishes on it. — HeroSet note Q1/Q3 citing SDK AppBase docs and `DEV/fenix843mm/nwidget_White.png`
- A launcher icon is drawn by the system at the left of the glance; the content area excludes it. — HeroSet note Q1 citing `DEV/fr965/simulator.json`

**Precedent and lessons from HeroSet's glance**
- Store glances are status-only, typically one value/line + one bar; a "have I taken it today" yes/no glance exists (Creatine Tracker); done states are shown by colour far more than by word (an accessibility hole). — HeroSet note Q2
- HeroSet glance shipped read-only, no Storage writes from the glance process, `(:glance)` scope enforced by `tools/glance-scope-check.sh` ("the default build is silent, the watch crashes"); seeding Storage in `initialize`/`onStart` crashed the glance ("Class not available to 'Glance'"). — [R/docker/SIMULATOR.md](R/docker/SIMULATOR.md) §2; [R/HeroSet/docs/development.md](R/HeroSet/docs/development.md) line 93
- Instinct E / 3 Solar: the simulator draws the glance at `contentArea` (x 9, y 19), under the round sub-window; HeroSet laid it out left of the window via `WatchUi.getSubscreen()` **blind** (about 90 px usable), with shorter-wording fallbacks; "the glance's real place on a watch is unknown". — [R/HeroSet/docs/decisions.md](R/HeroSet/docs/decisions.md) ADR-055 amendments; [R/HeroSet/docs/input-and-ux.md](R/HeroSet/docs/input-and-ux.md) line 58
- 1-bit glance: HeroSet's filled track rendered white, so every bar read full; on Instinct the track became outline-only. — ADR-055 amendment 2026-10-04, same file
- Garmin early guidance: "a picture is worth a thousand words", a few meaningful text elements. — [Garmin forum news post, Widget Glances](https://forums.garmin.com/developer/connect-iq/b/news-announcements/posts/widget-glances---a-new-way-to-present-your-data) (fēnix 6 era), via HeroSet note

### Inferences
- Treat the app as a watch-app with a glance (whatever the manifest says): two entry points (glance list and the app launcher), and the full view must work when opened cold from the launcher with no glance run before it. The spec's "widget" wording should be reconciled by the planner/platform track.
- Glance layout: state word in `FONT_GLANCE` (not the number font), plus one non-colour shape mark (section 4); no times (spec). Must fit 151×63 and 140×79 in every language, and ~90 px wide on Instinct beside the window. A word plus a small drawn mark fits two rows at 63 px (2×22 = 44 px, HeroSet arithmetic).
- No bitmaps in the glance on the 32 KB Instinct ids; draw marks with primitives.
- Use a **fixed** glance theme (or DEFAULT); keying `getGlanceTheme()` to OPEN/CLOSED would be a state colour and is barred by the spec. If the accent is used on the glance, its contrast must be checked against the themed card (up to `#525252` on White), not only against black; the accent roster's checks do not cover this.
- The glance must recompute state from the clock and stored location at each draw (live glance, under 1 Hz), and must not write Storage (HeroSet lesson; also spec D7 "no stale state across midnight").

### Gaps
- No Garmin glance style guide found (sizes, line counts, colours); SDK prose still says "32KB for most devices".
- Where the glance sits on a real Instinct E / 3 Solar is unknown (HeroSet's is blind).
- Real `FONT_GLANCE` glyph widths on devices are unverified (simulator fonts only).
- Whether the card theme gradient varies by user watch theme on each product is not documented.

---

## 3. Full view across screen types

### Takeaway
The 66 target watches are 63 round colour screens (9 MIP sizes from 218 to 280 px at 8 bpp, AMOLED 360-466 px at 16 bpp), one rectangle (Venu X1, 448×486), and three 1-bit semi-octagon Instincts (166/176 px) with a sub-window and a ~98 px visible circle. Every row must be chord-fitted, every word measured per language with a shorter-wording fallback before any smaller font, and every layout screenshotted on its device skin.

### Cited Findings
- Device classes, API 5.1+ watches (my DEV scan; 75 products incl. 8 Edge + eTrex, which are not watches): round 390 px ×19, 454 ×14, 416 ×9, 260 MIP ×8, 280 MIP ×6, 218 MIP ×2, 240 MIP ×2, 360 ×1, 466 ×1; rectangle venux1 448×486 ×1; semi-octagon 176 ×2, 166 ×1. MIP products report 8 bpp, AMOLED 16, Instinct 1. — DEV `*/compiler.json` (`resolution`, `bitsPerPixel`), `*/simulator.json`
- 64-colour MIP: each channel 00/55/AA/FF; FR45/55 use eight colours (not in the 5.1+ set). — [SDK/User_Experience_Guidelines/Incorporating_the_Visual_Design_and_Product_Personalities.html](SDK/User_Experience_Guidelines/Incorporating_the_Visual_Design_and_Product_Personalities.html)
- Garmin: AMOLED uses light on black; "If you can only choose one, focus on light-on-dark"; "Put the most Important information front and center"; system fonts are readability-tested; "Keep any text on device short"; "show the same content regardless of display size"; "Identify a theme color that speaks to your brand, and use that in your iconography and headers." — same page
- No static safe-zone percentage; use `getObscurityFlags()` per field. — [KIT/knowledge/platform-facts.md](KIT/knowledge/platform-facts.md) `[verified]`
- Instinct (1-bit): only black and white; no state may depend on grey or colour; the visible area is the square cut by a circle ~98 px radius (96-100 px); at 176 px the bottom row (y 151-174) is ~100 px wide; sub-window 62 px at (113,0) on 176 px products, 52 px on instincte40mm; add a fit failure for any text intersecting `getSubscreen()`; accent setting has no effect there (owner: hide it on Instinct, not leave it dead). — [KIT/knowledge/instinct-and-1bit-displays.md](KIT/knowledge/instinct-and-1bit-displays.md); [KIT/knowledge/owner-steering.md](KIT/knowledge/owner-steering.md) 2026-10-03
- Instinct watch-app memory is 131,072 B (others 786,432). — DEV/instincte45mm/compiler.json
- Long translations broke Instinct bands in 12 of 15 languages before truncation; cut with "." rather than moving rows; run the per-language sweep at 176, 166 (and 163×156, not in Sun Window's set). — [KIT/knowledge/instinct-and-1bit-displays.md](KIT/knowledge/instinct-and-1bit-displays.md) "Layout"
- HeroFace Shorter-Wording Rule: "picks a shorter wording, never a smaller font"; owner: "DONE (or any state word) must fit; shorten or cut with '.' before overlapping". — HeroSet note Q4 quoting [R/HeroFace/DESIGN.md](R/HeroFace/DESIGN.md); [KIT/knowledge/owner-steering.md](KIT/knowledge/owner-steering.md)
- Studio fit tooling: `everyStateFitsThisDisplay` (no text outside the display or overlapping; on Instinct none under the window or outside the visible circle), 15-language `fit_languages.sh`, compile sweep, package check. — [R/docker/SIMULATOR.md](R/docker/SIMULATOR.md) §2
- Rectangles: DayArc found the Venu X1 corner radius "not known (not measured, not read from the SDK)"; rows near the bottom edge unverified against rounded corners. — [R/DayArc/DESIGN.md](R/DayArc/DESIGN.md) "Layout"
- Real-device lesson: the only DayArc wrist photo showed a sub line drawn as "4...", an arc crowding the clock corners, a top-heavy stack, all invisible in per-row simulator fits; fixed by planning the whole stack by measured dry run. — [R/DayArc/DESIGN.md](R/DayArc/DESIGN.md); [R/DayArc/CLAUDE.md](R/DayArc/CLAUDE.md)
- Button navigation: many devices have no touch; design must work on buttons alone; Garmin: buttons beat touch with gloves/wet/motion, "Don't require the user to use mobile app settings before they can use your app." — [KIT/skills/watch-design-lead/SKILL.md](KIT/skills/watch-design-lead/SKILL.md) UX checklist; [R/reports/Garmin policies and design guidelines.md](R/reports/Garmin%20policies%20and%20design%20guidelines.md) §4
- Sideloaded builds get no phone settings; `getSettingsView` (Menu2) is required for on-watch Customize. — [KIT/knowledge/platform-facts.md](KIT/knowledge/platform-facts.md) "Settings" (FR965 device-confirmed); [R/SunWindow/docs/spec.md](R/SunWindow/docs/spec.md) Settings

### Inferences
- Mockup device matrix (minimum): fr965 454 (hero/store), venu3 454 (tallest glance), fenix7s 240 MIP (smallest glance height 63) and fr255s 218 MIP (smallest round screen), venux1 448×486 (only rectangle), instincte40mm 166 and instincte45mm 176 (1-bit, sub-window, smallest glance 154×61).
- Full-view content per spec: state word (hero), a shape mark, and today's open/close times (ADR-006 open). That is one focal read plus one secondary line, consistent with the craft bar's "one focal read". On Instinct the sub-window is a natural home for the shape mark (DayArc/TwoSuns put their gauge/dial there; [R/TwoSuns/DESIGN.md](R/TwoSuns/DESIGN.md) Instinct section).
- A widget has no always-on mode concerns like a face (it exits on inactivity), so burn-in rules matter little; still use light-on-dark.
- Longest English state is "NONE TODAY" (10 chars, two words); German/Finnish/Polish equivalents will be longer; plan a two-line or shorter fallback (e.g. "NONE" + second line) measured per language.

### Gaps
- Real device fonts on the 5.1+ MIP fēnix 8/9 Solar and Instinct 3 AMOLED/Crossover AMOLED were not probed by any studio project.
- The rectangle's corner radius and the Instinct glance position are unmeasured.
- Whether a widget-launched view's inactivity timeout is long enough to read two lines is unmeasured (HeroSet lists the idle timeout of an app launched from the glance as "unmeasured (hard gate)": [R/HeroSet/docs/release-contract.md](R/HeroSet/docs/release-contract.md) line 11).

---

## 4. Showing the states without colour keyed to state

### Takeaway
State must be carried by the **word plus a shape** (filled vs outline vs absent mark), identical in a greyscale render; the accent is a user-chosen identity colour applied the same in every state. Times are plain clock times. "NONE TODAY" is the default state for most of the year in the north, so it is the first impression and needs the same care; whether it may show when the window next returns is a new number on screen and therefore an owner call extending ADR-006. First-run, no-location and no-weather each need a plain sentence.

### Cited Findings
**Rules**
- "No colour keyed to a reading: OPEN and CLOSED differ by word and shape. The accent colour is a user choice, never a status colour." No minutes, dose, goal, streak; no state labelled good, bad, safe or enough; no "vitamin D" in watch UI. — [R/SunWindow/docs/spec.md](R/SunWindow/docs/spec.md) "What it explicitly does not do"
- Wording: sun or sky is the subject; "Window open / window closed." and "Opens at 11:10, closes at 14:40." are on the allowed list; "Optimal", "ideal", "best", "safe", "good" banned; a red state for "closed" or a warning icon "reads as a health or burn verdict"; same words in screenshots, watch strings, translations; translated strings can add a medical meaning (unchecked). — [R/research_notes/Vitamin D window/naming_and_wording.md](R/research_notes/Vitamin%20D%20window/naming_and_wording.md) §3
- Craft bar test: "would this colour differ if the number differed? If yes, it's a verdict"; consistency: accent application rule "colour marks state, category, or nothing — pick one"; "The empty state is a design surface… it is the first impression." — [KIT/skills/watch-design-lead/SKILL.md](KIT/skills/watch-design-lead/SKILL.md) "Craft bar"
- Precedents for non-colour state: TwoSuns "Stale is a shape as well as a colour: hollow glyph, outline dot" and the sun marker "solid when the sun is up, an outline when it is not" ([R/TwoSuns/DESIGN.md](R/TwoSuns/DESIGN.md)); HeroFace done = drawn check + full bar + word, with the audit "render the face in greyscale — every state must still be nameable" (HeroSet note Q3 quoting [R/HeroFace/DESIGN.md](R/HeroFace/DESIGN.md)); DaysToGo "State is never colour alone: the words TODAY, HOURS, DAYS SINCE carry it" ([R/DaysToGo/DESIGN.md](R/DaysToGo/DESIGN.md)).
- House rule: "A value the watch does not have is hidden or said in words, never faked or blank." — [R/SunWindow/CLAUDE.md](R/SunWindow/CLAUDE.md); UX checklist: every failure (no data yet, no location, stale) "shows a plain-English sentence"; permission with a privacy cost "says why and what it buys, requested in context". — [KIT/skills/watch-design-lead/SKILL.md](KIT/skills/watch-design-lead/SKILL.md)

**Times and NONE TODAY**
- ADR-006 (Open): default is full view shows opening and closing clock times, glance state word only; "Showing today's opening and closing clock times is not a dose, but it is a number." — [R/SunWindow/docs/decisions.md](R/SunWindow/docs/decisions.md)
- Closed season from the fixtures (2026): noon sun reaches 45 degrees only Apr 15-Aug 27 in Vilnius (135 days), Apr 6-Sep 5 London (153), May 16-Jul 26 Reykjavik (72); "For northern users the third state, 'none today', will show most of the year, which is physically honest and a retention problem." — [R/reports/Vitamin D window.md](R/reports/Vitamin%20D%20window.md) line 34
- Spec: never assert exact edge dates in tests (e.g. Sydney 2026-04-19); tolerance 0.02 degrees and 1 minute on window edges. — [R/SunWindow/docs/spec.md](R/SunWindow/docs/spec.md)
- Weather can turn OPEN into CLOSED during the computed window ("before opening, after closing, or the sky filter fails"). — same file

**First-run / no-location / no-weather**
- "If the widget has never been opened there is no stored location: the glance shows a plain 'open once' state. Whether a glance may call `Position` itself is untested (D6)." — [R/SunWindow/docs/spec.md](R/SunWindow/docs/spec.md)
- `Position.getInfo()` without the permission killed the app uncatchably (simulator). — [KIT/knowledge/platform-facts.md](KIT/knowledge/platform-facts.md) "Location and permissions"
- TwoSuns' words for these states: "No place yet", "No sun data", `--`, and a single "?" if reading throws. — [R/TwoSuns/DESIGN.md](R/TwoSuns/DESIGN.md) "Failure display"
- `uvIndex`/`cloudCover` are nullable, no device evidence they are populated (D2). — [R/research_notes/Vitamin D window/platform_and_permissions.md](R/research_notes/Vitamin%20D%20window/platform_and_permissions.md) line 15

### Inferences
- Shape proposal space for the mockup (not decided): OPEN = a filled sun disc (or a filled arc segment above a 45-degree tick), CLOSED = the same disc as outline, NONE TODAY = outline below a horizon/tick line or no disc. All in the accent; greyscale test passes because fill/outline/position differ. On Instinct the same shapes in white; outline stroke ≥2 px so 1-bit renders it (HeroSet's filled-track lesson).
- CLOSED has two meanings (outside the window vs sky filter demoted it). Saying which is useful and honest but adds a string; a neutral second line such as "Opens 11:10" / "Closed at 14:40" / "Cloud cover" (attributed to the watch's weather) fits the wording rules. Planner should list this as a design question, not assume it.
- NONE TODAY "returns on Apr 15" is not forbidden by the spec but is a new number like the times: raise it as an ADR-006 extension for the owner. If shown, it must be computed live (not from a table) and hedged as a date (fixture tolerance means an edge date may differ by a day); options: show nothing, show the year's highest sun time today ("Highest sun 12:47" — also a number), or the return date.
- First run: glance "Open once to set the place" style sentence (exact wording to translate); full view requests the fix in context and explains why (location only for the sun maths, kept on the watch, rounded) per the permission-framing rule. No-fix-available in the full view needs its own sentence and a retry path on a button.
- No weather (nulls): elevation alone decides OPEN; whether the full view says "Sky not checked" (or similar, attributed to the watch's weather) is a design call; silently showing OPEN under cloud contradicts nothing in the spec but may read as a claim.
- Glance must also handle a stored place far from the user's current place (travel): spec has no rule; flag.

### Gaps
- No user evidence on which NONE TODAY content keeps users; no studio precedent for a long "empty" season.
- Wording for each state in 15 languages is not drafted; translations unreviewed.
- D6 (Position from glance/view) undecided, so the first-run flow may change.

---

## 5. Store assets: sizes, rules, how the studio produces them

### Takeaway
Cover 500×500 (<300 KB, not black), optional hero 1440×720 (<2048 KB), screenshots <150 KB each at native device pixels (up to five), two 128×128 device icons (24-bit and a 64-colour quantised one), plus a per-device launcher icon (sizes 38-70 px across the 66 targets). Studio produces covers/hero/icons from HTML via headless Chrome and screens via scripted simulator capture; all looks are owner approvals.

### Cited Findings
- Garmin brand page: 500×500 sRGB store asset, 10 px padding, "Do not choose black or transparent backgrounds", "Steer clear of descriptive text anywhere on the icon"; a face preview often works best; 128×128 device icons (64 colours on MIP); hero 1440×720. All studio apps were approved with non-conforming covers (guidance, not a review gate). — [R/reports/Garmin policies and design guidelines.md](R/reports/Garmin%20policies%20and%20design%20guidelines.md) §4 citing [developer.garmin.com/brand-guidelines/connect-iq/](https://developer.garmin.com/brand-guidelines/connect-iq/); [R/research_notes/Free and Pro ladder/garmin_rules.md](R/research_notes/Free%20and%20Pro%20ladder/garmin_rules.md) lines 135-139
- Dashboard limits recorded: cover <300 KB, screens <150 KB, hero <2048 KB; screenshot count unpublished; no Garmin branding in the icon. — same garmin_rules.md
- Owner 2026-10-04 (ROADMAP 10.25): covers and heroes on a per-app coloured background, never black; device icons stay black ("the quote is about the 500x500 cover"). — [R/ROADMAP.md](R/ROADMAP.md) line 103; [R/DayArc/listing/screenshots.md](R/DayArc/listing/screenshots.md)
- Studio pipeline: `listing/src/{cover,hero,icon}.html` + `mark.svg` → `tools/render_listing_images.sh` (headless Chrome) → `cover-500.png`, `hero-1440x720.png`, `icon-24-128.png`, and `src/quantize64.py` snaps to the 64-colour palette → `icon-64-128.png`; check sizes with `ls -l` and `sips`; screens by `docker/capture.sh <Project> tools/listing_shots.sh` (faketime clock, 24-hour, File > Save Screen Capture at native pixels); an Instinct frame in each set. Never use a site SVG or a mockup as a store image. — [R/DayArc/listing/screenshots.md](R/DayArc/listing/screenshots.md); [R/DayArc/tools/render_listing_images.sh](R/DayArc/tools/render_listing_images.sh); [R/docker/SIMULATOR.md](R/docker/SIMULATOR.md)
- Every listing got 5 screens incl. an Instinct one, hero, cover, two 128 icons, "simulator only"; "You approve the looks" (`meta.yaml` `owner_approvals`). — [R/ROADMAP.md](R/ROADMAP.md) 9.7
- Launcher icon per device (`compiler.json` `launcherIcon`, my scan of the 66): 38 px instinctcrossoveramoled; **40** px 18 MIP (fēnix 7/8 Solar/9 Pro Solar, FR255/955, Enduro 3); 52 instincte40mm; 54 ×8 (FR165/170/70/570 42, Venu 4 41, vívoactive 6); 56 approachs50, vivoactive5; **60** ×19 (epix 2, fēnix 8/9 43, FR265/265s, MARQ 2, Instinct 3 AMOLED…); 62 instincte45mm, instinct3solar45mm; **65** ×12 (fr965, fr970, fēnix 8/9 47, Venu 4 45, venux1…); 70 venu3, venu3s, approachs7047mm. — DEV `*/compiler.json`
- "a launcher icon sized 62x62 for the Instinct products, or the compiler scales it with a warning"; studio builds treat launcher-icon scaling notices as the only accepted warnings. — [KIT/knowledge/instinct-and-1bit-displays.md](KIT/knowledge/instinct-and-1bit-displays.md) "Method that worked" 5; [R/TwoSuns/CLAUDE.md](R/TwoSuns/CLAUDE.md) House rules
- On 1-bit, a pre-coloured bitmap came out solid white; pick the brightest hue set for mono so nothing rounds to black; confirm by screenshot. — [KIT/knowledge/instinct-and-1bit-displays.md](KIT/knowledge/instinct-and-1bit-displays.md)
- The launcher icon is shown at the left of the glance by the system. — HeroSet note Q1
- Icons: source real icons from Tabler (MIT), outline style at small sizes; tintable icon-font glyph when hue is contextual (accent), bitmaps only for permanent per-type hues; `drawBitmap2` tint has an FR165/FR165m bug. — [KIT/knowledge/platform-facts.md](KIT/knowledge/platform-facts.md) "Iconography and layout"; [KIT/skills/watch-design-lead/SKILL.md](KIT/skills/watch-design-lead/SKILL.md)
- Screenshots: no "vitamin D" in screenshots; canned simulator weather must not be presented as real readings. — [R/SunWindow/docs/spec.md](R/SunWindow/docs/spec.md); [R/docker/SIMULATOR.md](R/docker/SIMULATOR.md)
- `SunWindow/listing/screenshots.md` is still the unfilled template ("Owner supplies"). — [R/SunWindow/listing/screenshots.md](R/SunWindow/listing/screenshots.md)
- Open ROADMAP icon work for other apps (1.5 launcher icons/covers placeholders, 10.5 live image swaps) shows icons stay owner-gated. — [R/ROADMAP.md](R/ROADMAP.md) lines 40-42

### Inferences
- Suggested screen set: OPEN (fr965), CLOSED with times (fr965), NONE TODAY (fr965 or a MIP), glance list view, Instinct frame; all via a `listing_shots.sh` that sets `faketime` and patches the stored place in a private copy (no GPS in the simulator). A glance-list screenshot is a new kind for the studio (HeroSet's Instinct shots open on the glance; a round glance-list capture route is not documented).
- Simulator weather is canned, so a sky-filter-demoted CLOSED state needs a `PREP` patch or the simulator's Set Weather menu.
- One SVG mark source can feed the launcher icons (8 sizes + 64-colour quantise for MIP) and the cover; icon is an owner decision.

### Gaps
- Garmin's brand page is JS-rendered; the 10 px padding figure is tagged `[unverified]` in the kit ([KIT/knowledge/platform-facts.md](KIT/knowledge/platform-facts.md)).
- Whether swapping store images triggers re-review is open (ROADMAP 10.5).

---

## 6. Accessibility basics: contrast and type

### Takeaway
Colours: 64-colour-safe; ≥3:1 on true black for anything persistent; the AMOLED-dimmed form (FF→AA) also ≥3:1 and never equal to muted `#AAAAAA`; the accent must not equal any of this app's reserved role colours, and if the design draws an accent over a track, the face's own track rule (HeroFace: 3:1 against `#555555`) applies. Type: system fonts from the enum, sizes measured per device; state never by colour alone.

### Cited Findings
- Roster checks (unit-tested per project): 64-safe, ≥3:1 on black, dimmed ≥3:1, not equal to MUTED, not equal to a reserved role, and the face's own track contrast where it has one. Free six: Sky `#55AAFF` 8.6 (dim 7.7), Mint `#55FFAA` 16.3, Amber `#FFAA00` 11.0, Pink `#FF55AA` 7.1 (dim 4.6), Violet `#AA55FF` 5.5 (dim 4.6), White 21.0 (dim collides with muted: nudge, TwoSuns used `#55AAAA`). Against `#555555`: Sky 3.05, Mint 5.78, Amber 3.91, Pink 2.53, Violet 1.94, White 7.46. Rejected: Blue `#0055FF`, Red `#FF0000`. Amber/orange/coral/red never a default on Body Battery, stress or sleep faces. — [R/research_notes/Free and Pro ladder/accent_roster.md](R/research_notes/Free%20and%20Pro%20ladder/accent_roster.md)
- HeroFace ADR-003: the face's rule is 3:1 against TRACK so a part-filled bar still reads; Magenta `#FF55FF` (2.84) failed and was recoloured to `#FFAAFF` (4.42) on the owner's call, keeping id 2. — [R/HeroFace/docs/decisions.md](R/HeroFace/docs/decisions.md) ADR-003
- Kit: contrast on true black ≥3:1 for persistent/always-on colour; check AMOLED-dimmed variant. — [KIT/skills/watch-design-lead/SKILL.md](KIT/skills/watch-design-lead/SKILL.md) "Hardware constraints"
- Studio contrast values are "computed from the hex values against black (WCAG formula), not measured on a screen". — [R/TwoSuns/DESIGN.md](R/TwoSuns/DESIGN.md) "Palette and contrast"
- Garmin publishes nothing on accessibility, touch targets or round safe areas in the pages read. — [R/reports/Garmin policies and design guidelines.md](R/reports/Garmin%20policies%20and%20design%20guidelines.md) §4 last row
- Users complain glances are "black background and white text" hard to read on FR255. — [forum thread](https://forums.garmin.com/sports-fitness/running-multisport/f/forerunner-255-series/331679/can-you-reverse-colours-of-glances-so-that-text-is-black-and-background-is-white), via HeroSet note Q2
- Font roles are a fixed enum; `FONT_GLANCE`/`FONT_GLANCE_NUMBER` exist since API 3.1.8; verify sizes by `getFontHeight()` + screenshot. — [KIT/knowledge/platform-facts.md](KIT/knowledge/platform-facts.md); HeroSet note Q1
- Glance-time budget 2-5 s (Wear OS verified, Apple unverified). — [KIT/knowledge/platform-facts.md](KIT/knowledge/platform-facts.md) "UX"

### Inferences
- Sun Window has no shipped accent ids, so its list is new and append-only from v1; start from the roster's Free six and admit only those clearing Sun Window's own reserved roles (to be listed in DESIGN.md: probably white text, muted `#AAAAAA`, any track/horizon grey). If OPEN is a filled accent shape and CLOSED an accent outline over a grey track, Pink and Violet fail a 3:1 track rule as they do for DaysToGo; either avoid an accent-over-track encoding or apply the HeroFace rule and trim the list.
- Avoid amber/orange/red as the **default** accent: "closed" in a warm or red hue reads as a burn/verdict signal (wording note rule 4); a cool default (Sky, as TwoSuns chose "because blue carries no status meaning") fits.
- Accent on the glance must be checked against the theme card, not only black (section 2).
- On Instinct the accent setting is hidden (owner steering), so the settings folder must be excluded per product (the merge trap: a setting in its own resource folder left out of the Instinct `resourcePath`; [KIT/knowledge/instinct-and-1bit-displays.md](KIT/knowledge/instinct-and-1bit-displays.md) "Method that worked" 7).

### Gaps
- No studio measurement of contrast on a real MIP screen in daylight; all ratios are arithmetic.
- No Garmin minimum text size exists; legibility of `FONT_GLANCE` at 19 px (fr255s, simulator) on a wrist is unverified.
