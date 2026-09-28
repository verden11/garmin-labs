// A DRAWING of the face, not a screenshot: the midday window with the secondary field grid —
// window-progress arc, clock, date, a hero icon beside the value, a gauge, and a grid of six
// fields each with its own small fixed-colour icon dot (ADR-013). Replace with a real capture when
// one exists.
const font = 'system-ui, sans-serif'
const accent = '#55ffff'
// Fixed per-type hues from DayArc/DESIGN.md's icon colour table (ADR-013) — schematic dots here
// stand in for the real Tabler-icon glyphs actually drawn on-device.
const cells: [string, string, string][] = [
  ['Next event', '2:30 PM', '#55aaff'],
  ['HR', '68', '#ff5555'],
  ['Floors', '4', '#aa55ff'],
  ['Steps', '6,204', '#55ff55'],
  ['Cal', '1,180', '#ff5500'],
  ['Notif', '3', '#5555ff'],
]

export function FacePreview({ size = 240 }: { size?: number }) {
  return (
    <svg className="face" width={size} height={size} viewBox="0 0 300 300" role="img"
      aria-label="A drawing of the watch face at midday: a thin progress arc, the time, the date, the word Stress, a number and gauge with a small wave icon, and a grid of six smaller fields below it, each with its own coloured icon dot.">
      <circle cx="150" cy="150" r="150" fill="#000" />
      <path d="M 62 62 A 105 105 0 0 1 238 62" fill="none" stroke={accent} strokeWidth="3.5" strokeLinecap="round" />
      <text x="150" y="66" fill="#fff" fontSize="26" textAnchor="middle" fontFamily={font} fontWeight="600">13:42</text>
      <text x="150" y="84" fill="#aaa" fontSize="11" textAnchor="middle" fontFamily={font}>Wed, Sep 30</text>
      <text x="150" y="106" fill="#aaa" fontSize="14" textAnchor="middle" fontFamily={font}>Stress</text>
      <circle cx="126" cy="132" r="6" fill="none" stroke={accent} strokeWidth="2" />
      <text x="160" y="140" fill={accent} fontSize="38" textAnchor="middle" fontFamily={font} fontWeight="600">22</text>
      <rect x="90" y="156" width="120" height="10" rx="5" fill="#aaa" />
      <rect x="90" y="156" width="26" height="10" rx="5" fill={accent} />
      {cells.map(([label, value, dot], i) => {
        const col = i % 2
        const row = Math.floor(i / 2)
        const x = col === 0 ? 44 : 156
        const y = 190 + row * 32
        return (
          <g key={label}>
            <circle cx={x - 10} cy={y - 4} r="4" fill={dot} />
            <text x={x} y={y} fill="#aaa" fontSize="13" fontFamily={font}>{label}</text>
            <text x={x + 100} y={y} fill="#fff" fontSize="13" fontFamily={font} textAnchor="end">{value}</text>
          </g>
        )
      })}
    </svg>
  )
}
