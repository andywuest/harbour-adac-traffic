import QtQuick 2.2
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

// QTBUG-34418
import "."

import "../components"

import "../js/constants.js" as Constants
import "../js/functions.js" as Functions

Page {
    id: settingsPage
    signal settingsChanged()

    onStatusChanged: {
        if (status === PageStatus.Deactivating) {
            Functions.log("[SettingsPage] store settings!");
            trafficDataSettings.streetName = streetNameTextField.text;
            trafficDataSettings.sync();
            Functions.log("[SettingsPage] new streetName : " + trafficDataSettings.streetName);
            settingsChanged();
        }
    }


    SilicaFlickable {
        id: settingsFlickable
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: settingsColumn.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: settingsColumn
            width: settingsPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                //: SettingsPage settings title
                title: qsTr("Settings")
            }

            ComboBox {
                id: countryComboBox
                //: SettingsPage country
                label: qsTr("Country")
                currentIndex: trafficDataSettings.country
                //: SettingsPage download strategy explanation
                description: qsTr("Country for which you want the traffic data")
                menu: ContextMenu {
                    MenuItem {
                        //: SettingsPage country Germany
                        text: qsTr("Germany")
                    }
                    MenuItem {
                        //: SettingsPage country Austria
                        text: qsTr("Austria")
                    }
                    MenuItem {
                        //: SettingsPage country Switzerland
                        text: qsTr("Switzerland")
                    }
                    MenuItem {
                        //: SettingsPage country Italy
                        text: qsTr("Italy")
                    }
                    onActivated: {
                        trafficDataSettings.country = index
                    }
                }
            }


            TextField {
                id: streetNameTextField
                width: parent.width
                text: trafficDataSettings.streetName
                placeholderText: qsTr("Name of autobahn / street")
            }

        }

    }

}
