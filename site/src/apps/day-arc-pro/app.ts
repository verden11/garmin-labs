import type { App } from '../types.ts'
import { DayArcProMark } from './Mark.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'
import { appName } from './facts.ts'

// No storeUrl until the store approves the app: the page then says "Coming soon".
// The slug is published in store listings and never changes, even if the name does.
// A separate listing from DayArc: its own app id, its own slug (DayArc/docs/decisions.md ADR-003).
export const dayArcPro: App = {
  slug: 'day-arc-pro',
  name: appName,
  title: `${appName} — the data-rich version of DayArc`,
  summary: 'The same four time windows as DayArc, with a denser field grid under each reading. Paid, no free tier.',
  platform: 'Watch face · Connect IQ',
  color: '#2a9fb0',
  onColor: '#ffffff',
  storeName: 'Connect IQ Store',
  Mark: DayArcProMark,
  Landing,
  Support,
  Privacy,
}
