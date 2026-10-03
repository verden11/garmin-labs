// A DRAWING of the DayArc faces, not a screenshot: 454 px canvas (the FR965's), example numbers, system
// font. Positions are measured from an owner simulator screenshot of the Pro evening window on the
// FR965 (2026-10-01) and DayArc/DESIGN.md "Layout": arc, clock, date, label, icon + value, gauge,
// sub line; Pro adds a divider and a 2-column grid of as many rows as fit (two on an FR965). Icon paths are the real Tabler-derived ones from
// DayArc/resources/drawables/icons and resources-pro/drawables/icons, hues from DESIGN.md's tables.
// Replace with real simulator/wrist captures when they exist (DayArc/listing/screenshots.md).
import type { ReactNode } from 'react'

export type Win = 'morning' | 'midday' | 'evening' | 'night'

const font = 'system-ui, -apple-system, sans-serif'
const MUTED = '#aaa'
const TRACK = '#555'
const HUE = { morning: '#ffaa00', midday: '#55ffff', evening: '#ff55aa' } as const

// 24x24 Tabler glyphs, grid hue per icon TYPE (DESIGN.md "Iconography"). `s` = drawn size in px.
const stroke = (c: string, w: number) => ({ fill: 'none', stroke: c, strokeWidth: w, strokeLinecap: 'round', strokeLinejoin: 'round' }) as const
type G = (s: number) => ReactNode
const glyph = (body: ReactNode): G => (s) => <svg width={s} height={s} viewBox="0 0 24 24" overflow="visible">{body}</svg>
const grid: Record<string, G> = {
  calendar: glyph(<><path fill="#55AAFF" d="M16 2a1 1 0 0 1 .993 .883l.007 .117v1h1a3 3 0 0 1 2.995 2.824l.005 .176v12a3 3 0 0 1 -2.824 2.995l-.176 .005h-12a3 3 0 0 1 -2.995 -2.824l-.005 -.176v-12a3 3 0 0 1 2.824 -2.995l.176 -.005h1v-1a1 1 0 0 1 1.993 -.117l.007 .117v1h6v-1a1 1 0 0 1 1 -1m3 8h-14v8.625c0 .705 .386 1.286 .883 1.366l.117 .009h12c.513 0 .936 -.53 .993 -1.215l.007 -.16zm-9 4a1 1 0 0 1 1 1v2a1 1 0 0 1 -1 1h-2a1 1 0 0 1 -1 -1v-2a1 1 0 0 1 1 -1z" /><ellipse cx="8" cy="4.5" rx="2.2" ry="1.6" fill="#AAFFFF" /></>),
  heart: glyph(<><path fill="#FF5555" d="M6.979 3.074a6 6 0 0 1 4.988 1.425l.037 .033l.034 -.03a6 6 0 0 1 4.733 -1.44l.246 .036a6 6 0 0 1 3.364 10.008l-.18 .185l-.048 .041l-7.45 7.379a1 1 0 0 1 -1.313 .082l-.094 -.082l-7.493 -7.422a6 6 0 0 1 3.176 -10.215z" /><ellipse cx="8.3" cy="6.2" rx="3" ry="2.3" fill="#FFAAAA" /></>),
  steps: glyph(<><path d="M4 6h5.426a1 1 0 0 1 .863 .496l1.064 1.823a3 3 0 0 0 1.896 1.407l4.677 1.114a4 4 0 0 1 3.074 3.89v2.27a1 1 0 0 1 -1 1h-16a1 1 0 0 1 -1 -1v-10a1 1 0 0 1 1 -1" {...stroke('#55FF55', 2)} /><path d="M14 13l1 -2M10 12l1.5 -3M8 18v-1a4 4 0 0 0 -4 -4h-1" {...stroke('#55FF55', 2)} /></>),
  flame: glyph(<><path fill="#FF5500" d="M10 2c0 -.88 1.056 -1.331 1.692 -.722c1.958 1.876 3.096 5.995 1.75 9.12l-.08 .174l.012 .003c.625 .133 1.203 -.43 2.303 -2.173l.14 -.224a1 1 0 0 1 1.582 -.153c1.334 1.435 2.601 4.377 2.601 6.27c0 4.265 -3.591 7.705 -8 7.705s-8 -3.44 -8 -7.706c0 -2.252 1.022 -4.716 2.632 -6.301l.605 -.589c.241 -.236 .434 -.43 .618 -.624c1.43 -1.512 2.145 -2.924 2.145 -4.78" /><ellipse cx="9.6" cy="16" rx="1.6" ry="2.2" fill="#FFAA55" /></>),
  bell: glyph(<><path fill="#5555FF" d="M12 2c1.358 0 2.506 .903 2.875 2.141l.046 .171l.008 .043a8.013 8.013 0 0 1 4.024 6.069l.028 .287l.019 .289v2.931l.021 .136a3 3 0 0 0 1.143 1.847l.167 .117l.162 .099c.86 .487 .56 1.766 -.377 1.864l-.116 .006h-16c-1.028 0 -1.387 -1.364 -.493 -1.87a3 3 0 0 0 1.472 -2.063l.021 -.143l.001 -2.97a8 8 0 0 1 3.821 -6.454l.248 -.146l.01 -.043a3.003 3.003 0 0 1 2.562 -2.29l.182 -.017l.176 -.004z" /><path fill="#AAAAFF" d="M14.235 19c.865 0 1.322 1.024 .745 1.668a3.992 3.992 0 0 1 -2.98 1.332a3.992 3.992 0 0 1 -2.98 -1.332c-.552 -.616 -.158 -1.579 .634 -1.661l.11 -.006h4.471z" /></>),
  bolt: glyph(<path fill="#FFFF55" d="M13 2l.018 .001l.016 .001l.083 .005l.011 .002h.011l.038 .009l.052 .008l.016 .006l.011 .001l.029 .011l.052 .014l.019 .009l.015 .004l.028 .014l.04 .017l.021 .012l.022 .01l.023 .015l.031 .017l.034 .024l.018 .011l.013 .012l.024 .017l.038 .034l.022 .017l.008 .01l.014 .012l.036 .041l.026 .027l.006 .009c.12 .147 .196 .322 .218 .513l.001 .012l.002 .041l.004 .064v6h5a1 1 0 0 1 .868 1.497l-.06 .091l-8 11c-.568 .783 -1.808 .38 -1.808 -.588v-6h-5a1 1 0 0 1 -.868 -1.497l.06 -.091l8 -11l.01 -.013l.018 -.024l.033 -.038l.018 -.022l.009 -.008l.013 -.014l.04 -.036l.028 -.026l.008 -.006a1 1 0 0 1 .402 -.199l.011 -.001l.027 -.005l.074 -.013l.011 -.001l.041 -.002z" />),
  stairs: glyph(<path d="M22 5h-5v5h-5v5h-5v5h-5" {...stroke('#AA55FF', 2)} />),
  refresh: glyph(<><path d="M20 11a8.1 8.1 0 0 0 -15.5 -2m-.5 -4v4h4" {...stroke('#FFAA55', 2)} /><path d="M4 13a8.1 8.1 0 0 0 15.5 2m.5 4v-4h-4" {...stroke('#FFAA55', 2)} /></>),
  breath: glyph(<path d="M21 12h-2c-.894 0 -1.662 -.857 -1.761 -2c-.296 -3.45 -.749 -6 -2.749 -6s-2.5 3.582 -2.5 8s-.5 8 -2.5 8s-2.452 -2.547 -2.749 -6c-.1 -1.147 -.867 -2 -1.763 -2h-2" {...stroke('#55FFFF', 2)} />),
  sunrise: glyph(<><path d="M3 17h1m16 0h1m-15.4 -6.4l.7 .7m12.1 -.7l-.7 .7m-9.7 5.7a4 4 0 0 1 8 0" {...stroke('#FFAA00', 2)} /><path d="M3 21l18 0M12 9v-6l3 3m-6 0l3 -3" {...stroke('#FFAA00', 2)} /></>),
  sunset: glyph(<><path d="M3 17h1m16 0h1m-15.4 -6.4l.7 .7m12.1 -.7l-.7 .7m-9.7 5.7a4 4 0 0 1 8 0" {...stroke('#FF5500', 2)} /><path d="M3 21l18 0M12 3v6l3 -3m-6 0l3 3" {...stroke('#FF5500', 2)} /></>),
  battery: glyph(<path d="M6 7h11a2 2 0 0 1 2 2v.5a.5 .5 0 0 0 .5 .5a.5 .5 0 0 1 .5 .5v3a.5 .5 0 0 1 -.5 .5a.5 .5 0 0 0 -.5 .5v.5a2 2 0 0 1 -2 2h-11a2 2 0 0 1 -2 -2v-6a2 2 0 0 1 2 -2" {...stroke('#AAFF55', 2)} />),
  droplet: glyph(<><path fill="#FF55AA" d="M10.708 2.372a2.382 2.382 0 0 0 -.71 .686l-4.892 7.26c-1.981 3.314 -1.22 7.466 1.767 9.882c2.969 2.402 7.286 2.402 10.254 0c2.987 -2.416 3.748 -6.569 1.795 -9.836l-4.919 -7.306c-.722 -1.075 -2.192 -1.376 -3.295 -.686z" /><ellipse cx="9.3" cy="9" rx="2.3" ry="3" fill="#FFAAFF" /></>),
}

