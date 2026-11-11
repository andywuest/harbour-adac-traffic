#!/usr/bin/env python3
"""Command line client for the ADAC traffic news BFF endpoint.

The ADAC traffic page (https://www.adac.de/verkehr/verkehrsinformationen/de/)
loads its data from a GraphQL BFF at https://www.adac.de/bff using an Apollo
persisted query. Only the sha256 hash of the query is transmitted; the query
itself is stored server-side. This client replays that request.

Usage:
    adac_traffic_get.py BW
    adac_traffic_get.py --street A8
    adac_traffic_get.py BW --street A8
    adac_traffic_get.py --country D --json HE
"""

import argparse
import json
import sys
import urllib.error
import urllib.request

BFF_URL = "https://www.adac.de/bff"
OPERATION_NAME = "TrafficNewsLegacy"

# Persisted query hashes used by the ADAC web frontend (@apollo/client).
# Both are accepted by the BFF regardless of the filter combination.
HASHES = (
    "944138708dd320c402fd63d04bc7254b18c94dfdc1ffd6b264a5e2bbb6674e41",
    "55e9b1be3d4f172ed4eab90e533609cd8e36546d40d84643ec5d1d96cb63c442",
)

FEDERAL_STATES = [
    "BW", "BY", "BE", "BB", "HB", "HH", "HE", "MV",
    "NI", "NW", "RP", "SL", "SN", "ST", "SH", "TH",
]


def build_payload(country, federal_state, street, show_construction_sites,
                  page_number, sha256_hash):
    return {
        "operationName": OPERATION_NAME,
        "variables": {
            "filter": {
                "country": country,
                "federalState": federal_state,
                "street": street,
                "showConstructionSites": show_construction_sites,
                "pageNumber": page_number,
            }
        },
        "extensions": {
            "clientLibrary": {
                "name": "@apollo/client",
                "version": "4.1.9",
            },
            "persistedQuery": {
                "version": 1,
                "sha256Hash": sha256_hash,
            },
        },
    }


def fetch_traffic_news(country, federal_state, street, show_construction_sites,
                       page_number, sha256_hash=HASHES[0]):
    payload = build_payload(country, federal_state, street,
                            show_construction_sites, page_number, sha256_hash)
    request = urllib.request.Request(
        BFF_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Origin": "https://www.adac.de",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) harbour-adac-traffic-cli",
        },
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        return json.loads(response.read().decode("utf-8"))


def item_summary(item):
    direction = item.get("headlineDirection")
    if direction:
        headline = "%s %s -> %s" % (item.get("street", ""),
                                    direction.get("from", ""),
                                    direction.get("to", ""))
    else:
        headline = item.get("headlineNonDirection", item.get("street", ""))
    caption = (item.get("image") or {}).get("caption", "")
    details = item.get("details", "")
    return headline, caption, details


def print_human(result):
    traffic = result.get("data", {}).get("trafficNewsLegacy", {})
    items = traffic.get("items", [])
    print("%d traffic message(s), %d on this page"
          % (traffic.get("size", 0), len(items)))
    print()
    for item in items:
        headline, caption, details = item_summary(item)
        if caption:
            print("[%s] %s" % (caption, headline))
        else:
            print(headline)
        if details:
            print("  %s" % details)
        time_loss = item.get("timeLoss")
        if time_loss:
            print("  Time loss: %s" % time_loss)
        print()


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Query the ADAC traffic news by country, federal state "
                    "and/or street.")
    parser.add_argument("federal_state", nargs="?", default=None,
                        help="Federal state code, e.g. BW, BY, HE, NW (%s)"
                             % "/".join(FEDERAL_STATES))
    parser.add_argument("--country", default="D",
                        help="Country code (default: D)")
    parser.add_argument("--street", default="",
                        help="Street to search for, e.g. A1. Can be combined "
                             "with a federal state or used on its own.")
    parser.add_argument("--page", type=int, default=1,
                        help="Page number (default: 1)")
    parser.add_argument("--construction-sites", action="store_true",
                        help="Include construction sites (default: off)")
    parser.add_argument("--json", action="store_true",
                        help="Print the raw JSON response")
    args = parser.parse_args(argv)

    if args.federal_state is None and not args.street:
        parser.error("provide a federal state and/or --street")

    if args.federal_state is None:
        state = ""
    else:
        state = args.federal_state.upper()
        if state not in FEDERAL_STATES:
            parser.error("unknown federal state %r, expected one of %s"
                         % (args.federal_state, " ".join(FEDERAL_STATES)))

    try:
        result = fetch_traffic_news(args.country.upper(), state, args.street,
                                    args.construction_sites, args.page)
    except urllib.error.HTTPError as error:
        print("HTTP error %d: %s"
              % (error.code, error.read().decode("utf-8", "replace")),
              file=sys.stderr)
        return 1
    except urllib.error.URLError as error:
        print("Request failed: %s" % error.reason, file=sys.stderr)
        return 1

    if "errors" in result:
        print("API error: %s" % json.dumps(result["errors"]), file=sys.stderr)
        return 1

    if args.json:
        json.dump(result, sys.stdout, indent=2, ensure_ascii=False)
        print()
    else:
        print_human(result)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except BrokenPipeError:
        sys.stderr.close()
        sys.exit(141)
