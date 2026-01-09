import QtQuick 2.0
import "helper.js" as Helper

GameBase {
    id: game
    swipeArea: swipeArea

    design: Component { TileDesign { } }

    //list the compound position for all direction
    property var leftVectors: Helper.getVectors("left")
    property var rightVectors: Helper.getVectors("right")
    property var upVectors: Helper.getVectors("up")
    property var downVectors: Helper.getVectors("down")

    moveDoMergeAvailable: function() {
        return Helper.mergeAvailable(leftVectors, tiles) || Helper.mergeAvailable(upVectors, tiles)
    }

    Rectangle {
        id: background;
        color: "white";
        opacity: 0.05;
        radius: width / 50;
        anchors.fill: parent;
    }

    SwipeArea {
        id: swipeArea;
        repeat: false;
        anchors.fill: parent;
        onMoveLeft:  { move (leftVectors);  moves++;}
        onMoveRight: { move (rightVectors); moves++;}
        onMoveUp:    { move (upVectors);    moves++;}
        onMoveDown:  { move (downVectors);  moves++;}
    }

    TileGrid {
        size: parent.size;
        padding: parent.padding;
        anchors {
            fill: parent;
            margins: padding;
        }

        // TODO: the following is not any different from HexaGame, need to move this to GameBase
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