// Hero icons: one glyph per window, one hue (the window's accent).
function Hero({ win, x, y, h }: { win: Exclude<Win, 'night'>; x: number; y: number; h: number }) {
  const c = HUE[win]
  if (win === 'midday') {
    return (
      <svg x={x} y={y} width={h} height={h} viewBox="0 0 24 24">
        <path d="M21 12h-2c-.894 0 -1.662 -.857 -1.761 -2c-.296 -3.45 -.749 -6 -2.749 -6s-2.5 3.582 -2.5 8s-.5 8 -2.5 8s-2.452 -2.547 -2.749 -6c-.1 -1.147 -.867 -2 -1.763 -2h-2" {...stroke(c, 2)} />
        <circle cx="12" cy="20" r="2.5" fill={c} />
      </svg>
    )
  }
  if (win === 'evening') {
    // Battery shell + heartbeat line, drawn at the bitmap's own 60x42 px (1 unit = 1 px): one hue, no level, no bolt.
    return (
      <svg x={x} y={y + (h - 42) / 2} width={60} height={42} viewBox="0 0 60 42">
        <rect x="3" y="6" width="48" height="30" rx="9" fill="none" stroke={c} strokeWidth="6" />
        <rect x="54" y="15" width="6" height="12" fill={c} />
        <path d="M12 21H19L24 14L32 28L37 21H44" {...stroke(c, 4)} />
      </svg>
    )
  }
  return (
    <svg x={x} y={y} width={h * 1.25} height={h} viewBox="0 0 30 24">
      <g fill={c}>
        <path d="M10.04 4.305c2.195 -.667 4.615 -.224 6.36 1.176c1.386 1.108 2.188 2.686 2.252 4.34l.003 .212l.091 .003c2.3 .107 4.143 1.961 4.25 4.27l.004 .211c0 2.407 -1.885 4.372 -4.255 4.482l-.21 .005h-11.878l-.222 -.008c-2.94 -.11 -5.317 -2.399 -5.43 -5.263l-.005 -.216c0 -2.747 2.08 -5.01 4.784 -5.417l.114 -.016l.07 -.181c.663 -1.62 2.056 -2.906 3.829 -3.518l.244 -.08z" />
        <path d="M12 7a5 5 0 1 1 -4.995 5.217l-.005 -.217l.005 -.217a5 5 0 0 1 4.995 -4.783z" />
        <path d="M12 2a1 1 0 0 1 .993 .883l.007 .117v1a1 1 0 0 1 -1.993 .117l-.007 -.117v-1a1 1 0 0 1 1 -1z" />
        <path d="M19.107 4.893a1 1 0 0 1 .083 1.32l-.083 .094l-.7 .7a1 1 0 0 1 -1.497 -1.32l.083 -.094l.7 -.7a1 1 0 0 1 1.414 0z" />
        <path d="M21 11a1 1 0 0 1 .117 1.993l-.117 .007h-1a1 1 0 0 1 -.117 -1.993l.117 -.007h1z" />
        <path d="M18.313 16.91l.094 .083l.7 .7a1 1 0 0 1 -1.32 1.497l-.094 -.083l-.7 -.7a1 1 0 0 1 1.218 -1.567l.102 .07z" />
      </g>
    </svg>
  )
}

