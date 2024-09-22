import QtQuick 2.0

import Sailfish.Silica 1.0

Row {
    id: titleRow
    width: parent.width
    spacing: Theme.paddingSmall

    property alias headlineText: headlineText.text
    property alias headlineIconPath: titleRowImage.source

    property int iconWidth: Theme.iconSizeSmallPlus + Theme.paddingMedium

    Label {
        width: iconWidth

        Image {
           id: titleRowImage
           width: Theme.iconSizeSmallPlus
           fillMode: Image.PreserveAspectFit
           anchors.verticalCenter: parent.verticalCenter
        }

    }

    Label {
        id: headlineText
        width: parent.width - iconWidth
    }

}
