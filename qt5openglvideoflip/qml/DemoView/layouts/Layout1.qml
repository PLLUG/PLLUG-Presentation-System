import QtQuick 2.0
import "../"

Item
{
    id: templateItem
    anchors.fill: parent
//    Rectangle
//    {
//        id: titleRect
//        property string defaultTitleText: "Click to add text"
//        width: templateItem.parent.contentWidth
//        height: textEdit.height
//        z: parent.z + 1
//        anchors
//        {
//            horizontalCenter: parent.horizontalCenter
//            top: parent.top
//            topMargin: /*templateItem.parent.topTitleMargin*/20
//        }
//        color: "transparent"

//        border
//        {
//            color: "lightgrey"
//            width: (textEdit.focus || textEdit.text === titleRect.defaultTitleText ) ? 1 :0
//        }
////        Rectangle
////        {
////            id: highlightRect
////            anchors.fill: parent
////            color: "lightsteelblue"
////            visible: blockItem.selected
////            onVisibleChanged:
////            {
////                if (!visible)
////                    templateItem.parent.editSelectedItemProperties = false
////            }
////        }
//        MouseArea
//        {
//            anchors.fill: parent
//            onClicked: {
//                textEdit.text = (textEdit.text === titleRect.defaultTitleText ) ? "" : textEdit.text
//                textEdit.forceActiveFocus()
//            }
//        }

//        TextInput
//        {
//            id: textEdit
//            anchors
//            {
//                centerIn: parent
//            }
////            visible: (focus || templateItem.parent.title != "")
//            text: titleRect.defaultTitleText
//            font.pixelSize: templateItem.parent.titleFontSize
//            horizontalAlignment: Text.Center
//            onFocusChanged: {
//                if (!focus)
//                {
////                    titleRect.border.visible = focus
//                    templateItem.parent.title = (textEdit.text === titleRect.defaultTitleText) ? "" : textEdit.text
//                    textEdit.text = (textEdit.text === titleRect.defaultTitleText) ? titleRect.defaultTitleText : ""
//                }
//            }
//        }
//    }

    Rectangle
    {
        id: contentRect
        x: templateItem.parent.contentX
        y: templateItem.parent.contentY
        width: templateItem.parent.contentWidth
        height: templateItem.parent.contentHeight
        z: parent.z + 1
        Item
        {
            id: blockItem
            width: parent.width
            height: parent.height
            property bool selected
            Rectangle
            {
                id: highlightRect
                anchors.fill: parent
                color: "lightsteelblue"
                visible: blockItem.selected
                onVisibleChanged:
                {
                    if (!visible)
                        templateItem.parent.editSelectedItemProperties = false
                }
            }
            //            Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }

            Block{
                id: block
                width: parent.width - 10
                height:  parent.height - 10
                anchors.centerIn: parent
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        blockItem.selected = !blockItem.selected
                        templateItem.parent.selectedItem = blockItem
                    }
                    onPressAndHold:
                    {
                        blockItem.selected = true
                        templateItem.parent.selectedItem = blockItem
                        templateItem.parent.editSelectedItemProperties = !templateItem.parent.editSelectedItemProperties
                    }
                }


            }
            Component.onCompleted:
            {
                selected = false
            }
        }
    }
    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            templateItem.forceActiveFocus()
            blockItem.selected = false
        }
    }

    focus: true
    Keys.onEnterPressed:
    {
        console.log("@@@@@@")
    }
    Keys.onPressed:
    {
        if (event.key === 16777220) // enter
        {
            console.log("ENTER")
            blockItem.selected = false
            templateItem.forceActiveFocus()
        }
    }
    Component.onCompleted:
    {
        templateItem.parent.title = "Click to add title"
    }
}

