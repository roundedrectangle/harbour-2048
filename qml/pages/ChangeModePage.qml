import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: page

    property Item game

    Column {
        spacing: 10
        anchors.fill: parent

        PageHeader {
            title: qsTr("Change Mode")
        }

        ComboBox {
            label: qsTr("Difficulty")
            currentIndex: config.difficulty
            onCurrentIndexChanged: {
                game.save()
                config.difficulty = currentIndex
            }
            menu: ContextMenu {
                Repeater {
                    model: app.difficultyStrings
                    MenuItem { text: modelData }
                }
            }
        }

        /*ComboBox {
            label: qsTr("Mode")
            currentIndex: config.mode
            onCurrentIndexChanged: {
                game.save()
                config.mode = currentIndex
            }
            menu: ContextMenu {
                Repeater {
                    model: app.modeStrings
                    MenuItem { text: modelData }
                }
            }
        }*/

        ComboBox {
            label: qsTr("Format")
            currentIndex: config.tileFormat
            onCurrentIndexChanged: {
                game.save()
                config.tileFormat = currentIndex
            }
            menu: ContextMenu {
                Repeater {
                    model: app.tileFormatStrings
                    MenuItem { text: modelData }
                }
            }
        }

        ComboBox {
            label: qsTr("Size")
            currentIndex: config.size - 2
            onCurrentIndexChanged: {
                game.save()
                config.size = currentIndex + 2
            }
            menu: ContextMenu {
                Repeater {
                    model: 5
                    MenuItem { text: index + 2 }
                }
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Reset")
            color: Theme.errorColor
            onClicked: {
                Remorse.popupAction(page, qsTr("Data reset", "past tense"), function () {
                    config.clear()
                    Qt.quit() // TODO: do not quit and clear all runtime data
                })
            }
        }
    }
}
