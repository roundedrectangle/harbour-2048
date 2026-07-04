import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    property alias label: label.text
    property alias value: value.text

    width: parent.width / 2
    height: parent.height

    color: Theme.rgba(Theme.overlayBackgroundColor, Theme.opacityHigh)
    radius: Theme.paddingSmall

    Column {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.paddingMedium

        Label {
            id: label
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
            font.family: Theme.fontFamilyHeading
        }
        Label {
            id: value
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
            font.family: Theme.fontFamilyHeading
        }
    }
}
