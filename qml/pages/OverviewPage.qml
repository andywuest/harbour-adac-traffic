import "../components"
import "../components/thirdparty"
import "../js/constants.js" as Constants
import "../js/functions.js" as Functions
import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property bool loading: false
    property bool errorOccured: false
    property bool trafficDataPresent: false
    property date lastUpdate

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    function receiveSettingsChanged() {
        Functions.log("[OverviewPage] - settings changed received.");
        app.reloadTrafficData(1);
    }

    function trafficDataChanged(result, error, date, clearData, lastPage) {
        Functions.log("[OverviewPage] - data has changed, error " + error + ", date : " + date + ", clearData : " + clearData);
        errorOccured = (error !== "");
        lastUpdate = new Date();
        if (clearData)
            trafficIncidentsModel.clear();

        trafficDataPresent = false;
        incidentsHeader.description = Functions.resolveCountryName(trafficDataSettings.country) + ": " + (trafficDataSettings.state > 0 ? Constants.STATE_MAP[trafficDataSettings.state] : "") + (trafficDataSettings.streetName.length > 0 ? " '" + trafficDataSettings.streetName + "'" : "");
        if (!errorOccured) {
            trafficDataPresent = (result.data.trafficNews.items.length > 0);
            for (var i = 0; i < result.data.trafficNews.items.length; i++) {
                var trafficIncident = result.data.trafficNews.items[i];
                // add missing json elements - to prevent breaking of rendering
                if (!trafficIncident.timeLoss)
                    trafficIncident.timeLoss = "";

                if (!trafficIncident.streetSign) {
                    trafficIncident.streetSign = {
                    };
                    trafficIncident.streetSign.country = "";
                }
                trafficIncidentsModel.append(trafficIncident);
            }
            if (lastPage)
                loading = false;

        } else {
            trafficDataUpdateNotification.show(error)
            loading = false;
        }
    }

    AppNotification {
        id: trafficDataUpdateNotification
    }

    Component.onCompleted: {
        app.trafficDataChanged.connect(trafficDataChanged);
        loading = true;
        app.reloadTrafficData(1);
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
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }

            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    var settingsPage = pageStack.push(Qt.resolvedUrl("SettingsPage.qml"));
                    settingsPage.settingsChanged.connect(receiveSettingsChanged);
                }
            }

            MenuItem {
                text: qsTr("Reload Traffic Data")
                onClicked: {
                    loading = true;
                    errorOccured = false;
                    console.log(">>> streetName : " + trafficDataSettings.streetName);
                    app.reloadTrafficData(1);
                }
            }

        }

        // Place our content in a Column. The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                id: incidentsHeader

                //: OverviewPage page header
                title: qsTr("Traffic Incidents")
                description: "" // getLastUpdateString();
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
                    text: qsTr("No traffic news reported for the search criteria.")
                }
            }

            Column {
                id: errorColumn

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                height: parent.height
                spacing: Theme.paddingSmall
                visible: errorOccured

                Label {
                    topPadding: Theme.paddingLarge
                    horizontalAlignment: Text.AlignHCenter
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * x
                    wrapMode: Text.Wrap
                    textFormat: Text.RichText
                    text: qsTr("Error loading traffic news.")
                }
            }

            SilicaListView {
                id: incidentsListView

                height: pageFlickable.height - incidentsHeader.height - Theme.paddingMedium
                clip: true
                width: parent.width
                Component.onCompleted: {
                }

                VerticalScrollDecorator {
                }

                model: ListModel {
                    id: trafficIncidentsModel
                }

                delegate: ListItem {
                    // enabled: menu.hasContent
                    width: parent.width
                    contentHeight: delegateCol.height + Theme.paddingLarge
                    anchors.horizontalCenter: parent.horizontalCenter

                    Column {
                        id: delegateCol

                        width: parent.width - 2 * Theme.horizontalPageMargin
                        height: childrenRect.height
                        spacing: Theme.paddingMedium

                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }

                        Row {
                            width: parent.width

                            Column {
                                width: parent.width * 1 / 6

                                IncidentSign {
                                    width: parent.width
                                    incidenTypeIconPath: Functions.determineIncidentTypeIconPath(type)
                                }

                            }

                            Column {
                                width: parent.width * 5 / 6

                                Header {
                                    id: header

                                    width: parent.width // TODO if D and street starts with I -> display text
                                    headlineIconPath: Functions.determineIconPath(streetSign.country, street)
                                    hasIcon: Functions.hasStreetIcon(streetSign.country, street)
                                    headlineText: Functions.determineHeadlineText(headline, street)
                                }

                                Label {
                                    text: "<style>" + "a { color: %1 }".arg(Theme.highlightColor) + "</style>" + "<p>" + details + "</p>"
                                    width: parent.width
                                    baseUrl: "https://asdfasdfa.sdde.de"
                                    textFormat: Text.RichText
                                    wrapMode: Text.Wrap
                                    font.pixelSize: Theme.fontSizeExtraSmall
                                    topPadding: Theme.paddingSmall
                                    bottomPadding: footer.visible ? Theme.paddingSmall : 0 // TODO padding
                                }

                                Footer {
                                    id: footer

                                    width: parent.width
                                    visible: timeLoss.length > 0
                                    timeLossText: qsTr("Zeitverlust: %1").arg(timeLoss)
                                }

                            }

                        }

                        Separator {
                            color: Theme.highlightColor
                            width: parent.width
                            horizontalAlignment: Qt.AlignHCenter
                        }

                    }

                }

            }

        }

    }

    LoadingIndicator {
        id: incidentsLoadingIndicator

        visible: loading
        opacity: loading ? 1 : 0
        height: parent.height
        width: parent.width

        Behavior on opacity {
            NumberAnimation {
            }

        }

    }

}