// Window-progress arc hugging the bezel across the top (140 degrees, DayArcConfig.ARC_SPAN_DEGREES):
// dim track, accent fill to `frac`.
function Arc({ color, frac }: { color: string; frac: number }) {
  const r = 214
  const span = 70 // degrees either side of straight up
  const pt = (deg: number) => `${(227 + r * Math.sin((deg * Math.PI) / 180)).toFixed(3)} ${(227 - r * Math.cos((deg * Math.PI) / 180)).toFixed(3)}`
  const end = -span + 2 * span * frac
  return (
    <g fill="none" strokeLinecap="round" strokeWidth="8">
      <path d={`M ${pt(-span)} A ${r} ${r} 0 0 1 ${pt(span)}`} stroke={TRACK} />
      <path d={`M ${pt(-span)} A ${r} ${r} 0 0 1 ${pt(end)}`} stroke={color} />
    </g>
  )
}

const T = (p: { x: number; y: number; size: number; fill: string; w?: number; anchor?: 'start' | 'middle' | 'end'; children: ReactNode }) => (
  <text x={p.x} y={p.y} fontSize={p.size} fill={p.fill} fontWeight={p.w ?? 400} textAnchor={p.anchor ?? 'middle'} fontFamily={font}>{p.children}</text>
)

const times = { morning: '7:15', midday: '13:42', evening: '20:05', night: '23:40' }

