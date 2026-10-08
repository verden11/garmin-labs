import type { App } from '../types.ts'
import { HeroFaceMark } from './Mark.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'

export const heroface: App = {
  slug: 'heroface',
  name: 'HeroFace',
  title: 'HeroFace — a time-first Garmin watch face',
  summary: 'A watch face with the time large and today’s goals beneath it.',
  platform: 'Watch face · Connect IQ',
  color: '#55aaff',
  onColor: '#0a1420',
  storeName: 'Connect IQ Store',
  storeUrl: 'https://apps.garmin.com/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116',   // HeroFace Pro
  freeStoreUrl: 'https://apps.garmin.com/apps/890dd680-20e6-4205-b9bf-cd98ea02849d',   // HeroFace (free), uploaded 2026-10-04
  ogImage: '/heroface/watch/everyday.png',
  Mark: HeroFaceMark,
  Landing,
  Support,
  Privacy,
}
