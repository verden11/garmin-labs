// The name is a WORKING NAME (owner has not confirmed it; store-collision and general web checked,
// no registered-trademark search — DayArc/docs/decisions.md ADR-012).
export const appName = 'DayArc'

// Mirrors DayArc/manifest.simple.xml and DayArc/docs/release-contract.md; update together.
// Generated from the manifests by site/scripts/watch-families.py (DayArc/manifest.simple.xml); re-run it when the products change. The store's
// device tab is the final word: a paid app is sold only on Garmin's paid-app list.
export const watchCount = 72
export const watchFamilies: [string, string][] = [
  ['Forerunner', '70, 165, 170, 255, 255s, 265, 265s, 570, 955, 965, 970'],
  ['fēnix', '7, 7 Pro, 7S, 7S Pro, 7X, 7X Pro, 8, 8 Pro, 8 Solar, 9, 9 Pro, 9 Pro Solar, E'],
  ['epix', 'Gen 2, Pro (Gen 2)'],
  ['Enduro', '3'],
  ['MARQ', 'Gen 2'],
  ['Venu', '2, 2 Plus, 2S, 3, 3S, 4, Sq 2, X1'],
  ['vívoactive', '5, 6'],
  ['Instinct', '3 AMOLED, 3 Solar, Crossover AMOLED, E'],
  ['Descent', 'G2, Mk3, Mk3i'],
  ['D2', 'Air X10, Mach 1, Mach 2, Mach 2 Pro'],
  ['Approach', 'S50, S70'],
]

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
