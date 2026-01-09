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

    ConfigurationGroup {
        id: config
        path: '/apps/harbour-2048'

        property int size: 4
        property int difficulty: 1 // Easy, Normal, Hard
        property int mode: 0 // Classic, Adventure (Adventure not yet implemented)
        property int tileFormat: 0 // TetraTile, HexaTile

        property int score

        function getContextDependantValue(prefix, defaultValue) {
            return value(prefix + mode + difficulty + size, defaultValue)
        }
        function setContextDependantValue(prefix, value) {
            setValue(prefix + mode + difficulty + size, value)
        }

        function getBestValue(type, defaultValue) {
            return getContextDependantValue('best' + type, defaultValue)
        }
        function setBestValue(type, value) {
            setContextDependantValue('best' + type, value)
        }
    }

    Component.onDestruction: {
        game.save()
        
        config.size = app.size
        config.tileFormat = app.tileFormat
        config.difficulty = app.difficulty
        config.mode = app.mode
        config.score = app.score
    }

    property int size: config.size
    property int difficulty: config.difficulty
    property int mode: config.mode
    property int tileFormat: config.tileFormat
    property int blizt: 0
    property Item game: null
    property int score: config.score

    property int bestBestTile: config.getBestValue('BestTile', 2)
    property int bestClassicScore: config.getBestValue('ClassicScore', 0)
    property int bestMoves: config.getBestValue('Moves', 0)
    property int bestImprovedScore: config.getBestValue('ImprovedScore', 0)
}
