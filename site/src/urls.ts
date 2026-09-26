// The only place app URLs are spelled. Store listings link these, so the
// strings this returns must never change (root CLAUDE.md).
export type Section = 'landing' | 'support' | 'privacy'

export function appUrl(slug: string, section: Section = 'landing'): string {
  return section === 'landing' ? `/${slug}/` : `/${slug}/${section}/`
}
