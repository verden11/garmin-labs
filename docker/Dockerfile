# Connect IQ build + simulator images. Adapted from github.com/matco/connectiq-tester.
#   target "build": monkeyc only, native on the host CPU (arm64 on Apple Silicon): compiles, sweeps.
#   target "sim":   + Xvfb + simulator, linux/amd64 only (the Linux simulator is an x86-64 ELF;
#                   Rosetta/QEMU on Apple Silicon): tests.
# Build both with docker/build.sh.
# jammy (22.04) is the newest base that works for "sim": the simulator links libwebkit2gtk-4.0 + libsoup-2.4,
# which Ubuntu 24.04 dropped (it only has 4.1/libsoup3).
FROM ubuntu:jammy AS build

ARG CIQ_SDK_VERSION=9.2.0
ENV DEBIAN_FRONTEND=noninteractive CIQ_HOME=/connectiq KEY=/keys/developer_key
ENV PATH=${PATH}:/connectiq/bin

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl jq unzip openjdk-17-jre-headless procps \
    && rm -rf /var/lib/apt/lists/*

# SDK straight from Garmin's public manifest (no login). Pinned by CIQ_SDK_VERSION.
RUN set -e; base=https://developer.garmin.com/downloads/connect-iq/sdks; \
    file=$(curl -fsS $base/sdks.json | jq -r --arg v "$CIQ_SDK_VERSION" '.[] | select(.version==$v) | .linux'); \
    test -n "$file"; curl -fsSL "$base/$file" -o /tmp/sdk.zip; \
    unzip -q /tmp/sdk.zip -d $CIQ_HOME; rm /tmp/sdk.zip; chmod +x $CIQ_HOME/bin/*

# Device + font files: hard-coded paths in compiler and simulator. Garmin's property, from
# the owner's own SDK Manager install, passed as a named build context (never pushed anywhere).
COPY --from=ciq Devices /root/.Garmin/ConnectIQ/Devices
COPY --from=ciq Fonts /root/.Garmin/ConnectIQ/Fonts

WORKDIR /work
CMD ["bash"]

FROM build AS sim
ENV DISPLAY=:1
# simulator needs webkit2gtk, libusb, libsm6 and a fake display (xvfb)
RUN apt-get update && apt-get install -y --no-install-recommends \
      libwebkit2gtk-4.0-37 libusb-1.0-0 libsm6 xvfb \
    && rm -rf /var/lib/apt/lists/*
