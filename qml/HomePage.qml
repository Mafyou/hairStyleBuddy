import QtQuick
import QtQuick.Layouts
import HairStyleBuddy

Item {
    id: page

    signal goToCategory(string category)

    // ── Header ──────────────────────────────────────────────────────────────
    Rectangle {
        id: header
        width: parent.width
        height: 68
        color: "#FFFFFF"

        Text {
            anchors.centerIn: parent
            text: appController.salonName
            font.pixelSize: 24
            font.weight: Font.Bold
            color: "#1C1C1E"
        }

        // Bouton fermeture ✕
        Rectangle {
            id: closeBtn
            width: 48
            height: 48
            radius: 24
            anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
            color: closeTap.pressed ? "#FCE4EC" : "transparent"

            Text {
                anchors.centerIn: parent
                text: "✕"
                font.pixelSize: 22
                color: "#C2185B"
            }

            TapHandler {
                id: closeTap
                onTapped: Qt.quit()
            }
        }

        Rectangle {
            width: parent.width
            height: 3
            color: "#F48FB1"
            anchors.bottom: parent.bottom
        }
    }

    // ── Grille 2×2 — 4 catégories ───────────────────────────────────────────
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
        rowSpacing: 16
        columnSpacing: 16

        ActionTile {
            Layout.fillWidth: true
            Layout.fillHeight: true
            label: "Couleur"
            sublabel: "Colorimétrie & mélanges"
            tileColor: "#FCE4EC"
            textColor: "#C2185B"
            onTapped: page.goToCategory("Couleur")
        }

        ActionTile {
            Layout.fillWidth: true
            Layout.fillHeight: true
            label: "Soin"
            sublabel: "Davines — soins capillaires"
            tileColor: "#E8F5E9"
            textColor: "#2E7D32"
            onTapped: page.goToCategory("Soin")
        }

        ActionTile {
            Layout.fillWidth: true
            Layout.fillHeight: true
            label: "Coupe"
            sublabel: "Femme · Homme · Enfant"
            tileColor: "#E3F2FD"
            textColor: "#1565C0"
            onTapped: page.goToCategory("Coupe")
        }

        ActionTile {
            Layout.fillWidth: true
            Layout.fillHeight: true
            label: "Balayage"
            sublabel: "Techniques & durées"
            tileColor: "#FFF8E1"
            textColor: "#E65100"
            onTapped: page.goToCategory("Balayage")
        }
    }
}
