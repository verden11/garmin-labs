// The face in miniature: a ring part drained, and one number.
export function DaysToGoMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 64 64" aria-hidden="true">
      <circle cx="32" cy="32" r="27" fill="none" stroke="#555" strokeWidth="5" />
      <path d="M32 5A27 27 0 1 1 8 44" fill="none" stroke="#55ffaa" strokeWidth="5" strokeLinecap="round" />
      <text x="32" y="41" fill="#fff" fontSize="26" fontWeight="700" textAnchor="middle" fontFamily="system-ui, sans-serif">97</text>
    </svg>
  )
}
