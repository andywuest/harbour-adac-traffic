/**
 * harbour-adac-traffic - Sailfish OS Version
 * Copyright © 2024 Andreas Wüst (andreas.wuest.freelancer@gmail.com)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#ifndef CONSTANTS_H
#define CONSTANTS_H

const char MIME_TYPE_JSON[] = "application/json";
const char USER_AGENT[] = "Mozilla/5.0 (X11; Linux x86_64; rv:132.0) Gecko/20100101 Firefox/132.0";
const char ADAC_URL[] = "https://www.adac.de/bff";

const char ADAC_POST_BODY[] = R"(
{
  "operationName": "TrafficNewsLegacy",
  "variables": {
    "filter": {
      "country": "%1",
      "federalState": "%2",
      "street": "%3",
      "showConstructionSites": %4,
      "pageNumber": %5
    }
  },
  "extensions": {
    "clientLibrary": {
      "name": "@apollo/client",
      "version": "4.1.9"
    },
    "persistedQuery": {
      "version": 1,
      "sha256Hash": "55e9b1be3d4f172ed4eab90e533609cd8e36546d40d84643ec5d1d96cb63c442"
    }
  }
}
)";

const char ADAC_GET_URL[] = "https://www.adac.de/bff/?operationName=TrafficNewsLegacy&variables=%7B%22filter%22%3A%7B%22country%22%3A%22{country}%22%2C%22federalState%22%3A%22{state}%22%2C%22street%22%3A%22{street}%22%2C%22showConstructionSites%22%3A{constructionSites}%2C%22pageNumber%22%3A{pageNumber}%7D%7D&extensions=%7B%22clientLibrary%22%3A%7B%22name%22%3A%22%40apollo%2Fclient%22%2C%22version%22%3A%224.1.9%22%7D%2C%22persistedQuery%22%3A%7B%22version%22%3A1%2C%22sha256Hash%22%3A%22944138708dd320c402fd63d04bc7254b18c94dfdc1ffd6b264a5e2bbb6674e41%22%7D%7D";

#endif // CONSTANTS_H
