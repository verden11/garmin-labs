# Days To Go changelog

One entry per Connect IQ Store publication, newest first. The store's "What's New"
text for each version is in [`listing/paste.md`](listing/paste.md).

## Unreleased (next upload of both)

- **The ring has one scale (owner, 2026-10-05, ROADMAP 13.1; simulator only).** It stops at 95% until the day itself, so a full ring means only the day (it was full at exactly 365 days). In Pro, a timed event's last 24 hours stay on the days' square-root scale (5% at 24 hours, a sliver at the end) instead of restarting near full. Pro listing shots 1, 3, 4, 5 and the hero were recaptured. Tests: Pro 67, Free 56 (`hoursRingContinuesTheDays` new).

## Free 1.0.0 and Pro 1.1.0 — uploaded 2026-10-04 by the owner, in Garmin review

Built 2026-10-01 against the Free + Pro plan; the owner approved the ladder 2026-10-04 (`docs/decisions.md` ADR-014 (Free + Pro ladder), Active) and uploaded both that day. Simulator-only evidence. Approval dates are recorded here when Garmin reports them.

### Days To Go (Free) 1.0.0 — uploaded 2026-10-04 by the owner, in review (a new app; developer page https://apps-developer.garmin.com/apps/2142b1e6-b56c-4fad-a9db-10a8e21790f9; the public store URL works once Garmin approves)

