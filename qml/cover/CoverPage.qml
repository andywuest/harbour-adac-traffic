import "../components"
import "../js/functions.js" as Functions
import QtQuick 2.6
import Sailfish.Silica 1.0

CoverBackground {
    id: coverPage

    function trafficNewsCountChangedResult(count) {
        Functions.log("[CoverPage] - count : " + count);
        trafficItemsCountText.text = "" + count;
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
