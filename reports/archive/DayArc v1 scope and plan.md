# DayArc v1 scope and implementation plan

Distilled from an adversarial review of `Time of day adaptive watch face.md` (a fresh-context agent attacked the report cold, found a factual architecture error, we converged over two rounds), then revised again after a full `Toybox.Complications` catalog check surfaced a second, bigger correction. This supersedes the original report's technical claims and scope framing; the original report's competitive/wording/craft research stands.

## Two corrections that changed the architecture

**1. Body Battery and stress are live via Complications, not history-only.** The original report said Body Battery needs `SensorHistory.getBodyBatteryHistory()` (history-only) and stress needs API 5.0+ (`stressScore`) or a 3.3.0 history fallback. Both wrong — `Toybox.Complications` (API 4.2.0) gives live numbers for both, no permission. TwoSuns already ships on this exact API (ADR-009, `minApiLevel 4.2.0`) reading Body Battery this way; the research never checked the studio's own prior app.

**2. Calendar next-event is native — no companion app needed.** The original report's biggest cut was calendar: "a watch face is barred from `Toybox.Communications` entirely," true as far as it goes, but it missed `COMPLICATION_TYPE_CALENDAR_EVENTS` (API 4.2.0, "the time of your next calendar event," `null` if none) — a separate, native path unrelated to `Communications`. Verified with a verbatim-quote fetch of the official docs and corroborated by an independent forum post ("complications for newer devices give you access to data from the calendar"). It returns a pre-formatted string, not structured event data (title/duration/location) — exactly the one-line "next event" read the original ask wanted, no more.

Pulling the full `ComplicationType` enum (42 constants, confirmed directly against the SDK docs) turned this from "3 fields plus dead ends" into a real catalog: battery %, steps, calories, floors climbed, intensity minutes, date/weekday, current + forecast weather condition, calendar events, sunrise/sunset, altitude, sea-level pressure, notification count, heart rate, weekly run/bike distance, recovery time, stress, Body Battery, VO2max (run/bike), training status, race predictors, pulse ox, respiration rate, solar input, current/high-low temperature — all API 4.2.0 except wheelchair pushes (4.2.3), golf score (5.0.0), and sleep score (6.0.2). This is what made the Simple/Pro split below possible without fragmenting the device floor.

## Why two listings, not one app with a toggle

Owner decision: **two separate store listings**, no in-app density toggle. Reasoning already on file from the prior round: settings-not-saving is this platform's single most-upvoted, best-documented failure mode (8.4% of low-star reviews in this project's own research). A toggle would put the mode switch itself on the platform's weakest spot. Two listings sidestep the bug class entirely, at the cost of double store review/listing/maintenance.

**Architecture implication:** one shared codebase, two build targets (a compile-time density flag, not a runtime setting) — both listings read from the same data layer, differing only in which fields render and how much screen each window uses. Avoids maintaining two divergent Monkey C projects. Record as an ADR.

Same device floor for both: `minApiLevel 4.2.0`, TwoSuns ADR-009's 69-product set. Every field in both variants lives at or under that floor except two bonus fields (UV, pulse ox — see below), which degrade gracefully rather than raising the floor.

## Window boundaries (locked)

Fixed clock, per owner decision: **morning 5:00-9:30, midday 9:30-17:00, evening 17:00-23:00.** Same three windows, same triggers, in both listings. A fourth window, **night (23:00-5:00)**, was not covered by the owner's three — see ADR-10, owner-reversible: time + date only, no health field.

## Simple — unchanged, one focal read per window

