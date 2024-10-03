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
