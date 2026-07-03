import QtQuick 2.0
import "helper.js" as Helper

GameBase {
    id: game

    // list the compound position for all direction
    property var leftVectors: Helper.getLeftHexaVectors(size)
    property var rightVectors: Helper.getRightHexaVectors(size)
    property var upLeftVectors: Helper.getUpLeftHexaVectors(size)
    property var upRightVectors: Helper.getUpRightHexaVectors(size)
    property var downLeftVectors: Helper.getDownLeftHexaVectors(size)
    property var downRightVectors: Helper.getDownRightHexaVectors(size)

    checkMergeAvailable: function() {
        return Helper.mergeAvailable(leftVectors, tiles) || Helper.mergeAvailable(upLeftVectors, tiles) || Helper.mergeAvailable(upRightVectors, tiles)
    }

    property alias background: background
    Polygon {
        id: background
        anchors.fill: parent
        side: 6
        color: 'white'
        opacity: 0.05
    }

    HexaSwipeArea {
        id: swipeArea
        anchors.fill: parent
        onMoveLeft: move(leftVectors)
        onMoveRight: move(rightVectors)
        onMoveUpLeft: move(upLeftVectors)
        onMoveUpRight: move(upRightVectors)
        onMoveDownLeft: move(downLeftVectors)
        onMoveDownRight: move(downRightVectors)
    }
    swipeArea: swipeArea

    HexaTileGrid { id: tileGrid }
    tileGrid: tileGrid
}