- **Morning (5:00-9:30)** — feels-like temperature, high/low, precipitation (`Weather.getCurrentConditions()`). UV band as a graceful-hide bonus (`uvIndex` needs API 5.1.0, confirmed above the 4.2.0 floor — never baseline).
- **Midday (9:30-17:00)** — stress band only (Garmin's own 0-25 blue/"rest"/parasympathetic, 25-100 orange/"draining"/sympathetic banding), explicit "not tracked during activity" state. Calendar next-event stays **out of Simple** — deliberate, not an oversight: Simple's whole reason to exist is the one-reading-per-window discipline, and adding a second native-and-free field back in just because it's cheap is the same "add it because it's available" pattern already rejected for sleep score in the prior round. Outdoor/break nudges stay cut (instructions, not readings).
- **Evening (17:00-23:00)** — Body Battery number + neutral capacity line, TwoSuns ADR-008 wording reused verbatim.
- **Night (23:00-5:00)** — time + date only (ADR-10). No health field.
- One shared idle/low-power template across all four windows. Explicit plain-English empty/error state per window.

## Pro (data-rich) — same three windows, more fields per window, still time-adaptive

Not a static dashboard: the density lives *inside* each time window, and the window-switching mechanic is still the product's differentiator against the flat, always-everything dashboards the market-gallery research found. Field selection below stays inside what's natively available at the shared 4.2.0 floor — no field here requires a permission or a companion app.

Owner decision: **go denser, matching the market norm (8-12+ fields per window)** rather than the more conservative 5-7 originally proposed — deliberately closer to what the top-downloaded community designs actually show. This is a conscious trade against this project's own "one focal read" research (median 4 complications, kitchen-sink outliers to 16-17) — accepted for Pro specifically, on the logic that Pro's entire reason to exist is serving the segment that wants that density, with Simple as the disciplined counterpart carrying the craft-bar position. `watch-design-lead` should still hold a hierarchy (largest/first element per window) even at this density — "more fields" isn't a license for "no layout precedence."

- **Morning (5:00-9:30)** — feels-like temp, high/low, precipitation, current weather condition icon, UV band (bonus, ≥5.1.0), sunrise/sunset, date/weekday, battery %, resting heart rate, steps-so-far, floors climbed, notification count.
- **Midday (9:30-17:00)** — next calendar event (Pro-exclusive), stress band, heart rate, intensity minutes (weekly), floors climbed, steps, calories burned, notification count, current temperature, weekly run/bike distance.
- **Evening (17:00-23:00)** — Body Battery + neutral line, recovery time remaining, respiration rate, heart rate, daily steps/calories total, pulse ox (bonus, graceful-hide below device support), training status, VO2max (run or bike, whichever the wearer has history for), date.
- **Night (23:00-5:00)** — time + date only, same as Simple (ADR-10). Even Pro doesn't add a field here — a data-rich night view fights its own purpose.

Both variants keep: no verdicts, no mood words (Body Battery/stress wording per ADR-008 either way), the shared idle/low-power template concept (each window still needs its own low-power variant in Pro, likely simplified further than the active view — untouched by this split), and explicit empty states per field that can be `null`.

## Still cut, both variants

| Feature | Why |
|---|---|
| Sleep score | Backward-looking only, no Sleep Coach recommendation in the SDK, and it was added mid-session by working backward from "a complication exists" rather than from need — the anti-pattern this project keeps re-catching. Available to revisit as a Pro-only field later if the owner wants it, on the same terms as calendar was just re-evaluated. |
| Outdoor/break nudges | Imperative framing ("go outside," "take a break"), not a reading, in either variant. |
| A calendar-driven widget artifact | The widget's only stated reason to exist was calendar; calendar is now native-in-Pro via Complications, which works on the face directly — no widget or companion app needed for it at all anymore. Re-evaluate a widget only if a future feature genuinely needs the widget surface specifically. |
| Manual event-list substitute | Now moot — the thing it was substituting for (native calendar) turned out to be buildable directly. Drop the workaround. |

## Pricing (locked)

**Simple is free. Pro is $1.99, and does not flip to free** — a deliberate break from the DaysToGo/TwoSuns 45-day flip-to-free-once rule. That rule existed to keep a reversible escape hatch on a single paid listing; here, free reach is already covered by Simple, so Pro can hold price indefinitely as the fixed monetization path without needing its own escape hatch. No flip review, no threshold to define for Pro. Simple has nothing to flip either way (free at launch, stays free).

## Naming

**DayArc** (Simple) stands. Pro listing needs its own name — proposed **DayArc Pro** pending its own store-collision check (the original naming research only cleared "DayArc," not a Pro variant). Trademark search still open for both.

## ADRs to record when this becomes spec.md

1. **Device set/API floor** — 4.2.0, Complications-first, reusing TwoSuns ADR-009's device set, both listings.
2. **Body Battery/stress/calendar data source** — `Complications`, not `SensorHistory`/`ActivityMonitor`/`Communications` — corrects the original research report's premise on all three. Permission: `ComplicationSubscriber` (manifest), both listings — corrects this plan's own first-pass "no permission" claim, see "Checked since the last pass."
3. **Two listings, one codebase** — compile-time density flag, not a runtime setting, to avoid the settings-persistence failure class.
4. **Window trigger** — fixed clock, not sunrise/sunset-relative; sun times are morning content only, in both variants.
5. **UV and pulse ox as bonus fields** — API floors above 4.2.0 (5.1.0 for UV; narrower device support for pulse ox); graceful-hide, never baseline.
6. **No-verdict wording** — reuses TwoSuns ADR-008 for Body Battery and stress in both variants.
7. **Price** — Simple free (no flip rule needed), Pro $1.99 with no flip-to-free — a deliberate departure from DaysToGo/TwoSuns ADR-002, since free reach is already covered by the Simple listing.
8. **Simple excludes calendar deliberately** — a craft decision (one-reading-per-window discipline), not a feasibility gap, recorded so it isn't "rediscovered" and re-added later the way sleep score was.
9. **Pro accepts kitchen-sink density on purpose** — 8-12+ fields/window, a deliberate departure from this project's own "one focal read" research, scoped to Pro only so Simple still carries the craft-bar position.
10. **Night window (23:00-5:00), owner-reversible** — the three locked windows cover 18 of 24 hours; night gets time + date only, the same restraint as the idle/low-power template but as a distinct fourth *active* window (not the dimmed/AOD state, which still applies on top of it). No health field at night — nothing in the field catalog is framed for a glance while trying to fall back asleep. Flagged for the owner to confirm or override before spec.md locks it.
11. **No settings surface, either variant** — the original ask said "customizations," but "two listings, no toggle" (ADR-3) already removes the one customization point most requested (density). No further `settings.xml`/`Menu2` surface is added for v1 — every remaining choice (window boundaries, field lists) is a build-time decision, not a runtime one, which sidesteps the platform's #1 complaint category entirely rather than partially. Recorded so this reads as a conscious scope cut, not an oversight, the same reason ADR-8 exists for calendar.

## Checked since the last pass

- **Correction (2026-09-27, caught before spec.md): `Complications` DOES need a manifest permission.** The module overview page has no permission note, but the Core Topics "Complications" guide states plainly: "To subscribe to a complication you need to add the ComplicationSubscriber permission to your manifest file" — confirmed by direct read via browser (the guide is JS-rendered) and corroborated by three independent Garmin forum threads reporting the exact same requirement/error when the permission is missing. TwoSuns already declares this permission for the same reason (`manifest.xml`, `ComplicationSubscriber`) — the studio's own prior app was consistent; this plan's first pass just checked the wrong page. Both DayArc manifests declare `ComplicationSubscriber`. This does not raise the API floor and needs no location/health disclosure beyond what TwoSuns's own privacy copy already covers (Complications data stays on-watch, no network), but it is a real permission line, not a "zero permissions" listing claim.
- **`getComplication(id)` throws `ComplicationNotFoundException` if the complication itself is unsupported/unavailable on that device** — confirmed on the same Core Topics page (a try/catch example is the documented pattern, not an optional defensive extra). Separately, many field *values* are documented as "or null" even when the complication is found (no data yet, e.g. a new device with no activity history). The data-access wrapper must handle both: catch the exception per field, then null-check the value.
- **Store-collision check, both names:** searched `apps.garmin.com`'s own search for "DayArc" (985 fuzzy results) and "DayArc Pro" (996 fuzzy results), sorted by relevance — no exact title match for either in the top results for either query. Closest neighbors: SkyArc, ArcMetrics, ArcNext, DaysTo, DayBreakr — none a collision.
- **General web/trademark scan:** no software product or app named "DayArc" found. One unrelated company, "Day Arc Environmental Systems" (two words, indoor cannabis-cultivation HVAC systems) — different industry, different trademark class, low collision risk, but noted for the record.
- **These are not a substitute for a real USPTO/legal trademark search** — that stays open. What's checked is store-collision and obvious-conflict risk, which is what was actually blocking a naming decision at this stage.
- **VO2max, training status, pulse ox, recovery time, weekly run/bike distance have no documented device-support or null-condition notes in the SDK reference** — confirmed by direct check. This isn't good news: it means there's no doc-level shortcut, only real hardware settles which of these are populated on which device, same as any other "simulator passing is not device proof" case. Stays a device gate, not resolved by this pass.

## Gates still open — device-only, can't be resolved from here

- Real 4.2+ hardware: confirm `Complications.getComplication()` returns non-null for every field this plan uses, per device in the target set. The simulator is known to not reliably model real per-device sensor/data absence for this API family — a simulator-only pass would not be device proof here.
- Confirm `CALENDAR_EVENTS` actually populates on a device with Garmin Connect Mobile calendar sync enabled, and confirm the `null` empty state (no sync enabled, or no upcoming event) reads as a plain sentence, not blank.
- Confirm UV and pulse ox hide cleanly below their respective floors/device support.
- Device screenshot check that "current UV" wording can't be misread as a forecast claim.
- Define the empty state for VO2max/training-status/weekly-distance on a wearer with no logged activity history — needed regardless of which devices support the sensor, since even a supporting device returns `null` until the wearer has logged enough activity.
- A real USPTO/legal trademark search for both names, if the owner wants that level of clearance before publishing (store-collision risk is now checked; registered-trademark risk is not).

## Implementation plan

1. Trademark/collision search — "DayArc" and "DayArc Pro."
2. Scaffold the 6th project from `watch-design-kit/templates/watch-app/` — device tier = TwoSuns ADR-009's set; structure as one codebase, two build targets from the start rather than retrofitting later.
3. Draft `spec.md` + `docs/decisions.md` with the 9 ADRs above.
4. `DESIGN.md` via `watch-design-lead` — Simple's 3 layouts, Pro's 3 denser layouts (hold a layout hierarchy even at 8-12+ fields), shared idle/low-power template for both, empty-state copy per field (including "no activity history yet" for VO2max/training-status/weekly-distance).
5. Build against simulator: both variants, Complications subscriptions per the field lists above.
6. Simulator compile sweep across the full 69-product device set for both build targets.
7. Device probes — the gates above, on real hardware, both variants. Simulator passing is not device proof.
8. Listing drafts (`listing/paste.md` + `NOTES.md`) for both, once wording ADRs are locked. Pro's listing states plainly it's a fixed $1.99 with no free tier.
9. Submit both. No flip-to-free clock for either listing — Simple launches free and stays free, Pro launches paid and stays paid.