const describe = (win: Win, pro: boolean) => {
  const alt = {
    morning: 'a thin amber progress arc, the time, the date, a sun-and-cloud icon beside the temperature 18°, and a line with the day’s high and low, rain chance and UV',
    midday: 'a thin cyan progress arc, the time, the date, the word Stress, a wave icon beside the number 22, and a part-filled curved gauge',
    evening: 'a thin rose progress arc, the time, the date, the words Body Battery, a battery-with-heartbeat icon beside the number 64, a part-filled curved gauge' + (pro ? '' : ' and the line 64 of 100'),
    night: 'only the time and the date, nothing else',
  }[win]
  const grid = pro && win !== 'night' ? ', then a grid of small icon-and-number fields in rounded pills, some beside the date' : ''
  return `A drawing of the ${pro ? 'Pro ' : ''}face in its ${win} window, ${times[win]}: ${alt}${grid}.`
}

// Fields in priority order. The first two icon-only fields take the upper corners beside the date (room
// the clock rows leave free); the rest fill the grid rows, as many as fit (two on an FR965). A label is
// at most about four letters: a cell is ~150 px wide and each letter ~16 px (DayArc strings.xml).
type Cell = [keyof typeof grid | null, string | null, string]
const cells: Record<'morning' | 'midday' | 'evening', Cell[]> = {
  morning: [['sunrise', null, '6:48'], ['sunset', null, '19:12'], ['battery', null, '72%'], ['heart', null, '64'], ['steps', null, '812'], ['stairs', null, '2'], ['bell', null, '3']],
  midday: [['heart', null, '68'], ['stairs', null, '4'], ['calendar', 'Next', '2:30'], ['bolt', 'Int', '24'], ['steps', null, '812'], ['flame', null, '640']],
  evening: [['heart', null, '58'], ['steps', null, '812'], ['refresh', 'Rec', '18'], ['breath', 'Resp', '14'], ['flame', null, '640'], ['droplet', null, '96%']],
}

