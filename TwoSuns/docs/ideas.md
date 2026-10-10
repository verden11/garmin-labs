# Feature ideas

Status: 2026-09-27. Candidate features for after v1 ships — not open items, not scheduled. [`archive/plan.md`](archive/plan.md) phase 9 (device evidence) and submission come first; nothing here is built. Durable decision from one of these gets ADR in [`decisions.md`](decisions.md), moves into `plan.md`'s Tier B / phase 10 backlog; this entry then says so.

---

## 1. Time-of-day labels on the energy curve

**What.** Rough tick labels under 96-bucket energy curve band — e.g. `12p`, `3p`, `6p` — curve reads against day, not bare shape next to clock.

**Why.** Curve already answers "how much energy is left"; glance can't tell *when* today's low point was, or how far current dot is from midnight. Few hour marks turn same drawing into timeline, for cost of few short strings.

**Cost.** Small. `TwoSunsCurve` already knows bucket width (15 min, 96 buckets/24h) and band's x-range; label = `TwoSunsDraw`-measured text at 3-5 fixed bucket indices (e.g. every 6 hours, or every 3 on widest screens). No new Storage key, permission or Complication.

**Risks.**
- **Budget, not headroom.** Curve band vertical space already tight (`plan.md` phase 4's bright-sun contrast note: "the curve's lower level must be ≥ 3:1 against black"); label row competes with that, and with always-on frame's drift positions (ADR-007 (always-on drift)) if must render there too. Likely needs own thin row below band, not text overlaid on it.

  *Note: ADR-007 gloss "always-on drift" inferred from context; source gave bare number.*
- **Small screens.** 218 px MIP (`fr255s`) tightest fit-tested size; 3 labels (12a/12p/current-hour-ish) may be ceiling there where 454 px AMOLED could fit 5-6. Needs same per-size screen-fit sweep as everything else (`tools/fit_all.sh`), not guess.
- **Not evidence yet.** Whole curve, labelled or not, never seen on wrist or approved by eye (`plan.md` phase 4 gate, still open). Adding labels before that approval risks second round of layout rework instead of one.
- **Locale-safe by construction if done right:** use watch's existing 12h/24h `DeviceSettings` format (already read elsewhere in app) rather than new string, so no new translation burden across 15 shipped languages.

**Not built.** Owner's idea, logged 2026-09-27, before phase 4's look approved and before phase 9's device evidence.