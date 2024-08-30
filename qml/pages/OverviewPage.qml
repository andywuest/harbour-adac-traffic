import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/thirdparty"

import "../js/functions.js" as Functions

Page {
    id: page

    property bool loading : false
    property bool errorOccured: false
    property bool trafficDataPresent: false
    property date lastUpdate

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    function trafficDataChanged(result, error, date) {
        Functions.log("[OverviewPage] - data has changed, error " + error + ", date : " + date);
        errorOccured = (error !== "");
        lastUpdate = new Date();
        trafficIncidentsModel.clear()
        trafficDataPresent = false;

        incidentsHeader.description = "TODO" // getLastUpdateString();

        if (!errorOccured) {
            trafficDataPresent = (result.data.trafficNews.items.length > 0);
            for (var i = 0; i < result.data.trafficNews.items.length; i++)   {
                var trafficIncident = result.data.trafficNews.items[i];
                trafficIncidentsModel.append(trafficIncident);
                Functions.log("[OverviewPage] added traffic incident " + trafficIncident.details);
            }
        } else {
            // TIODI
            // incidentUpdateNotification.show(error)
        }

        loading = false;
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        id: pageFlickable
        anchors.fill: parent
        visible: true
        contentHeight: parent.height
        contentWidth: parent.width

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Reload Traffic Data")
                onClicked: {
                    loading = true;
                    errorOccured = false;
                    app.reloadTrafficData();
                }
            }
        }

        // Place our content in a Column. The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium

//            Timer {
//                id: lastUpdateUpdater
//                interval: 60000
//                running: true
//                repeat: true
//                onTriggered: {
//                    Functions.log("[OverviewPage] - updating last update string ")
//                    incidentsHeader.description = getLastUpdateString();
//                }
//            }

            PageHeader {
                id: incidentsHeader
                //: OverviewPage page header
                title: qsTr("Traffic Incidents")
                description: ""// getLastUpdateString();
            }

            // TODO create component from it
            Column {
                id: noIncidentsColumn

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                height: parent.height
                spacing: Theme.paddingSmall

                visible: (!trafficDataPresent && !loading && !errorOccured)

                Label {
                    topPadding: Theme.paddingLarge
                    horizontalAlignment: Text.AlignHCenter
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * x

                    wrapMode: Text.Wrap
                    textFormat: Text.RichText
                    text: qsTr("Currently there are no incidents reported.")
                }
            }

            SilicaListView {
                id: incidentsListView

                height: pageFlickable.height - incidentsHeader.height - Theme.paddingMedium
                width: parent.width
                anchors.left: parent.left
                anchors.right: parent.right

                clip: true

                model: ListModel {
                    id: trafficIncidentsModel
                }

                delegate: ListItem {
                    contentHeight: incidentItem.height + (2 * Theme.paddingMedium)
                    contentWidth: parent.width

                    onClicked: {
                        var selectedIncident = incidentsListView.model.get(index);
                        // pageStack.push(Qt.resolvedUrl("../pages/DetailsPage.qml"), { incident: selectedIncident }) // TODO page url
                    }

                    Item {
                        id: incidentItem
                        width: parent.width
                        height: incidentRow.height + incidentSeparator.height
                        y: Theme.paddingMedium

                        Row {
                            id: incidentRow
                            width: parent.width - (2 * Theme.horizontalPageMargin)
                            spacing: Theme.paddingMedium
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            // TODO custom - hier noch pruefen, was an margins noch machbar, sinnvoll ist
                            Column {
                                id: trafficIncidentColumn
                                width: parent.width // - (2 * Theme.horizontalPageMargin)
                                // x: Theme.horizontalPageMargin
                                height: /*firstRow.height + */ /*changeValuesRow.height + iconLabelRow.height +*/ directionRow.height + detailsRow.height
                                /* + secondRow.height*/
                                        //+ changeValuesRow.height
                                        //+ (watchlistSettings.showPerformanceRow ? performanceRow.height : 0)

                                anchors.verticalCenter: parent.verticalCenter

//                                IconLabelRow {
//                                    id: iconLabelRow
//                                    lineType: Functions.resolveIconForLines(affected)
//                                    affectedLines: Functions.getListOfAffectedLines(affected)
//                                }

                                Row {
                                    id: directionRow
                                    width: parent.width
                                    height: Theme.fontSizeExtraSmall + Theme.paddingSmall

                                    Label {
                                        id: validityLabel
                                        width: parent.width
                                        height: parent.height
                                        text: headline.from + " -> " + headline.to

                                            //"A7 Karlsruhe -> Stuttgart"
                                            // Functions.createAvailabilityLabel(_fromFormatted, _toFormatted)
                                            // qsTr("On %1 until %2 ").arg(_fromFormatted).arg(_toFormatted)
                                        truncationMode: TruncationMode.Fade// TODO check for very long texts
                                        // elide: Text.ElideRight
                                        color: Theme.primaryColor
                                        font.pixelSize: Theme.fontSizeExtraSmall
                                        font.bold: true
                                        horizontalAlignment: Text.AlignLeft
                                    }
                                }

                                Row {
                                    id: detailsRow
                                    width: parent.width
                                    height: Theme.fontSizeExtraSmall + Theme.paddingSmall

                                    Label {
                                        width: parent.width
                                        height: parent.height
                                        text: details
                                            // Functions.determineQuoteDate(quoteTimestamp)
                                        truncationMode: TruncationMode.Fade
                                        color: Theme.primaryColor
                                        font.pixelSize: Theme.fontSizeExtraSmall
                                        horizontalAlignment: Text.AlignLeft
                                    }

                                }

                            }

                        }

                        Separator {
                            id: incidentSeparator
                            anchors.top: incidentRow.bottom
                            anchors.topMargin: Theme.paddingMedium

                            width: parent.width
                            color: Theme.primaryColor
                            horizontalAlignment: Qt.AlignHCenter
                        }

                    }

                }

            }
        }
    }

    Component.onCompleted: {
        app.trafficDataChanged.connect(trafficDataChanged)
        loading = true;
        app.reloadTrafficData();
    }

    LoadingIndicator {
        id: incidentsLoadingIndicator
        visible: loading
        Behavior on opacity {
            NumberAnimation {
            }
        }
        opacity: loading ? 1 : 0
        height: parent.height
        width: parent.width
    }

}
