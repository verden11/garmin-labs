import { DayArcFace, type Win } from './FaceDrawing.tsx'

export function FacePreview({ size = 240, win = 'midday' }: { size?: number; win?: Win }) {
  return <DayArcFace win={win} size={size} />
}
