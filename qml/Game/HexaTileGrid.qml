import QtQuick 2.0

TileGridBase {
    property real itemSize: Math.min(width, height) / repeater.count
    itemColor: Qt.rgba(0, 0, 0, 0.15)

    getSlot: function (i) {
        var row = repeater.itemAt(Math.floor(i / repeater.count))
        return row.repeater.itemAt(i % repeater.count)
    }
    slotCount: 3*size*(size - 1) + 1

    Column {
        anchors.centerIn: parent
        Repeater {
            id: repeater
            model: size * 2 - 1
            onModelChanged: slotsChanged()
            delegate: Row {
                id: row
                anchors.horizontalCenter: parent.horizontalCenter
                height: itemSize * 0.9

                property int columnIndex: model.index
                property alias repeater: rowRepeater

                Repeater {
                    id: rowRepeater
                    model: size + (row.columnIndex < size ? row.columnIndex : size * 2 - 2 - row.columnIndex)
                    delegate: Polygon {
                        width: itemSize
                        side: 6
                        canvas.rotation: 30
                        color: itemColor
                    }
                }
            }
        }
    }
}
