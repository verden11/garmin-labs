# DayArc / DayArc Pro changelog

One entry per Connect IQ Store publication, newest first, either listing (noted per entry). The
store's "What's New" text for each version is in that listing's `listing/README.md` or
`listing-pro/README.md`.

**There has been no store publication.** Nothing is submitted, no version number is confirmed.

## Unreleased / 1.0.0 in preparation (both listings)

Built 2026-09-28, twice: an initial plain-text/single-accent build, then ADR-013's icon/colour
redesign on top of it the same day. Evidence for both: simulator-only — compile sweep (both
densities, all 69 products, `docs/compatibility.md`); render/test exercised on 4 representative
devices (fr965, approachs50, venusq2, venux1), both densities. Nothing has run on a wrist.

Built:

- Four time windows (morning/midday/evening/night), fixed clock, shared by both listings.
- Simple: one focal read per window (feels-like weather / stress / Body Battery / time+date), each
  beside a single-hue hero icon tied to that window's own accent colour (ADR-013).
- Pro: the same hero reads plus a per-device-measured secondary field grid (up to ~8-12 fields),
  each grid field carrying its own permanently-coloured icon, 9 of 17 fields icon-only with no text
  label (ADR-013).
- A per-window accent colour (morning amber, midday cyan, evening rose; night hueless) and a thin
  window-progress arc across the top of the circle showing progress through the current window
  (morning/midday/evening only) (ADR-013).
- The date, shown in every window's header now, not just night's (ADR-013).
- All 17 icons sourced from real Tabler Icons (MIT licence) paths, recoloured, drawn as small
  pre-coloured bitmap resources — no runtime tinting, no icon font (`resources/drawables/icons/`,
  `resources-pro/drawables/icons/`, licence notice alongside).
- `Complications`-based data layer, `ComplicationSubscriber` permission only, no location, no
  network.
- No-verdict wording and single-hue gauges for stress and Body Battery (no colour/mood judgement);
  the same principle extended to the 14 grid icons — colour is fixed per icon type, never per value
  (ADR-013 extends ADR-006).
- AMOLED always-on dim/drift idle frame (TwoSuns's proven burn-in pattern, reused); the idle frame
  deliberately does not gain the new date line, to keep the fewest lit pixels.
- No settings surface, either listing.

Not done, and not to be claimed:

- No real device evidence — everything above is simulator-only.
- No screenshot of the actual build exists at all yet — this dev environment has no attached
  display (`screencapture` fails outright), not just an unconfirmed owner review.
- Real launcher icons, covers, hero images, screenshots — placeholders only.
- Owner has not yet seen the face render.
- Night window content (ADR-010) and the stress gauge's dim-above-threshold direction (ADR-006) are
  first-pass defaults, not yet confirmed by the owner or a design review.
- Full 69-product render/fit sweep (only compiled, not rendered, for products outside the 4 spot-
  checked above).
- Icon size (fixed pixels, not scaled per device) and the arc's clearance from the clock are
  arithmetically derived and internally consistent, but not yet visually confirmed on a real render
  — flagged in `docs/publish-checklist.md` gate 17.
