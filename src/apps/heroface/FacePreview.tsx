// The face drawn at a glance: ring, time, three mission bars, footer. Same
// geometry as the watch (HeroFace source/HeroFaceLayout.mc), so the page shows
// the real thing rather than a mock-up.
type Props = { size?: number; heroset?: boolean }

export function FacePreview({ size = 220, heroset = false }: Props) {
  const accent = heroset ? '#ffaa00' : '#55aaff'
  const bars = heroset
    ? [{ w: 0.37, done: false, label: 'PUSH', value: '37' }, { w: 0.52, done: false, label: 'SIT', value: '52' }, { w: 1, done: true, label: 'SQT', value: '100' }]
    : [{ w: 0.84, done: false, label: 'STEPS', value: '8420' }, { w: 0.81, done: false, label: 'INT', value: '18' }, { w: 1, done: true, label: 'FLR', value: '10' }]
  const top = heroset ? 'RANK 4' : 'WED 30 SEP'
  const under = heroset ? 'STREAK 12' : 'STREAK 12'
  return (
    <svg className="face" width={size} height={size} viewBox="0 0 454 454" role="img"
      aria-label={heroset
        ? 'The watch face showing rank, the time, and push-ups, sit-ups and squats as bars.'
        : 'The watch face showing the date, the time, and steps, intensity minutes and floors as bars.'}>
      <circle cx="227" cy="227" r="227" fill="#000" />
      <path d="M60 373A218 218 0 1 1 394 373" fill="none" stroke="#555" strokeWidth="7" strokeLinecap="round" />
      <path d={heroset ? 'M60 373A218 218 0 0 1 130 55' : 'M60 373A218 218 0 0 1 340 40'}
        fill="none" stroke={accent} strokeWidth="7" strokeLinecap="round" />
      <text x="227" y="80" fill="#aaa" fontSize="30" textAnchor="middle" fontFamily="system-ui, sans-serif">{top}</text>
      <text x="227" y="205" fill="#fff" fontSize="128" textAnchor="middle" fontFamily="system-ui, sans-serif" fontWeight="600">10:42</text>
      <text x="90" y="250" fill="#ffaa00" fontSize="30" fontFamily="system-ui, sans-serif">{under}</text>
      <text x="364" y="250" fill="#aaa" fontSize="30" textAnchor="end" fontFamily="system-ui, sans-serif">18°</text>
      {bars.map((bar, i) => {
        const x = 86 + i * 116
        return (
          <g key={bar.label}>
            <text x={x + 48} y="292" fill="#fff" fontSize="30" textAnchor="middle" fontFamily="system-ui, sans-serif">{bar.value}</text>
            <rect x={x} y="302" width="96" height="15" rx="7.5" fill="#555" />
            <rect x={x} y="302" width={96 * bar.w} height="15" rx="7.5" fill={bar.done ? '#00ff00' : accent} />
            <text x={x + 48} y="352" fill={bar.done ? '#00ff00' : '#aaa'} fontSize="27" textAnchor="middle" fontFamily="system-ui, sans-serif">{bar.label}</text>
          </g>
        )
      })}
      <text x="227" y="400" fill="#aaa" fontSize="27" textAnchor="middle" fontFamily="system-ui, sans-serif">84   ♥ 62</text>
    </svg>
  )
}
