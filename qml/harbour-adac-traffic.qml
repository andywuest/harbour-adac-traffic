import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

import "pages"
import "cover"

import "js/constants.js" as Constants
import "js/functions.js" as Functions

ApplicationWindow {
    id: app

    signal trafficDataChanged(var trafficData, string error, date lastUpdate)

    // Global Settings Storage
    ConfigurationGroup {
        id: trafficDataSettings
        path: "/apps/harbour-adac-traffic/settings"

        property int country: Constants.COUNTRY_GERMANY
        property int state: Constants.STATE_NONE
        property bool showConstructionSites: false
        property string streetName: ""
    }

    function getDataBackend(backendId) {
        if (Constants.BACKEND_ADAC === backendId) {
            Functions.log("[ApplicationWindow] - backend is : " + adacBackend);
            return adacBackend;
        }
    }

    function reloadTrafficData() {
        Functions.log("[ApplicationWindow] - reloadTrafficData");
        var backend = getDataBackend(Constants.BACKEND_ADAC);
        disconnectSlots(backend);
        connectSlots(backend);
        var state = (trafficDataSettings.country === Constants.COUNTRY_GERMANY) ? Constants.STATE_MAP[trafficDataSettings.state] : "";
        var country = Constants.COUNTRY_MAP[trafficDataSettings.country];
        backend.getTrafficData(country, state, trafficDataSettings.streetName, trafficDataSettings.showConstructionSites)
    }

    function connectSlots(backend) {
        Functions.log("[ApplicationWindow] - connect slot " + backend);
        backend.getTrafficDataResultAvailable.connect(getTrafficDataResultHandler);
        backend.requestError.connect(errorResultHandler);
    }

    function disconnectSlots(backend) {
        Functions.log("[ApplicationWindow] disconnect - slots");
        backend.getTrafficDataResultAvailable.disconnect(getTrafficDataResultHandler);
        backend.requestError.disconnect(errorResultHandler);
    }

    function getTrafficDataResultHandler(result) {
      Functions.log("[ApplicationWindow] result : " + result);
      trafficDataChanged(JSON.parse(result.toString()), "", new Date());
    }

    function errorResultHandler(result) {
        Functions.log("[ApplicationWindow] - result error : " + result);
        trafficDataChanged({}, result, new Date());
    }

    Component {
        id: overviewPage
        OverviewPage {
        }
    }

    Component {
        id: coverPage
        CoverPage {
        }
    }

    initialPage: overviewPage
    cover: coverPage
    allowedOrientations: defaultAllowedOrientations
}
