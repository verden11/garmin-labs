import { DayArcFace, type Win } from '../day-arc/FaceDrawing.tsx'

export function FacePreview({ size = 240, win = 'midday' }: { size?: number; win?: Win }) {
  return <DayArcFace win={win} pro size={size} />
}
