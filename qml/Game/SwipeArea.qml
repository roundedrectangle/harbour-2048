import QtQuick 2.0

MouseArea {
    signal moveLeft;
    signal moveRight;
    signal moveUp;
    signal moveDown;

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
        var xMove = lastX - mouse.x
        var yMove = lastY - mouse.y
        var flag = false;
        if (Math.abs(xMove) > Math.abs(yMove)) {
            while (xMove < -threshold && pressed) {
                moveRight();
                xMove += threshold;
                flag = true;
                if (!repeat) {
                    pressed = false;
                }
            }
            while (xMove > threshold && pressed) {
                moveLeft();
                xMove -= threshold;
                flag = true;
                if (!repeat) {
                    pressed = false;
                }
            }
        }
        else {
            while (yMove < -threshold && pressed) {
                moveDown();
                yMove += threshold;
                flag = true;
                if (!repeat) {
                    pressed = false;
                }
            }
            while (yMove > threshold && pressed) {
                moveUp();
                yMove -= threshold;
                flag = true;
                if (!repeat) {
                    pressed = false;
                }
            }
        }
        if (flag) {
            lastX = mouse.x;
            lastY = mouse.y;
        }
    }
}
