import QtQuick 2.0

Item {
    anchors {
        fill: parent
        margins: padding
    }

    property int size: game.size
    property real padding: game.padding

    property color itemColor: Qt.rgba(0, 0, 0, 0.05)

    property var getSlot // get a slot for putting a tile in it; for tetra, count = size*size
    property int slotCount
    signal slotsChanged
}
