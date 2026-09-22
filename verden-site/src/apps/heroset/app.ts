import type { App } from '../types.ts'
import { HeroSetMark } from './Mark.tsx'
import { Emblem } from './Pictograms.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'

export const heroset: App = {
  slug: 'heroset',
  name: 'HeroSet',
  summary: '100 push-ups, sit-ups and squats a day — or your own goal — counted on your Garmin.',
  platform: 'Garmin watches · Connect IQ',
  color: '#ffaa00',
  onColor: '#15130f',
  storeName: 'Connect IQ Store',
  storeUrl: 'https://apps.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377',
  Mark: HeroSetMark,
  Emblem,
  Landing,
  Support,
  Privacy,
}
