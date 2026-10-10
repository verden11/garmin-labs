import type { App } from './types.ts'
import { heroset } from './heroset/app.ts'
import { heroface } from './heroface/app.ts'
import { daysToGo } from './days-to-go/app.ts'
import { twoSuns } from './two-suns/app.ts'
import { dayArc } from './day-arc/app.ts'
import { dayArcPro } from './day-arc-pro/app.ts'
import { sunWindow } from './sun-window/app.ts'

// Add an app: create src/apps/<slug>/ exporting an App, then list it here.
export const apps: App[] = [heroset, heroface, daysToGo, twoSuns, dayArc, dayArcPro, sunWindow]
