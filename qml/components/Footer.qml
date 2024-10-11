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
import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    id: timeLossRow

    property alias timeLossText: timeLossLabel.text
    property int iconWidth: Theme.iconSizeSmall - Theme.paddingSmall

    width: parent.width
    spacing: Theme.paddingSmall

    Label {
        width: iconWidth

        Image {
            id: titleRowImage

            width: iconWidth
            fillMode: Image.PreserveAspectFit
            source: "image://theme/icon-s-time" + "?" + Theme.primaryColor
            anchors.verticalCenter: parent.verticalCenter
        }

    }

    Label {
        id: timeLossLabel

        width: parent.width - iconWidth
        topPadding: Theme.paddingSmall
        font.pixelSize: Theme.fontSizeExtraSmall
    }

}
