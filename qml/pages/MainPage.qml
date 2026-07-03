import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import '../Game'
import '../components'

Page {
    id: mainPage

    SilicaFlickable {
        width: parent.width
        anchors {
            top: parent.top
            bottom: gameLoader.top
        }
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Change Mode")
                onClicked: pageStack.push('ChangeModePage.qml', {game: game})
            }
            MenuItem {
                text: qsTr("Restart game")
                onClicked: game.restart()
            }
        }
        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("%1 difficulty, %2")
                        .arg(app.difficultyStrings[config.difficulty])
                        .arg(config.tileFormat == 1 ? config.size : qsTr("%1x%1").arg(config.size))
                description: app.modeStrings[config.mode]
            }

            PagedView {
                id: scorePagedView
                width: parent.width
                height: Theme.itemSizeMedium
                wrapMode: PagedView.NoWrap
                model: [{label: qsTr("SCORE"), valueKey: 'classicScore', bestKey: 'bestClassicScore'},
                        {label: qsTr("TILE"), valueKey: 'bestTile', bestKey: 'bestBestTile'},
                        {label: qsTr("MOVES"), valueKey: 'moves', bestKey: 'bestMoves'},
                        {label: qsTr("IMPSCORE", "short for improved score"), valueKey: 'improvedScore', bestKey: 'bestImprovedScore'}]

                currentIndex: config.score
                onCurrentIndexChanged: config.score = currentIndex

                contentItem {
                    x: Theme.iconSizeMedium + Theme.paddingMedium
                    width: scorePagedView.width - contentItem.x*2
                }

                IconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    icon.source: 'image://theme/icon-m-left'
                    enabled: scorePagedView.currentIndex > 0
                    onClicked: scorePagedView.currentIndex--
                }

                IconButton {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    icon.source: 'image://theme/icon-m-right'
                    enabled: scorePagedView.currentIndex < scorePagedView.count - 1
                    onClicked: scorePagedView.currentIndex++
                }

                delegate: Row {
                    width: PagedView.contentWidth
                    height: PagedView.contentHeight
                    spacing: Theme.paddingMedium

                    ScoreItem {
                        width: (parent.width - parent.spacing) / 2
                        label: modelData.label
                        value: gameConfig[modelData.valueKey]
                    }
                    ScoreItem {
                        width: (parent.width - parent.spacing) / 2
                        label: qsTr("BEST")
                        value: gameConfig[modelData.bestKey]
                    }
                }
            }
        }
    }

    property alias game: gameLoader.item

    Loader {
        id: gameLoader
        width: parent.width
        height: width
        anchors.bottom: parent.bottom
        sourceComponent: config.tileFormat == 1 ? hexaGameComponent : gameComponent
    }

    Component {
        id: gameComponent
        Game {
            anchors {
                fill: parent
                margins: Theme.paddingLarge
            }
            background.radius: Theme.paddingSmall
            design: Component { SailTileDesign {} }
            loseDesign: Component { Lose {} }
            size: config.size
            mode: modes[config.mode][config.difficulty]
            gameConfig: app.gameConfig
        }
    }
    Component {
        id: hexaGameComponent
        HexaGame {
            anchors {
                fill: parent
                margins: Theme.paddingLarge
            }
            design: Component { SailHexaDesign {} }
            loseDesign: Component { Lose {} }
            size: config.size
            mode: modes[config.mode][config.difficulty]
            gameConfig: app.gameConfig
        }
    }
}
