// The name is a WORKING NAME (owner has not confirmed it). It is spelled here
// and nowhere else in this folder: a rename is this one line, plus the slug
// question in NOTES (a published URL never changes, so the slug stays).
export const appName = 'Two Suns'

// Mirrors TwoSuns/resources (14 machine-drafted languages) and docs/release-contract.md; update together.
// There is deliberately no watch list or watch count here: the store's list is
// shorter than the manifest's, and the app is not live yet.
export const languages = [
  'English', 'Dansk', 'Deutsch', 'Español', 'Français', 'Italiano', 'Lietuvių', 'Nederlands',
  'Norsk bokmål', 'Polski', 'Português', 'Suomi', 'Svenska', 'Türkçe', 'Українська',
]

// Mirrors TwoSuns/manifest.xml. PROVISIONAL: Positioning is declared until the
// on-watch location probes report. If it is dropped: delete its entry here and
// the "Location" paragraph in Privacy.tsx (see TwoSuns/listing/NOTES.md).
export const permissions: [string, string][] = [
  ['Sensor history', 'to read your Body Battery for the last 24 hours, for the curve and the number.'],
  ['Complications', 'to read the watch’s own sunrise and sunset values and its current Body Battery value.'],
  ['Positioning', 'to read the last location the watch already knows, so the face can place the sun.'],
]
