import type { App } from '../types.ts'
import { HeroFaceMark } from './Mark.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'

export const heroface: App = {
  slug: 'heroface',
  name: 'HeroFace',
  title: 'HeroFace — a time-first Garmin watch face',
  summary: 'A watch face that shows the time first and today’s goals underneath.',
  platform: 'Garmin watches · Connect IQ',
  color: '#55aaff',
  onColor: '#0a1420',
  storeName: 'Connect IQ Store',
  storeUrl: 'https://apps.garmin.com/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116',
  ogImage: '/heroface/screens/heroset.png',
  Mark: HeroFaceMark,
  Landing,
  Support,
  Privacy,
}
