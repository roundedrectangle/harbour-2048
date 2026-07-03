import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    anchors.fill: parent
    color: Theme.rgba(Theme.overlayBackgroundColor, Theme.opacityOverlay)

    property bool hidden
    opacity: hidden ? 0.1 : 1
    radius: Theme.paddingSmall

    Column {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter

        Label {
            width: parent.width
            anchors.bottomMargin: Theme.paddingLarge
            text: qsTr("No moves available")
            font.pixelSize: Theme.fontSizeLarge
            horizontalAlignment: Text.AlignHCenter
        }

        DetailItem {
            label: qsTr("Best tile")
            value: game.bestTile
        }
        DetailItem {
            label: qsTr("Classic score")
            value: game.classicScore
        }
        DetailItem {
            label: qsTr("Improved score")
            value: game.improvedScore
        }
        DetailItem {
            label: qsTr("Moves")
            value: game.moves
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: hidden = !hidden
    }
}
