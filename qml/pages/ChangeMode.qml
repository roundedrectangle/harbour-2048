import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: page

    Column {
        spacing: 10
        anchors.fill: parent

        PageHeader {
            title: qsTr("Change Mode")
        }

        ComboBox {
            label: qsTr("Difficulty")
            currentIndex: app.difficulty
            onCurrentIndexChanged: {
                app.game.save()
                app.difficulty = currentIndex
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
            currentIndex: app.mode
            onCurrentIndexChanged: {
                app.game.save()
                app.mode = currentIndex
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
            currentIndex: app.tileFormat
            onCurrentIndexChanged: {
                app.game.save()
                app.tileFormat = currentIndex
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
            currentIndex: app.size - 2
            onCurrentIndexChanged: {
                app.game.save()
                app.size = currentIndex + 2
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