const GRID_FONT = 28
const GUTTER = 18
const PAD = 7 // pill padding, left and right
const PILL_H = 37 // the cell font's box (DayArcLayout.pillHeight)
// The smile (DayArcLayout): the gauge is an arc of this circle, 44 per mille deep, and grid pills lift onto it.
const GAUGE_W = 381
const GAUGE_PEN = 13
const SAG = 20
const GAUGE_R = ((GAUGE_W / 2) ** 2 + SAG ** 2) / (2 * SAG)
const lift = (dx: number) => GAUGE_R - Math.sqrt(GAUGE_R ** 2 - dx ** 2)
const LIFT_BUDGET = lift(218 / 3)
// Estimated width of a cell (icon + label + value) in this system font: ~0.58 em per character.
const cellWidth = ([icon, label, value]: Cell) => (icon ? 29 : 0) + (label ? label.length * 15.5 + 8 : 0) + value.length * 16.2

// One cell in its pill: icon, then the muted label (if any), then the white value; x is the content's left
// edge, y the text baseline.
function GridCell({ cell, x, y }: { cell: Cell; x: number; y: number }) {
  const [icon, label, value] = cell
  const ic = icon ? grid[icon] : null
  return (
    <g>
      <rect x={x - PAD} y={y - 27} width={cellWidth(cell) + 2 * PAD} height={PILL_H} rx={PILL_H / 2} fill="none" stroke={TRACK} strokeWidth="2" />
      {ic && <g transform={`translate(${x} ${y - 23})`}>{ic(24)}</g>}
      <text x={x + (ic ? 29 : 0)} y={y} fontSize={GRID_FONT} fontFamily={font}>
        {label && <tspan fill={MUTED}>{label}</tspan>}
        <tspan fill="#fff" dx={label ? 8 : 0}>{value}</tspan>
      </text>
    </g>
  )
}

