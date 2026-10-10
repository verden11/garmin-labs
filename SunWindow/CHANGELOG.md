# Sun Window changelog

One entry per Connect IQ Store publication, newest first. The store's "What's New" text for each version is in
[`listing/paste.md`](listing/paste.md).

**There has been no store publication.** Nothing is uploaded.

## Unreleased / 1.0.0 in preparation

Built 2026-10-10 from the approved mockup (ADR-011). Evidence: **simulator only**, plus the FR965 spike of 2026-10-05 on a
throwaway probe (not this build). Nothing of this build has been on a wrist.

Built:

- A widget with a glance (manifest type `widget`, ADR-008) for 65 API 5.1+ products (66 minus the Instinct Crossover AMOLED,
  whose hands cover the screen's middle): OPEN, CLOSED or NONE TODAY for the sun at or above 45 degrees, today's open and close
  times, the sun's path over the 45-degree line, one reason line ("Opens 10:26", "Closed for today", "Cloud cover", "Sun stays low",
  "No weather"), and the empty states "Open once", "Finding your place", "No place yet".
- The state is computed at every draw from the clock, the stored place (rounded to 0.1 degree, `Positioning`) and the watch's own
  UV index (UV under 3 shows an open window as closed); the glance and the app use the same rule.
- One setting, accent colour (six ids), from Garmin Connect and from the app's menu; hidden on the 1-bit Instinct.
- 31 unit tests (28 on the 1-bit Instinct), including the sun maths against the research fixtures (window edges within 1 minute,
  elevation within 0.02 degrees; JPL Horizons agrees with the fixtures to 0.0061 degrees); all pass on fr965, fr255s, fenix7s,
  venu3, venux1, instincte40mm and instincte45mm in the simulator. Compile sweep of all 65 products: 65 pass, 0 fail.
- Glance memory (release build): 2203 B data + 4858 to 4903 B code (about 7.1 KB) on the FR965 and the Instinct E (32 KB limit).

Not done, and not to be claimed:

- Wear day of this build (D2 daytime, D7 midnight, D9 window edges, D11 menu gesture): none run. Spike results on the probe:
  `docs/status.md`.
- Launcher icon, cover, hero, device icons and framed store screens: placeholders or not made; the owner approves them.
- Site pages, trademark check, upload (ROADMAP 18.x).
- MIP and Instinct looks: simulator only. The widget-type behaviour on a watch (listed in the app list or not, W1).
