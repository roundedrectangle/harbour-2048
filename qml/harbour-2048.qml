import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "pages"
import "cover"

ApplicationWindow {
    id: app
    cover: Component { CoverPage {} }
    initialPage: Component { MainPage {} }

    readonly property var modeStrings: [qsTr("Classic"), qsTr("Adventure")]
    readonly property var difficultyStrings: [qsTr("Easy"), qsTr("Normal"), qsTr("Hard")]
    readonly property var tileFormatStrings: [qsTr("TetraTile"), qsTr("HexaTile")]

    property string contextSuffix: ['', config.mode, config.difficulty, config.tileFormat, config.size].join(':')

    property alias gameConfig: gameConfig

    ConfigurationGroup {
        id: config
        path: '/apps/harbour-2048'

        property int version: 0

        property int size: 4
        property int difficulty: 1 // Easy, Normal, Hard
        property int mode: 0 // Classic, Adventure (Adventure not yet implemented)
        property int tileFormat: 0 // TetraTile, HexaTile

        property int score

        function getContextDependantValue(prefix, defaultValue) {
            return value(prefix + contextSuffix, defaultValue)
        }
        function setContextDependantValue(prefix, value) {
            setValue(prefix + contextSuffix, value)
        }

        function getBestValue(type, defaultValue) {
            return getContextDependantValue('best' + type, defaultValue)
        }
        function setBestValue(type, value) {
            setContextDependantValue('best' + type, value)
        }

        ConfigurationGroup {
            id: gameConfig
            path: [config.mode, config.difficulty, config.tileFormat, config.size].join(':')

            // array of tile values (ints)
            ConfigurationValue {
                id: gameState
                key: [config.path, gameConfig.path, 'state'].join('/')
            }
            //property var state: [] // fails with 'MDConf: no conversion for "/mypath" QVariant(QJSValue, )'
            property alias state: gameState.value

            property int bestTile // best current board tile
            property int classicScore
            property int moves
            property int improvedScore

            property int bestBestTile
            property int bestClassicScore
            property int bestMoves
            property int bestImprovedScore

            onBestTileChanged: bestBestTile = Math.max(bestBestTile, bestTile)
            onClassicScoreChanged: bestClassicScore = Math.max(bestClassicScore, classicScore)
            onMovesChanged: bestMoves = Math.max(bestMoves, moves)
            onImprovedScoreChanged: bestImprovedScore = Math.max(bestImprovedScore, improvedScore)
        }

        ConfigurationGroup {
            id: migrateGroup

            ConfigurationValue {
                id: migrateStateValue
                key: [config.path, migrateGroup.path, 'state'].join('/')
            }
        }

        Component.onCompleted:
            if (version == 0) {
                console.log("Migrating from version 0")
                var keys = [
                    'bestTile', 'classicScore', 'moves', 'improvedScore',
                    'bestBestTile', 'bestClassicScore', 'bestMoves', 'bestImprovedScore',
                ]

                // Old values are not cleared just in case
                for (var mode = 0; mode <= 1; mode++)
                    for (var difficulty = 0; difficulty <= 2; difficulty++)
                        for (var size = 2; size <= 6; size++) {
                            var isTetraTile = true
                            var oldKeySuffix = '' + mode + difficulty + size

                            function setMigrateGroupPath() {
                                migrateGroup.path = [mode, difficulty, +!isTetraTile, size].join(':')
                            }
                            setMigrateGroupPath()

                            var oldStateValue = value(oldKeySuffix)
                            if (oldStateValue) {
                                console.log("Migrating state", oldKeySuffix, oldStateValue)
                                var state = oldStateValue.split(',').map(function (x) { return parseInt(x) })

                                // < 3.1 has a bug, tileFormat was ignored when saving. We try to guess it here
                                // If the count of tiles is a perfect square, it's a TetraTile
                                isTetraTile = Math.sqrt(state.length) % 1 == 0
                                console.log("Is TetraTile:", isTetraTile)
                                setMigrateGroupPath()
                                migrateStateValue.value = state
                                //setValue(oldKeySuffix, undefined)
                            }

                            keys.forEach(function(key) {
                                var oldKey = key + oldKeySuffix
                                var val = value(oldKey)
                                if (typeof val === 'undefined')
                                    return

                                console.log("Migrating:", oldKey, migrateGroup.path, key, val)
                                migrateGroup.setValue(key, val)
                                //setValue(oldKey, undefined)
                            })
                        }

                version = 1
            }
    }
}
