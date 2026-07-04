import QtQuick

Rectangle {
    id: root

    property string title: ""
    signal back()

    width: parent ? parent.width : 0
    height: 68
    color: "#FFFFFF"

    // Liseré rose en bas
    Rectangle {
        width: parent.width
        height: 3
        color: "#F48FB1"
        anchors.bottom: parent.bottom
    }

    // Bouton retour — large, facile à toucher
    Rectangle {
        id: backBtn
        width: 100
        height: 52
        radius: 10
        anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
        color: backTap.pressed ? "#FCE4EC" : "transparent"

        Text {
            anchors.centerIn: parent
            text: "< Retour"
            font.pixelSize: 17
            font.weight: Font.Medium
            color: "#C2185B"
        }

        TapHandler {
            id: backTap
            onTapped: root.back()
        }
    }

    Text {
        anchors.centerIn: parent
        text: root.title
        font.pixelSize: 19
        font.weight: Font.SemiBold
        color: "#1C1C1E"
        elide: Text.ElideRight
        width: parent.width - 220
        horizontalAlignment: Text.AlignHCenter
    }
}
