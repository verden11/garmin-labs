# Days To Go decision log (ADRs)

Every durable design decision, newest last. [`spec.md`](spec.md) says what the product is; this file says why. Add an ADR at the end for any decision a future contributor would otherwise re-litigate. Mark old ADRs **Superseded** or **Amended**, never delete.

| ADR | Decision | Status |
|---|---|---|
| 001 | Any event, countdown-first | Active |
| 002 | Price: paid $1.99 first, one review at approval + 45 days | **Superseded** 2026-10-04 by 014 (the Free + Pro ladder; the owner retired the day-45 flip rule) and, for the price, by 017 (price: the $2.50 tier for every paid app) |
| 003 | List settings, never `date` or `numeric` | Active |
| 004 | Calendar-day arithmetic, no `Time.Moment` maths | Active |
| 005 | On-watch date picker | **Open**: gated by the owner's device test (plan phase 3) |
| 006 | Device set: 117 round products (CIQ 3.0+) plus 3 rectangular AMOLED | Active |
| 007 | Always-on is hero and time on a shifting grid | Active |
| 008 | Name **Days To Go**, site slug `days-to-go` | Active |
| 009 | 29 Feb every year counts to 28 Feb in common years | Active |
| 010 | No permissions, no `Storage`, nothing leaves the watch | Active |
| 011 | Date style setting, and dates written in words | Active |
| 012 | Rows are stacked from font heights, optional rows drop on small screens | Active |
| 013 | Ring beyond a year is the grey track only | Active |
| 014 | Free + Pro ladder: a Free twin beside the paid app, which becomes Days To Go Pro | Active (accepted 2026-10-04: the owner approved the ladder) |
| 015 | Instinct family: window gauge, black and white, no accent | Active (accepted 2026-10-04; simulator only) |
| 017 | Price: the $2.50 tier for every paid app | Active (accepted 2026-10-04; ships with the 1.1.0 upload) |

## ADR-001: Any event, countdown-first

**Decision.** The face counts to any date the wearer chooses (birthday, race, trip, New Year), not only races. It is countdown-first: the day count is the largest thing, the time second, nothing else on by default.
**Why.** Biggest audience; runners stay served by the timed-event and weeks options. Rival reviews ask for "just a simple countdown face".
**Evidence.** `reports/Countdown face research.md` §1 to §2; owner decision 2026-09-26.

## ADR-002: Price

