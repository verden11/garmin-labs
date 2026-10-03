#!/bin/bash
# Check the COMPILED store packages (not the source files): the Free .iq must ship none of the Pro settings keys
# and no "Pro" word, and the Pro .iq must ship them. Exits non-zero on any failure.
# Usage: tools/check_free_package.sh [--build] [free.iq] [pro.iq]
#   --build   first run `monkeyc -e -r` for both jungles (about 2 minutes each; compile only, no simulator)
#   defaults  dist/DaysToGoFree.iq (Free) and dist/DaysToGoPro.iq (Pro)
# A package older than any source, jungle, manifest or resource file is STALE and fails: rebuild with --build.
# Method (docs/development.md "Checking a store package"): a .iq is a 7-zip archive. Per part number it holds the
# compiled .prg, a <part>-settings.json (the settings the phone renders: keys, list options, and every
# string in every language) and one manifest.xml. This script extracts it and checks, for every part number:
#   Free: the settings KEYS are exactly the Free set and the Accent list is ids 0-5; the word "Pro" appears nowhere
#         (manifest, settings strings in every language, compiled .prg); no .prg contains the property names Hour or
#         Footer as standalone strings; AppName is "Days To Go" in every language.
#   Pro:  the settings keys are the full set including Hour and Footer; every .prg contains those two names and the
#         string "Days To Go Pro" (positive controls: they prove the Free checks can see what they look for);
#         AppName is "Days To Go Pro" in every language.
#   Both: the app ids are the expected, different ones; no permissions; the part numbers equal the SDK's part
#         numbers for the manifest's 127 product ids (one SDK part number may be absent, reported, not failed).
# NOT proven: that the Hour/Footer display strings (setting_hour, footer_*, h0-h23) are absent. They live in the
# shared strings and still ship, unreferenced, in Free. Nor does it prove behaviour on a watch.
set -u
cd "$(dirname "$0")/.." || exit 2
mkdir -p bin dist
KEY=${KEY:-$HOME/.garmin-connectiq/keys/developer_key}
if [ "${1:-}" = "--build" ]; then
  shift
  monkeyc -e -r -f monkey.free.jungle -o dist/DaysToGoFree.iq -y "$KEY" > bin/export-free.log 2>&1 || { tail -5 bin/export-free.log; exit 2; }
  monkeyc -e -r -f monkey.jungle -o dist/DaysToGoPro.iq -y "$KEY" > bin/export-pro.log 2>&1 || { tail -5 bin/export-pro.log; exit 2; }
fi
FREE=${1:-dist/DaysToGoFree.iq}
PRO=${2:-dist/DaysToGoPro.iq}
for pkg in "$FREE" "$PRO"; do [ -f "$pkg" ] || { echo "missing $pkg (run with --build)"; exit 2; }; done
stale=0
for pkg in "$FREE" "$PRO"; do
  newer=$(find source monkey.jungle monkey.free.jungle manifest.xml manifest.free.xml resources resources-* -type f -newer "$pkg" | head -3)
  if [ -n "$newer" ]; then echo "STALE: $pkg is older than: $(echo $newer | tr '\n' ' ')... (rebuild with --build)"; stale=1; fi
done
[ "$stale" -eq 0 ] || exit 1
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
extract() {  # extract <package> <dir>
  mkdir -p "$2"
  if command -v bsdtar > /dev/null; then bsdtar -xf "$1" -C "$2"
  elif command -v 7z > /dev/null; then 7z x -y -o"$2" "$1" > /dev/null
  else echo "need bsdtar or 7z to open a .iq"; return 1; fi
}
extract "$FREE" "$WORK/free" && extract "$PRO" "$WORK/pro" || exit 2
FREE_ID=$(grep -o '<iq:application id="[^"]*"' manifest.free.xml | sed 's/.*id="//; s/"//' | tr -d -)
PRO_ID=$(grep -o '<iq:application id="[^"]*"' manifest.xml | sed 's/.*id="//; s/"//' | tr -d -)
DEVICES=${CIQ_DEVICES:-$HOME/Library/Application Support/Garmin/ConnectIQ/Devices}
python3 - "$WORK/free" "$WORK/pro" "$FREE_ID" "$PRO_ID" "$DEVICES" <<'PY'
import glob, json, os, re, sys
free_dir, pro_dir, free_id, pro_id, devices = sys.argv[1:6]
FREE_KEYS = ["Event", "Name", "Month", "Day", "Year", "Unit", "DateStyle", "Accent"]
PRO_ONLY = ["Hour", "Footer"]
PRO_KEYS = ["Event", "Name", "Month", "Day", "Year", "Hour", "Unit", "DateStyle", "Footer", "Accent"]
# The Instinct family (ADR-015) has no Accent setting: a 1-bit display cannot show one. Its part numbers are read from
# the SDK so the check can tell an Instinct part's settings file from a round one's.
INSTINCT = ["instinct2", "instinct2s", "instinct2x", "descentg1", "instincte40mm", "instincte45mm", "instinct3solar45mm"]
problems = []

def fail(msg):
    problems.append(msg)

def instinct_parts(devices):
    """Part numbers of the Instinct products, from the SDK's device files; empty when the SDK files are missing."""
    parts = set()
    for pid in INSTINCT:
        path = os.path.join(devices, pid, "compiler.json")
        if os.path.exists(path):
            parts |= {p["number"] for p in json.load(open(path))["partNumbers"]}
    return parts

def settings_files(root):
    files = sorted(glob.glob(root + "/*/*-settings.json"))
    if not files:
        fail(f"{root}: no settings.json files found in the package")
    return files

