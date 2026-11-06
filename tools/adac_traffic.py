#!/usr/bin/env python3
"""Command line client for the ADAC traffic news BFF endpoint.

Usage:
    adac_traffic.py [options] <federal-state>
    adac_traffic.py [options] --street <street>
    adac_traffic.py BW
    adac_traffic.py --street A1
    adac_traffic.py --country D --json HE

The endpoint is a GraphQL BFF (https://www.adac.de/bff) that is queried via
POST. The query itself is registered as a persisted query and is therefore
only referenced by its sha256 hash (see HASH below). The hash originates from
the apollo client used by the ADAC web frontend.
"""

import argparse
import json
import sys
import urllib.error
import urllib.request

BFF_URL = "https://www.adac.de/bff"
OPERATION_NAME = "TrafficNewsLegacy"
# Persisted query hash as used by the ADAC web frontend (@apollo/client)
HASH = "55e9b1be3d4f172ed4eab90e533609cd8e36546d40d84643ec5d1d96cb63c442"

FEDERAL_STATES = [
    "BW", "BY", "BE", "BB", "HB", "HH", "HE", "MV",
    "NI", "NW", "RP", "SL", "SN", "ST", "SH", "TH",
]


def build_payload(country, federal_state, street, show_construction_sites, page_number):
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
                "sha256Hash": HASH,
            },
        },
    }


def fetch_traffic_news(country, federal_state, street, show_construction_sites, page_number):
    payload = build_payload(country, federal_state, street,
                            show_construction_sites, page_number)
    request = urllib.request.Request(
        BFF_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Content-Type": "application/json",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) harbour-adac-traffic-cli",
            "Origin": "https://www.adac.de",
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
    print("%d traffic message(s), %d on this page" % (traffic.get("size", 0), len(items)))
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
        description="Query the ADAC traffic news for a German federal state.")
    parser.add_argument("federal_state", nargs="?", default=None,
                        help="Federal state code, e.g. BW, BY, HE, NW (%s)"
                             % "/".join(FEDERAL_STATES))
    parser.add_argument("--country", default="D",
                        help="Country code (default: D)")
    parser.add_argument("--street", default="",
                        help="Search by street (e.g. A1) instead of, or in "
                             "addition to, a federal state")
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
        print("HTTP error %d: %s" % (error.code, error.read().decode("utf-8", "replace")),
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
