#!/usr/bin/env python3
"""Every resources-<lang>/strings/strings.xml must have exactly English's ids and placeholders, and the
sentences that have no shorter wording must stay short (they sit low on the round screen).
Run from the project root: python3 tools/check_strings.py"""
import glob
import re
import sys

PAIR = re.compile(r'<string id="([^"]+)">(.*?)</string>', re.S)
base = dict(PAIR.findall(open("resources/strings/strings.xml").read()))
# Sentences with a single wording (no shorter fallback): keep them under this many characters.
SINGLE_WORDING = ("sky_no_place", "sky_no_data", "sky_sun_up", "sky_midnight_sun_min", "sky_polar_night_min")
SINGLE_LIMIT = 14
# The three wordings of one sentence must not get longer: (full, shorter, shortest).
LADDERS = (("sky_midnight_sun", "sky_midnight_sun_short", "sky_midnight_sun_min"),
           ("sky_polar_night", "sky_polar_night_short", "sky_polar_night_min"),
           ("sky_sunrise", "sky_sunrise_short"), ("sky_sunrise_estimate", "sky_sunrise_estimate_short"), ("sky_sunset", "sky_sunset_short"),
           ("sky_daylight_left", "sky_daylight_left_short"), ("sky_no_sunrise", "sky_no_sunrise_short"))
# The last-resort wording of each sentence, with a time in it, must fit a narrow row (characters, a proxy:
# the pixel fit is tools/fit_languages.sh).
LAST_RESORT = ("sky_sunrise_short", "sky_sunrise_estimate_short", "sky_sunset_short", "sky_daylight_left_short", "sky_no_sunrise_short",
               "sky_midnight_sun_min", "sky_polar_night_min", "sky_no_place", "sky_no_data", "sky_sun_up")
LAST_RESORT_LIMIT = 16
bad = 0
manifest_languages = set(re.findall(r"<iq:language>(\w+)</iq:language>", open("manifest.xml").read()))
folders = {p.split("/")[0][len("resources-"):] for p in glob.glob("resources-*/strings/strings.xml")} | {"eng"}
if manifest_languages != folders:
    print("manifest languages and resources-<lang> folders differ:", sorted(manifest_languages ^ folders)); bad += 1
for path in sorted(glob.glob("resources-*/strings/strings.xml")):
    got = dict(PAIR.findall(open(path).read()))
    missing, extra = set(base) - set(got), set(got) - set(base)
    if missing or extra:
        print(path, "missing", sorted(missing), "extra", sorted(extra)); bad += 1
    for key in set(base) & set(got):
        if sorted(re.findall(r"\$\d\$", base[key])) != sorted(re.findall(r"\$\d\$", got[key])):
            print(path, key, "placeholder mismatch"); bad += 1
    if got.get("AppName") != "Two Suns":
        print(path, "AppName is not 'Two Suns':", got.get("AppName")); bad += 1
    if "Machine-drafted" not in open(path).read():
        print(path, "lacks the machine-drafted note"); bad += 1
    for key in LAST_RESORT:
        text = got.get(key, "").replace("$1$", "18:47")
        if len(text) > LAST_RESORT_LIMIT:
            print(path, key, f"longer than {LAST_RESORT_LIMIT} characters with a time in it:", text); bad += 1
    for key in SINGLE_WORDING:
        if len(got.get(key, "")) > SINGLE_LIMIT:
            print(path, key, f"longer than {SINGLE_LIMIT} characters:", got[key]); bad += 1
    for ladder in LADDERS:
        lengths = [len(got.get(k, "")) for k in ladder]
        if lengths != sorted(lengths, reverse=True):
            print(path, "wordings get longer:", [got.get(k) for k in ladder]); bad += 1
print("strings OK" if not bad else f"{bad} problem(s)")
sys.exit(1 if bad else 0)
