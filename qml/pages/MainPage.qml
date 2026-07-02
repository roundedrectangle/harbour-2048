import QtQuick 2.0
import Sailfish.Silica 1.0
import '../Game'
import '../components'

Page {
    id: page;

    function loadGame () {
        if (app.game)
            app.game.destroy()

        var gameValues = config.getContextDependantValue('')
        if (gameValues) {
            var t = "";
            var game = gameValues.split (",");
            console.debug (game);
            if (app.tileFormat === 1) {
                app.game = hexaGameComponent.createObject (gameContainer, { "size" : app.size, "initState": game });
            }
            else {
                app.game = gameComponent.createObject (gameContainer, { "size" : app.size, "initState": game });
            }
        }
        else {
            if (app.tileFormat === 1) {
                app.game = hexaGameComponent.createObject (gameContainer, { "size" : app.size });
            }
            else {
                app.game = gameComponent.createObject (gameContainer, { "size" : app.size });
            }
        }


        app.bestBestTile = config.getBestValue('BestTile', 2)
        app.bestClassicScore = config.getBestValue('ClassicScore', 0)
        app.bestMoves = config.getBestValue('Moves', 0)
        app.bestImprovedScore = config.getBestValue('ImprovedScore', 0)

        app.game.bestTile = config.getContextDependantValue('bestTile', 0)
        app.game.classicScore = config.getContextDependantValue('classicScore', 0)
        app.game.moves = config.getContextDependantValue('moves', 0)
        app.game.improvedScore = config.getContextDependantValue('improvedScore', 0)
    }

    Connections {
        target: app
        onSizeChanged: loadGame()
        onDifficultyChanged: loadGame()
        onModeChanged: loadGame()
        onTileFormatChanged: loadGame()
    }
    SilicaFlickable {
        id: control;
        contentHeight: column.height
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: gameContainer.top
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Change Mode")
                onClicked: pageStack.push("ChangeMode.qml")
            }
            MenuItem {
                text: qsTr("Restart game")
                onClicked: app.game.restart()
            }
        }
        Column {
            id: column;
            spacing: Theme.paddingMedium
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }

            PageHeader {
                title: qsTr("Mode: %1 %2 %3").arg(app.modeStrings[app.mode]).arg(app.difficultyStrings[app.difficulty]).arg(app.size + 2)
            }

            ListView {
                id: scoreList
                width: page.width
                height: Theme.itemSizeSmall
                orientation : ListView.Horizontal
                clip: true
                model: [{label: qsTr("SCORE"), value: app.game.classicScore, best: app.bestClassicScore},
                        {label: qsTr("TILE"), value: app.game.bestTile, best: app.bestBestTile},
                        {label: qsTr("MOVES"), value: app.game.moves, best: app.bestMoves},
                        {label: qsTr("IMPSCORE", "short for improved score"), value: app.game.improvedScore, best: app.bestImprovedScore}]

                property int index: app.score

                delegate: Rectangle {
                    width: page.width
                    height: scoreList.height
                    color: "transparent"
                    Row {
                        spacing: Theme.paddingMedium;
                        anchors.left: parent.left

                        width: parent.width*.6;
                        height: parent.height

                        IconButton {
                            anchors.verticalCenter: parent.verticalCenter;
                            icon.source: "image://theme/icon-m-left"
                            enabled: index > 0;
                            onClicked: {app.score--;}
                        }
                        ScoreItem {
                            label: modelData.label
                            value: modelData.value
                        }
                        ScoreItem {
                            label: qsTr("BEST")
                            value: modelData.best
                        }
                        IconButton {
                            anchors.verticalCenter: parent.verticalCenter
                            icon.source: "image://theme/icon-m-right"
                            enabled: index < scoreList.model.length - 1
                            onClicked: app.score++
                        }
                        Component.onCompleted: console.log(modelData.label, modelData.value, modelData.best, app.game.classicScore, app.bestClassicScore)
                    }
                }
                onDragEnded: {
                    if (contentX > index * width && index < model.length - 1)
                        app.score++
                    else if (contentX < index * width && index > 0)
                        app.score--
                    else
                        contentX = index * width;
                }

                onModelChanged: positionViewAtIndex(index, ListView.Beginning)

                onIndexChanged: contentX = index * width

                Behavior on contentX { PropertyAnimation { duration: 200 } }
            }

            Label {
                text: ""
                color: Theme.primaryColor
                font.family: Theme.fontFamilyHeading
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }
    Item {
        id: gameContainer
        height: width
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        Component.onCompleted: loadGame()
    }

    function storageSave(bestTile, classicScore, moves, improvedScore, game) {
        config.setBestValue('BestTile', app.bestBestTile)
        config.setBestValue('ClassicScore', app.bestClassicScore)
        config.setBestValue('Moves', app.bestMoves)
        config.setBestValue('ImprovedScore', app.bestImprovedScore)

        config.setContextDependantValue('bestTile', bestTile)
        config.setContextDependantValue('classicScore', classicScore)
        config.setContextDependantValue('moves', moves)
        config.setContextDependantValue('improvedScore', improvedScore)

        config.setContextDependantValue('', game)
    }

    Component {
        id: gameComponent;

        Game {
            design: Component { SailTileDesign {} }
            mode: modes[app.mode][app.difficulty]
            anchors {
                fill: parent;
                margins: Theme.paddingLarge;
            }
            onBestTileChanged:      { if (bestTile > app.bestBestTile)           { app.bestBestTile      = bestTile; } }
            onClassicScoreChanged:  { if (classicScore > app.bestClassicScore)   { app.bestClassicScore  = classicScore; } }
            onMovesChanged:         { if (moves > app.bestMoves)                 { app.bestMoves         = moves; } }
            onImprovedScoreChanged: { if (improvedScore > app.bestImprovedScore) { app.bestImprovedScore = improvedScore; } }
            onSave: {
                storageSave(bestTile, classicScore, moves, improvedScore, initState.join (","));
            }
        }
    }
    Component {
        id: hexaGameComponent;

        HexaGame {
            design: Component { SailHexaDesign {} }
            mode: modes[app.mode][app.difficulty]
            anchors {
                fill: parent;
                margins: Theme.paddingLarge;
            }
            onBestTileChanged:      { if (bestTile > app.bestBestTile)           { app.bestBestTile      = bestTile; } }
            onClassicScoreChanged:  { if (classicScore > app.bestClassicScore)   { app.bestClassicScore  = classicScore; } }
            onMovesChanged:         { if (moves > app.bestMoves)                 { app.bestMoves         = moves; } }
            onImprovedScoreChanged: { if (improvedScore > app.bestImprovedScore) { app.bestImprovedScore = improvedScore; } }
            onSave: {
                storageSave(bestTile, classicScore, moves, improvedScore, initState.join (","));
            }
        }
    }
}
