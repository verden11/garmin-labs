// The name is confirmed (owner, 2026-10-04) and live in the store since 2026-10-05 (store-collision and general web checked,
// no registered-trademark search — DayArc/docs/decisions.md ADR-012).
export const appName = 'DayArc Pro'

// Mirrors DayArc/manifest.pro.xml and DayArc/docs/release-contract.md; update together.
// Generated from the manifests by site/scripts/watch-families.py (DayArc/manifest.pro.xml); re-run it when the products change. The store's
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
