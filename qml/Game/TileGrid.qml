import QtQuick 2.0

TileGridBase {
    property real itemSize: (width + padding) / size - padding
    property real itemRadius: itemSize * 0.05

    getSlot: repeater.itemAt
    slotCount: repeater.count

    Grid {
        anchors.fill: parent
        rows: size
        columns: size
        spacing: padding

        Repeater {
            id: repeater
            model: size * size
            onModelChanged: slotsChanged()
            delegate: Rectangle {
                width: itemSize
                height: itemSize
                color: itemColor
                radius: itemRadius
            }
        }
    }
}
