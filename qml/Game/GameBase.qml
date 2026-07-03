import QtQuick 2.0
import "helper.js" as Helper
import "gameMode.js" as Mode

Item {
    id: game

    property var swipeArea

    property alias componentTile: componentTile

    property int size         : 3;  // size of the board; for tetra => number of vertical slot and horizontal slot

    property int bestTile      : 0;  // best current board tile
    property int classicScore  : 0;
    property int moves         : 0;
    property int improvedScore : 0;

    property var improvedScoreTable: {2:1, 4:2, 8:3, 16:4, 32:5, 64:6, 128:7, 256:8, 512:9, 1024:10, 2048:11, 4096:12, 8192:13, 16384:14, 32768:15}

    property var initState : undefined; // state of the board at the start of the game
    property var slots     : [];        // tile slot list, for tetra count = size * size
    property var tiles     : [];         // tile list
    property var tilesCount: ({});  // count how many of each tiles we added;

    property var modes: {
        0: { // Classic
            0: Mode.addTilesClassicEasy,
            1: Mode.addTilesClassicNormal,
            2: Mode.addTilesClassicHard,
        },
        1: { // Adventure
            0: Mode.addTilesAdventureNormal,
            1: Mode.addTilesAdventureNormal,
            2: Mode.addTilesAdventureNormal
        }
    }
    property var mode: modes[0][1] // behavior when adding tile to the board

    property int padding          : (width * 0.02);
    property Component design
    property Component animation  : Component { TileAnimation {} }
    property alias loseDesign: loseLoader.sourceComponent

    Loader {
        id: loseLoader
        anchors.fill: parent
        z: 1
        active: !swipeArea.enabled
    }

    signal lose
    signal restart
    signal save

    onLose:
        swipeArea.enabled = false

    onRestart: {
        swipeArea.enabled = true
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
        mode(number, tiles, slots, size, componentTile, tilesCount)
    }

    property var moveDoMergeAvailable

    function move(vectors) {
        var moved = Helper.dealWithVectors(vectors, tiles);
        if (moved) { addTiles(1); }
        else {
            var freeSpace = Helper.getFreeSpace(tiles, slots);
            console.debug("freeSpace", freeSpace)
            if (freeSpace.length === 0) {
                console.debug("no space available");
                var mergeAvailable = moveDoMergeAvailable()
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
}
