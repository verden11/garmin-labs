import type { App } from '../types.ts'
import { TwoSunsMark } from './Mark.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'
import { appName } from './facts.ts'

// Live in the store (page confirmed 2026-10-01). Without storeUrl the page would say "Coming soon".
// The slug is published in store listings and never changes, even if the name does.
export const twoSuns: App = {
  slug: 'two-suns',
  name: appName,
  title: `${appName} — a sun ring and energy curve watch face for Garmin`,
  summary: 'A watch face with a 24-hour ring for the sun and a curve of your last 24 hours of Body Battery.',
  platform: 'Watch face · Connect IQ',
  // Dusk coral on the shared grid (7.0:1 with its ink): amber is HeroSet, blue HeroFace, mint Days To Go
  // (and, since 2026-09-27, blue is also the watch face's own default accent — one more reason not to
  // reuse it here). Owner's call; DESIGN.md wants a named token and a line for it (see NOTES).
  color: '#ff6f8f',
  onColor: '#240a10',
  storeName: 'Connect IQ Store',
  storeUrl: 'https://apps.garmin.com/apps/9d4bca45-d79a-4f26-abf5-04e0519cf10b',
  Mark: TwoSunsMark,
  Landing,
  Support,
  Privacy,
}
