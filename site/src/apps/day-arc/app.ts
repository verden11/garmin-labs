import type { App } from '../types.ts'
import { DayArcMark } from './Mark.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'
import { appName } from './facts.ts'

// Approved by Garmin, store page supplied by the owner 2026-10-05.
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
  storeUrl: 'https://apps.garmin.com/apps/9e641dce-3838-4613-a129-55faeb761193',
  ogImage: '/day-arc/watch/midday.png',
  Mark: DayArcMark,
  Landing,
  Support,
  Privacy,
}
