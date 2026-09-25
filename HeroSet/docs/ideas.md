# Feature ideas

Status: 2026-09-26. Candidate features, ranked by value per unit of cost.

**Not open items.** Nothing here is committed, scheduled or blocking; [`go-to-market.md`](go-to-market.md) stays the only home for open items. 1.2.0 is Connect sync ([ADR-043](decisions.md#adr-043)); these come after it. Anything that graduates gets an ADR in [`decisions.md`](decisions.md) and moves to the go-to-market backlog; the entry here then says so.

Every idea is checked against [`release-contract.md`](release-contract.md) (forbidden claims), [ADR-029](decisions.md#adr-029) (no long-press gestures), [ADR-044](decisions.md#adr-044) (the complication field order HeroFace depends on) and the store build's `Sensor`-only permission ([ADR-033](decisions.md#adr-033)). Where one of those is the real cost, the entry says it.

---

## 1. Glance view

**What.** The Connect IQ glance for HeroSet: today's three mission bars and the streak, no app launch. Scrolling past it answers "am I done today?".

**Why first.** The app's whole loop is a daily check, and today that costs a full app launch for a question three bars answer. A glance is the difference between a habit app you open and one you pass twenty times a day. It pairs with HeroFace: the face covers the watch-face slot, the glance the widget carousel.

**Cost.** Small. `AppBase.getGlanceView()` plus a `(:glance)` view drawing a cut-down `HeroSetMissionBars`, reading the store like the dashboard. No new permission, storage key or contract change.

**Risks.** Glance support is per-device, not universal across the 80 products: sweep it into [`compatibility.md`](compatibility.md) before claiming it. Glances have a tighter memory budget, so the layout is a rewrite at glance size. They run on the system's schedule, so they must not assume `ensureCurrentDay` ran recently.

---

## 2. Faster manual entry

**What.** A way to log a set of 40 without 40 button presses, without a long-press.

**Why.** [`input-and-ux.md`](input-and-ux.md) states the hole: "big manual entry take one press per rep." Manual logging is the whole experience for anyone whose watch hand isn't on the floor, and the delta picker punishes the user who trusts the app least.

**Shape.** [ADR-029](decisions.md#adr-029) rules out hold-to-accelerate, so the step has to change another way, cheapest first: START cycles the step (1 → 5 → 10 → 1) and the save binding moves to the Back menu · the Back menu gains `+10` / `+25` · a second picker row for tens.

**Cost / risk.** Small, but it spends a button binding, and the navigation contract plus a screen-fit re-check come with it. The picker is also the learning path ([ADR-040](decisions.md#adr-040)): a bigger step is a bigger typo, and a typo teaches the detector the wrong threshold. Keep single-rep precision reachable.

---

## 3. Rest timer between sets

**What.** After a save, an optional countdown (45/60/90 s) that buzzes for the next set, with today's remaining reps on screen.

**Why.** 100 reps is 4–6 sets and the gap between them is what the app ignores. A timer turns separate launches into one session and raises reps per launch.

**Cost.** Small-to-medium: `Timer.Timer`, `HeroSetHaptics` and the `HeroSetDayTracker` pattern exist; new screen, strings and screen-fit rows across all products.

**Risks.** A lit screen between sets is the first real battery cost in this app: measure it per [`battery.md`](battery.md) before shipping. Needs a deliberate answer for the user walking away mid-countdown.

---

## 4. Goal-not-met nudge

**What.** A background check late in the day that notifies when the daily mission is still open.

**Why.** Streaks break by forgetting, not by quitting. The highest-leverage retention feature here, and the only one that acts when the app is closed.

**Cost.** High, mostly not code. A background temporal event needs the `Background` permission, which changes the listing's permission line, the privacy page in `../../verden-site/src/apps/heroset/` and [`release-contract.md`](release-contract.md)'s permission row, all in the same session. Background processes get a small memory budget and a minimum interval.

**Risks.** A nagging fitness app gets deleted: default off, switchable on the watch. Adding a permission is its own review cycle, so 1.3 at the earliest.

---

## 5. A fourth exercise

**What.** Pull-ups, lunges, dips or plank alongside the three. Likely the most requested feature, and the clearest ceiling on who the app is for.

**Cost.** The highest here, and not the counting. The three exercises are load-bearing:
- `HeroSetRules.EXERCISES`, the storage keys and the XP ratchet are per-exercise, but the daily cap and rank curve assume three ([ADR-002](decisions.md#adr-002)/[045](decisions.md#adr-045): 3 × 100 × 2 = 600 XP a day). A fourth changes the rank curve's meaning.
- The complication has a fixed field order HeroFace reads ([ADR-044](decisions.md#adr-044)). Fields append, so a fourth count can be added, but the dashboard, mission bars, menu and goal picker assume three rows on a round chord that may not fit four at 218 px.
- Plank is held time, not reps: a different mechanic in the detector, picker and XP rule.

**If ever done:** reps-based only, the XP cap a per-day total rather than per-exercise, and the ADR before the code.

---

## Considered and rejected

- **Day history (last 30 days).** Proposed and rejected by the owner 2026-09-21. Don't re-propose without new reasoning.
