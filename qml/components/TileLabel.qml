import QtQuick 2.0
import Sailfish.Silica 1.0

Label {
    anchors {
        fill: parent
        margins: Theme.paddingSmall
    }
    color: Theme.primaryColor
    style: Text.Outline
    styleColor: Theme.secondaryColor
    antialiasing: true
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    fontSizeMode: Text.Fit
    minimumPixelSize: Theme.fontSizeTiny
    font {
        bold: true
        family: Theme.fontFamilyHeading
        pixelSize: Theme.fontSizeHuge
    }
}