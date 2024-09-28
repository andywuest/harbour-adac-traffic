.pragma library

Qt.include('constants.js');

function log(message) {
    if (loggingEnabled && message) {
        console.log(message);
    }
}

function countryToIsoCode(countryName) {
    if (countryName) {
        if ("Deutschland" === countryName) {
            return "de";
        }
        if ("Schweiz" === countryName) {
            return "ch";
        }
    }
    return "de"; // fallback "de", if we have no countryName
}

function hasStreetIcon(country, street) {
    if (street && street.length > 0 && street.substring(0, 1) !== "I" && street.substring(0, 1) !== "L") {
        return true;
    }
    return false;
}

function determineIconPath(country, street) {
    if (!street || street.length === 0) {
        return "../icons/empty.svg";
    }
    return "../icons/" + countryToIsoCode(country) + "/" + street.toLowerCase() + ".svg";
}

function determineHeadlineText(headline, street) {
    var result = "";
    if (street.substring(0, 1) === "I") {
        result += street + " - ";
    }
    // TODO -> better icon for pointer
    return result += (headline.text ? headline.text : headline.from + " \u2192 " + headline.to);
}

function determineIncidentTypeIconPath(incidentType) {
    return "../icons/type/" + incidentType.toLowerCase() + ".png";
}

function resolveCountryName(countryId) {
    switch(countryId) {
    case 0: return qsTr("Germany");
    case 1: return qsTr("Austria");
    case 2: return qsTr("Switzerland");
    case 3: return qsTr("Italy");
    }
}
