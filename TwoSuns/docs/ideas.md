# Feature ideas

Status: 2026-09-27. Candidate features for after v1 ships — not open items, not scheduled. [`plan.md`](plan.md) phase 9 (device evidence) and submission come first; nothing here is built. A durable decision made from one of these gets an ADR in [`decisions.md`](decisions.md) and moves into `plan.md`'s Tier B / phase 10 backlog; this entry then says so.

---

## 1. Time-of-day labels on the energy curve

**What.** Rough tick labels under the 96-bucket energy curve band — e.g. `12p`, `3p`, `6p` — so the curve reads against the day instead of as a bare shape next to the clock.

**Why.** The curve already answers "how much energy is left"; a glance can't currently tell *when* today's low point was, or how far the current dot is from midnight. A handful of hour marks turns the same drawing into a timeline, for the cost of a few short strings.

**Cost.** Small. `TwoSunsCurve` already knows the bucket width (15 min, 96 buckets/24h) and the band's x-range; a label is `TwoSunsDraw`-measured text at 3-5 fixed bucket indices (e.g. every 6 hours, or every 3 on the widest screens). No new Storage key, permission or Complication.

**Risks.**
- **Budget, not headroom.** The curve band's vertical space is already tight (`plan.md` phase 4's bright-sun contrast note: "the curve's lower level must be ≥ 3:1 against black"); a label row competes with that, and with the always-on frame's drift positions (ADR-007) if it must render there too. Likely needs its own thin row below the band, not text overlaid on it.
- **Small screens.** 218 px MIP (`fr255s`) is the tightest fit-tested size; 3 labels (12a/12p/current-hour-ish) may be the ceiling there where 454 px AMOLED could fit 5-6. Needs the same per-size screen-fit sweep as everything else (`tools/fit_all.sh`), not a guess.
- **Not evidence yet.** The whole curve, labelled or not, has never been seen on a wrist or approved by eye (`plan.md` phase 4 gate, still open). Adding labels before that approval risks a second round of layout rework instead of one.
- **Locale-safe by construction if done right:** use the watch's existing 12h/24h `DeviceSettings` format (already read elsewhere in the app) rather than a new string, so no new translation burden across the 15 shipped languages.

**Not built.** Owner's idea, logged 2026-09-27, before phase 4's look was approved and before phase 9's device evidence.
