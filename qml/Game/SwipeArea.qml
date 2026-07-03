import QtQuick 2.0

SwipeAreaBase {
    signal moveUp
    signal moveDown

    onPositionChanged: {
        if (!isPressed) return

        var xMove = lastX - mouse.x
        var yMove = lastY - mouse.y
        var moved = false

        if (Math.abs(xMove) > Math.abs(yMove))
            moved = handleXMoved(xMove)
        else {
            while (yMove < -threshold && isPressed) {
                moveDown()
                yMove += threshold
                moved = true
                if (!repeat)
                    isPressed = false
            }
            while (yMove > threshold && isPressed) {
                moveUp()
                yMove -= threshold
                moved = true
                if (!repeat)
                    isPressed = false
            }
        }

        if (moved) updateLastPos()
    }
}
