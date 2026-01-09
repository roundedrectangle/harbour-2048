import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

Item {
    property var label;
    property var value;

    width: parent.width/2;
    height: parent.height;


    Rectangle {
        color: Theme.highlightColor;
        radius: 5;
        opacity: 0.15;
        anchors.fill: parent;
    }
    Column
    {
        anchors.verticalCenter: parent.verticalCenter;
        anchors.fill: parent;
        Label {
            text: label;
            font.pixelSize: Theme.fontSizeSmall;
            color: Theme.highlightColor;
            font.family: Theme.fontFamilyHeading;
            anchors.horizontalCenter: parent.horizontalCenter;
        }
        Label {
            text: value;
            font.pixelSize: Theme.fontSizeSmall;
            color: Theme.highlightColor;
            font.family: Theme.fontFamilyHeading;
            anchors.horizontalCenter: parent.horizontalCenter;
        }
    }
}
