# DayArc v1 scope and implementation plan

Distilled from adversarial review of `Time of day adaptive watch face.md` (fresh-context agent attacked report cold, found factual architecture error, converged over two rounds), then revised again after full `Toybox.Complications` catalog check surfaced second, bigger correction. Supersedes original report's technical claims and scope framing; original report's competitive/wording/craft research stands.

## Two corrections that changed the architecture

**1. Body Battery and stress live via Complications, not history-only.** Original report said Body Battery needs `SensorHistory.getBodyBatteryHistory()` (history-only), stress needs API 5.0+ (`stressScore`) or 3.3.0 history fallback. Both wrong — `Toybox.Complications` (API 4.2.0) gives live numbers for both, no permission. TwoSuns already ships on this API (ADR-009, `minApiLevel 4.2.0`) reading Body Battery this way; research never checked studio's own prior app.

**2. Calendar next-event native — no companion app needed.** Original report's biggest cut was calendar: "a watch face is barred from `Toybox.Communications` entirely," true as far as it goes, but missed `COMPLICATION_TYPE_CALENDAR_EVENTS` (API 4.2.0, "the time of your next calendar event," `null` if none) — separate native path unrelated to `Communications`. Verified by verbatim-quote fetch of official docs, corroborated by independent forum post ("complications for newer devices give you access to data from the calendar"). Returns pre-formatted string, not structured event data (title/duration/location) — exactly the one-line "next event" read original ask wanted, no more.

Full `ComplicationType` enum (42 constants, confirmed directly against SDK docs) turned "3 fields plus dead ends" into real catalog: battery %, steps, calories, floors climbed, intensity minutes, date/weekday, current + forecast weather condition, calendar events, sunrise/sunset, altitude, sea-level pressure, notification count, heart rate, weekly run/bike distance, recovery time, stress, Body Battery, VO2max (run/bike), training status, race predictors, pulse ox, respiration rate, solar input, current/high-low temperature — all API 4.2.0 except wheelchair pushes (4.2.3), golf score (5.0.0), sleep score (6.0.2). This made Simple/Pro split possible without fragmenting device floor.

## Why two listings, not one app with a toggle

Owner decision: **two separate store listings**, no in-app density toggle. Reasoning on file from prior round: settings-not-saving = platform's single most-upvoted, best-documented failure mode (8.4% of low-star reviews in this project's own research). Toggle puts mode switch on platform's weakest spot. Two listings sidestep bug class entirely, cost: double store review/listing/maintenance.

**Architecture implication:** one shared codebase, two build targets (compile-time density flag, not runtime setting) — both listings read same data layer, differ only in which fields render and how much screen each window uses. Avoids two divergent Monkey C projects. Record as ADR.

Same device floor both: `minApiLevel 4.2.0`, TwoSuns ADR-009's 69-product set. Every field in both variants at or under floor except two bonus fields (UV, pulse ox — see below), which degrade gracefully, not raise floor.

## Window boundaries (locked)

Fixed clock, per owner decision: **morning 5:00-9:30, midday 9:30-17:00, evening 17:00-23:00.** Same three windows, same triggers, both listings. Fourth window, **night (23:00-5:00)**, not covered by owner's three — see ADR-10, owner-reversible: time + date only, no health field.

## Simple — unchanged, one focal read per window

