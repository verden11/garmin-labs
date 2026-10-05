# Edge states of a watch face, for a design review (simulator only, never device proof): awake, always-on at two minutes
# (to see the burn-in drift), and the heat map's 24-hour burn-in verdict. A scenario for docker/capture.sh:
#   docker/capture.sh <project> /ciq-docker/edge_states.sh <jungle> <device> ["YYYY-MM-DD HH:MM:SS"] [tag]
# Writes /work/bin/edge/<tag>-<device>-{1-awake,2-aod,3-aod-next,4-burnin}.png in the project (bin/ is untracked).
JUNGLE=${1:?jungle}; DEV=${2:?device}; WHEN=${3:-2026-10-04 10:10:00}; TAG=${4:-edge}
OUT=/work/bin/edge; mkdir -p $OUT; P=$OUT/$TAG-$DEV
sim_boot "$WHEN"; rm -f /tmp/com.garmin.connectiq/GARMIN/APPS/SETTINGS/*.SET /tmp/app-settings.json
sim_load "$JUNGLE" "$DEV"; sim_24h; sleep 5
sim_save $P-1-awake.png
sim_always_on; sim_save $P-2-aod.png
sleep 65; sim_save $P-3-aod-next.png
sim_burnin_24h $P-4-burnin.png
echo "edge done $TAG $DEV"
