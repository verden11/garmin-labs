#!/usr/bin/env python3
"""Write manifest-beta.xml and beta.jungle: the Pro build (manifest.xml, monkey.jungle) with a second app id.

A Beta App upload (developer dashboard, "Beta App" checked) needs its own id so
it never collides with the release. The two manifests differ only in that id.
The id lives in tools/beta-app-id.txt (tracked; not a secret).

Run from the project root:  python3 tools/make_beta.py
Then:  monkeyc -e -r -f beta.jungle -o dist/DaysToGo-beta.iq -y ~/.garmin-connectiq/keys/developer_key
"""
import re
from pathlib import Path

root = Path(__file__).resolve().parent.parent
beta_id = (root / "tools" / "beta-app-id.txt").read_text().strip()
manifest = (root / "manifest.xml").read_text()
beta, count = re.subn(r'(<iq:application id=")[0-9a-f-]{36}(")', rf"\g<1>{beta_id}\g<2>", manifest)
assert count == 1, "manifest.xml must have exactly one application id"
assert beta != manifest, "beta id equals the production id"
(root / "manifest-beta.xml").write_text(beta)
# beta.jungle is monkey.jungle (Pro: resources;resources-pro, exclude free, per-language AppName paths) with the beta manifest.
jungle, count = re.subn(r"(?m)^project\.manifest = .*$", "project.manifest = manifest-beta.xml", (root / "monkey.jungle").read_text())
assert count == 1, "monkey.jungle must have exactly one project.manifest line"
(root / "beta.jungle").write_text(jungle)
print("wrote manifest-beta.xml, beta.jungle (id", beta_id + ")")
