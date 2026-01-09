import QtQuick 2.0

MouseArea {
    signal moveLeft;
    signal moveRight;
    signal moveUpLeft;
    signal moveUpRight;
    signal moveDownLeft;
    signal moveDownRight;

    property int threshold: 40;
    property bool repeat: false;
    property bool pressed: false;
    property int lastX;
    property int lastY;
    onPressed: {
        pressed = true;
        lastX = mouse.x;
        lastY = mouse.y;
    }
    onReleased: {
        pressed = false;
    }
    onMouseXChanged: {
        if (pressed) {
            xyChanged(mouse);
        }
    }
    onMouseYChanged: {
        if (pressed) {
            xyChanged(mouse);
        }
    }
    function xyChanged(mouse) {
        var xMove = lastX - mouse.x;
        var yMove = lastY - mouse.y;
        var rapport = xMove / yMove;
        var flag = false;
        if (Math.abs(rapport) > 1.73) {
            if (xMove < -threshold && pressed) {
                moveRight();
                flag = true;
                if (!repeat) {
                    pressed = false;
                }
            }
            if (xMove > threshold && pressed) {
                moveLeft();
                flag = true;
                if (!repeat) {
                    pressed = false;
                }
            }
        }
        else {
            if ( xMove < 0) {
                if (yMove < -threshold && pressed) {
                    moveDownRight();
                    flag = true;
                    if (!repeat) {
                        pressed = false;
                    }
                }
                if (yMove > threshold && pressed) {
                    moveUpRight();
                    flag = true;
                    if (!repeat) {
                        pressed = false;
                    }
                }
            }
            else {
                if (yMove < -threshold && pressed) {
                    moveDownLeft();
                    flag = true;
                    if (!repeat) {
                        pressed = false;
                    }
                }
                if (yMove > threshold && pressed) {
                    moveUpLeft();
                    flag = true;
                    if (!repeat) {
                        pressed = false;
                    }
                }
            }
        }
        if (flag) {
            lastX = mouse.x;
            lastY = mouse.y;
        }
    }
}
