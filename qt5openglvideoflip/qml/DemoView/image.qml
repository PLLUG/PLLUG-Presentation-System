import QtQuick 2.0

Rectangle
{
    id: item
    property string type : "image"
    property string source
    property string aspect
    property int fontSize
    property string fontFamily
    property string captionAlign
    property string textAlign

    property real widthCoeff
    property real heightCoeff

    property real xCoeff
    property real yCoeff

    onAspectChanged:
    {
        if ( item.aspect === "crop")
        {
            image.fillMode = Image.PreserveAspectCrop
        }
        else if ( item.aspect === "fit")
        {
            image.fillMode = Image.PreserveAspectFit
        }
        else if ( item.aspect === "stretch")
        {
            image.fillMode = Image.Stretch
        }
    }

    onCaptionAlignChanged:
    {
        if ( item.captionAlign === "top" )
        {
            titleRect.anchors.top = titleRect.parent.top
        }
        else if ( item.captionAlign === "bottom" )
        {
            titleRect.anchors.bottom = titleRect.parent.bottom
        }
    }

    onTextAlignChanged:
    {
        if ( item.textAlign === "center")
        {
            titleText.horizontalAlignment = Text.AlignHCenter
        }
        else  if ( item.textAlign === "left")
        {
            titleText.horizontalAlignment = Text.AlignLeft
        }
        else  if ( item.textAlign === "right")
        {
            titleText.horizontalAlignment = Text.AlignRight
        }
    }

    onParentChanged:
    {
        console.log("!!!!!", parent.width)
    }

    states:[
        State {
            name: "full"
            PropertyChanges {
                target: item
                width: item.parent.width
                height: item.parent.height
                x: 0
                y: 0
                z: 2

            }
        },
        State {
            name: "native"
            PropertyChanges {
                target: item
                width: widthCoeff*item.parent.width
                height: heightCoeff*item.parent.height
                x: xCoeff*item.parent.width
                y: yCoeff*item.parent.height
                z: 1

            }
        }
    ]
    state: "native"

    MouseArea
    {
        anchors.fill: parent
        hoverEnabled: true
        onEntered:
        {
            if ( item.state != "full")
            {
                titleRect.opacity = 0.7
            }
        }
        onExited:
        {
            titleRect.opacity = 0.0
        }
        onDoubleClicked:
        {
            if ( item.state === "native")
            {
                item.state = "full"
                titleRect.opacity = 0.0
            }
            else
            {
                item.state = "native"
            }
        }
    }



    Image
    {
        id: image
        anchors.fill : parent
        source: item.source

    }

    Rectangle
    {
        id: titleRect
        objectName: "Caption"
        width: parent.width
        height:  titleText.height + 5
        opacity: 0.0
        z: 1
        Text
        {
            id: titleText
//            width: parent.width
            objectName: "CaptionText"
            font.pixelSize: item.fontSize
            font.family: item.fontFamily
            verticalAlignment: Text.AlignVCenter
        }
        Behavior on opacity
        {
            PropertyAnimation{}
        }
    }
}

