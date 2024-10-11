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
    id: titleRow

    property alias headlineText: headlineText.text
    property alias headlineIconPath: titleRowImage.source
    property alias hasIcon: iconLabel.visible
    property int iconWidth: Theme.iconSizeSmallPlus + Theme.paddingMedium

    width: parent.width
    spacing: Theme.paddingSmall

    Label {
        id: iconLabel

        width: iconWidth

        Image {
            id: titleRowImage

            visible: iconLabel.visible
            width: Theme.iconSizeSmallPlus
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
        }

    }

    Label {
        id: headlineText

        width: parent.width - (iconLabel.visible ? iconWidth : 0)
        truncationMode: TruncationMode.Fade
    }

}
