# Days To Go: spec

Status: 2026-09-26. Spec, plan written; implementation under way (see `plan.md`). Name confirmed: **Days To Go**; folder `DaysToGo/`, code prefix `DaysToGo`. Connect IQ watch face, independent of HeroSet and HeroFace: own look, own app id, no complication link.

Sources: [`reports/Countdown face research.md`](../../reports/Countdown%20face%20research.md) and notes in
`research_notes/Countdown face research/`. Build order in [`archive/plan.md`](archive/plan.md). Verified reference code in
[`../source/`](../source/) and [`../tools/`](../tools/).

## In one paragraph

Watch face, one job: show days left until a date, get date right every time. Days number biggest on screen; time second; nothing else on by default. Date set from phone (plain lists, no date
picker) **or on the watch itself**; face starts with working default (New Year's Day), so never empty, never broken.
No permissions, nothing leaves watch.

## Decisions

| # | Decision | Status | Why |
|---|---|---|---|
| D1 | **Any event**, not race-only | Owner, 2026-09-26 | Biggest audience; runners still visible core (rival reviews), served by timed-event and weeks options |
| D2 | **Price: paid $1.99 first (price now $2.50 tier, D13, ADR-017 (price: the $2.50 tier for every paid app)); ~~one review at day 45 after approval on whether to flip to free (once, never back)~~ superseded 2026-10-04: flip rule retired by Free + Pro ladder (D12, ADR-014 (Free + Pro ladder))** | **Owner, 2026-09-26; flip rule retired 2026-10-04** | Owner chose option 1 after weekly free/paid idea advised against (see "Price"). Free flip may also send traffic to owner's other paid apps: hypothesis to measure, not promise. Build identical either way |
| D3 | **Name: Days To Go** | **Owner confirmed, 2026-09-26** (store search by eye and trademark search still to do) | Zero exact or containing collisions in store search; matches how people say it. See `research_notes/.../naming_and_listing.md` |
| D4 | **Settings: lists, never `date` or `numeric`** | Decided (evidence) | Both failed in rivals; see "Setting the date" |
| D5 | **Second way in: set date on watch** (`getSettingsView` + Picker) | Decided, gated by phase 3 device test | Removes phone from critical path; keep only if it does not destroy phone-set values. Documented for 94 of 117 products; older CIQ 3.x products and newest have phone only, so do Venu Sq 2 and Sq 2 Music (ADR-020 (no on-watch picker on the Sq 2)) |
| D6 | **Calendar-day arithmetic**, no `Time.Moment` maths | Decided (verified) | Rival bugs all calendar bugs; unit tests pass in simulator (43 tests; counting rules on fr965, fenix6pro, venu2s, screen fit on ten sizes) |
| D7 | **Devices: 117 round products HeroFace supports** (CIQ 3.0+), plus 3 rectangular AMOLED products (Venu Sq 2, Sq 2 Music, Venu X1) added 2026-09-26, and first-generation Venu Sq and Sq Music (LCD, CIQ 3.3.6; not on paid list, Free-only reach) added 2026-10-05; square design on rectangles since 2026-10-05 (ADR-019 (rectangles get a square design)) | Recommended | Same evidence base, test method; if paid, store itself restricts sales to its own list |
| D8 | **Category: Utility** | Recommended | Utility face; Simple is alternative |
| D9 | **Languages: English + HeroFace's 14 translations** | Recommended | Few strings; Russian, Greek, Chinese are owner-level additions |
| D10 | **No code sharing with HeroFace** (copy few files, no Barrel) | Decided | Barrel pays off at third shared face, not second |
| D11 | **Date style setting** (Automatic, Day first, Month first) | **Owner confirmed, 2026-09-26** | System gives no date-order preference; words avoid ambiguity, setting fixes order |
| D12 | **Free + Pro pair**: paid app becomes Days To Go Pro (1.1.0), Free twin added (1.0.0), one codebase, split at compile time (ADR-014 (Free + Pro ladder)) | **Approved by owner 2026-10-04; names confirmed, Pro at $2.50 tier (D13); both uploaded by owner 2026-10-04, in Garmin review** | See "Free and Pro" below. ADR-014 (Free + Pro ladder) superseded D2's day-45 flip rule on 2026-10-04 |
| D13 | **Price: Days To Go Pro at $2.50 tier** of Garmin's price points; Free is free; no price number in listing or site text (ADR-017 (price: the $2.50 tier for every paid app)) | **Owner, 2026-10-04** | Room for later discounts or rise; supersedes D2's price. Set in upload form with 1.1.0 upload |

### Free and Pro

Status: **Approved by owner 2026-10-04, uploaded 2026-10-04 (in Garmin review), simulator only.** Strategy, evidence: `../../reports/Free and Pro ladder.md`; build plan is WP4 in `../../reports/Free and Pro ladder execution plan.md`. Decision record is ADR-014 (Free + Pro ladder) in [`decisions.md`](decisions.md). Names ("Days To Go" and "Days To Go Pro") confirmed (owner, 2026-10-04); price is $2.50 tier (ADR-017 (price: the $2.50 tier for every paid app)); store titles stay owner's.

| | **Free** (new app id, $0) | **Pro** (existing paid app id) |
|---|---|---|
| Manifest, jungle | `manifest.free.xml`, `monkey.free.jungle` | `manifest.xml`, `monkey.jungle` |
| On-watch name | Days To Go | Days To Go Pro |
| Version | 1.0.0 | 1.1.0 |
| Event (New Year's Day, Christmas Day, My own date), Name, Month, Day, Year (Every year or 2026 to 2060) | yes | yes |
| Count in (Days, Weeks and days) | yes | yes |
| Date style (Automatic, Day first, Month first) | yes | yes |
| Accent colour, ids 0 to 5 (mint, amber, sky, pink, violet, white) | **yes** (every face has accent in Free, studio rule) | yes |
| On-watch "Set date" picker | yes | yes |
| Always-on frame, ring, hero, time, name, date lines, 15 languages | yes | yes |
| Time of day for event (last 24 h read as `H:MM`, HOURS state) | no | **yes** (Hour setting) |
| Minute (0 to 59) and Event time zone (watch's own, or UTC-12:00 to UTC+14:00) for timed event: count to the minute, in zone event starts in (ADR-018 (the event minute and zone)) | no | **yes** (Minute and EventZone settings; Pro's headline, "To the minute") |
| Bottom line: battery or steps (Footer setting), after drawn battery or footprints mark (ROADMAP 13.4) | no | **yes** |
| Accent ids 6 to 11 (cyan, lime, yellow, orange, coral, magenta) | no | **deferred**: not built; Pro-only when they come |
| New layout choice | no | **deferred**: not built |
| Permissions | none | none (Free's always subset of Pro's) |

Rules: Free ships whole promise (count, date, always-on frame). Its settings, properties, on-watch name, compiled code carry no "Pro" word and no Hour, Minute, EventZone or Footer key; no locked or greyed item, no upgrade text (unreferenced Hour and Footer display strings and dead HOURS and footer-drawing code still ship, shared with Pro). Phone sending Hour, Minute, EventZone or Footer to Free is ignored (Free properties file does not define them); Minute and zone strings are in Pro-only resource folders, so Free does not carry them at all. Pro headline is **"To the minute"** (owner, 2026-10-04: option 1 of `../../reports/Days To Go Pro research.md`): count down to minute event starts, in zone it starts in. In Pro 1.1.0 uploaded 2026-10-04 (in review), simulator only. "Unit unset" case: wearer who never touches Count in gets calendar days in both tiers (`unitUnsetCountsCalendarDays`, passed in simulator 2026-10-01).

### Price

**Update 2026-10-04 (D13, ADR-017: price: the $2.50 tier for every paid app):** Days To Go Pro moves to $2.50 tier of Garmin's price points (US $2.49, eurozone 2,99 EUR) with 1.1.0 upload, for room to discount or raise later. No price number on site or in listing text. Text in this section is 2026-09-26 position at $1.99, kept as history.

Owner chose paid ($1.99) on 2026-09-26. Research adds risk owner should see once, before submission:

- **Measured:** 15 paid countdown listings, all at download bucket 10 or lower; four free leaders at 10,000 to 100,000. Free faces out-reach paid ones by median 10× across store (`reports/Selling HeroSet and HeroFace.md`). Weak evidence about a *good* paid face (most of 15 look like recent, single-purpose uploads), strong evidence no paid countdown face has broken out.
- **Constraints of paid:** sold only on SDK's App_Sales product list (lowest tier CIQ 3.4) and its country list; Garmin keeps 15%; existing merchant account reused (`Selling HeroSet and HeroFace.md` puts break-even at about 48 sales a year across paid listings at $100 annual fee; at $1.99 a sale nets about $1.69).
- **Reversibility:** free→paid removes app for re-review, locks existing users out; paid→free undocumented by Garmin. Free harder choice to undo, so paid not reckless default.
- **Alternating free and paid weeks, kept secret (owner idea, 2026-09-26): not recommended.** Garmin documents only free→paid: app "is temporarily removed from the store so it can be reviewed again" and users "must purchase the app before they can use it again" (SDK `Monetization/App_Sales`); nothing documented for paid→free, no scheduled sale or promotion feature documented. So every switch to paid costs removal and re-review (about 72 h), locks out everyone who installed while free. Price also public on store page, so cannot be secret, and Garmin's review guidelines (section 4d) require disclosing "from the outset if your app is only free for a limited time" and forbid bait-and-switch, so undisclosed free period risks rejection or removal. Repeated switches also risk ranking velocity and merchant account owner's other apps depend on. **Chosen by owner (2026-09-26): paid first, at most one deliberate flip to free, never back.** Review scheduled in "Price review" below.
- **If owner flips to free:** no code, listing structure or site change beyond price answer and description's price-free wording; success test below changes.

### Price review (reminder) — retired 2026-10-04

**Retired.** Owner approved Free + Pro ladder on 2026-10-04 (ADR-014 (Free + Pro ladder)), so no day-45 flip review, paid app never flipped to free. Text below kept as history.

- **When:** **45 days after store approves app** (midpoint of 30 to 60 day window). Approval date not known yet, so date fixed the day approval arrives: write "Price review due <approval + 45 days>" into `DaysToGo/CLAUDE.md` (pattern `site/CLAUDE.md` uses for its DMARC line) and into memory index. Until then reminder lives in memory file `days-to-go-countdown-face` and plan phase 10.
- **Record at submission** (baseline for funnel question): download buckets, review counts, ratings of HeroSet and HeroFace, store link for each.
- **Decide with:** developer dashboard sales report (exact sales), download bucket, reviews, whether HeroSet or HeroFace moved. Proposed flip rule, owner to confirm: **fewer than 5 sales in 45 days and download bucket of 10 or lower.**
- **Funnel hypothesis:** free face may lift owner's paid apps. Existing evidence cautious: same-store attach from free face to separate app only 0.2 to 10% of installs even when app free, from dividing download buckets, so these are ranges (`reports/Selling HeroSet and HeroFace.md`). Treat as bonus, not reason. Measure as that report says: HeroSet downloads gained per Days To Go download over same window; if buckets cannot show it, say so.
- **Before flipping:** Garmin publishes nothing about paid→free (removal, reviews, downloads surviving), so email Connect IQ developer support first, as earlier report's stage 0 recommends. **Never cancel merchant account** to demonetize: would take HeroSet and HeroFace down too (SDK `Monetization/Account_Management`).
- **After flipping:** description and site must stop saying "paid" wording; buyers keep app (confirm with support); do not flip back (free→paid locks out every free user).

## What the face shows

| State | When | Hero | Caption | Ring |
|---|---|---|---|---|
| Upcoming | days > 0 | day count, or whole weeks | DAY / DAYS / WEEKS (+ "+ n DAYS" in weeks mode) | square root of share of next 365 days still to go (1 day = 5% of ring, 30 days = 29%); capped at 95% so only the day fills it; more than 365 days away: grey track only (ROADMAP 13.1) |
| Hours (**Pro only**: Free has no timed events) | timed event, under 24 h to its instant (its time in its own zone, ADR-018 (the event minute and zone)) | `7h 51m`, to the minute (letters in small font; ADR-018 (the event minute and zone) amendment, ROADMAP 13.2) | none | same scale as days, from 5% at 24 h to sliver (ROADMAP 13.1) |
| Today | event's day (all-day) or its instant has arrived (then until end of its last local day) | TODAY | | full, accent |
| Past | after event | days since | DAY SINCE / DAYS SINCE | empty track, muted |
| Invalid | saved date that does not exist (30 Feb 2026) | SET A DATE | | none |

Always: time (device 12/24 h, no seconds), event name (if any), target date small (`Fri 25 Dec 2026`, device language), after drawn arrow while event ahead (it is event's date, not today's; ROADMAP 13.3).
Optional bottom line, off by default: battery or steps (**Pro only**). Nothing else: no weather, heart rate, notifications, Bluetooth or alarm icons.
Why nothing else: requests in rival reviews are "I just want a simple countdown face" (Event Countdown, Countdown!).

## Setting the date

- **Phone** (Garmin Connect, Connect IQ app, Garmin Express): `Event` (New Year's Day / Christmas Day / My own date), `Name` (text, 16), `Month`, `Day`, `Year`
  (list: *Every year*, then 2026 to 2060), `Time of day` (**Pro only**; *All day* or 00:00 to 23:00, stored as 0 = all day and 1 to 24, never negative number), `Minute` (**Pro only**; 00 to 59, stored as 0 to 59, read only when Time of day set), `Event time zone` (**Pro only**; *My watch time zone*, stored as 0, or one of 40 real UTC offsets from UTC-12:00 to UTC+14:00, stored as quarter-hour index, 1 = UTC-12:00, 49 = UTC+00:00, 105 = UTC+14:00; read only when Time of day set), `Count in` (Days / Weeks and days), `Date style` (Automatic / Day first / Month first), `Bottom line` (**Pro only**), `Accent`. Free shows Event, Name, Month, Day, Year, Count in, Date style, Accent (see "Free and Pro"). Minute and Event time zone lists are phone settings only: on-watch picker sets date alone.
  **All lists**: list has nothing to validate. `date` type loses value on iOS and Android (Countdown!: 32 of 49 low-star reviews are date or saving it); `numeric`
  min/max failed in time2race ("must be between 0 and 0"). Generated by `tools/gen_settings.py free|pro` into `resources-free/settings/` and `resources-pro/settings/`.
- **On the watch** (watch's own Customize menu, then Set date. **Verified on FR965, 2026-09-26, sideloaded build:** choose face in watch-face list, then *Customize* (next to *Apply*), then *Set date*; picked date applied at once, survived restart. Route on other watches unverified): three-column Picker (month, day, year) writing same properties, switching Event to *My own date*.
  No phone, no Garmin Express. **Unverified until phase 3:** whether phone's next save overwrites it, whether Garmin Connect shows it.
- **Never empty**: shipped default *New Year's Day* (every year). Face installed, never configured, still correct, useful countdown.
- **Every year** is Year value, not checkbox: birthdays, anniversaries roll to next year by themselves.
- 29 Feb "every year" counts to 28 Feb in common years (owner-visible rule; alternatives 1 March or skipping).

## Date and time formats

SDK's `System.DeviceSettings` exposes `is24Hour`, units, `firstDayOfWeek`, language, and **no date-order preference**, so face cannot read whether wearer wants day-first or month-first. Rules:

- **Words, never numbers, for dates on face.** Date line is weekday, day, month name from `Gregorian.utcInfo(..., FORMAT_MEDIUM)`, which system writes in watch's language (`Fri 25 Dec 2026`). No `03/04/2026`, so cannot be misread.
- **Order** is the one thing system does not give. New setting **Date style** (list): *Automatic* (default), *Day first* (`Fri 25 Dec`), *Month first* (`Fri Dec 25`). Automatic = month first when watch language is English **and** distance unit is statute miles (proxy for US), otherwise day first. On Connect IQ 3.0.x watches system language not readable (API 3.1), so Automatic always day first there; override is the answer. Wrong for UK wearers who use miles; override is the answer, support page says so. Year shown only when target not in current year, so line stays short.
- **Setting entry order** on phone fixed by `settings.xml` (Month, Day, Year), cannot follow wearer's locale; titles are words so nothing ambiguous. On-watch picker's column order follows Date style (day-first: Day, Month, Year; month-first: Month, Day, Year).
- **Time** follows watch's 12/24 h setting (`is24Hour`) on face. *Time of day* setting list always 24 h (`18:00`) because list label cannot follow watch setting; support page says so.
- **Not supported:** non-Gregorian calendars (Hijri, Hebrew, Buddhist era), non-Latin digits, different first day of week (no weekday grid drawn). Year list Gregorian.

## Rules the count follows (all unit-tested)

1. Calendar days, integer arithmetic on year/month/day; no `Time.Moment` subtraction, no time-zone database, no DST rules. **Count** flips at **watch's local midnight**, both tiers, whatever Event time zone set (ADR-004 (calendar-day count), amended by ADR-018 (the event minute and zone): zone moves only when HOURS state starts and when TODAY arrives).
2. Tomorrow is 1. Event day is TODAY (not 0). Day after is "1 DAY SINCE" (or rolls forward for every-year event).
3. Timed event counts days until its last 24 h, then shows hours and minutes; once its time arrives stays TODAY until midnight (also for every-year event, which then rolls to next year). **Pro, with Event time zone set:** "its time" is written time in that zone converted to instant and compared with `Time.now()`, so HOURS starts and TODAY arrives at right moment for wearer in another zone. Rule table (calendar days to written date `d`, seconds to instant `r`) and edge cases in ADR-018 (the event minute and zone); in short: HOURS while 0 < r < 24 h; count is `d` (never below 1) while r is 24 h or more; TODAY from instant until end of later of written date and watch-local day instant fell on; then days since. All-day event ignores Minute and zone.
4. Date that does not exist is Invalid, shown in words, never as number: 30 Feb 2026, and also **every-year** 31 April or 30 February (phone's Day list offers 1 to 31 for every month). 29 Feb every year valid.
5. Small date line takes weekday from calendar arithmetic and weekday and month words from Moment in 2026 read with `Gregorian.utcInfo()` (SDK reads `moment()` fields as UTC; `info()` would shift day west of UTC; Moment cannot hold date past January 2038). Verified in simulator only.
6. With **My watch time zone** (default, and always in Free) time-of-day part of last-24-hours display is wall-clock seconds, so across watch's own DST change can be hour off. Accepted, documented. With explicit offset it is exact instant difference. **Face has no time-zone database: offset is the one event's place is on at event's date, and wearer chooses it** (for example, London event on 28 March is UTC+1, on 20 March UTC+0). Wrong choice makes countdown hour wrong; nothing on watch can know.
7. Weeks mode applies from one full week on (`6 WEEKS + 3 DAYS`, `1 WEEK`); under 7 days days are honest number, shows days. Past events always show days since.

## Design brief (visual identity is the owner's call, phase 4 gate)

Constraints (from SDK and HeroFace): primitives and system fonts only, no bitmaps; proportional layout with measured text fit; 64-colour safe values
(each channel 00, 55, AA or FF); black ground; state never colour alone.

Recommended direction: **"one number"**. Black ground; hero number white at largest system numeric font that fits
(`FONT_NUMBER_THAI_HOT` → `HOT` → `MEDIUM` → `MILD`), centred in middle third; thin bezel ring (on rectangle a rounded-rectangle track along glass edge, ADR-019 (rectangles get a square design)) in one accent that drains as date approaches
(365-day window), fills solid on the day; time above it, medium, muted-white; event name in accent colour above number; caption and
date muted grey below; nothing else. Accents (owner to approve): mint `#55FFAA` (default, distinct from HeroFace's gold and blue), amber `#FFAA00`,
sky `#55AAFF`, pink `#FF55AA`, violet `#AA55FF`, white `#FFFFFF`.

Row bands as fractions of shorter screen side D, top to bottom (implementer measures, stacks them as HeroFace's `HeroFaceLayout` does, then
checks each row against circle's chord): time 0.13–0.26, event name 0.28–0.35, hero 0.36–0.68, caption 0.69–0.76, date 0.78–0.85, optional bottom line 0.87–0.93.
Starting proportions, not mock-up; mock-up comes from design tool.

**As built (ADR-012 (row-height layout)):** fractional bands overlapped on 208 px screen, because system fonts do not scale with screen. So each row takes largest font up to height cap, rows stacked from those heights, hero takes rest; on small screen optional rows give way: bottom line first shares date row (ADR-016 (bottom line shares the date row)), then drops, then name, then date, until hero has room for its smallest font. Ring is full circle from top, clockwise; on rectangle closed rounded-rectangle track from top centre, clockwise, filled by same share of its length (ADR-019 (rectangles get a square design)). Screen-fit tests pass on ten sizes listed in `compatibility.md`.

**Always-on (AMOLED)**: only two lines, hero number and time, dim grey (`#5C5C5C`, 3.14:1 on black, burn-in-protected screens only; was `#555555` until 2026-10-08, ADR-007 (always-on) amendment), whole block stepping across 3×3 grid once a minute
(HeroFace's `HeroFaceSleep`). No ring, no name, no date. Error frame ("?" when settings cannot be read) also draws in `#5C5C5C`, drifts on same grid while asleep there, stays white and still otherwise (ADR-007 (always-on) amendment 2026-10-08). MIP watches show full face at all times.

## Devices and memory

- 117 round products (HeroFace's `manifest.xml`) plus 5 rectangular ones (own square design, rounded-rectangle track, ADR-019 (rectangles get a square design)) and 7 Instinct products, `minApiLevel` 3.0.0, one build, no bitmaps. Smallest watch-face memory 96 KB.
- Measured, finished face, simulator normal run, 2026-09-26: **28% of 110 KB on fēnix 6 Pro, 33% of 94 KB on FR55**. Simulator only.
- Not in v1: Instinct (semi-octagon, 64 KB, monochrome). Later face-shape pass, like HeroFace's phase 4.
- Paid only: sold on SDK's App_Sales product list (lowest tier CIQ 3.4) and its country list.

## Claims that may be made (release contract, once built)

Allowed only after matching test or device check: "the count flips at midnight" (also true with Event time zone: flips at watch's own midnight), "count down to the minute your event starts" (Pro; simulator only until wrist checks in `status.md`), "set the time zone the event starts in" (Pro; never "handles daylight saving": wearer picks offset), "set the date on your watch", "no permissions, nothing leaves your watch", "works without your phone after setup".
Forbidden until measured on a device: battery figures, always-on ghosting, MIP contrast, any watch count (store list shows fewer than manifest), any download or rating number. Forbidden always: "the only countdown with no permissions" (Countdown!, 100,000 downloads, also asks for none); "works on every watch" or "set it on your watch" without "on many watches"; anything about rivals by name.

## Non-goals (v1)

Multiple events, notifications or reminders, weather, heart rate, complications (publish or subscribe), seconds, progress bar from start date,
in-app purchases or keys, network of any kind, `Application.Storage`, `date`/`numeric` settings, `Time.Moment` day arithmetic.

## Risks and unknowns

| Risk / unknown | Evidence | Handling |
|---|---|---|
| Phone settings still fail for some users | Garmin Connect bugs outside our control (`settings_and_dates.md`) | Lists, working default, on-watch picker, Garmin Express named in support text |
| On-watch and phone values conflict | Not documented anywhere found | Phase 3 device test T4; drop picker if it destroys phone values |
| On-watch settings missing on 23 products (fēnix 9 family, FR70, FR170, older CIQ 3.x: D2 family, Descent Mk1, vívoactive 3, FR645/935, Chronos, S62) | SDK's supported-devices list omits them; for newest probably doc lag | Verify on hardware; never promise watch route on every watch |
| Nobody pays for a countdown face | 15 paid countdown faces, all at 10 downloads or fewer | Flagged in "Price"; success test below; owner can flip to free at submission |
| Live rival (Event Countdown, 2026-03) | Dashboard with countdown slot | Countdown-first, no permissions |
| Devices other than FR965 simulator-only | House rule | Say so in every report; MIP contrast, battery, ghosting stay open |

## Success and stop test (proposal, owner to confirm)

Judge at 60 days after approval, on developer dashboard (sales report) and store. Claim under test: *people will pay for a countdown that gets the date right.*
Paid: any sales at all, and at least one review not about setup. No sales and downloads stay in lowest bucket: evidence says stop; owner then chooses between switching to free (harder to undo) and leaving it. If owner switched to free: at least the 1,000 bucket and no review about setup. Either way, do not build second countdown-style face on lowest-bucket result.