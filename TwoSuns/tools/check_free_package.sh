#!/bin/bash
# Check the COMPILED store packages (not the source files): the Free .iq must ship none of the Pro settings keys, none of
# the Pro permissions, none of the Pro code and no "Pro" word, and the Pro .iq must ship them. Exits non-zero on any failure.
# Usage: tools/check_free_package.sh [--build] [free.iq] [pro.iq]
#   --build   first run `monkeyc -e -r` for both jungles (a few minutes each; compile only, no simulator)
#   defaults  dist/TwoSunsFree.iq (Free) and dist/TwoSunsPro.iq (Pro). dist/TwoSuns.iq is the pre-ladder 1.0.1 package; it is never written here.
# A package older than any source, jungle, manifest or resource file is STALE and fails: rebuild with --build.
# Method (docs/development.md "Checking a store package"): a .iq is a 7-zip archive. Per part number it holds the
# compiled TwoSuns.prg, a <part>-settings.json (the settings the phone renders: keys, list options, and every string in
# every language) and a debug.xml (every function and source file the compiler kept), plus one manifest.xml. This script
# extracts it and checks, for every part number:
#   Free: permissions are exactly ComplicationSubscriber, a subset of Pro's; the settings KEYS are exactly Accent (ids 0-5);
#         the word "Pro" appears nowhere (manifest, settings strings in every language, compiled .prg, debug.xml); no .prg
#         contains the property names Orientation, Golden, Curve or place (the Storage key); debug.xml names none of the Pro-only functions (positionLocation,
#         readCurve, updatePlace, ...), none of the Pro-only source files (TwoSunsSun.mc, TwoSunsPlace.mc, ...), none of the
#         modules Position, SensorHistory, Weather, Activity or Storage, and no TwoSunsSources.initialize (the Storage read);
#         AppName is "Two Suns" in every language.
#   Pro:  permissions are ComplicationSubscriber, Positioning and SensorHistory; the settings keys are Accent, Orientation,
#         Golden, Curve, Date, Weather, Battery; every .prg contains Orientation, Golden, Curve and "Two Suns Pro", and every debug.xml the Pro-only
#         functions and files (positive controls: they prove the Free checks can see what they look for);
#         AppName is "Two Suns Pro" in every language.
#   Both: the app ids are the expected, different ones; the part numbers equal the SDK's part numbers for the manifest's
#         69 product ids (one SDK part number may be absent, reported, not failed).
# NOT proven: that the Pro setting display strings (setting_golden, orientation_*, ...) are absent. They live in the
# shared strings and still ship, unreferenced, in Free. The property name Date is not scanned in the .prg
# (the shared setting title "Date" is that exact string); the settings keys and the missing Pro code prove it.
# Nor does it prove behaviour on a watch.
set -u
cd "$(dirname "$0")/.." || exit 2
mkdir -p bin dist
KEY=${KEY:-$HOME/.garmin-connectiq/keys/developer_key}
if [ "${1:-}" = "--build" ]; then
  shift
  monkeyc -e -r -f monkey.free.jungle -o dist/TwoSunsFree.iq -y "$KEY" > bin/export-free.log 2>&1 || { tail -5 bin/export-free.log; exit 2; }
  monkeyc -e -r -f monkey.jungle -o dist/TwoSunsPro.iq -y "$KEY" > bin/export-pro.log 2>&1 || { tail -5 bin/export-pro.log; exit 2; }
fi
FREE=${1:-dist/TwoSunsFree.iq}
PRO=${2:-dist/TwoSunsPro.iq}
for pkg in "$FREE" "$PRO"; do [ -f "$pkg" ] || { echo "missing $pkg (run with --build)"; exit 2; }; done
# Everything the build reads. Each path must exist (a missing one would make `find` fail quietly and pass a stale package).
WATCHED=(source monkey.jungle monkey.free.jungle manifest.xml manifest.free.xml resources resources-free resources-pro)
for lang_dir in resources-*; do case "$lang_dir" in resources-free|resources-pro) ;; *) WATCHED+=("$lang_dir");; esac; done
for path in "${WATCHED[@]}"; do [ -e "$path" ] || { echo "missing $path: cannot check the package is current"; exit 2; }; done
stale=0
for pkg in "$FREE" "$PRO"; do
  newer=$(find "${WATCHED[@]}" -type f -newer "$pkg" | head -3)
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
FREE_KEYS = ["Accent"]
PRO_ONLY = ["Orientation", "Golden", "Curve", "Date", "Weather", "Battery"]
PRO_KEYS = FREE_KEYS + PRO_ONLY
FREE_PERMISSIONS = {"ComplicationSubscriber"}
PRO_PERMISSIONS = {"ComplicationSubscriber", "Positioning", "SensorHistory"}
PRODUCTS = 69
# Property names scanned for in the compiled .prg. A .prg stores a string as <length byte><text><NUL>, so a standalone name is matched
# as control byte + name + NUL: that skips the longer titles that contain it ("Golden hour", the French "Orientation de l'anneau").
# Date is left out: the shared setting title "Date" is that exact string (see the header).
PRG_KEYS = ["Orientation", "Golden", "Curve", "place"]   # "place" is the Application.Storage key (TwoSunsConfig.KEY_PLACE, Pro only)

