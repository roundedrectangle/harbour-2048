import QtQuick 2.0
import "helper.js" as Helper
import "gameMode.js" as Mode

Item {
    id: game;

    property int size         : 3;  // size of the board

    property int bestTile      : 0;  // best current board tile
    property int classicScore  : 0;
    property int moves         : 0;
    property int improvedScore : 0;

    property var improvedScoreTable: {2:1, 4:2, 8:3, 16:4, 32:5, 64:6, 128:7, 256:8, 512:9, 1024:10, 2048:11, 4096:12, 8192:13, 16384:14, 32768:15}

    property var initState : undefined; // state of the board at the start of the game
    property var slots     : [];        // tile slot list
    property var tiles     : [];        // tile list
    property var tilesCount: ({});  // count how many of each tiles we added;

    property var modes : { "ClassicEasy"   : Mode.addTilesClassicEasy,
                           "ClassicNormal" : Mode.addTilesClassicNormal,
                           "ClassicHard"   : Mode.addTilesClassicHard,
                           "AdventureEasy"   : Mode.addTilesAdventureNormal,
                           "AdventureNormal"   : Mode.addTilesAdventureNormal,
                           "AdventureHard"   : Mode.addTilesAdventureNormal}
    property var mode  : modes["ClassicNormal"] // behavior when adding tile to the board

    property int padding          : (width * 0.02);
    property Component design     : Component { HexaTileDesign { } }
    property Component animation  : Component { TileAnimation {} }
    property Component loseDesign : Component { Lose {} }

    property Item loseComponent;

    //list the compound position for all direction
    property var leftVectors  : Helper.getHexaVectors("left");
    property var rightVectors : Helper.getHexaVectors("right");
    property var upLeftVectors    : Helper.getHexaVectors("uleft");
    property var upRightVectors    : Helper.getHexaVectors("uright");
    property var downLeftVectors  : Helper.getHexaVectors("dleft");
    property var downRightVectors  : Helper.getHexaVectors("dright");

    signal lose;
    signal restart;
    signal save;

    onLose: {
        loseComponent.bestTile = game.bestTile;
        loseComponent.classicScore = game.classicScore;
        loseComponent.moves = game.moves;
        loseComponent.improvedScore = game.improvedScore;
        loseComponent.visible = true;
        swipeArea.enabled = false
    }

    onRestart: {
        loseComponent.visible = false;
        swipeArea.enabled = true;
        for (var i in tiles) {
            var tile = tiles[i];
            if (tile !== undefined) {
                tile.destroy();
                tiles[i] = undefined;
            }
        }
        bestTile = 0;
        classicScore = 0;
        moves = 0;
        improvedScore = 0;
        addTiles(2);
        for (var i in tiles) {
            var tile = tiles[i];
            if (tile !== undefined && tile.value > bestTile) {
                bestTile = tile.value;
            }
        }
    }

    onSave: {
        initState = [];
        for (var i = 0; i < tiles.length; i++) {
            var tile = tiles [i];
            if (tile !== undefined && tile !== null) {
                initState.push (tile.value);
            }
            else {
                initState.push (0);
            }
        }
    }

    function addTiles (number) {
        mode(number, tiles, slots, size, componentTile, tilesCount);
    }

    function move(vectors) {
        var moved = Helper.dealWithVectors(vectors, tiles);
        if (moved) { addTiles(1); }
        else {
            var freeSpace = Helper.getFreeSpace(tiles, slots);
            console.debug("freeSpace", freeSpace)
            if (freeSpace.length === 0) {
                console.debug("no space available");
                var mergeAvailable = Helper.mergeAvailable(leftVectors, tiles) || Helper.mergeAvailable(upLeftVectors, tiles) || Helper.mergeAvailable(upRightVectors, tiles);
                if (!mergeAvailable) { lose(); }
            }
        }
    }

    Component {
        id: componentTile;

        Tile {
            design: game.design;
            animation: game.animation;
            onHasMerged: {
                classicScore += value;
                improvedScore += improvedScoreTable[value];
                console.debug(improvedScore)
                if (value > bestTile) {
                    bestTile = value;
                }
            }
        }
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

    Component.onCompleted: {
        loseComponent = loseDesign.createObject(game);
    }
}