def word(pattern, data):
    return re.search(pattern, data) is not None

def check(root, tier, app_name, keys, app_id, instinct):
    manifest = open(root + "/manifest.xml").read()
    ids = re.findall(r'<iq:application[^>]* id="([^"]+)"', manifest)
    if ids != [app_id]:
        fail(f"{tier}: manifest app id {ids}, expected {app_id}")
    if re.search(r"<iq:uses-permission", manifest):
        fail(f"{tier}: manifest declares permissions")
    products = len(re.findall(r"<iq:product ", manifest))
    files = settings_files(root)
    if len(files) != products:
        fail(f"{tier}: {len(files)} settings files for {products} products")
    for path in files:
        data = json.load(open(path))
        got = [s["key"] for s in data["settings"]]
        part = os.path.basename(path).split("-settings.json")[0]
        wanted = [k for k in keys if k != "Accent"] if part in instinct else keys
        if got != wanted:
            fail(f"{tier}: {path}: keys {got}, expected {wanted}")
        if part not in instinct:
            accent = [s for s in data["settings"] if s["key"] == "Accent"][0]
            if [o["value"] for o in accent["configOptions"]] != list(range(6)):
                fail(f"{tier}: {path}: Accent ids are not 0-5")
        for lang, strings in data["languages"].items():
            if strings.get("AppName") != app_name:
                fail(f"{tier}: {path}: language {lang} AppName is {strings.get('AppName')!r}, expected {app_name!r}")
    return products, len(files)

def check_part_numbers(root, tier):
    """Part numbers in the package must be the SDK's part numbers for the manifest's product ids."""
    ids = re.findall(r'<iq:product id="([^"]+)"', open("manifest.xml").read())
    if len(ids) != 127:
        fail(f"manifest.xml lists {len(ids)} product ids, expected 127")
    expected = set()
    for pid in ids:
        path = os.path.join(devices, pid, "compiler.json")
        if not os.path.exists(path):
            print(f"note: {path} not found; part-number check skipped")
            return
        expected |= {p["number"] for p in json.load(open(path))["partNumbers"]}
    got = set(re.findall(r'partNumber="([^"]+)"', open(root + "/manifest.xml").read()))
    if not got <= expected:
        fail(f"{tier}: part numbers not in the manifest's products: {sorted(got - expected)[:5]}")
    if expected - got:
        print(f"note: {tier} lacks {len(expected - got)} of the SDK's {len(expected)} part numbers for the 127 products: {sorted(expected - got)}")

instinct = instinct_parts(devices)
if not instinct:
    print("note: SDK device files not found; the Instinct parts cannot be told apart, so the Accent checks will fail")
free_products, free_files = check(free_dir, "FREE", "Days To Go", FREE_KEYS, free_id, instinct)
pro_products, pro_files = check(pro_dir, "PRO", "Days To Go Pro", PRO_KEYS, pro_id, instinct)
seen = {os.path.basename(f).split("-settings.json")[0] for f in settings_files(free_dir)}
if not (instinct & seen):
    fail("FREE: no Instinct part in the package (the Accent exemption was never exercised)")
check_part_numbers(free_dir, "FREE")
check_part_numbers(pro_dir, "PRO")
if free_id == pro_id:
    fail("Free and Pro share an app id")
if free_products != pro_products:
    fail(f"Free has {free_products} products, Pro {pro_products}")

# The Free package must not mention Pro or its two keys anywhere a person or the app could meet them.
for path in glob.glob(free_dir + "/**/*", recursive=True):
    if path.endswith((".prg", ".json", ".xml")):
        raw = open(path, "rb").read()
        if word(rb"\bPro\b", raw):
            fail(f"FREE: the word 'Pro' appears in {path[len(free_dir) + 1:]}")
        if path.endswith(".prg"):
            for key in PRO_ONLY:
                if word(rb"(?<![A-Za-z0-9_])" + key.encode() + rb"(?![A-Za-z0-9_])", raw):
                    fail(f"FREE: property name '{key}' appears in compiled {path[len(free_dir) + 1:]}")
# Positive controls: the Pro package must carry the Pro-only keys and names, or the Free checks above prove nothing.
for path in settings_files(pro_dir):
    got = [s["key"] for s in json.load(open(path))["settings"]]
    for key in PRO_ONLY:
        if key not in got:
            fail(f"PRO: {path}: missing {key}")
for path in sorted(glob.glob(pro_dir + "/*/*.prg")):
    raw = open(path, "rb").read()
    for key in PRO_ONLY:
        if not word(rb"(?<![A-Za-z0-9_])" + key.encode() + rb"(?![A-Za-z0-9_])", raw):
            fail(f"PRO: property name '{key}' not found in compiled {path[len(pro_dir) + 1:]} (the Free check is blind)")
    if raw.count(b"Days To Go Pro") < 1:
        fail(f"PRO: 'Days To Go Pro' not found in compiled {path[len(pro_dir) + 1:]}")

if problems:
    print("FAIL")
    for p in problems[:40]:
        print(" ", p)
    if len(problems) > 40:
        print(f"  ... and {len(problems) - 40} more")
    sys.exit(1)
print(f"OK: Free package ({free_products} products, {free_files} settings files): keys {FREE_KEYS} (no Accent on the 7 Instinct products), "
      f"no Hour/Footer in settings or compiled .prg, no 'Pro' anywhere, AppName 'Days To Go' in every language.")
print(f"OK: Pro package ({pro_products} products, {pro_files} settings files): keys {PRO_KEYS} (no Accent on the 7 Instinct products), AppName 'Days To Go Pro' in every language; Hour, Footer and the name found in every .prg (positive controls).")
PY
