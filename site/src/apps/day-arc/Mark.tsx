// The face in miniature: black disc, the window-progress arc across the top, the clock as a bar, and
// the gauge. Echoes the face's own layout (DayArc/DESIGN.md), not the launcher icon placeholder.
export function DayArcMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 64 64" aria-hidden="true">
      <circle cx="32" cy="32" r="32" fill="#000" />
      <path d="M12.1 17.3A26 26 0 0 1 51.9 17.3" fill="none" stroke="#555" strokeWidth="4" strokeLinecap="round" />
      <path d="M12.1 17.3A26 26 0 0 1 32 6" fill="none" stroke="#55ffff" strokeWidth="4" strokeLinecap="round" />
      <rect x="20" y="20" width="24" height="5" rx="2.5" fill="#aaa" />
      <rect x="22" y="31" width="20" height="9" rx="4.5" fill="#55ffff" />
      <rect x="18" y="46" width="28" height="5" rx="2.5" fill="#aaa" />
      <rect x="18" y="46" width="9" height="5" rx="2.5" fill="#55ffff" />
    </svg>
  )
}