- First release of the Free twin: the same 120 products, 15 languages, no permissions. The big day count, the ring, the time, the event name and date lines, always-on, the on-watch "Set date" picker.
- Settings: Event, Name, Month, Day, Year, Count in (days or weeks and days), Date style, Accent colour (the six shipped colours: mint, amber, sky, pink, violet, white).
- Not in Free (Pro only): timed events (the last 24 hours as H:MM) and the battery or steps line.
- **Instinct family, added 2026-10-03 (127 products instead of 120; ADR-015, accepted 2026-10-04, simulator only):** `instinct2`, `instinct2s`, `instinct2x`, `descentg1`, `instincte40mm`, `instincte45mm`, `instinct3solar45mm`. Black and white; the ring becomes a gauge in the round window; no Accent setting on these watches (owner's choice) and no footer. The visible area on an Instinct is a circle about 98 px in radius, which the layout and the fit test now model. Evidence: `docs/compatibility.md` "Instinct family".
- Rectangles (Venu Sq 2 and Sq 2 Music): a long stack (a named event, the date, the unit) now keeps the name and the largest count; before, the name was dropped. The date may use its shorter wording there, and Pro's bottom line can still be dropped (ADR-016, amended 2026-10-04). The Instinct 2 and 3 Solar still cut a 12-character name with "..." (documented, `docs/compatibility.md`).
- Launcher icon redrawn on the pixel grid (whole-number vertices; same look, crisper edges; no What's New line needed).
- On-watch "Set date" picker (2026-10-04, ADR-005 amended; simulator only): the month column shows the watch's short month word and the label font steps down on small screens, so nothing is cut on an Instinct (it was: "Octobe", "ery ye"); "Every year" wraps to two lines; the picker clears to black first (not confirmable in the simulator on a colour MIP watch).
- App id `9fde2744-b0f4-4396-927d-e4c7d65bb119` (generated 2026-10-01). Store name "Days To Go", title "Days To Go: Countdown to a Date" (confirmed 2026-10-04).
- ADRs: 014 (Free + Pro ladder), 015 (Instinct family); both accepted 2026-10-04.
- Evidence: compiled for both jungles on fr965, fr55, venusq2, venux1 and swept across every manifest product (`tools/compile_sweep.sh`); the Free package's contents checked (`tools/check_free_package.sh`: no Hour or Footer setting, no "Pro" anywhere). Simulator, 2026-10-01: the 51 Free tests PASSED on fr965, fr55 and venusq2, and the screen-fit run (`tools/fit_all.sh`: fr55, fenix5s, fenix5, vivoactive4, fenix7x, fr265s, fr165, epix2, fr965, fenix9pro51mm) passes on Free. Free memory was not measured separately. Nothing has run on a wrist.

### Days To Go Pro 1.1.0 — uploaded 2026-10-04 by the owner, in review (an update of the existing paid app id; headline "To the minute", ADR-018)

- The paid app is renamed on the watch to "Days To Go Pro" (confirmed name; the owner sets the tier in the upload form). Apart from "To the minute" below, behaviour, settings, ids and defaults are the same as 1.0.1: the settings of 1.0.1 are unchanged and keep their ids; two settings are appended.
- **Instinct family, added 2026-10-03** (127 products; ADR-015, accepted 2026-10-04, simulator only), as in the Free entry above; Pro on an Instinct has no footer (battery or steps) and no Accent setting.
- Rectangles (Venu Sq 2 and Sq 2 Music): as in the Free entry above (a named event keeps its name; the bottom line can still be dropped there).
- On-watch "Set date" picker: as in the Free entry above (short month words, smaller label font on small screens, "Every year" on two lines).
- **To the minute (Pro's headline, owner's pick 2026-10-04, ADR-018; simulator only):** two new phone settings next to Time of day. **Minute** (00 to 59) and **Event time zone** (My watch time zone, the default, or one of 40 UTC offsets from UTC-12:00 to UTC+14:00). With them the last 24 hours count down to the minute an event starts, in the zone it starts in (the hero `H:MM` and the word HOURS, as before), and TODAY arrives at that moment. **The day count does not change**: it is still whole days on the watch's own calendar and flips at the watch's local midnight, whatever the zone (ADR-004 amended: the zone moves only when HOURS starts and when TODAY arrives). **There is no time-zone database on a watch: the wearer picks the offset the event's place is on at the event's date; nothing is done about daylight saving.** An all-day event ignores both. New settings ids, appended: `Minute`, `EventZone`; 3 new phone strings in 15 languages (14 machine-drafted, not read by native speakers; kept in Pro-only resource folders). Free is unchanged (same settings, strings and behaviour; its package carries only extra, unused arithmetic).
- The plan's other Pro additions (accent ids 6 to 11, a new layout choice) are **deferred**, not built.
- Launcher icon redrawn on the pixel grid (whole-number vertices; same look, crisper edges; no What's New line needed).
- Build change: Pro is now `monkey.jungle` with `resources;resources-pro` and `(:free)` code excluded; `beta.jungle` follows it.
- ADRs: 014 (Free + Pro ladder, accepted 2026-10-04), 018 (to the minute: Minute and Event time zone; amends 004, calendar-day arithmetic). ADR-002 (price, day-45 review) is Superseded: the flip rule is retired. 017 (price: the $2.50 tier for every paid app, accepted 2026-10-04): Pro moves to the $2.50 tier with the 1.1.0 upload; no price number in listing text.
- Evidence for the headline (container simulator, 2026-10-04, **not a wrist**): the suite is Pro 66 (64 on an Instinct) and Free 55 (53 on an Instinct) with the 14 new zone tests (travel day east and west of the watch, DST-boundary day with an explicit offset, midnight edge, event already passed, minute rollover, +14 and -12 and the widest 26 h shift, the default zone, bad values); see `docs/status.md` for the devices and the memory on the 96 KB watches. Open wrist checks: travel day, a DST day, and that the phone-set Minute and zone survive reopening the settings (`docs/status.md`).
- Evidence (earlier): the 50 Pro tests (the 43 existing, one of them now Pro-only, plus 7 new) PASSED in the simulator on fr965, fr55 and venusq2 and the same ten-device fit run passes (2026-10-01); nothing on a wrist.

## 1.0.1 — submitted 2026-09-26 on top of 1.0.0 (the app was approved 2026-09-28, late afternoon, per the owner; which version Garmin approved is not recorded)

- A name or caption too long for a small screen now ends in "..." (the marker was being dropped). Found by the cloud code review; fixed with a test (43 tests).
- No other behaviour change. ADRs: none new.
- Evidence: simulator only. 43 tests on the ten screen-size devices; fenix6pro, venu2s, venusq2, venusq2m and venux1 re-run after the fix (43 of 43 each). Package `dist/DaysToGo.iq` (SHA-256 9f1b946d…3b21), same app id as 1.0.0.

## 1.0.0 — submitted 2026-09-26, superseded by 1.0.1 in the same review (not yet confirmed)

- First release: 120 products (117 round, 3 rectangular AMOLED), Connect IQ 3.0+, one big day count, list settings plus an on-watch date picker, weeks and hours, event name, date style, optional battery or steps line, always-on frame, 15 languages (14 machine-drafted, not read by native speakers).
- Paid, lowest tier (USD 2.00, $1.99 US). (A day-45 price review was planned here; retired 2026-10-04, ADR-014.)
- ADRs 001 to 013. Submitted **without** the beta round trip (owner's decision, `docs/status.md`).
- Evidence: simulator only (42 tests on 14 products; 15 languages on the FR965's smallest screen size, fr55); on the FR965, sideloaded: the default count, the on-watch date picker and a restart. Not tested on a device: the phone date route, always-on, midnight, battery.

