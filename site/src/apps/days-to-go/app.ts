import type { App } from '../types.ts'
import { DaysToGoMark } from './Mark.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'

// Store page URL supplied by the owner 2026-10-01. Without storeUrl the page would say "Coming soon".
export const daysToGo: App = {
  slug: 'days-to-go',
  name: 'Days To Go',
  title: 'Days To Go — a countdown watch face for Garmin',
  summary: 'A watch face that counts down the days to any date you choose.',
  platform: 'Watch face · Connect IQ',
  color: '#55ffaa',
  onColor: '#04140c',
  storeName: 'Connect IQ Store',
  storeUrl: 'https://apps.garmin.com/apps/95adf037-3bf8-423c-b939-e9921da1b4d4',
  Mark: DaysToGoMark,
  Landing,
  Support,
  Privacy,
}
