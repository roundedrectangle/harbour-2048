import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    id: setting;
    width: parent.width
    height: menu.visible ? menu.height + label.height : label.height;

    property string text;
    property var options;

    Label {
        id: label;
        text: setting.text;
        color: Theme.primaryColor;
        antialiasing: true;
        fontSizeMode: Text.Fit;
        font.pixelSize: Theme.fontSizeHuge;
        anchors.left: parent.left
        anchors.margins: Theme.paddingLarge;

        ContextMenu {
            id: menu;
            Repeater {
                model: options;
                delegate: MenuItem {
                    text: modelData[0];
                    onClicked: {
                        var action = options[index][1];
                        action ();
                    }
                }
            }
        }
    }
    onPressed: menu.show(setting)
}
