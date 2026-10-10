# Days To Go decision log (ADRs)

Every durable design decision, newest last. [`spec.md`](spec.md) says what the product is; this file says why. Add an ADR at the end for any decision a future contributor would otherwise re-litigate. Mark old ADRs **Superseded** or **Amended**, never delete.

| ADR | Decision | Status |
|---|---|---|
| 001 | Any event, countdown-first | Active |
| 002 | Price: paid $1.99 first, one review at approval + 45 days | **Superseded** 2026-10-04 by 014 (the Free + Pro ladder; the owner retired the day-45 flip rule) and, for the price, by 017 (price: the $2.50 tier for every paid app) |
| 003 | List settings, never `date` or `numeric` | Active |
| 004 | Calendar-day arithmetic, no `Time.Moment` maths | Active; **Amended** 2026-10-04 by 018 (a Pro timed event also has an instant in its own zone; the count is unchanged) |
| 005 | On-watch date picker | **Open**: gated by the owner's device test (plan phase 3); **Amended** 2026-10-08 by 020 (no on-watch picker on the Sq 2) |
| 006 | Device set: 117 round products (CIQ 3.0+) plus 5 rectangular (amended 2026-10-05: Venu Sq, Sq Music) | Active |
| 007 | Always-on is hero and time on a shifting grid | Active |
| 008 | Name **Days To Go**, site slug `days-to-go` | Active |
| 009 | 29 Feb every year counts to 28 Feb in common years | Active |
| 010 | No permissions, no `Storage`, nothing leaves the watch | Active |
| 011 | Date style setting, and dates written in words | Active |
| 012 | Rows are stacked from font heights, optional rows drop on small screens | Active |
| 013 | Ring beyond a year is the grey track only | Active |
| 014 | Free + Pro ladder: a Free twin beside the paid app, which becomes Days To Go Pro | Active (accepted 2026-10-04: the owner approved the ladder) |
| 015 | Instinct family: window gauge, black and white, no accent | Active (accepted 2026-10-04; simulator only) |
| 016 | The bottom line shares the date row before it is dropped; a name steps down a font | Proposed (simulator only) |
| 017 | Price: the $2.50 tier for every paid app | Active (accepted 2026-10-04; ships with the 1.1.0 upload) |
| 018 | To the minute: Pro's Minute and Event time zone; the zone moves only HOURS and TODAY | Active, UNRELEASED (owner chose the headline 2026-10-04; simulator only; amends 004) |
| 019 | Rectangles get a square design: a rounded-rectangle track and a stack that uses the whole box | Proposed, UNRELEASED (owner asked 2026-10-05; look approval pending on simulator screenshots; amends 006 and 016) |
| 020 | No on-watch date picker on the Venu Sq 2 and Sq 2 Music (their system picker column is 30 px wide) | Active, UNRELEASED (2026-10-08, the owner's standing authority; simulator evidence only; amends 005) |

## ADR-001: Any event, countdown-first

**Decision.** Face counts to any wearer-chosen date (birthday, race, trip, New Year), not only races. Countdown-first: day count largest, time second, nothing else on by default.
**Why.** Biggest audience; runners still served by timed-event and weeks options. Rival reviews ask for "just a simple countdown face".
**Evidence.** `reports/Countdown face research.md` §1 to §2; owner decision 2026-09-26.

## ADR-002: Price

**Status: Superseded 2026-10-04 by ADR-014 (the Free + Pro ladder).** Owner approved ladder 2026-10-04, retired day-45 flip rule below: paid app never flipped to free, Free twin replaces that idea. First-submission price (paid, lowest tier) was live price until next upload; **price is Superseded by [ADR-017](#adr-017) (price: the $2.50 tier for every paid app)**. Text below is history.

**Decision.** Paid, lowest tier (USD 2.00, shown as $1.99 in US, same tier as HeroFace and HeroSet), at first submission. One review 45 days after store approval on whether to flip to free, once, never back. Proposed rule (owner to confirm): fewer than 5 sales in 45 days and download bucket of 10 or lower.
**Why.** Owner's choice (2026-09-26) after weekly free/paid idea advised against: Garmin documents only free→paid (removal and re-review, buyers locked out), store rules require disclosing limited-time free period. Risk on record: 15 paid countdown faces, all at 10 downloads or fewer; free leaders 10,000 to 100,000. Free flip may also send traffic to owner's other paid apps: hypothesis to measure, not a promise.
**How to apply.** Build identical either way. Email Connect IQ developer support before flipping; never cancel merchant account (would take HeroSet and HeroFace down). Reminder and details: `spec.md` "Price review".

## ADR-003: List settings, never `date` or `numeric`

**Decision.** Month, Day, Year, Time of day and every other choice is `list` setting; name is `alphaNumeric`. Generator `tools/gen_settings.py`. List values never negative. Default event (New Year's Day) means face never empty.
**Why.** Garmin Connect's `date` picker shows empty value or 1 January 1970 on iOS and Android and forgets date (Countdown!: 32 of 49 low-star reviews). `numeric` min/max failed in time2race ("must be between 0 and 0"). List has nothing to validate.
**Evidence.** `research_notes/Countdown face research/settings_and_dates.md`, `rival_reviews.md`. Not yet confirmed on a phone: plan phase 3.

## ADR-004: Calendar-day arithmetic

**Status: Active. Amended 2026-10-04 by [ADR-018](#adr-018-to-the-minute-pros-minute-and-event-time-zone) (to the minute).** Changes: Pro timed event also has instant (written time in chosen UTC offset); "no time zones" no longer true of that instant. Unchanged: day count is whole local calendar days, computed exactly as below, flips at watch's local midnight, both tiers, whatever the zone. All-day events and whole Free build exactly as written here. Text below is original decision.

**Decision.** Count is integer arithmetic on year, month, day (`DaysToGoCalendar.dayNumber`), read from one `Gregorian.info(Time.now(), FORMAT_SHORT)`. No `Time.Moment` subtraction, no time zones, no DST. Flips at local midnight; target date line reads a `Gregorian.moment` back with `utcInfo`.
**Why.** Every rival day-count bug (a day off, tomorrow counted as two) is a calendar bug.
**Evidence.** Unit tests: every day of 1970 to 2100 advances by exactly 1; leap days; boundaries; impossible dates; each rival bug. Simulator only.

## ADR-005: On-watch date picker

**Status: open (route and basic function verified on the FR965 on 2026-09-26; the phone/watch overwrite question is not).** Route on FR965: pick face in watch-face list, then *Customize* next to *Apply*, then *Set date*; date applied at once, survived restart. `getSettingsView` opens Menu2 with "Set date" and three-column Picker writing same Properties as phone. Kept in build on assumption it helps; owner's FR965 test T4 (plan phase 3) decides between keeping both routes ("last change wins" documented) and dropping picker. Available on 94 of 117 products by SDK's list; never promise on every watch. Settings re-read on every `onUpdate` because picker writes without callback.

**Amended 2026-10-04 (ROADMAP 10.13; simulator only).** Harness showed picker cut on Instinct ("Octobe", "ery ye"): each column clipped to about a third of screen. Now: month column shows short month word of watch's language (`DaysToGoDateText.monthWord`, words date row already uses, so no new strings in 15 languages); label font steps down with screen (tiny to 176 px, small to 280 px, medium above; `DaysToGoConfig.PICKER_*_FONT_MAX_PX`); "Every year" broken after first word onto two lines; picker is own class clearing to black before drawing, as SDK Picker sample does. Phone's month list still uses full names (`month_N`). Black clear is **not visible in the simulator** (SDK's own sample also draws white on colour MIP `fenix5s` there), so whether real MIP watch legible is for owner's wrist check (ROADMAP 3.1).

**Amended 2026-10-08 by [ADR-020](#adr-020-no-on-watch-date-picker-on-the-venu-sq-2-and-sq-2-music) (no on-watch picker on the Sq 2).** Not offered on Venu Sq 2 and Sq 2 Music, whose system picker column is 30 px wide; offered on Venu Sq, Sq Music and X1. Column layout is system's, per device: "each column a third of the screen" above holds only where device defines it so.

## ADR-006: Device set

**Decision.** HeroFace's 117 round products (CIQ 3.0+) plus Venu Sq 2, Venu Sq 2 Music, Venu X1 (rectangular AMOLED, CIQ 5+), one build, no bitmaps, no per-device resources. On rectangles face keeps round design: ring is circle sized to shorter side, centred, black bars above and below. Added 2026-09-26 at owner's request as cheap widening; round-chord text checks stricter than rectangle needs, so nothing overflows. Instinct (semi-octagon, monochrome, 64 KB) is later pass with own layout; pre-CIQ-3 watches not worth it (no Menu2 or settings screen, paid apps sold only on CIQ 3.4+).
**Why.** Same evidence base and test method as HeroFace; smallest memory budget 96 KB, measured build far under.

**Amended 2026-10-05 by ADR-019 (rectangles get a square design):** rectangles no longer keep round design.

**Amended 2026-10-05 (agent, on request; simulator only).** First-generation **Venu Sq and Venu Sq Music** (`venusq`, `venusqm`: 240 x 240 LCD, CIQ 3.3.6, 96 KB and 512 KB watch-face memory) join both manifests: 129 products. No reason against on record; they take rectangle path unchanged. **Not on Garmin's paid list** (App Sales page, read 2026-10-05; CIQ 3.3 under 3.4 floor), so, as with Instinct 2 family (ROADMAP 10.15), Pro carries them in package but only Free reaches them, no listing text names them. Evidence: `compatibility.md` "Venu Sq and Venu Sq Music".

## ADR-007: Always-on

**Decision.** AMOLED sleep frame is only hero and time in dim grey, block stepping across 3 × 3 grid once a minute. MIP watches keep full face.
**Why.** Garmin's 10% lit-pixel and 3-minute limits; same approach as HeroFace. Sleep hero starts at FONT_NUMBER_MEDIUM, two sizes below awake. **Unverified, known risk**: SDK says individual pixel may be on no more than three update cycles and at most 10% of pixels may be lit, else whole screen goes dark; first version's fixed 4 px drift smaller than digit stroke, so interior pixels of big digit stayed lit across all nine positions; step now proportional to screen (HeroFace ships same scheme with smaller clock). Owner's heat map and always-on night on FR965 decide; if screen blanks, raise `BURN_IN_STEP_PERMILLE` (now 35, about 16 px on 454, a bit more than digit stroke, so stroke clears itself when row changes) or shrink hero.

**Amended 2026-10-04 (ROADMAP 10.17, Garmin policies research; history above kept).** Limits now cited to Garmin's pages, read 2026-10-04: AMOLED FAQ ("How do I Make a Watch Face for AMOLED Products?", also in SDK docs) says burn-in protection active when watch face in foreground and system asleep, and "if more than 10% of the screen pixels are on or any pixel is on for longer than 3 minutes, the system will shut off the screen" (pixel is on in any colour but black). Caveats: (1) **Garmin's pages disagree on the time**: same FAQ says 3 minutes, Entry Points page says "AMOLED always active (version 1)" stops "any pixel from being enabled for more than four minutes", or more than 10% of pixels; we design to shorter figure, our block moves every minute, so both hold. (2) **Pixel rule is original Venu's.** FAQ: "Since the Venu 2, the rule for always-on is to use less than 10% of the screen's luminance", and Entry Points' "version 2" has only 10% pixel limit, no dwell time; which product uses which rule read at run time (`requiresBurnInProtection`, `System.getDisplayMode`), not from list we hold. So "lit-pixel share" right measure only on original Venu; on Venu 2 and later it is luminance (dim grey counts less than white). (3) Unverified: our own frame's share: no heat-map run and no always-on night on a wrist (ROADMAP 3.1); simulator's File > View Screen Heat Map is Garmin's tool for it. Garmin's watch-face page adds: avoid much white or blue (light gray instead), thin fonts, shift static elements up to four pixels every minute; this face's grid step about 16 px, larger than four. Word "Unverified" above now means "our frame untested", not "Garmin's figure uncited".

**Amended 2026-10-08 (ROADMAP 13.25, one always-on grey for the studio; history above kept).** Always-on grey is `#5C5C5C`, not `#555555` (`DaysToGoPalette.SLEEP_TEXT`). `#555555` is 2.82:1 against black, under studio's 3:1 bar for persistent colour; `#5C5C5C` is 3.14:1 (WCAG formula, computed from hex values), same grey Two Suns uses (Two Suns ADR-027 (always-on text is a dim grey)), so every studio face sleeps in one grey. Relative luminance 0.107 against 0.091, about 18% more relative luminance per lit pixel (computed), still about a quarter of `#AAAAAA`. Not a 64-colour value: only sleep frame (and, by second amendment below, error frame) draws it (`DaysToGoView` takes sleep path only when watch asleep and reports `requiresBurnInProtection`), on AMOLEDs and, in simulator, first-generation Venu Sq and Sq Music (16-bit LCD, SDK `compiler.json`; whether real watches report flag unverified, `compatibility.md`). Every product drawing it is 16-bit (SDK `compiler.json`: AMOLEDs such as `fr965` and `venux1`, and `venusq` LCD), so screen stores about `#5A5D5A`, still about 3.1:1 (computed). 64-colour MIP screen not expected to report flag: Garmin's AMOLED FAQ ties burn-in protection to AMOLED products (DaysToGo ADR-007 (always-on), amended 2026-10-04); not checked per product. Instinct palette's `SLEEP_TEXT` stays white, never drawn there. Test `alwaysOnGreyReadsOnBlack` pins 3:1 bar and value. Simulator only: 24-hour heat map on `fr965` and `venux1` recorded in `DESIGN.md` "Always-on (AMOLED)"; legibility outdoors on a wrist still open (ROADMAP 3.1). **Reversed by:** always-on night showing grey unreadable, or simulator heat map reporting burn-in (one constant).

**Amended 2026-10-08, second part (coordinator request): error frame follows always-on rule too.** When settings cannot be read, face draws "?" (never blank screen). Asleep on burn-in watch it was full white and did not move, so read failure lasting a night would light same pixels for hours. Now draws in `SLEEP_TEXT` and steps with sleep frame's 3 x 3 grid (`DaysToGoSleep.drift`, shared by both; `DaysToGoView.drawFallback`), as Two Suns' error frame already did; awake, or on any MIP watch, stays white and centred. Test `errorFrameDimsAndDriftsWhenAsleep` (colour each way, nine distinct spots each within one step, frame drawn at every spot).

## ADR-008: Name and slug

**Decision.** Days To Go. Site slug `days-to-go`, permanent once published.
**Status.** Confirmed by owner 2026-09-26. Store search by eye and trademark search still owner's.

## ADR-009: 29 February every year

**Decision.** Every-year event on 29 Feb counts to 28 Feb in common years. Specific 29 Feb of common year invalid; so is every-year 30 Feb or 31 Apr.
**Why.** Alternatives (1 March, skipping) surprise more. Tested.

## ADR-010: No permissions, no Storage

**Decision.** Empty permission list; settings live in `Application.Properties` only; no network. Stated in privacy page. Claim "the only countdown with no permissions" forbidden (Countdown! also asks for none).

## ADR-011: Date style and words

**Decision.** Dates on face are words (`Fri 25 Dec 2026`) from `Gregorian.utcInfo(..., FORMAT_MEDIUM)`, in watch's language. Order is the one thing system does not tell us, so Date style list (Automatic, Day first, Month first) decides; Automatic is month first only for English with statute miles (never on CIQ 3.0.x, where language unreadable). Weekday from calendar arithmetic, words from a 2026 Moment (a Moment ends in 2038). Year appears only when it differs from current year. Time of day list always 24 h.
**Why.** `DeviceSettings` has no date-order field. Owner confirmed 2026-09-26.

## ADR-012: Rows follow font heights

**Decision.** Row fonts chosen first (largest under height cap), then rows stacked from those heights, hero takes rest. When hero would fall below smallest font, optional rows drop: footer, then name, then date.
**Why.** Fractional bands overlapped on 208 px screen because system fonts do not scale with screen. Screen-fit test caught it.

## ADR-013: Ring beyond a year

**Decision.** Ring is share of next 365 days still to go. Beyond 365 days shows grey track only; full accent ring appears only on the day itself (and at exactly 365 days).
**Why.** Found on FR965 2026-09-26: event 760 days away drew full ring, same as the day itself. Owner chose this option over keeping the cap or storing a start date.
**Amended the same day.** Owner: with 1 day left linear ring is 0.3% of circle, useless. Share now square-rooted (1 day 5%, 7 days 14%, 30 days 29%, 91 days 50%, 365 days 100%): continuous, always shrinking. Counting last day in hours rejected for all-day events because ring would jump from about 0% to 100% at day boundary; timed events already use hours in last 24 h.

## ADR-014: Free + Pro ladder

**Status: Accepted (Active) 2026-10-04: owner approved ladder 2026-10-04 (OD1 and OD2 in `../../reports/Free and Pro ladder.md`).** Written 2026-10-01 as Proposed. Supersedes ADR-002 (price)'s day-45 flip rule (paid app never flipped to free; Free twin replaces that idea), and ADR-002 (price) Superseded in same commit. Still owner's, not decided here: names, Pro price, icons, translations, every upload. Nothing here uploaded or priced.

**Decision.** Days To Go ships as pair built from one codebase at compile time, DayArc's method (`../../DayArc/docs/decisions.md`, ADR-003 there: no runtime toggle, no unlock key, no locked items):

- **Pro** is existing app: `manifest.xml`, live app id (never changes), `monkey.jungle`, excludes every `(:free)` symbol, uses `resources;resources-pro`. On-watch name "Days To Go Pro". Version 1.1.0 (UNRELEASED).
- **Free** is new: `manifest.free.xml`, app id `9fde2744-b0f4-4396-927d-e4c7d65bb119` (generated with `uuidgen` 2026-10-01, never changes once published), `monkey.free.jungle`, excludes every `(:pro)` symbol, uses `resources;resources-free`. On-watch name "Days To Go". Version 1.0.0 (UNRELEASED). Same 120 products, same `minApiLevel` 3.0.0, same 15 languages, empty permission list (Free's permissions subset of Pro's, never more).
- **The split** (plan WP4 step 3). Free: Event, Name, Month, Day, Year, Unit (days or weeks), Date style, Accent (ids 0 to 5, shipped list). Pro adds Hour (timed event: last 24 h read as H:MM) and Footer (battery or steps). Accent ids 6 to 11 (cyan, lime, yellow, orange, coral, magenta) **deferred**: no new colour added by this ADR; when they come they are Pro-only and appended (ids append-only, never reused).
- **Settings files live only in tier folders**: `resources-pro/settings/` (every key) and `resources-free/settings/` (no Hour, no Footer). Shared `resources/` holds **no** settings file, so two never overlap and compiler never asked which wins. `tools/gen_settings.py free|pro` writes them.
- **AppName** lives only in `resources-pro/strings` and `resources-free/strings`. Not in `resources/`, not in 14 `resources-<lang>/` folders: language folder defining it would override tier name on non-English watch. Language does **not** inherit default's strings (compiler warns "String id 'AppName' undefined for language ..."), so each jungle also appends its tier folder to every `base.lang.<l>` path. `tools/check_strings.py` enforces both rules.
- **Code**: `DaysToGoSettings` reads Hour and Footer only in `(:pro)`; `(:free)` twin returns defaults (all day, no bottom line), asks system for neither key. `DaysToGoReadings.footerText` and `stepsText` and `KEY_HOUR` and `KEY_FOOTER` constants are `(:pro)`. Free build's settings, properties, on-watch name, compiled code carry no "Pro" word and no Hour or Footer key; no locked or greyed item, no upgrade text. Not removed from Free: unreferenced Hour and Footer display strings (`setting_hour`, `footer_*`, `h0` to `h23`, shared with Pro) and dead HOURS-phase and footer-drawing code. Timed-event arithmetic (`DaysToGoCountdown`, HOURS phase) stays in shared code, pure, hour simply never set in Free; dead code in Free, kept on purpose (cutting would fork counting rule of ADR-004 (calendar-day arithmetic)).
- **Properties missing-key behaviour.** Per SDK 9.2.0 reference, `Application.Properties.getValue` of key absent from properties file throws `Properties.InvalidKeyException`. Free never calls it for Hour or Footer, so nothing depends on it; `read()` already catches exception. In simulator `freeMissingPropertyKeyThrows` passed on Free (fr965, fr55, venusq2, 2026-10-01): calls `getValue("Hour")` in build whose properties file lacks Hour, catching only `Properties.InvalidKeyException`, asserts thrown. So simulator throws that exception for missing key (not null or default, not another type). Says nothing about a real watch.
- **On-watch Customize menu** has one item, "Set date", no accent or Pro item, so identical in both tiers by construction.
- **Verification** (`docs/development.md` "Checking a store package"): `tools/check_free_package.sh` unpacks compiled `.iq` packages, fails if Free settings contain Hour or Footer, if "Pro" appears anywhere in Free package, or if Pro package lacks them; `tools/compile_sweep.sh` compiles every product for both jungles; `tools/run_tests.sh <device> [jungle]` runs suite on either.

**Why.** Plan WP4 (`../../reports/Free and Pro ladder execution plan.md`): free twin reaches 33 more products than paid listing can (Garmin sells paid apps only on own list), owner asked for missing Free/Pro variants. Compile-time split keeps one source, no licence server, no locked UI.

**Consequences.** Live paid app's on-watch name becomes "Days To Go Pro" at 1.1.0: visible change for existing buyers, owner's call. Pro behaviour otherwise identical to 1.0.1 (same settings, ids, defaults; `resources-pro/settings` byte-identical to old `resources/settings`). Pro headline (what buyer pays for beyond timed event and bottom line) not established when written; now "To the minute" (owner, 2026-10-04): see ADR-018 (to the minute), which also changes "identical to 1.0.1" statement above by two appended settings. **Owner decisions, not made here:** store names and titles, Pro price, Free's icon, translations of any new string, uploads (Free 1.0.0 as new app, Pro 1.1.0 on existing id, together), site deploy, OD1 to OD4.

## ADR-015: Instinct family: window gauge, black and white, no accent
**Status: Accepted (Active) 2026-10-04 (owner approved the ladder 2026-10-04). Written 2026-10-03 as Proposed; owner approved look (mockup `docs/archive/instinct-mockup.html`) same day, chose to hide Accent setting on these watches. Nothing has run on a watch (owner has none): simulator evidence only. Not uploaded. Accepted does not mean device-proven.**

**Context.** 7 semi-octagon products watch-face capable, left out of ADR-001 (any event, countdown-first)'s product set: `instinct2`, `instinct2s`, `instinct2x`, `descentg1` (CIQ 3.4) and `instincte40mm`, `instincte45mm`, `instinct3solar45mm` (CIQ 6.0). `instinctcrossover` left out as in HeroSet (analog hands cover display; simulator shows no window). 1-bit (palette `000000`/`FFFFFF` only, no anti-aliasing), 176 x 176 (`instincte40mm` 166 x 166, `instinct2s` 163 x 156), with round **window** (62 px, 52 px on E 40 mm, 54 px on 2S) cut into top-right corner. **Watch-face memory 65,536 B** (96 KB floor in ADR-001 (any event, countdown-first) does not hold). All seven at or above `minApiLevel` 3.0.0, face needs no Complications, so Instinct 2 family reachable.

**Decision.**
- **Products.** 7 above join both manifests (127 products in each tier). One build per tier, as before.
- **Layout.** `DaysToGoLayout` asks `WatchUi.getSubscreen()` on `SCREEN_SHAPE_SEMI_OCTAGON` products only, so no round or rectangular product's geometry depends on it. Rows are boxes, not chords: side margin each side, and row starting above window's lower edge plus ring clearance (6% of screen) ends left of it and is centred in band left (`rowCenterX`). Time takes that band (largest number font whose time fits, up to 20% of screen), event name under it; hero starts below window and takes rest above caption and date. **Bezel ring becomes gauge in window**: hairline circle (track) with thick fill inside (a quarter of window radius), same share, same direction from 12 o'clock, closed on the day.
- **Footer dropped.** Battery or steps line (Pro) has no room: watch's smallest font 23 px tall on 176 px screen, so time, name, hero, caption, date already use height. Mono Pro build shows same rows as Free. Listing wording must not promise footer on Instinct.
- **Black and white by annotation.** `DaysToGoPalette` is two classes with same name (`(:color)` and `(:mono)`); jungles exclude `mono` for every product and `color` for 7 Instinct products. All roles white; track is outline under solid fill; TODAY is word and closed gauge, never colour. **Per-product `excludeAnnotations` line replaces base list**, so tier's own exclude restated (`free;color` in `monkey.jungle`, `pro;color` in `monkey.free.jungle`); writing `color` alone would have silently broken Free/Pro split. Test counts prove it: Pro and Free Instinct builds run own tier-only tests.
- **Accent hidden on Instinct (owner, 2026-10-03).** Accent list lives in own settings file (`resources-accent-<tier>/settings/accent.xml`, written by `tools/gen_settings.py`); Instinct products' `resourcePath` leaves that folder out, so phone shows no Accent setting for them. Property stays in `properties.xml` (shipped key never changes) and `DaysToGoPalette.accent()` returns white. Settings file a second resource folder tries to override did not work (compiler merges settings, so Accent stayed); folder simply absent does. Round products' settings order unchanged (Accent last). `tools/check_free_package.sh` checks both: no Accent key on 7 Instinct parts, Accent ids 0 to 5 on rest.
- **Always-on.** Instinct is MIP without burn-in rules, so keeps full face, never draws always-on frame (its drift test skips these products).
- **Visible area is a circle (found by simulator screenshot, 2026-10-03).** Bezel hides corners: what shows is square cut by circle about 98 px in radius (96 to 100 px, from alpha mask of SDK's device images, all seven products), not the 20 px chamfer mockup drew. `DaysToGoLayout` clips every row's insets to 96 px circle (`VISIBLE_RADIUS_PX`), fit test fails any text box whose corner leaves it (`collectCorners`; boxes include font padding, so stricter than ink).

**Why.** Same reasoning as HeroSet ADR-055 (Instinct design, same hardware): window is the one place a gauge fits; 1-bit screen cannot carry accent or dim track; footers do not fit 23 px fonts on 176 px.

**Consequences.** Mockup drew type about 15 px tall; real smallest font 23 px, so real face has smaller hero than mockup (see "Evidence"). Pro on Instinct loses footer; Accent not offered there. No round product's drawing changed: `rowCenterX` returns centre and insets unchanged without window (round control suites pass).

**Verification.** See `docs/compatibility.md` "Instinct family". Simulator only; real bezel margins, contrast, on-watch Customize menu (is it offered on an Instinct?) unmeasured.

## ADR-016: The bottom line shares the date row before it is dropped; a name steps down a font
**Status: Proposed. Written 2026-10-04 (owner authorised UI fixes without asking first); simulator only.**

**Context.** Simulator screenshot on FR965 (454 px) with named event and Pro's bottom line on showed no bottom line: with name, caption, date rows present hero would have had less than smallest font, layout dropped footer first (ADR-012 (rows follow font heights)). Setting appeared to do nothing on flagship watch, while 218 px FR255S showed it. On Instinct 3 Solar a 12-character name ended in "..." although smaller font would have shown it whole.

**Decision.** (1) When hero would be too small, bottom line first moves onto date's row, joined by " · " ("Sat Dec 19 · 50%"; each date wording with footer, then date alone, so chord too narrow for both keeps date). Only if hero still too small does it drop, then name, then date, as before. State that had room unchanged. (2) Name tries each smaller name font before cut short with "...".

**Why.** Feature owner switched on must not vanish silently on biggest screen; date row short enough to carry a few characters more.

**Consequences.** `DaysToGoFrame.footerWithDate`, `nameFonts`; `DaysToGoView.dateCandidates`; test `bottomLineIsDrawnNotSilentlyDropped` (round, 218 px and up). Instinct has no bottom line (ADR-015 (Instinct family)). Middle dot renders in FR965 simulator font; not seen on a wrist.

**Amended 2026-10-04 (ROADMAP 10.12; owner asked for open cases to be fixed or documented).** (3) **Rectangles get a taller stack.** On 320 x 360 rectangle (`venusq2`, `venusq2m`) smallest font 39 px tall, as on round watch, but ring only 320 px, so stack of rows ran out of height: with a name hero fell below smallest font and name, then bottom line, dropped. `DaysToGoLayout` now spans 90 % of content radius on rectangle (`RECTANGLE_SPAN_PERMILLE`) instead of 80 %; every text still measured against round chord, so none touches ring. Result on `venusq2` with 12-character name, date, bottom line on: name shows again, hero keeps largest font; date steps down to shorter wording ("Dec 19" instead of "Sat Dec 19") because bottom row's chord narrower; **bottom line still dropped** ("Dec 19 · 50%" does not fit that chord). Round and Instinct products unchanged by construction (span applies only to `SCREEN_SHAPE_RECTANGLE`); `venux1`, other rectangle, passed suite too. (4) **Not fixable: Instinct 3 Solar and Instinct 2 (both 176 px, both screenshotted) still cut 12-character name** ("Anna and T..."; Instinct E 45 mm has same screen size but not screenshotted). Tried: name wrapped onto two lines at a space beside window. Does not fit: 23 px smallest font makes two lines 46 px, hero then starts at y 92 instead of 72, band left for it (about 22 px) under hero's smallest font, so something must go, only rows left are caption ("DAYS") and date, which product promises. Cut name stays; code not kept. Instinct E 40 mm (166 px) and wider chords show 12 characters whole.

**Amended 2026-10-05 (found while adding Venu Sq; simulator only).** (5) **Always-on frame keeps round span on rectangles.** Asleep, time fitted to circle smaller by drift step; with (3)'s 90 % span time row sat where that circle's chord narrower than time, so cut ("1" instead of "10:10") on top and middle drift rows of rectangles: measured on `venusq` and live `venusq2` (so `venusq2m`, same screen); `venux1` not measured before fix. `DaysToGoLayout.rows` now takes `sleeping`, uses 80 % span then (frame only time and hero); awake face unchanged. `alwaysOnFrameFitsAtEveryDrift` now fails when time not drawn whole.

**Amended 2026-10-05 by ADR-019 (rectangles get a square design).** (3) and (5) retired: rectangle's rows now run box inside its rounded-rectangle track, awake and asleep, bottom line shows on all three rectangle sizes; `bottomLineIsDrawnNotSilentlyDropped` runs there too.

<a id="adr-017"></a>
## ADR-017: Price: the $2.50 tier for every paid app

**Status: Accepted 2026-10-04 (owner, chat).** Supersedes price of [ADR-002](#adr-002-price) (paid at lowest tier, USD 2.00 / $1.99 US); ADR-002 (price)'s day-45 review already retired by ADR-014 (the Free + Pro ladder).

**Decision.** Days To Go Pro (paid app, live app id) moves to **USD 2.50 tier** of Garmin's price points (US $2.49, eurozone 2,99 EUR; measured table in `../../research_notes/Free and Pro ladder/garmin_rules.md`, source https://developer.garmin.com/connect-iq/monetization/price-points/). Every paid app in studio (HeroSet, HeroFace Pro, Days To Go Pro, Two Suns Pro, DayArc Pro) takes same tier. Days To Go (Free) stays free. Owner sets tier in upload form.

**Why.** Room for later discounts or rise: Garmin's tiers are $2.00, then every $0.25, so lowest tier left no step down. Tier converts to different number in each store, so no number stated where reader sees it.

**No price number on site or in listing text.** Neither listing's Description or What's New, nor pages under `site/src/apps/days-to-go/`, state a price.

**Open risk.** Garmin documents that changing price of approved app can take it out of store for re-review (SDK `Monetization/App_Sales`); how it treats repricing to higher tier not confirmed. Ship change together with 1.1.0 version upload (Pro), re-reviewed anyway. Garmin email on repricing cancelled (owner, 2026-10-04, [`../../ROADMAP.md`](../../ROADMAP.md) 2.1); agent re-reads Garmin's published policies instead (`../../reports/Garmin policies and design guidelines.md`, running), so risk stays open until that report answers it.

**Reversed by.** The owner.

## ADR-018: To the minute: Pro's Minute and Event time zone

**Status: Active (owner chose headline 2026-10-04: option 1 of `../../reports/Days To Go Pro research.md`, ROADMAP 3.10), UNRELEASED, simulator only. AMENDS [ADR-004](#adr-004-calendar-day-arithmetic) (calendar-day arithmetic), also marked Amended.** Nothing here uploaded or on a wrist.

**Context.** Pro's headline: "Count down to the minute your event starts, in the time zone it starts in." Pro already had Time of day (the hour) and last-24-hours H:MM; ADR-004 (calendar-day arithmetic) forbade any time zone. Race or flight starts at clock time in a place, wearer may be elsewhere.

**Decision.**

1. **Two Pro settings, appended** (ids never change; lists only, ADR-003 (list settings)): `Minute`, list 0 to 59 (default 0); and `EventZone`, list whose value 0 is **My watch time zone** (default, today's behaviour) and whose other values are real UTC offsets from UTC-12:00 to UTC+14:00 (40 of them, 15-minute steps where a place uses one: UTC-09:30, UTC+05:45, UTC+12:45 and so on). Stored value is offset as quarter-hour index, `49 + minutes / 15`: 1 is UTC-12:00, 49 is UTC+00:00, 105 is UTC+14:00; list values never negative. Mapping frozen once shipped; zone added later is new, larger or unused value, never re-numbering. Value outside 0 to 105, or wrong type, falls back to default. Hour must be set for either to matter: **all-day event ignores Minute and zone**, stays exactly ADR-004 (calendar-day arithmetic).
2. **No time-zone database on watch, so setting is a UTC offset, wearer chooses offset event's place is on at event's date.** Face cannot know London race on 28 March is UTC+1 and on 20 March UTC+0. Docs, phone setting's wording, listing must not say face "handles daylight saving"; "works across time zones" means only wearer sets offset.
3. **Event instant.** For timed event with chosen offset Oe: event's written date and time are wall-clock time at Oe, so instant is that time minus Oe. Watch's own offset Ow (wall clock minus UTC, DST included) read in `DaysToGoLocalTime.now()` from same `Time.now()` as date and time of day. Everything whole seconds on day numbers: no `Time.Moment` built for event (a Moment ends January 2038, year list runs to 2060), `days * 86400` stays inside 32 bits.
4. **The rule.** Let `d` be calendar days from watch's local today to written date (ADR-004 (calendar-day arithmetic), unchanged, no zone anywhere in it); `s = Ow - Oe` (0 for My watch time zone); `T` written time of day in seconds; `r = d * 86400 + T - (watch local seconds of day) + s`, seconds from now to instant. Let `A = writtenDate + floor((T + s) / 86400)`, watch-local day instant falls on, and `L = max(writtenDate, A)`. Timed event is then:

| # | Condition | State | Shown |
|---|---|---|---|
| 1 | all-day event (Hour not set) | UPCOMING if d > 0, TODAY if d = 0, PAST if d < 0 | `d` days; zone and Minute ignored; ADR-004 verbatim |
| 2 | timed, r >= 24 h | UPCOMING | `max(d, 1)` days. Count is `d`: drops at **watch's** local midnight whatever the zone. Floor of 1 only matters when zone puts instant more than a day away while written date already today or behind (26 h shift at most); count of 0 or negative never shows |
| 3 | timed, 0 < r < 24 h | HOURS | `H:MM` = `r` rounded up to minute (0:01 at last second, 24:00 at most); existing hero, caption, ring |
| 4 | timed, r <= 0 and today <= L | TODAY | word TODAY, from instant to end of `L`; never skipped, even when instant falls on different local day than written date |
| 5 | timed, r <= 0 and today > L | PAST | days since = today - `L` |
| 6 | every-year timed event | first of last year's, this year's, next year's occurrence not PAST | last year's matters only across New Year, when zone keeps it alive after its written day |

   With My watch time zone `s` is 0, `A` is written date, table is pre-ADR-018 behaviour exactly (existing suite passes unchanged).
5. **What zone may move.** Only **when HOURS state starts** (row 3 begins when r drops under 24 h) and **when TODAY arrives** (row 4 begins when r reaches 0, ends at end of `L`). Does not move day count: count is `d`, flips at watch's local midnight, same number for same written date in every zone. Keeps ADR-004 (calendar-day arithmetic)'s claim "the count flips at local midnight" true; release contract keeps it.
6. **Free unchanged.** Free has no timed events, no Minute, no zone; its properties file, settings, compiled strings carry none of new keys or words. Pro-only strings (two titles, "My watch time zone", minute and offset labels) live in `resources-pro/strings` and `resources-pro-<lang>/strings`, which only Pro jungle searches; shared countdown code (`DaysToGoCountdown`, `DaysToGoEvent`, `DaysToGoLocalTime`) carries arithmetic in Free too, dead there (Free event always has zone 0), as HOURS phase already did (ADR-014, the Free + Pro ladder). `tools/check_free_package.sh` adds `Minute` and `EventZone` to Pro-only keys.
7. **No new drawing.** HOURS state already draws `H:MM` as hero with caption HOURS; nothing added to row, layout, fonts. On Instinct hero is text, works in 1 bit (widest string, `24:00`, already in fit states).

**Known limits (documented, not fixed).** (a) Default zone is watch's wall clock: across watch's own DST change last 24 hours can be an hour off (spec rule 6); explicit offset has no such error because it compares instants. (b) Offset chosen by wearer; wrong DST choice is an hour wrong. (c) `A` uses watch's offset now; if watch's own DST changes between instant and now, `L` can be a day off for event within an hour of midnight. (d) "Days since" after zone event counts from `L`, so for far-east event can read 1 day since while written date still today in another zone: counts from later of the two. (e) Event's seconds are 0; hero rounds up to minute. (f) Minute and zone are phone settings only; on-watch picker sets date alone, so they depend on phone route that rival faces lost users on (untested on a wrist, ROADMAP 3.1).

**Tests** (`DaysToGoZoneTest`, Pro only; suite is Pro 66, Free 55): zone mapping at 0, 1, 49, 105 and out of range (row 0); default zone to the minute and minute rollover (rows 3, 4, 5); midnight edge (rows 3, 4); count flips at watch midnight over five zones and four watches (row 2); travel day with event east of watch and west of it (rows 2 to 5); written date reached with instant still ahead (rows 2, 3, 4); +14 and -12, and widest 26 h shift (rows 2 to 5); DST-boundary day with explicit offset, against default's one-hour limit (row 3, limit a); passed event and every-year rollover, including across New Year (rows 5, 6); all-day event with Minute and zone in settings (row 1); settings path to "7:51"; bad values fall back; Free ignores both keys.

**Why.** Option 1 of research is the only Pro line Free's calendar-day design leaves open on purpose, needs no permission and no memory (arithmetic a few dozen lines). Keeping count local protects the one promise both listings make.

**Reversed by.** The owner. A new ADR would supersede this one; keys `Minute` and `EventZone` stay in Pro properties file forever once shipped.

**Amendment 2026-10-05 (owner, ROADMAP 13.2; simulator only): last 24 hours read `8h 06m`, not `8:06` over HOURS.** `8:06` under the time read as second clock. Hero's digits stay in number font; unit letters ("h", "m": `resources-pro/strings/units.xml`, English only for now, ROADMAP 13.7) drawn in letter font on digits' baseline (`DaysToGoHoursHero`; `Graphics.getFontAscent` where API has it, else `DaysToGoLayout.HOURS_UNIT_LIFT_PERMILLE`). HOURS caption gone, hero gets that row's height; always-on draws same group, dim. Count, rounding, zone rules unchanged. Reversed by owner (restore caption, draw hero as one string).

## Reference code

`docs/reference/` (verified first draft of logic, on-watch picker, tools) superseded by `source/` and `tools/`, then deleted; history in research notes.

## ADR-019: Rectangles get a square design

**Status.** Accepted 2026-10-08: owner approved rectangle look from simulator screenshots (`device-test/rect-review/after/DaysToGo-*`). Proposed 2026-10-05, UNRELEASED, simulator only. Owner asked for real square designs on square watches (Venu Sq, Sq Music, Sq 2, Sq 2 Music, X1) and chose "build first, then approve the real simulator screenshots before any upload". Amends ADR-006 (device set: rectangles kept round design, centred) and ADR-016 (bottom line and name step-down: amendments 3 and 5, 90 % rectangle span and its always-on exception, retired with it).

**Decision.** On `SCREEN_SHAPE_RECTANGLE` ring is closed rounded-rectangle track along glass edge (`DaysToGoTrack`), inset like round ring and as wide, centreline corner radius 15 % of shorter side (clears Venu X1's rounded glass, about 64 px, measured off SDK's device image). Keeps ADR-013 (ring beyond a year)'s meaning (ring beyond a year is grey track only) and drain of round ring: from top centre, clockwise, share of ring is same share of track's length, square-root scale and 95 % cap unchanged, closed on the day. Rows run box inside track, top to bottom, measured against it including rounded corners; caller's radius stands for depth in from edge, so always-on frame (smaller by drift step) shrinks box same way.
**Why.** Round design inscribed in rectangle wasted corners and dropped Pro's bottom line on Sq 2 (ADR-016 (bottom line shares date row), amendment 3); square watch reads square frame.
**Consequences.** `DaysToGoTrack` (geometry), `DaysToGoRing.trace` (drawing), `DaysToGoLayout.rows` / `leftInsetWithin` / `rightInsetWithin` (rectangle branch); `RECTANGLE_SPAN_PERMILLE` removed. Typography moved to `DaysToGoType` and round ring's degree maths to `DaysToGoRing` to keep layout file under 250 lines (no behaviour change). Round and Instinct paths unchanged by construction (rectangle branch taken only when track exists). Test `rectangleTrackFillMatchesItsShare`; `bottomLineIsDrawnNotSilentlyDropped` now also runs on rectangles. Rectangle listing screenshot (`listing*/screens/4-rectangle.png`) shows old design until re-taken.
**Amended 2026-10-07 (design review rounds; simulator only).** (1) **Hero band:** on rectangle number hero takes largest number font whose digits (its ascent) fit band, caption sits a row gap under digits' baseline (in font's empty descent), spare height split so ink gaps above digits and below last row match where band allows (on Sq 2 with a name it does not: number sits right under name; Pro with name and bottom line there takes next number font down, as on round) (`HERO_DIGIT_INK_PERMILLE`, digits ≈ 68 % of ascent, measured on X1), lifting bottom rows off corners' curve (`DaysToGoFrame.settle`). TODAY gets exactly a number face's lift (its band less caption row it lacks); SET A DATE, with no row under it, stays centred. Screen-fit test logs as ink (font ascent) any text made only of digits, `:`, `h` and `m` on rectangle (hero, time, all-digit name or step count; none reaches below baseline) so tuck passes; every other text, and round and Instinct, keep font box. (2) **Drift floor:** asleep, rectangle drifts at least 24 px (`RECTANGLE_MIN_DRIFT_PX`). Simulator's 24-hour heat map shut `venusq` screen off after 3 minutes with 8 px proportional step (build before this ADR too) and after 7 minutes with 16 px; with 24 px passes on `venusq` (peak pixel usage 1.95 %), `venusq2` and `venux1` (heat-map runs on build `e1bf7da`; always-on frame unchanged since, `settle` runs only awake). Round products keep proportional step. (3) With tuck, every rectangle and tier keeps full date wording; before it Free on Sq 2 took short `→ Mar 14 2027`.

## ADR-020: No on-watch date picker on the Venu Sq 2 and Sq 2 Music

**Status.** Active, UNRELEASED (2026-10-08; taken under owner's standing authority to take recommended option; **simulator evidence only**). Amends ADR-005 (on-watch date picker): products offering *Customize > Set date* lose two.

**Cause.** App does not lay picker out: system does, from per-device slots (`simulator.json` > `picker.entries`: previous column, focused column, next column), clips each label into its slot. Rounds have one wide slot and 1 x 1 neighbours, so one column shows at a time (`fr965`: 316 px). Rectangles are three different cases:
- **Venu Sq and Sq Music** (identical slots): three real slots, 72 / 89 / 72 px. Carousel: focused column in middle, neighbours either side, then OK. "Sep 30" with no year was month focused with day beside it; year is next column along. Works as system designs it.
- **Venu X1**: one slot full 448 px width, no OK slot, newer system picker. One column at a time, like rounds. Works.
- **Venu Sq 2 and Sq 2 Music** (identical slots): focused slot **30 px wide** (x 145 to 175) and neighbour slots 35 x 26 px overlap it, so "Sep" cut to "Se" and drawn into "30". **SDK's own `samples/Picker` DatePicker garbled the same way** ("a -" for "Jan -"), and a **one-column** picker too ("aOK": label cut, OK slot on top). No pattern, font or label app chooses gets usable picker out of 30 px slot, Picker API takes no geometry.

**Decision.** On Venu Sq 2 and Sq 2 Music face offers no Customize screen: `DaysToGoApp.getSettingsView` annotated `(:picker)` and both jungles exclude `picker` for `venusq2` and `venusq2m` (line restates tier and `mono`, because per-product line replaces base list), so `AppBase`'s default (no settings view) applies. Every other product unchanged. Date set in Garmin Connect (or Garmin Express), route design already relies on; site's support page already says some watches do not offer watch route. Settings classes stay in build, so `tools/picker_shot.sh` can still open picker on Sq 2.
**Why not a custom picker view.** Would replace system control on two products with own drawing and input (buttons and touch), to fix layout that may be only simulator's: real Venu Sq 2 firmware may draw its picker correctly. Too much code for unverified bug.
**Evidence.** `device-test/rect-review/picker/` (both tiers, plain and `YEARFIRST=1`, five rectangles, `fr965`, `fr55`; SDK sample in `device-test/rect-review/picker-sdk/`, three-column and one-column); debug symbols of each build: `getSettingsView` absent on `venusq2` and `venusq2m`, present on `venusq`, `venusqm`, `venux1`, `fr965`, both jungles. `docs/compatibility.md` "On-watch date picker on the rectangles".
**Undo.** If Venu Sq 2 wrist check of picker (sideloaded build with harness, or build without two jungle lines) shows real picker readable, delete two `venusq2*.excludeAnnotations` lines from each jungle.