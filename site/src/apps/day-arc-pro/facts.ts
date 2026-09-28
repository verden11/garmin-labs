// The name is a WORKING NAME (owner has not confirmed it; store-collision and general web checked,
// no registered-trademark search — DayArc/docs/decisions.md ADR-012).
export const appName = 'DayArc Pro'

// Mirrors DayArc/manifest.pro.xml and DayArc/docs/release-contract.md; update together.
export const languages = ['English']

// Mirrors DayArc/manifest.pro.xml's <iq:permissions>.
export const permissions: [string, string][] = [
  ['Complications', 'to read the watch’s own weather, stress, Body Battery, calendar, and other daily readings.'],
]

// Mirrors DayArc/docs/spec.md's Pro field lists (DayArc/docs/decisions.md ADR-009, ADR-013). The
// date is shown in every window's header now, not just as a grid field, so it's dropped from the
// per-window field lists below to avoid double-counting it.
export const windows: [string, string, string][] = [
  ['Morning', '5:00–9:30', 'Weather, plus sunrise/sunset, battery, resting heart rate, steps, floors, notifications.'],
  ['Midday', '9:30–17:00', 'Your next calendar event, plus stress, heart rate, intensity minutes, floors, steps, calories, notifications, temperature, weekly run and bike distance.'],
  ['Evening', '17:00–23:00', 'Body Battery, plus recovery time, respiration, heart rate, steps, calories, pulse ox, VO2max.'],
  ['Night', '23:00–5:00', 'Time and date only — same as DayArc.'],
]
