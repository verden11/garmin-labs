// The watch face in miniature: the bezel ring, its progress, and the bars.
export function HeroFaceMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 64 64" aria-hidden="true">
      <path d="M13 52A27 27 0 1 1 51 52" fill="none" stroke="#555" strokeWidth="5" strokeLinecap="round" />
      <path d="M13 52A27 27 0 0 1 32 6" fill="none" stroke="#55aaff" strokeWidth="5" strokeLinecap="round" />
      <rect x="18" y="26" width="28" height="6" rx="3" fill="#fff" />
      <rect x="18" y="37" width="18" height="5" rx="2.5" fill="#55aaff" />
      <rect x="18" y="45" width="28" height="5" rx="2.5" fill="#00ff00" />
    </svg>
  )
}
