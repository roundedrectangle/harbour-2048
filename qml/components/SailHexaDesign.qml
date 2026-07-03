import QtQuick 2.0
import Sailfish.Silica 1.0
import '../Game'
import '../js/tilehelper.js' as TileHelper

Polygon {
    id: design
    width: parent.width

    side: 6
    canvas.rotation: 30
    color: Theme.rgba(Theme.highlightColor, TileHelper.getTileOpacity(parent.value))

    TileLabel {
        text: design.parent.value
    }
}
