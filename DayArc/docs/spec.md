# DayArc — spec

Name: **DayArc** (free) / **DayArc Pro** (paid) — confirmed by store-collision and general web
check, no registered-trademark search (`docs/decisions.md` ADR-012).

Written from [`Time of day adaptive watch face.md`](../../reports/archive/Time%20of%20day%20adaptive%20watch%20face.md)
(sourced notes: `research_notes/Time of day adaptive watch face/`) and its successor,
[`DayArc v1 scope and plan.md`](../../reports/archive/DayArc%20v1%20scope%20and%20plan.md), which corrects
the original report's data-source and calendar-feasibility claims after an adversarial review and a
full `Toybox.Complications` catalog check. The original report's competitive/wording/craft research
stands; its technical/scope claims are superseded by the plan doc and by this spec.

## What it does

A watch face whose content changes with a fixed clock, not a toggle: morning shows the weather to
dress for, midday shows a stress read (plus, in Pro, the next calendar event), evening shows Body
Battery, night shows time and date only. The date is shown in every window now, not just night
(ADR-013). Two listings share one codebase: **DayArc** (Simple) is one focal read per window, each
beside a single-hue icon tied to that window's own accent colour; **DayArc Pro** is the same three
data windows with a denser field grid underneath each hero read, each grid field carrying its own
permanently-coloured icon (ADR-013), for the segment that wants a data-rich face (`docs/decisions.md`
ADR-003, ADR-009, ADR-013). A thin window-progress arc across the top of the circle marks how far
through the current window the clock is (morning/midday/evening only, ADR-013).

## What it explicitly does not do

- No steps/HR/weather dashboard with no hierarchy — even Pro keeps one hero read per window, first
  and largest, ahead of its secondary grid (ADR-009).
- No mood, verdict, emoji or colour-coded judgement on any metric — number and neutral gauge only
  (ADR-006).
- No calendar in Simple — deliberate craft decision, not a gap (ADR-008).
- No outdoor/break nudges, no sleep score/coach, no companion app, no widget (all cut — see the
  plan doc's "Still cut" table; nothing here reopens them).
- No settings surface beyond ONE: Accent colour (ADR-014, which partly reverses ADR-011). Density
  is compile-time, never a setting.
- No network, no `Communications`, no `Background`, no `UserProfile`.

## Data sources

Everything through `Toybox.Complications` (permission: **`ComplicationSubscriber`**, confirmed
required — ADR-002) except the morning weather read, which is `Toybox.Weather.getCurrentConditions()`
(no permission — confirmed absent from the manifest permission table). `DayArcSources` is the only
class that touches either module; every accessor catches `Lang.Exception` (covers
`ComplicationNotFoundException`) and every typed accessor null-checks the value on top, so a
missing complication and a present-but-empty one both resolve to the same "--"/plain-sentence
empty state, never a crash.

| Field | Source | Type | Notes |
|---|---|---|---|
| Feels-like temp, high/low, precip | `Weather.CurrentConditions` | Float °C / preformatted string / Number % | Converted to the device's own units (`DayArcFormat`); high/low string is Garmin's own preformatted text, not re-converted |
| UV index | `CurrentConditions.uvIndex` | Float or Null | API 5.1.0+, `has` guard, bonus only |
| Stress | `COMPLICATION_TYPE_STRESS` | Number 0-100 or Null | Gauge, no band-name word |
| Body Battery | `COMPLICATION_TYPE_BODY_BATTERY` | Number 0-100 or Null | Gauge, no threshold split (TwoSuns ADR-008) |
| Next calendar event | `COMPLICATION_TYPE_CALENDAR_EVENTS` | String or Null | Pro only; null covers both "no sync" and "no upcoming event" — the SDK gives no way to tell them apart, so the copy claims neither cause |
| Date/weekday | `COMPLICATION_TYPE_WEEKDAY_MONTHDAY` | String | Shown in every window's header now, both densities (ADR-013) — no longer Pro-grid-only |
| Battery %, steps, calories, floors, intensity minutes, notification count, heart rate, recovery time, respiration rate, pulse ox, weekly run/bike distance, VO2max (run/bike), sunrise/sunset, current temperature | `Complications.Type` catalog | per-type | Pro secondary grid only |

Training status (`COMPLICATION_TYPE_TRAINING_STATUS`) was cut after the first pass: it's a raw
Garmin-authored string this app can't filter, and Garmin's own vocabulary for it includes words
sharing ADR-006's own banned root ("draining") — caught by `watch-design-reviewer`, 2026-09-28.

## Settings

Exactly one, in both listings (ADR-014, partly reversing ADR-011): **Accent colour**, a list —
`0` Auto (default: each window's own hue — morning amber, midday cyan, evening rose), `1` Cyan,
`2` Amber, `3` Rose, `4` Green, `5` Blue, `6` Purple; all 64-colour-safe, never a free colour
picker. A fixed choice colours the window-progress arc, the hero value, the gauge fill and the hero
icon in every non-night window; night stays hueless; Pro's 14 grid icons keep their fixed per-type
hues. Property id `Accent` (never changes once shipped), `resources/settings/settings.xml` +
`properties.xml`, shared by both jungles. Two writers, last change wins: the Garmin Connect phone
page (store-installed apps only — a sideloaded build gets none, so it is unverifiable until a store
install) and the watch's own Customize list (`getSettingsView`, CIQ 4.2+ — the only route a
sideloaded build has; not claimed in listing copy until it has been tried on a wrist). Read at draw time inside a guard, clamped, any bad
value falls back to Auto; a change applies on the next redraw with no restart. Density is not a
setting (ADR-003). No other setting is to be added under this one.

## Device reach

`minApiLevel="4.2.0"`, TwoSuns ADR-009's 69-product set, reused verbatim (ADR-001). Round products
(66 of the 69) are chord-fitted against the inscribed circle. The three rectangular AMOLED products
(Venu Sq 2, Venu Sq 2 Music, Venu X1) use the full screen width and the screen's own bottom edge —
they have no bezel to clip against; only the window-progress arc stays on the inscribed circle
(ADR-001, amended 2026-09-28). Every window's stack — clock, date, hero, gauge, sub line(s) and, in
Pro, the grid — is planned as a whole against the real display (`DayArcStack`), stepping fonts down
only as needed; on the smallest screens Pro reserves fewer grid rows (`DESIGN.md` "Layout").

## Success and stop test

Success: DayArc (free) drives DayArc Pro discovery/conversion without either listing needing a
correction for a wrong claim. Stop signal: a correctness complaint about a shown number (would mean
a units/formatting bug, `DayArcFormat`) or a repeated "this looks like a mood/verdict" complaint
(would mean ADR-006's gauge reads as a traffic light despite the single-hue rule — flagged for
`watch-design-reviewer` before submission, not just after a real complaint).
