// Same shield as the watch launcher icon (HeroSet resources/drawables/launcher_icon.svg).
export function HeroSetMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="4 3 57 59" aria-hidden="true">
      <path d="M10 13L32.5 7L55 13L52 36Q50 47 32.5 58Q15 47 13 36Z" fill="#ffaa00" />
      <path d="M14.5 16L32.5 11L50.5 16L48 35Q46.5 43.5 32.5 53Q18.5 43.5 17 35Z" fill="#000" />
      <path d="M21 20H28V28H37V20H44L42 39L37 43V37L32.5 33L28 37V43L23 39Z" fill="#ffaa00" />
    </svg>
  )
}
