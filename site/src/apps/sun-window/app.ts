import type { App } from '../types.ts'
import { SunWindowMark } from './Mark.tsx'
import { Landing } from './Landing.tsx'
import { Support } from './Support.tsx'
import { Privacy } from './Privacy.tsx'
import { appName } from './facts.ts'

// Not in the store yet: `storeUrl` stays unset (the landing page then says "Coming soon") until Garmin approves the listing and the
// owner supplies the URL. The slug is published in store listings and never changes, even if the name does.
// `platform` starts with "Widget": the site's JSON-LD category follows the first word ('watch app' = HealthApplication, anything
// else LifestyleApplication), which is the right one for an app that says it is for information only.
export const sunWindow: App = {
  slug: 'sun-window',
  name: appName,
  title: `${appName} — is the sun high right now?`,
  summary: 'One word for the sun: OPEN while it is at or above 45 degrees, CLOSED, or NONE TODAY, with today’s window.',
  platform: 'Widget · Connect IQ',
  color: '#55aaff',
  onColor: '#0a1f33',
  storeName: 'Connect IQ Store',
  Mark: SunWindowMark,
  Landing,
  Support,
  Privacy,
}
