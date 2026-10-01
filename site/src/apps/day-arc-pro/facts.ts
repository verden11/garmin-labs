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
// date is in every window's header, so it is not a grid field. Never state a COUNT of fields: how
// many show depends on the watch's screen (about 4-6 on an FR965, about 2 on a Venu Sq 2), so each
// list is "as many as fit".
export const windows: [string, string, string][] = [
  ['Morning', '5:00–9:30', 'Weather, plus as many as fit your watch’s screen of: sunrise/sunset, battery, heart rate, steps, floors, notifications.'],
  ['Midday', '9:30–17:00', 'Stress, plus as many as fit your watch’s screen of: your next calendar event, heart rate, intensity minutes, floors, steps, calories, notifications, temperature, weekly run and bike distance.'],
  ['Evening', '17:00–23:00', 'Body Battery, plus as many as fit your watch’s screen of: recovery time, respiration, heart rate, steps, calories, pulse ox, VO2max.'],
  ['Night', '23:00–5:00', 'Time and date only — same as DayArc.'],
]
