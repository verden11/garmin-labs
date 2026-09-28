// The face in miniature: a black disc, an arc for the day, a dot marking "now" — DayArc's own
// launcher icon motif (DayArc/resources/drawables/launcher_icon.svg), reused here.
export function DayArcMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 65 65" aria-hidden="true">
      <circle cx="32.5" cy="32.5" r="32.5" fill="#000" />
      <path d="M8 46A24.5 24.5 0 0 1 57 46" fill="none" stroke="#55ffff" strokeWidth="5" strokeLinecap="round" />
      <circle cx="44" cy="30" r="4" fill="#fff" />
    </svg>
  )
}
