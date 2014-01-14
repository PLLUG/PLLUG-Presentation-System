/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QML Presentation System.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/


import QtQuick 2.0
import QtQuick.Window 2.0

Item {
    id: root

    property bool enableEdit: true
    property variant slides: []
    property int currentSlide
    property bool showNotes: false;

    property color titleColor: /*textColor*/ "blue"
    property color textColor: "black"
    property string fontFamily: "Helvetica"
    property string codeFontFamily: "Courier New"
    property QtObject transition : null
    onTransitionChanged:
    {
        console.log("\ntransition\n", transition, transition.currentSlide)
    }


    // Private API
    property bool _faded: false
    property int _userNum;

    states: [
        State {
            name: "show"
            PropertyChanges {
                target: root
                enableEdit: false
            }
        },
        State{
            name: "edit"
            PropertyChanges {
                target: root
                enableEdit: true
            }
        }

    ]

    Component.onCompleted: {
        var slideCount = 0;
        var slides = [];
        for (var i=0; i<root.children.length; ++i) {
            var r = root.children[i];
            if (r.isSlide) {

                slides.push(r);
            }

        }

        root.slides = slides;
        console.log(root.slides.length)
        root._userNum = 0;

        // Make first slide visible...
        if (root.slides.length > 0) {
            root.currentSlide = 0;
            root.slides[root.currentSlide].visible = true;
        }
    }

    function newSlide(slide,index,isOpening) {
        console.log("NEW!!!")
        var lSlides = root.slides
        if (slide.isSlide) {
            lSlides.splice(index, 0, slide);
            slides = lSlides
            root.slides = lSlides
        }
        if (!isOpening)
        {
            goToNextSlide()
        }
    }

    function removeSlide(index) {
        if ( index === currentSlide)
        {
            if (index+1 < root.slides.length)
                goToNextSlide()
            else if (index-1 >= 0)
                goToPreviousSlide()
        }
        var lSlides = root.slides
        var removedSlide = lSlides.splice(index, 1);
        removedSlide[0].destroy()
        slides = lSlides
        root.slides = lSlides

    }

    function switchSlides(from, to, forward) {
        from.visible = false
        to.visible = true
        return true
    }

    function goToNextSlide() {
        if (transition != null)
        {
            //            if (effect.running)
            //                return
            transition.goToNextSlide()
            root.focus = true
            return
        }
        root._userNum = 0
        if (_faded)
            return
        if (root.currentSlide + 1 < root.slides.length) {
            var from = slides[currentSlide]
            var to = slides[currentSlide + 1]
            if (switchSlides(from, to, true)) {
                currentSlide = currentSlide + 1;
                root.focus = true;
            }
        }
    }

    function goToPreviousSlide() {
        if (transition != null)
        {
            //            if (effect.running)
            //                return
            transition.goToPreviousSlide()
            root.focus = true
            return
        }
        root._userNum = 0
        if (root._faded)
            return
        if (root.currentSlide - 1 >= 0) {
            var from = slides[currentSlide]
            var to = slides[currentSlide - 1]
            if (switchSlides(from, to, false)) {
                currentSlide = currentSlide - 1;
                root.focus = true;
            }
        }
    }

    function goToUserSlide() {
        --_userNum;
        if (root._faded || _userNum >= root.slides.length)
            return
        if (_userNum < 0)
            goToNextSlide()
        else if (root.currentSlide != _userNum) {
            var from = slides[currentSlide]
            var to = slides[_userNum]
            if (switchSlides(from, to, _userNum > currentSlide)) {
                currentSlide = _userNum;
                root.focus = true;
            }
        }
    }

    function goToSlide(index) {
        if (index != currentSlide)
        {
            if (transition != null)
            {
                //                if (effect.running)
                //                    return
                transition.goToSlide(index)
                root.focus = true
                return
            }

            root._userNum = 0
            if (_faded)
                return
            if ((index < root.slides.length) && (index >=0)) {
                var from = slides[currentSlide]
                var to = slides[index]
                if (switchSlides(from, to, true)) {
                    currentSlide = index;
                    root.focus = true;
                }
            }
        }
    }


    focus: true

    Keys.onSpacePressed: goToNextSlide()
    Keys.onRightPressed: goToNextSlide()
    Keys.onDownPressed: goToNextSlide()
    Keys.onLeftPressed: goToPreviousSlide()
    Keys.onUpPressed: goToPreviousSlide()
    Keys.onEscapePressed: Qt.quit()
    Keys.onPressed: {
        if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9)
            _userNum = 10 * _userNum + (event.key - Qt.Key_0)
        else {
            //            if (event.key == Qt.Key_Return /*|| event.key == Qt.Key_Enter*/)
            //                goToUserSlide();
            /*else */if (event.key == Qt.Key_Backspace)
                goToPreviousSlide();
            else if (event.key == Qt.Key_C)
                root._faded = !root._faded;
            _userNum = 0;
        }
    }

    Rectangle {
        z: 1000
        color: "black"
        anchors.fill: parent
        opacity: root._faded ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 250 } }
    }


    Window {
        id: notesWindow;
        width: 400
        height: 300

        title: "QML Presentation: Notes"
        visible: root.showNotes

        Text {
            anchors.fill: parent
            anchors.margins: parent.height * 0.1;

            font.pixelSize: 16
            wrapMode: Text.WordWrap

            property string notes:  (root.slides[root.currentSlide].notes) ? root.slides[root.currentSlide].notes : "";
            text: notes == "" ? "Slide has no notes..." : notes;
            font.italic: notes == "";
        }
    }
}
