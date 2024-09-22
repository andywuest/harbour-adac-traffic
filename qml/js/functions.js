.pragma library

Qt.include('constants.js');

function log(message) {
    if (loggingEnabled && message) {
        console.log(message);
    }
}

function countryToIsoCode(countryName) {
    if ("Deutschland" === countryName) {
        return "de";
    }
}

function determineIconPath(country, street) {
    return "../icons/" + countryToIsoCode(country) + "/" + street.toLowerCase() + ".svg";
}

function determineHeadlineText(headline) {
    // TODO -> better icon for pointer
    return headline.text ? headline.text : headline.from + " -> " + headline.to;
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
