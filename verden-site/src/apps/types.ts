import type { ComponentType } from 'react'

export type Screenshot = {
  label: string
  // Path under public/. Missing = render a labelled placeholder slot.
  src?: string
  // Actual pixel size of the file at `src`. Defaults to 454 (the common
  // simulator capture size) when omitted — set explicitly for any shot
  // captured at a different size so width/height attributes stay accurate.
  size?: number
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
  // Path under public/, used for og:image / twitter:image on this app's pages.
  ogImage?: string
  Mark: ComponentType<{ size?: number }>
  // The app's pictogram set on the studio home; falls back to Mark.
  Emblem?: ComponentType
  Landing: ComponentType
  Support: ComponentType
  Privacy: ComponentType
}
