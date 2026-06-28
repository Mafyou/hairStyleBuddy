import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    property string title: ""
    signal back()

    width: parent ? parent.width : 0
    height: 64
    color: "#2C2C2C"

    // Back button
    Rectangle {
        id: backBtn
        width: 80
        height: 44
        radius: 8
        anchors {
            left: parent.left
            leftMargin: 12
            verticalCenter: parent.verticalCenter
        }
        color: backTap.pressed ? "#444444" : "transparent"

        Text {
            anchors.centerIn: parent
            text: "< Retour"
            font.pixelSize: 15
            color: "#FFFFFF"
        }

        TapHandler {
            id: backTap
            onTapped: root.back()
        }
    }

    // Page title
    Text {
        anchors.centerIn: parent
        text: root.title
        font.pixelSize: 18
        font.weight: 500
        color: "#FFFFFF"
        elide: Text.ElideRight
        width: parent.width - 200
        horizontalAlignment: Text.AlignHCenter
    }
}
