import QtQuick
import QtQuick.Layouts
import HairStyleBuddy

Item {
    id: page

    signal goToAppointments()
    signal goToServices()
    signal goToNotes()

    // Header
    Rectangle {
        id: header
        width: parent.width
        height: 64
        color: "#2C2C2C"

        Text {
            anchors.centerIn: parent
            text: appController.salonName
            font.pixelSize: 22
            font.weight: 500
            color: "#FFFFFF"
        }
    }

    // Tile grid
    GridLayout {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 16
        }
        columns: 2
        rows: 2
        rowSpacing: 12
        columnSpacing: 12

        ActionTile {
            Layout.fillWidth: true
            Layout.fillHeight: true
            label: "Rendez-vous du jour"
            sublabel: "Planning & arrivées"
            tileColor: "#EAE0D5"
            onTapped: page.goToAppointments()
        }

        ActionTile {
            Layout.fillWidth: true
            Layout.fillHeight: true
            label: "Prestations"
            sublabel: "Tarifs & durées"
            tileColor: "#D5E8D8"
            onTapped: page.goToServices()
        }

        ActionTile {
            Layout.fillWidth: true
            Layout.fillHeight: true
            label: "Note rapide"
            sublabel: "Mémo pour le staff"
            tileColor: "#D5DDE8"
            onTapped: page.goToNotes()
        }

        ActionTile {
            Layout.fillWidth: true
            Layout.fillHeight: true
            label: "QR Code"
            sublabel: "Instagram & avis"
            tileColor: "#E8D5E2"
            onTapped: { /* À implémenter */ }
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: "#E5E5EA"
        anchors.top: header.bottom
    }
}
