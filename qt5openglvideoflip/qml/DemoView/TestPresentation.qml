import QtQuick 2.0
import QtQuick.Controls 1.0
//import Qt.labs.presentation 1.0
import "presentation"
import "layouts"
import "panels"


Presentation {
    id: presentation
    width: screenPixelWidth
    height: screenPixelHeight
    textColor: "black"
    //    effect: flipEffect
    onCurrentSlideChanged:
    {
        slidesListPanel.selectSlide(currentSlide)
    }


    function addNewSlide()
    {
        var component = Qt.createComponent("presentation/Slide.qml");
        var newSlide = component.createObject(presentation, {"layout": "Empty"});
        if (newSlide === null)
        {
            console.log("Error creating object");
        }
        presentation.newSlide(newSlide,presentation.currentSlide+1)
        layoutsListPanel.state = "opened"

    }

    function removeSlideAt(index)
    {
        presentation.removeSlide(index)
    }

    function setLayout(source)
    {
        if (source != "")
        {
            for (var i=0; i<presentation.slides[currentSlide].children.length; ++i)
            {
                var layoutToRemove;
                if (presentation.slides[currentSlide].children[i].objectName === "layout")
                {
                    layoutToRemove = presentation.slides[currentSlide].children[i]
                    if (layoutToRemove)
                    {
                        layoutToRemove.destroy();
                        break;
                    }
                }
            }
            if (source != "Empty")
            {
                var component = Qt.createComponent(source);
                component.createObject(presentation.slides[currentSlide], {"objectName": "layout"});
                presentation.slides[currentSlide].layout = source
            }
        }
    }

    function addBackground(source)
    {
        if (source != "")
        {
            for(var i=0; i<presentation.slides.length; ++i)
            {
                var background = Qt.createComponent(source);
                background.createObject(presentation.slides[i], {"objectName": source, z: "-1"});
            }
        }
    }

    function removeBackground(source)
    {
        if (source != "")
        {
            for (var i=0; i<presentation.slides.length; ++i)
            {
                for (var j=0; j<presentation.slides[i].children.length; ++j)
                {
                    var effectToRemove;
                    if (presentation.slides[i].children[j].objectName === source)
                    {
                        effectToRemove = presentation.slides[i].children[j]
                        if (effectToRemove)
                        {
                            effectToRemove.destroy();
                            break;
                        }
                    }
                }
            }
        }
    }


    function addTransition(source)
    {
        if (source != "")
        {
            var transitionComponent = Qt.createComponent(source);
            var effect = transitionComponent.createObject(presentation, {"objectName": "transition",
                                                              "currentSlide": presentation.currentSlide,
                                                              "screenWidth": presentation.width,
                                                              "screenHeight" : presentation.height });
            presentation.effect = effect
        }
    }

    function removeTransition()
    {
        for (var i=0; i<presentation.children.length; ++i)
        {
            var transitionToRemove;
            if (presentation.children[i].objectName === "transition")
            {
                transitionToRemove = presentation.children[i]
                if (transitionToRemove)
                {
                    transitionToRemove.destroy();
                    presentation.effect = null;
                    break;
                }
            }
        }

    }
    //    Loader {
    //        id : backgroundLoader
    //        anchors.fill: parent
    //    }




    //    Slide{
    //        Template1{

    //        }
    //    }

    EmptySlide
    {
        title: "first slide"
        visible: false
        content: [
            "Gradient Rectangle",
            "Swirls using ShaderEffect",
            " Movement using a vertexShader",
            " Colorized using a gradient rect converted to a texture",
            " Controlled using QML properties and animations",
            "Snow"
        ]

    }

    Slide {
        centeredText: "Animated Background"
        fontScale: 2
        visible: false
        title: "anim slide"



    }

    Slide {
        title: "Composition"
        visible: false
        content: [
            "Gradient Rectangle",
            "Swirls using ShaderEffect",
            " Movement using a vertexShader",
            " Colorized using a gradient rect converted to a texture",
            " Controlled using QML properties and animations",
            "Snow",
            " Using 'QtQuick.Particles 2.0'",
            " Emitter",
            " ImageParticle"
        ]

    }
    Slide {
        title: "Slide"
        visible: false
        content: [
            "  Text1",
            "  Text2",
            "  Text3",

        ]
        fontScale: 1
        Clock{}
    }

    Slide
    {
        title: "code slide"
        visible: false
        code: " RECT* rect = (RECT*) message->lParam;
        int fWidth = frameGeometry().width() - width();
        int fHeight = frameGeometry().height() - height();
        int nWidth = rect->right-rect->left - fWidth;
        int nHeight = rect->bottom-rect->top - fHeight;

        switch(message->wParam) {
        case WMSZ_BOTTOM:
        case WMSZ_TOP:
            rect->right = rect->left+(qreal)nHeight*mAspectRatio + fWidth;
            break;"
    }

    Slide {
        title: "Last Slide"
        visible: false
        centeredText: "Place some text here"
        fontScale: 2
        Clock{}
    }

    //    PageFlipShaderEffect
    //    {
    //        id: flipEffect
    //        currentSlide: presentation.currentSlide
    //        onCurrentSlideChanged:
    //        {
    //            presentation.currentSlide = currentSlide
    //        }
    //        screenWidth: presentation.width
    //        screenHeight: presentation.height
    //    }
    LayoutsListPanel
    {
        id: layoutsListPanel

    }
    OptionsPanel{
        id: optionsPanel
    }

    //    ItemPropertiesPanel
    //    {
    //        id: itemPropertiesPanel
    //        currentItem: presentation.slides[currentSlide].selectedItem
    //        state: (presentation.slides[currentSlide].editSelectedItemProperties) ? "opened" : "closed"
    //        z: 3
    //        //        MouseArea
    //        //        {
    //        //            anchors.fill: parent
    //        //            onDoubleClicked:
    //        //            {
    //        //                presentation.slides[currentSlide].editSelectedItemProperties = false
    //        //            }
    //        //        }

    //    }


    SlidesListPanel
    {
        id: slidesListPanel
        slides: presentation.slides
        z: 3
        onSlideSelected:
        {
            presentation.goToSlide(index)
        }
    }
    //    MouseArea
    //    {
    //        anchors.fill: parent
    //        onClicked: {
    //            slidesListPanel.state = "closed"
    //            layoutsListPanel.state = "closed"
    //            optionsPanel.state = "Closed"
    //        }

    //    }

}
