import QtQuick 2.0

Rectangle {
    width: 360
    height: 360
    Game {
        anchors.centerIn: parent;
        width: Math.min(parent.width, parent.height);
        height: Math.min(parent.width, parent.height);
        size: 2;
    }

    /*HexaGame {
        size: 3;
        padding: 20;
        anchors.fill: parent
        anchors.margins: 20
        width: Math.min(parent.width, parent.height);
        height: Math.min(parent.width, parent.height);
    }*/
}

