// The app in miniature: black disc, the horizon, the dashed 45-degree line and the sun's path over it with the window in sky blue
// and the sun disc on it. Echoes the app's own picture (SunWindow/DESIGN.md), not the launcher icon placeholder.
export function SunWindowMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 64 64" aria-hidden="true">
      <circle cx="32" cy="32" r="32" fill="#000" />
      <path d="M10 44H54" fill="none" stroke="#555" strokeWidth="3" />
      <path d="M12 24H52" fill="none" stroke="#aaa" strokeWidth="1.5" strokeDasharray="3 3" />
      <path d="M12 44Q32 4 52 44" fill="none" stroke="#555" strokeWidth="3" />
      <path d="M22 26Q32 14 42 26" fill="none" stroke="#55aaff" strokeWidth="6" />
      <circle cx="32" cy="19" r="5" fill="#55aaff" />
    </svg>
  )
}
