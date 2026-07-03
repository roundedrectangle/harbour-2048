import QtQuick 2.0

SwipeAreaBase {
    signal moveUpLeft
    signal moveUpRight
    signal moveDownLeft
    signal moveDownRight

    onPositionChanged: {
        if (!isPressed) return

        var xMove = lastX - mouse.x
        var yMove = lastY - mouse.y
        var rapport = xMove / yMove
        var moved = false

        if (Math.abs(rapport) > 1.73)
            moved = handleXMoved(xMove)
        else if (xMove < 0) {
            if (yMove < -threshold && isPressed) {
                moveDownRight();
                moved = true;
                if (!repeat) {
                    isPressed = false;
                }
            }
            if (yMove > threshold && isPressed) {
                moveUpRight();
                moved = true;
                if (!repeat) {
                    isPressed = false;
                }
            }
        } else {
            if (yMove < -threshold && isPressed) {
                moveDownLeft()
                moved = true
                if (!repeat)
                    isPressed = false
            }
            if (yMove > threshold && isPressed) {
                moveUpLeft()
                moved = true
                if (!repeat)
                    isPressed = false
            }
        }

        if (moved) updateLastPos()
    }
}
