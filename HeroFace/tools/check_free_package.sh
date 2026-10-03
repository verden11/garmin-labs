#!/bin/bash
# Prove from the COMPILED store packages (not the source files) that the Free .iq ships none of the Pro
# settings and the Pro .iq ships them all. Exits non-zero on any failure.
# Usage: tools/check_free_package.sh [--build] [free.iq] [pro.iq]
#   --build   first run `monkeyc -e -r` for both jungles (several minutes each; compile only, no simulator)
#   defaults  dist/HeroFaceFree.iq (Free) and dist/HeroFacePro.iq (Pro)
# Method (docs/development.md "Checking a store package"): a .iq is a 7-zip archive. Per part number it holds the
# compiled <app>.prg, a <part>-settings.json (the settings the phone renders: keys, list options, and every
# string in every language) and one manifest.xml. This script extracts it and checks, for every part number:
#   Free: settings keys are exactly Mode and Accent; Mode and Accent offer exactly Pro's lists (ids 0-1 and 0-2);
#         the word "Pro" appears nowhere (manifest, settings strings in every language, compiled .prg), nor does any
#         Pro-only property name (Slot1-3, Seconds, Weather) as a standalone string in any .prg; AppName is
#         "HeroFace" in every language.
#   Pro:  settings keys are the full set (Mode, Slot1-3, Accent, Seconds, Weather); each Pro-only name is present in
#         the compiled .prg (the positive control: without it the Free check would prove nothing); AppName is
#         "HeroFace Pro" in every language.
#   Guards: it fails (never skips) if any file under source/, resources*/, or any *.jungle or manifest*.xml is newer than either package
#         (a stale .iq proves nothing: rebuild with --build), if a path it needs is missing, if the two source manifests list different
#         products or not exactly 124 (117 round + 7 Instinct), or if the two packages list different part numbers. --build exports with -w --typecheck 3.
#   Not done (future): a case-insensitive "pro" scan, and a positive control in tools/compile_sweep.sh.
#   Both: the app ids are the expected ones and differ; the permission list is exactly ComplicationSubscriber (HeroSet mode
#         needs it, so Free's permissions equal Pro's and are never more); same product count.
set -u
cd "$(dirname "$0")/.." || exit 2
KEY=${KEY:-$HOME/.garmin-connectiq/keys/developer_key}
EXPECTED_PRODUCTS=124   # 117 round + 7 Instinct (ADR-002, the Instinct family)
mkdir -p bin dist
# Fail closed: every path the checks read must exist.
for path in source resources resources-free resources-pro manifest.xml manifest.free.xml monkey.jungle monkey.free.jungle; do
  [ -e "$path" ] || { echo "missing $path"; exit 2; }
done
products() { grep -o '<iq:product id="[^"]*"' "$1" | sed 's/.*id="//; s/"//'; }
if ! diff <(products manifest.xml) <(products manifest.free.xml) > /dev/null; then
  echo "manifest.xml and manifest.free.xml list different products"; exit 2
fi
count=$(products manifest.xml | wc -l | tr -d ' ')
[ "$count" = "$EXPECTED_PRODUCTS" ] || { echo "manifest.xml lists $count products, expected $EXPECTED_PRODUCTS"; exit 2; }
if [ "${1:-}" = "--build" ]; then
  shift
  monkeyc -e -r -f monkey.free.jungle -o dist/HeroFaceFree.iq -y "$KEY" -w --typecheck 3 > bin/export-free.log 2>&1 || { tail -5 bin/export-free.log; exit 2; }
  monkeyc -e -r -f monkey.jungle -o dist/HeroFacePro.iq -y "$KEY" -w --typecheck 3 > bin/export-pro.log 2>&1 || { tail -5 bin/export-pro.log; exit 2; }
