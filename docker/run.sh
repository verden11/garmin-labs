#!/bin/bash
# Run a command in a fresh container: own simulator, own network namespace, so any number can run at once.
# Usage: docker/run.sh <project-dir> <cmd...>    e.g. docker/run.sh DayArc /ciq-docker/ciq-test.sh fr965
# CIQ_IMAGE=verden-ciq-build:9.2.0 for native-speed builds/sweeps (no simulator); default is the simulator image.
set -e
PROJ=$(cd "${1:?usage: run.sh <project-dir> <cmd...>}" && pwd); shift
IMG=${CIQ_IMAGE:-verden-ciq:9.2.0}
command -v docker >/dev/null || { echo "docker not found: install Docker Desktop or OrbStack (or CIQ_DOCKER=0 for the host simulator)" >&2; exit 127; }
docker image inspect "$IMG" >/dev/null 2>&1 || { echo "image $IMG missing: run docker/build.sh once" >&2; exit 127; }
KEYS=${CIQ_KEYS:-$HOME/.garmin-connectiq/keys}
exec docker run --rm --platform "$(docker image inspect -f '{{.Os}}/{{.Architecture}}' "$IMG")" \
  ${MC_FLAGS+-e MC_FLAGS} ${EXPECT+-e EXPECT} ${CIQ_TZ:+-e TZ=$CIQ_TZ} ${CIQ_FAKETIME:+-e CIQ_FAKETIME} \
  -v "$PROJ":/work -v "$(cd "$(dirname "$0")" && pwd)":/ciq-docker:ro -v "$KEYS":/keys:ro \
  -w /work "$IMG" "${@:-bash}"
