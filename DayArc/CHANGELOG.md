# DayArc / DayArc Pro changelog

One entry per Connect IQ Store publication, newest first, either listing (noted per entry). The
store's "What's New" text for each version is in that listing's `listing/paste.md` or
`listing-pro/paste.md`.

## Unreleased

- **Always-on time in the studio's one always-on grey, `#5C5C5C`, both listings (ADR-020, 2026-10-08, AMOLED watches only,
  simulator only):** the dim always-on time was the awake grey `#AAAAAA`; it is now the dimmer `#5C5C5C` the other faces use
  (3.14:1 against black, about a quarter of the light). MIP watches and the Instinct are unchanged.
- **Square design on the rectangular watches (Venu Sq 2, Venu Sq 2 Music, Venu X1), both listings (ADR-019, 2026-10-05,
  simulator only, awaiting the owner's look at the screenshots):** the window-progress arc follows the screen as the top of a
  rounded-rectangle track, the Stress and Body Battery gauge is a straight bar, and the time, date and readings use the room
  inside the track. On the Venu Sq 2, DayArc Pro's morning now shows "Feels like" and a row of fields together. Round watches
  and the Instinct are unchanged.
- **Every watch, both listings (2026-10-06, simulator only):** a morning without weather shows the clock, the date and
  "Weather unavailable" (DayArc Pro shows its fields under it) instead of a lone "--" with nothing beside it; the morning line is planned without a UV reading on
  watches that cannot report one (below API 5.1), which gives those watches' mornings more room.

## 1.0.0, both listings: uploaded and approved by Garmin 2026-10-05 (first publication)

- DayArc (free): https://apps.garmin.com/apps/9e641dce-3838-4613-a129-55faeb761193
- DayArc Pro (paid, the $2.50 tier): https://apps.garmin.com/apps/b6373747-2569-4a55-86ca-c42914c571fe
- Packages `dist/DayArc-1.0.0.iq` and `dist/DayArcPro-1.0.0.iq`, 72 products (93 part numbers) each, exported 2026-10-05 evening
  from the final code below. Evidence: simulator (the QA pass, `../reports/QA/Simulator QA 2026-10-05.md`) and the owner's
  FR965 photos of the morning, midday and evening windows (the night window and the final build not yet on a wrist).

What went into 1.0.0:

- **2026-10-05, owner's picks on the photos (ROADMAP 13.28, 13.29):** the morning reads "Feels like" above the temperature;
  its icon is the current condition (clear, partly cloudy, cloudy, rain, snow), none when there is no weather.
- **2026-10-05, from the owner's FR965 photos (simulator-tested):** in 12-hour mode the hour has no leading zero (`1:02`, sunset `6:54`; it read `01:02` and `06:54`, the wrong half of the day); an empty calendar reads "None" (was cut to "No up...").
- **2026-10-05, design critique (owner: "do your picks"; ROADMAP 13.19, 13.20; simulator only):** the evening hero icon is a
  bolt (the battery shell read as a second battery beside Pro's watch-battery pill); Pro's grid icons are all muted grey (the
  per-type rainbow competed with the hero), and intensity is a pulse line. ADR-013 amendment. Both listing sets recaptured.

Built 2026-09-28 in three passes the same day: an initial plain-text/single-accent build, ADR-013's
icon/colour redesign, then a layout rework and an accent-colour setting after the owner's first
on-wrist photo (ADR-013 amendment, ADR-014). Evidence: simulator-only — compile sweep (both
densities, all 69 products, `docs/compatibility.md`); render/test exercised per device on 4
representative devices (fr965, approachs50, venusq2, venux1), both densities. The only real-device
evidence is that one photo; the fixes and the setting have not been re-checked on a wrist.

Added 2026-10-03: **Instinct E 40/45 mm and Instinct 3 Solar 45 mm** (72 products instead of 69; ADR-015, accepted 2026-10-04, simulator only): black and white, the window-progress arc becomes a gauge in the round window, no Accent setting (so no "Customize" on these watches), no corner pills. The visible area on an Instinct is a circle about 98 px in radius, which the layout and the tests now model. The Instinct 2 family is not included (no Complications at CIQ 3.4). Evidence: `docs/compatibility.md` "Instinct E and Instinct 3 Solar".

Changed 2026-10-04 (ADR-017, simulator only): the hero icon is sized to the screen and to the number beside it (two sizes per screen size, 42 px / 24 px on a 218 px watch up to 90 px / 66 px on a 454 px one) with a stroke about 0.12 of its height; the weather glyph is redrawn (an outlined cloud in front of a sun with rays instead of one fused shape); Pro keeps the hero label (the Instinct draws one row of fields with the label instead of two rows without it, and on the 3 Solar the morning and midday are the same as Simple). Earlier the same day (ADR-016): fields are shown whole or not at all, recovery reads in hours, half-size hero icons on the Instinct.

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
- Every window's stack planned as a whole against the real display (`DayArcStack`): vertically
  centred, fonts stepped down only as needed, a long sub line wrapped to two lines instead of cut
  to a stub, the clock and other rows kept clear of the progress arc; the three rectangular
  products use full-width rows (ADR-001 amendment, ADR-013 amendment).
- One setting, both listings: **Accent colour** (Auto default, or cyan/amber/rose/green/blue/purple),
  in the Garmin Connect app and the watch's own Customize list; applies without a restart
  (ADR-014, partly reversing ADR-011). Density stays a separate listing.

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
  — flagged in `docs/status.md` gate 17.
