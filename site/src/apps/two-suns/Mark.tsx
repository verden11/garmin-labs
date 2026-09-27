// The face in miniature on its own black disc: the 24-hour ring (night, then
// daylight) and the sun's marker. The disc keeps it legible on any field colour.
export function TwoSunsMark({ size = 32 }: { size?: number }) {
  return (
    <svg className="app-mark" width={size} height={size} viewBox="0 0 64 64" aria-hidden="true">
      <circle cx="32" cy="32" r="32" fill="#000" />
      <circle cx="32" cy="32" r="24" fill="none" stroke="#5555aa" strokeWidth="5" />
      <path d="M9.45 23.8A24 24 0 0 1 54.55 23.8" fill="none" stroke="#ffaa00" strokeWidth="5" />
      <circle cx="32" cy="8" r="5" fill="#fff" />
      <path d="M17 44Q26 36 32 40T47 33" fill="none" stroke="#fff" strokeWidth="3" strokeLinecap="round" />
    </svg>
  )
}
