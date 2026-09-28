// A DRAWING of the face, not a screenshot: the midday window, schematic layout with example
// numbers — window-progress arc, clock, date, a hero icon beside the value, a two-tier gauge, the
// empty-state-free sub line (ADR-013). Replace with a real capture when one exists
// (DayArc/docs/plan.md "Not done").
const font = 'system-ui, sans-serif'
const accent = '#55ffff'

export function FacePreview({ size = 240 }: { size?: number }) {
  return (
    <svg className="face" width={size} height={size} viewBox="0 0 300 300" role="img"
      aria-label="A drawing of the watch face at midday: a thin progress arc across the top, the time 13:42, the date, the word Stress, a small wave icon beside the number 22, a mostly-full gauge, and no mood word.">
      <circle cx="150" cy="150" r="150" fill="#000" />
      <path d="M 60 68 A 100 100 0 0 1 240 68" fill="none" stroke={accent} strokeWidth="4" strokeLinecap="round" />
      <text x="150" y="78" fill="#fff" fontSize="36" textAnchor="middle" fontFamily={font} fontWeight="600">13:42</text>
      <text x="150" y="100" fill="#aaa" fontSize="13" textAnchor="middle" fontFamily={font}>Wed, Sep 30</text>
      <text x="150" y="128" fill="#aaa" fontSize="18" textAnchor="middle" fontFamily={font}>Stress</text>
      <path d="M133 176c-2-10 12-10 10 0-1 5 5 8 8 3M151 179c2 5-4 8-5 3" fill="none" stroke={accent} strokeWidth="2.5" strokeLinecap="round" transform="translate(-38 -8) scale(1.1)" />
      <text x="160" y="186" fill={accent} fontSize="56" textAnchor="middle" fontFamily={font} fontWeight="600">22</text>
      <rect x="70" y="210" width="160" height="14" rx="7" fill="#aaa" />
      <rect x="70" y="210" width="35" height="14" rx="7" fill={accent} />
      <text x="150" y="250" fill="#aaa" fontSize="15" textAnchor="middle" fontFamily={font}>No mood word — just the number.</text>
    </svg>
  )
}
