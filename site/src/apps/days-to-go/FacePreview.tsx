// The face drawn at a glance: time, name, the number, caption, date, and the
// ring. Same rows as the watch (DaysToGo source/DaysToGoLayout.mc), so the page
// shows the real thing rather than a mock-up.
export function FacePreview({ size = 240 }: { size?: number }) {
  const accent = '#55ffaa'
  return (
    <svg className="face" width={size} height={size} viewBox="0 0 454 454" role="img"
      aria-label="The watch face showing the time, an event called Race, 97 days, and the date.">
      <circle cx="227" cy="227" r="227" fill="#000" />
      <circle cx="227" cy="227" r="211" fill="none" stroke="#555" strokeWidth="11" />
      <path d="M227 16A211 211 0 1 1 30 300" fill="none" stroke={accent} strokeWidth="11" strokeLinecap="round" />
      <text x="227" y="100" fill="#fff" fontSize="52" textAnchor="middle" fontFamily="system-ui, sans-serif">10:42</text>
      <text x="227" y="150" fill={accent} fontSize="34" textAnchor="middle" fontFamily="system-ui, sans-serif">Race</text>
      <text x="227" y="270" fill="#fff" fontSize="150" textAnchor="middle" fontFamily="system-ui, sans-serif" fontWeight="600">97</text>
      <text x="227" y="318" fill="#aaa" fontSize="34" textAnchor="middle" fontFamily="system-ui, sans-serif">DAYS</text>
      <text x="227" y="362" fill="#aaa" fontSize="30" textAnchor="middle" fontFamily="system-ui, sans-serif">Sat 26 Dec</text>
    </svg>
  )
}
