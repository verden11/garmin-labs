import type { Screenshot } from '../types.ts'

// HeroSet's Instinct support (ADR-055) is merged but not uploaded to the store yet.
// Flip this to true in the commit that follows the approved Instinct upload
// (HeroSet docs/status.md F), so the site never claims a watch the store does not list.
export const instinctLive = false

// Mirrors HeroSet docs/compatibility.md; update both together.
export const watchFamilies: [string, string][] = [
  ['Forerunner', '70, 165, 170, 255, 265, 570, 945 LTE, 955, 965, 970'],
  ['fēnix', '6, 6 Pro, 7, 7 Pro, 8, 8 Pro, 9, 9 Pro, E'],
  ['epix', 'Gen 2, Pro (Gen 2)'],
  ['Enduro', 'Enduro, Enduro 3'],
  ['MARQ', 'Gen 1, Gen 2'],
  ['D2', 'Mach, Air X10'],
  ['Descent', instinctLive ? 'G1, G2, MK2, MK2S, MK3' : 'MK2, MK2S, MK3, G2'],
  ['Venu', '2, 2 Plus, 2S, 3, 3S, 4'],
  ['vívoactive', '5, 6'],
  ['Approach', 'S50, S70'],
  ...(instinctLive ? [['Instinct', '2, 2S, 2X, E, 3 Solar'] as [string, string]] : []),
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
