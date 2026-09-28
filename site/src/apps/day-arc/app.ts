import type { App } from '../types.ts'
import { DayArcMark } from './Mark.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'
import { appName } from './facts.ts'

// No storeUrl until the store approves the app: the page then says "Coming soon".
// The slug is published in store listings and never changes, even if the name does.
export const dayArc: App = {
  slug: 'day-arc',
  name: appName,
  title: `${appName} — a watch face that changes through the day`,
  summary: 'One reading at a time: weather in the morning, stress at midday, Body Battery in the evening, time and date at night.',
  platform: 'Watch face · Connect IQ',
  color: '#55ffff',
  onColor: '#0a2424',
  storeName: 'Connect IQ Store',
  Mark: DayArcMark,
  Landing,
  Support,
  Privacy,
}
