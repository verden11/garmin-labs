import type { Screenshot } from '../types.ts'

// HeroSet's Instinct support (ADR-055) is merged but not uploaded to the store yet.
// Flip this to true in the commit that follows the approved Instinct upload
// (HeroSet docs/status.md F), so the site never claims a watch the store does not list.
export const instinctLive = true   // HeroSet 1.3.0 (Instinct) live since 2026-10-03 (ROADMAP 10.6)

// Generated from the manifests by site/scripts/watch-families.py (HeroSet/manifest-store.xml); re-run it when the products change. The store's
// device tab is the final word: a paid app is sold only on Garmin's paid-app list.
export const watchCount = 92
export const watchFamilies: [string, string][] = [
  ['Forerunner', '70, 165, 170, 255, 255s, 265, 265s, 570, 945 LTE, 955, 965, 970'],
  ['fēnix', '6, 6 Pro, 6S, 6S Pro, 6X Pro, 7, 7 Pro, 7S, 7S Pro, 7X, 7X Pro, 8, 8 Pro, 8 Solar, 9, 9 Pro, 9 Pro Solar, E'],
  ['epix', 'Gen 2, Pro (Gen 2)'],
  ['Enduro', '3, Enduro'],
  ['MARQ', 'Gen 1, Gen 2'],
  ['Venu', '2, 2 Plus, 2S, 3, 3S, 4, Sq 2, X1'],
  ['vívoactive', '5, 6'],
  ['Instinct', '2, 2S, 2X Solar, 3 AMOLED, 3 Solar, E'],
  ['Descent', 'G1, G2, Mk2, Mk2 S, Mk3, Mk3i'],
  ['D2', 'Air X10, Mach 1, Mach 2, Mach 2 Pro'],
  ['Approach', 'S50, S70'],
]

// HeroSet 1.2.0 (the glance) was approved by Garmin (owner, 2026-10-01); the support FAQ now describes it.
// Kept as a flag so a future glance change can be hidden until its version is live.
export const glanceLive = true

export const languages = [
  'English', 'Dansk', 'Deutsch', 'Español', 'Français', 'Italiano', 'Lietuvių', 'Nederlands',
  'Norsk bokmål', 'Polski', 'Português', 'Suomi', 'Svenska', 'Türkçe', 'Українська',
]

// Simulator captures of the store build (HeroSet ADR-039), each framed in the watch it ran on: the store listing's set
// (HeroSet/listing/screens-framed, docker/frame_listing.sh), resized to 560 px in public/heroset/watch/.
export const screens: Screenshot[] = [
  { label: 'Dashboard', src: '/heroset/watch/dashboard.png', watch: 'Forerunner 970' },
  { label: 'Counting', src: '/heroset/watch/counting.png', watch: 'Forerunner 965' },
  { label: 'Review', src: '/heroset/watch/review.png', watch: 'epix Pro' },
  { label: 'Complete', src: '/heroset/watch/complete.png', watch: 'Forerunner 265' },
  { label: 'Instinct', src: '/heroset/watch/instinct.png', watch: 'Instinct E' },
]
