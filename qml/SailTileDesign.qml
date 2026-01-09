import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: design
    anchors.fill: parent;

    Rectangle {
        color: Theme.highlightColor;
        radius: design.parent.parent.radius;
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
        anchors.fill: parent;
    }
    Label {
        text: design.parent.value;
        color: Theme.primaryColor;
        style: Text.Outline;
        styleColor: "black";
        antialiasing: true;
        verticalAlignment: Text.AlignVCenter;
        horizontalAlignment: Text.AlignHCenter;
        fontSizeMode: Text.Fit;
        minimumPixelSize: Theme.fontSizeTiny;
        font {
            bold: true;
            family: Theme.fontFamilyHeading;
            pixelSize: Theme.fontSizeHuge;
        }
        anchors {
            fill: parent;
            margins: Theme.paddingSmall;
        }
    }
}
