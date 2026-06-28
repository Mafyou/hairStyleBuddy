import QtQuick

Rectangle {
    id: root

    property string label:     ""
    property string sublabel:  ""
    property color  tileColor: "#FFFFFF"
    property color  textColor: "#1C1C1E"

    signal tapped()

    radius: 14
    color: tap.pressed ? Qt.darker(tileColor, 1.1) : tileColor

    Column {
        anchors.centerIn: parent
        spacing: 8

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            font.pixelSize: 20
            font.weight: 600
            color: root.textColor
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.sublabel
            font.pixelSize: 14
            color: Qt.rgba(root.textColor.r, root.textColor.g, root.textColor.b, 0.6)
            horizontalAlignment: Text.AlignHCenter
            visible: root.sublabel.length > 0
        }
    }

    TapHandler {
        id: tap
        onTapped: root.tapped()
    }
}
