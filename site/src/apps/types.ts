import type { ComponentType } from 'react'

export type Screenshot = {
  label: string
  // Path under public/. Missing = render a labelled placeholder slot.
  src?: string
  // Pixel size of the file at `src`; 560 (a watch-framed capture, public/<slug>/watch/) when omitted.
  size?: number
  // The watch it is shown on, for the alt text ("Forerunner 965").
  watch?: string
}

export type App = {
  slug: string
  name: string
  // One line: what it is. Used on the studio home and in meta descriptions.
  summary: string
  // The landing page's <title>: short, since search results cut at ~60.
  title: string
  platform: string
  // The app's field color on the shared grid, plus readable ink on it.
  color: string
  onColor: string
  // Store listing; absent until the app is live. With freeStoreUrl set, storeUrl is the Pro listing ("<name> Pro").
  storeUrl?: string
  // The free twin's listing (Free + Pro ladder): the store button splits into the two tiers.
  freeStoreUrl?: string
  storeName: string
  // Path under public/, used as og:image / twitter:image on this app's landing page.
  ogImage?: string
  Mark: ComponentType<{ size?: number }>
  // The app's pictogram set on the studio home; falls back to Mark.
  Emblem?: ComponentType
  Landing: ComponentType
  Support: ComponentType
  Privacy: ComponentType
}
