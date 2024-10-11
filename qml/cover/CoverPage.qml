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
import "../components"
import "../js/functions.js" as Functions
import QtQuick 2.6
import Sailfish.Silica 1.0

CoverBackground {
    id: coverPage

    function trafficNewsCountChangedResult(count) {
        Functions.log("[CoverPage] - count : " + count);
        trafficItemsCountText.text = (count < 0 ? "--" : "" + count);
    }

    Component.onCompleted: {
        app.trafficNewsCountChanged.connect(trafficNewsCountChangedResult);
    }

    Column {
        anchors.fill: parent
        anchors.margins: Theme.paddingLarge
        spacing: Theme.paddingMedium

        Row {
            width: parent.width
            spacing: Theme.paddingMedium

            Text {
                id: trafficItemsCountText

                font.pixelSize: Theme.fontSizeHuge
                color: Theme.primaryColor
                text: "--"
            }

            Label {
                id: trafficItemsText

                font.pixelSize: Theme.fontSizeExtraSmall
                width: parent.width - trafficItemsCountText.width - Theme.paddingMedium
                wrapMode: Text.Wrap
                anchors.verticalCenter: trafficItemsCountText.verticalCenter
                maximumLineCount: 2
                truncationMode: TruncationMode.Fade
                text: qsTr("traffic news items")
            }

        }

    }

}
