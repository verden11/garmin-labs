// A DRAWING of the DayArc faces, not a screenshot: 454 px canvas (the FR965's), example numbers, system
// font. Layout follows DayArc/DESIGN.md "Layout" top to bottom (arc, clock, date, label, icon + value,
// gauge, sub line; Pro: divider + 2-column grid). Icon paths are the real Tabler-derived ones from
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
  steps: glyph(<><path d="M4 6h5.426a1 1 0 0 1 .863 .496l1.064 1.823a3 3 0 0 0 1.896 1.407l4.677 1.114a4 4 0 0 1 3.074 3.89v2.27a1 1 0 0 1 -1 1h-16a1 1 0 0 1 -1 -1v-10a1 1 0 0 1 1 -1" {...stroke('#55FF55', 2.2)} /><path d="M14 13l1 -2M10 12l1.5 -3M8 18v-1a4 4 0 0 0 -4 -4h-1" {...stroke('#55FF55', 2.2)} /></>),
  flame: glyph(<><path fill="#FF5500" d="M10 2c0 -.88 1.056 -1.331 1.692 -.722c1.958 1.876 3.096 5.995 1.75 9.12l-.08 .174l.012 .003c.625 .133 1.203 -.43 2.303 -2.173l.14 -.224a1 1 0 0 1 1.582 -.153c1.334 1.435 2.601 4.377 2.601 6.27c0 4.265 -3.591 7.705 -8 7.705s-8 -3.44 -8 -7.706c0 -2.252 1.022 -4.716 2.632 -6.301l.605 -.589c.241 -.236 .434 -.43 .618 -.624c1.43 -1.512 2.145 -2.924 2.145 -4.78" /><ellipse cx="9.6" cy="16" rx="1.6" ry="2.2" fill="#FFAA55" /></>),
  bell: glyph(<><path fill="#5555FF" d="M12 2c1.358 0 2.506 .903 2.875 2.141l.046 .171l.008 .043a8.013 8.013 0 0 1 4.024 6.069l.028 .287l.019 .289v2.931l.021 .136a3 3 0 0 0 1.143 1.847l.167 .117l.162 .099c.86 .487 .56 1.766 -.377 1.864l-.116 .006h-16c-1.028 0 -1.387 -1.364 -.493 -1.87a3 3 0 0 0 1.472 -2.063l.021 -.143l.001 -2.97a8 8 0 0 1 3.821 -6.454l.248 -.146l.01 -.043a3.003 3.003 0 0 1 2.562 -2.29l.182 -.017l.176 -.004z" /><path fill="#AAAAFF" d="M14.235 19c.865 0 1.322 1.024 .745 1.668a3.992 3.992 0 0 1 -2.98 1.332a3.992 3.992 0 0 1 -2.98 -1.332c-.552 -.616 -.158 -1.579 .634 -1.661l.11 -.006h4.471z" /></>),
  stairs: glyph(<path d="M22 5h-5v5h-5v5h-5v5h-5" {...stroke('#AA55FF', 2.5)} />),
  refresh: glyph(<><path d="M20 11a8.1 8.1 0 0 0 -15.5 -2m-.5 -4v4h4" {...stroke('#FFAA55', 2.5)} /><path d="M4 13a8.1 8.1 0 0 0 15.5 2m.5 4v-4h-4" {...stroke('#FFAA55', 2.5)} /></>),
  breath: glyph(<path d="M21 12h-2c-.894 0 -1.662 -.857 -1.761 -2c-.296 -3.45 -.749 -6 -2.749 -6s-2.5 3.582 -2.5 8s-.5 8 -2.5 8s-2.452 -2.547 -2.749 -6c-.1 -1.147 -.867 -2 -1.763 -2h-2" {...stroke('#55FFFF', 2.3)} />),
  droplet: glyph(<><path fill="#FF55AA" d="M10.708 2.372a2.382 2.382 0 0 0 -.71 .686l-4.892 7.26c-1.981 3.314 -1.22 7.466 1.767 9.882c2.969 2.402 7.286 2.402 10.254 0c2.987 -2.416 3.748 -6.569 1.795 -9.836l-4.919 -7.306c-.722 -1.075 -2.192 -1.376 -3.295 -.686z" /><ellipse cx="9.3" cy="9" rx="2.3" ry="3" fill="#FFAAFF" /></>),
}

