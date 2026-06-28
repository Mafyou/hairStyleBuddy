import QtQuick
import QtQuick.Controls
import HairStyleBuddy

Page {
    id: page

    header: PageHeader {
        title: "Prestations & Tarifs"
        onBack: page.StackView.view.pop()
    }

    background: Rectangle { color: "#F5F3F0" }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8
        model: appController.services
        clip: true

        delegate: Rectangle {
            width: listView.width
            height: 64
            radius: 10
            color: "#FFFFFF"

            Row {
                anchors {
                    fill: parent
                    leftMargin: 16
                    rightMargin: 16
                }
                spacing: 0

                // Service name
                Text {
                    width: parent.width - 100 - 90
                    anchors.verticalCenter: parent.verticalCenter
                    text: name
                    font.pixelSize: 17
                    font.weight: 500
                    color: "#1C1C1E"
                    elide: Text.ElideRight
                }

                // Duration
                Text {
                    width: 100
                    anchors.verticalCenter: parent.verticalCenter
                    text: duration + " min"
                    font.pixelSize: 15
                    color: "#8E8E93"
                    horizontalAlignment: Text.AlignRight
                }

                // Price
                Text {
                    width: 90
                    anchors.verticalCenter: parent.verticalCenter
                    text: price.toFixed(2) + " €"
                    font.pixelSize: 17
                    font.weight: 600
                    color: "#C4956A"
                    horizontalAlignment: Text.AlignRight
                }
            }

            Rectangle {
                width: parent.width - 32
                height: 1
                color: "#F0EFED"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                visible: index < listView.count - 1
            }
        }
    }
}
