import QtQuick 2.3

FocusScope {
    id: contextMenuContainer

    property bool open: false

    Item {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: "#D1DBBD"
            focus: true
            Keys.onRightPressed: mainView.focus = true

            Text {
                anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; margins: 30 }
                color: "black"
                font.pixelSize: 14
                text: "Context Menu"
            }
        }
    }
}