// Hero icons: one glyph per window, one hue (the window's accent).
function Hero({ win, x, y, h }: { win: Exclude<Win, 'night'>; x: number; y: number; h: number }) {
  const c = HUE[win]
  if (win === 'midday') {
    return (
      <svg x={x} y={y} width={h} height={h} viewBox="0 0 24 24">
        <path d="M21 12h-2c-.894 0 -1.662 -.857 -1.761 -2c-.296 -3.45 -.749 -6 -2.749 -6s-2.5 3.582 -2.5 8s-.5 8 -2.5 8s-2.452 -2.547 -2.749 -6c-.1 -1.147 -.867 -2 -1.763 -2h-2" {...stroke(c, 2.3)} />
        <circle cx="12" cy="19.8" r="1.7" fill={c} />
      </svg>
    )
  }
  if (win === 'evening') {
    return (
      <svg x={x} y={y + h * 0.1} width={h * 1.4} height={h} viewBox="2 5 20 14">
        <path d="M6 7h11a2 2 0 0 1 2 2v.5a.5 .5 0 0 0 .5 .5a.5 .5 0 0 1 .5 .5v3a.5 .5 0 0 1 -.5 .5a.5 .5 0 0 0 -.5 .5v.5a2 2 0 0 1 -2 2h-11a2 2 0 0 1 -2 -2v-6a2 2 0 0 1 2 -2" {...stroke(c, 1.6)} strokeLinecap="butt" />
        <rect x="7" y="9.5" width="6.2" height="5" rx="1" fill={c} />
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

// Window-progress arc hugging the bezel across the top: dim track, accent fill to `frac`.
function Arc({ color, frac }: { color: string; frac: number }) {
  const r = 208
  const span = 44 // degrees either side of straight up
  const pt = (deg: number) => `${(227 + r * Math.sin((deg * Math.PI) / 180)).toFixed(1)} ${(227 - r * Math.cos((deg * Math.PI) / 180)).toFixed(1)}`
  const end = -span + 2 * span * frac
  return (
    <g fill="none" strokeLinecap="round" strokeWidth="9">
      <path d={`M ${pt(-span)} A ${r} ${r} 0 0 1 ${pt(span)}`} stroke={TRACK} />
      <path d={`M ${pt(-span)} A ${r} ${r} 0 0 1 ${pt(end)}`} stroke={color} />
    </g>
  )
}

const T = (p: { x: number; y: number; size: number; fill: string; w?: number; anchor?: 'start' | 'middle' | 'end'; children: ReactNode }) => (
  <text x={p.x} y={p.y} fontSize={p.size} fill={p.fill} fontWeight={p.w ?? 400} textAnchor={p.anchor ?? 'middle'} fontFamily={font}>{p.children}</text>
)

const label = (win: Win, pro: boolean) => {
  const time = { morning: '7:15', midday: '13:42', evening: '20:05', night: '23:40' }[win]
  const alt = {
    morning: 'a thin amber progress arc, the time, the date, a sun-and-cloud icon beside the temperature 18°, and a line with the day’s high and low, rain chance and UV',
    midday: 'a thin cyan progress arc, the time, the date, the word Stress, a wave icon beside the number 22, and a part-filled gauge',
    evening: 'a thin rose progress arc, the time, the date, the words Body Battery, a battery icon beside the number 64, and a part-filled gauge',
    night: 'only the time and the date, nothing else',
  }[win]
  const grid = pro && win !== 'night' ? ', then a divider and a two-column grid of small icon-and-number fields' : ''
  return `A drawing of the ${pro ? 'Pro ' : ''}face in its ${win} window, ${time}: ${alt}${grid}.`
}

type Cell = [keyof typeof grid | null, string | null, string]
const cells: Record<'morning' | 'midday' | 'evening', Cell[]> = {
  morning: [[null, 'Sunrise', '6:48'], [null, 'Sunset', '19:12'], [null, 'Battery', '72%'], [null, 'HR', '64'], [null, 'Steps', '812'], [null, 'Floors', '2']],
  midday: [['calendar', 'Standup', '2:30'], ['heart', null, '68'], ['steps', null, '6,204'], ['flame', null, '1,180'], ['bell', null, '3'], ['stairs', null, '4']],
  evening: [['refresh', 'Recovery', '18h'], ['breath', null, '14'], ['heart', null, '58'], ['droplet', null, '96'], ['steps', null, '9,310'], ['flame', null, '2,040']],
}

export function DayArcFace({ win = 'midday', pro = false, size = 240, className = 'face' }: { win?: Win; pro?: boolean; size?: number; className?: string }) {
  const night = win === 'night'
  const color = night ? MUTED : HUE[win]
  const time = { morning: '7:15', midday: '13:42', evening: '20:05', night: '23:40' }[win]
  const date = 'Wed, Sep 30'
  const hero = night ? '' : { morning: '18°', midday: '22', evening: '64' }[win]
  const frac = { morning: 0.5, midday: 0.55, evening: 0.45 }[win as Exclude<Win, 'night'>]
  const heroLabel = { midday: 'Stress', evening: 'Body Battery' }[win as 'midday' | 'evening']
  const gauge = { midday: 0.22, evening: 0.64 }[win as 'midday' | 'evening']
  const showGrid = pro && !night

  // Simple is centred in the display; Pro is top-anchored with the grid below (DESIGN.md "Layout").
  const clockY = night ? 245 : showGrid ? 112 : 144
  const hs = showGrid ? 66 : 92 // hero value size
  const ih = showGrid ? 44 : 60 // hero icon height
  const heroY = showGrid ? 232 : 316
  const textW = hero.length * hs * 0.55
  const iconW = win === 'evening' ? ih * 1.4 : win === 'morning' ? ih * 1.25 : ih
  const gap = 14
  const x0 = 227 - (iconW + gap + textW) / 2

  return (
    <svg className={className} width={size} height={size} viewBox="0 0 454 454" role="img" aria-label={label(win, pro)}>
      <circle cx="227" cy="227" r="227" fill="#000" />
      {!night && <Arc color={color} frac={frac} />}
      <T x={227} y={clockY} size={night ? 100 : showGrid ? 58 : 72} fill={night ? '#fff' : MUTED} w={600}>{time}</T>
      <T x={227} y={clockY + (night ? 44 : showGrid ? 30 : 36)} size={night ? 32 : showGrid ? 22 : 26} fill={MUTED}>{date}</T>
      {!night && (
        <>
          {heroLabel && <T x={227} y={clockY + (showGrid ? 62 : 80)} size={showGrid ? 24 : 28} fill={MUTED}>{heroLabel}</T>}
          <Hero win={win as Exclude<Win, 'night'>} x={x0} y={heroY - ih * 0.8} h={ih} />
          <T x={x0 + iconW + gap} y={heroY} size={hs} fill={color} w={700} anchor="start">{hero}</T>
          {gauge !== undefined && (
            <g>
              <rect x={showGrid ? 127 : 117} y={heroY + (showGrid ? 20 : 26)} width={showGrid ? 200 : 220} height={showGrid ? 12 : 14} rx="7" fill={MUTED} />
              <rect x={showGrid ? 127 : 117} y={heroY + (showGrid ? 20 : 26)} width={(showGrid ? 200 : 220) * gauge} height={showGrid ? 12 : 14} rx="7" fill={color} />
            </g>
          )}
          {win === 'evening' && !showGrid && <T x={227} y={heroY + 78} size={26} fill={MUTED}>64 of 100</T>}
          {win === 'morning' && !showGrid && (
            <>
              <T x={227} y={heroY + 40} size={26} fill={MUTED}>High 21° · Low 12°</T>
              <T x={227} y={heroY + 74} size={26} fill={MUTED}>23% rain · UV 4</T>
            </>
          )}
        </>
      )}
      {showGrid && (
        <>
          <line x1="100" x2="354" y1="286" y2="286" stroke={TRACK} strokeWidth="2" />
          {cells[win as 'morning' | 'midday' | 'evening'].map(([icon, lab, val], i) => {
            const col = i % 2
            const y = 326 + Math.floor(i / 2) * 39
            const x = col === 0 ? 82 : 254
            const ic = icon ? grid[icon] : null
            const tx = ic ? x + 32 : x
            return (
              <g key={`${win}-${i}`}>
                {ic && <g transform={`translate(${x} ${y - 22})`}>{ic(26)}</g>}
                {lab && !ic && <T x={x} y={y} size={20} fill={MUTED} anchor="start">{lab}</T>}
                {lab && ic && (
                  <text x={tx} y={y} fontSize="20" fill={MUTED} fontFamily={font}>{lab}<tspan fill="#fff" fontWeight="600" dx="8">{val}</tspan></text>
                )}
                {!(lab && ic) && <T x={ic ? tx : x + 126} y={y} size={21} fill="#fff" w={600} anchor={ic ? 'start' : 'end'}>{val}</T>}
              </g>
            )
          })}
        </>
      )}
    </svg>
  )
}
