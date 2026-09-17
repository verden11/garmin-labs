# Button-first interaction

Fully usable without touch — physical buttons + native Connect IQ menus.

**Buttons are press-only (ADR-029).** No in-app action uses a long-press:
on the FR965 holding Up/Down/Light/Back opens watch-level shortcuts, so a hold
can't be claimed as an app gesture. On-screen hints name buttons by their
bezel labels — `START`, `UP/DOWN`, `BACK` — never `SELECT`/`SEL`/`DN`
(`START` is what Connect IQ calls Select).

## Navigation contract

**Dashboard**: START/Up/Down → mission menu (so does Menu, the watch's own
hold-Up shortcut). Back → leave HeroSet.
Top to bottom (ADR-031):
- **XP ring**: a gold arc on the bezel, open at the bottom, fills with the XP
  earned inside the current rank and restarts empty at each rank-up.
- **`RANK N`** (gold), then **`N XP TO RANK M`** (muted; `N XP TO GO` if the
  numbers outgrow the row): says what XP is for.
- **Three mission bars**: label + today's count on one line, a thick bar
  under it (blue while in progress, full and green once at goal). A finished
  row's label reads `PUSH-UPS DONE`, so done never relies on color alone.
  All rows share one left/right edge, measured inside the ring, so labels,
  counts and bars line up as columns.
- **Streak line**: `N DAY STREAK` (`STREAK N` if it doesn't fit), muted while
  today is still open and gold once today's mission completes; `NO STREAK
  YET` at 0. A missed day shows 0 immediately, not the old run.
- **Footer**: the menu hint (`START: MENU`), or `MISSION COMPLETE` (green)
  once all three goals are met; a storage write failure (`! COULD NOT
  SAVE`, red) overrides both. It sits in the ring's bottom gap at one fixed
  y, so nothing shifts when it changes.

XP: 2 per rep, counted up to each daily goal (max 600 a day, ADR-002). Rank
r→r+1 costs 300 × min(r, 14) XP: rank 2 after half a full day, rank 10 after
about three weeks, then one rank per full week.

**Native menus**: Up/Down move, START activates, Back returns. The main menu
(titled HeroSet) shows today's progress under each Start item (`42/100` or
`DONE`) and opens focused on the Start item of the first exercise not yet at
its goal (top of the list when all are done), so starting the next set is
usually a single START. Log Push-ups/Sit-ups/Squats open the manual picker.

**Exercise session**: counting starts the instant the screen opens — no
pause/resume, no adjustment menu. The rep count is the dominant element;
below it `TODAY N/100` (stored + counted so far), then elapsed set time
(mm:ss) with live HR and an estimated-calories-for-this-set readout
(ADR-021), refreshed every second. Each rep taps once; the rep that carries
today's total over the goal gives a double tap instead (once per set).
START = Finish (`START: FINISH`), which opens the manual delta picker (below) pre-loaded with
the detected count so a miscount can be corrected before it's saved —
nothing is banked until the picker is saved. Back with zero reps leaves
directly. Back with reps opens an `N reps` menu (Garmin's activity-end
pattern, ADR-028): **Resume** (or Back) returns to counting; **Save** banks
the detected count as-is, no correction step, and returns to the dashboard;
**Discard** drops the set, returns to the dashboard and shows `DISCARDED`.
By default no FIT activity is created (see Sync below).

**Manual entry**: Main menu → Log <exercise>, or automatically after
finishing a workout set (ADR-024). A continuous delta picker opens (at 0 from
the menu, at the detected count after a workout, with a `DETECTED N`
subtitle): each Up/Down press steps the delta by exactly 1 (`UP/DOWN:
ADJUST`); there is deliberately no hold-to-accelerate (ADR-029), so a large
manual entry takes one press per rep. The delta never drops below
minus today's stored count. The delta shows white at 0, green when positive,
red when negative; `TODAY N/100` shows what today's total becomes if saved.
START banks the delta (`START: SAVE`) and returns to the dashboard. Back with zero delta
leaves directly; with a pending delta it opens a `+N reps` menu: **Save**
banks and returns to the dashboard, **Discard** returns to the dashboard
without saving (shows `DISCARDED`; nothing is logged to the validation log),
**Keep Editing** (or Back) returns to the picker unchanged.

**Save feedback** (every save path): `DAILY MISSION COMPLETE!` with a triple
vibration the moment a save completes all 3 daily goals for the first time
that day; otherwise `PUSH-UPS DONE!` (per exercise) with a double vibration
when the save carries that exercise from below to at/over its goal;
otherwise a plain `+N SAVED` toast.

**Sync boundary**: everything HeroSet tracks — reps, XP, streaks, calibration,
daily totals, live HR/calorie readouts — is local to the watch. By default
HeroSet never creates a FIT activity or touches Garmin Connect/Strava
(ADR-021).

**Garmin Connect/Strava sync (opt-in, off by default)**: Main menu → Connect
Sync is an on/off toggle showing its current state (`On`/`Off`) without
selecting it; START flips it immediately, no confirmation (ADR-027). The label
is `Connect Sync`, not `Garmin Connect Sync`: the longer one was cut off by
the toggle switch on the FR965 (ADR-029).
Turning it off saves any activity already recorded that day. When on, every workout set (not manual entries — those
have no elapsed-time/HR signal to attach) starts/resumes one combined FIT
activity for that calendar day; it's saved once, the next time a set is
logged on a new day (ADR-025). **Unverified on the watch:** the first test
produced two activities in one day (ADR-030). Discarding a set drops its reps, not the
counting time already recorded into that day's activity. No GPS/distance data. Strava itself isn't
contacted directly — this only creates a Garmin Connect activity; whether it
reaches Strava depends on the user's existing Garmin Connect ↔ Strava account
link.

## Calibration

Independent per-exercise profiles for push-ups/situps/squats, from the same
live accelerometer signal as counting — thresholds reflect the user's watch
position and movement style.

- Main menu → Calibrate Exercise → select exercise → START begins capture
  (`START: BEGIN`).
- Perform ten natural reps; auto-finishes at ten. While recording, START
  is labelled `START: STOP`: it abandons the session, because a profile needs all ten
  cycles and reaching ten finishes automatically — stopping early can never
  produce one.
- A rejected session names the reason: `ONLY 6/10 REPS` (stopped early) or
  `WEAK SIGNAL, RETRY` (ten cycles, but too small a movement). Neither replaces
  the previous profile.
- Back leaves without replacing the previous profile.
- First release: thresholds = half the mean counted cycle excursion (peak/valley
  each). Recalibrate when switching wrists, changing strap position, or when
  live counting drifts.

No critical action may require a touch target; touch may be added later as an
accelerator only.