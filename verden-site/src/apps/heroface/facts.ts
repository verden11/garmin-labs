import type { Screenshot } from '../types.ts'

// Mirrors HeroFace docs/compatibility.md; update both together.
export const watchCount = 117
export const watchFamilies: [string, string][] = [
  ['fēnix', '5, 5 Plus, 6, 6 Pro, 7, 7 Pro, 8, 8 Solar, 9, 9 Pro, E, Chronos'],
  ['Forerunner', '55, 70, 165, 170, 245, 255, 265, 570, 645, 745, 935, 945, 955, 965, 970'],
  ['MARQ', 'Gen 1, Gen 2'],
  ['Venu', 'Venu, 2, 2S, 2 Plus, 3, 3S, 4'],
  ['D2', 'Air, Air X10, Charlie, Delta, Mach'],
  ['vívoactive', '3, 4, 4S, 5, 6'],
  ['Descent', 'MK1, MK2, MK2S, MK3, G2'],
  ['epix', 'Gen 2, Pro (Gen 2)'],
  ['Approach', 'S50, S62, S70'],
  ['Instinct', '3 AMOLED, Crossover AMOLED'],
  ['Enduro', 'Enduro, Enduro 3'],
  ['Legacy', 'Hero (Captain Marvel, First Avenger), Saga (Darth Vader, Rey)'],
]

// Watches that can also show HeroSet reps: Connect IQ 4.2 and newer.
export const linkedWatchCount = 66

export const languages = [
  'English', 'Dansk', 'Deutsch', 'Español', 'Français', 'Italiano', 'Lietuvių', 'Nederlands',
  'Norsk bokmål', 'Polski', 'Português', 'Suomi', 'Svenska', 'Türkçe', 'Українська',
]

// Captures of the real face: the first two from the simulator, the HeroSet one
// from an FR965, because the link needs HeroSet running to publish. Empty slots
// render as pending. See HeroFace docs/listing/screenshots.md.
export const screens: Screenshot[] = [
  { label: 'Everyday', src: '/heroface/screens/everyday.png' },
  { label: 'Goals met', src: '/heroface/screens/goals-met.png' },
  { label: 'With HeroSet', src: '/heroface/screens/heroset.png' },
  { label: 'Always on' },
]
