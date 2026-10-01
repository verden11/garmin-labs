// The face in miniature on its own black disc (like the other face marks): a ring part drained, and
// one number. The disc keeps the mint ring and the white number legible on Days To Go's mint field.
export function DaysToGoMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 64 64" aria-hidden="true">
      <circle cx="32" cy="32" r="32" fill="#000" />
      <circle cx="32" cy="32" r="25" fill="none" stroke="#555" strokeWidth="4" />
      <path d="M32 7A25 25 0 1 1 9.8 43.5" fill="none" stroke="#55ffaa" strokeWidth="4" strokeLinecap="round" />
      <text x="32" y="40.5" fill="#fff" fontSize="24" fontWeight="700" textAnchor="middle" fontFamily="system-ui, sans-serif">97</text>
    </svg>
  )
}
