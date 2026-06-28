import QtQuick
import QtQuick.Controls
import HairStyleBuddy

Page {
    id: page

    header: PageHeader {
        title: "Rendez-vous du jour"
        onBack: page.StackView.view.pop()
    }

    background: Rectangle { color: "#F5F3F0" }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8
        model: appController.appointments
        clip: true

        delegate: Rectangle {
            width: listView.width
            height: 80
            radius: 10
            color: arrived ? "#EBF7ED" : "#FFFFFF"

            Row {
                anchors {
                    fill: parent
                    leftMargin: 16
                    rightMargin: 16
                    topMargin: 0
                    bottomMargin: 0
                }
                spacing: 0

                // Time column
                Column {
                    width: 72
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        text: apptTime
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        color: "#1C1C1E"
                    }
                }

                // Separator
                Rectangle {
                    width: 1
                    height: 48
                    color: "#E5E5EA"
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Client info
                Column {
                    width: parent.width - 72 - 1 - 130 - 16
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: 14
                    spacing: 4

                    Text {
                        text: clientName
                        font.pixelSize: 17
                        font.weight: Font.SemiBold
                        color: "#1C1C1E"
                        elide: Text.ElideRight
                        width: parent.width - parent.leftPadding
                    }

                    Text {
                        text: service
                        font.pixelSize: 14
                        color: "#8E8E93"
                        elide: Text.ElideRight
                        width: parent.width - parent.leftPadding
                    }
                }

                // Arrived button
                Rectangle {
                    width: 110
                    height: 48
                    radius: 8
                    anchors.verticalCenter: parent.verticalCenter
                    color: arrived ? "#34C759" : "#E5E5EA"

                    Text {
                        anchors.centerIn: parent
                        text: arrived ? "Arrivée ✓" : "Arrivée ?"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: arrived ? "#FFFFFF" : "#3C3C43"
                    }

                    TapHandler {
                        enabled: !arrived
                        onTapped: appController.markArrived(appointmentId)
                    }
                }
            }
        }

        // Empty state
        Text {
            anchors.centerIn: parent
            text: "Aucun rendez-vous aujourd'hui"
            font.pixelSize: 18
            color: "#8E8E93"
            visible: listView.count === 0
        }
    }
}
