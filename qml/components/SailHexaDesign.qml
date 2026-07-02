import QtQuick 2.0
import Sailfish.Silica 1.0
import '../Game'
import '../js/tilehelper.js' as TileHelper

Polygon {
    id: design
    size: parent.width

    rotation: 30
    side: 6
    color: Theme.rgba(Theme.highlightColor, TileHelper.getTileOpacity(parent.value))

    TileLabel {
        text: design.parent.value
        rotation: -30
    }
}
