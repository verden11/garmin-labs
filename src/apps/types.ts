import type { ComponentType } from 'react'

export type Screenshot = {
  label: string
  // Path under public/. Missing = render a labelled placeholder slot.
  src?: string
}

export type App = {
  slug: string
  name: string
  // One line: what it is. Used on the studio home and in meta descriptions.
  summary: string
  platform: string
  // The app's field color on the shared grid, plus readable ink on it.
  color: string
  onColor: string
  // Store listing; absent until the app is live.
  storeUrl?: string
  storeName: string
  Mark: ComponentType<{ size?: number }>
  // The app's pictogram set on the studio home; falls back to Mark.
  Emblem?: ComponentType
  Landing: ComponentType
  Support: ComponentType
  Privacy: ComponentType
}
