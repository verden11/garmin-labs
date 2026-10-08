import type { Screenshot } from '../types.ts'

// Mirrors DaysToGo/docs/compatibility.md and docs/release-contract.md; update together.
// There is deliberately no watch list or watch count here: the store's list is
// shorter than the manifest's, and the app is not live yet (release contract).
// Simulator captures, each framed in the watch it ran on: the store listings' sets (DaysToGo/listing*/screens-framed, docker/frame_listing.sh),
// resized to 560 px in public/days-to-go/watch/. Example numbers; the simulator's data is canned.
export const screens: Screenshot[] = [
  { label: 'Days', src: '/days-to-go/watch/days.png', watch: 'Venu 3' },
  { label: 'Weeks and days', src: '/days-to-go/watch/weeks.png', watch: 'Forerunner 265' },
  { label: 'Today', src: '/days-to-go/watch/today.png', watch: 'epix Pro' },
  { label: 'To the minute (Pro)', src: '/days-to-go/watch/to-the-minute.png', watch: 'Venu 4' },
  { label: 'Instinct', src: '/days-to-go/watch/instinct.png', watch: 'Instinct 2' },
]

// Generated from the manifests by site/scripts/watch-families.py (Days To Go Free and Pro manifests); re-run it when the products change. The store's
// device tab is the final word: a paid app is sold only on Garmin's paid-app list.
export const watchCount = 129
export const watchFamilies: [string, string][] = [
  ['Forerunner', '55, 70, 165, 170, 245, 255, 255s, 265, 265s, 570, 645, 745, 935, 945, 945 LTE, 955, 965, 970'],
  ['fēnix', '5, 5 Plus, 5S, 5S Plus, 5X, 5X Plus, 6, 6 Pro, 6S, 6S Pro, 6X Pro, 7, 7 Pro, 7S, 7S Pro, 7X, 7X Pro, 8, 8 Pro, 8 Solar, 9, 9 Pro, 9 Pro Solar, Chronos, E'],
  ['epix', 'Gen 2, Pro (Gen 2)'],
  ['Enduro', '3, Enduro'],
  ['MARQ', 'Gen 1, Gen 2'],
  ['Venu', '2, 2 Plus, 2S, 3, 3S, 4, Mercedes-Benz Collection, Sq, Sq 2, Sq. Edition, Venu, X1'],
  ['vívoactive', '3, 3 LTE, 3 Mercedes-Benz Collection, 4, 4S, 5, 6'],
  ['Instinct', '2, 2S, 2X Solar, 3 AMOLED, 3 Solar, Crossover AMOLED, E'],
  ['Descent', 'G1, G2, Mk1, Mk2, Mk2 S, Mk3, Mk3i'],
  ['D2', 'Air, Air X10, Charlie, Delta, Delta PX, Delta S, Mach 1, Mach 2, Mach 2 Pro'],
  ['Approach', 'S50, S62, S70'],
]

export const languages = [
  'English', 'Dansk', 'Deutsch', 'Español', 'Français', 'Italiano', 'Lietuvių', 'Nederlands',
  'Norsk bokmål', 'Polski', 'Português', 'Suomi', 'Svenska', 'Türkçe', 'Українська',
]
