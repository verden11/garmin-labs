import type { App } from '../types.ts'
import { DayArcProMark } from './Mark.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'
import { appName } from './facts.ts'

// Approved by Garmin, store page supplied by the owner 2026-10-05.
// The slug is published in store listings and never changes, even if the name does.
// A separate listing from DayArc: its own app id, its own slug (DayArc/docs/decisions.md ADR-003).
export const dayArcPro: App = {
  slug: 'day-arc-pro',
  name: appName,
  title: `${appName} — the data-rich version of DayArc`,
  summary: 'The same four time windows as DayArc, with a denser field grid under each reading. Paid, no free tier.',
  platform: 'Watch face · Connect IQ',
  color: '#2a9fb0',
  // Dark ink, not white: white on this teal is 3.14:1, under the 4.5:1 WCAG AA text minimum; this is 5.70:1.
  onColor: '#061a1d',
  storeName: 'Connect IQ Store',
  storeUrl: 'https://apps.garmin.com/apps/b6373747-2569-4a55-86ca-c42914c571fe',
  ogImage: '/day-arc-pro/watch/midday.png',
  Mark: DayArcProMark,
  Landing,
  Support,
  Privacy,
}
