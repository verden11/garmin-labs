import type { App } from '../types.ts'
import { HeroFaceMark } from './Mark.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'

export const heroface: App = {
  slug: 'heroface',
  name: 'HeroFace',
  summary: 'A watch face that shows the time first and today’s goals underneath.',
  platform: 'Garmin watches · Connect IQ',
  color: '#55aaff',
  onColor: '#0a1420',
  storeName: 'Connect IQ Store',
  // storeUrl: set once the listing is live.
  Mark: HeroFaceMark,
  Landing,
  Support,
  Privacy,
}
