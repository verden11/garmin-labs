#!/bin/bash
# Build both images. Needs the SDK Manager's ConnectIQ folder (Devices/ + Fonts/) on this machine.
set -e
CIQ=${CIQ_DATA:-"$HOME/Library/Application Support/Garmin/ConnectIQ"}
[ -d "$CIQ/Devices" ] || CIQ="$HOME/.Garmin/ConnectIQ"
cd "$(dirname "$0")"
docker build --target sim   --platform linux/amd64 --build-context ciq="$CIQ" -t verden-ciq:9.2.0 .
docker build --target build                        --build-context ciq="$CIQ" -t verden-ciq-build:9.2.0 .
docker build --target shots --platform linux/amd64 --build-context ciq="$CIQ" -t verden-ciq-shots:9.2.0 .
