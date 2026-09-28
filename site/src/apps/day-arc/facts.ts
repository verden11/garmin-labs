// The name is a WORKING NAME (owner has not confirmed it; store-collision and general web checked,
// no registered-trademark search — DayArc/docs/decisions.md ADR-012).
export const appName = 'DayArc'

// Mirrors DayArc/manifest.simple.xml and DayArc/docs/release-contract.md; update together.
export const languages = ['English']

// Mirrors DayArc/manifest.simple.xml's <iq:permissions>. If this ever changes: update the
// "Permissions" section in Privacy.tsx too (see DayArc/listing/NOTES.md).
export const permissions: [string, string][] = [
  ['Complications', 'to read the watch’s own weather, stress, Body Battery, and other daily readings.'],
]

// Mirrors DayArc/docs/spec.md's window boundaries (DayArc/docs/decisions.md ADR-004, ADR-013).
// Every window shows the date now, not just night.
export const windows: [string, string, string][] = [
  ['Morning', '5:00–9:30', 'Feels-like temperature, the day’s high and low, chance of rain.'],
  ['Midday', '9:30–17:00', 'A stress reading, shown as a number and a plain gauge.'],
  ['Evening', '17:00–23:00', 'Your Body Battery reading, the same way.'],
  ['Night', '23:00–5:00', 'Time and date only.'],
]
