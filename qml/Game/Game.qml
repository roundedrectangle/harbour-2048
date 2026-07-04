import QtQuick 2.0
import "helper.js" as Helper

GameBase {
    id: game

    //list the compound position for all direction
    readonly property var leftVectors: Helper.getVectors(size, Helper.vectorFactories.left)
    readonly property var rightVectors: Helper.getVectors(size, Helper.vectorFactories.right)
    readonly property var upVectors: Helper.getVectors(size, Helper.vectorFactories.top)
    readonly property var downVectors: Helper.getVectors(size, Helper.vectorFactories.bottom)

    checkMergeAvailable: function() {
        return Helper.mergeAvailable(leftVectors, tiles) || Helper.mergeAvailable(upVectors, tiles)
    }

    property alias background: background
    Rectangle {
        id: background
        anchors.fill: parent
        radius: width / 50
        color: Qt.rgba(1, 1, 1, 0.05)
    }

    SwipeArea {
        id: swipeArea
        anchors.fill: parent
        onMoveLeft: move(leftVectors)
        onMoveRight: move(rightVectors)
        onMoveUp: move(upVectors)
        onMoveDown: move(downVectors)
    }
    swipeArea: swipeArea

    tileGrid: TileGrid { parent: game }
}
