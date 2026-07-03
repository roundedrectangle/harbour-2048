import QtQuick 2.0

MouseArea {
    property int threshold: 40
    property bool repeat

    signal moveLeft
    signal moveRight

    property bool isPressed
    property int lastX
    property int lastY

    onPressed: {
        isPressed = true
        lastX = mouse.x
        lastY = mouse.y
    }
    onReleased: isPressed = false

    function handleXMoved(xMove) {
        var moved = false
        while (xMove < -threshold && isPressed) {
            moveRight()
            xMove += threshold
            moved = true
            if (!repeat)
                isPressed = false
        }
        while (xMove > threshold && isPressed) {
            moveLeft()
            xMove -= threshold
            moved = true
            if (!repeat)
                isPressed = false
        }
        return moved
    }

    function updateLastPos() {
        lastX = mouseX
        lastY = mouseY
    }
}
