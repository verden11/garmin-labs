# Days To Go changelog

One entry per Connect IQ Store publication, newest first. The store's "What's New"
text for each version is in [`listing/README.md`](listing/README.md).

## 1.0.1 — submitted 2026-09-26 on top of 1.0.0, pending review

- A name or caption too long for a small screen now ends in "..." (the marker was being dropped). Found by the cloud code review; fixed with a test (43 tests).
- No other behaviour change. ADRs: none new.
- Evidence: simulator only. 43 tests on the ten screen-size devices; fenix6pro, venu2s, venusq2, venusq2m and venux1 re-run after the fix (43 of 43 each). Package `dist/DaysToGo.iq` (SHA-256 9f1b946d…3b21), same app id as 1.0.0.

## 1.0.0 — submitted 2026-09-26, superseded by 1.0.1 in the same review (not yet confirmed)

- First release: 120 products (117 round, 3 rectangular AMOLED), Connect IQ 3.0+, one big day count, list settings plus an on-watch date picker, weeks and hours, event name, date style, optional battery or steps line, always-on frame, 15 languages (14 machine-drafted, not read by native speakers).
- Paid, lowest tier (USD 2.00, $1.99 US). Price review due approval + 45 days (`docs/spec.md` "Price review").
- ADRs 001 to 013. Submitted **without** the beta round trip (owner's decision, `docs/publish-checklist.md`).
- Evidence: simulator only (42 tests on 14 products; 15 languages on the FR965's smallest screen size, fr55); on the FR965, sideloaded: the default count, the on-watch date picker and a restart. Not tested on a device: the phone date route, always-on, midnight, battery.

## Unreleased

- Nothing yet.
