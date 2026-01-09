import QtQuick 2.0

Rectangle {
    anchors.fill: parent
    color: "red";
    opacity: 0.5;
    radius: parent.parent.radius

    Text {
        anchors.centerIn: parent;
        text: "=";
        font.pixelSize: 40;
    }
}


