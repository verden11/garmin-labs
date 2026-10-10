# Feature ideas

Status: 2026-09-26. Candidate features, ranked by value per unit of cost.

**Not open items.** Nothing here committed, scheduled, blocking; [`status.md`](status.md) not home for open items either: root ROADMAP.md is. Connect sync (1.3.0) shelved, [ADR-054](decisions.md#adr-054); nothing here depends on it shipping. Anything graduating gets ADR in [`decisions.md`](decisions.md), moves to go-to-market backlog; entry here then says so.

Every idea checked against [`release-contract.md`](release-contract.md) (forbidden claims), [ADR-029](decisions.md#adr-029) (no long-press gestures), [ADR-044](decisions.md#adr-044) (complication field order HeroFace depends on), store build's `Sensor` + `ComplicationPublisher` permissions ([ADR-033](decisions.md#adr-033)). Where one of those is real cost, entry says so.

---

## 1. Glance view. **Graduated: [ADR-051](decisions.md#adr-051), shipped as 1.2.0**

**What.** Connect IQ glance for HeroSet: today's three mission bars + streak, no app launch. Scrolling past answers "am I done today?".

**Why first.** App's whole loop = daily check; today costs full app launch for question three bars answer. Glance = difference between habit app you open and one you pass twenty times a day. Pairs with HeroFace: face covers watch-face slot, glance widget carousel.

**Cost.** Small to medium: `AppBase.getGlanceView()`, `(:glance)` view, read-only reader, lazy `HeroSetApp` (see [ADR-051](decisions.md#adr-051)). No new permission, storage key, contract change.

**Risks.** Glance support per-device, not universal across 80 products: sweep into [`compatibility.md`](compatibility.md) before claiming it. Glances have tighter memory budget, so layout = rewrite at glance size. Run on system's schedule, so must not assume `ensureCurrentDay` ran recently.

---

## 2. Faster manual entry

**What.** Way to log set of 40 without 40 button presses, without long-press.

**Why.** [`input-and-ux.md`](input-and-ux.md) states the hole: "big manual entry take one press per rep." Manual logging = whole experience for anyone whose watch hand isn't on floor; delta picker punishes user who trusts app least.

**Shape.** [ADR-029](decisions.md#adr-029) rules out hold-to-accelerate, so step must change another way, cheapest first: START cycles step (1 → 5 → 10 → 1), save binding moves to Back menu · Back menu gains `+10` / `+25` · second picker row for tens.

**Cost / risk.** Small, but spends a button binding; navigation contract + screen-fit re-check come with it. Picker also = learning path ([ADR-040](decisions.md#adr-040)): bigger step = bigger typo, typo teaches detector wrong threshold. Keep single-rep precision reachable.

---

## 3. Rest timer between sets

**What.** After save, optional countdown (45/60/90 s) buzzes for next set, today's remaining reps on screen.

**Why.** 100 reps = 4–6 sets; gap between them is what app ignores. Timer turns separate launches into one session, raises reps per launch.

**Cost.** Small-to-medium: `Timer.Timer`, `HeroSetHaptics`, `HeroSetDayTracker` pattern exist; new screen, strings, screen-fit rows across all products.

**Risks.** Lit screen between sets = first real battery cost in this app: measure per [`battery.md`](battery.md) before shipping. Needs deliberate answer for user walking away mid-countdown.

---

## 4. Goal-not-met nudge

**What.** Background check late in day notifies when daily mission still open.

**Why.** Streaks break by forgetting, not quitting. Highest-leverage retention feature here, only one acting when app closed.

**Cost.** High, mostly not code. Background temporal event needs `Background` permission, which changes listing's permission line, privacy page in `../../site/src/apps/heroset/`, [`release-contract.md`](release-contract.md)'s permission row, all same session. Background processes get small memory budget, minimum interval.

**Risks.** Nagging fitness app gets deleted: default off, switchable on watch. Adding permission = own review cycle, so 1.3 at earliest.

---

## 5. A fourth exercise

**What.** Pull-ups, lunges, dips or plank alongside the three. Likely most requested feature, clearest ceiling on who app is for.

**Cost.** Highest here, not the counting. Three exercises load-bearing:
- `HeroSetRules.EXERCISES`, storage keys, XP ratchet per-exercise, but daily cap + rank curve assume three ([ADR-002](decisions.md#adr-002)/[045](decisions.md#adr-045): 3 × 100 × 2 = 600 XP a day). Fourth changes rank curve's meaning.
- Complication has fixed field order HeroFace reads ([ADR-044](decisions.md#adr-044)). Fields append, so fourth count can be added, but dashboard, mission bars, menu, goal picker assume three rows on round chord that may not fit four at 218 px.
- Plank = held time, not reps: different mechanic in detector, picker, XP rule.

**If ever done:** reps-based only, XP cap per-day total not per-exercise, ADR before code.

---

## Considered and rejected

- **Day history (last 30 days).** Proposed and rejected by owner 2026-09-21. Don't re-propose without new reasoning.