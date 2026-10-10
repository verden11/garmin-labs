# Sun Window spike probe

Throwaway (plan P1.1). Same source, two manifests' worth of build:

| Build | Manifest `type` | App id | App name | `.prg` (git-ignored) |
|---|---|---|---|---|
| watch-app variant (wrist-tested 2026-10-05) | `watch-app` | `a1b2c3d4-0000-4000-8000-000000000016` | SW Probe | `device-test/SunWindowProbe-fr965.prg` |
| widget variant (this folder's current `manifest.xml`) | `widget` | `a1b2c3d4-0000-4000-8000-000000000018` | SW Widget | `device-test/SunWindowWidgetProbe-fr965.prg` |

To rebuild the watch-app variant: set `type="watch-app"`, the first id and `SW Probe` in `resources/strings/strings.xml`.
Build: `CIQ_IMAGE=verden-ciq-build:9.2.0 docker/run.sh "research_notes/Sun Window build plan/probe" monkeyc -d fr965 -f monkey.jungle -o bin/<name>.prg -y /keys/developer_key -w --typecheck 3`.
Simulator run: `docker/capture.sh "research_notes/Sun Window build plan/probe" tools/open_full_view.sh fr965`.
Results: `SunWindow/docs/status.md` (device checks).