export function DayArcFace({ win = 'midday', pro = false, size = 240, className = 'face' }: { win?: Win; pro?: boolean; size?: number; className?: string }) {
  const night = win === 'night'
  const color = night ? MUTED : HUE[win]
  const date = 'Wed 30' // the watch's own short date string, as the simulator and the wrist show it ("Fri 02")
  const hero = night ? '' : { morning: '18°', midday: '22', evening: '64' }[win]
  const frac = night ? 0 : { morning: 0.5, midday: 0.55, evening: 0.45 }[win]
  const heroLabel = { midday: 'Stress', evening: 'Body Battery' }[win as 'midday' | 'evening']
  const gauge = { midday: 0.22, evening: 0.64 }[win as 'midday' | 'evening']
  const subLines = night ? [] : { morning: ['High 21° · Low 12°', '23% rain · UV 4'], midday: [], evening: pro ? [] : ['64 of 100'] }[win]
  const showGrid = pro && !night

  // Pro is top-anchored (the grid takes what is left); Simple is vertically centred (DESIGN.md "Layout").
  const dy = night ? 0 : showGrid ? 0 : { morning: 30, midday: 56, evening: 41 }[win]
  const clockY = night ? 245 : 97 + dy
  const heroY = 262 + dy - (heroLabel ? 0 : 20)
  const hs = 90
  const ih = 48
  const iconW = win === 'evening' ? ih * 1.25 : win === 'morning' ? ih * 1.25 : ih
  const textW = hero.length * hs * 0.56
  const gap = 14
  const x0 = 227 - (iconW + gap + textW) / 2
  const gaugeY = heroY + 8
  // The smile: its lowest centre-line point sits SAG + pen/2 below the box top; the ends one cap short of the width.
  const gaugeLow = gaugeY + SAG + GAUGE_PEN / 2
  const gaugeCy = gaugeLow - GAUGE_R
  const half = GAUGE_W / 2 - GAUGE_PEN / 2
  const onSmile = (x: number) => `${x.toFixed(3)} ${(gaugeCy + Math.sqrt(GAUGE_R ** 2 - (x - 227) ** 2)).toFixed(3)}`
  const subY = (heroLabel ? gaugeY + SAG + GAUGE_PEN : heroY) + 36
  const bottom = subLines.length ? subY + (subLines.length - 1) * 34 + 10 : heroLabel ? gaugeY + SAG + GAUGE_PEN : heroY
  const lowY = bottom + 4 + LIFT_BUDGET // top of the centre-most pill, first row
  const ROW = PILL_H + 4
  const rows = showGrid ? Math.min(2, Math.max(0, 1 + Math.floor((427 - (lowY + PILL_H)) / ROW))) : 0
  const all = showGrid ? cells[win as 'morning' | 'midday' | 'evening'] : []
  const corners = all.slice(0, 2)
  const shown = all.slice(corners.length, corners.length + rows * 2)

  return (
    <svg className={className} width={size} height={size} viewBox="0 0 454 454" role="img" aria-label={describe(win, pro)}>
      <circle cx="227" cy="227" r="227" fill="#000" />
      {!night && <Arc color={color} frac={frac} />}
      <T x={227} y={clockY} size={night ? 104 : 64} fill={night ? '#fff' : MUTED} w={night ? 600 : 500}>{times[win]}</T>
      <T x={227} y={clockY + (night ? 46 : 35)} size={night ? 34 : 28} fill={MUTED}>{date}</T>
      {!night && (
        <>
          {heroLabel && <T x={227} y={clockY + 79} size={28} fill={MUTED}>{heroLabel}</T>}
          <Hero win={win as Exclude<Win, 'night'>} x={x0} y={heroY - ih} h={ih} />
          <T x={x0 + iconW + gap} y={heroY} size={hs} fill={color} w={500} anchor="start">{hero}</T>
          {gauge !== undefined && (
            <g fill="none" strokeLinecap="round" strokeWidth={GAUGE_PEN}>
              <path d={`M ${onSmile(227 - half)} A ${GAUGE_R} ${GAUGE_R} 0 0 0 ${onSmile(227 + half)}`} stroke={MUTED} />
              <path d={`M ${onSmile(227 - half)} A ${GAUGE_R} ${GAUGE_R} 0 0 0 ${onSmile(227 - half + 2 * half * gauge)}`} stroke={color} />
            </g>
          )}
          {corners.map((cell, i) => <GridCell key={`corner-${i}`} cell={cell} x={i === 0 ? 57 : 397 - cellWidth(cell)} y={clockY + 35} />)}
          {subLines.map((line, i) => <T key={line} x={227} y={subY + i * 34} size={28} fill={MUTED}>{line}</T>)}
        </>
      )}
      {showGrid && (
        <>
          {Array.from({ length: Math.ceil(shown.length / 2) }, (_, row) => {
            const top = lowY + row * ROW
            const [l, r] = [shown[row * 2], shown[row * 2 + 1]]
            // Each row is a centred pair of pills on the smile: the left ends at the gutter, the right starts after it.
            const lx = 227 - GUTTER / 2 - PAD - (l ? cellWidth(l) : 0)
            const rx = 227 + GUTTER / 2 + PAD
            return (
              <g key={`${win}-${row}`}>
                {l && <GridCell cell={l} x={lx} y={top - Math.min(lift(227 - lx - cellWidth(l) / 2), LIFT_BUDGET) + 27} />}
                {r && <GridCell cell={r} x={rx} y={top - Math.min(lift(rx + cellWidth(r) / 2 - 227), LIFT_BUDGET) + 27} />}
              </g>
            )
          })}
        </>
      )}
    </svg>
  )
}