fi
FREE=${1:-dist/HeroFaceFree.iq}
PRO=${2:-dist/HeroFacePro.iq}
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
extract() {  # extract <package> <dir>
  mkdir -p "$2"
  if command -v bsdtar > /dev/null; then bsdtar -xf "$1" -C "$2"
  elif command -v 7z > /dev/null; then 7z x -y -o"$2" "$1" > /dev/null
  else echo "need bsdtar or 7z to open a .iq"; return 1; fi
}
for pkg in "$FREE" "$PRO"; do
  [ -f "$pkg" ] || { echo "missing $pkg (run with --build)"; exit 2; }
  # find prints newer files; a find error (missing path) or any hit fails the check.
  stale=$(find source resources resources-* manifest.xml manifest.free.xml monkey.jungle monkey.free.jungle -type f -newer "$pkg" 2>&1) \
    || { echo "stale-package guard could not scan: $stale"; exit 2; }
  [ -z "$stale" ] || { echo "STALE: $pkg is older than: $(echo "$stale" | head -3 | tr '\n' ' ')(run with --build)"; exit 2; }
done
extract "$FREE" "$WORK/free" && extract "$PRO" "$WORK/pro" || exit 2
DEVICES=${CIQ_DEVICES:-$HOME/Library/Application Support/Garmin/ConnectIQ/Devices}
FREE_ID=$(grep -o '<iq:application id="[^"]*"' manifest.free.xml | sed 's/.*id="//; s/"//' | tr -d -)
PRO_ID=$(grep -o '<iq:application id="[^"]*"' manifest.xml | sed 's/.*id="//; s/"//' | tr -d -)
python3 - "$WORK/free" "$WORK/pro" "$FREE_ID" "$PRO_ID" "$DEVICES" <<'PY'
import glob, json, os, re, sys
free_dir, pro_dir, free_id, pro_id, devices = sys.argv[1:6]
# The Instinct family has no Accent setting: a 1-bit display cannot show one (ADR-002). Its part numbers come from the SDK so the
# check can tell an Instinct part's settings file from a round one's.
INSTINCT = ["instinct2", "instinct2s", "instinct2x", "descentg1", "instincte40mm", "instincte45mm", "instinct3solar45mm"]
INSTINCT_PARTS = set()
for pid in INSTINCT:
    path = os.path.join(devices, pid, "compiler.json")
    if os.path.exists(path):
        INSTINCT_PARTS |= {p["number"] for p in json.load(open(path))["partNumbers"]}
if not INSTINCT_PARTS:
    print("note: SDK device files not found; the Instinct parts cannot be told apart, so the Accent checks will fail")
FREE_KEYS = ["Mode", "Accent"]
PRO_ONLY = ["Slot1", "Slot2", "Slot3", "Seconds", "Weather"]
PRO_KEYS = ["Mode", "Slot1", "Slot2", "Slot3", "Accent", "Seconds", "Weather"]
LISTS = {"Mode": [0, 1], "Accent": [0, 1, 2]}   # the same in both tiers: HeroFace stays at its shipped three accents
PERMISSIONS = ["ComplicationSubscriber"]
problems = []
PARTS = {}

def fail(msg):
    problems.append(msg)

def settings_files(root):
    files = sorted(glob.glob(root + "/*/*-settings.json"))
    if not files:
        fail(f"{root}: no settings.json files found in the package")
    return files

def word(pattern, data):
    return re.search(pattern, data) is not None

def standalone(key):
    return rb"(?<![A-Za-z0-9_])" + key.encode() + rb"(?![A-Za-z0-9_])"

