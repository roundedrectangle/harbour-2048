import QtQuick 2.0
import Sailfish.Silica 1.0
import '../js/tilehelper.js' as TileHelper

Rectangle {
    id: design
    anchors.fill: parent

    color: Theme.rgba(Theme.highlightColor, TileHelper.getTileOpacity(parent.value))
    radius: Theme.paddingSmall

    TileLabel {
        text: design.parent.value
    }
}