def key_pattern(key):
    return rb"[\x00-\x1f]" + key.encode() + rb"\x00"
# Pro-only code, by the names the compiler keeps in debug.xml: functions that exist only in Pro, and whole source files.
PRO_SYMBOLS = ["positionLocation", "readCurve", "updatePlace", "activityLocation", "weatherLocation", "fromStorage", "drawDot", "readWeather"]
PRO_FILES = ["TwoSunsSun.mc", "TwoSunsPlace.mc", "TwoSunsCurvePlan.mc", "TwoSunsDateText.mc",
             "TwoSunsWeatherData.mc", "TwoSunsWeatherSource.mc", "TwoSunsWeatherKind.mc", "TwoSunsWeatherPlan.mc", "TwoSunsWeatherIcons.mc", "TwoSunsWeatherRow.mc", "TwoSunsBatteryRow.mc"]
# Modules the Free build must not so much as import. Only the first two show up in Pro's debug.xml (Pro names Position, Activity and
# Storage in full, which leaves no module entry), so only those two are positive controls; the Storage read itself is in
# TwoSunsSources.initialize, which Free does not have (checked below with updatePlace and fromStorage, the write and the parse).
PRO_MODULES = ["SensorHistory", "Weather", "Position", "Activity", "Storage"]
PRO_MODULES_SEEN_IN_PRO = ["SensorHistory", "Weather"]
problems = []

def fail(msg):
    problems.append(msg)

def read_bytes(path):
    with open(path, "rb") as handle:
        return handle.read()

def read_text(path):
    return read_bytes(path).decode("utf-8", errors="replace")

def part_files(root, pattern):
    files = sorted(glob.glob(root + "/*/" + pattern))
    if not files:
        fail(f"{root}: no {pattern} files found in the package")
    return files

def word(pattern, data):
    return re.search(pattern, data) is not None

def has_symbol(text, name):
    """A function by name. The compiler writes a private one as symbol="&lt;globals/Class/&lt;&gt;name&gt;", a public one as symbol="name"."""
    return word(r'symbol="[^"]*\b' + re.escape(name) + r'\b[^"]*"', text)

def has_module(text, name):
    return word(r'module="true" symbol="' + re.escape(name) + '"', text)

def has_sources_initialize(text):
    """TwoSunsSources.initialize reads the remembered place from Application.Storage; only Pro has it."""
    return word(r'parent="globals/TwoSunsSources"[^>]*symbol="initialize"', text)

def has_file(text, name):
    return word(r'filename="[^"]*/' + re.escape(name) + '"', text)

def check(root, tier, app_name, keys, app_id, permissions):
    manifest = read_text(root + "/manifest.xml")
    ids = re.findall(r'<iq:application[^>]* id="([^"]+)"', manifest)
    if ids != [app_id]:
        fail(f"{tier}: manifest app id {ids}, expected {app_id}")
    got_permissions = set(re.findall(r'<iq:uses-permission id="([^"]+)"', manifest))
    if got_permissions != permissions:
        fail(f"{tier}: permissions {sorted(got_permissions)}, expected {sorted(permissions)}")
    products = len(re.findall(r"<iq:product ", manifest))
    files = part_files(root, "*-settings.json")
    if len(files) != products:
        fail(f"{tier}: {len(files)} settings files for {products} products")
    for path in files:
        data = json.loads(read_text(path))
        got = [s["key"] for s in data["settings"]]
        if got != keys:
            fail(f"{tier}: {path}: keys {got}, expected {keys}")
        accent = [s for s in data["settings"] if s["key"] == "Accent"][0]
        if [o["value"] for o in accent["configOptions"]] != list(range(6)):
            fail(f"{tier}: {path}: Accent ids are not 0-5")
        for lang, strings in data["languages"].items():
            if strings.get("AppName") != app_name:
                fail(f"{tier}: {path}: language {lang} AppName is {strings.get('AppName')!r}, expected {app_name!r}")
    return got_permissions, products, len(files)

def check_part_numbers(root, tier):
    """Part numbers in the package must be the SDK's part numbers for the manifest's product ids. Returns True when the check ran."""
    ids = re.findall(r'<iq:product id="([^"]+)"', read_text("manifest.xml"))
    if len(ids) != PRODUCTS:
        fail(f"manifest.xml lists {len(ids)} product ids, expected {PRODUCTS}")
    expected = set()
    for pid in ids:
        path = os.path.join(devices, pid, "compiler.json")
        if not os.path.exists(path):
            print(f"note: {path} not found; part-number check skipped")
            return False
        expected |= {p["number"] for p in json.loads(read_text(path))["partNumbers"]}
    got = set(re.findall(r'partNumber="([^"]+)"', read_text(root + "/manifest.xml")))
    if not got <= expected:
        fail(f"{tier}: part numbers not in the manifest's products: {sorted(got - expected)[:5]}")
    if expected - got:
        print(f"note: {tier} lacks {len(expected - got)} of the SDK's {len(expected)} part numbers for the {PRODUCTS} products: {sorted(expected - got)}")
    else:
        print(f"note: {tier} has all {len(expected)} of the SDK's part numbers for the {PRODUCTS} products ({len(got)} in the package)")
    return True

