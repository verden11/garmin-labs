// DayArc Pro's mark: DayArc's face in miniature plus the grid, drawn as small coloured dots in the
// fixed per-icon hues (DayArc/DESIGN.md "Iconography").
export function DayArcProMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 64 64" aria-hidden="true">
      <circle cx="32" cy="32" r="32" fill="#000" />
      <path d="M12.1 17.3A26 26 0 0 1 51.9 17.3" fill="none" stroke="#555" strokeWidth="4" strokeLinecap="round" />
      <path d="M12.1 17.3A26 26 0 0 1 32 6" fill="none" stroke="#55ffff" strokeWidth="4" strokeLinecap="round" />
      <rect x="22" y="18" width="20" height="4" rx="2" fill="#aaa" />
      <rect x="23" y="26" width="18" height="8" rx="4" fill="#55ffff" />
      <rect x="16" y="38" width="32" height="1.5" fill="#555" />
      <circle cx="22" cy="45" r="3" fill="#ff5555" />
      <circle cx="42" cy="45" r="3" fill="#ff5500" />
      <circle cx="22" cy="53" r="3" fill="#55ff55" />
      <circle cx="42" cy="53" r="3" fill="#aa55ff" />
    </svg>
  )
}
