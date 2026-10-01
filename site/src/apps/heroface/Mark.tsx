// The watch face in miniature on its own black disc (like the other face marks): the bezel ring, its
// progress, and the bars. The disc keeps the blue arc legible on HeroFace's own blue field colour.
export function HeroFaceMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 64 64" aria-hidden="true">
      <circle cx="32" cy="32" r="32" fill="#000" />
      <path d="M15.6 50.6A25 25 0 1 1 48.4 50.6" fill="none" stroke="#777" strokeWidth="4" strokeLinecap="round" />
      <path d="M15.6 50.6A25 25 0 0 1 32 7" fill="none" stroke="#55aaff" strokeWidth="4" strokeLinecap="round" />
      <rect x="19" y="25" width="26" height="6" rx="3" fill="#fff" />
      <rect x="19" y="35" width="26" height="5" rx="2.5" fill="#55aaff" />
      <rect x="19" y="43" width="26" height="5" rx="2.5" fill="#00ff00" />
    </svg>
  )
}
