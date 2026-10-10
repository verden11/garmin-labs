// The name is confirmed (owner, 2026-10-05, ADR-001; a real trademark search is still open, ROADMAP 18.3). It is spelled here and
// nowhere else in this folder: a rename is this one line, but the slug never changes once a listing links it.
export const appName = 'Sun Window'

// Mirrors SunWindow/manifest.xml and SunWindow/docs/release-contract.md; update together.
// Generated from the manifest by site/scripts/watch-families.py (SunWindow/manifest.xml); re-run it when the products change. The store's
// device tab is the final word.
export const watchCount = 65
export const watchFamilies: [string, string][] = [
  ['Forerunner', '70, 165, 170, 255, 255s, 265, 265s, 570, 955, 965, 970'],
  ['fēnix', '7, 7 Pro, 7S, 7S Pro, 7X, 7X Pro, 8, 8 Pro, 8 Solar, 9, 9 Pro, 9 Pro Solar, E'],
  ['epix', 'Gen 2, Pro (Gen 2)'],
  ['Enduro', '3'],
  ['MARQ', 'Gen 2'],
  ['Venu', '3, 3S, 4, X1'],
  ['vívoactive', '5, 6'],
  ['Instinct', '3 AMOLED, 3 Solar, E'],
  ['Descent', 'G2, Mk3, Mk3i'],
  ['D2', 'Mach 1, Mach 2, Mach 2 Pro'],
  ['Approach', 'S50, S70'],
]

export const languages = ['English']

// Mirrors SunWindow/manifest.xml's <iq:permissions>. If this ever changes: update the "Permissions" and "Location" sections in
// Privacy.tsx too (SunWindow/listing/NOTES.md).
export const permissions: [string, string][] = [
  ['Positioning', 'to read the last place your watch knows, so the sun’s height can be worked out for where you are.'],
]

// The three states, as the glance and the app say them (SunWindow/docs/spec.md "What it does").
export const states: [string, string][] = [
  ['OPEN', 'The sun is at or above 45 degrees right now.'],
  ['CLOSED', 'Today’s sun reaches 45 degrees, but not now: before it gets there, after it has gone, or the watch’s own weather reports a low UV index.'],
  ['NONE TODAY', 'Today’s highest sun stays under 45 degrees. In the north that is most of the winter.'],
]
