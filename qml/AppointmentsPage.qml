import QtQuick
import QtQuick.Controls
import HairStyleBuddy

Page {
    id: page

    header: PageHeader {
        title: "Rendez-vous du jour"
        onBack: page.StackView.view.pop()
    }

    background: Rectangle { color: "#FAFAFA" }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10
        model: appController.appointments
        clip: true

        delegate: Rectangle {
            width: listView.width
            height: 88
            radius: 12
            color: arrived ? "#E8F5E9" : "#FFFFFF"

            // Bordure gauche colorée
            Rectangle {
                width: 5
                height: parent.height - 16
                radius: 3
                color: arrived ? "#81C784" : "#90CAF9"
                anchors { left: parent.left; leftMargin: 0; verticalCenter: parent.verticalCenter }
            }

            Row {
                anchors {
                    fill: parent
                    leftMargin: 16
                    rightMargin: 12
                }
                spacing: 0

                // Heure — grande et lisible
                Text {
                    width: 78
                    anchors.verticalCenter: parent.verticalCenter
                    text: apptTime
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: arrived ? "#2E7D32" : "#1565C0"
                }

                // Séparateur
                Rectangle {
                    width: 1
                    height: 52
                    color: "#E0E0E0"
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Infos cliente
                Column {
                    width: parent.width - 78 - 1 - 130 - 12
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: 14
                    spacing: 6

                    Text {
                        text: clientName
                        font.pixelSize: 18
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

                // Bouton Arrivée — grand et tactile
                Rectangle {
                    width: 118
                    height: 60
                    radius: 10
                    anchors.verticalCenter: parent.verticalCenter
                    color: arrived ? "#C8E6C9" : "#E3F2FD"

                    Text {
                        anchors.centerIn: parent
                        text: arrived ? "Arrivee !" : "Arrivee ?"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        color: arrived ? "#2E7D32" : "#1565C0"
                    }

                    TapHandler {
                        enabled: !arrived
                        onTapped: appController.markArrived(appointmentId)
                    }
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: "Aucun rendez-vous aujourd'hui"
            font.pixelSize: 18
            color: "#8E8E93"
            visible: listView.count === 0
        }
    }
}
