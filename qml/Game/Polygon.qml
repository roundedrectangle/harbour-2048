import QtQuick 2.0

Item {
    id: polygon;
    width: size;
    height: size;

    property int   size  : 400;
    property int   side  : internal.minSide;
    property color color : "green";

    readonly property alias border : borderProperty;

    function containsPosition (posX, posY) {
        for (var item, pos, idx = 0; (idx < repeatBack.count) && (item = repeatBack.itemAt (idx)) && (pos = mapToItem (item, posX, posY)); idx++) {
            if (pos ["x"] >= 0 && pos ["x"] <= item ["width"] && pos ["y"] >= 0 && pos ["y"] <= item ["height"]) {
                return true;
            }
        }
        return false;
    }

    QtObject {
        id: borderProperty;
        property int   width : 0;
        property color color : "black";
    }

    QtObject {
        id: internal;

        readonly property int    minSide        : 4;
        readonly property int    validCount     : side >= minSide ? side : minSide; // reset polygon square if wrong side is set
        readonly property real   maskAngle      : 360 / validCount;
        readonly property real   radAngle       : Math.PI / validCount;
        readonly property real   rectWidth      : size * Math.sin (radAngle);
        readonly property real   rectHeight     : size * Math.cos (radAngle) / 2;
        readonly property bool   highQuality    : false;
        readonly property string fragmentShader : "
            varying %1 vec2      qt_TexCoord0;
            uniform %1 float     qt_Opacity;
            uniform %1 sampler2D mask;
            void main (void) {
               gl_FragColor = texture2D (mask, qt_TexCoord0) * qt_Opacity;
            }".arg (highQuality ? "highp" : "lowp");

        function opacify (col) {
            return Qt.rgba (col.r, col.g, col.b, 1.0);
        }
    }
    Item {
        id: mask;
        visible: false;
        layer.enabled: true;
        anchors.fill: parent;

        Repeater {
            id: repeaterContent;
            model: internal.validCount;
            delegate: Rectangle {
                width: internal.rectWidth;
                height: internal.rectHeight;
                color: internal.opacify (polygon.color);
                transformOrigin: Item.Bottom;
                rotation: model.index * internal.maskAngle;
                antialiasing: rotation % 90;
                anchors.bottom: mask.verticalCenter;
                anchors.horizontalCenter: mask.horizontalCenter;
            }
        }

        Repeater {
            id: repeaterBorder;
            model: internal.validCount;
            delegate: Item {
                width: internal.rectWidth;
                height: internal.rectHeight;
                transformOrigin: Item.Bottom;
                rotation: model.index * internal.maskAngle;
                anchors.bottom: mask.verticalCenter;
                anchors.horizontalCenter: mask.horizontalCenter;

                Rectangle {
                    anchors {
                        top: parent.top;
                        left: parent.left;
                        right: parent.right;
                    }
                    height: polygon.border.width;
                    color: internal.opacify (polygon.border.color);
                    antialiasing: parent.rotation % 90;
                }
            }
        }
    }
    ShaderEffect {
        id: shader;
        fragmentShader: internal.fragmentShader;
        anchors.fill: parent;

        readonly property alias mask : mask;
    }
}
