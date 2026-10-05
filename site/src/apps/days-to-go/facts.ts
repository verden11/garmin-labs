import type { Screenshot } from '../types.ts'

// Mirrors DaysToGo/docs/compatibility.md and docs/release-contract.md; update together.
// There is deliberately no watch list or watch count here: the store's list is
// shorter than the manifest's, and the app is not live yet (release contract).
// Simulator captures, each framed in the watch it ran on: the store listings' sets (DaysToGo/listing*/screens-framed, docker/frame_listing.sh),
// resized to 560 px in public/days-to-go/watch/. Example numbers; the simulator's data is canned.
export const screens: Screenshot[] = [
  { label: 'Days', src: '/days-to-go/watch/days.png', watch: 'Venu 3' },
  { label: 'Weeks and days', src: '/days-to-go/watch/weeks.png', watch: 'Forerunner 265' },
  { label: 'Today', src: '/days-to-go/watch/today.png', watch: 'epix Pro' },
  { label: 'To the minute (Pro)', src: '/days-to-go/watch/to-the-minute.png', watch: 'Venu 4' },
  { label: 'Instinct', src: '/days-to-go/watch/instinct.png', watch: 'Instinct 2' },
]

export const languages = [
  'English', 'Dansk', 'Deutsch', 'Español', 'Français', 'Italiano', 'Lietuvių', 'Nederlands',
  'Norsk bokmål', 'Polski', 'Português', 'Suomi', 'Svenska', 'Türkçe', 'Українська',
]
