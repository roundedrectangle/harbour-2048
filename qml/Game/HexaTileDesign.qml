import QtQuick 2.0

Item {
    id: design
    anchors.fill: parent;

    Polygon {
        id: polygon;
        size: design.width;
        side: 6;
        rotation : 30;
        color: "blue";
        opacity: {
            switch (design.parent.value) {
            case 0:    return 0.00;
            case 2:    return 0.15;
            case 4:    return 0.20;
            case 8:    return 0.25;
            case 16:   return 0.30;
            case 32:   return 0.35;
            case 64:   return 0.40;
            case 128:  return 0.45;
            case 256:  return 0.50;
            case 512:  return 0.55;
            case 1024: return 0.65;
            case 2048: return 0.70;
            case 4096: return 0.85;
            case 8192: return 0.90;
            default:   return 1.00;
            }
        }
    }
    Text {
        text: design.parent.value;
        color: "white";
        antialiasing: true;
        verticalAlignment: Text.AlignVCenter;
        horizontalAlignment: Text.AlignHCenter;
        font {
            bold: true;
            pixelSize: 25;
        }
        anchors {
            fill: parent;
            margins: 10;
        }
    }
}