**Status: Superseded 2026-10-04 by ADR-014 (the Free + Pro ladder).** The owner approved the ladder on 2026-10-04 and retired the day-45 flip rule below: the paid app is never flipped to free, the Free twin replaces that idea. The first-submission price (paid, the lowest tier) was the live price until the next upload; **the price is Superseded by [ADR-017](#adr-017) (price: the $2.50 tier for every paid app)**. The text below is the history.

**Decision.** Paid, the lowest tier (USD 2.00, shown as $1.99 in the US, the same tier as HeroFace and HeroSet), at first submission. One review 45 days after store approval on whether to flip to free, once, never back. Proposed rule (owner to confirm): fewer than 5 sales in 45 days and a download bucket of 10 or lower.
**Why.** Owner's choice (2026-09-26) after the weekly free/paid idea was advised against: Garmin documents only free→paid (removal and re-review, buyers locked out), and the store's rules require disclosing a limited-time free period. Risk on record: 15 paid countdown faces, all at 10 downloads or fewer; free leaders 10,000 to 100,000. A free flip may also send traffic to the owner's other paid apps: a hypothesis to measure, not a promise.
**How to apply.** The build is identical either way. Email Connect IQ developer support before flipping; never cancel the merchant account (it would take HeroSet and HeroFace down). Reminder and details: `spec.md` "Price review".

## ADR-003: List settings, never `date` or `numeric`

**Decision.** Month, Day, Year, Time of day and every other choice is a `list` setting; the name is `alphaNumeric`. The generator is `tools/gen_settings.py`. List values are never negative. A default event (New Year's Day) means the face is never empty.
**Why.** Garmin Connect's `date` picker shows an empty value or 1 January 1970 on iOS and Android and forgets the date (Countdown!: 32 of 49 low-star reviews). `numeric` min/max failed in time2race ("must be between 0 and 0"). A list has nothing to validate.
**Evidence.** `research_notes/Countdown face research/settings_and_dates.md`, `rival_reviews.md`. Not yet confirmed on a phone: plan phase 3.

## ADR-004: Calendar-day arithmetic

**Decision.** The count is integer arithmetic on year, month and day (`DaysToGoCalendar.dayNumber`), read from one `Gregorian.info(Time.now(), FORMAT_SHORT)`. No `Time.Moment` subtraction, no time zones, no DST. It flips at local midnight; the target date line reads a `Gregorian.moment` back with `utcInfo`.
**Why.** Every rival day-count bug (a day off, tomorrow counted as two) is a calendar bug.
**Evidence.** Unit tests: every day of 1970 to 2100 advances by exactly 1; leap days; boundaries; impossible dates; each rival bug. Simulator only.

## ADR-005: On-watch date picker

**Status: open (route and basic function verified on the FR965 on 2026-09-26; the phone/watch overwrite question is not).** Route on the FR965: pick the face in the watch-face list, then *Customize* next to *Apply*, then *Set date*; the date applied at once and survived a restart. `getSettingsView` opens a Menu2 with "Set date" and a three-column Picker that writes the same Properties as the phone. Kept in the build on the assumption it helps; the owner's FR965 test T4 (plan phase 3) decides between keeping both routes ("last change wins" documented) and dropping the picker. Available on 94 of the 117 products by the SDK's list; never promise it on every watch. Settings are re-read on every `onUpdate` because the picker writes without a callback.

**Amended 2026-10-04 (ROADMAP 10.13; simulator only).** The harness showed the picker cut on the Instinct ("Octobe", "ery ye") because each column is clipped to about a third of the screen. Now: the month column shows the short month word of the watch's language (`DaysToGoDateText.monthWord`, the words the date row already uses, so no new strings in 15 languages); the label font steps down with the screen (tiny to 176 px, small to 280 px, medium above; `DaysToGoConfig.PICKER_*_FONT_MAX_PX`); "Every year" is broken after its first word onto two lines; the picker is its own class that clears to black before drawing, as the SDK Picker sample does. The phone's month list still uses the full names (`month_N`). The black clear is **not visible in the simulator** (the SDK's own sample also draws white on a colour MIP `fenix5s` there), so whether a real MIP watch is legible is for the owner's wrist check (ROADMAP 3.1).

## ADR-006: Device set

**Decision.** HeroFace's 117 round products (CIQ 3.0+) plus Venu Sq 2, Venu Sq 2 Music and Venu X1 (rectangular AMOLED, CIQ 5+), one build, no bitmaps, no per-device resources. On the rectangles the face keeps its round design: the ring is a circle the size of the shorter side, centred, with black bars above and below. Added 2026-09-26 at the owner's request as the cheap widening; the round-chord text checks are stricter than a rectangle needs, so nothing overflows. Instinct (semi-octagon, monochrome, 64 KB) is a later pass with its own layout; pre-CIQ-3 watches are not worth it (no Menu2 or settings screen, and paid apps are sold only on CIQ 3.4+).
**Why.** Same evidence base and test method as HeroFace; smallest memory budget 96 KB, and the measured build is far under it.

## ADR-007: Always-on

**Decision.** AMOLED sleep frame is only the hero and the time in dim grey, the block stepping across a 3 × 3 grid once a minute. MIP watches keep the full face.
**Why.** Garmin's 10% lit-pixel and 3-minute limits; same approach as HeroFace. The sleep hero starts at FONT_NUMBER_MEDIUM, two sizes below awake. **Unverified, and a known risk**: the SDK says an individual pixel may be on for no more than three update cycles and at most 10% of pixels may be lit, else the whole screen goes dark; the first version's fixed 4 px drift was smaller than a digit stroke, so interior pixels of a big digit stayed lit across all nine positions; the step is now proportional to the screen (HeroFace ships the same scheme with a smaller clock). The owner's heat map and an always-on night on the FR965 decide; if the screen blanks, raise `BURN_IN_STEP_PERMILLE` (now 35, about 16 px on 454, a bit more than a digit stroke, so a stroke clears itself when the row changes) or shrink the hero.

**Amended 2026-10-04 (ROADMAP 10.17, Garmin policies research; history above kept).** The limits are now cited to Garmin's pages, read 2026-10-04: the AMOLED FAQ ("How do I Make a Watch Face for AMOLED Products?", also in the SDK docs) says burn-in protection is active when the watch face is in the foreground and the system is asleep, and "if more than 10% of the screen pixels are on or any pixel is on for longer than 3 minutes, the system will shut off the screen" (a pixel is on in any colour but black). Caveats: (1) **Garmin's pages disagree on the time**: the same FAQ says 3 minutes, the Entry Points page says "AMOLED always active (version 1)" stops "any pixel from being enabled for more than four minutes", or more than 10% of the pixels; we design to the shorter figure, and our block moves every minute, so both hold. (2) **The pixel rule is the original Venu's.** The FAQ: "Since the Venu 2, the rule for always-on is to use less than 10% of the screen's luminance", and Entry Points' "version 2" has only the 10% pixel limit with no dwell time; which product uses which rule is read at run time (`requiresBurnInProtection`, `System.getDisplayMode`), not from a list we hold. So "lit-pixel share" is the right measure only on the original Venu; on Venu 2 and later it is luminance (a dim grey counts for less than white). (3) What stays unverified is our own frame's share: no heat-map run and no always-on night on a wrist (ROADMAP 3.1); the simulator's File > View Screen Heat Map is Garmin's tool for it. Garmin's watch-face page adds: avoid much white or blue (light gray instead), thin fonts, and shift static elements up to four pixels every minute; this face's grid step is about 16 px, larger than four. The word "Unverified" above now means "our frame untested", not "Garmin's figure uncited".

## ADR-008: Name and slug

**Decision.** Days To Go. Site slug `days-to-go`, permanent once published.
**Status.** Confirmed by the owner 2026-09-26. The store search by eye and a trademark search are still the owner's.

## ADR-009: 29 February every year

**Decision.** An every-year event on 29 Feb counts to 28 Feb in common years. A specific 29 Feb of a common year is invalid; so is every-year 30 Feb or 31 Apr.
**Why.** Alternatives (1 March, skipping) surprise more. Tested.

## ADR-010: No permissions, no Storage

**Decision.** Empty permission list; settings live in `Application.Properties` only; no network. Stated in the privacy page. The claim "the only countdown with no permissions" is forbidden (Countdown! also asks for none).

## ADR-011: Date style and words

**Decision.** Dates on the face are words (`Fri 25 Dec 2026`) from `Gregorian.utcInfo(..., FORMAT_MEDIUM)`, in the watch's language. Order is the one thing the system does not tell us, so a Date style list (Automatic, Day first, Month first) decides; Automatic is month first only for English with statute miles (and never on CIQ 3.0.x, where the language is unreadable). Weekday comes from the calendar arithmetic, the words from a 2026 Moment (a Moment ends in 2038). Year appears only when it differs from the current year. Time of day list is always 24 h.
**Why.** `DeviceSettings` has no date-order field. Owner confirmed 2026-09-26.

## ADR-012: Rows follow font heights

**Decision.** Row fonts are chosen first (largest under a height cap), then the rows are stacked from those heights and the hero takes the rest. When the hero would fall below its smallest font, optional rows drop: footer, then name, then date.
**Why.** Fractional bands overlapped on the 208 px screen because system fonts do not scale with the screen. The screen-fit test caught it.

## ADR-013: Ring beyond a year

**Decision.** The ring is the share of the next 365 days still to go. Beyond 365 days it shows the grey track only; a full accent ring appears only on the day itself (and at exactly 365 days).
**Why.** Found on the FR965 on 2026-09-26: an event 760 days away drew a full ring, the same as the day itself. Owner chose this option over keeping the cap or storing a start date.
**Amended the same day.** Owner: with 1 day left a linear ring is 0.3% of the circle, useless. The share is now square-rooted (1 day 5%, 7 days 14%, 30 days 29%, 91 days 50%, 365 days 100%): continuous and always shrinking. Counting the last day in hours was rejected for all-day events because the ring would jump from about 0% to 100% at the day boundary; timed events already use hours in their last 24 h.

## ADR-014: Free + Pro ladder

**Status: Accepted (Active) 2026-10-04: the owner approved the ladder 2026-10-04 (OD1 and OD2 in `../../reports/Free and Pro ladder.md`).** Written 2026-10-01 as Proposed. This supersedes ADR-002's day-45 flip rule (the paid app is never flipped to free; the Free twin replaces that idea), and ADR-002 is Superseded in the same commit. Still the owner's, not decided here: names, the Pro price, icons, translations and every upload. Nothing here is uploaded or priced.

**Decision.** Days To Go ships as a pair built from one codebase at compile time, DayArc's method (`../../DayArc/docs/decisions.md`, ADR-003 there: no runtime toggle, no unlock key, no locked items):

- **Pro** is the existing app: `manifest.xml`, the live app id (never changes), `monkey.jungle`, which excludes every `(:free)` symbol and uses `resources;resources-pro`. On-watch name "Days To Go Pro". Version 1.1.0 (UNRELEASED).
- **Free** is new: `manifest.free.xml`, app id `9fde2744-b0f4-4396-927d-e4c7d65bb119` (generated with `uuidgen` 2026-10-01, never changes once published), `monkey.free.jungle`, which excludes every `(:pro)` symbol and uses `resources;resources-free`. On-watch name "Days To Go". Version 1.0.0 (UNRELEASED). Same 120 products, same `minApiLevel` 3.0.0, same 15 languages, empty permission list (Free's permissions are a subset of Pro's, never more).
- **The split** (plan WP4 step 3). Free: Event, Name, Month, Day, Year, Unit (days or weeks), Date style, Accent (ids 0 to 5, the shipped list). Pro adds Hour (a timed event: the last 24 h read as H:MM) and Footer (battery or steps). Accent ids 6 to 11 (cyan, lime, yellow, orange, coral, magenta) are **deferred**: no new colour is added by this ADR, and when they come they are Pro-only and appended (ids are append-only, never reused).
- **Settings files live only in tier folders**: `resources-pro/settings/` (every key) and `resources-free/settings/` (no Hour, no Footer). The shared `resources/` holds **no** settings file, so two never overlap and the compiler is never asked which one wins. `tools/gen_settings.py free|pro` writes them.
- **AppName** lives only in `resources-pro/strings` and `resources-free/strings`. Not in `resources/`, and not in the 14 `resources-<lang>/` folders: a language folder that defined it would override the tier name on a non-English watch. A language does **not** inherit the default's strings (the compiler warns "String id 'AppName' undefined for language ..."), so each jungle also appends its tier folder to every `base.lang.<l>` path. `tools/check_strings.py` enforces both rules.
- **Code**: `DaysToGoSettings` reads Hour and Footer only in `(:pro)`; the `(:free)` twin returns the defaults (all day, no bottom line) and asks the system for neither key. `DaysToGoReadings.footerText` and `stepsText` and the `KEY_HOUR` and `KEY_FOOTER` constants are `(:pro)`. The Free build's settings, properties, on-watch name and compiled code carry no "Pro" word and no Hour or Footer key, and it has no locked or greyed item and no upgrade text. Not removed from Free: the unreferenced Hour and Footer display strings (`setting_hour`, `footer_*`, `h0` to `h23`, shared with Pro) and the dead HOURS-phase and footer-drawing code. The timed-event arithmetic (`DaysToGoCountdown`, the HOURS phase) stays in shared code, because it is pure and the hour is simply never set in Free; that is dead code in Free, kept on purpose (cutting it would fork the counting rule of ADR-004, calendar-day arithmetic).
- **Properties missing-key behaviour.** Per the SDK 9.2.0 reference, `Application.Properties.getValue` of a key absent from the properties file throws `Properties.InvalidKeyException`. Free never calls it for Hour or Footer, so nothing depends on it; `read()` already catches the exception. In the simulator `freeMissingPropertyKeyThrows` passed on Free (fr965, fr55, venusq2, 2026-10-01): it calls `getValue("Hour")` in a build whose properties file lacks Hour, catching only `Properties.InvalidKeyException`, and asserts that it was thrown. So the simulator throws that exception for a missing key (it does not return null or a default, nor throw another type). It says nothing about a real watch.
- **The on-watch Customize menu** has one item, "Set date", and no accent or Pro item, so it is identical in both tiers by construction.
- **Verification** (`docs/development.md` "Checking a store package"): `tools/check_free_package.sh` unpacks the compiled `.iq` packages and fails if the Free settings contain Hour or Footer, if "Pro" appears anywhere in the Free package, or if the Pro package lacks them; `tools/compile_sweep.sh` compiles every product for both jungles; `tools/run_tests.sh <device> [jungle]` runs the suite on either.

**Why.** Plan WP4 (`../../reports/Free and Pro ladder execution plan.md`): a free twin reaches 33 more products than the paid listing can (Garmin sells paid apps only on its own list), and the owner asked for the missing Free/Pro variants. A compile-time split keeps one source, no licence server and no locked UI.

**Consequences.** The live paid app's on-watch name becomes "Days To Go Pro" at 1.1.0: a visible change for existing buyers, owner's call. Pro behaviour is otherwise identical to 1.0.1 (same settings, same ids, same defaults; `resources-pro/settings` is byte-identical to the old `resources/settings`). The Pro headline (what a buyer pays for beyond the timed event and bottom line) is **not** established: no research was run; if none is found, ship Pro as the shipped extras only and say Pro is thin (plan WP4 step 1). **Owner decisions, not made here:** store names and titles, the Pro price, Free's icon, translations of any new string, the uploads (Free 1.0.0 as a new app, Pro 1.1.0 on the existing id, together), the site deploy, and OD1 to OD4.

## ADR-015: Instinct family: window gauge, black and white, no accent
**Status: Accepted (Active) 2026-10-04 (owner approved the ladder 2026-10-04). Written 2026-10-03 as Proposed; the owner approved the look (mockup `docs/archive/instinct-mockup.html`) the same day, and chose to hide the Accent setting on these watches. Nothing has run on a watch (the owner has none): simulator evidence only. Not uploaded. Accepted does not mean device-proven.**

**Context.** 7 semi-octagon products are watch-face capable and were left out of ADR-001's product set: `instinct2`, `instinct2s`, `instinct2x`, `descentg1` (CIQ 3.4) and `instincte40mm`, `instincte45mm`, `instinct3solar45mm` (CIQ 6.0). `instinctcrossover` is left out as in HeroSet (its analog hands cover the display; the simulator shows no window). They are 1-bit (palette `000000`/`FFFFFF` only, no anti-aliasing), 176 x 176 (`instincte40mm` 166 x 166, `instinct2s` 163 x 156), and have a round **window** (62 px, 52 px on the E 40 mm, 54 px on the 2S) cut into the top-right corner. Their **watch-face memory is 65,536 B** (the 96 KB floor in ADR-001 does not hold). All seven are at or above `minApiLevel` 3.0.0, and the face needs no Complications, so the Instinct 2 family is reachable.

**Decision.**
- **Products.** The 7 above join both manifests (127 products in each tier). One build per tier, as before.
- **Layout.** `DaysToGoLayout` asks `WatchUi.getSubscreen()` on `SCREEN_SHAPE_SEMI_OCTAGON` products only, so no round or rectangular product's geometry depends on it. Rows are boxes, not chords: a side margin each side, and a row that starts above the window's lower edge plus a ring clearance (6% of the screen) ends left of it and is centred in the band that is left (`rowCenterX`). The time takes that band (the largest number font whose time fits it, up to 20% of the screen) and the event name sits under it; the hero starts below the window and takes the rest above the caption and the date. **The bezel ring becomes a gauge in the window**: a hairline circle (the track) with a thick fill inside it (a quarter of the window radius), same share, same direction from 12 o'clock, closed on the day.
- **Footer dropped.** The battery or steps line (Pro) has no room: the watch's smallest font is 23 px tall on a 176 px screen, so time, name, hero, caption and date already use the height. A mono Pro build therefore shows the same rows as Free. Listing wording must not promise the footer on Instinct.
- **Black and white by annotation.** `DaysToGoPalette` is two classes with the same name (`(:color)` and `(:mono)`); the jungles exclude `mono` for every product and `color` for the 7 Instinct products. All roles are white; the track is an outline under a solid fill; TODAY is a word and a closed gauge, never a colour. **A per-product `excludeAnnotations` line replaces the base list**, so the tier's own exclude is restated (`free;color` in `monkey.jungle`, `pro;color` in `monkey.free.jungle`); writing `color` alone would have silently broken the Free/Pro split. The test counts prove it: Pro and Free Instinct builds run their own tier-only tests.
- **Accent hidden on Instinct (owner, 2026-10-03).** The Accent list lives in its own settings file (`resources-accent-<tier>/settings/accent.xml`, written by `tools/gen_settings.py`); the Instinct products' `resourcePath` leaves that folder out, so the phone shows no Accent setting for them. The property stays in `properties.xml` (a shipped key never changes) and `DaysToGoPalette.accent()` returns white. A settings file a second resource folder tries to override did not work (the compiler merges settings, so Accent stayed); a folder that is simply absent does. Round products' settings order is unchanged (Accent last). `tools/check_free_package.sh` checks both: no Accent key on the 7 Instinct parts, Accent ids 0 to 5 on the rest.
- **Always-on.** The Instinct is MIP without burn-in rules, so it keeps the full face and never draws the always-on frame (its drift test skips these products).
- **The visible area is a circle (found by simulator screenshot, 2026-10-03).** The bezel hides the corners: what shows is the square cut by a circle about 98 px in radius (96 to 100 px, from the alpha mask of the SDK's device images, all seven products), not the 20 px chamfer the mockup drew. `DaysToGoLayout` clips every row's insets to a 96 px circle (`VISIBLE_RADIUS_PX`), and the fit test fails any text box whose corner leaves it (`collectCorners`; boxes include font padding, so this is stricter than the ink).

**Why.** The same reasoning as HeroSet ADR-055 (the same hardware): the window is the one place a gauge fits; a 1-bit screen cannot carry an accent or a dim track; footers do not fit 23 px fonts on 176 px.

**Consequences.** The mockup drew type about 15 px tall; the real smallest font is 23 px, so the real face has a smaller hero than the mockup (see "Evidence"). Pro on Instinct loses the footer; Accent is not offered there. No round product's drawing changed: `rowCenterX` returns the centre and the insets are unchanged without a window (round control suites pass).

**Verification.** See `docs/compatibility.md` "Instinct family". Simulator only; real bezel margins, contrast and the on-watch Customize menu (is it offered on an Instinct?) are unmeasured.

## ADR-016: The bottom line shares the date row before it is dropped; a name steps down a font
**Status: Proposed. Written 2026-10-04 (owner authorised UI fixes without asking first); simulator only.**

**Context.** A simulator screenshot on the FR965 (454 px) with a named event and Pro's bottom line on showed no bottom line: with the name, caption and date rows present the hero would have had less than its smallest font, and the layout dropped the footer first (ADR-012). The setting appeared to do nothing on the flagship watch, while a 218 px FR255S showed it. On an Instinct 3 Solar a 12-character name ended in "..." although a smaller font would have shown it whole.

**Decision.** (1) When the hero would be too small, the bottom line first moves onto the date's row, joined by " · " ("Sat Dec 19 · 50%"; each date wording with the footer, then the date alone, so a chord too narrow for both keeps the date). Only if the hero is still too small does it drop, then the name, then the date, as before. A state that had room is unchanged. (2) The name tries each smaller name font before it is cut short with "...".

**Why.** A feature the owner switched on must not vanish silently on the biggest screen; the date row is short enough to carry a few characters more.

**Consequences.** `DaysToGoFrame.footerWithDate`, `nameFonts`; `DaysToGoView.dateCandidates`; test `bottomLineIsDrawnNotSilentlyDropped` (round, 218 px and up). The Instinct has no bottom line (ADR-015). The middle dot renders in the FR965 simulator font; not seen on a wrist.

**Amended 2026-10-04 (ROADMAP 10.12; the owner asked for the open cases to be fixed or documented).** (3) **Rectangles get a taller stack.** On a 320 x 360 rectangle (`venusq2`, `venusq2m`) the smallest font is 39 px tall, as on a round watch, but the ring is only 320 px, so the stack of rows ran out of height: with a name the hero fell below its smallest font and the name, then the bottom line, were dropped. `DaysToGoLayout` now spans 90 % of the content radius on a rectangle (`RECTANGLE_SPAN_PERMILLE`) instead of 80 %; every text is still measured against the round chord, so none touches the ring. Result on `venusq2` with a 12-character name, a date and the bottom line on: the name shows again and the hero keeps its largest font; the date steps down to its shorter wording ("Dec 19" instead of "Sat Dec 19") because the bottom row's chord is narrower; **the bottom line is still dropped** ("Dec 19 · 50%" does not fit that chord). Round and Instinct products are unchanged by construction (the span applies only to `SCREEN_SHAPE_RECTANGLE`); `venux1`, the other rectangle, passed the suite too. (4) **Not fixable: the Instinct 3 Solar and the Instinct 2 (both 176 px, both screenshotted) still cut a 12-character name** ("Anna and T..."; the Instinct E 45 mm has the same screen size but was not screenshotted). Tried: the name wrapped onto two lines at a space beside the window. It does not fit: the 23 px smallest font makes two lines 46 px, the hero then starts at y 92 instead of 72 and the band left for it (about 22 px) is under the hero's smallest font, so something must go, and the only rows left are the caption ("DAYS") and the date, which the product promises. A cut name stays; the code was not kept. The Instinct E 40 mm (166 px) and wider chords show 12 characters whole.

## ADR-017: Price: the $2.50 tier for every paid app

**Status: Accepted 2026-10-04 (owner, chat).** Supersedes the price of [ADR-002](#adr-002-price) (paid at the lowest tier, USD 2.00 / $1.99 US); ADR-002's day-45 review was already retired by ADR-014 (the Free + Pro ladder).

**Decision.** Days To Go Pro (the paid app, the live app id) moves to the **USD 2.50 tier** of Garmin's price points (US $2.49, eurozone 2,99 EUR; measured table in `../../research_notes/Free and Pro ladder/garmin_rules.md`, source https://developer.garmin.com/connect-iq/monetization/price-points/). Every paid app in the studio (HeroSet, HeroFace Pro, Days To Go Pro, Two Suns Pro, DayArc Pro) takes the same tier. Days To Go (Free) stays free. The owner sets the tier in the upload form.

**Why.** Room for later discounts or a rise: Garmin's tiers are $2.00, then every $0.25, so the lowest tier left no step down. The tier converts to a different number in each store, so no number is stated where a reader sees it.

**No price number on the site or in listing text.** Neither listing's Description or What's New, nor the pages under `site/src/apps/days-to-go/`, state a price.

**Open risk.** Garmin documents that changing the price of an approved app can take it out of the store for re-review (SDK `Monetization/App_Sales`); how it treats a repricing to a higher tier is not confirmed. Ship the change together with the 1.1.0 version upload (Pro), which is re-reviewed anyway. The Garmin email on repricing was cancelled (owner, 2026-10-04, [`../../ROADMAP.md`](../../ROADMAP.md) 2.1); the agent re-reads Garmin's published policies instead (`../../reports/Garmin policies and design guidelines.md`, running), so the risk stays open until that report answers it.

**Reversed by.** The owner.

## Reference code

`docs/reference/` (the verified first draft of the logic, the on-watch picker and the tools) was superseded by `source/` and `tools/`, then deleted; its history is in the research notes.
