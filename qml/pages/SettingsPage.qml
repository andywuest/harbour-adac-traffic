/*
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
import "."
import "../components"
import "../js/constants.js" as Constants
import "../js/functions.js" as Functions
import Nemo.Configuration 1.0
import QtQuick 2.2
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0

Page {
    id: settingsPage

    signal settingsChanged()

    function addToStateModel(state) {
        stateComboBoxItems.append({
            "text": qsTr(state)
        });
    }

    Component.onCompleted: {
        for (var i = 0; i < Constants.STATE_MAP.length; i++) {
            addToStateModel(Constants.STATE_MAP[i]);
        }
    }
    onStatusChanged: {
        if (status === PageStatus.Deactivating) {
            Functions.log("[SettingsPage] store settings!");
            trafficDataSettings.streetName = streetNameTextField.text;
            trafficDataSettings.state = stateComboBox.currentIndex;
            trafficDataSettings.sync();
            // TODO wird auf aufgerufen, wenn man in die combobox navigiert ->
            settingsChanged();
        }
        if (status === PageStatus.Activating) {
            Functions.log("[SettingsPage] init via settings!");
            stateComboBox.currentIndex = trafficDataSettings.state;
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
                //: SettingsPage country explanation
                description: qsTr("Country for which you want the traffic data")

                menu: ContextMenu {
                    onActivated: {
                        trafficDataSettings.country = index;
                    }

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

                }

            }

            ListModel {
                id: stateComboBoxItems
            }

            ComboBox {
                id: stateComboBox

                //: SettingsPage state
                label: qsTr("State")
                //: SettingsPage state explanation
                description: qsTr("State for which you want the traffic data")
                visible: countryComboBox.currentIndex === Constants.COUNTRY_GERMANY

                menu: ContextMenu {
                    onActivated: {
                        trafficDataSettings.state = index;
                    }

                    Repeater {
                        model: stateComboBoxItems

                        delegate: MenuItem {
                            text: model.text
//                            onClicked: {
//                                console.log("index :  " + index);
//                            }
                        }

                    }

                }

            }

            TextSwitch {
                id: stockAlarmTextSwitch

                //: SettingsPage show construction sites
                text: qsTr("Show construction sites")
                //: SettingsPage show constructions sites description
                description: qsTr("Additionally display construction sites on the street.")
                checked: trafficDataSettings.showConstructionSites
                onCheckedChanged: {
                    trafficDataSettings.showConstructionSites = checked;
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
