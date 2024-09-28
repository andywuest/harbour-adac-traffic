import QtQuick 2.0
import Sailfish.Silica 1.0

Label {
    property alias incidenTypeIconPath: typeImage.source

    width: parent.width
    topPadding: Theme.paddingLarge

    Image {
        id: typeImage

        width: Theme.iconSizeMedium
        //source: "../icons/type/baustelle.png"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
    }

}