free_perms, free_products, free_files = check(free_dir, "FREE", "Two Suns", FREE_KEYS, free_id, FREE_PERMISSIONS)
pro_perms, pro_products, pro_files = check(pro_dir, "PRO", "Two Suns Pro", PRO_KEYS, pro_id, PRO_PERMISSIONS)
parts_checked = check_part_numbers(free_dir, "FREE") and check_part_numbers(pro_dir, "PRO")
if not free_perms <= pro_perms:
    fail(f"Free permissions {sorted(free_perms)} are not a subset of Pro's {sorted(pro_perms)}")
if free_id == pro_id:
    fail("Free and Pro share an app id")
if free_products != pro_products:
    fail(f"Free has {free_products} products, Pro {pro_products}")

# One compiled .prg and one debug.xml per product: a missing file must not pass the scans below by being absent.
for root, tier, products in ((free_dir, "FREE", free_products), (pro_dir, "PRO", pro_products)):
    for pattern in ("*.prg", "debug.xml"):
        found = len(glob.glob(root + "/*/" + pattern))
        if found != products:
            fail(f"{tier}: {found} {pattern} files for {products} products")

# The Free package must not mention Pro, its property names or its code anywhere a person or the app could meet them.
for path in glob.glob(free_dir + "/**/*", recursive=True):
    rel = path[len(free_dir) + 1:]
    if path.endswith((".prg", ".json", ".xml")):
        raw = read_bytes(path)
        if word(rb"\bPro\b", raw):
            fail(f"FREE: the word 'Pro' appears in {rel}")
        if path.endswith(".prg"):
            for key in PRG_KEYS:
                if word(key_pattern(key), raw):
                    fail(f"FREE: property name '{key}' appears in compiled {rel}")
    if path.endswith("debug.xml"):
        text = read_text(path)
        for name in PRO_SYMBOLS:
            if has_symbol(text, name):
                fail(f"FREE: Pro-only function '{name}' is compiled into {rel}")
        for name in PRO_FILES:
            if has_file(text, name):
                fail(f"FREE: Pro-only source file {name} is compiled into {rel}")
        for name in PRO_MODULES:
            if has_module(text, name):
                fail(f"FREE: module {name} is referenced in {rel}")
        if has_sources_initialize(text):
            fail(f"FREE: TwoSunsSources.initialize (the Application.Storage read) is compiled into {rel}")
# Positive controls: the Pro package must carry the Pro-only keys, names, functions and files, or the Free checks above prove nothing.
for path in part_files(pro_dir, "*-settings.json"):
    got = [s["key"] for s in json.loads(read_text(path))["settings"]]
    for key in PRO_ONLY:
        if key not in got:
            fail(f"PRO: {path}: missing {key}")
for path in part_files(pro_dir, "*.prg"):
    raw = read_bytes(path)
    rel = path[len(pro_dir) + 1:]
    for key in PRG_KEYS:
        if not word(key_pattern(key), raw):
            fail(f"PRO: property name '{key}' not found in compiled {rel} (the Free check is blind)")
    if raw.count(b"Two Suns Pro") < 1:
        fail(f"PRO: 'Two Suns Pro' not found in compiled {rel}")
for path in part_files(pro_dir, "debug.xml"):
    text = read_text(path)
    rel = path[len(pro_dir) + 1:]
    for name in PRO_SYMBOLS:
        if not has_symbol(text, name):
            fail(f"PRO: function '{name}' not found in {rel} (the Free check is blind)")
    for name in PRO_FILES:
        if not has_file(text, name):
            fail(f"PRO: source file {name} not found in {rel} (the Free check is blind)")
    for name in PRO_MODULES_SEEN_IN_PRO:
        if not has_module(text, name):
            fail(f"PRO: module {name} not found in {rel} (the Free check is blind)")
    if not has_sources_initialize(text):
        fail(f"PRO: TwoSunsSources.initialize not found in {rel} (the Free check is blind)")

if problems:
    print("FAIL")
    for p in problems[:40]:
        print(" ", p)
    if len(problems) > 40:
        print(f"  ... and {len(problems) - 40} more")
    sys.exit(1)
parts_note = "part numbers equal the SDK's for the manifest's 69 products" if parts_checked else "part-number check SKIPPED (SDK device files not found)"
print(f"OK: Free package ({free_products} part numbers, {free_files} settings files): permissions {sorted(free_perms)} only, keys {FREE_KEYS} (Accent 0-5), "
      f"no Pro-only function or file in debug.xml, no 'Pro' anywhere, AppName 'Two Suns' in every language; {parts_note}.")
print(f"OK: Pro package ({pro_products} part numbers, {pro_files} settings files): permissions {sorted(pro_perms)}, keys {PRO_KEYS}, AppName 'Two Suns Pro' in every language; "
      f"the Pro keys, functions, files and name found in every part number (positive controls).")
PY
