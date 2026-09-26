import type { Screenshot } from '../types.ts'

// Mirrors HeroSet docs/compatibility.md; update both together.
export const watchFamilies: [string, string][] = [
  ['Forerunner', '70, 165, 170, 255, 265, 570, 945 LTE, 955, 965, 970'],
  ['fēnix', '6, 6 Pro, 7, 7 Pro, 8, 8 Pro, 9, 9 Pro, E'],
  ['epix', 'Gen 2, Pro (Gen 2)'],
  ['Enduro', 'Enduro, Enduro 3'],
  ['MARQ', 'Gen 1, Gen 2'],
  ['D2', 'Mach, Air X10'],
  ['Descent', 'MK2, MK2S, MK3, G2'],
  ['Venu', '2, 2 Plus, 2S, 3, 3S, 4'],
  ['vívoactive', '5, 6'],
  ['Approach', 'S50, S70'],
]

export const languages = [
  'English', 'Dansk', 'Deutsch', 'Español', 'Français', 'Italiano', 'Lietuvių', 'Nederlands',
  'Norsk bokmål', 'Polski', 'Português', 'Suomi', 'Svenska', 'Türkçe', 'Українська',
]

// Simulator captures of the store build (HeroSet ADR-039). Drop files in
// public/heroset/screens/ and set src; empty slots render as pending.
// Store-listing set: HeroSet/listing/screens; framed marketing set: HeroSet/listing/framed.
export const screens: Screenshot[] = [
  { label: 'Dashboard', src: '/heroset/screens/dashboard.png' },
  { label: 'Counting', src: '/heroset/screens/counting.png' },
  { label: 'Review', src: '/heroset/screens/review.png' },
  { label: 'Saved', src: '/heroset/screens/saved.png' },
]
