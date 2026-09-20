import type { CSSProperties } from 'react'

// Two-pose figures on a 64-unit grid, drawn as cut bars with gaps at the joints.
// The CSS flips between pose "a" (top of the rep) and "b" (bottom) in discrete steps.
type Pose = { head: [number, number]; bars: string[] }

const figures: Record<'pushup' | 'situp' | 'squat', { a: Pose; b: Pose }> = {
  pushup: {
    a: { head: [52, 31], bars: ['M5 55 L24 47', 'M27 46 L44 39', 'M43 43 L43 57'] },
    b: { head: [53, 44], bars: ['M5 55 L24 52', 'M27 51 L45 48', 'M43 51 L43 57'] },
  },
  situp: {
    a: { head: [7, 49], bars: ['M13 53 L33 53', 'M36 52 L43 41 M44 42 L52 55'] },
    b: { head: [20, 22], bars: ['M22 30 L32 50', 'M36 52 L43 41 M44 42 L52 55', 'M25 35 L38 38'] },
  },
  squat: {
    a: { head: [32, 8], bars: ['M32 16 L32 34', 'M32 37 L32 57', 'M34 20 L47 20'] },
    b: { head: [38, 22], bars: ['M35 29 L26 41', 'M27 44 L40 44 M41 46 L41 57', 'M38 32 L52 32'] },
  },
}

function Figure({ pose, className }: { pose: Pose; className: string }) {
  return (
    <g className={className}>
      <circle cx={pose.head[0]} cy={pose.head[1]} r="5.5" />
      {pose.bars.map((d) => <path key={d} d={d} />)}
    </g>
  )
}

export function Emblem() {
  return (
    <span className="emblem" aria-hidden="true">
      {(['pushup', 'situp', 'squat'] as const).map((kind) => (
        <svg key={kind} viewBox="0 0 64 57"><Figure pose={figures[kind][kind === 'situp' ? 'b' : 'a']} className="" /></svg>
      ))}
    </span>
  )
}

export function RepCounter({ kind, label, start, tempo }: { kind: keyof typeof figures; label: string; start: number; tempo: number }) {
  const style = { '--start': start, '--tempo': `${tempo}s`, '--left': 100 - start } as CSSProperties
  return (
    <figure className="rep" style={style}>
      <svg viewBox="0 0 64 57" className="rep__figure">
        <Figure pose={figures[kind].a} className="rep__a" />
        <Figure pose={figures[kind].b} className="rep__b" />
      </svg>
      <figcaption>
        <span className="rep__count"><span className="rep__n" />/100</span>
        <span className="rep__label">{label}<span className="rep__done"> done</span></span>
      </figcaption>
    </figure>
  )
}
