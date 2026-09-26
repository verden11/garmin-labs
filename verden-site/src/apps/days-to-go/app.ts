import type { App } from '../types.ts'
import { DaysToGoMark } from './Mark.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'

// No storeUrl until the store approves the app: the page then says "Coming soon".
export const daysToGo: App = {
  slug: 'days-to-go',
  name: 'Days To Go',
  title: 'Days To Go — a countdown watch face for Garmin',
  summary: 'A watch face that counts the days to a date, and gets the date right.',
  platform: 'Garmin watches · Connect IQ',
  color: '#55ffaa',
  onColor: '#04140c',
  storeName: 'Connect IQ Store',
  Mark: DaysToGoMark,
  Landing,
  Support,
  Privacy,
}
