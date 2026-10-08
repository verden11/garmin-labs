# Days To Go: spec

Status: 2026-09-26. Spec and plan written; implementation under way (see `plan.md`). Name confirmed: **Days To Go**; folder `DaysToGo/`, code prefix `DaysToGo`. A Connect IQ watch face,
independent of HeroSet and HeroFace: own look, own app id, no complication link.

Sources: [`reports/Countdown face research.md`](../../reports/Countdown%20face%20research.md) and the notes in
`research_notes/Countdown face research/`. The build order is in [`archive/plan.md`](archive/plan.md). Verified reference code is in
[`../source/`](../source/) and [`../tools/`](../tools/).

## In one paragraph

A watch face with one job: show how many days are left until a date, and get that date right every time. The days number is the
biggest thing on the screen; the time is second; nothing else is on by default. The date is set from the phone (plain lists, no date
picker) **or on the watch itself**, and the face starts with a working default (New Year's Day), so it is never empty and never broken.
No permissions, nothing leaves the watch.

## Decisions

| # | Decision | Status | Why |
|---|---|---|---|
| D1 | **Any event**, not race-only | Owner, 2026-09-26 | Biggest audience; runners are still the visible core (rival reviews) and are served by the timed-event and weeks options |
| D2 | **Price: paid $1.99 first (the price is now the $2.50 tier, D13, ADR-017); ~~one review at day 45 after approval on whether to flip to free (once, never back)~~ superseded 2026-10-04: the flip rule is retired by the Free + Pro ladder (D12, ADR-014)** | **Owner, 2026-09-26; flip rule retired 2026-10-04** | Owner's choice of option 1 after the weekly free/paid idea was advised against (see "Price"). A free flip may also send traffic to the owner's other paid apps: a hypothesis to measure, not a promise. The build is identical either way |
| D3 | **Name: Days To Go** | **Owner confirmed, 2026-09-26** (store search by eye and trademark search still to do) | Zero exact or containing collisions in the store search; matches how people say it. See `research_notes/.../naming_and_listing.md` |
| D4 | **Settings: lists, never `date` or `numeric`** | Decided (evidence) | Both failed in rivals; see "Setting the date" |
| D5 | **A second way in: set the date on the watch** (`getSettingsView` + Picker) | Decided, gated by the phase 3 device test | Removes the phone from the critical path; keep only if it does not destroy phone-set values. Documented for 94 of the 117 products; the older CIQ 3.x products and the newest have the phone only, and so do the Venu Sq 2 and Sq 2 Music (ADR-020 (no on-watch picker on the Sq 2)) |
| D6 | **Calendar-day arithmetic**, no `Time.Moment` maths | Decided (verified) | Rival bugs are all calendar bugs; unit tests pass in the simulator (43 tests; the counting rules on fr965, fenix6pro and venu2s, screen fit on ten sizes) |
| D7 | **Devices: the 117 round products HeroFace supports** (CIQ 3.0+), plus 3 rectangular AMOLED products (Venu Sq 2, Sq 2 Music, Venu X1) added 2026-09-26, and the first-generation Venu Sq and Sq Music (LCD, CIQ 3.3.6; not on the paid list, Free-only reach) added 2026-10-05; square design on the rectangles since 2026-10-05 (ADR-019) | Recommended | Same evidence base and test method; if paid, the store itself restricts sales to its own list |
| D8 | **Category: Utility** | Recommended | It is a utility face; Simple is the alternative |
| D9 | **Languages: English + HeroFace's 14 translations** | Recommended | Few strings; Russian, Greek and Chinese are owner-level additions |
| D10 | **No code sharing with HeroFace** (copy the few files, no Barrel) | Decided | A Barrel pays off at the third shared face, not the second |
| D11 | **Date style setting** (Automatic, Day first, Month first) | **Owner confirmed, 2026-09-26** | The system gives no date-order preference; words avoid ambiguity, the setting fixes the order |
| D12 | **Free + Pro pair**: the paid app becomes Days To Go Pro (1.1.0), a Free twin is added (1.0.0), one codebase, split at compile time (ADR-014 (Free + Pro ladder)) | **Approved by the owner 2026-10-04; names confirmed, Pro at the $2.50 tier (D13); both uploaded by the owner 2026-10-04, in Garmin review** | See "Free and Pro" below. ADR-014 (Free + Pro ladder) superseded D2's day-45 flip rule on 2026-10-04 |
| D13 | **Price: Days To Go Pro at the $2.50 tier** of Garmin's price points; Free is free; no price number in listing or site text (ADR-017 (price: the $2.50 tier for every paid app)) | **Owner, 2026-10-04** | Room for later discounts or a rise; supersedes D2's price. Set in the upload form with the 1.1.0 upload |

### Free and Pro

Status: **Approved by the owner 2026-10-04, uploaded 2026-10-04 (in Garmin review), simulator only.** Strategy and evidence: `../../reports/Free and Pro ladder.md`; the build plan is WP4 in `../../reports/Free and Pro ladder execution plan.md`. The decision record is ADR-014 (Free + Pro ladder) in [`decisions.md`](decisions.md). Names ("Days To Go" and "Days To Go Pro") are confirmed (owner, 2026-10-04); the price is the $2.50 tier (ADR-017); the store titles stay the owner's.

| | **Free** (new app id, $0) | **Pro** (the existing paid app id) |
|---|---|---|
| Manifest, jungle | `manifest.free.xml`, `monkey.free.jungle` | `manifest.xml`, `monkey.jungle` |
| On-watch name | Days To Go | Days To Go Pro |
| Version | 1.0.0 | 1.1.0 |
| Event (New Year's Day, Christmas Day, My own date), Name, Month, Day, Year (Every year or 2026 to 2060) | yes | yes |
| Count in (Days, Weeks and days) | yes | yes |
| Date style (Automatic, Day first, Month first) | yes | yes |
| Accent colour, ids 0 to 5 (mint, amber, sky, pink, violet, white) | **yes** (every face has an accent in Free, studio rule) | yes |
| On-watch "Set date" picker | yes | yes |
| Always-on frame, ring, hero, time, name, date lines, 15 languages | yes | yes |
| Time of day for an event (the last 24 h read as `H:MM`, the HOURS state) | no | **yes** (Hour setting) |
| Minute (0 to 59) and Event time zone (the watch's own, or UTC-12:00 to UTC+14:00) for a timed event: count to the minute, in the zone the event starts in (ADR-018 (the event minute and zone)) | no | **yes** (Minute and EventZone settings; Pro's headline, "To the minute") |
| Bottom line: battery or steps (Footer setting), after a drawn battery or footprints mark (ROADMAP 13.4) | no | **yes** |
| Accent ids 6 to 11 (cyan, lime, yellow, orange, coral, magenta) | no | **deferred**: not built; Pro-only when they come |
| New layout choice | no | **deferred**: not built |
| Permissions | none | none (Free's are always a subset of Pro's) |

Rules: Free ships the whole promise (the count, the date, the always-on frame). Its settings, properties, on-watch name and compiled code carry no "Pro" word and no Hour, Minute, EventZone or Footer key, and it has no locked or greyed item and no upgrade text (unreferenced Hour and Footer display strings and the dead HOURS and footer-drawing code still ship, shared with Pro). A phone that sends Hour, Minute, EventZone or Footer to Free is ignored (the Free properties file does not define them); the Minute and zone strings are in Pro-only resource folders, so Free does not carry them at all. The Pro headline is **"To the minute"** (owner, 2026-10-04: option 1 of `../../reports/Days To Go Pro research.md`): count down to the minute an event starts, in the zone it starts in. It is in the Pro 1.1.0 uploaded 2026-10-04 (in review), simulator only. On the "Unit unset" case: a wearer who never touches Count in gets calendar days in both tiers (`unitUnsetCountsCalendarDays`, passed in the simulator 2026-10-01).

### Price

**Update 2026-10-04 (D13, ADR-017: price: the $2.50 tier for every paid app):** Days To Go Pro moves to the $2.50 tier of Garmin's price points (US $2.49, eurozone 2,99 EUR) with the 1.1.0 upload, for room to discount or raise later. No price number appears on the site or in listing text. The text in this section is the 2026-09-26 position at $1.99, kept as history.

The owner chose paid ($1.99) on 2026-09-26. The research adds a risk the owner should see once, before submission:

- **Measured:** 15 paid countdown listings, all at download bucket 10 or lower; the four free leaders sit at 10,000 to 100,000. Free faces out-reach paid ones by a median of 10× across the store (`reports/Selling HeroSet and HeroFace.md`). Weak evidence about a *good* paid face (most of the 15 look like recent, single-purpose uploads), strong evidence that no paid countdown face has broken out.
- **Constraints of paid:** sold only on the SDK's App_Sales product list (lowest tier CIQ 3.4) and in its country list; Garmin keeps 15%; the existing merchant account is reused (`Selling HeroSet and HeroFace.md` puts break-even at about 48 sales a year across paid listings at the $100 annual fee; at $1.99 a sale nets about $1.69).
- **Reversibility:** free→paid removes the app for re-review and locks existing users out; paid→free is undocumented by Garmin. Free is the harder choice to undo, so paid is not the reckless default.
- **Alternating free and paid weeks, kept secret (owner idea, 2026-09-26): not recommended.** Garmin documents only free→paid: the app "is temporarily removed from the store so it can be reviewed again" and users "must purchase the app before they can use it again" (SDK `Monetization/App_Sales`); nothing is documented for paid→free, and no scheduled sale or promotion feature is documented. So every switch to paid costs a removal and a re-review (about 72 h) and locks out everyone who installed while free. The price is also public on the store page, so it cannot be secret, and Garmin's review guidelines (section 4d) require disclosing "from the outset if your app is only free for a limited time" and forbid bait-and-switch, so an undisclosed free period risks rejection or removal. Repeated switches also risk the ranking velocity and the merchant account the owner's other apps depend on. **Chosen by the owner (2026-09-26): paid first, at most one deliberate flip to free, never back.** The review is scheduled in "Price review" below.
- **If the owner flips to free:** no code, listing structure or site change beyond the price answer and the description's price-free wording; the success test below changes.

### Price review (reminder) — retired 2026-10-04

**Retired.** The owner approved the Free + Pro ladder on 2026-10-04 (ADR-014), so there is no day-45 flip review and the paid app is never flipped to free. The text below is kept as history.

- **When:** **45 days after the store approves the app** (the midpoint of a 30 to 60 day window). The approval date is not known yet, so the date is fixed the day approval arrives: write "Price review due <approval + 45 days>" into `DaysToGo/CLAUDE.md` (the pattern `site/CLAUDE.md` uses for its DMARC line) and into the memory index. Until then the reminder lives in the memory file `days-to-go-countdown-face` and in plan phase 10.
- **Record at submission** (baseline for the funnel question): the download buckets, review counts and ratings of HeroSet and HeroFace, and the store link for each.
- **Decide with:** the developer dashboard sales report (exact sales), the download bucket, reviews, and whether HeroSet or HeroFace moved. Proposed flip rule, owner to confirm: **fewer than 5 sales in 45 days and a download bucket of 10 or lower.**
- **The funnel hypothesis:** a free face may lift the owner's paid apps. The existing evidence is cautious: same-store attach from a free face to a separate app was only 0.2 to 10% of installs even when the app is free, from dividing download buckets, so these are ranges (`reports/Selling HeroSet and HeroFace.md`). Treat it as a bonus, not the reason. Measure it as that report says: HeroSet downloads gained per Days To Go download over the same window; if the buckets cannot show it, say so.
- **Before flipping:** Garmin publishes nothing about paid→free (removal, reviews, downloads surviving), so email Connect IQ developer support first, as the earlier report's stage 0 recommends. **Never cancel the merchant account** to demonetize: that would take HeroSet and HeroFace down too (SDK `Monetization/Account_Management`).
- **After flipping:** the description and site must stop saying "paid" wording; buyers keep their app (confirm with support); do not flip back (free→paid locks out every free user).

## What the face shows

| State | When | Hero | Caption | Ring |
|---|---|---|---|---|
| Upcoming | days > 0 | the day count, or whole weeks | DAY / DAYS / WEEKS (+ "+ n DAYS" in weeks mode) | square root of the share of the next 365 days still to go (1 day = 5% of the ring, 30 days = 29%); capped at 95% so only the day fills it; more than 365 days away: grey track only (ROADMAP 13.1) |
| Hours (**Pro only**: Free has no timed events) | timed event, under 24 h to its instant (its time in its own zone, ADR-018) | `7h 51m`, to the minute (letters in a small font; ADR-018 amendment, ROADMAP 13.2) | none | the same scale as the days, from 5% at 24 h to a sliver (ROADMAP 13.1) |
| Today | the event's day (all-day) or its instant has arrived (then until the end of its last local day) | TODAY | | full, accent |
| Past | after the event | days since | DAY SINCE / DAYS SINCE | empty track, muted |
| Invalid | a saved date that does not exist (30 Feb 2026) | SET A DATE | | none |

Always: time (device 12/24 h, no seconds), event name (if any), target date small (`Fri 25 Dec 2026`, device language), after a drawn arrow while the event is ahead (it is the event's date, not today's; ROADMAP 13.3).
Optional bottom line, off by default: battery or steps (**Pro only**). Nothing else: no weather, heart rate, notifications, Bluetooth or alarm icons.
Why nothing else: the requests in rival reviews are "I just want a simple countdown face" (Event Countdown, Countdown!).

## Setting the date

- **Phone** (Garmin Connect, Connect IQ app, Garmin Express): `Event` (New Year's Day / Christmas Day / My own date), `Name` (text, 16), `Month`, `Day`, `Year`
  (a list: *Every year*, then 2026 to 2060), `Time of day` (**Pro only**; *All day* or 00:00 to 23:00, stored as 0 = all day and 1 to 24, never a negative number), `Minute` (**Pro only**; 00 to 59, stored as 0 to 59, read only when a Time of day is set), `Event time zone` (**Pro only**; *My watch time zone*, stored as 0, or one of 40 real UTC offsets from UTC-12:00 to UTC+14:00, stored as a quarter-hour index, 1 = UTC-12:00, 49 = UTC+00:00, 105 = UTC+14:00; read only when a Time of day is set), `Count in` (Days / Weeks and days), `Date style` (Automatic / Day first / Month first), `Bottom line` (**Pro only**), `Accent`. Free shows Event, Name, Month, Day, Year, Count in, Date style and Accent (see "Free and Pro"). The Minute and Event time zone lists are phone settings only: the on-watch picker sets the date alone.
  **All lists**: a list has nothing to validate. The `date` type loses its value on iOS and Android (Countdown!: 32 of 49 low-star reviews are the date or saving it); `numeric`
  min/max failed in time2race ("must be between 0 and 0"). Generated by `tools/gen_settings.py free|pro` into `resources-free/settings/` and `resources-pro/settings/`.
- **On the watch** (the watch's own Customize menu, then Set date. **Verified on the FR965, 2026-09-26, sideloaded build:** choose the face in the watch-face list, then *Customize* (next to *Apply*), then *Set date*; the picked date applied at once and survived a restart. The route on other watches is unverified): a three-column Picker (month, day, year) writing the same properties and switching Event to *My own date*.
  No phone, no Garmin Express. **Unverified until phase 3:** whether the phone's next save overwrites it, and whether Garmin Connect shows it.
- **Never empty**: the shipped default is *New Year's Day* (every year). A face installed and never configured is still a correct, useful countdown.
- **Every year** is a Year value, not a checkbox: birthdays and anniversaries roll to next year by themselves.
- 29 Feb "every year" counts to 28 Feb in common years (an owner-visible rule; alternatives are 1 March or skipping).

## Date and time formats

The SDK's `System.DeviceSettings` exposes `is24Hour`, units, `firstDayOfWeek` and the language, and **no date-order preference**, so the face cannot read whether the wearer wants day-first or month-first. Rules:

- **Words, never numbers, for dates on the face.** The date line is weekday, day and month name from `Gregorian.utcInfo(..., FORMAT_MEDIUM)`, which the system writes in the watch's language (`Fri 25 Dec 2026`). No `03/04/2026`, so it cannot be misread.
- **Order** is the one thing the system does not give. New setting **Date style** (list): *Automatic* (default), *Day first* (`Fri 25 Dec`), *Month first* (`Fri Dec 25`). Automatic = month first when the watch language is English **and** the distance unit is statute miles (a proxy for the US), otherwise day first. On Connect IQ 3.0.x watches the system language is not readable (API 3.1), so Automatic is always day first there; the override is the answer. It will be wrong for UK wearers who use miles; the override is the answer, and the support page says so. Year is shown only when the target is not in the current year, so the line stays short.
- **Setting entry order** on the phone is fixed by `settings.xml` (Month, Day, Year) and cannot follow the wearer's locale; titles are words so nothing is ambiguous. The on-watch picker's column order follows Date style (day-first: Day, Month, Year; month-first: Month, Day, Year).
- **Time** follows the watch's 12/24 h setting (`is24Hour`) on the face. The *Time of day* setting list is always 24 h (`18:00`) because a list label cannot follow the watch setting; the support page says so.
- **Not supported:** non-Gregorian calendars (Hijri, Hebrew, Buddhist era), non-Latin digits, a different first day of the week (no weekday grid is drawn). Year list is Gregorian.

## Rules the count follows (all unit-tested)

1. Calendar days, integer arithmetic on year/month/day; no `Time.Moment` subtraction, no time-zone database, no DST rules. The **count** flips at the **watch's local midnight**, in both tiers, whatever Event time zone is set (ADR-004, amended by ADR-018 (the event minute and zone): the zone moves only when the HOURS state starts and when TODAY arrives).
2. Tomorrow is 1. The event day is TODAY (not 0). The day after is "1 DAY SINCE" (or rolls forward for an every-year event).
3. A timed event counts days until its last 24 h, then shows hours and minutes; once its time arrives it stays TODAY until midnight (also for an every-year event, which then rolls to next year). **Pro, with an Event time zone set:** "its time" is the written time in that zone converted to an instant and compared with `Time.now()`, so HOURS starts and TODAY arrives at the right moment for a wearer in another zone. The rule table (the calendar days to the written date `d`, the seconds to the instant `r`) and its edge cases are in ADR-018; in short: HOURS while 0 < r < 24 h; the count is `d` (never below 1) while r is 24 h or more; TODAY from the instant until the end of the later of the written date and the watch-local day the instant fell on; then days since. An all-day event ignores Minute and zone.
4. A date that does not exist is Invalid, shown in words, never as a number: 30 Feb 2026, and also **every-year** 31 April or 30 February (the phone's Day list offers 1 to 31 for every month). 29 Feb every year is valid.
5. The small date line takes its weekday from the calendar arithmetic and its weekday and month words from a Moment in 2026 read with `Gregorian.utcInfo()` (the SDK reads `moment()` fields as UTC; `info()` would shift the day west of UTC; a Moment cannot hold a date past January 2038). Verified in the simulator only.
6. With **My watch time zone** (the default, and always in Free) the time-of-day part of the last-24-hours display is wall-clock seconds, so across the watch's own DST change it can be an hour off. Accepted, documented. With an explicit offset it is an exact instant difference. **The face has no time-zone database: the offset is the one the event's place is on at the event's date, and the wearer chooses it** (for example, a London event on 28 March is UTC+1, on 20 March UTC+0). Choosing the wrong one makes the countdown an hour wrong; nothing on the watch can know.
7. Weeks mode applies from one full week on (`6 WEEKS + 3 DAYS`, `1 WEEK`); under 7 days the days are the honest number and it shows days. Past events always show days since.

## Design brief (visual identity is the owner's call, phase 4 gate)

Constraints (from SDK and HeroFace): primitives and system fonts only, no bitmaps; proportional layout with measured text fit; 64-colour safe values
(each channel 00, 55, AA or FF); black ground; a state is never colour alone.

Recommended direction: **"one number"**. Black ground; the hero number in white at the largest system numeric font that fits
(`FONT_NUMBER_THAI_HOT` → `HOT` → `MEDIUM` → `MILD`), centred in the middle third; a thin bezel ring (on a rectangle a rounded-rectangle track along the glass edge, ADR-019) in one accent that drains as the date approaches
(365-day window) and fills solid on the day; the time above it, medium and muted-white; event name in the accent colour above the number; caption and
date in muted grey below; nothing else. Accents (owner to approve): mint `#55FFAA` (default, distinct from HeroFace's gold and blue), amber `#FFAA00`,
sky `#55AAFF`, pink `#FF55AA`, violet `#AA55FF`, white `#FFFFFF`.

Row bands as fractions of the shorter screen side D, top to bottom (the implementer measures and stacks them as HeroFace's `HeroFaceLayout` does, then
checks each row against the circle's chord): time 0.13–0.26, event name 0.28–0.35, hero 0.36–0.68, caption 0.69–0.76, date 0.78–0.85, optional bottom line 0.87–0.93.
These are starting proportions, not a mock-up; the mock-up comes from the design tool.

**As built (ADR-012):** fractional bands overlapped on the 208 px screen, because system fonts do not scale with the screen. So each row takes the largest font up to a height cap, the rows are stacked from those heights, and the hero takes the rest; on a small screen optional rows give way: the bottom line first shares the date row (ADR-016), then drops, then the name, then the date, until the hero has room for its smallest font. The ring is a full circle from the top, clockwise; on a rectangle it is a closed rounded-rectangle track from top centre, clockwise, filled by the same share of its length (ADR-019 (rectangles get a square design)). Screen-fit tests pass on the ten sizes listed in `compatibility.md`.

**Always-on (AMOLED)**: only two lines, the hero number and the time, in dim grey (`#555555`), the whole block stepping across a 3×3 grid once a minute
(HeroFace's `HeroFaceSleep`). No ring, no name, no date. MIP watches show the full face at all times.

## Devices and memory

- 117 round products (HeroFace's `manifest.xml`) plus 5 rectangular ones (their own square design, a rounded-rectangle track, ADR-019) and 7 Instinct products, `minApiLevel` 3.0.0, one build, no bitmaps. Smallest watch-face memory 96 KB.
- Measured, finished face, simulator normal run, 2026-09-26: **28% of 110 KB on fēnix 6 Pro, 33% of 94 KB on FR55**. Simulator only.
- Not in v1: Instinct (semi-octagon, 64 KB, monochrome). A later face-shape pass, like HeroFace's phase 4.
- Paid only: sold on the SDK's App_Sales product list (lowest tier CIQ 3.4) and in its country list.

## Claims that may be made (release contract, once built)

Allowed only after the matching test or device check: "the count flips at midnight" (also true with an Event time zone: it flips at the watch's own midnight), "count down to the minute your event starts" (Pro; simulator only until the wrist checks in `status.md`), "set the time zone the event starts in" (Pro; never "handles daylight saving": the wearer picks the offset), "set the date on your watch", "no permissions, nothing leaves your watch", "works without your phone after setup".
Forbidden until measured on a device: battery figures, always-on ghosting, MIP contrast, any watch count (the store list shows fewer than the manifest), any download or rating number. Forbidden always: "the only countdown with no permissions" (Countdown!, 100,000 downloads, also asks for none); "works on every watch" or "set it on your watch" without "on many watches"; anything about rivals by name.

## Non-goals (v1)

Multiple events, notifications or reminders, weather, heart rate, complications (publish or subscribe), seconds, progress bar from a start date,
in-app purchases or keys, network of any kind, `Application.Storage`, `date`/`numeric` settings, `Time.Moment` day arithmetic.

## Risks and unknowns

| Risk / unknown | Evidence | Handling |
|---|---|---|
| Phone settings still fail for some users | Garmin Connect bugs are outside our control (`settings_and_dates.md`) | Lists, a working default, the on-watch picker, Garmin Express named in support text |
| On-watch and phone values conflict | Not documented anywhere found | Phase 3 device test T4; drop the picker if it destroys phone values |
| On-watch settings missing on 23 products (fēnix 9 family, FR70, FR170, and older CIQ 3.x: D2 family, Descent Mk1, vívoactive 3, FR645/935, Chronos, S62) | The SDK's supported-devices list omits them; for the newest this is probably doc lag | Verify on hardware; never promise the watch route on every watch |
| Nobody pays for a countdown face | 15 paid countdown faces, all at 10 downloads or fewer | Flagged in "Price"; success test below; the owner can flip to free at submission |
| A live rival (Event Countdown, 2026-03) | It is a dashboard with a countdown slot | Countdown-first, no permissions |
| Devices other than the FR965 are simulator-only | House rule | Say so in every report; MIP contrast, battery, ghosting stay open |

## Success and stop test (proposal, owner to confirm)

Judge at 60 days after approval, on the developer dashboard (sales report) and the store. The claim under test: *people will pay for a countdown that gets the date right.*
Paid: any sales at all, and at least one review that is not about setup. If there are no sales and downloads stay in the lowest bucket, the evidence says stop; the owner then chooses between switching to free (harder to undo) and leaving it. If the owner has switched to free: at least the 1,000 bucket and no review about setup. Either way, do not build a second countdown-style face on a lowest-bucket result.
