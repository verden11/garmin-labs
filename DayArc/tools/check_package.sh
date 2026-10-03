#!/bin/bash
# Check the COMPILED packages (not the source): the Instinct parts carry no settings file (the Accent setting is hidden
# there, ADR-015) and every other part still has the Accent setting. Exports both densities first with --build.
# Usage: tools/check_package.sh [--build] [simple.iq pro.iq]      (defaults dist/DayArcSimple.iq, dist/DayArcPro.iq)
set -u
cd "$(dirname "$0")/.." || exit 2
KEY=${KEY:-$HOME/.garmin-connectiq/keys/developer_key}
mkdir -p bin dist
if [ "${1:-}" = "--build" ]; then
  shift
  monkeyc -e -r -f monkey.simple.jungle -o dist/DayArcSimple.iq -y "$KEY" -w > bin/export-simple.log 2>&1 || { tail -5 bin/export-simple.log; exit 2; }
  monkeyc -e -r -f monkey.pro.jungle -o dist/DayArcPro.iq -y "$KEY" -w > bin/export-pro.log 2>&1 || { tail -5 bin/export-pro.log; exit 2; }
fi
SIMPLE=${1:-dist/DayArcSimple.iq}; PRO=${2:-dist/DayArcPro.iq}
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
for pkg in "$SIMPLE" "$PRO"; do [ -f "$pkg" ] || { echo "missing $pkg (run with --build)"; exit 2; }; done
mkdir -p "$WORK/simple" "$WORK/pro"
bsdtar -xf "$SIMPLE" -C "$WORK/simple" && bsdtar -xf "$PRO" -C "$WORK/pro" || exit 2
DEVICES=${CIQ_DEVICES:-$HOME/Library/Application\ Support/Garmin/ConnectIQ/Devices}
python3 - "$WORK" "$DEVICES" <<'PY'
import glob, json, os, re, sys
work, devices = sys.argv[1:3]
INSTINCT = ["instincte40mm", "instincte45mm", "instinct3solar45mm"]
instinct = set()
for pid in INSTINCT:
    instinct |= {p["number"] for p in json.load(open(os.path.join(devices, pid, "compiler.json")))["partNumbers"]}
problems = []
for density in ("simple", "pro"):
    root = os.path.join(work, density)
    manifest = open(root + "/manifest.xml").read()
    parts = set(re.findall(r'<iq:product [^>]*partNumber="([^"]+)"', manifest))
    have = {}
    for f in glob.glob(root + "/*/*-settings.json"):
        have[os.path.basename(f).split("-settings.json")[0]] = [s["key"] for s in json.load(open(f))["settings"]]
    for part in sorted(parts):
        if part in instinct and part in have:
            problems.append(f"{density}: Instinct part {part} has a settings file {have[part]} (Accent must be hidden)")
        if part not in instinct and have.get(part) != ["Accent"]:
            problems.append(f"{density}: part {part} settings {have.get(part)}, expected ['Accent']")
    if not instinct & parts:
        problems.append(f"{density}: no Instinct part in the package (the check was never exercised)")
    print(f"{density}: {len(parts)} part numbers, {len(instinct & parts)} Instinct without settings, {len(parts) - len(instinct & parts)} with Accent")
if problems:
    print("FAIL"); [print(" ", p) for p in problems[:20]]; sys.exit(1)
print("OK")
PY
