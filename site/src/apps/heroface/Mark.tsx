// The watch face in miniature on its own black disc (like the other face marks): the bezel ring, its
// progress, and the bars. The disc keeps the blue arc legible on HeroFace's own blue field colour.
export function HeroFaceMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 64 64" aria-hidden="true">
      <circle cx="32" cy="32" r="32" fill="#000" />
      <path d="M15.466 50.752A25 25 0 1 1 48.534 50.752" fill="none" stroke="#777" strokeWidth="4" strokeLinecap="round" />
      <path d="M15.466 50.752A25 25 0 0 1 32 7" fill="none" stroke="#55aaff" strokeWidth="4" strokeLinecap="round" />
      <rect x="20" y="26" width="24" height="6" rx="3" fill="#fff" />
      <rect x="20" y="36" width="24" height="4" rx="2" fill="#55aaff" />
      <rect x="20" y="44" width="24" height="4" rx="2" fill="#00ff00" />
    </svg>
  )
}
