import QtQuick 2.0
import 'mathutils.js' as MathUtils
import "helper.js" as Helper
import "gameMode.js" as Mode

Item {
    id: game

    property alias tileComponent: tileComponent

    property bool loaded
    property bool fresh: true

    property int size: 3 // size of the board; for tetra => number of vertical slot and horizontal slot

    // state (array of tiles), bestTile (best current board tile), classicScore, moves, improvedScore
    property var gameConfig

    property var tiles: [] // tile list
    property var tilesCount: ({}) // count how many of each tiles we added

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

    property SwipeAreaBase swipeArea
    property TileGridBase tileGrid

    property int padding: width * 0.02
    property Component design
    property Component animation: Component { TileAnimation {} }

    property bool lost: !swipeArea.enabled
    property alias loseDesign: loseLoader.sourceComponent

    Loader {
        id: loseLoader
        anchors.fill: parent
        z: 1
        active: lost
    }

    function checkLost() {
        var freeSpace = Helper.getFreeSpace(tiles, tileGrid)
        console.debug("freeSpace", freeSpace)
        if (!freeSpace.length && !checkMergeAvailable())
            lose()
    }

    function loadFromState() {
        console.log("Loading from state")
        fresh = true
        for (var i in gameConfig.state) {
            var value = gameConfig.state[i]
            if (value) {
                tiles[i] = tileComponent.createObject(tileGrid.getSlot(i), {value: value})
                gameConfig.bestTile = Math.max(gameConfig.bestTile, value)
            }
        }

        checkLost()
    }

    function destroyAllTiles() {
        console.log("Destroying all")
        for (var i in tiles) {
            var tile = tiles[i]
            if (tile) {
                tile.destroy()
                tiles[i] = undefined
            }
        }
    }

    Component.onCompleted: {
        if (gameConfig.state && gameConfig.state.length)
            loadFromState()
        else {
            tiles[size * size - 1] = undefined
            addTiles(2)
        }
        loaded = true
    }

    function reload() {
        if (!loaded) return

        console.log("Reloading")
        swipeArea.enabled = true
        destroyAllTiles()
        tiles = []
        if (gameConfig.state && gameConfig.state.length)
            loadFromState()
        else {
            tiles[size * size - 1] = undefined
            loadNewGame()
        }
    }

    function lose() {
        swipeArea.enabled = false
    }

    function loadNewGame() {
        console.log("Loading a new game")
        fresh = true
        gameConfig.bestTile = gameConfig.classicScore = gameConfig.moves = gameConfig.improvedScore = 0
        addTiles(2)
        for (var i in tiles) {
            var tile = tiles[i]
            if (tile)
                gameConfig.bestTile = Math.max(gameConfig.bestTile, tile.value)
        }
    }

    function restart() {
        console.log("Restarting")
        swipeArea.enabled = true
        destroyAllTiles()
        loadNewGame()
    }

    onModeChanged: reload()
    // when sizeChanged is emitted in GameBase, slots in tile grid aren't updated yet
    //onSizeChanged: reload()
    Connections {
        target: tileGrid
        onSlotsChanged: reload()
    }
    Connections {
        target: gameConfig
        onStateChanged:
            // This is used when migrating
            if (fresh) {
                console.log("State changed for a fresh game, reloading")
                reload()
            }
    }

    function save() {
        console.log("Save")
        var tilesState = []
        for (var i=0; i < tiles.length; i++) {
            var tile = tiles[i]
            tilesState.push(tile && tile.value ? tile.value : 0)
        }
        gameConfig.state = tilesState
    }
    Component.onDestruction: save()

    function addTiles(number) {
        mode(number, tiles, tileGrid, size, tileComponent, tilesCount)
    }

    property var checkMergeAvailable

    function move(vectors) {
        fresh = false
        var moved = Helper.dealWithVectors(size, tileGrid, vectors, tiles)
        if (moved) {
            addTiles(1)
            gameConfig.moves++
        } else
            checkLost()
    }

    Component {
        id: tileComponent

        Tile {
            design: game.design
            animation: game.animation
            onHasMerged: {
                gameConfig.classicScore += value
                gameConfig.improvedScore += value > 1 ? MathUtils.log2(value) - 1 : 0
                gameConfig.bestTile = Math.max(gameConfig.bestTile, value)
            }
        }
    }
}
