import QtQuick 2.0

SequentialAnimation {
    id: anim;
    loops: 1;
    running: false;
    alwaysRunToEnd: true;
    onStopped: { anim.destroy (); }
    Component.onCompleted: {
        var tmp = anim.newParent.mapFromItem (tile, tile.x, tile.y);
        //console.debug ("tmp", JSON.stringify (tmp));
        tile.parent = anim.newParent;
        tile.x = tmp ['x'];
        tile.y = tmp ['y'];
        start ();
    }

    property Item tile      : null;
    property Item newParent : null;
    property Item mergeWith : null;

    ParallelAnimation {
        PropertyAnimation {
            target: tile;
            property: "x";
            to: 0;
            duration: 100;
        }
        PropertyAnimation {
            target: tile;
            property: "y";
            to: 0;
            duration: 100;
        }
    }
    ScriptAction {
        script: {
            if (anim.mergeWith) {
                console.debug ("merge", tile,"(", tile.value, ")" ,"with", anim.mergeWith);
                anim.mergeWith.upgrade ();
                tile.destroy ();
            }
        }
    }
    PropertyAnimation {
        target: anim.mergeWith;
        property: "scale";
        to: 1.25;
        duration: 150;
    }
    PropertyAnimation {
        target: anim.mergeWith;
        property: "scale";
        to: 1.0;
        duration: 150;
    }
}
