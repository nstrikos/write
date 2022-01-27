import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.0
import Qt.labs.platform 1.1
import Qt.labs.settings 1.0

ApplicationWindow {
    id: application
    width: 640
    height: 640
    visible: true
    title: qsTr("Hello World")
    flags: Qt.FramelessWindowHint

    //    property var windowFlags

    //    Component.onCompleted: {
    //        windowFlags = application.flags
    //    }

    Settings {
        id: settings
        property alias x: application.x
        property alias y: application.y
        property alias width: application.width
        property alias height: application.height
        property string fontFamily: "Helvetica"
        property int pointSize: 24
        property bool bold: false
        property bool italic: false
        property bool underline: false
        property color color: "blue"
    }

    Component.onCompleted: {
        textArea.font.family = settings.fontFamily
        textArea.font.pointSize = settings.pointSize
        textArea.font.bold = settings.bold
        textArea.font.italic = settings.italic
        textArea.font.underline = settings.underline
        textArea.color = settings.color

        textArea.text = file.read()
    }

    Component.onDestruction: {
        settings.fontFamily = textArea.font.family
        settings.pointSize = textArea.font.pointSize
        settings.bold = textArea.font.bold
        settings.italic = textArea.font.italic
        settings.underline = textArea.font.underline
        settings.color = textArea.color
    }

    Flickable {
        id: flickable
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: parent

        TextArea.flickable: TextArea {
            id: textArea
            textFormat: Qt.PlainText
            wrapMode: TextArea.Wrap
            focus: true
            selectByMouse: true
            persistentSelection: true
            // Different styles have different padding and background
            // decorations, but since this editor is almost taking up the
            // entire window, we don't need them.
            leftPadding: 6
            rightPadding: 6
            topPadding: 0
            bottomPadding: 0
            font.family: "Helvetica"
            font.pointSize: 24
            font.bold: false
            font.italic: false
            font.underline: false

            color: "blue"

            background:
//                Image {
//                source: "qrc:/resources/background.jpg"
                Rectangle {
                gradient: Gradient {
                         GradientStop { position: 0.0; color: "brown" }
                         GradientStop { position: 1.0; color: "burlywood" }
                     }
            }

            Keys.onPressed: {
                if (event.key === Qt.Key_Left && (event.modifiers & Qt.ControlModifier) ) {
                    application.x -= 25;
                    event.accepted = true;
                } else if (event.key === Qt.Key_Right && (event.modifiers & Qt.ControlModifier) ) {
                    application.x += 25;
                    event.accepted = true;
                } else if (event.key === Qt.Key_Up && (event.modifiers & Qt.ControlModifier) ) {
                    application.y -= 25;
                    event.accepted = true;
                } else if (event.key === Qt.Key_Down && (event.modifiers & Qt.ControlModifier) ) {
                    application.y += 25;
                    event.accepted = true;
                }  else if (event.key === Qt.Key_Left && (event.modifiers & Qt.ShiftModifier) ) {
                    --application.width;
                    if (application.width < 50)
                        application.width = 50;
                    event.accepted = true;
                } else if (event.key === Qt.Key_Right && (event.modifiers & Qt.ShiftModifier) ) {
                    ++application.width;
                    if (application.width > 1000)
                        application.width = 1000;
                    event.accepted = true;
                } else if (event.key === Qt.Key_Up && (event.modifiers & Qt.ShiftModifier) ) {
                    --application.height;
                    if (application.height < 50)
                        application.height = 50;
                    event.accepted = true;
                } else if (event.key === Qt.Key_Down && (event.modifiers & Qt.ShiftModifier) ) {
                    ++application.height;
                    if (application.height > 1000)
                        application.height = 1000;
                    event.accepted = true;
                } else if (event.key === Qt.Key_Escape) {
                    application.close()
                }

            }

            onTextChanged: file.write(textArea.text)

            MouseArea {
                acceptedButtons: Qt.RightButton
                anchors.fill: parent
                onClicked: contextMenu.open()
            }

            //onLinkActivated: Qt.openUrlExternally(link)
        }

        ScrollBar.vertical: ScrollBar {}
    }

    Menu {
        id: contextMenu

        MenuItem {
            text: qsTr("Copy")
            enabled: textArea.selectedText
            onTriggered: textArea.copy()
        }
        MenuItem {
            text: qsTr("Cut")
            enabled: textArea.selectedText
            onTriggered: textArea.cut()
        }
        MenuItem {
            text: qsTr("Paste")
            enabled: textArea.canPaste
            onTriggered: textArea.paste()
        }

        MenuSeparator {}

        //        MenuItem {
        //            text: qsTr("Frame")
        //            onTriggered: {
        //                windowFlags = Qt.Window
        //                application.flags = windowFlags
        //                timer.start()
        //            }
        //        }

        //        MenuItem {
        //            text: qsTr("Show")
        //            onTriggered: {
        //                windowFlags = Qt.Window
        //                windowFlags |= Qt.FramelessWindowHint
        //                application.flags = windowFlags
        //            }
        //        }

        MenuItem {
            text: qsTr("Font...")
            onTriggered: fontDialog.open()
        }

        MenuItem {
            text: qsTr("Color...")
            onTriggered: colorDialog.open()
        }

        MenuItem {
            text: qsTr("Close")
            onTriggered: application.close()
        }
    }

//    SystemTrayIcon {
//        visible: true
//        icon.source: "qrc:/resources/icon.png"

//        menu: Menu {
//            MenuItem {
//                text: qsTr("Quit")
//                onTriggered: Qt.quit()
//            }
//        }

//        onActivated: {
//            if (!application.visible)
//                application.show()
//            else
//                application.hide()
//        }
//    }

    FontDialog {
        id: fontDialog
        onAccepted: {
//            document.fontFamily = font.family;
//            document.fontSize = font.pointSize;
            textArea.font.family = font.family;
            textArea.font.pointSize = font.pointSize;
            textArea.font.bold = font.bold;
            textArea.font.italic = font.italic;
            textArea.font.underline = font.underline;
        }
    }

    ColorDialog {
        id: colorDialog
        onAccepted: textArea.color = color
    }
}
