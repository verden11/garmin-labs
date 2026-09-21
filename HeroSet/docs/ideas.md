# Feature ideas

Status: 2026-09-21. Candidate features, ranked by value per unit of cost.

**Not open items.** Nothing here is committed, scheduled or blocking;
[`go-to-market.md`](go-to-market.md) stays the only home for open items,
blockers and launch gates. Nothing here is pulled forward before 1.0.0 clears
review. Anything that graduates gets an ADR in [`decisions.md`](decisions.md)
and moves to the go-to-market backlog; the entry here then says so.

Every idea below is checked against [`release-contract.md`](release-contract.md)
(forbidden claims), ADR-029 (no long-press gestures), ADR-044 (the complication
field order HeroFace depends on) and the store build's `Sensor`-only permission
(ADR-033). Where one of those is the real cost, the entry says it.

---

## 1. Glance view

**What.** The Connect IQ glance for HeroSet: today's three mission bars and the
streak, no app launch. Scrolling past it on the watch answers "am I done
today?".

**Why it's first.** The app's whole loop is a daily check. Right now checking
costs a full app launch — menu, load, draw — for a question answered by three
bars. A glance is the difference between a habit app you open and one you pass
by twenty times a day. It also pairs with HeroFace: the face covers the
watch-face slot, the glance covers the widget carousel.

**Cost.** Small. `AppBase.getGlanceView()` plus a `(:glance)` view that draws a
cut-down version of what `HeroSetMissionBars` already draws. Reads the store the
same way the dashboard does. No new permission, no storage key, no change to the
complication contract.

**Risks.** Glance support is per-device, not universal across the 67 — needs a
capability sweep in [`compatibility.md`](compatibility.md) before it's claimed.
Glance views run under a tighter memory budget than the app, so the layout is a
rewrite at glance size, not a reuse of `HeroSetView`. Glance code runs on the
system's schedule, so it must not assume `ensureCurrentDay` was called recently.

---

## 2. Faster manual entry

**What.** A way to log a set of 40 without 40 button presses, without a
long-press.

**Why.** [`input-and-ux.md`](input-and-ux.md) states the hole plainly: "big
manual entry take one press per rep." Manual logging is not an edge path — it's
the entire experience for anyone whose watch hand isn't on the floor (sit-ups
with the watch on a belt, push-ups on knuckles, a set done before the app was
open). The delta picker punishes exactly the user who trusts the app least.

**Shape.** ADR-029 rules out hold-to-accelerate, so the step has to change some
other way. Options, cheapest first:
- START on the picker cycles the step (1 → 5 → 10 → 1), shown next to the delta.
  Costs the current START-saves binding, which then moves to the Back menu.
- The Back menu gains `+10` / `+25` items alongside Save/Discard.
- A second picker row for tens, Up/Down moving whichever row is focused.

**Cost.** Small, but it spends a button binding, and the navigation contract in
`input-and-ux.md` plus a screen-fit re-check come with it.

**Risk.** The picker is the save path and the learning path (ADR-040). A bigger
step means a bigger typo, and a typo here teaches the detector the wrong
threshold. Whatever ships should keep single-rep precision reachable.

---

## 3. Rest timer between sets

**What.** After a set is saved, an optional countdown (45/60/90 s) that buzzes
when it's time for the next one, with today's remaining reps on screen.

**Why.** 100 reps is 4–6 sets for most people, and the gap between them is the
part the app currently ignores — the user is left staring at the dashboard
guessing when to go again. A timer turns three separate launches into one
session and raises reps per launch, which is the number that actually moves the
daily goal.

**Cost.** Small-to-medium. `Timer.Timer` and `HeroSetHaptics` already do the
work; `HeroSetDayTracker` is the pattern for a timer that starts and stops with
a view. New screen, new strings, new screen-fit rows across 67 products.

**Risks.** A screen that stays lit between sets is the first thing in this app
with a real battery cost — it belongs in [`battery.md`](battery.md)'s
measurement plan before it ships. Needs a deliberate answer for what happens
when the user walks away mid-countdown.

---

## 4. Goal-not-met nudge

**What.** A background check late in the day that notifies when the daily
mission is still open.

**Why.** Streaks break by forgetting, not by choosing to quit. This is the
single highest-leverage retention feature in the list, and the only one that
acts when the app is closed.

**Cost.** High, and most of it is not code. A background temporal event needs
the `Background` permission, which changes the store listing's permission line,
the privacy page at `../verden-site/src/apps/heroset/`, and the "Data leaving
watch / permission `Sensor` only" row of `release-contract.md` — all in the same
session, per the cross-folder rule. Background processes get a small memory
budget and a fixed minimum interval.

**Risks.** A fitness app that nags is a fitness app that gets deleted; it must
default off and be switchable on the watch. Adding a permission to a
published app is a separate review cycle — this is a 1.3 item at the earliest
(1.2.0 is Connect sync), never a rider on 1.1.0.

---

## 5. A fourth exercise

**What.** Pull-ups, lunges, dips or plank alongside the three.

**Why.** The most likely single request from buyers, and the clearest ceiling on
who the app is for.

**Cost.** The highest in this file, and it isn't the counting. The three
exercises are load-bearing in a way a fourth cannot quietly join:
- `HeroSetRules.EXERCISES`, the storage keys and the XP credit ratchet are
  per-exercise but the daily cap and rank curve assume three (ADR-002/045:
  3 × 100 × 2 = 600 XP a day). A fourth changes the rank curve's meaning.
- The complication value has a fixed field order that HeroFace reads (ADR-044).
  New fields append, so a fourth exercise's count can be added — but the
  dashboard, the mission bars, the menu and the goal picker all assume three
  rows, and the layout is measured against a round chord that a fourth row may
  not fit on 218 px.
- Plank is a held time, not reps — a different mechanic in the detector, the
  picker and the XP rule, not a fourth symbol.

**If it's ever done:** reps-based only (pull-ups/lunges/dips), the XP cap stays a
per-day total rather than per-exercise, and the ADR comes before the code.

---

## Considered and rejected

- **Day history (last 30 days).** Proposed 2026-09-21, rejected same day by the
  owner. Don't re-propose without new reasoning.
