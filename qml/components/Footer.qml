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
