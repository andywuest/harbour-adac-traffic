import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

import "pages"
import "cover"

import "js/constants.js" as Constants
import "js/functions.js" as Functions

ApplicationWindow {
    id: app

    signal trafficDataChanged(var trafficData, string error, date lastUpdate, bool clearData, bool lastPage)
    signal trafficNewsCountChanged(int count)

    property int currentPage: 1

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

    function reloadTrafficData(page) {
        currentPage = page;
        Functions.log("[ApplicationWindow] - reloadTrafficData - page : " + page);
        var backend = getDataBackend(Constants.BACKEND_ADAC);
        disconnectSlots(backend);
        connectSlots(backend);
        var state = (trafficDataSettings.country === Constants.COUNTRY_GERMANY) ? Constants.STATE_MAP[trafficDataSettings.state] : "";
        var country = Constants.COUNTRY_MAP[trafficDataSettings.country];
        backend.getTrafficData(country, state, trafficDataSettings.streetName, trafficDataSettings.showConstructionSites, page)
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
      var jsonResult = JSON.parse(result.toString());
      var numberOfResults = jsonResult.data.trafficNews.size;
      Functions.log("[ApplicationWindow] getTrafficDataResultHandler - count  : " + numberOfResults);
      var clearData = (currentPage == 1);
      var lastPage = true;
      if (numberOfResults > (currentPage * 10)) {
         lastPage = false;
         reloadTrafficData(currentPage + 1);
         Functions.log("[ApplicationWindow] getTrafficDataResultHandler - reloading next page " + (currentPage + 1));
      }
      trafficDataChanged(jsonResult, "", new Date(), clearData, lastPage);
      trafficNewsCountChanged(numberOfResults);
    }

    function errorResultHandler(result) {
        Functions.log("[ApplicationWindow] - result error : " + result);
        trafficDataChanged({}, result, new Date(), true, true);
        trafficNewsCountChanged(-1);
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
