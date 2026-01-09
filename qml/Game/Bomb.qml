import QtQuick 2.0

import QtQuick 2.0

Rectangle {
    id: bomb
    anchors.fill: parent
    color: "red";
    opacity: 0.5;
    radius: parent.parent.radius

    Text {
        anchors.centerIn: parent;
        text: "X" + Math.abs(bomb.parent.value + 1);
        font.pixelSize: 40;
    }
}