def check(root, tier, app_name, keys, app_id):
    manifest = open(root + "/manifest.xml").read()
    ids = re.findall(r'<iq:application[^>]* id="([^"]+)"', manifest)
    if ids != [app_id]:
        fail(f"{tier}: manifest app id {ids}, expected {app_id}")
    permissions = re.findall(r'<iq:uses-permission id="([^"]+)"', manifest)
    if permissions != PERMISSIONS:
        fail(f"{tier}: manifest permissions {permissions}, expected {PERMISSIONS}")
    parts = set(re.findall(r'<iq:product [^>]*partNumber="([^"]+)"', manifest))
    PARTS[tier] = parts
    products = len(re.findall(r"<iq:product ", manifest))
    if products != len(parts):
        fail(f"{tier}: {products} product entries but {len(parts)} distinct part numbers")
    files = settings_files(root)
    if len(files) != products:
        fail(f"{tier}: {len(files)} settings files for {products} products")
    for path in files:
        data = json.load(open(path))
        got = [s["key"] for s in data["settings"]]
        part = os.path.basename(path).split("-settings.json")[0]
        wanted = [k for k in keys if k != "Accent"] if part in INSTINCT_PARTS else keys
        if got != wanted:
            fail(f"{tier}: {path}: keys {got}, expected {wanted}")
        for setting in data["settings"]:
            want = LISTS.get(setting["key"])
            if want is not None and [o["value"] for o in setting["configOptions"]] != want:
                fail(f"{tier}: {path}: {setting['key']} ids are not {want}")
        for lang, strings in data["languages"].items():
            if strings.get("AppName") != app_name:
                fail(f"{tier}: {path}: language {lang} AppName is {strings.get('AppName')!r}, expected {app_name!r}")
    return products, len(files)

free_products, free_files = check(free_dir, "FREE", "HeroFace", FREE_KEYS, free_id)
pro_products, pro_files = check(pro_dir, "PRO", "HeroFace Pro", PRO_KEYS, pro_id)
if free_id == pro_id:
    fail("Free and Pro share an app id")
seen = {os.path.basename(f).split("-settings.json")[0] for f in settings_files(free_dir)}
if not (INSTINCT_PARTS & seen):
    fail("FREE: no Instinct part in the package (the Accent exemption was never exercised)")
if free_products != pro_products:
    fail(f"Free has {free_products} products, Pro {pro_products}")
if PARTS["FREE"] != PARTS["PRO"]:
    fail(f"Free and Pro list different part numbers: only Free {sorted(PARTS['FREE'] - PARTS['PRO'])[:5]}, only Pro {sorted(PARTS['PRO'] - PARTS['FREE'])[:5]}")

# The Free package must not mention Pro or its keys anywhere a person or the app could meet them.
for path in glob.glob(free_dir + "/**/*", recursive=True):
    if path.endswith((".prg", ".json", ".xml")):
        raw = open(path, "rb").read()
        if word(rb"\bPro\b", raw):
            fail(f"FREE: the word 'Pro' appears in {path[len(free_dir) + 1:]}")
        if path.endswith(".prg"):
            for key in PRO_ONLY:
                if word(standalone(key), raw):
                    fail(f"FREE: property name '{key}' appears in compiled {path[len(free_dir) + 1:]}")
# The Pro package must carry the Pro-only keys, in the settings and in the compiled code, or the checks above prove nothing.
for path in settings_files(pro_dir):
    got = [s["key"] for s in json.load(open(path))["settings"]]
    for key in PRO_ONLY:
        if key not in got:
            fail(f"PRO: {path}: missing {key}")
for path in glob.glob(pro_dir + "/**/*.prg", recursive=True):
    raw = open(path, "rb").read()
    for key in PRO_ONLY:
        if not word(standalone(key), raw):
            fail(f"PRO: property name '{key}' missing from compiled {path[len(pro_dir) + 1:]}")

if problems:
    print("FAIL")
    for p in problems[:40]:
        print(" ", p)
    if len(problems) > 40:
        print(f"  ... and {len(problems) - 40} more")
    sys.exit(1)
print(f"OK: Free package ({free_products} products, {free_files} settings files): keys {FREE_KEYS} (no Accent on the 7 Instinct products), "
      f"no Slot1-3/Seconds/Weather, no 'Pro', AppName 'HeroFace' in every language, permissions {PERMISSIONS}.")
print(f"OK: Pro package ({pro_products} products, {pro_files} settings files): keys {PRO_KEYS} (no Accent on the 7 Instinct products), "
      f"Pro-only names in the compiled code, AppName 'HeroFace Pro' in every language, permissions {PERMISSIONS}.")
PY
