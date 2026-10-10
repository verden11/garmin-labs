# DayArc — spec

Name: **DayArc** (free) / **DayArc Pro** (paid) — confirmed by store-collision, general web check; no registered-trademark search (`docs/decisions.md` ADR-012).

Written from [`Time of day adaptive watch face.md`](../../reports/archive/Time%20of%20day%20adaptive%20watch%20face.md)
(sourced notes: `research_notes/Time of day adaptive watch face/`) and successor
[`DayArc v1 scope and plan.md`](../../reports/archive/DayArc%20v1%20scope%20and%20plan.md). Successor corrects original report's data-source, calendar-feasibility claims after adversarial review, full `Toybox.Complications` catalog check. Original competitive/wording/craft research stands; technical/scope claims superseded by plan doc, this spec.

## What it does

Watch face content changes with fixed clock, not toggle: morning shows weather to dress for, midday shows stress read (Pro adds next calendar event), evening shows Body Battery, night shows time, date only. Date shown in every window now, not just night (ADR-013). Two listings, one codebase: **DayArc** (Simple) = one focal read per window, each beside single-hue icon tied to window's own accent colour; **DayArc Pro** = same three data windows, denser field grid under each hero read, each grid field own icon, all muted grey so hero only coloured read (ADR-013, amended 2026-10-05), for segment wanting data-rich face (`docs/decisions.md`
ADR-003, ADR-009, ADR-013). Thin window-progress arc across top of circle marks how far through current window clock is (morning/midday/evening only, ADR-013).

## What it explicitly does not do

- No steps/HR/weather dashboard with no hierarchy — even Pro keeps one hero read per window, first, largest, ahead of secondary grid (ADR-009).
- No mood, verdict, emoji, colour-coded judgement on any metric — number, neutral gauge only (ADR-006).
- No calendar in Simple — deliberate craft decision, not gap (ADR-008).
- No outdoor/break nudges, no sleep score/coach, no companion app, no widget (all cut — see plan doc's "Still cut" table; nothing here reopens them).
- No settings surface beyond ONE: Accent colour (ADR-014, partly reverses ADR-011). Density compile-time, never setting.
- No network, no `Communications`, no `Background`, no `UserProfile`.

## Data sources

All through `Toybox.Complications` (permission: **`ComplicationSubscriber`**, confirmed required — ADR-002) except morning weather read: `Toybox.Weather.getCurrentConditions()` (no permission — confirmed absent from manifest permission table). `DayArcSources` only class touching either module; every accessor catches `Lang.Exception` (covers
`ComplicationNotFoundException`), every typed accessor null-checks value on top, so missing complication, present-but-empty one resolve to same "--"/plain-sentence empty state, never crash.

| Field | Source | Type | Notes |
|---|---|---|---|
| Feels-like temp, high/low, precip | `Weather.CurrentConditions` | Float °C / preformatted string / Number % | Converted to device's own units (`DayArcFormat`); high/low string Garmin's own preformatted text, not re-converted |
| UV index | `CurrentConditions.uvIndex` | Float or Null | API 5.1.0+, `has` guard, bonus only |
| Stress | `COMPLICATION_TYPE_STRESS` | Number 0-100 or Null | Gauge, no band-name word |
| Body Battery | `COMPLICATION_TYPE_BODY_BATTERY` | Number 0-100 or Null | Gauge, no threshold split (TwoSuns ADR-008) |
| Next calendar event | `COMPLICATION_TYPE_CALENDAR_EVENTS` | String or Null | Pro only; null covers both "no sync" and "no upcoming event" — SDK cannot tell apart, so copy claims neither cause |
| Date/weekday | `COMPLICATION_TYPE_WEEKDAY_MONTHDAY` | String | Shown in every window's header now, both densities (ADR-013) — no longer Pro-grid-only |
| Battery %, steps, calories, floors, intensity minutes, notification count, heart rate, recovery time, respiration rate, pulse ox, weekly run/bike distance, VO2max (run/bike), sunrise/sunset, current temperature | `Complications.Type` catalog | per-type | Pro secondary grid only |

Training status (`COMPLICATION_TYPE_TRAINING_STATUS`) cut after first pass: raw Garmin-authored string app cannot filter; Garmin's vocabulary includes words sharing ADR-006's banned root ("draining") — caught by `watch-design-reviewer`, 2026-09-28.

## Settings

Exactly one, both listings (ADR-014, partly reversing ADR-011): **Accent colour**, list — `0` Auto (default: each window's own hue — morning amber, midday cyan, evening rose), `1` Cyan, `2` Amber, `3` Rose, `4` Green, `5` Blue, `6` Purple; all 64-colour-safe, never free colour picker. Fixed choice colours window-progress arc, hero value, gauge fill, hero icon in every non-night window; night stays hueless; Pro grid icons stay muted grey (ADR-013 amendment, 2026-10-05). Property id `Accent` (never changes once shipped), `resources/settings/settings.xml` + `properties.xml`, shared by both jungles. Two writers, last change wins: Garmin Connect phone page (store-installed apps only — sideloaded build gets none, so unverifiable until store install) and watch's own Customize list (`getSettingsView`, CIQ 4.2+ — only route sideloaded build has; not claimed in listing copy until tried on a wrist). Read at draw time inside guard, clamped, any bad value falls back to Auto; change applies on next redraw, no restart. Density not setting (ADR-003). No other setting to be added under this one.

## Device reach

`minApiLevel="4.2.0"`, TwoSuns ADR-009's 69-product set plus Instinct E 40/45 mm and Instinct 3 Solar 45 mm (ADR-015): 72 products (ADR-001). Round products chord-fitted against inscribed circle. Three rectangular AMOLED products (Venu Sq 2, Venu Sq 2 Music, Venu X1) have own square design (ADR-019, 2026-10-05): window-progress arc = upper part of rounded-rectangle track following glass, gauge = straight bar, every row fits box inside track (`DESIGN.md` "Rectangle"). Every window's stack — clock, date, hero, gauge, sub line(s), in Pro the grid — planned as whole against real display (`DayArcStack`), stepping fonts down only as needed; on smallest screens Pro reserves fewer grid rows (`DESIGN.md` "Layout").

## Success and stop test

Success: DayArc (free) drives DayArc Pro discovery/conversion without either listing needing correction for wrong claim. Stop signal: correctness complaint about shown number (would mean units/formatting bug, `DayArcFormat`) or repeated "this looks like a mood/verdict" complaint (would mean ADR-006's gauge reads as traffic light despite single-hue rule — flagged for `watch-design-reviewer` before submission, not just after real complaint).