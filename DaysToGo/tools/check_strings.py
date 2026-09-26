#!/usr/bin/env python3
"""Every resources-<lang>/strings/strings.xml must have exactly English's ids and
placeholders. Run from the project root: python3 tools/check_strings.py"""
import glob
import re
import sys

PAIR = re.compile(r'<string id="([^"]+)">(.*?)</string>', re.S)
base = dict(PAIR.findall(open("resources/strings/strings.xml").read()))
bad = 0
for path in sorted(glob.glob("resources-*/strings/strings.xml")):
    got = dict(PAIR.findall(open(path).read()))
    missing, extra = set(base) - set(got), set(got) - set(base)
    if missing or extra:
        print(path, "missing", sorted(missing), "extra", sorted(extra)); bad += 1
    for key in set(base) & set(got):
        if sorted(re.findall(r"\$\d\$", base[key])) != sorted(re.findall(r"\$\d\$", got[key])):
            print(path, key, "placeholder mismatch"); bad += 1
    # Captions are one line in a small font; the SET A DATE hero shrinks through the font chain.
    for key, limit in (("cap_since_days", 14), ("cap_since_day", 14), ("cap_invalid", 18), ("cap_days", 8), ("cap_weeks", 10), ("cap_hours", 10)):
        if len(got.get(key, "")) > limit:
            print(path, key, f"longer than {limit} characters:", got[key]); bad += 1
print("strings OK" if not bad else f"{bad} problem(s)")
sys.exit(1 if bad else 0)
