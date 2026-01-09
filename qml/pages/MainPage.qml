import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../Game";
import "..";
import "../storage.js" as Storage;

Page {
    id: page;

    function loadGame () {
        Storage.initialize();
        if (app.game) {
            app.game.destroy ();
        }
        var gameValues = Storage.getLabel (app.mode + app.tileFormat + app.difficulty + app.size);
        if (gameValues) {
            var t = "";
            var game = gameValues.split (",");
            console.debug (game);
            if (app.tileFormat === "HexaTile") {
                app.game = hexaGameComponent.createObject (gameContainer, { "size" : app.size, "initState": game });
            }
            else {
                app.game = gameComponent.createObject (gameContainer, { "size" : app.size, "initState": game });
            }
        }
        else {
            if (app.tileFormat === "HexaTile") {
                app.game = hexaGameComponent.createObject (gameContainer, { "size" : app.size });
            }
            else {
                app.game = gameComponent.createObject (gameContainer, { "size" : app.size });
            }
        }

        var bestBestTile      = Storage.getLabel ("bestBestTile" +      app.mode + app.tileFormat + app.difficulty + app.size);
        var bestClassicScore  = Storage.getLabel ("bestClassicScore" +  app.mode + app.tileFormat + app.difficulty + app.size);
        var bestMoves         = Storage.getLabel ("bestMoves" +         app.mode + app.tileFormat + app.difficulty + app.size);
        var bestImprovedScore = Storage.getLabel ("bestImprovedScore" + app.mode + app.tileFormat + app.difficulty + app.size);

        var bestTile      = Storage.getLabel ("bestTile" +      app.mode + app.tileFormat + app.difficulty + app.size);
        var classicScore  = Storage.getLabel ("classicScore" +  app.mode + app.tileFormat + app.difficulty + app.size);
        var moves         = Storage.getLabel ("moves" +         app.mode + app.tileFormat + app.difficulty + app.size);
        var improvedScore = Storage.getLabel ("improvedScore" + app.mode + app.tileFormat + app.difficulty + app.size);

        if (bestBestTile)      { app.bestBestTile      = bestBestTile; }
        if (bestClassicScore)  { app.bestClassicScore  = bestClassicScore; }
        if (bestMoves)         { app.bestMoves         = bestMoves; }
        if (bestImprovedScore) { app.bestImprovedScore = bestImprovedScore; }

        if (bestTile)      { app.game.bestTile      = bestTile; }
        if (classicScore)  { app.game.classicScore  = classicScore; }
        if (moves)         { app.game.moves         = moves; }
        if (improvedScore) { app.game.improvedScore = improvedScore; }

    }

    Connections {
        target: app;
        onSizeChanged       : { loadGame (); }
        onDifficultyChanged : { loadGame (); }
        onModeChanged       : { loadGame (); }
        onTileFormatChanged : { loadGame (); }
    }
    SilicaFlickable {
        id: control;
        contentHeight: column.height;
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
            bottom: gameContainer.top;
        }

        PullDownMenu {
            MenuItem {
                text: "Drop data";
                font.family: Theme.fontFamilyHeading;
                onClicked: Storage.destroyData();
                enabled: false;
                visible: enabled;
            }
            MenuItem {
                text: "Change Mode";
                font.family: Theme.fontFamilyHeading;
                onClicked: pageStack.push("ChangeMode.qml");
            }
            MenuItem {
                text: "Restart game";
                font.family: Theme.fontFamilyHeading;
                onClicked: app.game.restart();
            }
        }
        Column {
            id: column;
            spacing: Theme.paddingMedium;
            anchors {
                left: parent.left;
                right: parent.right;
                margins: Theme.paddingLarge;
            }

            PageHeader {
                title: "Mode : " + app.mode + " " + app.difficulty + " " + app.size;
            }
            ListView {
                id: scoreList
                width: page.width;
                height: 80;
                orientation : ListView.Horizontal
                clip: true;
                model: [{"label":"SCORE",    "value": app.game.classicScore, "best": app.bestClassicScore},
                        {"label":"TILE",     "value": app.game.bestTile, "best": app.bestBestTile},
                        {"label":"MOVES",    "value": app.game.moves, "best": app.bestMoves},
                        {"label":"IMPSCORE", "value": app.game.improvedScore, "best": app.bestImprovedScore}]

                property int index: app.score;

                delegate: Rectangle {
                    width: page.width;
                    height: parent.height;
                    color: "transparent"
                    Row {
                        spacing: Theme.paddingMedium;
                        anchors.left: parent.left

                        width: parent.width*.6;
                        height: 80;

                        IconButton {
                            anchors.verticalCenter: parent.verticalCenter;
                            icon.source: "image://theme/icon-m-left"
                            enabled: index > 0;
                            onClicked: {app.score--;}
                        }
                        ScoreItem {
                            label: modelData["label"];
                            value: modelData["value"];
                        }
                        ScoreItem {
                            label: "BEST";
                            value: modelData["best"];
                        }
                        IconButton {
                            anchors.verticalCenter: parent.verticalCenter;
                            icon.source: "image://theme/icon-m-right"
                            enabled: index < scoreList.model.length - 1;
                            onClicked: {app.score++;}
                        }
                    }
                }
                onDragEnded: {
                    if (contentX > index * width && index < model.length - 1) { app.score++; }
                    else if (contentX < index * width && index > 0) { app.score--; }
                    else { contentX = index * width;}
                }

                onModelChanged: positionViewAtIndex(index, ListView.Beginning)

                onIndexChanged: contentX = index * width;

                Behavior on contentX { PropertyAnimation { duration: 200;} }
            }

            Label {
                text: ""
                color: Theme.primaryColor
                font.family: Theme.fontFamilyHeading;
                font.pixelSize: Theme.fontSizeSmall;
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                anchors {
                    left: parent.left;
                    right: parent.right;
                }
            }
        }
    }
    Item {
        id: gameContainer;
        height: width;
        anchors {
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }
        Component.onCompleted: { loadGame (); }
    }

    function storageSave(bestTile, classicScore, moves, improvedScore, game) {
        Storage.setLabel ("bestBestTile" +      app.mode + app.tileFormat + app.difficulty + app.size, app.bestBestTile);
        Storage.setLabel ("bestClassicScore" +  app.mode + app.tileFormat + app.difficulty + app.size, app.bestClassicScore);
        Storage.setLabel ("bestMoves" +         app.mode + app.tileFormat + app.difficulty + app.size, app.bestMoves);
        Storage.setLabel ("bestImprovedScore" + app.mode + app.tileFormat + app.difficulty + app.size, app.bestImprovedScore);

        Storage.setLabel ("bestTile" +      app.mode + app.tileFormat + app.difficulty + app.size, bestTile);
        Storage.setLabel ("classicScore" +  app.mode + app.tileFormat + app.difficulty + app.size, classicScore);
        Storage.setLabel ("moves" +         app.mode + app.tileFormat + app.difficulty + app.size, moves);
        Storage.setLabel ("improvedScore" + app.mode + app.tileFormat + app.difficulty + app.size, improvedScore);

        Storage.setLabel (app.mode + app.tileFormat + app.difficulty + app.size, game);
    }

    Component {
        id: gameComponent;

        Game {
            design: Component { SailTileDesign {} }
            mode: modes[app.mode + app.difficulty]
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
            mode: modes[app.mode + app.difficulty]
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
