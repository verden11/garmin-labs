// A DRAWING of the face, not a screenshot: a daytime state at 10:42 in the
// default look (sky accent, noon at the top), a schematic of the layout with
// example numbers: date, time, the Body Battery band (battery glyph, number,
// curve), then the sun sentence, inside the 24-hour ring. Replace it with real
// captures when they exist.
const C = 227 // centre of the 454 viewBox
const R = 209 // ring radius
const W = 12 // ring width
const accent = '#55aaff'
const gone = '#55aaaa' // dim(accent): the watch turns each FF channel of the accent to AA
const font = 'system-ui, sans-serif'

// Minute of the local day to a point on radius r: 24 h ring, noon at the top, clockwise.
const angle = (minute: number) => ((minute - 720) / 1440) * 2 * Math.PI
const xy = (minute: number, r: number): [string, string] => {
  const a = angle(minute)
  return [(C + r * Math.sin(a)).toFixed(3), (C - r * Math.cos(a)).toFixed(3)]
}
const pt = (minute: number, r: number) => xy(minute, r).join(' ')
const arc = (from: number, to: number) =>
  `M${pt(from, R)}A${R} ${R} 0 ${to - from > 720 ? 1 : 0} 1 ${pt(to, R)}`

const sunrise = 6 * 60 + 41
const sunset = 19 * 60 + 23
const now = 10 * 60 + 42

export function FacePreview({ size = 240 }: Readonly<{ size?: number }>) {
  return (
    <svg className="face" width={size} height={size} viewBox="0 0 454 454" role="img"
      aria-label="A drawing of the watch face by day: a ring for the 24 hours with the sun's marker, the time 10:42, a Body Battery curve with its number, and the line 8:41 of daylight.">
      <circle cx={C} cy={C} r={C} fill="#000" />
      <circle cx={C} cy={C} r={R} fill="none" stroke="#5555aa" strokeWidth={W} />
      <path d={arc(sunrise - 40, sunrise)} fill="none" stroke="#aaaaff" strokeWidth={W} />
      <path d={arc(sunset, sunset + 40)} fill="none" stroke="#aaaaff" strokeWidth={W} />
      <path d={arc(sunrise, now)} fill="none" stroke={gone} strokeWidth={W} />
      <path d={arc(now, sunset)} fill="none" stroke={accent} strokeWidth={W} />
      {[sunrise, sunset].map((m) => (
        <path key={m} d={`M${pt(m, R - 14)}L${pt(m, R + 14)}`} stroke="#fff" strokeWidth="4" />
      ))}
      <circle cx={xy(now, R)[0]} cy={xy(now, R)[1]} r={W * 0.9} fill="#fff" />

      <text x={C} y="124" fill="#aaa" fontSize="26" textAnchor="middle" fontFamily={font}>Sat 26 Sep</text>
      <text x={C} y="212" fill="#fff" fontSize="96" textAnchor="middle" fontFamily={font} fontWeight="600">10:42</text>

      {/* Body Battery band: a level pill (DESIGN.md "Glyph" — no nub, changed 2026-09-27; a battery
          shape reads as watch battery regardless of fill colour), then the number, then the curve. */}
      <rect x="126" y="252" width="32" height="18" rx="9" fill="none" stroke="#fff" strokeWidth="3" />
      <rect x="126" y="252" width="20" height="18" rx="9" fill={accent} />
      <text x="166" y="273" fill={accent} fontSize="32" fontFamily={font} fontWeight="600">64</text>
      <path d="M212 274L212 262Q226 250 240 258T268 246T296 262L296 274Z" fill="#5555aa" />
      <path d="M212 262Q226 250 240 258T268 246T296 262" fill="none" stroke="#fff" strokeWidth="3" />
      <circle cx="296" cy="262" r="6" fill={accent} stroke="#000" strokeWidth="3" />

      <text x={C} y="336" fill="#fff" fontSize="30" textAnchor="middle" fontFamily={font}>8:41 of daylight</text>
    </svg>
  )
}
