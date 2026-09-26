import type { App } from './types.ts'
import { heroset } from './heroset/app.ts'
import { heroface } from './heroface/app.ts'
import { daysToGo } from './days-to-go/app.ts'

// Add an app: create src/apps/<slug>/ exporting an App, then list it here.
export const apps: App[] = [heroset, heroface, daysToGo]
