// The watch launcher icon's shield (HeroSet resources/drawables/launcher_icon.svg), regridded for the page:
// whole-number vertices on an even grid, mirrored about x=32, so every straight edge lands on a pixel at
// the 32 and 96 px sizes. The launcher icon keeps its own 65 px grid.
export function HeroSetMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 64 64" aria-hidden="true">
      <path d="M4 8L32 2L60 8L56 36Q54 50 32 62Q10 50 8 36Z" fill="#ffaa00" />
      <path d="M10 12L32 6L54 12L50 36Q50 46 32 56Q14 46 14 36Z" fill="#000" />
      <path d="M18 18H28V28H36V18H46L44 40L36 46V36L32 32L28 36V46L20 40Z" fill="#ffaa00" />
    </svg>
  )
}
