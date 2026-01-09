import QtQuick 2.0

Item {
    id:tileGrid

    property int size;
    property int padding;

    property real itemSize : Math.min(width, height) / (2 * size - 1)

    property var slots: [];


    Column {
        id: columnBack;
        anchors.centerIn: parent;
        Repeater {
            model : size * 2 - 1;
            delegate: Row {
                id: rowBack;
                anchors.horizontalCenter: parent.horizontalCenter;
                property int columnIndex: model.index;
                height: itemSize * 0.9
                Repeater {
                    model: size + (rowBack.columnIndex < size ? rowBack.columnIndex : size * 2 - 2 - rowBack.columnIndex)
                    delegate: Polygon {
                        size: itemSize;
                        side: 6;
                        rotation : 30;
                        color: "black";
                        opacity: 0.15;
                    }
                }
            }
        }
    }

    Column {
        id: columnSlot;
        anchors.centerIn: parent;
        Repeater {
            model : size * 2 - 1;
            delegate: Row {
                id: rowSlot;
                anchors.horizontalCenter: parent.horizontalCenter;
                property int columnIndex: model.index;
                height: itemSize * 0.9;
                Repeater {
                    model: size + (rowSlot.columnIndex < size ? rowSlot.columnIndex : size * 2 - 2 - rowSlot.columnIndex)
                    delegate: Rectangle {
                        id: tileSlot;
                        width: itemSize;
                        height: width;
                        color: "transparent"
                        Component.onCompleted: { slots [rowSlot.columnIndex * (2 * tileGrid.size - 1) + model.index] = tileSlot;}
                    }
                }
            }
        }
    }
}
