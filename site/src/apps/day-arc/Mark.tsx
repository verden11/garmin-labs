// The face in miniature: black disc, the window-progress arc across the top, the clock as a bar, and
// the gauge. Echoes the face's own layout (DayArc/DESIGN.md), not the launcher icon placeholder.
export function DayArcMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 64 64" aria-hidden="true">
      <circle cx="32" cy="32" r="32" fill="#000" />
      <path d="M11.087 16.552A26 26 0 0 1 52.913 16.552" fill="none" stroke="#555" strokeWidth="4" strokeLinecap="round" />
      <path d="M11.087 16.552A26 26 0 0 1 32 6" fill="none" stroke="#55ffff" strokeWidth="4" strokeLinecap="round" />
      <rect x="20" y="20" width="24" height="4" rx="2" fill="#aaa" />
      <rect x="22" y="30" width="20" height="8" rx="4" fill="#55ffff" />
      <rect x="18" y="46" width="28" height="4" rx="2" fill="#aaa" />
      <rect x="18" y="46" width="10" height="4" rx="2" fill="#55ffff" />
    </svg>
  )
}
