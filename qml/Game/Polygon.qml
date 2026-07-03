import QtQuick 2.0

Item {
    id: polygon

    width: 400
    height: width

    property int side: 4
    property color color: 'green'

    property alias canvas: canvas

    property PolygonBorder border: PolygonBorder {
        onWidthChanged: canvas.requestPaint()
        onColorChanged: canvas.requestPaint()
    }

    onSideChanged: canvas.requestPaint()
    onColorChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        renderTarget: Canvas.Image

        readonly property int validSide: Math.max(side, 3)
        readonly property real angleStep: 2 * Math.PI / validSide
        readonly property real startAngle: (-Math.PI + angleStep) / 2

        onPaint: {
            var ctx = getContext('2d')
            ctx.clearRect(0, 0, width, height)

            var cx = width / 2,
                cy = height / 2
            var r = (Math.min(width, height) - border.width) / 2

            ctx.beginPath()
            for (var i = 0; i < validSide; ++i) {
                var a = startAngle + i * angleStep
                var x = cx + Math.cos(a) * r,
                    y = cy + Math.sin(a) * r

                if (i == 0) ctx.moveTo(x, y)
                else ctx.lineTo(x, y)
            }
            ctx.closePath()

            ctx.fillStyle = color
            ctx.fill()

            if (border.width > 0) {
                ctx.lineWidth = border.width
                ctx.strokeStyle = border.color
                ctx.stroke()
            }
        }

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }

    onSideChanged: canvas.requestPaint()
    onColorChanged: canvas.requestPaint()
}
