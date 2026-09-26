import type { App } from '../types.ts'
import { HeroSetMark } from './Mark.tsx'
import { Emblem } from './Pictograms.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'

export const heroset: App = {
  slug: 'heroset',
  name: 'HeroSet',
  title: 'HeroSet — rep counter for Garmin watches',
  summary: 'Counts your daily push-ups, sit-ups and squats from your wrist: 100 of each, or your own goal.',
  platform: 'Watch app · Connect IQ',
  color: '#ffaa00',
  onColor: '#15130f',
  storeName: 'Connect IQ Store',
  storeUrl: 'https://apps.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377',
  ogImage: '/heroset/screens/dashboard.png',
  Mark: HeroSetMark,
  Emblem,
  Landing,
  Support,
  Privacy,
}
