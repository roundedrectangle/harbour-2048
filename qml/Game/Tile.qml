import QtQuick 2.0

Item {
    id: tile;
    width: parent.width;
    height: parent.height;
    scale: 0.65;
    Component.onCompleted: {
        if (value > 1) {
            design.createObject(tile);
        } else if (value === 1) {
            joker.createObject(tile);
        } else if (value === -10) {
            brick.createObject(tile);
        } else if (value < -1 && value >= -4) {
            bomb.createObject(tile);
        }
        startAnimation.start();
    }

    PropertyAnimation {
        id: startAnimation;
        target: tile;
        property: "scale";
        to: 1.0;
        duration: 250;
    }

    property int value: 0;
    property int guru: 0;
    property bool adept: false;
    property int virus: 0;
    property Component design: Component { TileDesign { } }
    property Component animation: Component { TileAnimation {} }
    property Component joker: Component {Joker {}}
    property Component brick: Component {Brick {}}
    property Component bomb: Component {Bomb {}}

    signal hasMerged ();

    function upgrade () {
        value *= 2;
        hasMerged ();
    }
    function moveTo (newParent, mergeWith) { // call this and pass another Tile item as param
        if (newParent) {
            animation.createObject (newParent, {
                                        "tile"      : tile,
                                        "newParent" : newParent,
                                        "mergeWith" : (mergeWith || null)
                                    });
        }
    }
}
