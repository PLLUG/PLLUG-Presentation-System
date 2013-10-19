import QtQuick 2.0
import QtMultimedia 5.0

Rectangle
{
    id: item
    property string type : "video"
    property string source
    property string aspect
    property int fontSize
    property string fontFamily
    property string captionAlign
    property string textAlign

    property real widthCoeff : 1
    property real heightCoeff : 1

    property real xCoeff : 1
    property real yCoeff : 1
    property int titleY

    onAspectChanged:
    {
        if ( item.aspect === "crop")
        {
            videoOutput.fillMode = VideoOutput.PreserveAspectCrop
        }
        else if ( item.aspect === "fit")
        {
            videoOutput.fillMode = VideoOutput.PreserveAspectFit
        }
        else if ( item.aspect === "stretch")
        {
            videoOutput.fillMode = VideoOutput.Stretch
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
        widthCoeff = width/parent.width
        heightCoeff = height/parent.height
        xCoeff = x/parent.width
        yCoeff = y/parent.height
    }

    states:[
        State {
            name: "full"
            PropertyChanges {
                target: item
                width: (item.parent) ? item.parent.width : 0
                height: (item.parent) ? item.parent.height : 0
                x: 0
                y: 0
                z: 2

            }
        },
        State {
            name: "native"

            PropertyChanges {
                target: item
                width: (item.parent) ? widthCoeff*item.parent.width : 0
                height: (item.parent) ? heightCoeff*item.parent.height : 0
                x: (item.parent) ? xCoeff*item.parent.width : 0
                y: (item.parent) ? yCoeff*item.parent.height : 0
                z: 1

            }
        }
    ]
    state: "native"

    Rectangle
    {
        id: titleRect
        objectName: "Caption"
        width: parent.width
        height: titleText.height + 5
        opacity: 0.0
        z: 1
        Text
        {
            id: titleText
            objectName: "CaptionText"
            width: parent.width
            font.pixelSize: item.fontSize
            font.family: item.fontFamily
            verticalAlignment: Text.AlignVCenter
        }
        Behavior on opacity
        {
            PropertyAnimation{}
        }
    }

    Image
    {
        id: replayImage
        source: "qrc:/icons/replay.png"
        width: 50
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: false
        z : 1
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                mediaPlayer.play()
                mouseArea.prevPos = 0
            }
        }
    }

    Image
    {
        id: playImage
        source: "qrc:/icons/play.png"
        width: 50
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: true
        z : 1
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                playImage.visible = false
                mediaPlayer.play()
                mouseArea.prevPos = 0
            }
        }
    }



    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        property real prevPos: 0
        property real coeff: mediaPlayer.duration/videoOutput.width
        property real adds
        onClicked:
        {
            if (mediaPlayer.playbackState == MediaPlayer.PlayingState)
            {
                mediaPlayer.pause();
            }
            else
            {
                if (mediaPlayer.playbackState == MediaPlayer.PausedState )
                {
                    mediaPlayer.play();
                }
            }
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

        onPressAndHold:
        {
            mediaPlayer.seeking = true
            mediaPlayer.play()
        }

        onReleased:
        {
            if ( mediaPlayer.seeking)
            {
                mediaPlayer.seeking = false
            }

        }

        onMouseXChanged:
        {
            if ( mediaPlayer.seeking  && (mouseX >= 0))
            {
                adds = (mouseX - prevPos) *coeff
//                console.log(mouseX, mediaPlayer.position, adds)
                if ( (mediaPlayer.position + adds  < mediaPlayer.duration) && (mediaPlayer.position + adds  > 0))
                {
//                    console.log("seek")
                    mediaPlayer.seek(mediaPlayer.position + adds )
                }
                else
                {
                    if (mediaPlayer.position + adds  >= mediaPlayer.duration )
                        mediaPlayer.seek(mediaPlayer.duration)
                    if (mediaPlayer.position + adds  <= 0 )
                        mediaPlayer.seek(0)
                }

                prevPos = mouseX
            }
        }

    }



    MediaPlayer
    {
        id: mediaPlayer
        source: item.source
//        autoPlay:  true
        autoLoad: true
        volume: 0.0
//        playbackRate: 4.0

        property bool seeking : false
//        loops: Animation.Infinite

        onPositionChanged:
        {
//            if (( mediaPlayer.position < mediaPlayer.duration) && ( mediaPlayer.position > mediaPlayer.duration - 500 ) )
//            {
//                console.log("!!!!!!!!!!!!")
////                mediaPlayer.pause()
//            }
        }
        onStatusChanged:
        {
            if (mediaPlayer.status === MediaPlayer.Loaded)
            {
                mediaPlayer.volume = 0.0
                mediaPlayer.play()
                mediaPlayer.seek(1)
                mediaPlayer.pause()
                mediaPlayer.volume = 1.0
            }
            if (mediaPlayer.status === MediaPlayer.EndOfMedia)
            {
//                item.color = "black"
                replayImage.visible = true
                mediaPlayer.seeking = false
            }

        }
        onPlaying:
        {
            replayImage.visible = false
        }



    }

    VideoOutput
    {
        id: videoOutput
        source: mediaPlayer
        anchors.fill: parent
        onVisibleChanged:
        {
            mediaPlayer.pause()
        }
    }

}

