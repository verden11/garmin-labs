import type { Screenshot } from '../types.ts'

// The name is a WORKING NAME (owner has not confirmed it). It is spelled here
// and nowhere else in this folder: a rename is this one line, plus the slug
// question in NOTES (a published URL never changes, so the slug stays).
export const appName = 'Two Suns'

// Mirrors TwoSuns/resources (14 machine-drafted languages) and docs/release-contract.md; update together.
// There is deliberately no watch list or watch count here: the store's list is
// shorter than the manifest's, and the app is not live yet.
// Simulator captures, each framed in the watch it ran on: the store listings' sets (TwoSuns/listing*/screens-framed, docker/frame_listing.sh),
// resized to 560 px in public/two-suns/watch/. Example numbers; the simulator's data is canned.
export const screens: Screenshot[] = [
  { label: 'By day', src: '/two-suns/watch/day.png', watch: 'fēnix 8 Pro' },
  { label: 'Golden hour', src: '/two-suns/watch/golden-hour.png', watch: 'epix Pro' },
  { label: 'After sunset', src: '/two-suns/watch/evening.png', watch: 'Venu 3' },
  { label: 'Two Suns (free)', src: '/two-suns/watch/free.png', watch: 'Forerunner 970' },
  { label: 'Instinct', src: '/two-suns/watch/instinct.png', watch: 'Instinct E' },
]

export const languages = [
  'English', 'Dansk', 'Deutsch', 'Español', 'Français', 'Italiano', 'Lietuvių', 'Nederlands',
  'Norsk bokmål', 'Polski', 'Português', 'Suomi', 'Svenska', 'Türkçe', 'Українська',
]

// Mirrors TwoSuns/manifest.xml. Positioning is confirmed (TwoSuns/docs/decisions.md
// ADR-005, 2026-09-27). If it is ever dropped: delete its entry here and the
// "Location" paragraph in Privacy.tsx (see TwoSuns/listing/NOTES.md).
export const permissions: [string, string][] = [
  ['Sensor history', 'to read your Body Battery for the last 24 hours, for the curve and the number.'],
  ['Complications', 'to read the watch’s own sunrise and sunset values and its current Body Battery value.'],
  ['Positioning', 'to read the last location the watch already knows, so the face can place the sun.'],
]
