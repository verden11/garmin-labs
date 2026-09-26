# Days To Go decision log (ADRs)

Every durable design decision, newest last. [`spec.md`](spec.md) says what the product is; this file says why. Add an ADR at the end for any decision a future contributor would otherwise re-litigate. Mark old ADRs **Superseded** or **Amended**, never delete.

| ADR | Decision | Status |
|---|---|---|
| 001 | Any event, countdown-first | Active |
| 002 | Price: paid $1.99 first, one review at approval + 45 days | Active |
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

## ADR-001: Any event, countdown-first

**Decision.** The face counts to any date the wearer chooses (birthday, race, trip, New Year), not only races. It is countdown-first: the day count is the largest thing, the time second, nothing else on by default.
**Why.** Biggest audience; runners stay served by the timed-event and weeks options. Rival reviews ask for "just a simple countdown face".
**Evidence.** `reports/Countdown face research.md` §1 to §2; owner decision 2026-09-26.

## ADR-002: Price

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

## ADR-006: Device set

**Decision.** HeroFace's 117 round products (CIQ 3.0+) plus Venu Sq 2, Venu Sq 2 Music and Venu X1 (rectangular AMOLED, CIQ 5+), one build, no bitmaps, no per-device resources. On the rectangles the face keeps its round design: the ring is a circle the size of the shorter side, centred, with black bars above and below. Added 2026-09-26 at the owner's request as the cheap widening; the round-chord text checks are stricter than a rectangle needs, so nothing overflows. Instinct (semi-octagon, monochrome, 64 KB) is a later pass with its own layout; pre-CIQ-3 watches are not worth it (no Menu2 or settings screen, and paid apps are sold only on CIQ 3.4+).
**Why.** Same evidence base and test method as HeroFace; smallest memory budget 96 KB, and the measured build is far under it.

## ADR-007: Always-on

**Decision.** AMOLED sleep frame is only the hero and the time in dim grey, the block stepping across a 3 × 3 grid once a minute. MIP watches keep the full face.
**Why.** Garmin's 10% lit-pixel and 3-minute limits; same approach as HeroFace. The sleep hero starts at FONT_NUMBER_MEDIUM, two sizes below awake. **Unverified, and a known risk**: the SDK says an individual pixel may be on for no more than three update cycles and at most 10% of pixels may be lit, else the whole screen goes dark; the first version's fixed 4 px drift was smaller than a digit stroke, so interior pixels of a big digit stayed lit across all nine positions; the step is now proportional to the screen (HeroFace ships the same scheme with a smaller clock). The owner's heat map and an always-on night on the FR965 decide; if the screen blanks, raise `BURN_IN_STEP_PERMILLE` (now 35, about 16 px on 454, a bit more than a digit stroke, so a stroke clears itself when the row changes) or shrink the hero.

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

## Reference code

`docs/reference/` (the verified first draft of the logic, the on-watch picker and the tools) is superseded by `source/` and `tools/` and is to be deleted; its history is in the research notes.
