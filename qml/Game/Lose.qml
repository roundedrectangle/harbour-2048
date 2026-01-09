import QtQuick 2.0

Rectangle {
    id: loseComponent;
    anchors.fill: parent;
    visible: false;
    color: Qt.rgba(1,1,1,0.8);

    property int bestTile      : 0;
    property int classicScore  : 0;
    property int moves         : 0;
    property int improvedScore : 0;

    Column {
        anchors.centerIn: parent;
        Text {
            id: noMoveText;
            text: "No moves available";
            font.pixelSize: 30;
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter;
            text: "Best tile : " + bestTile
            font.pixelSize: 30;
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter;
            text: "Classic score : " + classicScore
            font.pixelSize: 30;
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter;
            text: "Improved score : " + improvedScore
            font.pixelSize: 30;
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter;
            text: "Moves : " + moves
            font.pixelSize: 30;
        }
    }

    MouseArea {
        anchors.fill: parent;

        onClicked: {
            if (loseComponent.opacity === 1) { loseComponent.opacity = 0.1; }
            else { loseComponent.opacity = 1; }
        }
    }
}
