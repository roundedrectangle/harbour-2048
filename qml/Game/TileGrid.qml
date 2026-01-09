import QtQuick 2.0

Item {
    id:tileGrid

    property int size;
    property int padding;

    property real itemSize : (((width + padding) / size) - padding);

    property var slots: [];

    Grid {
        id: back;
        rows: size;
        columns: size;
        spacing: padding;
        anchors.fill: slotsGrid;

        Repeater {
            model: size * size;
            delegate: Rectangle {
                color: "black";
                radius: (width * 0.05);
                width: itemSize;
                height: itemSize;
                opacity: 0.15;
            }
        }
    }

    Grid {
        id: slotsGrid;
        rows: size;
        columns: size;
        spacing: padding;
        anchors.fill: parent;

        Repeater {
            model: size * size;
            delegate: Rectangle {
                id: tileSlot;
                color: "transparent";
                radius: (width * 0.05);
                width: itemSize;
                height: itemSize;
                Component.onCompleted: { slots [model.index] = tileSlot; }
            }
        }
    }
}