- **Morning (5:00-9:30)** — feels-like temperature, high/low, precipitation (`Weather.getCurrentConditions()`). UV band graceful-hide bonus (`uvIndex` needs API 5.1.0, confirmed above 4.2.0 floor — never baseline).
- **Midday (9:30-17:00)** — stress band only (Garmin's own 0-25 blue/"rest"/parasympathetic, 25-100 orange/"draining"/sympathetic banding), explicit "not tracked during activity" state. Calendar next-event stays **out of Simple** — deliberate, not oversight: Simple's whole reason to exist = one-reading-per-window discipline; adding second native-and-free field just because cheap = same "add it because it's available" pattern already rejected for sleep score in prior round. Outdoor/break nudges stay cut (instructions, not readings).
- **Evening (17:00-23:00)** — Body Battery number + neutral capacity line, TwoSuns ADR-008 wording reused verbatim.
- **Night (23:00-5:00)** — time + date only (ADR-10). No health field.
- One shared idle/low-power template across all four windows. Explicit plain-English empty/error state per window.

## Pro (data-rich) — same three windows, more fields per window, still time-adaptive

Not static dashboard: density lives *inside* each time window; window-switching mechanic still product's differentiator against flat, always-everything dashboards market-gallery research found. Field selection stays inside natively available at shared 4.2.0 floor — no field requires permission or companion app.

Owner decision: **go denser, matching market norm (8-12+ fields per window)** rather than more conservative 5-7 originally proposed — deliberately closer to what top-downloaded community designs show. Conscious trade against project's own "one focal read" research (median 4 complications, kitchen-sink outliers to 16-17) — accepted for Pro specifically; Pro's reason to exist = serving segment wanting that density, Simple = disciplined counterpart carrying craft-bar position. `watch-design-lead` should still hold hierarchy (largest/first element per window) even at this density — "more fields" not license for "no layout precedence."

- **Morning (5:00-9:30)** — feels-like temp, high/low, precipitation, current weather condition icon, UV band (bonus, ≥5.1.0), sunrise/sunset, date/weekday, battery %, resting heart rate, steps-so-far, floors climbed, notification count.
- **Midday (9:30-17:00)** — next calendar event (Pro-exclusive), stress band, heart rate, intensity minutes (weekly), floors climbed, steps, calories burned, notification count, current temperature, weekly run/bike distance.
- **Evening (17:00-23:00)** — Body Battery + neutral line, recovery time remaining, respiration rate, heart rate, daily steps/calories total, pulse ox (bonus, graceful-hide below device support), training status, VO2max (run or bike, whichever wearer has history for), date.
- **Night (23:00-5:00)** — time + date only, same as Simple (ADR-10). Even Pro adds no field here — data-rich night view fights its own purpose.

Both variants keep: no verdicts, no mood words (Body Battery/stress wording per ADR-008 either way), shared idle/low-power template concept (each window still needs own low-power variant in Pro, likely simplified further than active view — untouched by this split), explicit empty states per field that can be `null`.

## Still cut, both variants

| Feature | Why |
|---|---|
| Sleep score | Backward-looking only, no Sleep Coach recommendation in SDK; added mid-session by working backward from "a complication exists" not from need — anti-pattern project keeps re-catching. Can revisit as Pro-only field later if owner wants, same terms as calendar just re-evaluated. |
| Outdoor/break nudges | Imperative framing ("go outside," "take a break"), not reading, either variant. |
| A calendar-driven widget artifact | Widget's only stated reason to exist was calendar; calendar now native-in-Pro via Complications, works on face directly — no widget or companion app needed anymore. Re-evaluate widget only if future feature genuinely needs widget surface specifically. |
| Manual event-list substitute | Moot — what it substituted for (native calendar) buildable directly. Drop workaround. |

## Pricing (locked)

**Simple free. Pro $1.99, does not flip to free** — deliberate break from DaysToGo/TwoSuns 45-day flip-to-free-once rule. Rule existed to keep reversible escape hatch on single paid listing; here free reach already covered by Simple, so Pro holds price indefinitely as fixed monetization path, no own escape hatch. No flip review, no threshold to define for Pro. Simple has nothing to flip either way (free at launch, stays free).

## Naming

**DayArc** (Simple) stands. Pro listing needs own name — proposed **DayArc Pro** pending own store-collision check (original naming research only cleared "DayArc," not Pro variant). Trademark search still open for both.

## ADRs to record when this becomes spec.md

1. **Device set/API floor** — 4.2.0, Complications-first, reusing TwoSuns ADR-009's device set, both listings.
2. **Body Battery/stress/calendar data source** — `Complications`, not `SensorHistory`/`ActivityMonitor`/`Communications` — corrects original research report's premise on all three. Permission: `ComplicationSubscriber` (manifest), both listings — corrects this plan's own first-pass "no permission" claim, see "Checked since the last pass."
3. **Two listings, one codebase** — compile-time density flag, not runtime setting, avoids settings-persistence failure class.
4. **Window trigger** — fixed clock, not sunrise/sunset-relative; sun times morning content only, both variants.
5. **UV and pulse ox as bonus fields** — API floors above 4.2.0 (5.1.0 for UV; narrower device support for pulse ox); graceful-hide, never baseline.
6. **No-verdict wording** — reuses TwoSuns ADR-008 for Body Battery and stress, both variants.
7. **Price** — Simple free (no flip rule needed), Pro $1.99 with no flip-to-free — deliberate departure from DaysToGo/TwoSuns ADR-002, free reach already covered by Simple listing.
8. **Simple excludes calendar deliberately** — craft decision (one-reading-per-window discipline), not feasibility gap, recorded so not "rediscovered" and re-added later like sleep score.
9. **Pro accepts kitchen-sink density on purpose** — 8-12+ fields/window, deliberate departure from project's own "one focal read" research, scoped to Pro only so Simple still carries craft-bar position.
10. **Night window (23:00-5:00), owner-reversible** — three locked windows cover 18 of 24 hours; night gets time + date only, same restraint as idle/low-power template but as distinct fourth *active* window (not dimmed/AOD state, which still applies on top). No health field at night — nothing in field catalog framed for glance while trying to fall back asleep. Flagged for owner to confirm or override before spec.md locks it.
11. **No settings surface, either variant** — original ask said "customizations," but "two listings, no toggle" (ADR-3) already removes most-requested customization point (density). No further `settings.xml`/`Menu2` surface added for v1 — every remaining choice (window boundaries, field lists) = build-time decision, not runtime, sidesteps platform's #1 complaint category entirely, not partially. Recorded so reads as conscious scope cut, not oversight, same reason ADR-8 exists for calendar.

## Checked since the last pass

- **Correction (2026-09-27, caught before spec.md): `Complications` DOES need manifest permission.** Module overview page has no permission note, but Core Topics "Complications" guide states plainly: "To subscribe to a complication you need to add the ComplicationSubscriber permission to your manifest file" — confirmed by direct read via browser (guide JS-rendered), corroborated by three independent Garmin forum threads reporting same requirement/error when permission missing. TwoSuns already declares this permission for same reason (`manifest.xml`, `ComplicationSubscriber`) — studio's own prior app consistent; plan's first pass just checked wrong page. Both DayArc manifests declare `ComplicationSubscriber`. Does not raise API floor, needs no location/health disclosure beyond what TwoSuns's own privacy copy covers (Complications data stays on-watch, no network), but is real permission line, not "zero permissions" listing claim.
- **`getComplication(id)` throws `ComplicationNotFoundException` if complication itself unsupported/unavailable on that device** — confirmed on same Core Topics page (try/catch example = documented pattern, not optional defensive extra). Separately, many field *values* documented "or null" even when complication found (no data yet, e.g. new device with no activity history). Data-access wrapper must handle both: catch exception per field, then null-check value.
- **Store-collision check, both names:** searched `apps.garmin.com`'s own search for "DayArc" (985 fuzzy results) and "DayArc Pro" (996 fuzzy results), sorted by relevance — no exact title match for either in top results for either query. Closest neighbors: SkyArc, ArcMetrics, ArcNext, DaysTo, DayBreakr — none collision.
- **General web/trademark scan:** no software product or app named "DayArc" found. One unrelated company, "Day Arc Environmental Systems" (two words, indoor cannabis-cultivation HVAC systems) — different industry, different trademark class, low collision risk, noted for record.
- **These are not substitute for real USPTO/legal trademark search** — stays open. Checked = store-collision and obvious-conflict risk, what was actually blocking naming decision at this stage.
- **VO2max, training status, pulse ox, recovery time, weekly run/bike distance have no documented device-support or null-condition notes in SDK reference** — confirmed by direct check. Not good news: no doc-level shortcut, only real hardware settles which populated on which device, same as any other "simulator passing is not device proof" case. Stays device gate, not resolved by this pass.

## Gates still open — device-only, can't be resolved from here

- Real 4.2+ hardware: confirm `Complications.getComplication()` returns non-null for every field this plan uses, per device in target set. Simulator known to not reliably model real per-device sensor/data absence for this API family — simulator-only pass would not be device proof here.
- Confirm `CALENDAR_EVENTS` actually populates on device with Garmin Connect Mobile calendar sync enabled, confirm `null` empty state (no sync enabled, or no upcoming event) reads as plain sentence, not blank.
- Confirm UV and pulse ox hide cleanly below their respective floors/device support.
- Device screenshot check that "current UV" wording can't be misread as forecast claim.
- Define empty state for VO2max/training-status/weekly-distance on wearer with no logged activity history — needed regardless of which devices support sensor, since even supporting device returns `null` until wearer has logged enough activity.
- Real USPTO/legal trademark search for both names, if owner wants that clearance level before publishing (store-collision risk now checked; registered-trademark risk not).

## Implementation plan

1. Trademark/collision search — "DayArc" and "DayArc Pro."
2. Scaffold 6th project from `watch-design-kit/templates/watch-app/` — device tier = TwoSuns ADR-009's set; structure as one codebase, two build targets from start, not retrofit later.
3. Draft `spec.md` + `docs/decisions.md` with 9 ADRs above.
4. `DESIGN.md` via `watch-design-lead` — Simple's 3 layouts, Pro's 3 denser layouts (hold layout hierarchy even at 8-12+ fields), shared idle/low-power template both, empty-state copy per field (including "no activity history yet" for VO2max/training-status/weekly-distance).
5. Build against simulator: both variants, Complications subscriptions per field lists above.
6. Simulator compile sweep across full 69-product device set, both build targets.
7. Device probes — gates above, real hardware, both variants. Simulator passing is not device proof.
8. Listing drafts (`listing/paste.md` + `NOTES.md`) both, once wording ADRs locked. Pro's listing states plainly fixed $1.99, no free tier.
9. Submit both. No flip-to-free clock either listing — Simple launches free, stays free; Pro launches paid, stays paid.