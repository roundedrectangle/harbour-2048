import QtQuick 2.0
import "helper.js" as Helper

GameBase {
    id: game
    swipeArea: swipeArea

    //list the compound position for all direction
    property var leftVectors: Helper.getHexaVectors("left")
    property var rightVectors: Helper.getHexaVectors("right")
    property var upLeftVectors: Helper.getHexaVectors("uleft")
    property var upRightVectors: Helper.getHexaVectors("uright")
    property var downLeftVectors: Helper.getHexaVectors("dleft")
    property var downRightVectors: Helper.getHexaVectors("dright")

    moveDoMergeAvailable: function() {
        return Helper.mergeAvailable(leftVectors, tiles) || Helper.mergeAvailable(upLeftVectors, tiles) || Helper.mergeAvailable(upRightVectors, tiles)
    }

    Polygon {
        id: background;
        color: "white";
        opacity: 0.05;
        side: 6;
        size: parent.width;
    }

    HexaSwipeArea {
        id: swipeArea;
        repeat: false;
        anchors.fill: parent;
        onMoveLeft:      { move (leftVectors);      moves++;}
        onMoveRight:     { move (rightVectors);     moves++;}
        onMoveUpLeft:    { move (upLeftVectors);    moves++;}
        onMoveUpRight:   { move (upRightVectors);   moves++;}
        onMoveDownLeft:  { move (downLeftVectors);  moves++;}
        onMoveDownRight: { move (downRightVectors); moves++;}
    }

    HexaTileGrid {
        size: parent.size;
        padding: parent.padding;
        anchors {
            fill: parent;
            margins: padding;
        }

        Component.onCompleted: {
            game.slots = slots;
            if (initState !== undefined) {
                for (var i in initState) {
                    var value = parseInt (initState [i]);
                    var slot = slots [i];
                    if (value !== 0) {
                        tiles [i] = componentTile.createObject (slot, { "value" : value });
                        if (value > bestTile) {
                            bestTile = value;
                        }
                    }
                }
            }
            else {
                tiles [size * size - 1] = undefined;
                addTiles(2);
            }
        }
    }
}