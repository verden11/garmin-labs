# Days To Go changelog

One entry per Connect IQ Store publication, newest first. The store's "What's New"
text for each version is in [`listing/paste.md`](listing/paste.md).

## 1.0.1 — submitted 2026-09-26 on top of 1.0.0 (the app was approved 2026-09-28, late afternoon, per the owner; which version Garmin approved is not recorded)

- A name or caption too long for a small screen now ends in "..." (the marker was being dropped). Found by the cloud code review; fixed with a test (43 tests).
- No other behaviour change. ADRs: none new.
- Evidence: simulator only. 43 tests on the ten screen-size devices; fenix6pro, venu2s, venusq2, venusq2m and venux1 re-run after the fix (43 of 43 each). Package `dist/DaysToGo.iq` (SHA-256 9f1b946d…3b21), same app id as 1.0.0.

## 1.0.0 — submitted 2026-09-26, superseded by 1.0.1 in the same review (not yet confirmed)

- First release: 120 products (117 round, 3 rectangular AMOLED), Connect IQ 3.0+, one big day count, list settings plus an on-watch date picker, weeks and hours, event name, date style, optional battery or steps line, always-on frame, 15 languages (14 machine-drafted, not read by native speakers).
- Paid, lowest tier (USD 2.00, $1.99 US). Price review due approval + 45 days (`docs/spec.md` "Price review").
- ADRs 001 to 013. Submitted **without** the beta round trip (owner's decision, `docs/status.md`).
- Evidence: simulator only (42 tests on 14 products; 15 languages on the FR965's smallest screen size, fr55); on the FR965, sideloaded: the default count, the on-watch date picker and a restart. Not tested on a device: the phone date route, always-on, midnight, battery.

## Unreleased

Everything below is **UNRELEASED**: built 2026-10-01 against the Free + Pro plan, **proposed** (`docs/decisions.md` ADR-014 (Free + Pro ladder), owner has not signed off), simulator-only evidence, nothing uploaded. The headings are the versions the owner would upload; dates and uploads are theirs.

### Days To Go (Free) 1.0.0 — UNRELEASED, a new app (new app id), not uploaded

- First release of the Free twin: the same 120 products, 15 languages, no permissions. The big day count, the ring, the time, the event name and date lines, always-on, the on-watch "Set date" picker.
- Settings: Event, Name, Month, Day, Year, Count in (days or weeks and days), Date style, Accent colour (the six shipped colours: mint, amber, sky, pink, violet, white).
- Not in Free (Pro only): timed events (the last 24 hours as H:MM) and the battery or steps line.
- **Instinct family, added 2026-10-03 (127 products instead of 120; ADR-015, proposed, simulator only):** `instinct2`, `instinct2s`, `instinct2x`, `descentg1`, `instincte40mm`, `instincte45mm`, `instinct3solar45mm`. Black and white; the ring becomes a gauge in the round window; no Accent setting on these watches (owner's choice) and no footer. The visible area on an Instinct is a circle about 98 px in radius, which the layout and the fit test now model. Evidence: `docs/compatibility.md` "Instinct family".
- App id `9fde2744-b0f4-4396-927d-e4c7d65bb119` (generated 2026-10-01). Store name and title are the owner's decision (placeholder "Days To Go").
- ADRs: 014 (Free + Pro ladder, proposed), 015 (Instinct family, proposed).
- Evidence: compiled for both jungles on fr965, fr55, venusq2, venux1 and swept across every manifest product (`tools/compile_sweep.sh`); the Free package's contents checked (`tools/check_free_package.sh`: no Hour or Footer setting, no "Pro" anywhere). Simulator, 2026-10-01: the 51 Free tests PASSED on fr965, fr55 and venusq2, and the screen-fit run (`tools/fit_all.sh`: fr55, fenix5s, fenix5, vivoactive4, fenix7x, fr265s, fr165, epix2, fr965, fenix9pro51mm) passes on Free. Free memory was not measured separately. Nothing has run on a wrist.

### Days To Go Pro 1.1.0 — UNRELEASED, an update of the existing paid app id, not uploaded

- The paid app is renamed on the watch to "Days To Go Pro" (placeholder name; the owner decides it and the price). Behaviour, settings, ids and defaults are the same as 1.0.1: `resources-pro/settings` is byte-identical to the old shared settings.
- **Instinct family, added 2026-10-03** (127 products; ADR-015, proposed, simulator only), as in the Free entry above; Pro on an Instinct has no footer (battery or steps) and no Accent setting.
- No new feature. The plan's other Pro additions (accent ids 6 to 11, a new layout choice) are **deferred**, not built; the Pro headline question is open (Pro is thin: timed events and the battery or steps line).
- Build change: Pro is now `monkey.jungle` with `resources;resources-pro` and `(:free)` code excluded; `beta.jungle` follows it.
- ADRs: 014 (Free + Pro ladder, proposed). ADR-002 (price, day-45 review) still governs until the owner signs off.
- Evidence: as above. The 50 Pro tests (the 43 existing, one of them now Pro-only, plus 7 new) PASSED in the simulator on fr965, fr55 and venusq2 and the same ten-device fit run passes (2026-10-01); nothing on a wrist.
