#!/usr/bin/env python3
"""Daily read of our public Connect IQ store listings (WP9, ROADMAP 6.2).

Reads only the public store API, no login, no key, no browser:
  GET https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/<id>?countryCode=US
and appends one CSV row per listing per day to research_notes/Free and Pro ladder/poll.csv.

  tools/store_poll.py                      poll every id in tools/store_poll_ids.txt
  tools/store_poll.py ID [ID ...]          poll these store ids instead
  tools/store_poll.py --fixture DIR        offline: read DIR/<id>.json instead of the network
  tools/store_poll.py --selftest           offline self-check against tools/fixtures/ (no network, no CSV)

Ids are the STORE ids (the last part of the listing URL), not the manifest app ids.
A listing already polled today is skipped, so running twice a day adds nothing.
downloadCount is a bucket (1, 10, 100, 1000, 10k, ...), never an exact count; do not turn it into revenue.
price is what the store returns for countryCode=US: euros so far ("2.49 EUR"); 0 for a free listing.
"""
import csv
import datetime
import json
import os
import sys
import time
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
IDS = os.path.join(HERE, "store_poll_ids.txt")
CSV_PATH = os.path.join(ROOT, "research_notes", "Free and Pro ladder", "poll.csv")
URL = "https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/{}?countryCode=US"
HEADER = ["date", "id", "downloadCount", "reviewCount", "averageRating",
          "compatibleDeviceTypeIds", "latestExternalVersion", "price"]
PAUSE_S = 3  # between requests: we read a handful of pages, never a crawl


def fetch(app_id):
    req = urllib.request.Request(URL.format(app_id), headers={"User-Agent": "verden-store-poll/1 (hello@verden.watch)"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)


def price(d):
    sale = ((d.get("pricing") or {}).get("salePrice")) or {}
    if not sale.get("price"):
        return "0"
    return "%s %s" % (sale["price"], sale.get("currencyCode", ""))


def row(d, today, app_id):
    """One CSV row from one store response. compatibleDeviceTypeIds is the COUNT of device types."""
    return [today, d.get("id", app_id), d["downloadCount"], d["reviewCount"], d["averageRating"],
            len(d.get("compatibleDeviceTypeIds") or []), d["latestExternalVersion"], price(d)]


def read_ids():
    with open(IDS) as f:
        return [ln.split()[0] for ln in f if ln.strip() and not ln.startswith("#")]


def append(rows, path=CSV_PATH):
    new = not os.path.exists(path)
    seen = set()
    if not new:
        with open(path, newline="") as f:
            seen = {(r["date"], r["id"]) for r in csv.DictReader(f)}
    rows = [r for r in rows if (r[0], r[1]) not in seen]
    with open(path, "a", newline="") as f:
        w = csv.writer(f)
        if new:
            w.writerow(HEADER)
        w.writerows(rows)
    return len(rows)


def selftest():
    import tempfile
    d = json.load(open(os.path.join(HERE, "fixtures", "store_poll_heroset.json")))
    r = row(d, "2026-10-04", d["id"])
    assert r == ["2026-10-04", "54bbf625-82af-4715-8af0-f2f16a5d1377", 1, 0, 0, 97, "1.3.0", "2.49 EUR"], r
    assert row({**d, "pricing": None}, "x", "i")[-1] == "0"                 # free listing
    assert row({k: v for k, v in d.items() if k != "id"}, "x", "fallback")[1] == "fallback"
    with tempfile.TemporaryDirectory() as t:
        p = os.path.join(t, "poll.csv")
        assert append([r], p) == 1 and append([r], p) == 0                   # same day twice: one row
        assert append([["2026-10-05"] + r[1:]], p) == 1                      # next day: a second row
        lines = open(p).read().splitlines()
        assert lines[0] == ",".join(HEADER) and len(lines) == 3, lines
    print("selftest ok")


def main(argv):
    if argv[:1] == ["--selftest"]:
        return selftest()
    fixture = None
    if argv[:1] == ["--fixture"]:
        fixture, argv = argv[1], argv[2:]
    ids = argv or read_ids()
    today = datetime.date.today().isoformat()
    rows, failed = [], 0
    for i, app_id in enumerate(ids):
        try:
            if fixture:
                d = json.load(open(os.path.join(fixture, app_id + ".json")))
            else:
                if i:
                    time.sleep(PAUSE_S)
                d = fetch(app_id)
            rows.append(row(d, today, app_id))
        except Exception as e:  # one dead listing must not stop the others
            failed += 1
            print("FAILED %s: %s" % (app_id, e), file=sys.stderr)
    print("added %d row(s) to %s" % (append(rows), os.path.relpath(CSV_PATH, ROOT)))
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
