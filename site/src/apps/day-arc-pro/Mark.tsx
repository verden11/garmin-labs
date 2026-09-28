// DayArc Pro's own launcher icon motif: the same arc and dot as DayArc, plus the ticks that mark
// the denser grid underneath (DayArc/resources-pro/drawables/launcher_icon_pro.svg), reused here.
export function DayArcProMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 65 65" aria-hidden="true">
      <circle cx="32.5" cy="32.5" r="32.5" fill="#000" />
      <path d="M8 46A24.5 24.5 0 0 1 57 46" fill="none" stroke="#55ffff" strokeWidth="5" strokeLinecap="round" />
      <circle cx="44" cy="30" r="4" fill="#fff" />
      <circle cx="20" cy="38" r="2" fill="#aaa" />
      <circle cx="32.5" cy="22" r="2" fill="#aaa" />
    </svg>
  )
}
